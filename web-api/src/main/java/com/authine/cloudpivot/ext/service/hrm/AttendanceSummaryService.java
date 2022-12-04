package com.authine.cloudpivot.ext.service.hrm;

import java.util.Map;

import org.springframework.stereotype.Service;

import com.authine.cloudpivot.engine.enums.ErrCode;
import com.authine.cloudpivot.ext.model.hrm.AttendanceSummaryModel;
import com.authine.cloudpivot.ext.service.BaseCommonService;
import com.authine.cloudpivot.ext.util.ResponseResultUtils;
import com.authine.cloudpivot.web.api.view.ResponseResult;
import com.google.common.collect.Maps;

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

    @Deprecated
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

    public Map<String, Object> initTableData() {
        Map<String, Object> tableData = Maps.newHashMap();

        tableData.put(AttendanceSummaryModel.realWorkDays, 0.0);
        // tableData.put(AttendanceSummaryModel.shouldWorkDays, 0.0);
        tableData.put(AttendanceSummaryModel.queKaShu, 0.0);
        tableData.put(AttendanceSummaryModel.chiDaoShu, 0.0);
        tableData.put(AttendanceSummaryModel.chiDaoTimes, 0.0);
        tableData.put(AttendanceSummaryModel.zaoTuiShu, 0.0);
        tableData.put(AttendanceSummaryModel.zaoTuiTimes, 0.0);

        tableData.put(AttendanceSummaryModel.shiJia, 0.0);
        tableData.put(AttendanceSummaryModel.bingJia, 0.0);
        tableData.put(AttendanceSummaryModel.sangJia, 0.0);
        tableData.put(AttendanceSummaryModel.hunJia, 0.0);
        tableData.put(AttendanceSummaryModel.chanJia, 0.0);
        tableData.put(AttendanceSummaryModel.peiChanJia, 0.0);
        tableData.put(AttendanceSummaryModel.chanJianJia, 0.0);
        tableData.put(AttendanceSummaryModel.tiaoXiu, 0.0);
        tableData.put(AttendanceSummaryModel.nianJia, 0.0);
        tableData.put(AttendanceSummaryModel.youxXinJia, 0.0);
        tableData.put(AttendanceSummaryModel.qiTaQingJia, 0.0);

        tableData.put(AttendanceSummaryModel.jieJiaRiJiaBan, 0.0);
        tableData.put(AttendanceSummaryModel.gongZuoRiJiaBan, 0.0);
        tableData.put(AttendanceSummaryModel.xiuXiRiJiaBan, 0.0);
        tableData.put(AttendanceSummaryModel.jieSuanXinZiJiaBan, 0.0);
        tableData.put(AttendanceSummaryModel.jieSuanTiaoXiuJiaBan, 0.0);
        tableData.put(AttendanceSummaryModel.jieSuanQiTaJiaBan, 0.0);

        return tableData;
    }

}
