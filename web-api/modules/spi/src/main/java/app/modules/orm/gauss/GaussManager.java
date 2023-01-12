package app.modules.orm.gauss;


import com.alibaba.fastjson.JSON;
import com.authine.cloudpivot.engine.enums.type.BizPropertyType;
import com.authine.cloudpivot.foundation.orm.api.ddl.internal.DBUtil;
import com.authine.cloudpivot.foundation.orm.api.model.FieldModel;
import com.authine.cloudpivot.foundation.orm.api.model.TableModel;
import com.authine.cloudpivot.foundation.orm.spi.TableNameStrategy;
import com.authine.cloudpivot.foundation.orm.spi.ddl.BaseDDLManager;
import com.google.common.collect.Lists;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;


@Slf4j
//@Component
public class GaussManager extends BaseDDLManager {

    private String TABLE_MODIFY_OPERATE = "MODIFY";

    /**
     * primary key
     */
    private static final String ID = "id";

    /**
     * 时间类型
     */
    private static final String DATE = "date";

    @Autowired
    public GaussManager(DBUtil dbUtil, TableNameStrategy tableNameStrategy) {
        super("gauss", dbUtil, tableNameStrategy);
    }

    @Override
    public boolean checkTableExists(String code) {
        return tableExist(code);
    }

    @Override
    public boolean checkColumnExists(String code, String columnName) {
        AtomicBoolean exist = new AtomicBoolean(false);
        StringBuilder sb = new StringBuilder();
        List<Object> params = Lists.newArrayList(this.getTableName(code).toLowerCase(), columnName.toLowerCase());
        sb.append("select count(1) as num from pg_class c,pg_attribute a,pg_type t where  lower(c.relname) = ?"
                + " and lower(a.attname) = ? and a.attnum > 0 and a.attrelid= c.oid  and a.atttypid = t.oid");

        this.dbUtil.execQuery(sb.toString(),
                rs -> {
                    try {
                        while (rs.next()) {
                            exist.set(rs.getLong(1) > 0L);
                        }
                    } catch (Exception ex) {
                        log.info("查询表-{}是否存在异常：{}", code, ex);
                    }
                }, params);
        return exist.get();
    }

    @Override
    public boolean checkIndexExists(String code, String indexName) {
        AtomicBoolean exist = new AtomicBoolean(false);
        List<Object> params = Lists.newArrayList(this.getTableName(code).toLowerCase(), indexName.toLowerCase());
        this.dbUtil.execQuery("select count(1) as num from pg_indexes where lower(tablename) = ? and lower(indexname)" +
                        " = ?",
                rs -> {
                    try {
                        while (rs.next()) {
                            exist.set(rs.getLong("num") > 0L);
                        }
                    } catch (Exception ex) {
                        log.info("查询表-{}是否存在异常：{}", code, ex);
                    }
                }, params);

        return exist.get();
    }

    @Override
    public int countIndex(TableModel schema) {
        AtomicInteger exist = new AtomicInteger(0);
        String tableName = this.getTableName(schema);
        List<Object> params = Lists.newArrayList(tableName.toLowerCase());
        this.dbUtil.execQuery(
                "SELECT count(1) as num FROM pg_indexes where lower(tablename) = ?",
                rs -> {
                    try {
                        while (rs.next()) {
                            exist.set(rs.getInt("num"));
                        }
                    } catch (Exception ex) {
                        log.info("查询索引数量存在异常，表-{}：{}", tableName, ex);
                    }
                }, params);
        return exist.get();
    }

    @Override
    public String getColumnDefine(FieldModel property) {
        String code = property.getCode();
        String defaultValue = property.getDefaultValue();
        boolean dvBlank = StringUtils.isBlank(defaultValue);
        if (BizPropertyType.DATE == property.getPropertyType()) {
            return getColumnDefine(code, "timestamp", dvBlank ? null : getSafeDate(defaultValue), null);
        }
        return getPostgreColumnDefine(property, null);
    }


    public String getColumnDefine(FieldModel property, String operate) {
        String code = property.getCode();
        String defaultValue = property.getDefaultValue();
        boolean dvBlank = StringUtils.isBlank(defaultValue);
        if (BizPropertyType.DATE == property.getPropertyType()) {
            return getColumnDefine(code, "timestamp", dvBlank ? null : getSafeDate(defaultValue), operate);
        }
        return getPostgreColumnDefine(property, operate);
    }

