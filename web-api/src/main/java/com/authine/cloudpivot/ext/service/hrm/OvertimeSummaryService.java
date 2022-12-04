package com.authine.cloudpivot.ext.service.hrm;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.authine.cloudpivot.engine.api.model.organization.DepartmentModel;
import com.authine.cloudpivot.engine.api.model.runtime.BizObjectModel;
import com.authine.cloudpivot.engine.api.model.runtime.SelectionValue;
import com.authine.cloudpivot.engine.component.query.api.FilterExpression;
import com.authine.cloudpivot.engine.enums.ErrCode;
import com.authine.cloudpivot.ext.model.ExtBaseModel;
import com.authine.cloudpivot.ext.model.hrm.AttendanceSummaryModel;
import com.authine.cloudpivot.ext.model.hrm.OvertimeApplyModel;
import com.authine.cloudpivot.ext.model.hrm.OvertimeSummaryModel;
import com.authine.cloudpivot.ext.service.BaseCommonService;
import com.authine.cloudpivot.ext.util.ExtClassUtils;
import com.authine.cloudpivot.ext.util.ResponseResultUtils;
import com.authine.cloudpivot.web.api.view.ResponseResult;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;

import lombok.extern.slf4j.Slf4j;

/**
 * 加班申请汇总调休
 * 
 * @author quyw
 * @date 2022/12/04
 */
@Service
@Slf4j
public class OvertimeSummaryService extends BaseCommonService {

    @Autowired
    private AttendanceSummaryService attendanceSummaryService;

    private static final String OPT_AVAILABLE = "AVAILABLE";
    private static final String OPT_CANCEL = "CANCEL";
    private static final String OPT_DELETE = "DELETE";

    private static final String JIABAN_TYPE_1 = "工作日加班";
    private static final String JIABAN_TYPE_2 = "休息日加班";
    private static final String JIABAN_TYPE_3 = "节假日加班";

    private static final String JIESUAN_TYPE_1 = "调休";
    private static final String JIESUAN_TYPE_2 = "加班工资";
    private static final String JIESUAN_TYPE_3 = "其他";

