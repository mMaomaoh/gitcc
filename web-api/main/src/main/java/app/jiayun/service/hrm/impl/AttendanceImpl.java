package app.jiayun.service.hrm.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.authine.cloudpivot.web.api.view.ResponseResult;

import app.jiayun.service.hrm.AttendanceService;
import app.jiayun.service.hrm.api.IAttendanceApi;

@Service
public class AttendanceImpl implements IAttendanceApi {

    @Autowired
    private AttendanceService attendanceService;

    @Override
    public ResponseResult<?> getColumnVal(Map<String, Object> params) {
        return attendanceService.getColumnVal(params);
    }

}
