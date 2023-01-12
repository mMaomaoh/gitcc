package app.modules.orm.gauss;


import com.authine.cloudpivot.engine.api.facade.DepartmentFacade;
import com.authine.cloudpivot.engine.api.model.organization.DepartmentModel;
import com.authine.cloudpivot.engine.api.model.runtime.SearchListWorkflowInstancesInputObjects;
import com.authine.cloudpivot.engine.api.model.runtime.SearchWorkflowInstancesInputObjects;
import com.authine.cloudpivot.engine.api.model.runtime.WorkItemQueryInputObjects;
import com.authine.cloudpivot.engine.api.spec.WorkItemQuerySpec;
import com.authine.cloudpivot.engine.api.spec.WorkflowInstanceQuerySpec;
import com.authine.cloudpivot.engine.enums.status.WorkflowEndStatus;
import com.authine.cloudpivot.engine.enums.status.WorkflowInstanceStatus;
import com.authine.cloudpivot.engine.enums.type.ProcessDataType;
import com.authine.cloudpivot.engine.enums.type.UnitType;
import com.authine.cloudpivot.engine.utils.DateUtils;
import com.authine.cloudpivot.foundation.orm.spi.NativeSqlInfo;
import com.authine.cloudpivot.foundation.orm.spi.NativeSqlProvider;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.collect.Sets;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.collections4.ListUtils;
import org.apache.commons.collections4.MapUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;


//@Component
@Slf4j
public class WorkflowNativeSqlProviderGauss implements NativeSqlProvider {
    public static final String SEARCHWORKITEMS = "searchWorkitems";

    public static final String SEARCH_WORKFLOW_INSTANCES = "searchWorkflowInstances";

    public static final String SEARCH_LIST_WORKFLOW_INSTANCES = "searchListWorkflowInstances";

    private Map<String, Set<String>> dbs = Maps.newHashMap();

    @Autowired
    private DepartmentFacade departmentFacade;

    @Value("${organization.independent-data-source.switch:false}")
    private boolean dataSourceSwitch;

    public void initData() {
        dbs.put(SEARCHWORKITEMS, Sets.newHashSet("gauss"));
        dbs.put(SEARCH_WORKFLOW_INSTANCES, Sets.newHashSet("gauss"));
        dbs.put(SEARCH_LIST_WORKFLOW_INSTANCES, Sets.newHashSet("gauss"));
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

        switch (method) {
            case SEARCHWORKITEMS:
                return getSearchWorkitems(dbType, inputObjects);
            case SEARCH_WORKFLOW_INSTANCES:
                return searchWorkflowInstances(dbType, inputObjects);
            case SEARCH_LIST_WORKFLOW_INSTANCES:
                return searchListWorkflowInstances(dbType, inputObjects);
            default:
                log.error("method:{} in db:{} illegal", method, dbType);
        }
        return null;
    }