    public ResponseResult<Map<String, Object>> summaryOvertime(Map<String, Object> params) {
        log.info("[人事系统-考勤]：加班申请更新调休及考勤汇总开始，params={}", params);
        try {
            String objectId = (String)params.get("objectId");
            String sc_jb = (String)params.get("sc_jb");
            String sc_tx = (String)params.get("sc_tx");
            String sc_kqhz = (String)params.get("sc_kqhz");
            String opt = (String)params.get("opt");

            /*
             * 1、加班申请表单数据
             */
            List<String> columns = Lists.newArrayList();
            columns.add(ExtBaseModel.id);
            columns.add(ExtBaseModel.workflowInstanceId);
            columns.add(ExtBaseModel.sequenceStatus);
            columns.add(OvertimeApplyModel.jiaBanRen);
            columns.add(OvertimeApplyModel.jiaBanType);
            columns.add(OvertimeApplyModel.jieSuanType);
            columns.add(OvertimeApplyModel.timeLength);
            columns.add(OvertimeApplyModel.yearMonth);
            // 查询条件
            FilterExpression filter = new FilterExpression.Item(ExtBaseModel.id, FilterExpression.Op.Eq, objectId);
            List<BizObjectModel> formDataList = super.baseQueryFormData(sc_jb, null, columns, filter);
            if (CollectionUtils.isEmpty(formDataList)) {
                throw new Exception("未查询到数据");
            } else if (formDataList.size() > 1) {
                throw new Exception("查询结果异常");
            }
            Map<String, Object> formDataMap = formDataList.get(0).getData();

            // 如果已经作废了流程，删除数据则不更新汇总
            String workflowInstanceId = (String)formDataMap.get(ExtBaseModel.workflowInstanceId);
            String sequenceStatus = (String)formDataMap.get(ExtBaseModel.sequenceStatus);
            if (OPT_DELETE.equals(opt)) {
                if (StringUtils.isNotBlank(workflowInstanceId) && "CANCELED".equals(sequenceStatus)) {
                    return ResponseResultUtils.getOkResponseResult(null, "操作成功");
                }
            }

            LocalDateTime yearMonth = ((Timestamp)formDataMap.get(OvertimeApplyModel.yearMonth)).toLocalDateTime();
            double timeLength = ((BigDecimal)formDataMap.get(OvertimeApplyModel.timeLength)).doubleValue();
            List<SelectionValue> userList = (List<SelectionValue>)formDataMap.get(OvertimeApplyModel.jiaBanRen);
            String jiaBanType = (String)formDataMap.get(OvertimeApplyModel.jiaBanType);
            String jieSuanType = (String)formDataMap.get(OvertimeApplyModel.jieSuanType);

            /*
             * 2、生成调休汇总
             * 3、更新到考勤汇总
             */
            for (int i = 0; i < userList.size(); i++) {
                SelectionValue user = userList.get(i);
                String uid = user.getId();
                String userDept = user.getDepartmentId();
                if (StringUtils.isBlank(userDept)) {
                    List<DepartmentModel> userDeptList =
                        engineService.getOrganizationFacade().getDepartmentsByUserId(uid);
                    if (CollectionUtils.isNotEmpty(userDeptList)) {
                        userDept = userDeptList.get(0).getId();
                    }
                }

                // 更新到调休汇总
                if (JIESUAN_TYPE_1.equals(jieSuanType)) {
                    updateTiaoXiuSummary(opt, sc_tx, uid, userDept, yearMonth, timeLength);
                }

                // 更新到考勤汇总
                Map<String, Double> attDataMap = Maps.newHashMap();
                if (JIABAN_TYPE_1.equals(jiaBanType)) {
                    attDataMap.put(AttendanceSummaryModel.gongZuoRiJiaBan, timeLength);
                } else if (JIABAN_TYPE_2.equals(jiaBanType)) {
                    attDataMap.put(AttendanceSummaryModel.xiuXiRiJiaBan, timeLength);
                } else if (JIABAN_TYPE_3.equals(jiaBanType)) {
                    attDataMap.put(AttendanceSummaryModel.jieJiaRiJiaBan, timeLength);
                }
                if (JIESUAN_TYPE_1.equals(jieSuanType)) {
                    attDataMap.put(AttendanceSummaryModel.jieSuanTiaoXiuJiaBan, timeLength);
                } else if (JIESUAN_TYPE_2.equals(jieSuanType)) {
                    attDataMap.put(AttendanceSummaryModel.jieSuanXinZiJiaBan, timeLength);
                }
                if (JIESUAN_TYPE_3.equals(jieSuanType)) {
                    attDataMap.put(AttendanceSummaryModel.jieSuanTiaoXiuJiaBan, timeLength);
                }
                Map<String, Object> attSummaryMap = Maps.newHashMap();
                attSummaryMap.put("schemaCode", sc_kqhz);
                attSummaryMap.put("yearMonth", yearMonth);
                attSummaryMap.put("userId", uid);
                attSummaryMap.put("userDept", userDept);
                attSummaryMap.put("data", attDataMap);
                attSummaryMap.put("opt", opt);
                updateAttendanceSummery(attSummaryMap);
            }

            log.info("[人事系统-考勤]：加班申请更新调休及考勤汇总结束...");
            return ResponseResultUtils.getOkResponseResult(null, "操作成功");
        } catch (Exception e) {
            log.error("[人事系统-考勤]：加班申请更新调休及考勤汇总异常：{}", e.toString());
            e.printStackTrace();
            return ResponseResultUtils.getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), e.getMessage());
        }
    }

    private String updateTiaoXiuSummary(String opt, String schemaCode, String orgUserId, String orgUserDept,
        LocalDateTime yearsMonth, double timeLength) throws Exception {

        // 请假申请为年月格式，调休按年统计
        // String yearStr = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(yearsMonth);
        String yearStr = yearsMonth.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));

        Date years = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
            .parse(yearStr.split("-")[0] + "-" + yearStr.split("-")[1] + "-01 00:00:00");

        // 查询调休汇总
        List<String> columns = Lists.newArrayList();
        columns.add(OvertimeSummaryModel.userName);
        columns.add(OvertimeSummaryModel.userDept);
        columns.add(OvertimeSummaryModel.years);
        columns.add(OvertimeSummaryModel.workTimesRemainder);
        // 查询条件
        List<FilterExpression> filterList = Lists.newArrayList();
        filterList.add(new FilterExpression.Item(OvertimeSummaryModel.years, FilterExpression.Op.Eq, years));
        filterList.add(new FilterExpression.Item(OvertimeSummaryModel.userName, FilterExpression.Op.Eq, orgUserId));
        FilterExpression.And filter = new FilterExpression.And(filterList);

        List<BizObjectModel> formDataList = super.baseQueryFormData(schemaCode, null, columns, filter);

        Map<String, Object> tableData = Maps.newHashMap();
        if (CollectionUtils.isEmpty(formDataList)) {
            if (OPT_DELETE.equals(opt) || OPT_CANCEL.equals(opt)) {
                // 删除数据，作废流程不触发新增
                return null;
            }
            tableData.put(OvertimeSummaryModel.userName, orgUserId);
            tableData.put(OvertimeSummaryModel.userDept, orgUserDept);
            tableData.put(OvertimeSummaryModel.years, years);
            tableData.put(OvertimeSummaryModel.workTimesRemainder, timeLength);
        } else if (formDataList.size() > 1) {
            throw new Exception("查询结果异常");
        } else {
            Map<String, Object> formDataMap = formDataList.get(0).getData();
            tableData.putAll(formDataMap);

            double d = ((BigDecimal)formDataMap.get(OvertimeSummaryModel.workTimesRemainder)).doubleValue();
            if (OPT_AVAILABLE.equals(opt)) {
                tableData.put(OvertimeSummaryModel.workTimesRemainder, timeLength + d);
            } else if (OPT_CANCEL.equals(opt) || OPT_DELETE.equals(opt)) {
                tableData.put(OvertimeSummaryModel.workTimesRemainder, d - timeLength);
            }
        }
        BizObjectModel model = new BizObjectModel(schemaCode, tableData, false);
        String result = engineService.getBizObjectFacade().saveBizObject(orgUserId, model, true);
        return result;
    }

    public String updateAttendanceSummery(Map<String, Object> params) throws Exception {

        String opt = (String)params.get("opt");
        String schemaCode = (String)params.get("schemaCode");
        LocalDateTime yearMonth = (LocalDateTime)params.get("yearMonth");
        String orgUserId = (String)params.get("userId");
        String orgUserDept = (String)params.get("userDept");
        Map<String, Object> data = (Map<String, Object>)params.get("data");

        List<String> columns = ExtClassUtils.getFiledsValue(AttendanceSummaryModel.class);

        List<FilterExpression> filterList = Lists.newArrayList();
        filterList.add(new FilterExpression.Item(AttendanceSummaryModel.kaoQinYue, FilterExpression.Op.Eq,
            Timestamp.valueOf(yearMonth)));
        filterList.add(new FilterExpression.Item(AttendanceSummaryModel.userName, FilterExpression.Op.Eq, orgUserId));
        FilterExpression.And filter = new FilterExpression.And(filterList);

        List<BizObjectModel> formDataList = super.baseQueryFormData(schemaCode, null, columns, filter);

        Map<String, Object> tableData = Maps.newHashMap();
        if (CollectionUtils.isEmpty(formDataList)) {
            // 新增数据
            tableData.putAll(attendanceSummaryService.initTableData());
            tableData.putAll(data);
            tableData.put(AttendanceSummaryModel.userName, orgUserId);
            tableData.put(AttendanceSummaryModel.userDept, orgUserDept);
            tableData.put(AttendanceSummaryModel.kaoQinYue, Timestamp.valueOf(yearMonth));
        } else if (formDataList.size() > 1) {
            throw new Exception("查询结果异常");
        } else {
            // 更新数据
            Map<String, Object> formDataMap = formDataList.get(0).getData();
            // tableData.put(ExtBaseModel.id, formDataMap.get(ExtBaseModel.id));
            tableData.putAll(formDataMap);

            // 数据库查出来的
            double gongZuoRiJiaBan =
                ((BigDecimal)formDataMap.get(AttendanceSummaryModel.gongZuoRiJiaBan)).doubleValue();
            double xiuXiRiJiaBan = ((BigDecimal)formDataMap.get(AttendanceSummaryModel.xiuXiRiJiaBan)).doubleValue();
            double jieJiaRiJiaBan = ((BigDecimal)formDataMap.get(AttendanceSummaryModel.jieJiaRiJiaBan)).doubleValue();
            double jieSuanTiaoXiuJiaBan =
                ((BigDecimal)formDataMap.get(AttendanceSummaryModel.jieSuanTiaoXiuJiaBan)).doubleValue();
            double jieSuanXinZiJiaBan =
                ((BigDecimal)formDataMap.get(AttendanceSummaryModel.jieSuanXinZiJiaBan)).doubleValue();
            double jieSuanQiTaJiaBan =
                ((BigDecimal)formDataMap.get(AttendanceSummaryModel.jieSuanQiTaJiaBan)).doubleValue();

            // 需要累加的
            double gongZuoRiJiaBan1 = (double)data.get(AttendanceSummaryModel.gongZuoRiJiaBan);
            double xiuXiRiJiaBan1 = (double)data.get(AttendanceSummaryModel.xiuXiRiJiaBan);
            double jieJiaRiJiaBan1 = (double)data.get(AttendanceSummaryModel.jieJiaRiJiaBan);
            double jieSuanTiaoXiuJiaBan1 = (double)data.get(AttendanceSummaryModel.jieSuanTiaoXiuJiaBan);
            double jieSuanXinZiJiaBan1 = (double)data.get(AttendanceSummaryModel.jieSuanXinZiJiaBan);
            double jieSuanQiTaJiaBan1 = (double)data.get(AttendanceSummaryModel.jieSuanQiTaJiaBan);

            // 累加计算
            if (OPT_AVAILABLE.equals(opt)) {
                tableData.put(AttendanceSummaryModel.gongZuoRiJiaBan, gongZuoRiJiaBan + gongZuoRiJiaBan1);
                tableData.put(AttendanceSummaryModel.xiuXiRiJiaBan, xiuXiRiJiaBan + xiuXiRiJiaBan1);
                tableData.put(AttendanceSummaryModel.jieJiaRiJiaBan, jieJiaRiJiaBan + jieJiaRiJiaBan1);
                tableData.put(AttendanceSummaryModel.jieSuanTiaoXiuJiaBan,
                    jieSuanTiaoXiuJiaBan + jieSuanTiaoXiuJiaBan1);
                tableData.put(AttendanceSummaryModel.jieSuanXinZiJiaBan, jieSuanXinZiJiaBan + jieSuanXinZiJiaBan1);
                tableData.put(AttendanceSummaryModel.jieSuanQiTaJiaBan, jieSuanQiTaJiaBan + jieSuanQiTaJiaBan1);
            } else if (OPT_CANCEL.equals(opt) || OPT_DELETE.equals(opt)) {
                tableData.put(AttendanceSummaryModel.gongZuoRiJiaBan, gongZuoRiJiaBan - gongZuoRiJiaBan1);
                tableData.put(AttendanceSummaryModel.xiuXiRiJiaBan, xiuXiRiJiaBan - xiuXiRiJiaBan1);
                tableData.put(AttendanceSummaryModel.jieJiaRiJiaBan, jieJiaRiJiaBan - jieJiaRiJiaBan1);
                tableData.put(AttendanceSummaryModel.jieSuanTiaoXiuJiaBan,
                    jieSuanTiaoXiuJiaBan - jieSuanTiaoXiuJiaBan1);
                tableData.put(AttendanceSummaryModel.jieSuanXinZiJiaBan, jieSuanXinZiJiaBan - jieSuanXinZiJiaBan1);
                tableData.put(AttendanceSummaryModel.jieSuanQiTaJiaBan, jieSuanQiTaJiaBan - jieSuanQiTaJiaBan1);
            }
        }

        BizObjectModel model = new BizObjectModel(schemaCode, tableData, false);
        String result = engineService.getBizObjectFacade().saveBizObject(orgUserId, model, true);

        return result;
    }

}
