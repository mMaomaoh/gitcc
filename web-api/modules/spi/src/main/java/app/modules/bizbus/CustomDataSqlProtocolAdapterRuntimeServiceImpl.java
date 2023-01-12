package app.modules.bizbus;

import com.alibaba.fastjson.JSON;
import com.authine.cloudpivot.engine.api.exceptions.ServiceException;
import com.authine.cloudpivot.engine.api.model.bizservice.BizServiceMethodModel;
import com.authine.cloudpivot.engine.api.model.bizservice.ParameterModel;
import com.authine.cloudpivot.engine.api.utils.ModelUtil;
import com.authine.cloudpivot.engine.domain.bizservice.BizDatabaseConnectionPool;
import com.authine.cloudpivot.engine.enums.ErrCode;
import com.authine.cloudpivot.engine.enums.type.bizservice.MethodReturnType;
import com.authine.cloudpivot.engine.service.bizservice.BizDatabaseConnectionPoolService;
import com.authine.cloudpivot.engine.service.bizservice.BizServiceMethodService;
import com.authine.cloudpivot.engine.service.datasource.DataSourceService;
import com.authine.cloudpivot.engine.service.datasource.MyColumnMapRowMapper;
import com.authine.cloudpivot.engine.service.impl.datasource.TemplateDynamicMultiDataSource;
import com.authine.cloudpivot.engine.service.metadata.vo.DatabaseMethodConfigVO;
import com.authine.cloudpivot.engine.service.util.MapOpsUtil;
import com.authine.cloudpivot.engine.spi.metadata.Options;
import com.authine.cloudpivot.engine.spi.metadata.vo.BaseMethodConfigVO;
import com.authine.cloudpivot.engine.spi.metadata.vo.ServiceConfigVO;
import com.authine.cloudpivot.engine.spi.runtime.ProtocolAdapterRuntimeService;
import com.google.common.collect.Maps;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DataAccessException;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.dao.IncorrectResultSizeDataAccessException;
import org.springframework.dao.InvalidDataAccessApiUsageException;
import org.springframework.dao.TransientDataAccessResourceException;
import org.springframework.jdbc.BadSqlGrammarException;
import org.springframework.jdbc.UncategorizedSQLException;
import org.springframework.util.Assert;

import java.sql.SQLException;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * @author luoee
 * @date 2022/12/5
 */
@Slf4j
public class CustomDataSqlProtocolAdapterRuntimeServiceImpl implements ProtocolAdapterRuntimeService {

    private final ServiceConfigVO bizServiceConfig;
    private final String bizServiceCode;
    private BizServiceMethodService bizServiceMethodService;
    private BizDatabaseConnectionPoolService connectionPoolService;

    public CustomDataSqlProtocolAdapterRuntimeServiceImpl(BizServiceMethodService bizServiceMethodService,
                                                          BizDatabaseConnectionPoolService connectionPoolService,
                                                          String bizServiceCode, ServiceConfigVO bizServiceConfig) {
        this.bizServiceMethodService = bizServiceMethodService;
        this.bizServiceCode = bizServiceCode;
        this.bizServiceConfig = bizServiceConfig;
        this.connectionPoolService = connectionPoolService;
    }


    @Override
    public BizServiceMethodModel getBizServiceMethod(String bizServiceMethodCode) {
        return null;
    }

    public List<BizServiceMethodModel> getBizServiceMethods() {
        return ModelUtil.toModel(bizServiceMethodService.getListByServiceCode(bizServiceCode), BizServiceMethodModel.class);
    }

