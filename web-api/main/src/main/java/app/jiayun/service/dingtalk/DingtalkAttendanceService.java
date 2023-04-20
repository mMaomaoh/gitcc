package app.jiayun.service.dingtalk;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.alibaba.fastjson.JSONObject;
import com.dingtalk.api.DefaultDingTalkClient;
import com.dingtalk.api.DingTalkClient;
import com.dingtalk.api.request.OapiAttendanceGetcolumnvalRequest;
import com.dingtalk.api.response.OapiAttendanceGetcolumnvalResponse;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class DingtalkAttendanceService {

    private static final String URL_COLUMNVAL = "https://oapi.dingtalk.com/topapi/attendance/getcolumnval";

    public JSONObject getColumnVal(String token, Map<String, Object> params) {
        log.info("钉钉企业内部应用，获取考勤列表值开始...");

        JSONObject result = new JSONObject();

        try {
            DingTalkClient client = new DefaultDingTalkClient(URL_COLUMNVAL);
            OapiAttendanceGetcolumnvalRequest req = new OapiAttendanceGetcolumnvalRequest();
            req.setUserid(params.get("userId").toString());
            req.setColumnIdList(params.get("columnList").toString());
            req.setFromDate(parseDate(params.get("fromDate").toString()));
            req.setToDate(parseDate(params.get("toDate").toString()));
            OapiAttendanceGetcolumnvalResponse response = null;
            response = client.execute(req, token);

            result = JSONObject.parseObject(response.getBody(), JSONObject.class);
        } catch (Exception e) {
            log.error("钉钉企业内部应用，获取考勤列表值异常：{}", e);
            e.printStackTrace();
        }

        log.debug("钉钉企业内部应用，获取考勤列表值结束...");
        return result;
    }

    private Date parseDate(String str) throws ParseException {
        return new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(str);
    }

}