    private NativeSqlInfo getSearchWorkitems(String dbType, Object inputObjects) {
        if (!(inputObjects instanceof WorkItemQueryInputObjects)) {
            log.error("input objects is negative:{}", inputObjects);
            return new NativeSqlInfo();
        }

        WorkItemQuerySpec workItemQuerySpec = ((WorkItemQueryInputObjects) inputObjects).getWorkItemQuerySpec();
        String userId = workItemQuerySpec.getUserId();
        String keyWord = workItemQuerySpec.getKeyword();
        String appCode = workItemQuerySpec.getAppCode();
        String startTime = workItemQuerySpec.getStartTime();
        String endTime = workItemQuerySpec.getEndTime();
        Boolean batchOperate = workItemQuerySpec.getBatchOperate();
        String instanceName = workItemQuerySpec.getWorkflowName();
        String workflowCode = workItemQuerySpec.getWorkflowCode();
        String originator = workItemQuerySpec.getOriginator();
        UnitType unitType = workItemQuerySpec.getUnitType();
        String activityName = workItemQuerySpec.getActivityName();
        String participantName = workItemQuerySpec.getParticipantName();
        String participant = workItemQuerySpec.getParticipant();
        String sequenceNo = workItemQuerySpec.getSequenceNo();
        List<String> workItemSource = workItemQuerySpec.getWorkItemSource();

        final Map<String, Object> params = Maps.newHashMap();
        final StringBuilder querySql = new StringBuilder("SELECT ");
        final StringBuilder countSql = new StringBuilder("SELECT COUNT(1) FROM biz_workitem t ");
        final StringBuilder conditionSql = new StringBuilder(" WHERE 1 = 1 ");
        final String orderSql;

        orderSql = " ORDER BY \"timeoutStatusValue\" ASC, (now() - t.allowedTime) DESC, t.startTime DESC ";
        querySql.append(" case when now() > t.allowedTime then 0 when now() > t.timeoutWarn2 then 1 ");
        querySql.append(" when now() > t.timeoutWarn1 then 2 else 3 end \"timeoutStatusValue\", ");


        querySql.append("t.instanceName \"instanceName\", t.instanceId \"instanceId\", t.id \"id\", t.activityCode " +
                "\"activityCode\", ");
        querySql.append("t.activityName \"activityName\", t.allowedTime \"allowedTime\", t.timeoutWarn2 " +
                "\"timeoutWarning2\", ");
        querySql.append("t.startTime \"startTime\", t.originator \"originator\", t.originatorName \"originatorName\"," +
                " t.state \"stateString\", ");
        querySql.append("t.departmentId \"departmentId\", t.departmentName \"departmentName\", t.participant " +
                "\"participant\", ");
        querySql.append("t.workflowCode \"workflowCode\", t.workflowVersion \"workflowVersion\", t.timeoutWarn1 " +
                "\"timeoutWarning1\",");
        querySql.append("t.participantName \"participantName\", t.workflowTokenId \"workflowTokenId\", t.appCode " +
                "\"appCode\", ");
        querySql.append("t.isTrust \"isTrust\", t.trustor \"trustor\", t.trustorName \"trustorName\", ");
        querySql.append("t.sequenceNo \"sequenceNo\"");
        querySql.append(" FROM biz_workitem t ");

        conditionSql.append(" and t.dataType = :dataType ");
        params.put("dataType", ProcessDataType.NORMAL.name());

        if (!StringUtils.isEmpty(sequenceNo)) {
            conditionSql.append(" AND t.sequenceNo like :sequenceNo ");
            params.put("sequenceNo", '%' + sequenceNo + '%');
        }
        if (!StringUtils.isEmpty(userId)) {
            conditionSql.append(" AND t.participant = :userId ");
            params.put("userId", userId);
        }
        if (!StringUtils.isEmpty(keyWord)) {
            conditionSql.append(" AND (t.originatorName like :keyWord OR t.instanceName like :keyWord) ");
            params.put("keyWord", '%' + keyWord + '%');
        }

        if (!StringUtils.isEmpty(instanceName)) {
            conditionSql.append(" AND t.instanceName like :instanceName ");
            params.put("instanceName", '%' + instanceName + '%');
        }

        if (unitType != null) {
            switch (unitType) {
                case DEPARTMENT:
                    DepartmentModel department = departmentFacade.get(originator);
                    if (department != null && org.apache.commons.lang3.StringUtils.isNotBlank(department.getQueryCode())) {
                        List<String> queryCodes = Lists.newArrayList();
                        queryCodes.add(department.getQueryCode());
                        List<DepartmentModel> departments = departmentFacade.listByQueryCodes(queryCodes, Boolean.TRUE);
                        if (!CollectionUtils.isEmpty(departments)) {
                            List<String> depts =
                                    departments.stream().map(DepartmentModel::getId).collect(Collectors.toList());
                            conditionSql.append(" and t.departmentId in :originatorDepartments ");
                            params.put("originatorDepartments", depts);
                        }
                    }
                    break;
                case USER:
                    if (!StringUtils.isEmpty(originator)) {
                        conditionSql.append(" and t.originator = :originator ");
                        params.put("originator", originator);
                    }
                    break;
                case ROLE:
                    break;
                default:
            }
        }

        if (!StringUtils.isEmpty(appCode)) {
            conditionSql.append(" AND t.appCode = :appCode ");
            params.put("appCode", appCode);
        }

        if (!StringUtils.isEmpty(startTime)) {
            Date startDateTime = DateUtils.formateDateTime(startTime);
            if (startDateTime != null) {
                conditionSql.append(" AND t.startTime >= :startDateTime ");
                params.put("startDateTime", startDateTime);
            }
        }

        if (!StringUtils.isEmpty(endTime)) {
            Date endDateTime = DateUtils.formateDateTime(endTime);
            if (endDateTime != null) {
                conditionSql.append(" AND t.startTime <= :endDateTime ");
                params.put("endDateTime", endDateTime);
            }
        }

        if (batchOperate != null && batchOperate) {
            conditionSql.append(" AND t.batchOperate = :batchOperate ");
            params.put("batchOperate", batchOperate);
        }

        if (!StringUtils.isEmpty(workflowCode)) {
            conditionSql.append(" AND t.workflowCode = :workflowCode ");
            params.put("workflowCode", workflowCode);
        }

        if (!StringUtils.isEmpty(activityName)) {
            conditionSql.append(" AND t.activityName like :activityName ");
            params.put("activityName", '%' + activityName + '%');
        }

        if (!StringUtils.isEmpty(participantName)) {
            conditionSql.append(" AND t.participantName = :participantName ");
            params.put("participantName", participantName);
        }

        if (!StringUtils.isEmpty(participant)) {
            conditionSql.append(" AND t.participant = :participant ");
            params.put("participant", participant);
        }

        if (!CollectionUtils.isEmpty(workItemSource)) {
            conditionSql.append(" AND t.workItemSource in :workItemSource ");
            params.put("workItemSource", workItemSource);
        }

        final String finalQuerySql = querySql.append(conditionSql).append(orderSql).toString();
        final String finalCountSql = countSql.append(conditionSql).toString();

        return new NativeSqlInfo(finalQuerySql, finalCountSql, params);
    }

