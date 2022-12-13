package com.authine.cloudpivot.ext.controller;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.authine.cloudpivot.engine.enums.ErrCode;
import com.authine.cloudpivot.ext.service.crm.api.ICrmServiceApi;
import com.authine.cloudpivot.ext.util.ResponseResultUtils;
import com.authine.cloudpivot.web.api.view.ResponseResult;
import com.google.common.collect.Maps;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;

/**
 * crm模块接口
 * 
 * @author quyw
 * @date 2022/12/11
 */
@Api(value = "EXTAPI::crm模块接口", tags = "EXTAPI::crm模块接口")
@RestController
@RequestMapping("/ext/crm/convert")
@Slf4j
public class CrmConvertController {

    @Autowired
    private ICrmServiceApi crmServiceApi;

    @ApiOperation(value = "生成客户编码")
    @PostMapping("/getKeHuCode")
    @ResponseBody
    public Map<String, Object> getList() {
        String uid = UUID.randomUUID().toString();
        String s = uid.split("-")[4];
        LocalDateTime time = LocalDateTime.now();
        String d = time.format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        String code = "KH-" + d + "-" + s.toUpperCase();

        Map<String, Object> data = Maps.newHashMap();
        data.put("data", code);
        return data;
    }

    @ApiOperation(value = "转客户")
    @PostMapping("/toKeHu")
    @ResponseBody
    public ResponseResult<Map<String, Object>> toKeHu(@RequestBody Map<String, Object> params) {
        log.info("[crm]：转客户开始， params={}", params);
        try {
            String userId = (String)params.get("userId");
            List<String> objectIds = (List<String>)params.get("objectIds");
            String optSource = (String)params.get("optSource");
            if (StringUtils.isEmpty(userId)) {
                return ResponseResultUtils.getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), "userId不能为空");
            }
            if (CollectionUtils.isEmpty(objectIds)) {
                return ResponseResultUtils.getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(),
                    "objectIds不能为空");
            }
            if (StringUtils.isBlank(optSource)) {
                return ResponseResultUtils.getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(),
                    "optSource不能为空");
            }

            ResponseResult<Map<String, Object>> result = crmServiceApi.toKeHu(params);
            log.info("[crm]：转客户结束...");
            return result;
        } catch (Exception e) {
            return ResponseResultUtils.getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), e.getMessage());
        }
    }

    @ApiOperation(value = "转线索")
    @PostMapping("/toXianSuo")
    @ResponseBody
    public ResponseResult<Map<String, Object>> toXianSuo(@RequestBody Map<String, Object> params) {
        log.info("[crm]：转线索开始， params={}", params);
        try {
            String userId = (String)params.get("userId");
            List<String> objectIds = (List<String>)params.get("objectIds");
            String optSource = (String)params.get("optSource");
            if (StringUtils.isEmpty(userId)) {
                return ResponseResultUtils.getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), "userId不能为空");
            }
            if (CollectionUtils.isEmpty(objectIds)) {
                return ResponseResultUtils.getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(),
                    "objectIds不能为空");
            }
            if (StringUtils.isBlank(optSource)) {
                return ResponseResultUtils.getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(),
                    "optSource不能为空");
            }

            ResponseResult<Map<String, Object>> result = crmServiceApi.toXianSuo(params);
            log.info("[crm]：转线索结束...");
            return result;
        } catch (Exception e) {
            return ResponseResultUtils.getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), e.getMessage());
        }
    }

    @ApiOperation(value = "转公海")
    @PostMapping("/toGongHai")
    @ResponseBody
    public ResponseResult<Map<String, Object>> toGongHai(@RequestBody Map<String, Object> params) {
        log.info("[crm]：转公海开始， params={}", params);
        try {
            String userId = (String)params.get("userId");
            List<String> objectIds = (List<String>)params.get("objectIds");
            String optSource = (String)params.get("optSource");
            if (StringUtils.isEmpty(userId)) {
                return ResponseResultUtils.getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), "userId不能为空");
            }
            if (CollectionUtils.isEmpty(objectIds)) {
                return ResponseResultUtils.getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(),
                    "objectIds不能为空");
            }
            if (StringUtils.isBlank(optSource)) {
                return ResponseResultUtils.getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(),
                    "optSource不能为空");
            }

            ResponseResult<Map<String, Object>> result = crmServiceApi.toGongHai(params);
            log.info("[crm]：转公海结束...");
            return result;
        } catch (Exception e) {
            return ResponseResultUtils.getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), e.getMessage());
        }
    }

}
