alter table h_app_package modify code varchar(40) not null;
create unique index uq_code on h_app_package (code);

alter table h_app_group modify code varchar(40) not null;
create unique index uq_code on h_app_group (code);

alter table h_app_function modify appCode varchar(40) not null;
alter table h_app_function modify code varchar(40) not null;
alter table h_app_function modify type varchar(40) not null;
drop index idx_type_ac on h_app_function;
create index idx_type_ac on h_app_function (appCode, type);
create index idx_parentId on h_app_function (parentId);

alter table h_custom_page modify code varchar(40) not null;
alter table h_custom_page modify openMode varchar(40) not null;
alter table h_custom_page modify appCode varchar(40) not null;

alter table h_biz_schema modify code varchar(40) not null;
alter table h_biz_schema modify published bit not null;
drop index idx_schemaCode on h_biz_schema;
create unique index uq_schemaCode on h_biz_schema (code);

alter table h_biz_sheet modify code varchar(40) not null;
alter table h_biz_sheet modify schemaCode varchar(40) not null;
alter table h_biz_sheet modify sheetType varchar(50) not null;
create unique index uq_schema_code on h_biz_sheet (schemaCode, code);

alter table h_biz_property modify code varchar(40) not null;
alter table h_biz_property modify propertyType varchar(40) not null;
alter table h_biz_property modify published bit not null;
alter table h_biz_property modify schemaCode varchar(40) not null;
drop index Idx_schemaCode on h_biz_property;

alter table h_biz_data_rule modify schemaCode varchar(40) not null;
alter table h_biz_data_rule modify propertyCode varchar(40) not null;
alter table h_biz_data_rule modify dataRuleType varchar(40) not null;
create index idx_schemaCode on h_biz_data_rule (schemaCode, propertyCode);

alter table h_business_rule modify bizRuleType varchar(15) collate utf8_bin not null;
alter table h_business_rule modify code varchar(40) collate utf8_bin not null;
alter table h_business_rule modify schemaCode varchar(40) collate utf8_bin not null;
create index idx_schema_code on h_business_rule (schemaCode, code);

alter table h_biz_button modify schemaCode varchar(40) not null comment '模型编码';
alter table h_biz_button modify code varchar(40) not null comment '按钮编码';
alter table h_biz_button modify triggerCode varchar(40) not null comment '调用方编码（视图、表单）';
alter table h_biz_button modify triggerType varchar(40) not null comment '调用方类型（视图、表单）';
alter table h_biz_button modify showPermCode varchar(40) not null comment '显示权限，绑定对象编码';
alter table h_biz_button modify showPermType varchar(40) not null comment '显示权限，绑定对象类型';

alter table h_biz_query modify code varchar(40) not null;
alter table h_biz_query modify schemaCode varchar(40) not null;
create unique index uq_schema_code on h_biz_query (schemaCode, code);

alter table h_biz_query_action modify actionCode varchar(40) not null;
alter table h_biz_query_action modify queryId varchar(36) not null;
alter table h_biz_query_action modify schemaCode varchar(40) not null;
alter table h_biz_query_action modify clientType varchar(40) default 'PC' not null comment 'PC或者MOBILE端';
create index idx_queryId_actionCode on h_biz_query_action (queryId, actionCode);

alter table h_biz_query_column modify propertyCode varchar(40) not null;
alter table h_biz_query_column modify propertyType varchar(40) not null;
alter table h_biz_query_column modify queryId varchar(36) not null;
alter table h_biz_query_column modify schemaCode varchar(40) not null;
alter table h_biz_query_column modify clientType varchar(40) default 'PC' not null comment 'PC或者MOBILE端';

alter table h_biz_query_condition modify propertyCode varchar(40) not null;
alter table h_biz_query_condition modify propertyType varchar(40) not null;
alter table h_biz_query_condition modify queryId varchar(36) not null;
alter table h_biz_query_condition modify schemaCode varchar(40) not null;
alter table h_biz_query_condition modify clientType varchar(40) default 'PC' not null comment 'PC或者MOBILE端';

alter table h_biz_query_sorter modify propertyCode varchar(40) not null;
alter table h_biz_query_sorter modify propertyType varchar(40) not null;
alter table h_biz_query_sorter modify queryId varchar(36) not null;
alter table h_biz_query_sorter modify schemaCode varchar(40) not null;
alter table h_biz_query_sorter modify clientType varchar(40) default 'PC' not null comment 'PC或者MOBILE端';
create index idx_queryId on h_biz_query_sorter (queryId);