    private NativeSqlInfo searchWorkflowInstances(String dbType, Object inputObjects) {
        if (!(inputObjects instanceof SearchWorkflowInstancesInputObjects)) {
            log.error("input objects is negative:{}", inputObjects);
            return new NativeSqlInfo();
        }
        SearchWorkflowInstancesInputObjects searchObjects = (SearchWorkflowInstancesInputObjects) inputObjects;
        WorkflowInstanceQuerySpec querySpec = searchObjects.getQuerySpec();
        String originator = querySpec.getOriginator();
        UnitType unitType = querySpec.getUnitType();
        String currentUserId = querySpec.getCurrentUserId();
        String workflowName = querySpec.getWorkflowName();
        String workflowCode = querySpec.getWorkflowCode();
        String startTime = querySpec.getStartTime();
        String endTime = querySpec.getEndTime();
        List<WorkflowInstanceStatus> instanceStatusList = querySpec.getInstanceState();

        final StringBuilder querySql = new StringBuilder();

        boolean isProcessing = false;
        boolean isCancel = false;
        boolean isException = false;//异常的流程按发起时间排序

        if (!CollectionUtils.isEmpty(instanceStatusList)) {
            for (WorkflowInstanceStatus status : instanceStatusList) {
                if (status == WorkflowInstanceStatus.PROCESSING) {
                    isProcessing = true;
                } else if (status == WorkflowInstanceStatus.CANCELED) {
                    isCancel = true;
                } else if (status == WorkflowInstanceStatus.EXCEPTION) {
                    isException = true;
                }
            }
        }

        if (isProcessing) {
            querySql.append(" SELECT WF.id id, WF.finishTime \"finishTime\", WF.startTime \"startTime\", WF" +
                    ".bizObjectId \"bizObjectId\", WF.departmentId \"departmentId\",");
            querySql.append("  	  WF.departmentName \"departmentName\",WF.instanceName \"instanceName\",WF" +
                    ".originator" +
                    " " +
                    "\"originator\",");
            querySql.append("  WF.originatorName originatorName,WF.state stateString,WF.workflowCode workflowCode,WF" +
                    ".workflowVersion workflowVersion,");
            querySql.append("    (SELECT item.participantName FROM biz_workitem item WHERE item.id = (SELECT MIN(BW" +
                    ".id) FROM biz_workitem BW WHERE BW.instanceId = WF.id) ) AS participantName, ");
            querySql.append("    (SELECT item.participant FROM biz_workitem item WHERE item.id = (SELECT MIN(BW.id) " +
                    "FROM biz_workitem BW WHERE BW.instanceId = WF.id) ) AS participant ");
            querySql.append(" FROM	biz_workflow_instance WF ");
            querySql.append(" WHERE 1 = 1 %1$s ");
            querySql.append(" ORDER BY WF.startTime desc ");
        } else {
            querySql.append("SELECT WF.id \"id\",WF.finishTime \"finishTime\",WF.startTime \"startTime\",WF" +
                    ".bizObjectId \"bizObjectId\",");
            querySql.append("WF.departmentId \"departmentId\",WF.departmentName \"departmentName\",WF.instanceName " +
                    "\"instanceName\",");
            querySql.append("WF.originator \"originator\",WF.originatorName \"originatorName\",WF.state " +
                    "\"stateString\",");
            querySql.append("WF.workflowCode \"workflowCode\",WF.workflowVersion \"workflowVersion\" ");

            if (CollectionUtils.isEmpty(instanceStatusList) || isException) {
                querySql.append(" FROM biz_workflow_instance WF WHERE 1 = 1 %1$s ORDER BY WF.startTime desc");
            } else {
                querySql.append(" FROM biz_workflow_instance WF WHERE 1 = 1 %1$s ORDER BY WF.finishTime desc");
            }
        }

        final Map<String, Object> params = Maps.newHashMap();
        final String countSql = "SELECT COUNT(1) FROM biz_workflow_instance WF WHERE 1 = 1 ";
        final StringBuilder conditions = new StringBuilder();

        if (unitType != null) {
            switch (unitType) {
                case USER:
                    if (!StringUtils.isEmpty(originator)) {
                        conditions.append(" AND WF.originator = :originator ");
                        params.put("originator", originator);
                    }
                    break;
                case ROLE:
                    break;
                case DEPARTMENT:
                    DepartmentModel department = departmentFacade.get(originator);
                    if (department != null && org.apache.commons.lang3.StringUtils.isNotBlank(department.getQueryCode())) {
                        List<String> queryCodes = Lists.newArrayList();
                        queryCodes.add(department.getQueryCode());
                        List<DepartmentModel> departments = departmentFacade.listByQueryCodes(queryCodes, Boolean.TRUE);
                        if (!CollectionUtils.isEmpty(departments)) {
                            List<String> depts =
                                    departments.stream().map(DepartmentModel::getId).collect(Collectors.toList());
                            conditions.append(" and WF.departmentId in :originatorDepartments ");
                            params.put("originatorDepartments", depts);
                        }
                    }
                    break;
                default:
            }
        }
        //当前用户，不能查看不属于自己的草稿
        if (!StringUtils.isEmpty(currentUserId)) {
            conditions.append(" AND WF.state != 'DRAFT' ");
        }
        if (!StringUtils.isEmpty(workflowName)) {
            conditions.append(" AND WF.instanceName like :instanceName ");
            params.put("instanceName", '%' + workflowName + '%');
        }
        if (!StringUtils.isEmpty(workflowCode)) {
            conditions.append(" AND WF.workflowCode = :workflowCode ");
            params.put("workflowCode", workflowCode);
        }
        if (!CollectionUtils.isEmpty(instanceStatusList)) {
            conditions.append(" AND ( ");
            for (int i = 0; i < instanceStatusList.size(); i++) {
                conditions.append(i == 0 ? "" : " OR ");
                conditions.append(" WF.state = :instanceState").append(i);

                params.put("instanceState" + i, instanceStatusList.get(i).toString());
            }
            conditions.append("  ) ");
        }
        if (!StringUtils.isEmpty(startTime)) {
            if (isCancel) {
                conditions.append(" AND WF.finishTime >= :startTime ");
            } else {
                conditions.append(" AND WF.startTime >= :startTime ");
            }
            params.put("startTime", DateUtils.formateDateTime(startTime));
        }
        if (!StringUtils.isEmpty(endTime)) {
            if (isCancel) {
                conditions.append(" AND WF.finishTime <= :endTime ");
            } else {
                conditions.append(" AND WF.startTime <= :endTime ");
            }
            params.put("endTime", DateUtils.formateDateTime(endTime));
        }

        final String finalQuerySql = String.format(querySql.toString(), conditions);
        final String finalCountSql = countSql + conditions;
        return new NativeSqlInfo(finalQuerySql, finalCountSql, params);
    }