    @Override
    public List<String> buildCreateSql(TableModel bizSchema, List<? extends FieldModel> properties,
                                       boolean isChildTable) {
        String tableName = getTableName(bizSchema);
        String columnDefines =
                properties.stream().map(p -> getColumnDefine(p, "add")).filter(StringUtils::isNotBlank).collect(Collectors.joining(","));
        return Collections.singletonList(String.format("create table %s(%s)", tableName, columnDefines));
    }

    @Override
    public List<String> buildModifyColumnsSql(TableModel schema, List<? extends FieldModel> properties) {
        String tableName = this.getTableName(schema);
        List<String> sqls = new ArrayList<>();
        for (FieldModel property : properties) {
            String sql = getColumnDefine(property, "");
            if (StringUtils.isNotBlank(sql)) {
                sqls.add(String.format("alter table %s alter column %s", tableName, sql));
            }
        }
        return sqls;
    }

    @Override
    public List<String> buildAddColumnsSql(TableModel schema, List<? extends FieldModel> properties) {
        String tableName = this.getTableName(schema);
        List<String> sqls = new ArrayList<>();
        for (FieldModel property : properties) {
            String sql = getColumnDefine(property);
            if (StringUtils.isNotBlank(sql)) {
                sqls.add(String.format("alter table %s add  %s ", tableName, sql));
            }
        }
        return sqls;
    }

    @Override
    public List<String> buildDropSql(List<String> tableNames) {
        List<String> sqls = Lists.newArrayListWithExpectedSize(tableNames.size());
        for (String tableName : tableNames) {
            sqls.add(String.format("drop table %s", tableName));
        }
        return sqls;
    }

    @Override
    public List<String> buildDropColumnsSql(TableModel schema, List<String> columnNames) {
        String tableName = this.getTableName(schema);
        String columns = columnNames.stream().map(this::quote).collect(Collectors.joining(","));
        return Collections.singletonList(String.format("alter table %s drop %s", tableName, columns));
    }

    @Override
    public List<String> buildDropIndexesSql(TableModel schema, List<? extends FieldModel> properties) {
        List<String> sqls = Lists.newArrayListWithExpectedSize(properties.size());
        for (FieldModel property : properties) {
            String indexName = this.getIndexName(schema, property);
            if (!checkIndexExists(schema.getCode(), indexName)) {
                continue;
            }
            sqls.add(String.format("drop index %s", indexName));
        }
        return sqls;
    }

    @Override
    public List<String> buildAddIndexesSql(TableModel schema, List<? extends FieldModel> properties) {
        List<String> sqls = Lists.newArrayListWithExpectedSize(properties.size());
        String tableName = this.getTableName(schema);
        for (FieldModel property : properties) {
            String indexName = this.getIndexName(schema, property);
            if (checkIndexExists(schema.getCode(), indexName)) {
                log.error("index {} exists, table:{} column:{}", indexName, tableName, property.getCode());
                continue;
            }
            sqls.add(String.format("create index %s on %s(%s)", indexName, tableName, quote(property.getCode())));
        }
        return sqls;
    }

    /**
     * 得到创建表字段的sql语句
     *
     * @param columnName   列名
     * @param type         类型
     * @param defaultValue 默认值
     * @return sql
     */
    public String getColumnDefine(String columnName, String type, String defaultValue, String operate) {
        String operateType = StringUtils.equals(operate, TABLE_MODIFY_OPERATE) ? "type" : "";
        if (ID.equalsIgnoreCase(columnName)) {
            return quote("id").concat(operateType).concat(" varchar(36) primary key");
        }

        String columnFormat = quote("%s");
        if (type.startsWith(DATE)) {
            if (StringUtils.isNotBlank(defaultValue)) {
                return String.format(columnFormat + " %s  %s default %s", columnName, operateType, type, defaultValue);
            } else {
                return String.format(columnFormat + " %s %s  default null", columnName, operateType, type);
            }
        }
        if (StringUtils.isNotBlank(defaultValue)) {
            return String.format(columnFormat + " %s %s default '%s'", columnName, operateType, type, defaultValue);
        }
        return String.format(columnFormat + " %s %s default null", columnName, operateType, type);
    }

