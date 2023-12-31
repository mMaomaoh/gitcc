package app.ext.service.hrm.api;

import java.util.Map;

import com.authine.cloudpivot.web.api.view.ResponseResult;

public interface IHrmAttendanceApi {

    /**
     * 获取考勤明细
     * 
     * @param params
     * @return
     */
    ResponseResult<Map<String, Object>> getAttendanceRecord(Map<String, Object> params);

    /**
     * 汇总加班数据到调休统计和考勤汇总
     *
     * @param params
     * @return
     */
    ResponseResult<Map<String, Object>> summaryOvertime(Map<String, Object> params);

    /**
     * 有薪假申请更新有薪假汇总
     * 
     * @param params
     * @return
     */
    ResponseResult<Map<String, Object>> summaryYouXinJia(Map<String, Object> params);

    /**
     * 休假数据统计到考勤汇总
     * 
     * @param params
     * @return
     */
    ResponseResult<Map<String, Object>> summaryLeave(Map<String, Object> params);

    /**
     * 出差数据统计到考勤汇总
     * 
     * @param params
     * @return
     */
    ResponseResult<Map<String, Object>> summaryBusinessTrip(Map<String, Object> params);

}
