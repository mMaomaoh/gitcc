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
import com.authine.cloudpivot.engine.api.model.system.RelatedCorpSettingModel;
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
            List<String> userIds = Lists.newArrayList();
            List<String> userDeptIds = Lists.newArrayList();
            Map<String, String[]> userMap = Maps.newHashMap();
            for (int k = 0; k < userModelList.size(); k++) {
                UserModel m = userModelList.get(k);
                // 过滤掉离职员工，但不包括当天离职的
                UserWorkStatus status = m.getUserWorkStatus();
                if (!UserWorkStatus.WAITING_TRANSFER.equals(status) && !UserWorkStatus.DIMISSION.equals(status)) {
                    String uid = m.getUserId();
                    String dept = m.getDepartmentId();
                    userIds.add(uid);
                    userDeptIds.add(dept);
                    userMap.put(uid, new String[] {m.getId(), dept});
                }
            }

            // 获取用户所有部门信息
            Map<String, String> userDeptMap = Maps.newHashMap();
            List<DepartmentModel> userDeptList =
                engineService.getOrganizationFacade().getDepartmentsByDeptIds(userDeptIds);
            for (int k = 0; k < userDeptList.size(); k++) {
                DepartmentModel dm = userDeptList.get(k);
                userDeptMap.put(dm.getId(), dm.getQueryCode());
            }

            // 开始封装调用钉钉接口获取考勤数据
            JSONObject recordObject = new JSONObject();

            String[] rangeDate = getDateRange();
            String fromDate = rangeDate[0];
            String toDate = rangeDate[1];

            String columnList = ATTCOLUMNS.keySet().toString();
            columnList = columnList.replace("[", "").replace("]", "").replace(" ", "");

            Map<String, Object> map = Maps.newHashMap();
            map.put("columnList", columnList);
            map.put("fromDate", fromDate);
            map.put("toDate", toDate);
            for (int i = 0; i < userIds.size(); i++) {
                String userId = userIds.get(i);
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
                recordObject.put(userId, colValueMap);
            }
            System.out.println(recordObject);

            // 保存到表单
            List<String> result = saveToForm(schemaCode, recordObject, userMap, userDeptMap);
            return ResponseResultUtils.getOkResponseResult(result, "操作成功");
        } catch (Exception e) {
            log.error("[jiayun-hrm]：获取钉钉考勤异常：{}", e.toString());
            e.printStackTrace();
            return ResponseResultUtils.getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), e.getMessage());
        }
    }

    private List<String> saveToForm(
        String schemaCode,
        JSONObject data,
        Map<String, String[]> userMap,
        Map<String, String> userDeptMap) {

        List<BizObjectModel> orgMapping = getOrgMapping();

        List<BizObjectModel> modelList = Lists.newArrayList();
        for (String key : data.keySet()) {
            String[] arr = userMap.get(key);
            String uid = arr[0];
            String udeptId = arr[1];
            String deptQueryCode = userDeptMap.get(udeptId);

            String belongOrg = "";
            for (BizObjectModel m : orgMapping) {
                Map<String, Object> map = m.getData();
                String qc = (String)map.get("orgDeptQueryCode");
                if (deptQueryCode.indexOf(qc) > -1) {
                    belongOrg = (String)map.get("id");
                    break;
                }
            }

            JSONObject dataByday = (JSONObject)data.get(key);
            for (String date : dataByday.keySet()) {
                JSONObject object = (JSONObject)dataByday.get(date);

                Map<String, Object> dataMap = new HashMap<>();
                dataMap.putAll(object);

                dataMap.put("creater", uid);
                dataMap.put("sequenceStatus", SequenceStatus.CANCELED);
                dataMap.put("userName", uid);
                dataMap.put("userDept", udeptId);
                dataMap.put("dakaTimes", date);
                dataMap.put("belongOrg", belongOrg);

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
                    BizObjectModel model = new BizObjectModel(schemaCode, dataMap, false);
                    modelList.add(model);
                }
            }
        }

        List<String> result = engineService.getBizObjectFacade().addBizObjects(true, this.ADMIN_USER, modelList, null);
        return result;
    }

    private List<BizObjectModel> getOrgMapping() {
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
        long c = d.getTime() - (3 * 24 * 60 * 60 * 1000);
        String start = new SimpleDateFormat("yyyy-MM-dd").format(new Date(c)) + " 00:00:00";

        // return new String[] {start, end};
        return new String[] {"2023-04-11 00:00:00", "2023-04-19 23:59:59"};
    }

}
