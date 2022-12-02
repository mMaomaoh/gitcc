package com.authine.cloudpivot.ext.service.hrm;

import java.util.Map;

import org.springframework.stereotype.Service;

import com.authine.cloudpivot.engine.enums.ErrCode;
import com.authine.cloudpivot.ext.service.BaseCommonService;
import com.authine.cloudpivot.ext.util.ResponseResultUtils;
import com.authine.cloudpivot.web.api.view.ResponseResult;

import lombok.extern.slf4j.Slf4j;

/**
 * 考勤汇总
 * 
 * @author quyw
 * @date 2022/12/02
 */
@Service
@Slf4j
public class AttendanceSummaryService extends BaseCommonService {

    public ResponseResult<Map<String, Object>> summaryAttendance(Map<String, Object> params) {
        log.info("[人事系统-考勤]：更新考勤汇总开始，params={}", params);
        try {
            // 考勤明细业务规则会自动创建汇总
            log.info("[人事系统-考勤]：更新考勤汇总结束...");
            return ResponseResultUtils.getOkResponseResult(null, "操作成功");
        } catch (Exception e) {
            log.error("[人事系统-考勤]：更新考勤汇总异常：{}", e.toString());
            e.printStackTrace();
            return ResponseResultUtils.getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), e.getMessage());
        }

    }

}
