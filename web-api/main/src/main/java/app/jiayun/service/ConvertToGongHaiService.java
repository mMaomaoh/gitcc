package app.jiayun.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;

import com.authine.cloudpivot.engine.api.model.runtime.BizObjectModel;
import com.authine.cloudpivot.engine.component.query.api.FilterExpression;
import com.authine.cloudpivot.engine.enums.ErrCode;
import com.authine.cloudpivot.web.api.view.ResponseResult;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;

import app.ext.util.ResponseResultUtils;
import lombok.extern.slf4j.Slf4j;

/**
 * 从跟进记录转公海
 * 
 * @author quyw
 * @date 2023/03/15
 */
@Service
@Slf4j
public class ConvertToGongHaiService extends JiayunBizCommonService {

    public ResponseResult<Map<String, Object>> convertToGongHai(Map<String, Object> params) {
        try {
            /*
             * （1）往公海新增一条数据-成功获取数据ID
             * （2）更新跟进表关联公海线索/关联公海客户=数据ID
             * （3）删除线索/客户
             */
            String userId = (String)params.get("userId");
            String objectId = (String)params.get("objectId");
            String genJinType = (String)params.get("genJinType");
            String xs_objId = (String)params.get("xs_objId");
            String kh_objId = (String)params.get("kh_objId");

            /*
             * （1）往公海新增一条数据-成功获取数据ID
             */
            String dataId = null;
            if (genJinType.equals("线索")) {
                // 1、查询线索表数据
                List<Map<String, Object>> list = queryXianSuoByObjectId(xs_objId);
                Map<String, Object> map = list.get(0);
                // 2、往公海新增一条数据-成功获取数据ID
                Map<String, Object> insertMap = getInsertData(genJinType, map);
                dataId = insertToGongHai(userId, insertMap);

                // 3、跟进记录表更新
                Map<String, Object> updateMap = Maps.newHashMap();
                updateMap.put("id", objectId);
                updateMap.put("dataId", dataId);
                String resultStr = updateGenJin(userId, genJinType, updateMap);

                // 4、删除线索表数据
                if (StringUtils.isNotBlank(resultStr)) {
                    engineService.getBizObjectFacade().deleteBizObject("JiaYun_ShiChangXianSuo", xs_objId);
                }
            } else if (genJinType.equals("客户")) {
                // 1、查询客户表数据
                List<Map<String, Object>> list = queryKeHuByObjectId(kh_objId);
                Map<String, Object> map = list.get(0);

                // 2、往公海新增一条数据-成功获取数据ID
                Map<String, Object> insertMap = getInsertData(genJinType, map);
                dataId = insertToGongHai(userId, insertMap);

                // 3、跟进记录表更新
                Map<String, Object> updateMap = Maps.newHashMap();
                updateMap.put("id", objectId);
                updateMap.put("dataId", dataId);
                String resultStr = updateGenJin(userId, genJinType, updateMap);

                // 4、删除客户表数据
                // if (StringUtils.isNotBlank(resultStr)) {
                // engineService.getBizObjectFacade().deleteBizObject("JiaYun_KeHuGuanLi", kh_objId);
                // }
            } else {
                log.error("[jiayun-bus]：转公海异常：跟进类型未匹配");
                return ResponseResultUtils.getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), "跟进类型未匹配");
            }

