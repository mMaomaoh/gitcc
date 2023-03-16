package app.jiayun.controller;

import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.authine.cloudpivot.engine.enums.ErrCode;
import com.authine.cloudpivot.web.api.controller.base.BaseController;
import com.authine.cloudpivot.web.api.view.ResponseResult;

import app.ext.util.ResponseResultUtils;
import app.jiayun.service.api.IBizServiceApi;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;

/**
 * crm模块接口
 * 
 * @author quyw
 * @date 2022/12/11
 */
@Api(value = "JIAYUN::客户跟进转公海", tags = "JIAYUN::客户跟进转公海")
@RestController
@RequestMapping("/jiayun/bus")
@Slf4j
public class ConvertToGongHaiController extends BaseController {

    @Autowired
    private IBizServiceApi bizServiceApi;

    @ApiOperation(value = "从跟进记录转公海")
    @PostMapping("/genJinToGongHai")
    @ResponseBody
    public ResponseResult<Map<String, Object>> toKeHu(@RequestBody Map<String, Object> params) {
        log.info("[jiayun-bus]：从跟进记录转公海开始， params={}", params);
        try {
            String objectId = (String)params.get("objectId");
            String genJinType = (String)params.get("genJinType");
            String xs_objId = (String)params.get("xs_objId");
            String kh_objId = (String)params.get("kh_objId");

            Object obj = params.get("userId");
            String userId = null;
            if (obj instanceof List) {
                List<Map<String, Object>> user = (List<Map<String, Object>>)params.get("userId");
                userId = (String)user.get(0).get("id");
            } else {
                userId = obj.toString();
            }
            if (StringUtils.isEmpty(userId)) {
                return ResponseResultUtils.getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), "userId不能为空");
            }
            params.put("userId", userId);

            if (StringUtils.isEmpty(objectId)) {
                return ResponseResultUtils
                    .getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), "objectId不能为空");
            }
            if (StringUtils.isBlank(genJinType)) {
                return ResponseResultUtils
                    .getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), "genJinType不能为空");
            }
            if (genJinType.equals("线索")) {
                if (StringUtils.isEmpty(xs_objId)) {
                    return ResponseResultUtils
                        .getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), "xs_objId不能为空");
                }
            } else if (genJinType.equals("客户")) {
                if (StringUtils.isEmpty(kh_objId)) {
                    return ResponseResultUtils
                        .getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), "kh_objId不能为空");
                }
            }

            ResponseResult<Map<String, Object>> result = bizServiceApi.convertToGongHai(params);
            log.info("[jiayun-bus]从跟进记录转公海结束...");
            return result;
        } catch (Exception e) {
            return ResponseResultUtils.getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), e.getMessage());
        }
    }

}
