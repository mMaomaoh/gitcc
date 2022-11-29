package com.authine.cloudpivot.ext.controller;

import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.authine.cloudpivot.engine.enums.ErrCode;
import com.authine.cloudpivot.ext.service.api.IHrmAttendanceApi;
import com.authine.cloudpivot.web.api.controller.base.BaseController;
import com.authine.cloudpivot.web.api.view.ResponseResult;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

/**
 * 人事考勤模块接口
 * 
 * @author quyw
 * @date 2022/11/25
 */

@Api(value = "EXTAPI::人事考勤模块接口", tags = "EXTAPI::人事考勤模块接口")
@RestController
@RequestMapping("/ext/hrm/attendance")
public class HrmAttendanceController extends BaseController {

    private static Logger log = LoggerFactory.getLogger(HrmAttendanceController.class);

    @Autowired
    private IHrmAttendanceApi hrmAttendanceApi;

    /**
     * 获取钉钉打卡结果
     * 
     * @param params
     * @return
     * @throws Exception
     */
    @ApiOperation(value = "获取钉钉打卡结果")
    @PostMapping("/getRecordList")
    @ResponseBody
    public ResponseResult<Map<String, Object>> getRecordList(@RequestBody Map<String, Object> params) throws Exception {
        log.info("[人事系统-考勤]：controller获取钉钉打卡结果开始， params={}", params);

        String corpId = (String)params.get("corpId");
        if (StringUtils.isBlank(corpId)) {
            return getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), "corpId不能为空");
        }

        ResponseResult<Map<String, Object>> result = hrmAttendanceApi.getAttendanceList(params);
        return result;
    }

}