    @Override
    public Object invoke(String bizServiceMethodCode, Map<String, Object> args, Options options) {
        if (log.isDebugEnabled()) {
            log.debug("bizServiceMethodCode = {}, args = {}, options = {}", bizServiceMethodCode, args, JSON.toJSONString(options));
        }
        Optional<BizServiceMethodModel> optional = getBizServiceMethods().stream().filter(bs -> bizServiceMethodCode.equals(bs.getCode())).findAny();
        if (optional.isPresent()) {
            BizServiceMethodModel serviceMethod = optional.get();
            DatabaseMethodConfigVO configVO = (DatabaseMethodConfigVO) getConfig(serviceMethod.getConfigJson());
            MethodReturnType returnType = configVO.getReturnType();
            String sql = configVO.getSql();
            String countSql = configVO.getCountSql();
            if (log.isDebugEnabled()) {
                log.debug("returnType = {}, sql = {},countSql={}", returnType, sql, countSql);
            }
            String dbConnPoolCode = bizServiceConfig.getDbConnPoolCode();
            BizDatabaseConnectionPool connectionPool = connectionPoolService.getByCode(dbConnPoolCode);

            if(connectionPool == null){
                throw new ServiceException(ErrCode.BIZ_DATA_BASE_POOL_CODE_INVALID, "数据库连接池编码无效");
            }
            String datasourceType = connectionPool.getDatasourceType();
            String databaseType = connectionPool.getDatabaseType();
            String jdbcUrl = connectionPool.getJdbcUrl();
            String username = connectionPool.getUsername();
            String password = connectionPool.getPasswordDecode();
            String driverClassName = connectionPool.getDriverClassName();
            List<ParameterModel> inputParameters = serviceMethod.getInputParameterModels();
            Map<String, Object> paramMap = MapOpsUtil.map(inputParameters, args);
            Integer pageIndex = (Integer) paramMap.get("pageIndex");
            Integer pageSize = (Integer) paramMap.get("pageSize");
            if (pageIndex != null && pageSize != null) {
                if ("MySql".equals(databaseType)) {
                    pageIndex = pageIndex * pageSize;
                } else if ("Oracle".equals(databaseType)) {
                    pageIndex = (pageIndex + 1) * pageSize;
                    pageSize = pageIndex - pageSize;
                } else if("SqlServer" .equals(databaseType)){
                    int tmp = pageIndex;
                    pageIndex = pageSize;
                    pageSize = tmp * pageSize;
                }
            }
            if (pageIndex != null && pageIndex < 0) {
                pageIndex = 0;
            }
            if (pageSize != null && pageSize < 0) {
                pageSize = 0;
            }
            paramMap.put("pageIndex", pageIndex);
            paramMap.put("pageSize", pageSize);
            if (log.isDebugEnabled()) {
                log.debug("paramMap= {}", paramMap);
            }
            HashMap<String, Object> tempMap = new HashMap<>(paramMap);
            tempMap.entrySet().removeIf(el -> "pageIndex".equals(el.getKey()) || "pageSize".equals(el.getKey()));

//            DBManager dbManager = DynamicMultiDataSource.getDBManager(dbConnPoolCode, databaseType,driverClassName, jdbcUrl, username, password);
            String type = datasourceType + "." + databaseType;
            DataSourceService dataSourceService = (DataSourceService) TemplateDynamicMultiDataSource.
                    getDataSourceService(dbConnPoolCode, type, JSON.toJSONString(connectionPool));
            try {
                Object result;
                if (MethodReturnType.SingleObject == returnType) {
                    result = dataSourceService.getJdbcTemplate().queryForObject(sql, paramMap, new MyColumnMapRowMapper());
                    Assert.state(result != null, "No result map");

                    if (log.isDebugEnabled()) {
                        log.debug("single result = {}.", result);
                    }

                } else if (MethodReturnType.List == returnType) {
                    List<Map<String, Object>> list = dataSourceService.getJdbcTemplate().query(sql, paramMap, new MyColumnMapRowMapper());
                    Map<String, Object> countMap = dataSourceService.getJdbcTemplate().queryForMap(countSql, tempMap);
                    Map<String, Object> mapValue = Maps.newHashMap();
                    mapValue.put("data", list);
                    mapValue.put("count", countMap.get("count"));
                    result = mapValue;

                    if (log.isTraceEnabled()) {
                        log.trace("list result = {}.", result);
                    }

                } else {
                    result = dataSourceService.getJdbcTemplate().update(sql, paramMap);

                    if (log.isDebugEnabled()) {
                        log.debug("update result = {}.", result);
                    }
                }
                return result;
            } catch (DataAccessException e) {
                log.error("sql execute error.", e);
                String errMsg = e.getMessage();
                log.error("errMsg = {}.", errMsg);
                if (e instanceof EmptyResultDataAccessException) {
                    return Collections.EMPTY_MAP;
                } else if (e instanceof IncorrectResultSizeDataAccessException) {
                    ServiceException serviceException =
                            new ServiceException(ErrCode.BIZ_SERVICE_SQL_EXECUTE_INCORRECT_RESULT_SIZE);
                    serviceException.initCause(e);
                    throw serviceException;
                } else if (e instanceof BadSqlGrammarException) {
                    ServiceException serviceException = new ServiceException(ErrCode.BIZ_SERVICE_SQL_BAD_GRAMMAR, sql);
                    serviceException.initCause(e);
                    throw serviceException;
                } else if (e instanceof InvalidDataAccessApiUsageException) {
                    ServiceException serviceException = new ServiceException(ErrCode.BIZ_SERVICE_SQL_INVALID_DATA_ACCESS, sql);
                    serviceException.initCause(e);
                    throw serviceException;
                }
                ServiceException exception = new ServiceException(ErrCode.BIZ_SERVICE_SQL_EXECUTE_FAILED.getErrCode()
                        , errMsg, paramMap);
                exception.initCause(e);
                throw exception;
            }
        }

        log.info("service method can not found.");
        return null;
    }

    @Override
    public BaseMethodConfigVO getConfig(String configJson){
        return JSON.parseObject(configJson, DatabaseMethodConfigVO.class);
    }
}
