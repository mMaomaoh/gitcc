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
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.authine.cloudpivot.engine.api.model.organization.DepartmentModel;
import com.authine.cloudpivot.engine.api.model.runtime.BizObjectModel;
import com.authine.cloudpivot.engine.api.model.runtime.SelectionValue;
import com.authine.cloudpivot.engine.component.query.api.FilterExpression;
import com.authine.cloudpivot.engine.enums.ErrCode;
import com.authine.cloudpivot.ext.constant.BusRuleOptConstants;
import com.authine.cloudpivot.ext.model.ExtBaseModel;
import com.authine.cloudpivot.ext.model.hrm.AttendanceSummaryModel;
import com.authine.cloudpivot.ext.model.hrm.LeaveApplyModel;
import com.authine.cloudpivot.ext.service.BaseCommonService;
import com.authine.cloudpivot.ext.util.ExtClassUtils;
import com.authine.cloudpivot.ext.util.ResponseResultUtils;
import com.authine.cloudpivot.web.api.view.ResponseResult;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;

import lombok.extern.slf4j.Slf4j;

/***
 * 休假申请**
 * 
 * @author quyw
 * @date 2022/12/02
 */
@Service
@Slf4j
public class LeaveSummaryService extends BaseCommonService {

    @Autowired
    private AttendanceSummaryService attendanceSummaryService;

    private static final String TYPE_SHIJIA = "事假";
    private static final String TYPE_BINGJIA = "病假";
    private static final String TYPE_SANGJIA = "丧假";
    private static final String TYPE_HUNJIA = "婚假";
    private static final String TYPE_CHANJIA = "产假";
    private static final String TYPE_PEICHANJIA = "陪产假";
    private static final String TYPE_CHANJIANJIA = "产检假";
    private static final String TYPE_TIAOXIU = "调休";
    private static final String TYPE_NIANJIA = "年假";
    private static final String TYPE_YOUXINJIA = "有薪假";
    private static final String TYPE_QITAQINGJIA = "其他";

