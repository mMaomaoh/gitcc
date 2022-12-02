// package com.authine.cloudpivot.ext.service.hrm;
//
// import java.math.BigDecimal;
// import java.sql.Timestamp;
// import java.time.LocalDateTime;
// import java.util.List;
// import java.util.Map;
//
// import org.apache.commons.collections.CollectionUtils;
// import org.apache.commons.collections.MapUtils;
// import org.springframework.stereotype.Service;
//
// import com.authine.cloudpivot.engine.api.model.runtime.BizObjectModel;
// import com.authine.cloudpivot.engine.api.model.runtime.SelectionValue;
// import com.authine.cloudpivot.engine.component.query.api.FilterExpression;
// import com.authine.cloudpivot.engine.enums.ErrCode;
// import com.authine.cloudpivot.ext.model.ExtBaseModel;
// import com.authine.cloudpivot.ext.model.hrm.AttendanceSummaryModel;
// import com.authine.cloudpivot.ext.model.hrm.LeaveApplyModel;
// import com.authine.cloudpivot.ext.util.ResponseResultUtils;
// import com.authine.cloudpivot.web.api.view.ResponseResult;
// import com.google.common.collect.Lists;
// import com.google.common.collect.Maps;
//
// import lombok.extern.slf4j.Slf4j;
//
/// **
// * 休假申请
// *
// * @author quyw
// * @date 2022/12/02
// */
// @Service
// @Slf4j
// public class LeaveApplyService {
//
// public ResponseResult<Map<String, Object>> summaryLeave(Map<String, Object> params) {
// log.info("[人事系统-考勤]：休假数据统计到考勤汇总开始，params={}", params);
// try {
// String objectId = (String)params.get("objectId");
// String schemaCode = (String)params.get("schemaCode");
// // 考勤汇总表schemacode
// String schemaCode1 = (String)params.get("schemaCode1");
//
// /*
// * 查询请假数据
// */
// List<String> columns = Lists.newArrayList();
// columns.add(ExtBaseModel.id);
// // columns.add(LeaveApplyModel.userName);
// // columns.add(LeaveApplyModel.qingJiaLeiXing);
// // columns.add(LeaveApplyModel.sheet1669733916460);
// // 查询条件
// FilterExpression filter = new FilterExpression.Item(ExtBaseModel.id, FilterExpression.Op.Eq, objectId);
// List<BizObjectModel> formData = super.baseQueryFormData(schemaCode, null, columns, filter);
// if (CollectionUtils.isEmpty(formData)) {
// throw new Exception("未查询到数据");
// } else if (formData.size() > 1) {
// throw new Exception("查询结果异常");
// }
// Map<String, Object> formMap = formData.get(0).getData();
//
// /*
// * 计算休假类型或日期是否月或跨年（因为考勤汇总是按月统计）
// */
// Map<String, Double> monthMap = Maps.newHashMap();
// List<SelectionValue> selection = (List<SelectionValue>)formMap.get(LeaveApplyModel.userName);
// String userId = selection.get(0).getId();
// String leaveType = (String)formMap.get(LeaveApplyModel.qingJiaLeiXing);
// List<Map<String, Object>> leaveDetail =
// (List<Map<String, Object>>)formMap.get(LeaveApplyModel.sheet1669733916460);
// for (Map<String, Object> map : leaveDetail) {
// LocalDateTime date = ((Timestamp)map.get(LeaveApplyModel.sheet_qingJiaRiQi)).toLocalDateTime();
// int year = date.getYear();
// int month = date.getMonthValue();
// double timeLength = ((BigDecimal)map.get(LeaveApplyModel.sheet_shiChang)).doubleValue();
// String m = String.valueOf(month);
// String key = String.valueOf(year) + "-" + (m.length() > 1 ? m : "0".concat(m));
// if (monthMap.containsKey(key)) {
// timeLength = timeLength + monthMap.get(key);
// }
// monthMap.put(key, timeLength);
// }
//
// /*
// * 根据月份查询考勤汇总表
// */
// for (String key : monthMap.keySet()) {
// Map<String, Object> map = getAttendanceSummery(schemaCode1, key, userId);
// if (MapUtils.isEmpty(map)) {
// // insert
// } else {
// // update
// String id = (String)map.get(ExtBaseModel.id);
// Map<String, Object> tableData = Maps.newHashMap();
// tableData.put(ExtBaseModel.id, id);
//
// if ("事假".equals(leaveType)) {
// tableData.put(AttendanceSummaryModel.shiJia, monthMap.get(key));
// }
//
// BizObjectModel model = new BizObjectModel(schemaCode1, tableData, false);
// String result = engineService.getBizObjectFacade().saveBizObject(userId, model, false);
// System.out.println(result);
// }
// }
//
// log.info("[人事系统-考勤]：休假数据统计到考勤汇总结束...");
// return ResponseResultUtils.getOkResponseResult(null, "操作成功");
// } catch (Exception e) {
// log.error("[人事系统-考勤]：休假数据统计到考勤汇总异常：{}", e.toString());
// e.printStackTrace();
// return ResponseResultUtils.getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), e.getMessage());
// }
// }
//
// }
