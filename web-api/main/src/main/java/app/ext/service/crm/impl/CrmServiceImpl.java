package app.ext.service.crm.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.authine.cloudpivot.web.api.view.ResponseResult;

import app.ext.service.crm.CrmGongHaiService;
import app.ext.service.crm.CrmKeHuService;
import app.ext.service.crm.CrmXianSuoService;
import app.ext.service.crm.api.ICrmServiceApi;

/**
 * 人事考勤模块接口
 * 
 * @author quyw
 * @date 2022/11/25
 */
@Service
public class CrmServiceImpl implements ICrmServiceApi {

    @Autowired
    private CrmKeHuService crmKeHuService;
    @Autowired
    private CrmGongHaiService crmGongHaiService;
    @Autowired
    private CrmXianSuoService crmXianSuoService;

    @Override
    public ResponseResult<Map<String, Object>> toKeHu(Map<String, Object> params) {
        return crmKeHuService.toKeHu(params);
    }

    @Override
    public ResponseResult<Map<String, Object>> toGongHai(Map<String, Object> params) {
        return crmGongHaiService.toGongHai(params);
    }

    @Override
    public ResponseResult<Map<String, Object>> toXianSuo(Map<String, Object> params) {
        return crmXianSuoService.toXianSuo(params);
    }

}