    public ResponseResult<Map<String, Object>> summaryLeave(Map<String, Object> params) {
        log.info("[人事系统-考勤]：休假数据统计到考勤汇总开始，params={}", params);
        try {
            String objectId = (String)params.get("objectId");
            String sc_xjsq = (String)params.get("sc_xjsq");
            String sc_xjsq_sheet = (String)params.get("sc_xjsq_sheet");
            String sc_kqhz = (String)params.get("sc_kqhz");
            String opt = (String)params.get("opt");

            /*
            * 查询请假数据
            */
            List<String> columns = Lists.newArrayList();
            columns.add(sc_xjsq_sheet);
            columns.add(ExtBaseModel.id);
            columns.add(LeaveApplyModel.userName);
            columns.add(LeaveApplyModel.qingJiaLeiXing);
            // 查询条件
            FilterExpression filter = new FilterExpression.Item(ExtBaseModel.id, FilterExpression.Op.Eq, objectId);
            List<BizObjectModel> formDataList = super.baseQueryFormData(sc_xjsq, null, columns, filter);
            if (CollectionUtils.isEmpty(formDataList)) {
                throw new Exception("未查询到数据");
            } else if (formDataList.size() > 1) {
                throw new Exception("查询结果异常");
            }
            Map<String, Object> formDataMap = formDataList.get(0).getData();

            // 如果已经作废了流程，删除数据则不更新汇总，进行中的流程删除也不触发更新汇总
            String workflowInstanceId = (String)formDataMap.get(ExtBaseModel.workflowInstanceId);
            String sequenceStatus = (String)formDataMap.get(ExtBaseModel.sequenceStatus);
            if (BusRuleOptConstants.OPT_DELETE.equals(opt)) {
                if (StringUtils.isNotBlank(workflowInstanceId)) {
                    if ("CANCELED".equals(sequenceStatus) || "PROCESSING".equals(sequenceStatus)) {
                        return ResponseResultUtils.getOkResponseResult(null, "操作成功");
                    }
                }
            }

            /*
            * 计算休假类型或日期是否月或跨年（因为考勤汇总是按月统计）
            */
            // 休假类型
            String leaveType = (String)formDataMap.get(LeaveApplyModel.qingJiaLeiXing);
            // 休假人
            List<SelectionValue> selection = (List<SelectionValue>)formDataMap.get(LeaveApplyModel.userName);
            String userId = selection.get(0).getId();
            // 休假人所属部门
            String userDept = (String)formDataMap.get(ExtBaseModel.createdDeptId);
            if (StringUtils.isBlank(userDept)) {
                List<DepartmentModel> userDeptList =
                    engineService.getOrganizationFacade().getDepartmentsByUserId(userId);
                if (CollectionUtils.isNotEmpty(userDeptList)) {
                    userDept = userDeptList.get(0).getId();
                }
            }
            // 休假明细子表
            List<Map<String, Object>> leaveDetailList = (List<Map<String, Object>>)formDataMap.get(sc_xjsq_sheet);

            // 按月分组统计请假时长
            Map<String, Double> monthMap = Maps.newHashMap();
            for (Map<String, Object> leaveDetailMap : leaveDetailList) {
                double timeLength = ((BigDecimal)leaveDetailMap.get(LeaveApplyModel.sheet_shiChang)).doubleValue();
                LocalDateTime date =
                    ((Timestamp)leaveDetailMap.get(LeaveApplyModel.sheet_qingJiaRiQi)).toLocalDateTime();

                String dateStr = date.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
                String monthStr = dateStr.split("-")[0] + "-" + dateStr.split("-")[1];

                if (monthMap.containsKey(monthStr)) {
                    timeLength = timeLength + monthMap.get(monthStr);
                }
                monthMap.put(monthStr, timeLength);
            }

            /*
            * 根据月份查询考勤汇总表以进行insert或update
            */
            for (String key : monthMap.keySet()) {
                Map<String, Object> attSummaryMap = Maps.newHashMap();
                attSummaryMap.put("schemaCode", sc_kqhz);
                attSummaryMap.put("monthStr", key);
                attSummaryMap.put("userId", userId);
                attSummaryMap.put("userDept", userDept);
                attSummaryMap.put("leaveType", leaveType);
                attSummaryMap.put("timeLength", monthMap.get(key));
                attSummaryMap.put("opt", opt);
                updateAttendanceSummery(attSummaryMap);
            }

            log.info("[人事系统-考勤]：休假数据统计到考勤汇总结束...");
            return ResponseResultUtils.getOkResponseResult(null, "操作成功");
        } catch (Exception e) {
            log.error("[人事系统-考勤]：休假数据统计到考勤汇总异常：{}", e.toString());
            e.printStackTrace();
            return ResponseResultUtils.getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), e.getMessage());
        }
    }

    public String updateAttendanceSummery(Map<String, Object> params) throws Exception {

        String schemaCode = (String)params.get("schemaCode");
        String monthStr = (String)params.get("monthStr");
        String orgUserId = (String)params.get("userId");
        String orgUserDept = (String)params.get("userDept");
        String leaveType = (String)params.get("leaveType");
        String opt = (String)params.get("opt");
        double timeLength = (double)params.get("timeLength");

        Date month = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(monthStr + "-01 00:00:00");

        List<String> columns = ExtClassUtils.getFiledsValue(AttendanceSummaryModel.class);

        List<FilterExpression> filterList = Lists.newArrayList();
        filterList.add(new FilterExpression.Item(AttendanceSummaryModel.kaoQinYue, FilterExpression.Op.Eq, month));
        filterList.add(new FilterExpression.Item(AttendanceSummaryModel.userName, FilterExpression.Op.Eq, orgUserId));
        FilterExpression.And filter = new FilterExpression.And(filterList);

        List<BizObjectModel> formDataList = super.baseQueryFormData(schemaCode, null, columns, filter);

        Map<String, Object> formDataMap = Maps.newHashMap();
        if (CollectionUtils.isEmpty(formDataList)) {
            // nothing
        } else if (formDataList.size() > 1) {
            throw new Exception("查询结果异常");
        } else {
            formDataMap = formDataList.get(0).getData();
        }

        Map<String, Object> tableData = Maps.newHashMap();
        if (MapUtils.isEmpty(formDataMap)) {
            if (BusRuleOptConstants.OPT_DELETE.equals(opt) || BusRuleOptConstants.OPT_CANCEL.equals(opt)) {
                // 删除数据，作废流程不触发新增
                return null;
            }
            // insert
            tableData.put(AttendanceSummaryModel.userName, orgUserId);
            tableData.put(AttendanceSummaryModel.userDept, orgUserDept);
            tableData.put(AttendanceSummaryModel.kaoQinYue, month);
            // init
            tableData.putAll(attendanceSummaryService.initTableData());
            // 区分类型赋值
            if (TYPE_SHIJIA.equals(leaveType)) {
                tableData.put(AttendanceSummaryModel.shiJia, timeLength);
            } else if (TYPE_BINGJIA.equals(leaveType)) {
                tableData.put(AttendanceSummaryModel.bingJia, timeLength);
            } else if (TYPE_SANGJIA.equals(leaveType)) {
                tableData.put(AttendanceSummaryModel.sangJia, timeLength);
            } else if (TYPE_HUNJIA.equals(leaveType)) {
                tableData.put(AttendanceSummaryModel.hunJia, timeLength);
            } else if (TYPE_CHANJIA.equals(leaveType)) {
                tableData.put(AttendanceSummaryModel.chanJia, timeLength);
            } else if (TYPE_PEICHANJIA.equals(leaveType)) {
                tableData.put(AttendanceSummaryModel.peiChanJia, timeLength);
            } else if (TYPE_CHANJIANJIA.equals(leaveType)) {
                tableData.put(AttendanceSummaryModel.chanJianJia, timeLength);
            } else if (TYPE_TIAOXIU.equals(leaveType)) {
                tableData.put(AttendanceSummaryModel.tiaoXiu, timeLength);
            } else if (TYPE_NIANJIA.equals(leaveType)) {
                tableData.put(AttendanceSummaryModel.nianJia, timeLength);
            } else if (TYPE_YOUXINJIA.equals(leaveType)) {
                tableData.put(AttendanceSummaryModel.youxXinJia, timeLength);
            } else {
                tableData.put(AttendanceSummaryModel.qiTaQingJia, timeLength);
            }
        } else {
            tableData.putAll(formDataMap);

            double shiJia = ((BigDecimal)formDataMap.get(AttendanceSummaryModel.shiJia)).doubleValue();
            double bingJia = ((BigDecimal)formDataMap.get(AttendanceSummaryModel.bingJia)).doubleValue();
            double sangJia = ((BigDecimal)formDataMap.get(AttendanceSummaryModel.sangJia)).doubleValue();
            double hunJia = ((BigDecimal)formDataMap.get(AttendanceSummaryModel.hunJia)).doubleValue();
            double chanJia = ((BigDecimal)formDataMap.get(AttendanceSummaryModel.chanJia)).doubleValue();
            double peiChanJia = ((BigDecimal)formDataMap.get(AttendanceSummaryModel.peiChanJia)).doubleValue();
            double chanJianJia = ((BigDecimal)formDataMap.get(AttendanceSummaryModel.chanJianJia)).doubleValue();
            double tiaoXiu = ((BigDecimal)formDataMap.get(AttendanceSummaryModel.tiaoXiu)).doubleValue();
            double nianJia = ((BigDecimal)formDataMap.get(AttendanceSummaryModel.nianJia)).doubleValue();
            double youxXinJia = ((BigDecimal)formDataMap.get(AttendanceSummaryModel.youxXinJia)).doubleValue();
            double qiTaQingJia = ((BigDecimal)formDataMap.get(AttendanceSummaryModel.qiTaQingJia)).doubleValue();

            if (BusRuleOptConstants.OPT_AVAILABLE.equals(opt)) {
                if (TYPE_SHIJIA.equals(leaveType)) {
                    tableData.put(AttendanceSummaryModel.shiJia, shiJia + timeLength);
                } else if (TYPE_BINGJIA.equals(leaveType)) {
                    tableData.put(AttendanceSummaryModel.bingJia, bingJia + timeLength);
                } else if (TYPE_SANGJIA.equals(leaveType)) {
                    tableData.put(AttendanceSummaryModel.sangJia, sangJia + timeLength);
                } else if (TYPE_HUNJIA.equals(leaveType)) {
                    tableData.put(AttendanceSummaryModel.hunJia, hunJia + timeLength);
                } else if (TYPE_CHANJIA.equals(leaveType)) {
                    tableData.put(AttendanceSummaryModel.chanJia, chanJia + timeLength);
                } else if (TYPE_PEICHANJIA.equals(leaveType)) {
                    tableData.put(AttendanceSummaryModel.peiChanJia, peiChanJia + timeLength);
                } else if (TYPE_CHANJIANJIA.equals(leaveType)) {
                    tableData.put(AttendanceSummaryModel.chanJianJia, chanJianJia + timeLength);
                } else if (TYPE_TIAOXIU.equals(leaveType)) {
                    tableData.put(AttendanceSummaryModel.tiaoXiu, tiaoXiu + timeLength);
                } else if (TYPE_NIANJIA.equals(leaveType)) {
                    tableData.put(AttendanceSummaryModel.nianJia, nianJia + timeLength);
                } else if (TYPE_YOUXINJIA.equals(leaveType)) {
                    tableData.put(AttendanceSummaryModel.youxXinJia, youxXinJia + timeLength);
                } else {
                    tableData.put(AttendanceSummaryModel.qiTaQingJia, qiTaQingJia + timeLength);
                }
            } else if (BusRuleOptConstants.OPT_CANCEL.equals(opt) || BusRuleOptConstants.OPT_DELETE.equals(opt)) {
                if (TYPE_SHIJIA.equals(leaveType)) {
                    tableData.put(AttendanceSummaryModel.shiJia, shiJia - timeLength);
                } else if (TYPE_BINGJIA.equals(leaveType)) {
                    tableData.put(AttendanceSummaryModel.bingJia, bingJia - timeLength);
                } else if (TYPE_SANGJIA.equals(leaveType)) {
                    tableData.put(AttendanceSummaryModel.sangJia, sangJia - timeLength);
                } else if (TYPE_HUNJIA.equals(leaveType)) {
                    tableData.put(AttendanceSummaryModel.hunJia, hunJia - timeLength);
                } else if (TYPE_CHANJIA.equals(leaveType)) {
                    tableData.put(AttendanceSummaryModel.chanJia, chanJia - timeLength);
                } else if (TYPE_PEICHANJIA.equals(leaveType)) {
                    tableData.put(AttendanceSummaryModel.peiChanJia, peiChanJia - timeLength);
                } else if (TYPE_CHANJIANJIA.equals(leaveType)) {
                    tableData.put(AttendanceSummaryModel.chanJianJia, chanJianJia - timeLength);
                } else if (TYPE_TIAOXIU.equals(leaveType)) {
                    tableData.put(AttendanceSummaryModel.tiaoXiu, tiaoXiu - timeLength);
                } else if (TYPE_NIANJIA.equals(leaveType)) {
                    tableData.put(AttendanceSummaryModel.nianJia, nianJia - timeLength);
                } else if (TYPE_YOUXINJIA.equals(leaveType)) {
                    tableData.put(AttendanceSummaryModel.youxXinJia, youxXinJia - timeLength);
                } else {
                    tableData.put(AttendanceSummaryModel.qiTaQingJia, qiTaQingJia - timeLength);
                }
            }
        }

        BizObjectModel model = new BizObjectModel(schemaCode, tableData, false);
        String result = engineService.getBizObjectFacade().saveBizObject(orgUserId, model, false);
        return result;
    }

}
