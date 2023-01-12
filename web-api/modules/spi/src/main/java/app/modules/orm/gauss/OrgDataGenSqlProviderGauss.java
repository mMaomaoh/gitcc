package app.modules.orm.gauss;


import com.authine.cloudpivot.foundation.orm.spi.NativeSqlInfo;
import com.authine.cloudpivot.foundation.orm.spi.NativeSqlProvider;
import com.google.common.collect.Maps;
import com.google.common.collect.Sets;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.util.Map;
import java.util.Objects;
import java.util.Set;

//@Component
@Slf4j
public class OrgDataGenSqlProviderGauss implements NativeSqlProvider {

    @Value("${cloudpivot.bizobject.db.column.sensitive}")
    private Boolean oracleColumnSensitive;

    private final static String ORG_DATA_GEN_PROVIDER_METHOD_NAME = "orgDataGenProviderMethod";

    private Map<String, Set<String>> dbs = Maps.newHashMap();

    public void initData() {
        dbs.put(ORG_DATA_GEN_PROVIDER_METHOD_NAME, Sets.newHashSet("gauss"));
    }

    @Override
    public boolean matchDbAndMethod(String dbType, String method) {
        if (dbs.isEmpty()) {
            initData();
        }

        if (!dbs.containsKey(method)) {
            return false;
        }

        return dbs.get(method).contains(dbType);
    }

    @Override
    public NativeSqlInfo getNativeSql(String dbType, String method, Object inputObjects) {
        if (!matchDbAndMethod(dbType, method)) {
            log.error("methodName or dbType is negative {}:{}", method, dbType);
            return null;
        }
        if (ORG_DATA_GEN_PROVIDER_METHOD_NAME.equals(method)) {
            return getQuerySql(dbType, (String) inputObjects);
        }

        return null;
    }

    private NativeSqlInfo getQuerySql(String dbType, String tableName) {
        StringBuilder sql = new StringBuilder();
        if (Objects.equals(Boolean.TRUE, oracleColumnSensitive)) {
            sql.append("select \"owner\" ,count(*) from ").append(tableName).append(" group by \"owner\"");
        } else {
            sql.append("select owner ,count(*) from ").append(tableName).append(" group by owner");
        }
        NativeSqlInfo result = new NativeSqlInfo();
        result.setFullSql(sql.toString());
        return result;
    }

}