    private NativeSqlInfo searchListWorkflowInstances(String dbType, Object inputObjects) {
        if (!(inputObjects instanceof SearchListWorkflowInstancesInputObjects)) {
            log.error("input objects is negative:{}", inputObjects);
            return new NativeSqlInfo();
        }
        SearchListWorkflowInstancesInputObjects searchObjects = (SearchListWorkflowInstancesInputObjects) inputObjects;
        WorkflowInstanceQuerySpec querySpec = searchObjects.getQuerySpec();
        String originator = querySpec.getOriginator();
        UnitType unitType = querySpec.getUnitType();
        String currentUserId = querySpec.getCurrentUserId();
        String workflowName = querySpec.getWorkflowName();
        String workflowCode = querySpec.getWorkflowCode();
        String appCode = querySpec.getAppCode();
        String startTime = querySpec.getStartTime();
        String endTime = querySpec.getEndTime();
        List<WorkflowInstanceStatus> instanceStatusList = querySpec.getInstanceState();
        String squenceNo = querySpec.getSquenceNo();
        ProcessDataType dataType = querySpec.getDataType();
        Map<String, Map<String, List<String>>> appScopes = querySpec.getAppScopes();
        List<String> workflowCodes = querySpec.getWorkflowCodes();
        String activityName = querySpec.getActivityName();
        String participantId = querySpec.getParticipantId();
        Integer workflowVersion = querySpec.getWorkflowVersion();
        String activityCode = querySpec.getActivityCode();
        List<String> workItemSource = querySpec.getWorkItemSource();
        String filterWorkflowInstanceId = querySpec.getFilterWorkflowInstanceId();
        String endStatus = querySpec.getEndStatus();

        final StringBuilder querySql = new StringBuilder();
        boolean isProcessing = false;
        boolean isCancel = false;
        //异常的流程按发起时间排序
        boolean isException = false;

        if (!CollectionUtils.isEmpty(instanceStatusList)) {
            for (WorkflowInstanceStatus status : instanceStatusList) {
                if (status == WorkflowInstanceStatus.PROCESSING) {
                    isProcessing = true;
                } else if (status == WorkflowInstanceStatus.CANCELED) {
                    isCancel = true;
                } else if (status == WorkflowInstanceStatus.EXCEPTION) {
                    isException = true;
                }
            }
        }

        if (isProcessing) {
            querySql.append(" SELECT WF.id id, WF.appCode  \"appCode\", WF.schemaCode \"schemaCode\", WF.finishTime " +
                    "\"finishTime\", WF.startTime \"startTime\", WF.bizObjectId  \"bizObjectId\", WF.departmentId " +
                    "\"departmentId\",");
            querySql.append("  	  WF.departmentName \"departmentName\",WF.instanceName \"instanceName\",WF" +
                    ".originator" +
                    " " +
                    "\"originator\",");
            querySql.append("  	  WF.trustType \"trustType\",WF.trustee \"trustee\",WF.trusteeName \"trusteeName\"," +
                    "WF" +
                    ".dataType \"dataType\",WF.runMode \"runMode\", ");
            querySql.append("  WF.originatorName \"originatorName\",WF.state \"stateString\" ,WF.workflowCode " +
                    "\"workflowCode\",WF.workflowName \"workflowName\",WF.source \"source\",WF.workflowVersion " +
                    "\"workflowVersion\",WF.sequenceNo \"sequenceNo\",");
            //当前处理人名称
            querySql.append("    (SELECT item.participantName FROM biz_workitem item WHERE item.id = (SELECT MIN(BW" +
                    ".id) FROM biz_workitem BW WHERE BW.instanceId = WF.id");
            //添加节点名称和处理人添加搜索
            addConditionByActivityCodeAndNameAndParticipantId(querySql, activityCode, activityName, participantId,
                    workItemSource);
            querySql.append(") ) AS  \"participantName\" , ");
            //当前节点编码
            querySql.append("    (SELECT item.activityCode FROM biz_workitem item WHERE item.id = (SELECT MIN(BW.id) " +
                    "FROM biz_workitem BW WHERE BW.instanceId = WF.id");
            //添加节点名称和处理人添加搜索
            addConditionByActivityCodeAndNameAndParticipantId(querySql, activityCode, activityName, participantId,
                    workItemSource);
            querySql.append(") ) AS   \"activityCode\" , ");
            //当前节点名称
            querySql.append("    (SELECT item.activityName FROM biz_workitem item WHERE item.id = (SELECT MIN(BW.id) " +
                    "FROM biz_workitem BW WHERE BW.instanceId = WF.id");
            //添加节点名称和处理人添加搜索
            addConditionByActivityCodeAndNameAndParticipantId(querySql, activityCode, activityName, participantId,
                    workItemSource);
            querySql.append(") ) AS   \"activityName\", ");
            //当前节点处理人ID
            querySql.append("    (SELECT item.participant FROM biz_workitem item WHERE item.id = (SELECT MIN(BW.id) " +
                    "FROM biz_workitem BW WHERE BW.instanceId = WF.id");
            //添加节点名称和处理人添加搜索
            addConditionByActivityCodeAndNameAndParticipantId(querySql, activityCode, activityName, participantId,
                    workItemSource);
            querySql.append(") ) AS   \"participant\"  ");
            querySql.append(" FROM	biz_workflow_instance WF ");
            querySql.append(" WHERE 1 = 1 %1$s ");
            querySql.append(" ORDER BY WF.startTime desc ");
        } else {
            querySql.append("SELECT WF.id \"id\",WF.appCode \"appCode\",WF.schemaCode \"schemaCode\",WF.finishTime " +
                    "\"finishTime\",WF.startTime \"startTime\",WF.bizObjectId \"bizObjectId\",");
            querySql.append("WF.departmentId \"departmentId\",WF.departmentName \"departmentName\",WF.instanceName " +
                    "\"instanceName\",");
            querySql.append("WF.originator \"originator\",WF.originatorName \"originatorName\",WF.state " +
                    "\"stateString\",");
            querySql.append("WF.trustType \"trustType\",WF.trustee \"trustee\",WF.trusteeName \"trusteeName\",");
            querySql.append("WF.dataType \"dataType\",WF.runMode \"runMode\",");
            querySql.append("WF.workflowCode \"workflowCode\",WF.workflowName \"workflowName\",WF.source \"source\"," +
                    "WF.workflowVersion \"workflowVersion\", WF.sequenceNo \"sequenceNo\" ");

            if (CollectionUtils.isEmpty(instanceStatusList) || isException) {
                querySql.append(" FROM biz_workflow_instance WF WHERE 1 = 1 %1$s ORDER BY WF.startTime desc");
            } else {
                querySql.append(" FROM biz_workflow_instance WF WHERE 1 = 1 %1$s ORDER BY WF.finishTime desc");
            }
        }

        final Map<String, Object> params = Maps.newHashMapWithExpectedSize(16);
        final String countSql = "SELECT COUNT(1) FROM biz_workflow_instance WF WHERE 1 = 1 ";
        final StringBuilder conditions = new StringBuilder();

        if (unitType != null) {
            switch (unitType) {
                case USER:
                    if (!StringUtils.isEmpty(originator)) {
                        conditions.append(" AND (WF.originator = :originator or  WF.trustee = :trustee) ");
                        params.put("originator", originator);
                        params.put("trustee", originator);
                    }
                    break;
                case ROLE:
                    break;
                case DEPARTMENT:
                    DepartmentModel department = departmentFacade.get(originator);
                    if (department != null && org.apache.commons.lang3.StringUtils.isNotBlank(department.getQueryCode())) {
                        List<String> queryCodes = Lists.newArrayList();
                        queryCodes.add(department.getQueryCode());
                        List<DepartmentModel> departments = departmentFacade.listByQueryCodes(queryCodes, Boolean.TRUE);
                        if (!CollectionUtils.isEmpty(departments)) {
                            List<String> depts =
                                    departments.stream().map(DepartmentModel::getId).collect(Collectors.toList());
                            conditions.append(" and WF.departmentId in :originatorDepartments ");
                            params.put("originatorDepartments", depts);
                        }
                    }
                    break;
                default:
            }
        }
        //当前用户，不能查看不属于自己的草稿
        if (!StringUtils.isEmpty(currentUserId)) {
            conditions.append(" AND WF.state != 'DRAFT' ");
        }
        if (!StringUtils.isEmpty(workflowName)) {
            conditions.append(" AND WF.instanceName like :instanceName ");
            params.put("instanceName", '%' + workflowName + '%');
        }
        if (!StringUtils.isEmpty(workflowCode)) {
            conditions.append(" AND WF.workflowCode = :workflowCode ");
            params.put("workflowCode", workflowCode);
        }
        if (!StringUtils.isEmpty(appCode)) {
            conditions.append(" AND WF.appCode = :appCode ");
            params.put("appCode", appCode);
        }
        dataType = dataType == null ? ProcessDataType.NORMAL : dataType;
        conditions.append(" AND WF.dataType = :dataType ");
        params.put("dataType", dataType.name());

        if (!CollectionUtils.isEmpty(instanceStatusList)) {
            conditions.append(" AND ( ");
            for (int i = 0; i < instanceStatusList.size(); i++) {
                conditions.append(i == 0 ? "" : " OR ");
                conditions.append(" WF.state = :instanceState").append(i);

                params.put("instanceState" + i, instanceStatusList.get(i).toString());
            }
            conditions.append("  ) ");
        }
        if (!StringUtils.isEmpty(startTime)) {
            if (isCancel) {
                conditions.append(" AND WF.finishTime >= :startTime ");
            } else {
                conditions.append(" AND WF.startTime >= :startTime ");
            }
            params.put("startTime", DateUtils.formateDateTime(startTime));
        }
        if (!StringUtils.isEmpty(endTime)) {
            if (isCancel) {
                conditions.append(" AND WF.finishTime <= :endTime ");
            } else {
                conditions.append(" AND WF.startTime <= :endTime ");
            }
            params.put("endTime", DateUtils.formateDateTime(endTime));
        }

        if (!StringUtils.isEmpty(squenceNo)) {
            conditions.append(" AND sequenceNo like :squenceNo ");
            params.put("squenceNo", '%' + squenceNo + '%');
        }

        if (workflowVersion != null) {
            conditions.append(" AND WF.workflowVersion = :workflowVersion ");
            params.put("workflowVersion", workflowVersion);
        }

        if (!StringUtils.isEmpty(filterWorkflowInstanceId)) {
            conditions.append(" AND WF.id <> :filterWorkflowInstanceId ");
            params.put("filterWorkflowInstanceId", filterWorkflowInstanceId);
        }

        if (!StringUtils.isEmpty(participantId) || !StringUtils.isEmpty(activityCode)
                || !StringUtils.isEmpty(activityName) || !CollectionUtils.isEmpty(workItemSource)) {
            conditions.append(" AND EXISTS(SELECT 1 FROM biz_workitem wk WHERE wk.instanceId = WF.id");
            if (!StringUtils.isEmpty(participantId)) {
                conditions.append(" AND wk.participant = :participantId");
                params.put("participantId", participantId);
            }
            if (!StringUtils.isEmpty(activityCode)) {
                conditions.append(" AND wk.activityCode = :activityCode");
                params.put("activityCode", activityCode);
            }
            if (!StringUtils.isEmpty(activityName)) {
                conditions.append(" AND wk.activityName like :activityName");
                params.put("activityName", "%" + activityName + "%");
            }
            if (!CollectionUtils.isEmpty(workItemSource)) {
                conditions.append(" AND wk.workItemSource in :workItemSource");
                params.put("workItemSource", workItemSource);
            }
            conditions.append(')');
        }
        //子管理员和特权人管理范围
        String getManageScope = getManageScopeCondition(workflowCodes, appScopes, params);
        if (!StringUtils.isEmpty(getManageScope)) {
            conditions.append(getManageScope);
        }
        //流程结束状态
        if (StringUtils.isNotBlank(endStatus)) {
            if (WorkflowEndStatus.APPROVAL.name().equalsIgnoreCase(endStatus)) {
                conditions.append(" AND (WF.remark = :endStatus or WF.remark is null) ");
            } else {
                conditions.append(" AND WF.remark = :endStatus ");
            }
            params.put("endStatus", endStatus);
        }
        final String finalQuerySql = String.format(querySql.toString(), conditions);
        final String finalCountSql = countSql + conditions;
        return new NativeSqlInfo(finalQuerySql, finalCountSql, params);
    }

