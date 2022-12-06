package com.authine.cloudpivot.ext.service.hrm;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Set;

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
import com.authine.cloudpivot.ext.model.hrm.BusinessTripApplyModel;
import com.authine.cloudpivot.ext.service.BaseCommonService;
import com.authine.cloudpivot.ext.util.ExtClassUtils;
import com.authine.cloudpivot.ext.util.ResponseResultUtils;
import com.authine.cloudpivot.web.api.view.ResponseResult;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.collect.Sets;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class BusinessTripSummaryService extends BaseCommonService {

    @Autowired
    private AttendanceSummaryService attendanceSummaryService;

    public ResponseResult<Map<String, Object>> summaryBusinessTrip(Map<String, Object> params) {
        log.info("[人事系统-考勤]：出差数据统计到考勤汇总开始，params={}", params);
        try {
            String objectId = (String)params.get("objectId");
            String sc_ccsq = (String)params.get("sc_ccsq");
            String sc_ccsq_sheet = (String)params.get("sc_ccsq_sheet");
            String sc_kqhz = (String)params.get("sc_kqhz");
            String opt = (String)params.get("opt");

            /*
             * 1、出差申请表单数据
             */
            List<String> columns = Lists.newArrayList();
            columns.add(sc_ccsq_sheet);
            columns.add(ExtBaseModel.id);
            columns.add(ExtBaseModel.workflowInstanceId);
            columns.add(ExtBaseModel.sequenceStatus);
            columns.add(BusinessTripApplyModel.shenQingRen);
            columns.add(BusinessTripApplyModel.tongXingRen);
            // 查询条件
            FilterExpression filter = new FilterExpression.Item(ExtBaseModel.id, FilterExpression.Op.Eq, objectId);
            List<BizObjectModel> formDataList = super.baseQueryFormData(sc_ccsq, null, columns, filter);
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

            // 出差申请人和同行人
            List<SelectionValue> sqrList = (List<SelectionValue>)formDataMap.get(BusinessTripApplyModel.shenQingRen);
            List<SelectionValue> txrList = (List<SelectionValue>)formDataMap.get(BusinessTripApplyModel.tongXingRen);

            Set<SelectionValue> userSet = Sets.newHashSet();
            userSet.add(sqrList.get(0));
            for (int i = 0; i < txrList.size(); i++) {
                userSet.add(txrList.get(i));
            }

            // 出差明细子表
            List<Map<String, Object>> tripDetailList = (List<Map<String, Object>>)formDataMap.get(sc_ccsq_sheet);

            // 处理出差人和出差时间
            Map<String, Double> monthMap = Maps.newHashMap();
            for (Map<String, Object> tripDetailMap : tripDetailList) {
                double timeLength =
                    ((BigDecimal)tripDetailMap.get(BusinessTripApplyModel.sheet_shiChang)).doubleValue();
                LocalDateTime date =
                    ((Timestamp)tripDetailMap.get(BusinessTripApplyModel.sheet_chuChaiDate)).toLocalDateTime();

                String dateStr = date.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
                String monthStr = dateStr.split("-")[0] + "-" + dateStr.split("-")[1];

                if (monthMap.containsKey(monthStr)) {
                    timeLength = timeLength + monthMap.get(monthStr);
                }
                monthMap.put(monthStr, timeLength);
            }

            /*
             * 2、更新到考勤汇总
             */
            for (SelectionValue user : userSet) {
                String userId = user.getId();
                String userDept = user.getDepartmentId();
                if (StringUtils.isBlank(userDept)) {
                    List<DepartmentModel> userDeptList =
                        engineService.getOrganizationFacade().getDepartmentsByUserId(userId);
                    if (CollectionUtils.isNotEmpty(userDeptList)) {
                        userDept = userDeptList.get(0).getId();
                    }
                }
                for (String monthStr : monthMap.keySet()) {
                    double timeLength = monthMap.get(monthStr);
                    // 更新到考勤汇总
                    Map<String, Object> attSummaryMap = Maps.newHashMap();
                    attSummaryMap.put("schemaCode", sc_kqhz);
                    attSummaryMap.put("monthStr", monthStr);
                    attSummaryMap.put("userId", userId);
                    attSummaryMap.put("userDept", userDept);
                    attSummaryMap.put("timeLength", timeLength);
                    attSummaryMap.put("opt", opt);
                    updateAttendanceSummery(attSummaryMap);
                }
            }

            log.info("[人事系统-考勤]：出差数据统计到考勤汇总结束...");
            return ResponseResultUtils.getOkResponseResult(null, "操作成功");
        } catch (Exception e) {
            log.error("[人事系统-考勤]：出差数据统计到考勤汇总异常：{}", e.toString());
            e.printStackTrace();
            return ResponseResultUtils.getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), e.getMessage());
        }
    }

    public String updateAttendanceSummery(Map<String, Object> params) throws Exception {

        String schemaCode = (String)params.get("schemaCode");
        String monthStr = (String)params.get("monthStr");
        String orgUserId = (String)params.get("userId");
        String orgUserDept = (String)params.get("userDept");
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
            // 出差时长
            tableData.put(AttendanceSummaryModel.chuChai, timeLength);
        } else {
            tableData.putAll(formDataMap);
            // 出差时长
            double d = ((BigDecimal)formDataMap.get(AttendanceSummaryModel.chuChai)).doubleValue();

            if (BusRuleOptConstants.OPT_AVAILABLE.equals(opt)) {
                tableData.put(AttendanceSummaryModel.chuChai, d + timeLength);
            } else if (BusRuleOptConstants.OPT_CANCEL.equals(opt) || BusRuleOptConstants.OPT_DELETE.equals(opt)) {
                tableData.put(AttendanceSummaryModel.chuChai, d - timeLength);
            }
        }

        BizObjectModel model = new BizObjectModel(schemaCode, tableData, false);
        String result = engineService.getBizObjectFacade().saveBizObject(orgUserId, model, false);
        return result;
    }

}
