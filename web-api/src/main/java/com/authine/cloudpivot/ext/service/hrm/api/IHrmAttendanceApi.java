package com.authine.cloudpivot.ext.service.hrm.api;

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

}
