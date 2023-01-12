package app.modules.orm.gauss;


import com.authine.cloudpivot.engine.api.model.runtime.OrgBatchSqlGenObject;
import com.authine.cloudpivot.foundation.orm.api.dml.BatchManager;
import com.authine.cloudpivot.foundation.orm.spi.NativeSqlInfo;
import com.authine.cloudpivot.foundation.orm.spi.NativeSqlProvider;
import com.google.common.collect.Maps;
import com.google.common.collect.Sets;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;
import java.util.Set;


//@Component
@Slf4j
public class OrgBatchSqlProviderGauss implements NativeSqlProvider {

    private final static String ORG_BATCH_PROVIDER_METHOD_NAME = "orgBatchProviderMethod";

    private Map<String, Set<String>> dbs = Maps.newHashMap();

    public void initData() {
        dbs.put(ORG_BATCH_PROVIDER_METHOD_NAME, Sets.newHashSet("gauss"));
    }

    @Override
    public boolean matchDbAndMethod(String dbType, String method) {
        if (dbs.isEmpty()) {
            initData();
        }

        if (!dbs.containsKey(method)) {
            return false;
        }

        if (!dbs.get(method).contains(dbType)) {
            return false;
        }
        return true;
    }

    @Override
    public NativeSqlInfo getNativeSql(String dbType, String method, Object inputObjects) {
        if (!matchDbAndMethod(dbType, method)) {
            log.error("methodName or dbType is negative {}:{}", method, dbType);
            return null;
        }
        if (ORG_BATCH_PROVIDER_METHOD_NAME.equals(method)) {
            return getBatchInsertSql(dbType, (OrgBatchSqlGenObject) inputObjects);
        }

        return null;
    }

    private NativeSqlInfo getBatchInsertSql(String dbType, OrgBatchSqlGenObject inputObjects) {
        OrgBatchSqlGenObject orgBatchSqlGenObject = inputObjects;
        BatchManager.BatchInsertHandler handler = orgBatchSqlGenObject.getHandler();
        List<?> list = orgBatchSqlGenObject.getList();
        StringBuilder sql = new StringBuilder();
        sql.append("insert into ").append(handler.returnTableName()).append(handler.returnTableFields()).append(" " +
                "values ");
        for (int i = 0; i < list.size(); i++) {
            if (i == 0) {
                sql.append(handler.returnValue(list.get(i)));
                continue;
            }
            sql.append(',').append(handler.returnValue(list.get(i)));
        }


        NativeSqlInfo result = new NativeSqlInfo();
        result.setFullSql(sql.toString());
        return result;
    }

}