    /**
     * @param querySql
     * @param activityCode
     * @param activityName
     * @param participantId
     * @param workItemSource
     */
    private void addConditionByActivityCodeAndNameAndParticipantId(StringBuilder querySql, String activityCode,
                                                                   String activityName, String participantId,
                                                                   List<String> workItemSource) {
        if (!StringUtils.isEmpty(participantId)) {
            querySql.append(" AND BW.participant = :participantId");
        }
        if (!StringUtils.isEmpty(activityCode)) {
            querySql.append(" AND BW.activityCode = :activityCode");
        }
        if (!StringUtils.isEmpty(activityName)) {
            querySql.append(" AND BW.activityName like :activityName");
        }
        if (!CollectionUtils.isEmpty(workItemSource)) {
            querySql.append(" AND BW.workItemSource in :workItemSource");
        }
    }


    /**
     * 子管理员和特权人管理范围 OR
     *
     * @param workflowCodes
     * @param appScopes
     * @param params
     * @return
     */
    private String getManageScopeCondition(List<String> workflowCodes,
                                           Map<String, Map<String, List<String>>> appScopes,
                                           Map<String, Object> params) {
        StringBuilder sb = new StringBuilder();
        StringBuilder workflowCodeCondition = new StringBuilder();
        StringBuilder scopeCondition = new StringBuilder();
        //流程管理员管理范围
        if (!CollectionUtils.isEmpty(workflowCodes)) {
            workflowCodeCondition.append("(WF.workflowCode in :workflowCodes)");
            params.put("workflowCodes", workflowCodes);
        }
        //子管理员管理范围
        if (!MapUtils.isEmpty(appScopes)) {
            int i = 0;
            //子管理员管理的应用范围和组织管辖范围
            for (Map.Entry<String, Map<String, List<String>>> entry : appScopes.entrySet()) {
                String adminAppCode = entry.getKey();
                Map<String, List<String>> appScope = entry.getValue();
                if (MapUtils.isEmpty(appScope)) {
                    continue;
                }
                StringBuilder condition = new StringBuilder("WF.appCode = :adminAppCode").append(i);
                params.put("adminAppCode" + i, adminAppCode);
                //外链数据和管理范围为OR条件
                List<String> userIds = appScope.get("userId");
                List<String> departmentIds = appScope.get("deptIds");
                StringBuilder orgCondition = new StringBuilder();
                if (!CollectionUtils.isEmpty(userIds)) {
                    orgCondition.append("WF.originator = :userId").append(i).append(" OR WF.trustee = :userId").append(i);
                    params.put("userId" + i, userIds.get(0));
                }
                //管理范围条件
                addOrgCondition(orgCondition, departmentIds, params, i);
                if (org.apache.commons.lang3.StringUtils.isNotBlank(orgCondition)) {
                    condition.append(" AND (").append(orgCondition).append(')');
                }
                if (i > 0) {
                    scopeCondition.append(" OR ");
                }
                scopeCondition.append('(').append(condition).append(')');
                i++;
            }
        }
        StringBuilder appScopeCondition = new StringBuilder();
        if (org.apache.commons.lang3.StringUtils.isNotBlank(workflowCodeCondition)) {
            appScopeCondition.append(workflowCodeCondition);
        }
        if (org.apache.commons.lang3.StringUtils.isNotBlank(scopeCondition)) {
            if (org.apache.commons.lang3.StringUtils.isNotBlank(appScopeCondition)) {
                appScopeCondition.append(" OR ");
            }
            appScopeCondition.append(scopeCondition);
        }
        if (org.apache.commons.lang3.StringUtils.isNotBlank(appScopeCondition)) {
            sb.append(" AND (").append(appScopeCondition).append(')');
        }
        return sb.toString();
    }

