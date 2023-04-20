package app.jiayun.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.authine.cloudpivot.engine.enums.ErrCode;
import com.authine.cloudpivot.web.api.view.ResponseResult;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;

import app.ext.util.ResponseResultUtils;
import app.jiayun.service.hrm.api.IAttendanceApi;
import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/jiayun/hrm")
@Slf4j
public class AttendanceController {

    @Autowired
    private IAttendanceApi attendanceApi;

    @PostMapping("/getList")
    @ResponseBody
    public Map<String, Object> getList() {
        /*
         * 该接口无具体业务含义，确保返回一条list格式数据即可
         */
        Map<String, Object> data = Maps.newHashMap();
        data.put("total", 1);

        Map<String, Object> content = Maps.newHashMap();
        content.put("a", "test");
        List<Map<String, Object>> list = Lists.newArrayList();
        list.add(content);

        data.put("content", list);
        return data;
    }

    @PostMapping("/getColumnVal")
    @ResponseBody
    public ResponseResult<?> getRecordList() {
        try {
            String corpId = "ding147bfb1d294eb7364ac5d6980864d335";
            String schemaCode = "JiaYun_KaoQinMingXi";

            Map<String, Object> params = new HashMap<>();
            params.put("corpId", corpId);
            params.put("schemaCode", schemaCode);

            ResponseResult<?> result = attendanceApi.getColumnVal(params);
            return result;
        } catch (Exception e) {
            return ResponseResultUtils.getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), e.getMessage());
        }
    }

}