alter table h_biz_query_present modify queryId varchar(36) not null;
alter table h_biz_query_present modify schemaCode varchar(40) not null;
alter table h_biz_query_present modify clientType varchar(40) not null comment 'PC或者MOBILE端';
create unique index uq_queryId_clientType on h_biz_query_present (queryId, clientType);

alter table h_biz_data_track modify bizObjectId varchar(120) not null comment '留痕的表单ID';
alter table h_biz_data_track modify schemaCode varchar(40) not null comment '所属数据模型编码';
create index idx_bizObjectId on h_biz_data_track (bizObjectId);

alter table h_biz_data_track_detail modify trackId varchar(120) not null comment '留痕记录ID';
alter table h_biz_data_track_detail modify bizObjectId varchar(120) not null comment '留痕的表单ID';
create index idx_track_id on h_biz_data_track_detail (trackId);

alter table h_biz_data_track_child modify detailId varchar(120) not null comment '留痕详情ID';
alter table h_biz_data_track_child modify schemaCode varchar(40) not null comment '子表模型编码';
alter table h_biz_data_track_child modify operationType varchar(40) not null comment '子表操作类型：Added、Modified、Deleted';

alter table h_workflow_header modify schemaCode varchar(40) not null;
alter table h_workflow_header modify workflowCode varchar(40) not null;
create index idx_schemaCode on h_workflow_header (schemaCode);

alter table h_workflow_template modify workflowCode varchar(40) not null;

alter table h_workflow_permission modify unitId varchar(36) not null;
alter table h_workflow_permission modify unitType varchar(10) not null;
alter table h_workflow_permission modify workflowCode varchar(40) not null;
create index idx_workflowCode on h_workflow_permission (workflowCode);

alter table h_workflow_admin modify workflowCode varchar(200) not null;

alter table h_workflow_admin_scope modify adminId varchar(120) not null;
alter table h_workflow_admin_scope modify unitId varchar(36) not null;
alter table h_workflow_admin_scope modify unitType varchar(10) not null;

alter table h_workflow_relative_event modify schemaCode varchar(40) not null comment '模型编码';
alter table h_workflow_relative_event modify workflowCode varchar(40) not null comment '流程编码';
alter table h_workflow_relative_event modify bizMethodCode varchar(40) not null comment '业务方法编码';

alter table h_workflow_relative_object modify workflowCode varchar(40) not null;
alter table h_workflow_relative_object modify workflowVersion int not null;

alter table biz_workflow_instance modify bizObjectId varchar(36) not null comment '业务类ID';
alter table biz_workflow_instance modify workflowCode varchar(200) not null comment '流程模板编码';
alter table biz_workflow_instance modify workflowVersion int not null comment '流程模板版本号';
alter table biz_workflow_instance modify originator varchar(200) not null comment '发起人';
alter table biz_workflow_instance modify state varchar(200) not null comment '流程实例状态';
alter table biz_workflow_instance modify schemaCode varchar(40) not null comment '模型编码';

alter table biz_workflow_token modify activityCode varchar(200) not null;
alter table biz_workflow_token modify instanceId varchar(36) not null;
alter table biz_workflow_token modify activityType varchar(20) not null;

alter table biz_workitem modify workflowCode varchar(200) not null comment '流程模板编码';
alter table biz_workitem modify workflowVersion int not null comment '流程模板版本';
alter table biz_workitem modify originator varchar(200) not null comment '流程实例发起人';
alter table biz_workitem modify participant varchar(200) not null comment '参与者';
alter table biz_workitem modify instanceId varchar(36) not null comment '流程实例ID';
alter table biz_workitem modify activityCode varchar(200) not null comment '活动节点编码';
alter table biz_workitem modify workItemType varchar(20) not null;
alter table biz_workitem modify workflowTokenId varchar(200) not null;
create index idx_workflowCode on biz_workitem (workflowCode);

alter table biz_workitem_finished modify workflowCode varchar(200) not null comment '流程模板编码';
alter table biz_workitem_finished modify workflowVersion int not null comment '流程模板版本';
alter table biz_workitem_finished modify originator varchar(200) not null comment '流程实例发起人';
alter table biz_workitem_finished modify participant varchar(200) not null comment '参与者';
alter table biz_workitem_finished modify instanceId varchar(36) not null comment '流程实例ID';
alter table biz_workitem_finished modify state varchar(36) not null comment '工作任务状态';
alter table biz_workitem_finished modify activityCode varchar(200) not null comment '活动节点编码';
alter table biz_workitem_finished modify workItemType varchar(20) not null;
alter table biz_workitem_finished modify workflowTokenId varchar(200) not null;
create index idx_workflowCode on biz_workitem_finished (workflowCode);

