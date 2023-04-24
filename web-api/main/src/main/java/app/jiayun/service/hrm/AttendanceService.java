package app.jiayun.service.hrm;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.authine.cloudpivot.engine.api.model.organization.DepartmentModel;
import com.authine.cloudpivot.engine.api.model.organization.UserModel;
import com.authine.cloudpivot.engine.api.model.runtime.BizObjectModel;
import com.authine.cloudpivot.engine.api.model.runtime.SelectionValue;
import com.authine.cloudpivot.engine.api.model.system.RelatedCorpSettingModel;
import com.authine.cloudpivot.engine.component.query.api.FilterExpression;
import com.authine.cloudpivot.engine.enums.ErrCode;
import com.authine.cloudpivot.engine.enums.status.SequenceStatus;
import com.authine.cloudpivot.engine.enums.type.UserWorkStatus;
import com.authine.cloudpivot.web.api.view.ResponseResult;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;

import app.ext.util.ResponseResultUtils;
import app.jiayun.service.JiayunCommonService;
import app.jiayun.service.dingtalk.DingtalkAttendanceService;
import app.jiayun.service.dingtalk.DingtalkAuthService;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class AttendanceService extends JiayunCommonService {

    /*
     * key=钉钉考勤报表列ID <br>
     * value=JiaYun_KaoQinMingXi表字段
     */
    static JSONObject ATTCOLUMNS = new JSONObject() {
        private static final long serialVersionUID = 1L;
        {
            put("518009116", "should_attendance_days");// 应出勤天数
            put("518009119", "attendance_days");// 出勤天数
            put("518009121", "attendance_work_time");// 工作时长
            put("518009122", "late_times"); // 迟到次数
            put("518009123", "late_minute");// 迟到时长
            put("518009124", "serious_late_times");// 严重迟到次数
            put("518009125", "serious_late_minute");// 严重迟到时长
            put("518009126", "absenteeism_late_times");// 旷工迟到次数
            put("518009131", "absenteeism_days");// 旷工天数
            put("518009127", "leave_early_times");// 早退次数
            put("518009128", "leave_early_minute");// 早退时长
            put("518009129", "on_work_lack_card_times");// 上班缺卡次数
            put("518009130", "off_work_lack_card_times");// 下班缺卡次数
            put("518009117", "making_up_lack_times");// 补卡次数
            put("518009139", "attend_result");// 考勤结果
        }
    };

    @Autowired
    private DingtalkAuthService dingtalkAuthService;
    @Autowired
    private DingtalkAttendanceService dingtalkAttendanceService;

    public ResponseResult<?> getColumnVal(Map<String, Object> params) {
        log.debug("[jiayun-hrm]：获取钉钉考勤开始...");

        String corpId = (String)params.get("corpId");
        String schemaCode = (String)params.get("schemaCode");

        try {
            // 获取aksk
            RelatedCorpSettingModel corpSetting =
                engineService.getSystemManagementFacade().getRelatedCorpSettingByCorpId(corpId);
            String appKey = corpSetting.getAppkey();
            String appSecret = corpSetting.getAppSecret();

            // 获取钉钉接口调用accessToken
            String accessToken = dingtalkAuthService.getAccessToken(appKey, appSecret);
            if (StringUtils.isBlank(accessToken)) {
                throw new Exception("获取钉钉企业内部应用accessToken失败");
            }

            // 获取组织架构userId，全员拉取考勤数据
            List<UserModel> userModelList = engineService.getOrganizationFacade().getUsersByCorpId(corpId);
            List<String> userIdList = Lists.newArrayList();
            List<String> userDeptIdList = Lists.newArrayList();
            Map<String, String[]> userPropertyMap = Maps.newHashMap();
            for (int k = 0; k < userModelList.size(); k++) {
                UserModel m = userModelList.get(k);
                // 过滤掉离职员工，但不包括当天离职的
                UserWorkStatus status = m.getUserWorkStatus();
                if (!UserWorkStatus.WAITING_TRANSFER.equals(status) && !UserWorkStatus.DIMISSION.equals(status)) {
                    String uid = m.getUserId();
                    String deptId = m.getDepartmentId();
                    userIdList.add(uid);
                    userDeptIdList.add(deptId);
                    userPropertyMap.put(uid, new String[] {m.getId(), deptId});
                }
            }

            // 获取用户所有部门信息
            Map<String, String> userDeptQueryCodeMap = Maps.newHashMap();
            List<DepartmentModel> userDeptList =
                engineService.getOrganizationFacade().getDepartmentsByDeptIds(userDeptIdList);
            for (int k = 0; k < userDeptList.size(); k++) {
                DepartmentModel dm = userDeptList.get(k);
                userDeptQueryCodeMap.put(dm.getId(), dm.getQueryCode());
            }

            // 开始封装调用钉钉接口获取考勤数据
            JSONObject interfaceResJson = new JSONObject();

            String[] rangeDate = getDateRange();
            String fromDate = rangeDate[0];
            String toDate = rangeDate[1];

            String columnList = ATTCOLUMNS.keySet().toString();
            columnList = columnList.replace("[", "").replace("]", "").replace(" ", "");

            Map<String, Object> map = Maps.newHashMap();
            map.put("columnList", columnList);
            map.put("fromDate", fromDate);
            map.put("toDate", toDate);
            for (int i = 0; i < userIdList.size(); i++) {
                String userId = userIdList.get(i);
                map.put("userId", userId);
                JSONObject res = dingtalkAttendanceService.getColumnVal(accessToken, map);
                if (0 != res.getIntValue("errcode")) {
                    throw new Exception("获取钉钉考勤报表列值异常");
                }

                JSONObject colValueMap = new JSONObject();
                JSONArray valsArray = res.getJSONObject("result").getJSONArray("column_vals");
                for (int j = 0; j < valsArray.size(); j++) {
                    JSONObject json = (JSONObject)valsArray.get(j);
                    String columnId = json.getJSONObject("column_vo").getString("id");
                    if (ATTCOLUMNS.containsKey(columnId)) {
                        String colName = ATTCOLUMNS.getString(columnId);
                        JSONArray colValueArray = json.getJSONArray("column_vals");
                        for (int k = 0; k < colValueArray.size(); k++) {
                            JSONObject colValueObj = colValueArray.getJSONObject(k);
                            String date = colValueObj.getString("date");
                            String value = colValueObj.getString("value");

                            JSONObject t = colValueMap.getJSONObject(date);
                            if (null != t) {
                                t.put(colName, value);
                                colValueMap.getJSONObject(date).putAll(t);
                            } else {
                                t = new JSONObject();
                                t.put(colName, value);
                                colValueMap.put(date, t);
                            }
                        }
                    }
                }
                interfaceResJson.put(userId, colValueMap);
            }

            // 保存到表单
            List<Map<String, Object>> interDataList =
                handleInterfaceData(interfaceResJson, userPropertyMap, userDeptQueryCodeMap);
            List<BizObjectModel> dbSavedList = getAttendanceRecordFromDb(fromDate, toDate);
            List<BizObjectModel> modelList = buildSaveData(schemaCode, interDataList, dbSavedList);

            List<String> result = saveToForm(modelList);
            log.info("[jiayun-hrm]：获取钉钉考勤成功：{}", result);
            return ResponseResultUtils.getOkResponseResult(result, "操作成功");
        } catch (Exception e) {
            log.error("[jiayun-hrm]：获取钉钉考勤异常：{}", e.toString());
            e.printStackTrace();
            return ResponseResultUtils.getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), e.getMessage());
        }
    }

    private List<Map<String, Object>> handleInterfaceData(JSONObject data, Map<String, String[]> userPropertyMap,
        Map<String, String> userDeptQueryCodeMap) {

        List<BizObjectModel> orgMappingList = getOrgMappingList();

        List<Map<String, Object>> resultList = Lists.newArrayList();
        for (String key : data.keySet()) {
            String[] arr = userPropertyMap.get(key);
            String uid = arr[0];
            String udeptId = arr[1];
            String deptQueryCode = userDeptQueryCodeMap.get(udeptId);

            String belongOrg = "";
            String orgFirstDeptId = "";
            for (BizObjectModel bom : orgMappingList) {
                Map<String, Object> map = bom.getData();
                String qc = (String)map.get("orgFirstDeptQueryCode");
                if (deptQueryCode.indexOf(qc) > -1) {
                    belongOrg = (String)map.get("id");
                    orgFirstDeptId = (String)map.get("orgFirstDeptId");
                    break;
                }
            }

            JSONObject dataByday = (JSONObject)data.get(key);
            for (String date : dataByday.keySet()) {
                JSONObject object = (JSONObject)dataByday.get(date);

                Map<String, Object> dataMap = new HashMap<>();
                dataMap.putAll(object);

                dataMap.put("sequenceStatus", SequenceStatus.CANCELED);
                dataMap.put("userName", uid);
                dataMap.put("userDept", udeptId);
                dataMap.put("dakaTimes", date);
                dataMap.put("belongOrg", belongOrg);
                dataMap.put("orgFirstDept", orgFirstDeptId);

                dataMap.put("waichuTimes", 0);
                dataMap.put("qingJiaTimes", 0);
                dataMap.put("tiaoxXiuTimes", 0);

                String attendResult = object.getString("attend_result");
                if (attendResult.indexOf("外出") > -1) {
                    dataMap.put("waichuTimes", 1);
                }
                if (attendResult.indexOf("假") > -1) {
                    dataMap.put("qingJiaTimes", 1);
                }
                if (attendResult.indexOf("调休") > -1) {
                    dataMap.put("tiaoxXiuTimes", 1);
                }

                if (attendResult.equals("正常")) {
                    dataMap.put("attendResultMark", "正常");
                } else if (attendResult.equals("休息")) {
                    dataMap.put("attendResultMark", "休息");
                } else {
                    dataMap.put("attendResultMark", "其它");
                }

                // 只保存出勤和应出勤大于0的，同时为0表示可能未在考勤组或不需要打卡
                int a = object.getIntValue("attendance_days");
                int b = object.getIntValue("should_attendance_days");
                if (0 != a || 0 != b) {
                    resultList.add(dataMap);
                }
            }
        }
        return resultList;
    }

    private List<BizObjectModel> getAttendanceRecordFromDb(String fromDate, String toDate) {
        try {
            String schemaCode = "JiaYun_KaoQinMingXi";

            List<String> columns = Lists.newArrayList();
            columns.add("id");

            FilterExpression filter =
                new FilterExpression.Item("dakaTimes", FilterExpression.Op.Between, new String[] {fromDate, toDate});

            List<BizObjectModel> formDataList = super.baseQueryFormData(schemaCode, null, columns, filter);
            if (CollectionUtils.isEmpty(formDataList)) {
                return new ArrayList<>();
            }
            return formDataList;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    @SuppressWarnings("unchecked")
    private List<BizObjectModel> buildSaveData(String schemaCode, List<Map<String, Object>> interDataList,
        List<BizObjectModel> dbSavedList) {

        List<BizObjectModel> resultList = Lists.newArrayList();

        for (int i = 0; i < interDataList.size(); i++) {
            Map<String, Object> d1 = interDataList.get(i);
            String uid1 = (String)d1.get("userName");
            String dkTimes1 = (String)d1.get("dakaTimes");

            for (int k = 0; k < dbSavedList.size(); k++) {
                Map<String, Object> d2 = dbSavedList.get(k).getData();
                List<SelectionValue> u = (List<SelectionValue>)d2.get("userName");
                String uid2 = u.get(0).getId();
                Date de = (Date)d2.get("dakaTimes");
                String dkTimes2 = new SimpleDateFormat("yyyy-MM-dd").format(de) + " 00:00:00";
                // 数据库已存在对应时间的考勤数据
                if (uid1.equals(uid2) && dkTimes1.equals(dkTimes2)) {
                    String objectId = (String)d2.get("id");
                    d1.put("id", objectId);
                    break;
                }
            }

            BizObjectModel model = new BizObjectModel(schemaCode, d1, false);
            resultList.add(model);
        }
        return resultList;
    }

    private List<String> saveToForm(List<BizObjectModel> modelList) {
        List<String> result = Lists.newArrayList();
        engineService.getBizObjectFacade().batchSaveBizObjectModel(this.ADMIN_USER, modelList, "id");
        return result;
    }

    private List<BizObjectModel> getOrgMappingList() {
        try {
            String schemaCode = "JiaYun_OrgMapping";

            List<String> columns = Lists.newArrayList();
            columns.add("id");
            columns.add("orgName");
            columns.add("orgShortName");
            columns.add("orgDeptId");
            columns.add("orgDeptQueryCode");

            List<BizObjectModel> formDataList = super.baseQueryFormData(schemaCode, null, columns, null);
            if (CollectionUtils.isEmpty(formDataList)) {
                throw new Exception("未查询到数据");
            }

            return formDataList;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    private String[] getDateRange() throws ParseException {
        // 返回每月开始和结束的时间
        // Calendar calendar = Calendar.getInstance();
        // calendar.set(Calendar.DATE, 1);
        // calendar.roll(Calendar.DATE, -1);
        // int max = calendar.get(Calendar.DATE);
        // String start = new SimpleDateFormat("yyyy-MM-").format(new Date()) + "01 00:00:00";
        // String end = new SimpleDateFormat("yyyy-MM-").format(new Date()) + max + " 23:59:59";

        // 当前时间往前共三天的开始起止时间
        String end = new SimpleDateFormat("yyyy-MM-dd").format(new Date()) + " 23:59:59";
        Date d = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(end);
        long c = d.getTime() - (2 * 24 * 60 * 60 * 1000);
        String start = new SimpleDateFormat("yyyy-MM-dd").format(new Date(c)) + " 00:00:00";

        return new String[] {start, end};
        // return new String[] {"2023-04-11 00:00:00", "2023-04-20 23:59:59"};
    }

}
