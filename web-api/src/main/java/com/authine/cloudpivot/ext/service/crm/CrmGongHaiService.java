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
public class CrmGongHaiService extends BaseCommonService {

    @Autowired
    private CrmCommonService crmCommonService;

    public ResponseResult<Map<String, Object>> toGongHai(Map<String, Object> params) {
        log.info("[crm-公海]：转公海开始，params={}", params);
        try {
            String userId = (String)params.get("userId");
            List<String> objectIds = (List<String>)params.get("objectIds");
            String optSource = (String)params.get("optSource");

            String sc_gh = (String)params.get("sc_gh");
            String sc_gh_khlxr = (String)params.get("sc_gh_khlxr");
            if (StringUtils.isBlank(sc_gh)) {
                throw new Exception("sc_gh不能为空");
            }
            if (StringUtils.isBlank(sc_gh_khlxr)) {
                throw new Exception("sc_gh_khlxr不能为空");
            }

            String sc_xs = null;;
            String sc_xs_khlxr = null;
            String sc_kh = null;
            String sc_kh_khlxr = null;

            List<Map<String, Object>> insertDataList = Lists.newArrayList();
            /*
             * 查询线索/客户表
             */
            if (CrmCommonService.OPT_SOURCE_XIANSUO.equals(optSource)) {
                sc_xs = (String)params.get("sc_xs");
                sc_xs_khlxr = (String)params.get("sc_xs_khlxr");
                if (StringUtils.isBlank(sc_xs)) {
                    throw new Exception("sc_xs不能为空");
                }
                if (StringUtils.isBlank(sc_xs_khlxr)) {
                    throw new Exception("sc_xs_khlxr不能为空");
                }
                // 查询线索表
                List<Map<String, Object>> formDataList =
                    crmCommonService.queryXianSuoDataByObjectIds(sc_xs, sc_xs_khlxr, objectIds);
                // 待插入的数据
                insertDataList = getInsertDataByXianSuo(formDataList, sc_xs_khlxr, sc_gh_khlxr);
            } else if (CrmCommonService.OPT_SOURCE_KEHU.equals(optSource)) {
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
                insertDataList = getInsertDataByKeHu(formDataList, sc_kh_khlxr, sc_gh_khlxr);
            }

            /*
             * 新增公海
             */
            List<String> successIds = Lists.newArrayList();
            for (int i = 0; i < insertDataList.size(); i++) {
                Map<String, Object> tableData = insertDataList.get(i);
                String id = (String)tableData.get("sourceObjectId");
                tableData.remove("sourceObjectId");
                BizObjectModel model = new BizObjectModel(sc_gh, tableData, false);
                String s = engineService.getBizObjectFacade().saveBizObject(userId, model, false);
                if (null == s) {
                    successIds.add(id);
                }
            }

            /*
             * 删除客户/线索表
             */
            if (CrmCommonService.OPT_SOURCE_XIANSUO.equals(optSource)) {
                for (int i = 0; i < objectIds.size(); i++) {
                    String id = objectIds.get(i);
                    if (successIds.contains(id)) {
                        engineService.getBizObjectFacade().deleteBizObject(sc_xs, id);
                    }
                }
            } else if (CrmCommonService.OPT_SOURCE_KEHU.equals(optSource)) {
                for (int i = 0; i < objectIds.size(); i++) {
                    String id = objectIds.get(i);
                    if (successIds.contains(id)) {
                        engineService.getBizObjectFacade().deleteBizObject(sc_kh, id);
                    }
                }
            }

            log.info("[crm-公海]：转公海结束...");
            return ResponseResultUtils.getOkResponseResult(null, "操作成功");
        } catch (Exception e) {
            log.error("[crm-公海]：转公海异常：{}", e.toString());
            e.printStackTrace();
            return ResponseResultUtils.getErrResponseResult(null, ErrCode.UNKNOW_ERROR.getErrCode(), e.getMessage());
        }
    }

