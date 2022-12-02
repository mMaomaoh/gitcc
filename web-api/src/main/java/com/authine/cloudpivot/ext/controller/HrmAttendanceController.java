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
import com.authine.cloudpivot.ext.service.hrm.api.IHrmAttendanceApi;
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
    @ApiOperation(value = "获取考勤明细")
    @PostMapping("/getRecordList")
    @ResponseBody
    public ResponseResult<Map<String, Object>> getRecordList(@RequestBody Map<String, Object> params) throws Exception {
        log.info("[人事系统-考勤]：获取获取考勤明细开始， params={}", params);

        String corpId = (String)params.get("corpId");
        String schemaCode = (String)params.get("schemaCode");
        if (StringUtils.isBlank(corpId)) {
            return getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), "corpId不能为空");
        }
        if (StringUtils.isBlank(schemaCode)) {
            return getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), "schemaCode不能为空");
        }

        ResponseResult<Map<String, Object>> result = hrmAttendanceApi.getAttendanceRecord(params);
        log.info("[人事系统-考勤]：获取获取考勤明细结束...");
        return result;
    }

    /**
     * 加班申请数据统计
     * 
     * @param params
     * @return
     * @throws Exception
     */
    @ApiOperation(value = "加班申请更新调休及考勤汇总")
    @PostMapping("/summaryOvertime")
    @ResponseBody
    public ResponseResult<Map<String, Object>> summaryOvertime(@RequestBody Map<String, Object> params)
        throws Exception {
        log.info("[人事系统-考勤]：加班申请更新调休及考勤汇总开始， params={}", params);

        String objectId = (String)params.get("objectId");
        String sc_jb = (String)params.get("sc_jb");
        String sc_tx = (String)params.get("sc_tx");
        String sc_kqhz = (String)params.get("sc_kqhz");
        if (StringUtils.isBlank(sc_jb)) {
            return getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), "schemaCode不能为空");
        }
        if (StringUtils.isBlank(sc_tx)) {
            return getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), "schemaCode1不能为空");
        }
        if (StringUtils.isBlank(objectId)) {
            return getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), "objectId不能为空");
        }

        ResponseResult<Map<String, Object>> result = hrmAttendanceApi.summaryOvertime(params);
        log.info("[人事系统-考勤]：加班申请更新调休及考勤汇总结束...");
        return result;
    }

}
