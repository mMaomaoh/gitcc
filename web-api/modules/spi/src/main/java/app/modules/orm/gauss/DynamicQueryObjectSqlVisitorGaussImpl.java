package app.modules.orm.gauss;


import com.authine.cloudpivot.engine.component.query.api.DynamicQueryObject;
import com.authine.cloudpivot.engine.component.query.api.FilterExpression;
import com.authine.cloudpivot.engine.component.query.api.Order;
import com.authine.cloudpivot.engine.component.query.api.Pageable;
import com.authine.cloudpivot.foundation.orm.api.dml.DbFunctionType;
import com.authine.cloudpivot.foundation.orm.api.model.BizObjectQueryObject;
import com.authine.cloudpivot.foundation.orm.api.model.FieldModel;
import com.authine.cloudpivot.foundation.orm.api.model.QueryRelationObject;
import com.authine.cloudpivot.foundation.orm.spi.dml.AbstractDynamicQueryObjectSqlVisitor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.tuple.ImmutablePair;
import org.apache.commons.lang3.tuple.Pair;
import org.springframework.stereotype.Component;

import java.util.*;
import java.util.stream.Collectors;

import static com.authine.cloudpivot.engine.component.query.api.FilterExpression.Op.*;


/**
 * Oracle实现类 ，和Mysql差别主要是在分页还有
 *
 * @author 1031
 */
@Slf4j
//@Component
public class DynamicQueryObjectSqlVisitorGaussImpl  extends AbstractDynamicQueryObjectSqlVisitor {

    /**
     * 根据查询对象生成select sql和参数
     *
     * @param queryObject   查询对象
     * @param fieldModels 模型数据项表
     * @return sql and parameter
     */
    @Override
    public Pair<String, Map<String, Object>> selectVisit(DynamicQueryObject queryObject, List<? extends FieldModel> fieldModels) {
        FilterExpression expression = queryObject.getFilterExpression();
        Pair<String, Map<String, Object>> pair = getFilterExpressionVisit().render(expression, fieldModels).getResult();
        String selects = visit(queryObject.getDisplayFields());
        String tableName;
        if (queryObject instanceof BizObjectQueryObject) {
            tableName = bizObjectHelper.getTableName(((BizObjectQueryObject) queryObject).getSchemaCode());
        } else {
            tableName = String.valueOf(queryObject.getTarget());
        }

        StringBuffer stringBuffer = new StringBuffer(selects);
        String orderClause = visit(queryObject.getSortable());
        //group by 与 order by 同时存在
        if (CollectionUtils.isNotEmpty(queryObject.getGroupByFields()) && CollectionUtils.isNotEmpty(queryObject.getSortable().getOrders())) {
            List<String> displayFields = queryObject.getDisplayFields();
            queryObject.getSortable().getOrders().forEach(order -> {
                //如果显示字段不包含order字段，需要将min(字段)或max(字段)添加到查询字段
                if (displayFields.contains(order.getField())) {
                    return;
                }
                FieldModel orderModel = CollectionUtils.isEmpty(fieldModels) ? null : fieldModels.stream().filter(bizProperty -> Objects.equals(bizProperty.getCode(), order.getField())).findFirst().orElse(null);
                if (orderModel == null) {
                    return;
                }
                String orderField = quote(order.getField());
                String function = (order.getDir() == Order.Dir.DESC ? "MAX" : "MIN");
                stringBuffer.append(',');
                stringBuffer.append(String.format("%s(%s)", function, orderField));
                stringBuffer.append(" AS ").append(orderField);
            });
        }
        String p = String.format("SELECT %s FROM %s %s", stringBuffer, tableName, pair.getLeft()).trim();
        String groupByClause = null;
        if (!CollectionUtils.isEmpty(queryObject.getGroupByFields())) {
            groupByClause = String.format(" GROUP BY %s", queryObject.getGroupByFields().stream().map(it -> quote(it)).collect(Collectors.joining(", ")));
        }

        String limitClause = null;
        Pageable pageable = queryObject.getPageable();
        if (pageable != null) {
            limitClause = String.format("offset %s limit %s", queryObject.getPageable().getStart(), queryObject.getPageable().getLimit());
        }
        StringBuilder sql = new StringBuilder(p);
        if (StringUtils.isNotBlank(groupByClause)) {
            sql.append(' ').append(groupByClause);
        }
        if (StringUtils.isNotBlank(orderClause)) {
            sql.append(' ').append(orderClause);
        }
        if (StringUtils.isNotBlank(limitClause)) {
            sql.append(' ').append(limitClause);
        }
        if (log.isDebugEnabled()) {
            log.debug("selectVisit查询语句：{},参数：{}", sql, pair.getRight());
        }
        return ImmutablePair.of(sql.toString(), pair.getRight());
    }


