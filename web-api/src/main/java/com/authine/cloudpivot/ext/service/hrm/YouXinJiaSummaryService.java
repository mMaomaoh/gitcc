package com.authine.cloudpivot.ext.service.hrm;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;

import com.authine.cloudpivot.engine.api.model.organization.DepartmentModel;
import com.authine.cloudpivot.engine.api.model.runtime.BizObjectModel;
import com.authine.cloudpivot.engine.api.model.runtime.SelectionValue;
import com.authine.cloudpivot.engine.component.query.api.FilterExpression;
import com.authine.cloudpivot.engine.enums.ErrCode;
import com.authine.cloudpivot.ext.model.ExtBaseModel;
import com.authine.cloudpivot.ext.model.hrm.OvertimeSummaryModel;
import com.authine.cloudpivot.ext.model.hrm.YouXinJiaApplyModel;
import com.authine.cloudpivot.ext.model.hrm.YouXinJiaSummaryModel;
import com.authine.cloudpivot.ext.service.BaseCommonService;
import com.authine.cloudpivot.ext.util.ResponseResultUtils;
import com.authine.cloudpivot.web.api.view.ResponseResult;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;

import lombok.extern.slf4j.Slf4j;

/**
 * 有薪假汇总
 * 
 * @author quyw
 * @date 2022/12/04
 */
@Service
@Slf4j
public class YouXinJiaSummaryService extends BaseCommonService {

    private static final String OPT_AVAILABLE = "AVAILABLE";
    private static final String OPT_CANCEL = "CANCEL";
    private static final String OPT_DELETE = "DELETE";

    public ResponseResult<Map<String, Object>> summaryYouXinJia(Map<String, Object> params) {
        log.info("[人事系统-考勤]：有薪假申请更新有薪假汇总开始，params={}", params);
        try {
            String objectId = (String)params.get("objectId");
            String sc_yxjsq = (String)params.get("sc_yxjsq");
            String sc_yxjhz = (String)params.get("sc_yxjhz");
            String opt = (String)params.get("opt");

            /*
             * 1、薪假申请表单数据
             */
            List<String> columns = Lists.newArrayList();
            columns.add(ExtBaseModel.id);
            columns.add(ExtBaseModel.workflowInstanceId);
            columns.add(ExtBaseModel.sequenceStatus);
            columns.add(YouXinJiaApplyModel.leaveUser);
            columns.add(YouXinJiaApplyModel.timeLength);
            columns.add(YouXinJiaApplyModel.years);
            columns.add(YouXinJiaApplyModel.rpaidTimesRemainder);
            // 查询条件
            FilterExpression filter = new FilterExpression.Item(ExtBaseModel.id, FilterExpression.Op.Eq, objectId);
            List<BizObjectModel> formDataList = super.baseQueryFormData(sc_yxjsq, null, columns, filter);
            if (CollectionUtils.isEmpty(formDataList)) {
                throw new Exception("未查询到数据");
            } else if (formDataList.size() > 1) {
                throw new Exception("查询结果异常");
            }
            Map<String, Object> formDataMap = formDataList.get(0).getData();

            // 如果已经作废了流程，删除数据则不更新汇总，进行中的流程删除也不触发更新汇总
            String workflowInstanceId = (String)formDataMap.get(ExtBaseModel.workflowInstanceId);
            String sequenceStatus = (String)formDataMap.get(ExtBaseModel.sequenceStatus);
            if (OPT_DELETE.equals(opt)) {
                if (StringUtils.isNotBlank(workflowInstanceId)) {
                    if ("CANCELED".equals(sequenceStatus) || "PROCESSING".equals(sequenceStatus)) {
                        return ResponseResultUtils.getOkResponseResult(null, "操作成功");
                    }
                }
            }

            LocalDateTime years = ((Timestamp)formDataMap.get(YouXinJiaApplyModel.years)).toLocalDateTime();
            double timeLength = ((BigDecimal)formDataMap.get(YouXinJiaApplyModel.timeLength)).doubleValue();
            List<SelectionValue> userList = (List<SelectionValue>)formDataMap.get(YouXinJiaApplyModel.leaveUser);

            /*
             * 2、更新到薪假汇总
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
                // 更新到薪假汇总
                updateYouXinJiaSummary(opt, sc_yxjhz, uid, userDept, years, timeLength);
            }

            log.info("[人事系统-考勤]：有薪假申请更新有薪假汇总结束...");
            return ResponseResultUtils.getOkResponseResult(null, "操作成功");
        } catch (Exception e) {
            log.error("[人事系统-考勤]：有薪假申请更新有薪假汇总异常：{}", e.toString());
            e.printStackTrace();
            return ResponseResultUtils.getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), e.getMessage());
        }
    }

    private String updateYouXinJiaSummary(String opt, String schemaCode, String orgUserId, String orgUserDept,
        LocalDateTime years, double timeLength) throws Exception {

        // 查询有薪假汇总
        List<String> columns = Lists.newArrayList();
        columns.add(YouXinJiaSummaryModel.userName);
        columns.add(YouXinJiaSummaryModel.userDept);
        columns.add(YouXinJiaSummaryModel.years);
        columns.add(YouXinJiaSummaryModel.repaidTimesRemainder);
        // 查询条件
        List<FilterExpression> filterList = Lists.newArrayList();
        filterList.add(
            new FilterExpression.Item(OvertimeSummaryModel.years, FilterExpression.Op.Eq, Timestamp.valueOf(years)));
        filterList.add(new FilterExpression.Item(OvertimeSummaryModel.userName, FilterExpression.Op.Eq, orgUserId));
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
            if (OPT_DELETE.equals(opt) || OPT_CANCEL.equals(opt)) {
                // 删除数据，作废流程不触发新增
                return null;
            }
            tableData.put(YouXinJiaSummaryModel.userName, orgUserId);
            tableData.put(YouXinJiaSummaryModel.userDept, orgUserDept);
            tableData.put(YouXinJiaSummaryModel.years, Timestamp.valueOf(years));
            tableData.put(YouXinJiaSummaryModel.repaidTimesRemainder, timeLength);
        } else {
            double d = ((BigDecimal)formDataMap.get(YouXinJiaSummaryModel.repaidTimesRemainder)).doubleValue();
            tableData.putAll(formDataMap);
            if (OPT_AVAILABLE.equals(opt)) {
                tableData.put(YouXinJiaSummaryModel.repaidTimesRemainder, timeLength + d);
            } else if (OPT_CANCEL.equals(opt) || OPT_DELETE.equals(opt)) {
                tableData.put(YouXinJiaSummaryModel.repaidTimesRemainder, d - timeLength);
            }
        }

        BizObjectModel model = new BizObjectModel(schemaCode, tableData, false);
        String result = engineService.getBizObjectFacade().saveBizObject(orgUserId, model, true);
        return result;
    }

}