            return ResponseResultUtils.getOkResponseResult(null, "操作成功");
        } catch (Exception e) {
            log.error("[jiayun-bus]：转公海异常：{}", e.toString());
            e.printStackTrace();
            return ResponseResultUtils.getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), e.getMessage());
        }
    }

    private List<Map<String, Object>> queryXianSuoByObjectId(String objectId) throws Exception {
        log.info("[jiayun-bus]：查询线索表单数据开始...");

        List<Map<String, Object>> list = Lists.newArrayList();
        List<String> columns = new ArrayList<>();
        columns.add("keHuName");
        columns.add("xinYongCode");
        columns.add("keHuBianHao");
        columns.add("hangYeFenLei");
        columns.add("juTiHangYe");
        columns.add("qiYeGuiMo");
        columns.add("qiYeLianXiRen");
        columns.add("qiYeLianXiRenZhiWei");
        columns.add("lianXiDianHua");
        columns.add("keHuAddress");
        // 查询条件
        FilterExpression filter = new FilterExpression.Item("id", FilterExpression.Op.Eq, objectId);
        List<BizObjectModel> formDataList = super.baseQueryFormData("JiaYun_ShiChangXianSuo", null, columns, filter);
        if (CollectionUtils.isEmpty(formDataList)) {
            throw new Exception("未查询到数据");
        }
        list = formDataList.stream().map(BizObjectModel::getData).collect(Collectors.toList());
        log.info("[jiayun-biz]：查询线索表单数据结束...");
        return list;
    }

    private List<Map<String, Object>> queryKeHuByObjectId(String objectId) throws Exception {
        log.info("[jiayun-bus]：查询客户表单数据开始...");
        List<Map<String, Object>> list = Lists.newArrayList();
        List<String> columns = new ArrayList<>();
        columns.add("keHuName");
        columns.add("xinYongCode");
        columns.add("keHuBianHao");
        columns.add("keHuManager");
        columns.add("hangYeFenLei");
        columns.add("juTiHangYe");
        columns.add("qiYeGuiMo");
        columns.add("qiYeLianXiRen");
        columns.add("qiYeLianXiRenZhiWei");
        columns.add("lianXiDianHua");
        columns.add("keHuAddress");
        columns.add("keHuZhuYinYeWu");
        columns.add("keHuDengJi");
        columns.add("shangNianTongLeiTouRu");
        columns.add("keHuNianJinYinLiRun");
        columns.add("keHuXinXiHuaXianZhuang");
        columns.add("keHuXuQiuShuZiHua");
        columns.add("keHuXuQiuQiYeFuWu");
        columns.add("keHuDuiJie");
        columns.add("keHuDuiJieZhiWei");
        columns.add("duiJieRenDianHua");
        columns.add("keHuJueCeRen");
        columns.add("keHuJueCeRenZhiWei");
        columns.add("jueCeRenDianHua");
        columns.add("keHuJuJianRen");
        columns.add("keHuJuJianRenZhiWei");
        columns.add("juJianRenDianHua");
        // 查询条件
        FilterExpression filter = new FilterExpression.Item("id", FilterExpression.Op.Eq, objectId);
        List<BizObjectModel> formDataList = super.baseQueryFormData("JiaYun_KeHuGuanLi", null, columns, filter);
        if (CollectionUtils.isEmpty(formDataList)) {
            throw new Exception("未查询到数据");
        }

        list = formDataList.stream().map(BizObjectModel::getData).collect(Collectors.toList());
        log.info("[jiayun-bus]：查询客户表单数据结束...");
        return list;
    }

    private String insertToGongHai(String userId, Map<String, Object> dataMap) throws Exception {
        if (MapUtils.isEmpty(dataMap)) {
            throw new Exception("待新增的数据为空");
        }
        BizObjectModel model = new BizObjectModel("JiaYun_GongHaiGuanLi", dataMap, false);
        String objectId = engineService.getBizObjectFacade().saveBizObject(userId, model, false);
        return objectId;
    }

    private Map<String, Object> getInsertData(String type, Map<String, Object> data) {
        // map是公海表数据，data是线索或者客户查出来的数据
        Map<String, Object> map = new HashMap<>();
        if (type.equals("线索")) {
            map.put("shuJuLaiYuan", "线索");
            map.put("keHuName", data.get("keHuName"));
            map.put("xinYongCode", data.get("xinYongCode"));
            map.put("keHuBianHao", data.get("keHuBianHao"));
            map.put("keHuManager", data.get("keHuManager"));
            map.put("hangYeFenLei", data.get("hangYeFenLei"));
            map.put("juTiHangYe", data.get("juTiHangYe"));
            map.put("qiYeGuiMo", data.get("qiYeGuiMo"));
            map.put("qiYeLianXiRen", data.get("qiYeLianXiRen"));
            map.put("lianXiDianHua", data.get("lianXiDianHua"));
            map.put("qiYeLianXiRenZhiWei", data.get("qiYeLianXiRenZhiWei"));
            map.put("keHuAddress", data.get("keHuAddress"));
        } else if (type.equals("客户")) {
            map.put("shuJuLaiYuan", "客户");
            map.put("keHuName", data.get("keHuName"));
            map.put("xinYongCode", data.get("xinYongCode"));
            map.put("keHuBianHao", data.get("keHuBianHao"));
            map.put("keHuManager", data.get("keHuManager"));
            map.put("hangYeFenLei", data.get("hangYeFenLei"));
            map.put("juTiHangYe", data.get("juTiHangYe"));
            map.put("qiYeGuiMo", data.get("qiYeGuiMo"));
            map.put("qiYeLianXiRen", data.get("qiYeLianXiRen"));
            map.put("qiYeLianXiRenZhiWei", data.get("qiYeLianXiRenZhiWei"));
            map.put("lianXiDianHua", data.get("lianXiDianHua"));
            map.put("keHuZhuYinYeWu", data.get("keHuZhuYinYeWu"));
            map.put("keHuDengJi", data.get("keHuDengJi"));
            map.put("shangNianTongLeiTouRu", data.get("shangNianTongLeiTouRu"));
            map.put("keHuNianJinYinLiRun", data.get("keHuNianJinYinLiRun"));
            map.put("keHuXinXiHuaXianZhuang", data.get("keHuXinXiHuaXianZhuang"));
            map.put("keHuXuQiuShuZiHua", data.get("keHuXuQiuShuZiHua"));
            map.put("keHuXuQiuQiYeFuWu", data.get("keHuXuQiuQiYeFuWu"));
            map.put("keHuDuiJie", data.get("keHuDuiJie"));
            map.put("keHuDuiJieZhiWei", data.get("keHuDuiJieZhiWei"));
            map.put("duiJieRenDianHua", data.get("duiJieRenDianHua"));
            map.put("keHuJueCeRen", data.get("keHuJueCeRen"));
            map.put("keHuJueCeRenZhiWei", data.get("keHuJueCeRenZhiWei"));
            map.put("jueCeRenDianHua", data.get("jueCeRenDianHua"));
            map.put("keHuJuJianRen", data.get("keHuJuJianRen"));
            map.put("keHuJuJianRenZhiWei", data.get("keHuJuJianRenZhiWei"));
            map.put("juJianRenDianHua", data.get("juJianRenDianHua"));
            map.put("keHuZhuYinYeWu", data.get("keHuZhuYinYeWu"));
            map.put("keHuAddress", data.get("keHuAddress"));
            map.put("relevanceKeHu", data.get("id"));
        }
        return map;
    }

    private String updateGenJin(String userId, String type, Map<String, Object> params) throws Exception {
        Map<String, Object> tableData = Maps.newHashMap();
        tableData.put("id", params.get("id"));
        tableData.put("guanLianGongHai", params.get("dataId"));

        BizObjectModel model = new BizObjectModel("JiaYun_KeHuGenJin", tableData, false);
        String result = engineService.getBizObjectFacade().saveBizObject(userId, model, true);

        log.debug("[jiayun-bus] 跟进记录更新完成，result={}", result);

        return result;
    }

}
