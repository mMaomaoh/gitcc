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
import lombok.extern.slf4j.Slf4j;

/**
 * 人事考勤模块接口
 * 
 * @author quyw
 * @date 2022/11/25
 */

@Api(value = "EXTAPI::人事考勤模块接口", tags = "EXTAPI::人事考勤模块接口")
@RestController
@RequestMapping("/ext/hrm/attendance")
@Slf4j
public class HrmAttendanceController extends BaseController {

    private static Logger log = LoggerFactory.getLogger(HrmAttendanceController.class);

    @Autowired
    private IHrmAttendanceApi hrmAttendanceApi;

    /**
     * 获取钉钉打卡结果
     * 
     * @param params
     * @return
     */
    @ApiOperation(value = "获取考勤明细")
    @PostMapping("/getRecordList")
    @ResponseBody
    public ResponseResult<Map<String, Object>> getRecordList(@RequestBody Map<String, Object> params) {
        log.info("[人事系统-考勤]：获取获取考勤明细开始， params={}", params);
        try {
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
        } catch (Exception e) {
            return getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), e.getMessage());
        }
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
    public ResponseResult<Map<String, Object>> summaryOvertime(@RequestBody Map<String, Object> params) {
        log.info("[人事系统-考勤]：加班申请更新调休及考勤汇总开始， params={}", params);
        try {
            String objectId = (String)params.get("objectId");
            String sc_jb = (String)params.get("sc_jb");
            String sc_tx = (String)params.get("sc_tx");
            String sc_kqhz = (String)params.get("sc_kqhz");
            // 流程生效=AVAILABLE，流程作废=CANCEL，数据删除=DELETE
            String opt = (String)params.get("opt");
            if (StringUtils.isBlank(sc_jb)) {
                return getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), "sc_jb不能为空");
            }
            if (StringUtils.isBlank(sc_tx)) {
                return getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), "sc_tx不能为空");
            }
            if (StringUtils.isBlank(sc_kqhz)) {
                return getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), "sc_kqhz不能为空");
            }
            if (StringUtils.isBlank(objectId)) {
                return getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), "objectId不能为空");
            }
            if (StringUtils.isBlank(opt)) {
                return getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), "opt不能为空");
            }

            ResponseResult<Map<String, Object>> result = hrmAttendanceApi.summaryOvertime(params);
            log.info("[人事系统-考勤]：加班申请更新调休及考勤汇总结束...");
            return result;
        } catch (Exception e) {
            return getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), e.getMessage());
        }
    }

    @ApiOperation(value = "有薪假申请更新有薪假汇总")
    @PostMapping("/summaryYouXinJia")
    @ResponseBody
    public ResponseResult<Map<String, Object>> summaryYouXinJia(@RequestBody Map<String, Object> params) {
        log.info("[人事系统-考勤]：有薪假申请更新有薪假汇总开始， params={}", params);
        try {
            String objectId = (String)params.get("objectId");
            String sc_yxjsq = (String)params.get("sc_yxjsq");
            String sc_yxjhz = (String)params.get("sc_yxjhz");
            // 流程生效=AVAILABLE，流程作废=CANCEL，数据删除=DELETE
            String opt = (String)params.get("opt");
            if (StringUtils.isBlank(sc_yxjsq)) {
                return getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), "sc_yxjsq不能为空");
            }
            if (StringUtils.isBlank(sc_yxjhz)) {
                return getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), "sc_yxjhz不能为空");
            }
            if (StringUtils.isBlank(objectId)) {
                return getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), "objectId不能为空");
            }
            if (StringUtils.isBlank(opt)) {
                return getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), "opt不能为空");
            }

            ResponseResult<Map<String, Object>> result = hrmAttendanceApi.summaryYouXinJia(params);
            log.info("[人事系统-考勤]：有薪假申请更新有薪假汇总结束...");
            return result;
        } catch (Exception e) {
            return getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), e.getMessage());
        }
    }

    @ApiOperation(value = "休假数据统计到考勤汇总")
    @PostMapping("/summaryLeave")
    @ResponseBody
    public ResponseResult<Map<String, Object>> summaryLeave(@RequestBody Map<String, Object> params) {
        log.info("[人事系统-考勤]：休假数据统计到考勤汇总开始， params={}", params);
        try {
            String objectId = (String)params.get("objectId");
            String sc_xjsq = (String)params.get("sc_xjsq");
            String sc_xjsq_sheet = (String)params.get("sc_xjsq_sheet");
            String sc_kqhz = (String)params.get("sc_kqhz");
            // 流程生效=AVAILABLE，流程作废=CANCEL，数据删除=DELETE
            String opt = (String)params.get("opt");
            if (StringUtils.isBlank(sc_xjsq)) {
                return getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), "sc_xjsq不能为空");
            }
            if (StringUtils.isBlank(sc_xjsq_sheet)) {
                return getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), "sc_xjsq_sheet不能为空");
            }
            if (StringUtils.isBlank(sc_kqhz)) {
                return getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), "sc_kqhz不能为空");
            }
            if (StringUtils.isBlank(objectId)) {
                return getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), "objectId不能为空");
            }
            if (StringUtils.isBlank(opt)) {
                return getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), "opt不能为空");
            }

            ResponseResult<Map<String, Object>> result = hrmAttendanceApi.summaryLeave(params);
            log.info("[人事系统-考勤]：休假数据统计到考勤汇总结束...");
            return result;
        } catch (Exception e) {
            return getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), e.getMessage());
        }
    }

    @ApiOperation(value = "出差数据统计到考勤汇总")
    @PostMapping("/summaryBusinessTrip")
    @ResponseBody
    public ResponseResult<Map<String, Object>> summaryBusinessTrip(@RequestBody Map<String, Object> params) {
        log.info("[人事系统-考勤]：出差数据统计到考勤汇总开始， params={}", params);
        try {
            String objectId = (String)params.get("objectId");
            String sc_ccsq = (String)params.get("sc_ccsq");
            String sc_ccsq_sheet = (String)params.get("sc_ccsq_sheet");
            String sc_kqhz = (String)params.get("sc_kqhz");
            // 流程生效=AVAILABLE，流程作废=CANCEL，数据删除=DELETE
            String opt = (String)params.get("opt");
            if (StringUtils.isBlank(sc_ccsq)) {
                return getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), "sc_ccsq不能为空");
            }
            if (StringUtils.isBlank(sc_ccsq_sheet)) {
                return getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), "sc_ccsq_sheet不能为空");
            }
            if (StringUtils.isBlank(sc_kqhz)) {
                return getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), "sc_kqhz不能为空");
            }
            if (StringUtils.isBlank(objectId)) {
                return getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), "objectId不能为空");
            }
            if (StringUtils.isBlank(opt)) {
                return getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), "opt不能为空");
            }

            ResponseResult<Map<String, Object>> result = hrmAttendanceApi.summaryBusinessTrip(params);
            log.info("[人事系统-考勤]：出差数据统计到考勤汇总结束...");
            return result;
        } catch (Exception e) {
            return getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), e.getMessage());
        }
    }

}
