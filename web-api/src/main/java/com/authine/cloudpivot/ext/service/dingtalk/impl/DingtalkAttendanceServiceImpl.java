package com.authine.cloudpivot.ext.service.dingtalk.impl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.alibaba.fastjson.JSONObject;
import com.authine.cloudpivot.ext.service.dingtalk.api.IDingtalkAttendanceApi;
import com.dingtalk.api.DefaultDingTalkClient;
import com.dingtalk.api.DingTalkClient;
import com.dingtalk.api.request.OapiAttendanceListRequest;
import com.dingtalk.api.response.OapiAttendanceListResponse;
import com.taobao.api.ApiException;

import lombok.extern.slf4j.Slf4j;

/**
 * 钉钉考勤接口
 * 
 * @author quyw
 * @date 2022/11/25
 */
@Service
@Slf4j
public class DingtalkAttendanceServiceImpl implements IDingtalkAttendanceApi {

    private static final String URL_ATTENDANCE_LIST = "https://oapi.dingtalk.com/attendance/list";

    @Override
    public JSONObject getAttendanceList(Map<String, Object> params) {
        log.debug("钉钉企业内部应用，获取考勤打卡结果开始，params={}", params);

        String accessToken = (String)params.get("accessToken");
        String workDateFrom = (String)params.get("workDateFrom");
        String workDateTo = (String)params.get("workDateTo");
        List<String> userIdList = (List<String>)params.get("UserIdList");
        long offset = (long)params.get("offset");
        long limit = (long)params.get("limit");

        // 通过调用接口获取考勤打卡结果
        DingTalkClient clientDingTalkClient = new DefaultDingTalkClient(URL_ATTENDANCE_LIST);
        OapiAttendanceListRequest requestAttendanceListRequest = new OapiAttendanceListRequest();
        // 查询考勤打卡记录的起始工作日
        requestAttendanceListRequest.setWorkDateFrom(workDateFrom);
        // 查询考勤打卡记录的结束工作日
        requestAttendanceListRequest.setWorkDateTo(workDateTo);
        // 员工在企业内的userid列表，最多不能超过50个。
        requestAttendanceListRequest.setUserIdList(userIdList);
        // 表示获取考勤数据的起始点
        requestAttendanceListRequest.setOffset(offset);
        // 表示获取考勤数据的条数，最大不能超过50条。
        requestAttendanceListRequest.setLimit(limit);
        OapiAttendanceListResponse response = null;
        try {
            response = clientDingTalkClient.execute(requestAttendanceListRequest, accessToken);
        } catch (ApiException e) {
            log.error("钉钉企业内部应用，获取考勤打卡结果异常：", e);
            e.printStackTrace();
        }

        JSONObject result = JSONObject.parseObject(response.getBody(), JSONObject.class);

        log.debug("钉钉企业内部应用，获取考勤打卡结果结束，result-size={}", result.size());
        return result;

    }

}
