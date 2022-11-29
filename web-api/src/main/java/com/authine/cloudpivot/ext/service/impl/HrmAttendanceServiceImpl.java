package com.authine.cloudpivot.ext.service.impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.alibaba.fastjson.JSONObject;
import com.authine.cloudpivot.engine.api.model.organization.UserModel;
import com.authine.cloudpivot.engine.api.model.runtime.BizObjectModel;
import com.authine.cloudpivot.engine.api.model.system.RelatedCorpSettingModel;
import com.authine.cloudpivot.engine.enums.ErrCode;
import com.authine.cloudpivot.engine.enums.type.UserWorkStatus;
import com.authine.cloudpivot.ext.model.AttendanceDetailsModel;
import com.authine.cloudpivot.ext.service.api.IHrmAttendanceApi;
import com.authine.cloudpivot.ext.service.dingtalk.api.IDingtalkAttendanceApi;
import com.authine.cloudpivot.ext.service.dingtalk.api.IDingtalkCommonApi;
import com.authine.cloudpivot.ext.util.ResponseResultUtils;
import com.authine.cloudpivot.web.api.service.EngineService;
import com.authine.cloudpivot.web.api.view.ResponseResult;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;

import lombok.extern.slf4j.Slf4j;

/**
 * 人事考勤模块，获取考勤打卡数据
 * 
 * @author quyw
 * @date 2022/11/25
 */
@Service
@Slf4j
public class HrmAttendanceServiceImpl extends EngineService implements IHrmAttendanceApi {

    @Autowired
    private IDingtalkCommonApi dingtalkCommonApi;
    @Autowired
    private IDingtalkAttendanceApi dingtalkAttendanceApi;

    @Autowired
    private EngineService engineService;