alter table biz_circulateitem modify activityCode varchar(200) not null;
alter table biz_circulateitem modify instanceId varchar(36) not null;
alter table biz_circulateitem modify participant varchar(200) not null;
alter table biz_circulateitem modify sourceId varchar(200) not null;
alter table biz_circulateitem modify workflowCode varchar(36) not null;
alter table biz_circulateitem modify workflowVersion int not null;
alter table biz_circulateitem modify workflowTokenId varchar(200) not null;

alter table biz_circulateitem_finished modify activityCode varchar(200) not null;
alter table biz_circulateitem_finished modify instanceId varchar(36) not null;
alter table biz_circulateitem_finished modify participant varchar(200) not null;
alter table biz_circulateitem_finished modify workflowCode varchar(36) not null;
alter table biz_circulateitem_finished modify workflowVersion int not null;
alter table biz_circulateitem_finished modify workflowTokenId varchar(200) not null;

alter table h_biz_comment modify activityCode varchar(40) not null;

create unique index uq_code on h_biz_database_pool (code);

alter table h_biz_service_category modify name varchar(50) not null;

alter table h_biz_service modify code varchar(40) not null;
alter table h_biz_service modify serviceCategoryId varchar(40) not null;
alter table h_biz_service modify adapterCode varchar(40) not null;
create unique index uq_code on h_biz_service (code);

alter table h_biz_service_method modify code varchar(40) not null;
alter table h_biz_service_method modify serviceCode varchar(40) not null;
create unique index uq_service_code on h_biz_service_method (serviceCode, code);

alter table h_biz_method_mapping modify methodCode varchar(40) not null;
alter table h_biz_method_mapping modify schemaCode varchar(40) not null;
alter table h_biz_method_mapping modify serviceCode varchar(40) not null;
alter table h_biz_method_mapping modify serviceMethodCode varchar(40) not null;
alter table h_biz_method_mapping modify businessRuleId varchar(40) not null comment '关联的业务规则id';
alter table h_biz_method_mapping modify nodeCode varchar(40) not null comment '关联的业务规则节点';
create index idx_schemaCode on h_biz_method_mapping (schemaCode);
create index idx_service_methodCode on h_biz_method_mapping (serviceCode, methodCode);

alter table h_data_dictionary modify code varchar(50) not null comment '字典编码';
alter table h_data_dictionary modify dictionaryType varchar(40) not null comment '字典类型';
alter table h_data_dictionary modify status bit not null comment '启用状态';
create unique index uq_code on h_data_dictionary (code);

alter table h_dictionary_record modify code varchar(50) not null comment '字典数据编码';
alter table h_dictionary_record modify dictionaryId varchar(120) not null comment '所属字典ID';
alter table h_dictionary_record modify status bit not null comment '字典数据启用状态';
create index idx_dictionaryId on h_dictionary_record (dictionaryId);

alter table h_related_corp_setting modify corpId varchar(120) collate utf8mb4_general_ci not null comment '组织的corpId';
alter table h_related_corp_setting modify orgType varchar(12) collate utf8mb4_general_ci not null comment '第三方类型';
alter table h_related_corp_setting modify relatedType varchar(12) collate utf8mb4_general_ci not null comment '组织类型';
alter table h_related_corp_setting modify syncType varchar(12) collate utf8mb4_general_ci not null comment '同步方式';
create unique index uq_corpId on h_related_corp_setting (corpId);

update h_org_department set sourceId = null where sourceId = '';
create index idx_queryCode on h_org_department (queryCode);

alter table h_org_dept_user modify deptId varchar(36) not null;
alter table h_org_dept_user modify userId varchar(36) not null;

update h_org_user set corpId = 'main',userId = 'xuser' where username = 'xuser' and corpId is null;
update h_org_user set corpId = 'main',userId = 'admin' where username = 'admin' and corpId is null;
alter table h_org_user modify corpId varchar(256) not null;
alter table h_org_user modify username varchar(40) not null;
alter table h_org_user modify userId varchar(255) not null;
drop index UK_rj7duahtop7qmf2ka0kxs57i0 on h_org_user;
drop index idx_corpId_userId on h_org_user;
create index idx_corpId_userId on h_org_user (userId, corpId);

alter table h_org_role_group modify code varchar(180) not null;
alter table h_org_role_group modify roleType varchar(40) default 'SYS' not null comment '角色类型';
alter table h_org_role_group modify corpId varchar(256) not null;
create unique index idx_corpId_sourceId on h_org_role_group (corpId, sourceId);

alter table h_org_role modify code varchar(180) not null;
alter table h_org_role modify groupId varchar(36) not null;
alter table h_org_role modify roleType varchar(40) default 'SYS' not null comment '角色类型';
alter table h_org_role modify corpId varchar(256) not null;
drop index idx_rolde_name on h_org_role;
drop index idx_role_id on h_org_role;
create index idx_groupId on h_org_role (groupId);