    /**
     * 管理范围条件
     *
     * @param orgCondition
     * @param departmentIds
     * @param params
     * @param index
     */
    private void addOrgCondition(StringBuilder orgCondition, List<String> departmentIds, Map<String, Object> params,
                                 int index) {
        if (CollectionUtils.isEmpty(departmentIds)) {
            return;
        }
        List<DepartmentModel> departmentList = departmentFacade.listByIdList(departmentIds);
        if (CollectionUtils.isEmpty(departmentList)) {
            return;
        }
        List<String> queryCodes =
                departmentList.stream().filter(department -> !StringUtils.isEmpty(department.getQueryCode())).map(DepartmentModel::getQueryCode).collect(Collectors.toList());
        if (CollectionUtils.isEmpty(queryCodes)) {
            return;
        }
        //如果开启了组织独立数据源，只能通过查询所有相关部门的ID进行in查询
        if (dataSourceSwitch) {
            List<DepartmentModel> departments = departmentFacade.listByQueryCodes(queryCodes);
            if (CollectionUtils.isEmpty(departments)) {
                return;
            }
            List<String> deptIds = departments.stream().map(DepartmentModel::getId).collect(Collectors.toList());
            if (org.apache.commons.lang3.StringUtils.isNotBlank(orgCondition)) {
                orgCondition.append(" OR ");
            }
            List<List<String>> subList = ListUtils.partition(deptIds, 1000);
            for (int i = 0; i < subList.size(); i++) {
                String paramKey = "departmentIds" + index + "_" + i;
                List<String> paramValue = subList.get(i);
                orgCondition.append(" WF.departmentId in :").append(paramKey);
                params.put(paramKey, paramValue);
                if (i < subList.size() - 1) {
                    orgCondition.append(" OR ");
                }
            }
            //未开启组织独立数据源，直接关联查询
        } else {
            if (org.apache.commons.lang3.StringUtils.isNotBlank(orgCondition)) {
                orgCondition.append(" OR ");
            }
            for (int i = 0; i < queryCodes.size(); i++) {
                String paramKey = "queryCode" + index + "_" + i;
                String paramValue = queryCodes.get(i);
                String paramLikeKey = "like" + paramKey;
                String paramLikeValue = paramValue + "#%";
                orgCondition.append(" WF.departmentId IN(SELECT id from h_org_department where queryCode = :").append(paramKey).append(" or queryCode like :").append(paramLikeKey).append(')');
                params.put(paramKey, paramValue);
                params.put(paramLikeKey, paramLikeValue);
                if (i < queryCodes.size() - 1) {
                    orgCondition.append(" OR ");
                }
            }
        }
    }

}

