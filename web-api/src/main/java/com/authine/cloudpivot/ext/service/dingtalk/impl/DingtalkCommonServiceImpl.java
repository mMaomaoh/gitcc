package com.authine.cloudpivot.ext.service.dingtalk.impl;

import org.springframework.stereotype.Service;

import com.authine.cloudpivot.ext.service.dingtalk.api.IDingtalkCommonApi;
import com.dingtalk.api.DefaultDingTalkClient;
import com.dingtalk.api.DingTalkClient;
import com.dingtalk.api.request.OapiGettokenRequest;
import com.dingtalk.api.response.OapiGettokenResponse;
import com.taobao.api.ApiException;

import lombok.extern.slf4j.Slf4j;

/**
 * 钉钉开放平台公共接口
 * 
 * @author quyw
 * @date 2022/11/25
 */
@Service
@Slf4j
public class DingtalkCommonServiceImpl implements IDingtalkCommonApi {

    private static final String URL_GETTOKEN = "https://oapi.dingtalk.com/gettoken";

    @Override
    public String getAccessToken(String appKey, String appSecret) {
        log.info("钉钉企业内部应用，获取accessToken开始，appKey={},appSecert={}", appKey, appSecret);

        DingTalkClient client = new DefaultDingTalkClient(URL_GETTOKEN);
        OapiGettokenRequest request = new OapiGettokenRequest();
        request.setAppkey(appKey);
        request.setAppsecret(appSecret);
        request.setHttpMethod("GET");
        OapiGettokenResponse response = null;
        try {
            response = client.execute(request);
        } catch (ApiException e) {
            log.error("钉钉企业内部应用，获取accessToken异常：{}", e);
            e.printStackTrace();
        }
        log.debug("钉钉企业内部应用，获取accessToken结束，response={}", response);
        return response.getAccessToken();
    }

}