alter table h_org_role_user modify roleId varchar(36) not null;
drop index idx_role_user_composeid on h_org_role_user;
drop index idx_role_user_id on h_org_role_user;
drop index idx_role_user_sourceid on h_org_role_user;
create index idx_userId on h_org_role_user (userId);
create index idx_roleId on h_org_role_user (roleId);

alter table h_org_user_extend_attr modify code varchar(120) default '' not null comment '编码code';
alter table h_org_user_extend_attr modify mapKey varchar(120) default '' not null comment '映射key';
alter table h_org_user_extend_attr modify corpId varchar(128) default 'ALL' not null comment '组织ID';
drop index IDX_corpId on h_org_user_extend_attr;
drop index UK_code_corpId on h_org_user_extend_attr;
create unique index UK_code_corpId on h_org_user_extend_attr (corpId, code);

alter table h_org_user_transfer_record modify sourceUserId varchar(120) not null;
alter table h_org_user_transfer_record modify receiveUserId varchar(120) not null;
alter table h_org_user_transfer_record modify transferType varchar(32) not null;
create index idx_sourceUser on h_org_user_transfer_record (sourceUserId);

alter table h_perm_selection_scope modify departmentId varchar(120) not null;
alter table h_perm_selection_scope modify deptVisibleType varchar(40) not null;
alter table h_perm_selection_scope modify staffVisibleType varchar(40) not null;
create unique index uq_departmentId on h_perm_selection_scope (departmentId);

alter table h_user_common_comment modify userId varchar(36) not null;
create index idx_userId on h_user_common_comment (userId);

alter table h_user_favorites modify bizObjectKey varchar(80) not null;
alter table h_user_favorites modify bizObjectType varchar(40) not null;
alter table h_user_favorites modify userId varchar(36) not null;

alter table h_perm_app_package modify appCode varchar(40) not null;
alter table h_perm_app_package modify visibleType varchar(40) not null;
create unique index uq_appCode on h_perm_app_package (appCode);

alter table h_perm_group modify appCode varchar(40) not null;
alter table h_perm_group modify authorType varchar(40) not null comment ' 授权类型';
create index idx_appCode on h_perm_group (appCode);

alter table h_biz_perm_group modify schemaCode varchar(40) not null;
alter table h_biz_perm_group modify appPermGroupId varchar(120) not null comment '关联的应用管理权限组ID';
create index idx_appPermGroupId on h_biz_perm_group (appPermGroupId);
create index idx_schemaCode on h_biz_perm_group (schemaCode);

alter table h_biz_perm_property modify bizPermType varchar(40) not null;
alter table h_biz_perm_property modify groupId varchar(40) not null;
alter table h_biz_perm_property modify propertyCode varchar(40) not null;
alter table h_biz_perm_property modify propertyType varchar(40) not null;
alter table h_biz_perm_property modify schemaCode varchar(40) not null comment '模型编码';
create index idx_groupId on h_biz_perm_property (groupId);

alter table h_perm_biz_function modify dataPermissionType varchar(40) not null;
alter table h_perm_biz_function modify functionCode varchar(40) not null;
alter table h_perm_biz_function modify permissionGroupId varchar(40) not null;
alter table h_perm_biz_function modify schemaCode varchar(40) not null;
alter table h_perm_biz_function modify visible bit not null;
create index idx_permissionGroupId on h_perm_biz_function (permissionGroupId);
create index idx_schemaCode on h_perm_biz_function (schemaCode);

alter table h_perm_function_condition modify schemaCode varchar(40) not null;
alter table h_perm_function_condition modify functionId varchar(40) not null;
create index idx_functionId on h_perm_function_condition (functionId);
create index idx_schemaCode on h_perm_function_condition (schemaCode);

alter table h_perm_admin modify adminType varchar(40) not null;
alter table h_perm_admin modify userId varchar(40) not null;
create unique index uq_userId_type on h_perm_admin (userId, adminType);

create index idx_adminId on h_perm_admin_group (adminId);

alter table h_perm_apppackage_scope modify adminId varchar(40) not null;
alter table h_perm_apppackage_scope modify code varchar(40) not null;
create index idx_adminId on h_perm_apppackage_scope (adminId);

alter table h_perm_department_scope modify adminId varchar(40) not null;
alter table h_perm_department_scope modify unitId varchar(40) not null;
alter table h_perm_department_scope modify unitType varchar(10) not null;
create index idx_adminId on h_perm_department_scope (adminId);