    private List<Map<String, Object>> getInsertDataByXianSuo(List<Map<String, Object>> formDataList, String sheetSource,
        String sheetTarget) {
        List<Map<String, Object>> insertTableData = Lists.newArrayList();
        for (int i = 0; i < formDataList.size(); i++) {
            Map<String, Object> temp = Maps.newHashMap();
            Map<String, Object> formDataMap = formDataList.get(i);
            temp.put(GongHaiModel.keHuMingCheng, formDataMap.get(XianSuoModel.keHuMingCheng));
            temp.put(GongHaiModel.sequenceNo, formDataMap.get(XianSuoModel.sequenceNo));
            temp.put(GongHaiModel.keHuJiBie, formDataMap.get(XianSuoModel.keHuJiBie));
            temp.put(GongHaiModel.qiYeGuiMo, formDataMap.get(XianSuoModel.qiYeGuiMo));
            temp.put(GongHaiModel.categoryFirst, formDataMap.get(XianSuoModel.categoryFirst));
            temp.put(GongHaiModel.categorySecond, formDataMap.get(XianSuoModel.categorySecond));
            temp.put(GongHaiModel.gongSiWangZhi, formDataMap.get(XianSuoModel.gongSiWangZhi));
            temp.put(GongHaiModel.keHuZhuYingYeWu, formDataMap.get(XianSuoModel.keHuZhuYingYeWu));
            temp.put(GongHaiModel.keHuDiZhi, formDataMap.get(XianSuoModel.keHuDiZhi));
            temp.put(GongHaiModel.keHuJingLi, formDataMap.get(XianSuoModel.keHuJingLi));
            temp.put(GongHaiModel.keHuJingLiBuMen, formDataMap.get(XianSuoModel.keHuJingLiBuMen));

            temp.put(GongHaiModel.dataSource, CrmCommonService.DATASOURCE_XIANSUO);
            temp.put(GongHaiModel.toGongHaiReason, formDataMap.get(XianSuoModel.toKeHuReason));
            temp.put(GongHaiModel.toGongHaiTime, new Date());

            // 子表
            List<Map<String, Object>> sheetDataList = (List<Map<String, Object>>)formDataMap.get(sheetSource);
            List<Map<String, Object>> sheetList = Lists.newArrayList();
            for (int j = 0; j < sheetDataList.size(); j++) {
                Map<String, Object> sheetMap = sheetDataList.get(j);
                Map<String, Object> t = sheetDataList.get(j);
                t.put(GongHaiModel.sheet_keHuName, sheetMap.get(XianSuoModel.sheet_keHuName));
                t.put(GongHaiModel.sheet_shouJiHao, sheetMap.get(XianSuoModel.sheet_shouJiHao));
                t.put(GongHaiModel.sheet_buMen, sheetMap.get(XianSuoModel.sheet_buMen));
                t.put(GongHaiModel.sheet_zhiWei, sheetMap.get(XianSuoModel.sheet_zhiWei));
                t.put(GongHaiModel.sheet_beiZhu, sheetMap.get(XianSuoModel.sheet_beiZhu));
                sheetList.add(t);
            }
            temp.put(sheetTarget, sheetList);

            temp.put("sourceObjectId", formDataMap.get(ExtBaseModel.id));
            insertTableData.add(temp);
        }
        return insertTableData;
    }

    private List<Map<String, Object>> getInsertDataByKeHu(List<Map<String, Object>> formDataList, String sheetSource,
        String sheetTarget) {
        List<Map<String, Object>> insertTableData = Lists.newArrayList();
        for (int i = 0; i < formDataList.size(); i++) {
            Map<String, Object> temp = Maps.newHashMap();
            Map<String, Object> formDataMap = formDataList.get(i);
            temp.put(GongHaiModel.keHuMingCheng, formDataMap.get(KeHuModel.keHuMingCheng));
            temp.put(GongHaiModel.sequenceNo, formDataMap.get(KeHuModel.sequenceNo));
            temp.put(GongHaiModel.keHuJiBie, formDataMap.get(KeHuModel.keHuJiBie));
            temp.put(GongHaiModel.qiYeGuiMo, formDataMap.get(KeHuModel.qiYeGuiMo));
            temp.put(GongHaiModel.categoryFirst, formDataMap.get(KeHuModel.categoryFirst));
            temp.put(GongHaiModel.categorySecond, formDataMap.get(KeHuModel.categorySecond));
            temp.put(GongHaiModel.gongSiWangZhi, formDataMap.get(KeHuModel.gongSiWangZhi));
            temp.put(GongHaiModel.keHuZhuYingYeWu, formDataMap.get(KeHuModel.keHuZhuYingYeWu));
            temp.put(GongHaiModel.keHuDiZhi, formDataMap.get(KeHuModel.keHuDiZhi));
            temp.put(GongHaiModel.keHuJingLi, formDataMap.get(KeHuModel.keHuJingLi));
            temp.put(GongHaiModel.keHuJingLiBuMen, formDataMap.get(KeHuModel.keHuJingLiBuMen));

            temp.put(GongHaiModel.dataSource, crmCommonService.DATASOURCE_KEHU);
            temp.put(GongHaiModel.toGongHaiReason, formDataMap.get(KeHuModel.toKeHuReason));
            temp.put(GongHaiModel.toGongHaiTime, new Date());

            // 子表
            List<Map<String, Object>> sheetDataList = (List<Map<String, Object>>)formDataMap.get(sheetSource);
            List<Map<String, Object>> sheetList = Lists.newArrayList();
            for (int j = 0; j < sheetDataList.size(); j++) {
                Map<String, Object> sheetMap = sheetDataList.get(j);
                Map<String, Object> t = sheetDataList.get(j);
                t.put(GongHaiModel.sheet_keHuName, sheetMap.get(KeHuModel.sheet_keHuName));
                t.put(GongHaiModel.sheet_shouJiHao, sheetMap.get(KeHuModel.sheet_shouJiHao));
                t.put(GongHaiModel.sheet_buMen, sheetMap.get(KeHuModel.sheet_buMen));
                t.put(GongHaiModel.sheet_zhiWei, sheetMap.get(KeHuModel.sheet_zhiWei));
                t.put(GongHaiModel.sheet_beiZhu, sheetMap.get(KeHuModel.sheet_beiZhu));
                sheetList.add(t);
            }
            temp.put(sheetTarget, sheetList);

            temp.put("sourceObjectId", formDataMap.get(ExtBaseModel.id));
            insertTableData.add(temp);
        }
        return insertTableData;
    }

}
