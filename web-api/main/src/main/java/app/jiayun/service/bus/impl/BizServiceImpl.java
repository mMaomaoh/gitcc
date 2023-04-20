package app.jiayun.service.bus.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.authine.cloudpivot.web.api.view.ResponseResult;

import app.jiayun.service.bus.ConvertToGongHaiService;
import app.jiayun.service.bus.api.IBizServiceApi;

@Service
public class BizServiceImpl implements IBizServiceApi {

    @Autowired
    private ConvertToGongHaiService convertToGongHaiService;

    @Override
    public ResponseResult<Map<String, Object>> convertToGongHai(Map<String, Object> params) {
        return convertToGongHaiService.convertToGongHai(params);
    }

}
