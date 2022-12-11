package com.authine.cloudpivot.ext.service.crm.api;

import java.util.Map;

import com.authine.cloudpivot.web.api.view.ResponseResult;

public interface ICrmServiceApi {

    /**
     * 转客户
     * 
     * @param params
     * @return
     */
    ResponseResult<Map<String, Object>> toKeHu(Map<String, Object> params);

    /**
     * 转公海
     *
     * @param params
     * @return
     */
    ResponseResult<Map<String, Object>> toGongHai(Map<String, Object> params);

    /**
     * 转线索
     * 
     * @param params
     * @return
     */
    ResponseResult<Map<String, Object>> toXianSuo(Map<String, Object> params);

}