    @Override
    public ResponseResult<Map<String, Object>> getAttendanceList(Map<String, Object> params) {
        log.info("[人事系统-考勤]：获取考勤打卡结果开始，params={}", params);

        try {
            String corpId = (String)params.get("corpId");
            // 按天查询考勤，接口传参格式“yyyy-MM-dd”
            String startTime = (String)params.get("startTime");
            if (StringUtils.isBlank(startTime)) {
                // 当前系统时间，按天查询
                startTime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
                startTime = startTime.split(" ")[0] + " 00:00:00";
            } else {
                startTime = startTime + " 00:00:00";
            }

            // 获取aksk
            RelatedCorpSettingModel corpSetting =
                engineService.getSystemManagementFacade().getRelatedCorpSettingByCorpId(corpId);
            String appKey = corpSetting.getAppkey();
            String appSecret = corpSetting.getAppSecret();

            // 获取钉钉接口调用accessToken
            String accessToken = dingtalkCommonApi.getAccessToken(appKey, appSecret);
            if (StringUtils.isBlank(accessToken)) {
                throw new Exception("获取钉钉企业内部应用accessToken失败");
            }

            // 获取组织架构userId，全员拉取考勤数据
            List<UserModel> userModelList = engineService.getOrganizationFacade().getUsersByCorpId(corpId);
            // List<String> userIds = userlList.stream().map(m -> m.getUserId()).collect(Collectors.toList());
            List<String> userIds = Lists.newArrayList();
            // orgUser,key=userId,value=id
            Map<String, String[]> userMap = Maps.newHashMap();
            for (int k = 0; k < userModelList.size(); k++) {
                UserModel m1 = userModelList.get(k);
                // 过滤掉离职员工，但不包括当天离职的
                UserWorkStatus status = m1.getUserWorkStatus();
                if (!UserWorkStatus.WAITING_TRANSFER.equals(status)) {
                    String uid1 = m1.getUserId();
                    userIds.add(uid1);
                    userMap.put(uid1, new String[] {m1.getId(), m1.getDepartmentId()});
                }
            }
            // 钉钉接口每次最多传递50个userid
            List<List<String>> userIdList = Lists.newArrayList();
            int border = 50;
            if (userIds.size() < border) {
                userIdList.add(userIds);
            } else {
                List<String> t = Lists.newArrayList();
                for (int i = 0; i < userIds.size(); i++) {
                    t.add(userIds.get(i));
                    if (t.size() < border) {
                        if (i == userIds.size() - 1) {
                            userIdList.add(t);
                            t = Lists.newArrayList();
                        }
                    } else {
                        userIdList.add(t);
                        t = Lists.newArrayList();
                    }
                }
            }

            // 开始封装调用钉钉接口获取考勤明细数据
            List<Object> recordList = Lists.newArrayList();
            Map<String, Object> paramsMap = Maps.newHashMap();
            paramsMap.put("accessToken", accessToken);
            paramsMap.put("workDateFrom", startTime);
            paramsMap.put("workDateTo", startTime);
            for (int i = 0; i < userIdList.size(); i++) {
                long offset = 0l;
                long limit = 50l;
                paramsMap.put("UserIdList", userIdList.get(i));
                paramsMap.put("offset", offset);
                paramsMap.put("limit", limit);
                // 继续查询
                recordList = getAttendanceRecord(recordList, paramsMap);
            }
            // 开始写入到业务模块对应表
            if (CollectionUtils.isEmpty(recordList)) {
                throw new Exception("未查询到考勤数据");
            }
            insertFormData(recordList, userMap, startTime);
        } catch (Exception e) {
            log.error("[人事系统-考勤]：获取考勤打卡结果失败：{}", e.toString());
            e.printStackTrace();
            return ResponseResultUtils.getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), e.getMessage());
        }

        log.info("[人事系统-考勤]：获取考勤打卡结果结束");
        return ResponseResultUtils.getOkResponseResult(null, "操作成功");
    }

    /**
     * 分页场景下，递归取数据
     */
    private List<Object> getAttendanceRecord(List<Object> recordResult, Map<String, Object> params) throws Exception {
        long offset = (long)params.get("offset");
        long limit = (long)params.get("limit");
        JSONObject response = dingtalkAttendanceApi.getAttendanceList(params);
        int errcode = response.getIntValue("errcode");
        if (0 != errcode) {
            throw new Exception(response.getString("errmsg"));
        }
        List<Object> r = response.getJSONArray("recordresult");
        recordResult.addAll(r);
        boolean hasMore = response.getBoolean("hasMore");
        if (hasMore) {
            offset = offset + limit;
            params.put("offset", offset);
            getAttendanceRecord(recordResult, params);
        }
        return recordResult;
    }

    /**
     * 数据写到考勤明细表
     */
    private void insertFormData(List<Object> recordResult, Map<String, String[]> userMap, String startTime) {
        Map<String, String> resultMap = Maps.newHashMap();
        List<Map<String, Object>> insertData = Lists.newArrayList();
        for (String duid : userMap.keySet()) {
            Map<String, Object> paramsMap = Maps.newHashMap();

            // 系统组织用户，人员单选，部门单选
            String orgUserId = userMap.get(duid)[0];
            String orgUserDeptId = userMap.get(duid)[1];
            paramsMap.put(AttendanceDetailsModel.org_userName, orgUserId);
            paramsMap.put(AttendanceDetailsModel.org_userDept, orgUserDeptId);
            // 钉钉用户Id
            paramsMap.put(AttendanceDetailsModel.dingtalk_userId, duid);
            // 考勤时间
            paramsMap.put(AttendanceDetailsModel.attendanceTime, startTime);
            paramsMap.put(AttendanceDetailsModel.countWeiDaKa, 0);
            paramsMap.put(AttendanceDetailsModel.countChiDao, 0);
            paramsMap.put(AttendanceDetailsModel.countZaoTui, 0);

            // 上班下班打卡为两条数据，需要合并
            for (int j = 0; j < recordResult.size(); j++) {
                JSONObject json = (JSONObject)recordResult.get(j);
                String duid1 = json.getString("userId");
                if (duid.equals(duid1)) {
                    handleInsertData(paramsMap, json);
                }
            }
            insertData.add(paramsMap);
        }
        /* 遍历待写入表单数据，匹配休假，外出，出差
         * 无打卡数据的用户不匹配休假，外出，出差
         */
        for (int i = 0; i < insertData.size(); i++) {
            Map<String, Object> dataMap = insertData.get(i);
            String orgUserId = (String)dataMap.get(AttendanceDetailsModel.org_userName);
            // 未查询到考勤数据的用户统一设置为未打卡
            Integer countQk = (Integer)dataMap.get(AttendanceDetailsModel.countWeiDaKa);
            String timeResult = (String)dataMap.get(AttendanceDetailsModel.timeResult);
            if (StringUtils.isBlank(timeResult)) {
                dataMap.put(AttendanceDetailsModel.timeResult, "未打卡");
                countQk = countQk + 1;
            }
            String timeResult1 = (String)dataMap.get(AttendanceDetailsModel.timeResult1);
            if (StringUtils.isBlank(timeResult1)) {
                dataMap.put(AttendanceDetailsModel.timeResult1, "未打卡");
                countQk = countQk + 1;
            }
            dataMap.put(AttendanceDetailsModel.countWeiDaKa, countQk);

            BizObjectModel model = new BizObjectModel(AttendanceDetailsModel.SCHEMA_CODE, dataMap, false);
            String result = engineService.getBizObjectFacade().saveBizObject(orgUserId, model, true);
            resultMap.put(result, null);
        }
    }

    private void handleInsertData(Map<String, Object> data, JSONObject json) {
        String checkType = json.getString("checkType");
        // 上班OnDuty，下班OffDuty
        if ("OnDuty".equals(checkType)) {
            // 打卡时间
            data.put(AttendanceDetailsModel.userCheckTime, new Date(json.getLongValue("userCheckTime")));
            // 打卡位置
            String locationResult = json.getString("locationResult");
            if ("Normal".equals(locationResult)) {
                data.put(AttendanceDetailsModel.locationResult, "范围内");
            } else if ("Outside".equals(locationResult)) {
                data.put(AttendanceDetailsModel.locationResult, "范围外");
            } else if ("NotSigned".equals(locationResult)) {
                data.put(AttendanceDetailsModel.locationResult, "未打卡");
                data.put(AttendanceDetailsModel.userCheckTime, null);
            }
            // 打卡结果
            String timeResult = json.getString("timeResult");
            if ("Normal".equals(timeResult)) {
                data.put(AttendanceDetailsModel.timeResult, "正常");
            } else if ("Early".equals(timeResult)) {
                data.put(AttendanceDetailsModel.timeResult, "早退");
            } else if ("Late".equals(timeResult) || "SeriousLate".equals(timeResult)
                || "Absenteeism".equals(timeResult)) {
                // 迟到，严重迟到，旷工迟到都算迟到
                data.put(AttendanceDetailsModel.timeResult, "迟到");
                // 迟到时长
                Long sum = json.getLongValue("userCheckTime") - json.getLongValue("baseCheckTime");
                data.put(AttendanceDetailsModel.lateTimes, sum / 1000 / 60);
                // 迟到次数
                Integer s = (Integer)data.get(AttendanceDetailsModel.countChiDao) + 1;
                data.put(AttendanceDetailsModel.countChiDao, s);
            } else if ("NotSigned".equals(timeResult)) {
                data.put(AttendanceDetailsModel.timeResult, "未打卡");
                data.put(AttendanceDetailsModel.userCheckTime, null);
                // 未打卡次数
                Integer s = (Integer)data.get(AttendanceDetailsModel.countWeiDaKa) + 1;
                data.put(AttendanceDetailsModel.countWeiDaKa, s);
            } else {
                // 其他情况记为未打卡
                data.put(AttendanceDetailsModel.timeResult, "未打卡");
                data.put(AttendanceDetailsModel.userCheckTime, null);
                Integer s = (Integer)data.get(AttendanceDetailsModel.countWeiDaKa) + 1;
                data.put(AttendanceDetailsModel.countWeiDaKa, s);
            }
        } else if ("OffDuty".equals(checkType)) {
            // 打卡时间
            data.put(AttendanceDetailsModel.userCheckTime1, new Date(json.getLongValue("userCheckTime")));
            // 打卡位置
            String locationResult = json.getString("locationResult");
            if ("Normal".equals(locationResult)) {
                data.put(AttendanceDetailsModel.locationResult1, "范围内");
            } else if ("Outside".equals(locationResult)) {
                data.put(AttendanceDetailsModel.locationResult1, "范围外");
            } else if ("NotSigned".equals(locationResult)) {
                data.put(AttendanceDetailsModel.locationResult1, "未打卡");
            }
            // 打卡结果
            String timeResult = json.getString("timeResult");
            if ("Normal".equals(timeResult)) {
                data.put(AttendanceDetailsModel.timeResult1, "正常");
            } else if ("Early".equals(timeResult)) {
                data.put(AttendanceDetailsModel.timeResult1, "早退");
                // 早退时长
                Long sum = json.getLongValue("baseCheckTime") - json.getLongValue("userCheckTime");
                data.put(AttendanceDetailsModel.earlyTimes, sum / 1000 / 60);
                // 早退次数
                Integer s = (Integer)data.get(AttendanceDetailsModel.countZaoTui) + 1;
                data.put(AttendanceDetailsModel.countZaoTui, s);
            } else if ("Late".equals(timeResult) || "SeriousLate".equals(timeResult)
                || "Absenteeism".equals(timeResult)) {
                // 迟到，严重迟到，旷工迟到都算迟到
                data.put(AttendanceDetailsModel.timeResult1, "迟到");
            } else if ("NotSigned".equals(timeResult)) {
                data.put(AttendanceDetailsModel.timeResult1, "未打卡");
                data.put(AttendanceDetailsModel.userCheckTime1, null);
                // 未打卡次数
                Integer s = (Integer)data.get(AttendanceDetailsModel.countWeiDaKa) + 1;
                data.put(AttendanceDetailsModel.countWeiDaKa, s);
            } else {
                // 其他情况记为未打卡
                data.put(AttendanceDetailsModel.timeResult1, "未打卡");
                data.put(AttendanceDetailsModel.userCheckTime, null);
                Integer s = (Integer)data.get(AttendanceDetailsModel.countWeiDaKa) + 1;
                data.put(AttendanceDetailsModel.countWeiDaKa, s);
            }
        }
    }

}
