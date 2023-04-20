package app.jiayun.service.hrm.api;

import java.util.Map;

import com.authine.cloudpivot.web.api.view.ResponseResult;

public interface IAttendanceApi {

    ResponseResult<?> getColumnVal(Map<String, Object> params);

}
