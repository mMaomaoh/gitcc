package app.jiayun.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.authine.cloudpivot.engine.api.model.bizquery.BizQueryHeaderModel;
import com.authine.cloudpivot.engine.api.model.runtime.BizObjectModel;
import com.authine.cloudpivot.engine.api.model.runtime.BizObjectQueryModel;
import com.authine.cloudpivot.engine.component.query.api.FilterExpression;
import com.authine.cloudpivot.engine.component.query.api.Page;
import com.authine.cloudpivot.engine.enums.type.QueryDisplayType;
import com.authine.cloudpivot.web.api.service.EngineService;
import com.google.common.collect.Lists;

import lombok.extern.slf4j.Slf4j;

/**
 * 公共服务类
 * 
 * @author quyw
 * @date 2021/09/03
 */
@Service
@Slf4j
public class JiayunBizCommonService {

    @Autowired
    protected EngineService engineService;

    // @Autowired
    // private RedisTemplate<String, Object> redisTemplate;

    public HttpServletRequest getRequest() {
        return ((ServletRequestAttributes)RequestContextHolder.getRequestAttributes()).getRequest();
    }

    /**
     * 根据schemaCode获取queryCode
     * 
     * @param schemaCode
     * @return
     * @throws Exception
     */
    public String getQueryCode(String schemaCode) throws Exception {
        String queryCode = null;
        if (StringUtils.isBlank(schemaCode)) {
            throw new Exception("schemaCode不能为空");
        }
        List<BizQueryHeaderModel> list = engineService.getAppManagementFacade().getBizQueryHeaders(schemaCode);
        for (int i = 0; i < list.size(); i++) {
            BizQueryHeaderModel model = list.get(i);
            // QueryPresentationType type = model.getQueryPresentationType();
            // 导入应用似乎type=null
            // if (QueryPresentationType.LIST.getIndex().equals(type.getIndex()) && model.getPublish()
            if (model.getPublish() && model.getShowOnPc()) {
                // 取第一个pc视图
                queryCode = model.getCode();
                break;
            }
        }
        if (null == queryCode) {
            throw new Exception("queryCode为空");
        }
        return queryCode;
    }

    /**
     * 表单数据查询公共方法
     * 
     * @param schemaCode
     * @param queryCode
     * @param columns
     * @param filter
     * @return
     * @throws Exception
     */
    @SuppressWarnings("unchecked")
    public List<BizObjectModel> baseQueryFormData(String schemaCode, String queryCode, List<String> columns,
        FilterExpression filter) throws Exception {
        log
            .info("baseQueryFormData start..., schemaCode={}, queryCode={}, columns={}, filter={}", schemaCode,
                  queryCode, columns, filter);
        BizObjectQueryModel.Options options = new BizObjectQueryModel.Options();
        options.setQueryDisplayType(QueryDisplayType.APPEND);
        options.setCustomDisplayColumns(columns);

        BizObjectQueryModel query = new BizObjectQueryModel();
        query.setOptions(options);
        if (null != filter) {
            query.setFilterExpr(filter);
        }
        query.setSchemaCode(schemaCode);
        if (StringUtils.isBlank(queryCode)) {
            queryCode = this.getQueryCode(schemaCode);
        }
        query.setQueryCode(queryCode);

        Page<BizObjectModel> resultPage = engineService.getBizObjectFacade().queryBizObjects(query);
        List<BizObjectModel> content = Lists.newArrayList();
        if (resultPage != null) {
            content = (List<BizObjectModel>)resultPage.getContent();
        }

        log.info("baseQueryFormData end...");
        return content;
    }

}
