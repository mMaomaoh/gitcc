package com.authine.cloudpivot.ext.service.crm;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.authine.cloudpivot.engine.api.model.runtime.BizObjectModel;
import com.authine.cloudpivot.engine.enums.ErrCode;
import com.authine.cloudpivot.ext.model.ExtBaseModel;
import com.authine.cloudpivot.ext.model.crm.GongHaiModel;
import com.authine.cloudpivot.ext.model.crm.KeHuModel;
import com.authine.cloudpivot.ext.model.crm.XianSuoModel;
import com.authine.cloudpivot.ext.service.BaseCommonService;
import com.authine.cloudpivot.ext.util.ResponseResultUtils;
import com.authine.cloudpivot.web.api.view.ResponseResult;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class CrmXianSuoService extends BaseCommonService {

    @Autowired
    private CrmCommonService crmCommonService;

    public ResponseResult<Map<String, Object>> toXianSuo(Map<String, Object> params) {
        log.info("[crm-线索]：转线索开始，params={}", params);
        try {
            String userId = (String)params.get("userId");
            List<String> objectIds = (List<String>)params.get("objectIds");
            String optSource = (String)params.get("optSource");

            String sc_xs = (String)params.get("sc_xs");
            String sc_xs_khlxr = (String)params.get("sc_xs_khlxr");
            if (StringUtils.isBlank(sc_xs)) {
                throw new Exception("sc_kh不能为空");
            }
            if (StringUtils.isBlank(sc_xs_khlxr)) {
                throw new Exception("sc_kh_khlxr不能为空");
            }

            String sc_kh = null;;
            String sc_kh_khlxr = null;
            String sc_gh = null;
            String sc_gh_khlxr = null;

            List<Map<String, Object>> insertDataList = Lists.newArrayList();
            /*
             * 查询客户/公海表
             */
            if (CrmCommonService.OPT_SOURCE_KEHU.equals(optSource)) {
                sc_kh = (String)params.get("sc_kh");
                sc_kh_khlxr = (String)params.get("sc_kh_khlxr");
                if (StringUtils.isBlank(sc_kh)) {
                    throw new Exception("sc_kh不能为空");
                }
                if (StringUtils.isBlank(sc_kh_khlxr)) {
                    throw new Exception("sc_kh_khlxr不能为空");
                }
                // 查询客户
                List<Map<String, Object>> formDataList =
                    crmCommonService.queryKeHuDataByObjectIds(sc_kh, sc_kh_khlxr, objectIds);
                // 待插入的数据
                insertDataList = getInsertDataByKeHu(formDataList, sc_kh_khlxr, sc_xs_khlxr);
            } else if (CrmCommonService.OPT_SOURCE_GONGHAI.equals(optSource)) {
                sc_gh = (String)params.get("sc_kh");
                sc_gh_khlxr = (String)params.get("sc_kh_khlxr");
                if (StringUtils.isBlank(sc_gh)) {
                    throw new Exception("sc_gh不能为空");
                }
                if (StringUtils.isBlank(sc_gh_khlxr)) {
                    throw new Exception("sc_gh_khlxr不能为空");
                }
                // 查询公海表
                List<Map<String, Object>> formDataList =
                    crmCommonService.queryGongHaiDataByObjectIds(sc_gh, sc_gh_khlxr, objectIds);
                // 待插入的数据
                insertDataList = getInsertDataByGongHai(formDataList, sc_gh_khlxr, sc_kh_khlxr);
            }

            /*
             * 新增线索表
             */
            List<String> successIds = Lists.newArrayList();
            for (int i = 0; i < insertDataList.size(); i++) {
                Map<String, Object> tableData = insertDataList.get(i);
                String id = (String)tableData.get("sourceObjectId");
                tableData.remove("sourceObjectId");
                BizObjectModel model = new BizObjectModel(sc_xs, tableData, false);
                String s = engineService.getBizObjectFacade().saveBizObject(userId, model, false);
                if (null != s) {
                    successIds.add(id);
                }
            }

            /*
             * 删除公海/客户表
             */
            if (CrmCommonService.OPT_SOURCE_KEHU.equals(optSource)) {
                for (int i = 0; i < objectIds.size(); i++) {
                    String id = objectIds.get(i);
                    if (successIds.contains(id)) {
                        engineService.getBizObjectFacade().deleteBizObject(sc_kh, id);
                    }
                }
            } else if (CrmCommonService.OPT_SOURCE_GONGHAI.equals(optSource)) {
                for (int i = 0; i < objectIds.size(); i++) {
                    String id = objectIds.get(i);
                    if (successIds.contains(id)) {
                        engineService.getBizObjectFacade().deleteBizObject(sc_gh, id);
                    }
                }
            }

            log.info("[crm-线索]：转线索结束...");
            return ResponseResultUtils.getOkResponseResult(null, "操作成功");
        } catch (Exception e) {
            log.error("[crm-线索]：转线索异常：{}", e.toString());
            e.printStackTrace();
            return ResponseResultUtils.getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), e.getMessage());
        }
    }

    private List<Map<String, Object>> getInsertDataByKeHu(List<Map<String, Object>> formDataList, String sheetSource,
        String sheetTarget) {
        List<Map<String, Object>> insertTableData = Lists.newArrayList();
        for (int i = 0; i < formDataList.size(); i++) {
            Map<String, Object> temp = Maps.newHashMap();
            Map<String, Object> formDataMap = formDataList.get(i);
            temp.put(XianSuoModel.keHuMingCheng, formDataMap.get(KeHuModel.keHuMingCheng));
            temp.put(XianSuoModel.keHuBianMa, formDataMap.get(KeHuModel.keHuBianMa));
            temp.put(XianSuoModel.keHuJiBie, formDataMap.get(KeHuModel.keHuJiBie));
            temp.put(XianSuoModel.qiYeGuiMo, formDataMap.get(KeHuModel.qiYeGuiMo));
            temp.put(XianSuoModel.categoryFirst, formDataMap.get(KeHuModel.categoryFirst));
            temp.put(XianSuoModel.categorySecond, formDataMap.get(KeHuModel.categorySecond));
            temp.put(XianSuoModel.gongSiWangZhi, formDataMap.get(KeHuModel.gongSiWangZhi));
            temp.put(XianSuoModel.keHuZhuYingYeWu, formDataMap.get(KeHuModel.keHuZhuYingYeWu));
            temp.put(XianSuoModel.keHuDiZhi, formDataMap.get(KeHuModel.keHuDiZhi));
            temp.put(XianSuoModel.keHuJingLi, formDataMap.get(KeHuModel.keHuJingLi));
            temp.put(XianSuoModel.keHuJingLiBuMen, formDataMap.get(KeHuModel.keHuJingLiBuMen));

            temp.put(XianSuoModel.dataSource, CrmCommonService.DATASOURCE_KEHU);
            temp.put(XianSuoModel.toXianSuoReason, formDataMap.get(KeHuModel.toXianSuoReason));
            temp.put(XianSuoModel.toXianSuoTime, new Date());

            // 子表
            List<Map<String, Object>> sheetDataList = (List<Map<String, Object>>)formDataMap.get(sheetSource);
            List<Map<String, Object>> sheetList = Lists.newArrayList();
            for (int j = 0; j < sheetDataList.size(); j++) {
                Map<String, Object> sheetMap = sheetDataList.get(j);
                Map<String, Object> t = Maps.newHashMap();
                t.put(XianSuoModel.sheet_keHuName, sheetMap.get(KeHuModel.sheet_keHuName));
                t.put(XianSuoModel.sheet_shouJiHao, sheetMap.get(KeHuModel.sheet_shouJiHao));
                t.put(XianSuoModel.sheet_buMen, sheetMap.get(KeHuModel.sheet_buMen));
                t.put(XianSuoModel.sheet_zhiWei, sheetMap.get(KeHuModel.sheet_zhiWei));
                t.put(XianSuoModel.sheet_beiZhu, sheetMap.get(KeHuModel.sheet_beiZhu));
                sheetList.add(t);
            }
            temp.put(sheetTarget, sheetList);

            temp.put("sourceObjectId", formDataMap.get(ExtBaseModel.id));
            insertTableData.add(temp);
        }
        return insertTableData;
    }

    private List<Map<String, Object>> getInsertDataByGongHai(List<Map<String, Object>> formDataList, String sheetSource,
        String sheetTarget) {
        List<Map<String, Object>> insertTableData = Lists.newArrayList();
        for (int i = 0; i < formDataList.size(); i++) {
            Map<String, Object> temp = Maps.newHashMap();
            Map<String, Object> formDataMap = formDataList.get(i);
            temp.put(XianSuoModel.keHuMingCheng, formDataMap.get(GongHaiModel.keHuMingCheng));
            temp.put(XianSuoModel.keHuBianMa, formDataMap.get(GongHaiModel.keHuBianMa));
            temp.put(XianSuoModel.keHuJiBie, formDataMap.get(GongHaiModel.keHuJiBie));
            temp.put(XianSuoModel.qiYeGuiMo, formDataMap.get(GongHaiModel.qiYeGuiMo));
            temp.put(XianSuoModel.categoryFirst, formDataMap.get(GongHaiModel.categoryFirst));
            temp.put(XianSuoModel.categorySecond, formDataMap.get(GongHaiModel.categorySecond));
            temp.put(XianSuoModel.gongSiWangZhi, formDataMap.get(GongHaiModel.gongSiWangZhi));
            temp.put(XianSuoModel.keHuZhuYingYeWu, formDataMap.get(GongHaiModel.keHuZhuYingYeWu));
            temp.put(XianSuoModel.keHuDiZhi, formDataMap.get(GongHaiModel.keHuDiZhi));
            temp.put(XianSuoModel.keHuJingLi, formDataMap.get(GongHaiModel.keHuJingLi));
            temp.put(XianSuoModel.keHuJingLiBuMen, formDataMap.get(GongHaiModel.keHuJingLiBuMen));

            temp.put(XianSuoModel.dataSource, CrmCommonService.DATASOURCE_GONGHAI);
            temp.put(XianSuoModel.toXianSuoReason, formDataMap.get(GongHaiModel.toXianSuoReason));
            temp.put(XianSuoModel.toXianSuoReason, new Date());

            // 子表
            List<Map<String, Object>> sheetDataList = (List<Map<String, Object>>)formDataMap.get(sheetSource);
            List<Map<String, Object>> sheetList = Lists.newArrayList();
            for (int j = 0; j < sheetDataList.size(); j++) {
                Map<String, Object> sheetMap = sheetDataList.get(j);
                Map<String, Object> t = Maps.newHashMap();
                t.put(XianSuoModel.sheet_keHuName, sheetMap.get(GongHaiModel.sheet_keHuName));
                t.put(XianSuoModel.sheet_shouJiHao, sheetMap.get(GongHaiModel.sheet_shouJiHao));
                t.put(XianSuoModel.sheet_buMen, sheetMap.get(GongHaiModel.sheet_buMen));
                t.put(XianSuoModel.sheet_zhiWei, sheetMap.get(GongHaiModel.sheet_zhiWei));
                t.put(XianSuoModel.sheet_beiZhu, sheetMap.get(GongHaiModel.sheet_beiZhu));
                sheetList.add(t);
            }
            temp.put(sheetTarget, sheetList);

            temp.put("sourceObjectId", formDataMap.get(ExtBaseModel.id));
            insertTableData.add(temp);
        }
        return insertTableData;
    }

}
