package com.authine.cloudpivot.ext.service.hrm.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.authine.cloudpivot.ext.service.hrm.AttendanceDetailService;
import com.authine.cloudpivot.ext.service.hrm.LeaveSummaryService;
import com.authine.cloudpivot.ext.service.hrm.OvertimeSummaryService;
import com.authine.cloudpivot.ext.service.hrm.YouXinJiaSummaryService;
import com.authine.cloudpivot.ext.service.hrm.api.IHrmAttendanceApi;
import com.authine.cloudpivot.web.api.view.ResponseResult;

/**
 * 人事考勤模块接口
 * 
 * @author quyw
 * @date 2022/11/25
 */
@Service
public class HrmAttendanceServiceImpl implements IHrmAttendanceApi {

    @Autowired
    private AttendanceDetailService attendanceDetailService;
    @Autowired
    private OvertimeSummaryService overtimeSummaryService;
    @Autowired
    private YouXinJiaSummaryService youXinJiaSummaryService;
    @Autowired
    private LeaveSummaryService leaveSummaryService;

    @Override
    public ResponseResult<Map<String, Object>> getAttendanceRecord(Map<String, Object> params) {
        return attendanceDetailService.getAttendanceRecord(params);
    }

    @Override
    public ResponseResult<Map<String, Object>> summaryOvertime(Map<String, Object> params) {
        return overtimeSummaryService.summaryOvertime(params);
    }

    @Override
    public ResponseResult<Map<String, Object>> summaryYouXinJia(Map<String, Object> params) {
        return youXinJiaSummaryService.summaryYouXinJia(params);
    }

    @Override
    public ResponseResult<Map<String, Object>> summaryLeave(Map<String, Object> params) {
        return leaveSummaryService.summaryLeave(params);
    }

}
