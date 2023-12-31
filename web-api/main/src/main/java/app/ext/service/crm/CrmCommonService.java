package app.ext.service.crm;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.apache.commons.collections.CollectionUtils;
import org.springframework.stereotype.Service;

import com.authine.cloudpivot.engine.api.model.runtime.BizObjectModel;
import com.authine.cloudpivot.engine.component.query.api.FilterExpression;
import com.google.common.collect.Lists;

import app.ext.model.ExtBaseModel;
import app.ext.model.crm.GongHaiModel;
import app.ext.model.crm.KeHuModel;
import app.ext.model.crm.XianSuoModel;
import app.ext.service.BaseCommonService;
import app.ext.util.ExtClassUtils;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class CrmCommonService extends BaseCommonService {

    public static final String USERID_ADMIN = "2c9280a26706a73a016706a93ccf002b";

    public static final String SEQUENCESTATUS_COMPLETED = "COMPLETED";

    public static final String DATASOURCE_CREATE = "新增";
    public static final String DATASOURCE_GONGHAI = "公海";
    public static final String DATASOURCE_KEHU = "客户";
    public static final String DATASOURCE_XIANSUO = "线索";

    public static final String OPT_SOURCE_XIANSUO = "XIANSUO";
    public static final String OPT_SOURCE_KEHU = "KEHU";
    public static final String OPT_SOURCE_GONGHAI = "GONGHAI";

    public List<Map<String, Object>> queryXianSuoDataByObjectIds(String sc_xs, String sc_xs_khlxr,
        List<String> objectIds) throws Exception {
        log.info("[crm]：查询线索表单数据开始...");

        List<Map<String, Object>> list = Lists.newArrayList();
        List<String> columns = ExtClassUtils.getFiledsValue(XianSuoModel.class);
        columns.add(sc_xs_khlxr);

        // 查询条件
        FilterExpression filter = new FilterExpression.Item(ExtBaseModel.id, FilterExpression.Op.In, objectIds);
        List<BizObjectModel> formDataList = super.baseQueryFormData(sc_xs, null, columns, filter);
        if (CollectionUtils.isEmpty(formDataList)) {
            throw new Exception("未查询到数据");
        }

        list = formDataList.stream().map(BizObjectModel::getData).collect(Collectors.toList());
        log.info("[crm]：查询线索表单数据结束...");
        return list;
    }

    public List<Map<String, Object>> queryKeHuDataByObjectIds(String sc_kh, String sc_kh_khlxr, List<String> objectIds)
        throws Exception {
        log.info("[crm]：查询客户表单数据开始...");

        List<Map<String, Object>> list = Lists.newArrayList();
        List<String> columns = ExtClassUtils.getFiledsValue(KeHuModel.class);
        columns.add(sc_kh_khlxr);

        // 查询条件
        FilterExpression filter = new FilterExpression.Item(ExtBaseModel.id, FilterExpression.Op.In, objectIds);
        List<BizObjectModel> formDataList = super.baseQueryFormData(sc_kh, null, columns, filter);
        if (CollectionUtils.isEmpty(formDataList)) {
            throw new Exception("未查询到数据");
        }

        list = formDataList.stream().map(BizObjectModel::getData).collect(Collectors.toList());
        log.info("[crm]：查询客户表单数据结束...");
        return list;
    }

    public List<Map<String, Object>> queryGongHaiDataByObjectIds(String sc_gh, String sc_gh_khlxr,
        List<String> objectIds) throws Exception {
        log.info("[crm]：查询公海表单数据开始...");

        List<Map<String, Object>> list = Lists.newArrayList();
        List<String> columns = ExtClassUtils.getFiledsValue(GongHaiModel.class);
        columns.add(sc_gh_khlxr);

        // 查询条件
        FilterExpression filter = new FilterExpression.Item(ExtBaseModel.id, FilterExpression.Op.In, objectIds);
        List<BizObjectModel> formDataList = super.baseQueryFormData(sc_gh, null, columns, filter);
        if (CollectionUtils.isEmpty(formDataList)) {
            throw new Exception("未查询到数据");
        }

        list = formDataList.stream().map(BizObjectModel::getData).collect(Collectors.toList());
        log.info("[crm]：查询公海表单数据结束...");
        return list;
    }

}