    /**
     * 得到Oracle默认日期值
     *
     * @param defaultValue 默认的日期格式
     * @return yyyy-MM-dd HH:mm:ss
     */
    public String getSafeDate(String defaultValue) {
        return String.format("to_date('%s','yyyy-MM-dd HH24:mi:ss')", defaultValue);
    }

    @Override
    public boolean tableExist(String code) {
        AtomicBoolean exist = new AtomicBoolean(false);
        List<Object> params = Lists.newArrayList(this.getTableName(code).toLowerCase());
        this.dbUtil.execQuery("SELECT COUNT(1) as num FROM pg_tables WHERE lower(tablename)= ?", rs -> {
            try {
                while (rs.next()) {
                    exist.set(rs.getLong(1) > 0L);
                }
            } catch (Exception ex) {
                log.info("查询表-{}是否存在异常：{}", code, ex);
            }
        }, params);
        return exist.get();
    }

    /**
     * 获取索引名称
     */
    @Override
    public String getIndexName(TableModel tableModel, FieldModel fieldModel) {
        String modelName = tableModel.getCode();
        String fieldName = fieldModel.getCode();
        int length = modelName.length() + fieldName.length();
        if (length < 26) {
            return String.format("idx_%s_%s", modelName, fieldName);
        }

        String indexName = "idx_";
        if (modelName.length() > 15) {
            indexName += modelName.substring(modelName.length() - 15);
        } else {
            indexName += modelName;
        }
        indexName += "_";
        if (fieldName.length() > 25 - modelName.length()) {
            indexName += fieldName.substring(fieldName.length() + modelName.length() - 25);
        } else {
            indexName += fieldName;
        }

        return indexName;
    }

    @Override
    public String quote(String columnName) {
        if (isSensitive()) {
            return String.format("\"%s\"", columnName);
        }
        return columnName;
    }

    public String getPostgreColumnDefine(FieldModel property, String operate) {
        String fieldSql = "";
        String code = property.getCode();
        String defaultValue = property.getDefaultValue();
        boolean dvBlank = StringUtils.isBlank(defaultValue);
        switch (property.getPropertyType()) {
            case SHORT_TEXT:
            case RADIO:
            case DROPDOWN_BOX:
            case WORK_SHEET:
                fieldSql = getColumnDefine(code, "varchar(200)", dvBlank ? null : getSafeString(defaultValue), operate);
                break;
            case MULT_WORK_SHEET:
                fieldSql = getColumnDefine(code, "text", null, operate);
                break;
            case LONG_TEXT:
            case CHECKBOX:
            case DROPDOWN_MULTI_BOX:
                fieldSql = getColumnDefine(code, "text", null, operate);
                break;
            case SELECTION:
            case STAFF_MULTI_SELECTOR:
            case DEPARTMENT_MULTI_SELECTOR:
                if (property.getDefaultProperty()) {
                    fieldSql = getColumnDefine(code, "varchar(128)", dvBlank ? null : getSafeString(defaultValue),
                            operate);
                } else {
                    fieldSql = getColumnDefine(code, "text", null, operate);
                }
                break;
            case STAFF_SELECTOR:
            case DEPARTMENT_SELECTOR:
                if (property.getDefaultProperty()) {
                    fieldSql = getColumnDefine(code, "varchar(128)", dvBlank ? null : getSafeString(defaultValue),
                            operate);
                } else {
                    fieldSql = getColumnDefine(code, "varchar(200)", null, operate);
                }
                break;
            case NUMERICAL:
                fieldSql = getColumnDefine(code, "decimal(25,8)", dvBlank ? null : getSafeNumber(defaultValue),
                        operate);
                break;
            case DATE:
                fieldSql = getColumnDefine(code, "timestamp", dvBlank ? null : getSafeDate(defaultValue), operate);
                break;
//            case TIME:
//                fieldSql = getColumnDefine(code,
//                "time", dvBlank ? null : getSafeDate(defaultValue));
//                break;
            case LOGICAL:
                fieldSql = getColumnDefine(code, "bool", null, operate);
                break;
            case ADDRESS:
                fieldSql = getColumnDefine(code, "varchar(500)", null, operate);
                break;
            default:
                break;
        }
        if (log.isTraceEnabled()) {
            log.trace("Property object is :{} ", JSON.toJSONString(property));
            log.trace("Column SQL: {}", fieldSql);
        }
        return fieldSql;
    }
}