package com.authine.cloudpivot.ext.service.hrm;

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
import com.authine.cloudpivot.ext.model.hrm.AttendanceDetailModel;
import com.authine.cloudpivot.ext.service.BaseCommonService;
import com.authine.cloudpivot.ext.service.hrm.dingtalk.api.IDingtalkAttendanceApi;
import com.authine.cloudpivot.ext.service.hrm.dingtalk.api.IDingtalkCommonApi;
import com.authine.cloudpivot.ext.util.ResponseResultUtils;
import com.authine.cloudpivot.web.api.view.ResponseResult;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;

import lombok.extern.slf4j.Slf4j;

/**
 * 考勤明细
 * 
 * @author quyw
 * @date 2022/12/02
 */
@Service
@Slf4j
public class AttendanceDetailService extends BaseCommonService {

    @Autowired
    private IDingtalkCommonApi dingtalkCommonApi;
    @Autowired
    private IDingtalkAttendanceApi dingtalkAttendanceApi;

    public ResponseResult<Map<String, Object>> getAttendanceRecord(Map<String, Object> params) {
        log.info("[人事系统-考勤]：生成考勤明细开始，params={}", params);

        try {
            String corpId = (String)params.get("corpId");
            String schemaCode = (String)params.get("schemaCode");
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
                if (!UserWorkStatus.WAITING_TRANSFER.equals(status) && !UserWorkStatus.DIMISSION.equals(status)) {
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
            Map<String, Object> map = Maps.newHashMap();
            map.put("accessToken", accessToken);
            map.put("workDateFrom", startTime);
            map.put("workDateTo", startTime);
            for (int i = 0; i < userIdList.size(); i++) {
                long offset = 0l;
                long limit = 50l;
                map.put("UserIdList", userIdList.get(i));
                map.put("offset", offset);
                map.put("limit", limit);
                // 继续查询
                recordList = getDingtalkAttendanceRecord(recordList, map);
            }
            if (CollectionUtils.isEmpty(recordList)) {
                throw new Exception("未查询到考勤数据");
            }

            /* 
             * 开始写入考勤明细
             */
            List<Map<String, Object>> insertData = buildRecordList(recordList, userMap, startTime);
            for (int i = 0; i < insertData.size(); i++) {
                Map<String, Object> dataMap = insertData.get(i);
                String orgUserId = (String)dataMap.get(AttendanceDetailModel.org_userName);
                // 未查询到考勤数据的用户统一设置为未打卡
                Integer countQk = (Integer)dataMap.get(AttendanceDetailModel.countWeiDaKa);
                String timeResult = (String)dataMap.get(AttendanceDetailModel.timeResult);
                if (StringUtils.isBlank(timeResult)) {
                    dataMap.put(AttendanceDetailModel.timeResult, "未打卡");
                    countQk = countQk + 1;
                }
                String timeResult1 = (String)dataMap.get(AttendanceDetailModel.timeResult1);
                if (StringUtils.isBlank(timeResult1)) {
                    dataMap.put(AttendanceDetailModel.timeResult1, "未打卡");
                    countQk = countQk + 1;
                }
                dataMap.put(AttendanceDetailModel.countWeiDaKa, countQk);
                // 当天两次未打卡出勤天数为0
                if (2 == countQk) {
                    dataMap.put(AttendanceDetailModel.workDays, 0);
                }
                // 考勤时间
                dataMap.put(AttendanceDetailModel.attendanceTime,
                    new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(startTime));
                // 考勤归属月份，系统年月存储格式为固定每月1号
                dataMap.put(AttendanceDetailModel.kaoQinMonth, new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
                    .parse(startTime.split("-")[0] + "-" + startTime.split("-")[1] + "-01 00:00:00"));

                BizObjectModel model = new BizObjectModel(schemaCode, dataMap, false);
                String result = engineService.getBizObjectFacade().saveBizObject(orgUserId, model, true);
            }

            log.info("[人事系统-考勤]：生成考勤明细结束");
            return ResponseResultUtils.getOkResponseResult(null, "操作成功");
        } catch (Exception e) {
            log.error("[人事系统-考勤]：生成考勤明细异常：{}", e.toString());
            e.printStackTrace();
            return ResponseResultUtils.getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), e.getMessage());
        }
    }

    /**
     * 分页场景下，递归取数据
     */
    private List<Object> getDingtalkAttendanceRecord(List<Object> recordResult, Map<String, Object> params)
        throws Exception {
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
            getDingtalkAttendanceRecord(recordResult, params);
        }
        return recordResult;
    }

    /**
     * 上下班考勤数据合并及其他逻辑处理
     */
    private List<Map<String, Object>> buildRecordList(List<Object> recordResult, Map<String, String[]> userMap,
        String startTime) {
        List<Map<String, Object>> resultMap = Lists.newArrayList();
        for (String duid : userMap.keySet()) {
            Map<String, Object> paramsMap = Maps.newHashMap();

            // 系统组织用户，人员单选，部门单选
            String orgUserId = userMap.get(duid)[0];
            String orgUserDeptId = userMap.get(duid)[1];
            paramsMap.put(AttendanceDetailModel.org_userName, orgUserId);
            paramsMap.put(AttendanceDetailModel.org_userDept, orgUserDeptId);
            // 钉钉用户Id
            paramsMap.put(AttendanceDetailModel.countWeiDaKa, 0);
            paramsMap.put(AttendanceDetailModel.countChiDao, 0);
            paramsMap.put(AttendanceDetailModel.countZaoTui, 0);
            paramsMap.put(AttendanceDetailModel.workDays, 1);
            paramsMap.put(AttendanceDetailModel.lateTimes, 0);
            paramsMap.put(AttendanceDetailModel.earlyTimes, 0);

            // 上班下班打卡为两条数据，需要合并
            for (int j = 0; j < recordResult.size(); j++) {
                JSONObject json = (JSONObject)recordResult.get(j);
                String duid1 = json.getString("userId");
                if (duid.equals(duid1)) {
                    buildDuty(paramsMap, json);
                }
            }
            resultMap.add(paramsMap);
        }
        return resultMap;
    }

    private void buildDuty(Map<String, Object> data, JSONObject json) {
        String checkType = json.getString("checkType");
        // 上班OnDuty，下班OffDuty
        if ("OnDuty".equals(checkType)) {
            // 打卡时间
            data.put(AttendanceDetailModel.userCheckTime, new Date(json.getLongValue("userCheckTime")));
            // 打卡位置
            String locationResult = json.getString("locationResult");
            if ("Normal".equals(locationResult)) {
                data.put(AttendanceDetailModel.locationResult, "范围内");
            } else if ("Outside".equals(locationResult)) {
                data.put(AttendanceDetailModel.locationResult, "范围外");
            } else if ("NotSigned".equals(locationResult)) {
                data.put(AttendanceDetailModel.locationResult, "未打卡");
                data.put(AttendanceDetailModel.userCheckTime, null);
            }
            // 打卡结果
            String timeResult = json.getString("timeResult");
            if ("Normal".equals(timeResult)) {
                data.put(AttendanceDetailModel.timeResult, "正常");
            } else if ("Early".equals(timeResult)) {
                data.put(AttendanceDetailModel.timeResult, "早退");
            } else if ("Late".equals(timeResult) || "SeriousLate".equals(timeResult)
                || "Absenteeism".equals(timeResult)) {
                // 迟到，严重迟到，旷工迟到都算迟到
                data.put(AttendanceDetailModel.timeResult, "迟到");
                // 迟到时长
                Long sum = json.getLongValue("userCheckTime") - json.getLongValue("baseCheckTime");
                data.put(AttendanceDetailModel.lateTimes, sum / 1000 / 60);
                // 迟到次数
                Integer s = (Integer)data.get(AttendanceDetailModel.countChiDao) + 1;
                data.put(AttendanceDetailModel.countChiDao, s);
            } else if ("NotSigned".equals(timeResult)) {
                data.put(AttendanceDetailModel.timeResult, "未打卡");
                data.put(AttendanceDetailModel.userCheckTime, null);
                // 未打卡次数
                Integer s = (Integer)data.get(AttendanceDetailModel.countWeiDaKa) + 1;
                data.put(AttendanceDetailModel.countWeiDaKa, s);
            } else {
                // 其他情况记为未打卡
                data.put(AttendanceDetailModel.timeResult, "未打卡");
                data.put(AttendanceDetailModel.userCheckTime, null);
                Integer s = (Integer)data.get(AttendanceDetailModel.countWeiDaKa) + 1;
                data.put(AttendanceDetailModel.countWeiDaKa, s);
            }
        } else if ("OffDuty".equals(checkType)) {
            // 打卡时间
            data.put(AttendanceDetailModel.userCheckTime1, new Date(json.getLongValue("userCheckTime")));
            // 打卡位置
            String locationResult = json.getString("locationResult");
            if ("Normal".equals(locationResult)) {
                data.put(AttendanceDetailModel.locationResult1, "范围内");
            } else if ("Outside".equals(locationResult)) {
                data.put(AttendanceDetailModel.locationResult1, "范围外");
            } else if ("NotSigned".equals(locationResult)) {
                data.put(AttendanceDetailModel.locationResult1, "未打卡");
            }
            // 打卡结果
            String timeResult = json.getString("timeResult");
            if ("Normal".equals(timeResult)) {
                data.put(AttendanceDetailModel.timeResult1, "正常");
            } else if ("Early".equals(timeResult)) {
                data.put(AttendanceDetailModel.timeResult1, "早退");
                // 早退时长
                Long sum = json.getLongValue("baseCheckTime") - json.getLongValue("userCheckTime");
                data.put(AttendanceDetailModel.earlyTimes, sum / 1000 / 60);
                // 早退次数
                Integer s = (Integer)data.get(AttendanceDetailModel.countZaoTui) + 1;
                data.put(AttendanceDetailModel.countZaoTui, s);
            } else if ("Late".equals(timeResult) || "SeriousLate".equals(timeResult)
                || "Absenteeism".equals(timeResult)) {
                // 迟到，严重迟到，旷工迟到都算迟到
                data.put(AttendanceDetailModel.timeResult1, "迟到");
            } else if ("NotSigned".equals(timeResult)) {
                data.put(AttendanceDetailModel.timeResult1, "未打卡");
                data.put(AttendanceDetailModel.userCheckTime1, null);
                // 未打卡次数
                Integer s = (Integer)data.get(AttendanceDetailModel.countWeiDaKa) + 1;
                data.put(AttendanceDetailModel.countWeiDaKa, s);
            } else {
                // 其他情况记为未打卡
                data.put(AttendanceDetailModel.timeResult1, "未打卡");
                data.put(AttendanceDetailModel.userCheckTime, null);
                Integer s = (Integer)data.get(AttendanceDetailModel.countWeiDaKa) + 1;
                data.put(AttendanceDetailModel.countWeiDaKa, s);
            }
        }
    }

}