    /**
     * 根据查询对象生成select sql和参数
     *
     * @param queryObject   查询对象
     * @param fieldModels 模型数据项表
     * @return sql and parameter
     */
    @Override
    public Pair<String, Map<String, Object>> selectVisitExpectSimulative(DynamicQueryObject queryObject, List<? extends FieldModel> fieldModels) {
        FilterExpression expression = queryObject.getFilterExpression();
        Pair<String, Map<String, Object>> pair = getFilterExpressionVisit().render(expression, fieldModels).getResult();
        String selects = visit(queryObject.getDisplayFields());
        String tableName;
        if (queryObject instanceof BizObjectQueryObject) {
            tableName = bizObjectHelper.getTableName(((BizObjectQueryObject) queryObject).getSchemaCode());
        } else {
            tableName = String.valueOf(queryObject.getTarget());
        }

        StringBuilder stringBuffer = new StringBuilder(selects);
        String orderClause = visit(queryObject.getSortable());

        String whereClause = pair.getLeft();
        if (StringUtils.isNotEmpty(whereClause)) {
            whereClause = whereClause + " AND (workflowInstanceId NOT IN (SELECT id  FROM biz_workflow_instance WHERE dataType = 'SIMULATIVE') OR workflowInstanceId is NULL) ";
        } else {
            whereClause = "WHERE (workflowInstanceId NOT IN (SELECT id  FROM biz_workflow_instance WHERE dataType = 'SIMULATIVE') OR workflowInstanceId is NULL) ";
        }
        String p = String.format("SELECT %s FROM %s %s", stringBuffer, tableName, whereClause).trim();
        String groupByClause = null;
        if (!CollectionUtils.isEmpty(queryObject.getGroupByFields())) {
            groupByClause = String.format(" GROUP BY %s", queryObject.getGroupByFields().stream().map(it -> quote(it)).collect(Collectors.joining(", ")));
        }

        String limitClause = null;
        Pageable pageable = queryObject.getPageable();
        if (pageable != null) {
            limitClause = String.format("offset %s limit %s", queryObject.getPageable().getStart(), queryObject.getPageable().getLimit());
        }
        StringBuilder sql = new StringBuilder(p);
        if (StringUtils.isNotBlank(groupByClause)) {
            sql.append(' ').append(groupByClause);
        }
        if (StringUtils.isNotBlank(orderClause)) {
            sql.append(' ').append(orderClause);
        }
        if (StringUtils.isNotBlank(limitClause)) {
            sql.append(' ').append(limitClause);
        }
        if (log.isDebugEnabled()) {
            log.debug("selectVisit查询语句：{},参数：{}", sql, pair.getRight());
        }
        return ImmutablePair.of(sql.toString(), pair.getRight());
    }

    @Override
    public Pair<String, Map<String, Object>> batchInsertVisit(String tableName, List<Map<String, Object>> parameters) {
        int i = 0;
        Map<String, Object> finalParameters = new HashMap<>();
        //String[] columns = parameters.get(0).keySet().toArray(new String[0]);
        Set<String> cs = new HashSet<>();
        for (Map<String, Object> parameter : parameters) {
            cs.addAll(parameter.keySet());
        }
        String[] columns = cs.toArray(new String[0]);
        StringBuilder placeholders = new StringBuilder();
        for (Map<String, Object> parameter : parameters) {
            StringBuilder sb = new StringBuilder("(");
            for (String column : columns) {
                finalParameters.put(column + "[" + i + "]", parameter.get(column));
                sb.append(String.format(":%s[%d]", column, i)).append(',');
            }
            sb.setLength(sb.length() - 1);
            sb.append(')');
            placeholders.append(sb);
            placeholders.append(',');
            i++;
        }
        placeholders.setLength(placeholders.length() - 1);
        for (int j = 0; j < columns.length; j++) {
            columns[j] = String.format("%s", quote(columns[j]));
        }
        //INSERT INTO cloudpivot.`base_security_client`(a,b,c,d,e,f) VALUES(:a1,:b1,:c1,:d1,:e1,:f1),(:a2,:b2,:c2,:d2,:e2,:f2);
        String sql = String.format("INSERT INTO %s (%s) VALUES %s", tableName, String.join(",", columns), placeholders);
        return ImmutablePair.of(sql, finalParameters);
    }

    /**
     * 给表名，字段名加上""(oracle) 或者 ``(mysql)
     *
     * @param value 表名，字段名
     * @return `表名`,`字段名`
     */
    @Override
    protected String quote(String value) {
        String format = "%s";
        if (isSensitive()) {
            format = "\"" + format + "\"";
        }
        if (value.contains(".")) {
            String[] split = value.split("[.]");
            return split[0] + "." + String.format(format, split[1]);
        }
        return String.format(format, value);

    }

