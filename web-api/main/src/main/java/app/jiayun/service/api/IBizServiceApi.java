package app.jiayun.service.api;

import java.util.Map;

import com.authine.cloudpivot.web.api.view.ResponseResult;

public interface IBizServiceApi {

    /**
     * 客户跟进转公海
     * 
     * @param params
     * @return
     */
    ResponseResult<Map<String, Object>> convertToGongHai(Map<String, Object> params);

}
