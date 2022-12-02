package com.authine.cloudpivot.ext.service.hrm.dingtalk.api;

import java.util.Map;

import com.alibaba.fastjson.JSONObject;

public interface IDingtalkAttendanceApi {

    JSONObject getAttendanceList(Map<String, Object> params);

}
