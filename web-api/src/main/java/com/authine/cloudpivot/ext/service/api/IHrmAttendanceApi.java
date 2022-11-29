package com.authine.cloudpivot.ext.service.api;

import java.util.Map;

import com.authine.cloudpivot.web.api.view.ResponseResult;

public interface IHrmAttendanceApi {

    ResponseResult<Map<String, Object>> getAttendanceList(Map<String, Object> params);

}