    @Override
    protected String quoteAs(String value) {
        return this.quote(value);
    }

    /**
     * 获得FilterExpressionVisit对象
     *
     * @return AbstractFilterExpressionVisit
     */
    @Override
    protected AbstractFilterExpressionVisit getFilterExpressionVisit() {
        return new AbstractFilterExpressionVisit() {
            @Override
            public String visitClob(FilterExpression.Item item) {
                StringBuilder sql = new StringBuilder();
                sql.append(quote(item.field));
                sql.append(String.format(" %s ", visit(item.op, item.value)));
                FilterExpression.Op op = item.op;
                Object value = item.value;
                if (op == Reg) {
                    return visitReg(item, value, false);
                }
                if (op == FilterExpression.Op.NotReg) {
                    return visitReg(item, item.value, true);
                }
                if (op == LengthEq) {
                    return generateFunctionExpression(DbFunctionType.LengthEq, item);
                }
                if (op == LengthNotEq) {
                    return generateFunctionExpression(DbFunctionType.LengthNotEq, item);
                }
                if (value != null) {
                    if (op == In || op == NotIn) {
                        sql.append('(').append(getHolderPlace()).append(')');
                        parameters.put(getParameterName(), value);
                        return sql.toString();
                    }
                    sql.append(getHolderPlace());
                    // 条件为!=时， 该字段为null的数据也需要查询出来
                    if (op == NotEq) {
                        sql.append(" or ");
                        sql.append(quote(item.field));
                        sql.append(" is null");
                    }
                    if (op == Like) {
                        return visitLike(item);
                    } else if (op == NotLike) {
                        return visitNotLike(item);
                    } else if (op == LLike) {
                        parameters.put(getParameterName(), String.format("%s%%", value));
                    } else {
                        parameters.put(getParameterName(), value);
                    }
                } else {
                    sql.append("NULL");
                }
                return sql.toString();
            }

            @Override
            public Object visitLogical(Object value) {
                if (value == null) {
                    return null;
                }
                if (Objects.equals("1", value) || Objects.equals(1, value)) {
                    return Boolean.TRUE;
                }
                return Boolean.FALSE;
            }
        };
    }

    @Override
    public String generateRegularCondition(String quoteField, String holderPlace, boolean isNot) {
        StringBuilder sql = new StringBuilder();
        sql.append("regexp_match(").append(quoteField).append(',').append(holderPlace).append(')');
        sql.append(" is ");
        if (!isNot) {
            sql.append(" not ");
        }
        sql.append(" null");
        return sql.toString();
    }

    /**
     * 多表关联查询
     * @param queryObject 关联查询对象
     * @param fieldModels 关联对象字段列表
     * @return
     */
    @Override
    public Pair<String, Map<String, Object>> selectVisit(QueryRelationObject queryObject, List<? extends FieldModel> fieldModels) {
        //显示字段 schemaCode.id, schemaCode1.name
        String displayFieldSql = getDisplayFieldSql(queryObject.getDisplayFields());
        //主表 table as schemaCode
        String tableSql = getTableSql(queryObject.getSchemaCode(), queryObject.getSchemaAlias());
        //关联表 join tableA as schemaCode1 on schemaCode1.id = schemaCode.id
        String relationSql = getRelationSql(queryObject.getSchemaRelations());
        //查询条件及参数
        Pair<String, Map<String, Object>> pair = getFilterExpressionVisit().renderRelation(queryObject.getFilterExpression(), fieldModels);
        //分组字段
        String groupBySql = getGroupBySql(queryObject.getGroupByFields());
        //排序字段
        String orderBySql = getOrderBySql(queryObject.getOrderByFields());
        //分页信息
        String pageSql = getPageSql(queryObject.getPageable());

        String sql = String.format("SELECT %s FROM %s %s %s %s %s %s", displayFieldSql, tableSql, relationSql, pair.getLeft(), groupBySql, orderBySql, pageSql);

        if (log.isDebugEnabled()) {
            log.debug("selectVisit查询语句：{},参数：{}", sql, pair.getRight());
        }
        return ImmutablePair.of(sql, pair.getRight());
    }

    @Override
    public String getDbType() {
        return "gauss";
    }

    @Override
    public String generateFunctionExpression(DbFunctionType dbFunctionType, FilterExpression.Item item) {
        StringBuilder sql = new StringBuilder();
        switch (dbFunctionType) {
            case LengthEq:
                sql.append("LENGTH(");
                sql.append(quote(item.field));
                sql.append(") = ");
                sql.append(item.value);
                break;
            case LengthNotEq:
                sql.append("LENGTH(");
                sql.append(quote(item.field));
                sql.append(") != ");
                sql.append(item.value);
                break;
            default:
        }
        return sql.toString();
    }
}
