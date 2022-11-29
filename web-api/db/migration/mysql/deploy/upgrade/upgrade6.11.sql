ALTER TABLE  h_biz_query_condition ADD COLUMN filterType varchar(10)  NULL DEFAULT NULL COMMENT '查询条件筛选类型';

ALTER TABLE h_biz_query_present ADD COLUMN options longtext NULL COMMENT '额外配置参数';

update h_biz_property set propertyLength = 200 where code='sequenceNo';

ALTER TABLE h_system_sequence_no add schemaCode varchar(120) COMMENT '数据模型编码';

ALTER TABLE h_system_sequence_no add filterCondition varchar(200) COMMENT '过滤条件';

ALTER TABLE d_process_task MODIFY COLUMN taskId varchar(50) NOT NULL COMMENT '钉钉待办id' AFTER `processInstanceId`;
ALTER TABLE d_process_task MODIFY COLUMN processInstanceId varchar(64) NULL AFTER `id`;

CREATE TABLE if not exists `h_user_common_query` (
  `id` varchar(120) NOT NULL COMMENT '主键id',
  `name` varchar(100) DEFAULT NULL COMMENT '名字',
  `type` varchar(40) CHARACTER SET utf8 NOT NULL DEFAULT 'VIEW_QUERY' COMMENT '类型 VIEW_QUERY:视图查询 VIEW_EXPORT_QUERY:视图导出查询 ',
  `schemaCode` varchar(40) NOT NULL COMMENT '模型编码',
  `queryCode` varchar(40) NOT NULL COMMENT '需要查询对象的code',
  `userId` varchar(36) NOT NULL COMMENT '用户ID',
  `sort` smallint(6) DEFAULT '0' COMMENT '序列号',
  `patientia` bit(1) DEFAULT 0 COMMENT '是否默认 1：默认 0：非默认',
  `createdTime` datetime NOT NULL COMMENT '创建时间',
  `modifiedTime` datetime DEFAULT NULL COMMENT '更新时间',
  `queryCondition` text DEFAULT NULL COMMENT '查询条件',
  KEY `index_common_query_s_u` (`schemaCode`,`userId`) USING BTREE COMMENT '用户常用查询schemaCode_userId索引'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户常用查询条件';

CREATE TABLE if not exists `h_biz_query_gantt` (
  `id` varchar(120)  NOT NULL,
  `creater` varchar(120)  DEFAULT NULL,
  `createdTime` datetime DEFAULT NULL,
  `deleted` bit(1) DEFAULT NULL,
  `modifier` varchar(120)  DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `remarks` varchar(200)  DEFAULT NULL,
  `queryId` varchar(36)  DEFAULT NULL,
  `schemaCode` varchar(40)  DEFAULT NULL COMMENT '模型code',
  `startTimePropertyCode` varchar(40)  DEFAULT NULL COMMENT '开始时间对应数据项code',
  `endTimePropertyCode` varchar(40)  DEFAULT NULL COMMENT '结束时间对应数据项code',
  `configJson` longtext  COMMENT '展示配置JSON数据',
  `progressPropertyCode` varchar(40)  DEFAULT NULL COMMENT '进度对应数据项code',
  `titlePropertyCode` varchar(40)  DEFAULT NULL COMMENT '标题对应数据项code',
  `preDependencyPropertyCode` varchar(40)  DEFAULT NULL COMMENT '前置依赖对应数据项code',
  `endDependencyPropertyCode` varchar(40)  DEFAULT NULL COMMENT '后置依赖对应数据项code',
  `levelPropertyCode` varchar(40)  DEFAULT NULL COMMENT '层级关系对应数据项code',
  `milepostCode` varchar(40)  DEFAULT NULL COMMENT '里程碑任务对应数据项code',
  `defaultPrecision` varchar(40)  DEFAULT NULL COMMENT '默认时间精度',
  `sortKey` varchar(40)  DEFAULT NULL COMMENT '排序字段',
  `liableManCode` varchar(40)  DEFAULT NULL COMMENT '责任人对应数据项code',
  `statusCode` varchar(40)  DEFAULT NULL COMMENT '状态对应数据项code',
  PRIMARY KEY (`id`),
  KEY `Idx_schemaCode` (`schemaCode`),
  KEY `Idx_queryid` (`queryId`)
) ENGINE=InnoDB COMMENT='甘特图配置';

ALTER TABLE h_system_pair ADD COLUMN uniqueCode varchar(120) NULL COMMENT '唯一码';
ALTER TABLE h_system_pair ADD COLUMN type varchar(40) NULL COMMENT '类型';
ALTER TABLE h_system_pair ADD COLUMN expireTime datetime(3) NULL COMMENT '过期时间';
create unique index idx_u_code on h_system_pair (uniqueCode);

ALTER TABLE h_perm_group ADD COLUMN sortKey int(11) DEFAULT NULL COMMENT '排序字段';

-- h_user_common_query表增加filterFixed字段
ALTER TABLE h_user_common_query ADD COLUMN filterFixed bit(1) DEFAULT 0 COMMENT '窗口是否固定 1：固定 0：不固定';
ALTER TABLE h_user_common_query ADD COLUMN conditionType bit(1) DEFAULT 0 COMMENT '条件类型 1：全部 0：任一';

ALTER TABLE h_biz_sheet MODIFY COLUMN `printTemplateJson` longtext NULL COMMENT '关联的打印模板' AFTER `shortCode`;
ALTER TABLE h_biz_sheet_history MODIFY COLUMN `printTemplateJson` longtext NULL COMMENT '关联的打印模板' AFTER `shortCode`;


ALTER TABLE h_perm_biz_function ADD COLUMN attribute longtext NULL COMMENT '拓展属性';

CREATE TABLE `h_biz_button` (
  `id` varchar(120) NOT NULL,
  `createdTime` datetime DEFAULT NULL,
  `creater` varchar(120) DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `modifier` varchar(120) DEFAULT NULL,
  `schemaCode` varchar(40) DEFAULT NULL COMMENT '模型编码',
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '按钮名称',
  `code` varchar(40) DEFAULT NULL COMMENT '按钮编码',
  `triggerCode` varchar(40) DEFAULT NULL COMMENT '调用方编码（视图、表单）',
  `triggerType` varchar(40) DEFAULT NULL COMMENT '调用方类型（视图、表单）',
  `showPermCode` varchar(40) DEFAULT NULL COMMENT '显示权限，绑定对象编码',
  `showPermType` varchar(40) DEFAULT NULL COMMENT '显示权限，绑定对象类型',
  `hint` varchar(200) DEFAULT NULL COMMENT '移入提示',
  `description` text COMMENT '描述',
  `useLocation` varchar(40) NOT NULL COMMENT '使用位置 ',
  `bindAction` varchar(40) NOT NULL COMMENT '按钮操作',
  `operateType` varchar(40) NOT NULL COMMENT '操作类型',
  `targetCode` varchar(40) DEFAULT NULL COMMENT '目标编码',
  `targetObjCode` varchar(40) DEFAULT NULL COMMENT '目标对象编码',
  `actionConfig` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '按钮操作配置',
  `deleted` bit(1) DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL COMMENT '备注',
  `sortKey` int(8) DEFAULT NULL COMMENT '排序',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

create unique index idx_s_code on h_biz_button (schemaCode, triggerType, triggerCode, code);

alter table h_biz_sheet add options text DEFAULT NULL COMMENT '扩展配置';
alter table h_biz_sheet_history add options text DEFAULT NULL COMMENT '扩展配置';

alter table h_app_package add builtInApp bit(1) default 0 comment '内置应用 1：是 0：否';

ALTER TABLE `h_user_favorites` ADD INDEX `idx_user_favorites_userId`(`userId`) USING BTREE;

alter table h_biz_query_column add visible bit default true null comment '是否显示';

update h_biz_query_column set visible = true where visible is null;

ALTER TABLE `h_biz_data_track_detail` ADD COLUMN `code` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '留痕字段编码' AFTER `creatorName`;

CREATE TABLE if not exists `h_biz_data_track_child` (
  `id` varchar(120) NOT NULL,
  `detailId` varchar(120) DEFAULT NULL COMMENT '留痕详情ID',
  `schemaCode` varchar(40) DEFAULT NULL COMMENT '子表模型编码',
  `beforeValue` longtext COMMENT '留痕字段新值',
  `afterValue` longtext COMMENT '留痕字段旧值',
  `modifiedProperties` longtext COMMENT '修改的字段',
  `sortKey` decimal(25,8) DEFAULT NULL COMMENT '排序号',
  `operationType` varchar(40) DEFAULT NULL COMMENT '子表操作类型：Added、Modified、Deleted',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_h_track_child_detail_op` (`detailId`,`operationType`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE h_workflow_trust_rule CHANGE createTime createdTime datetime NULL;
ALTER TABLE h_workflow_trust_rule ADD remarks varchar(200) NULL COMMENT '备注';
ALTER TABLE h_workflow_trust_rule ADD deleted bit(1) NULL COMMENT '删除标识';

ALTER TABLE h_workflow_trust CHANGE createTime createdTime datetime NULL;
ALTER TABLE h_workflow_trust ADD modifier varchar(120) NULL COMMENT '修改人';
ALTER TABLE h_workflow_trust ADD modifiedTime DATETIME NULL COMMENT '修改时间';
ALTER TABLE h_workflow_trust ADD remarks varchar(200) NULL COMMENT '备注';
ALTER TABLE h_workflow_trust ADD deleted bit(1) NULL COMMENT '删除标识';

ALTER TABLE h_timer_job ADD triggerTime datetime NULL COMMENT '触发时间';
ALTER TABLE h_job_result ADD triggerTime datetime NULL COMMENT '触发时间';

ALTER TABLE h_from_comment_attachment MODIFY COLUMN refId varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '上传到文件系统的文件id' AFTER `name`;

alter table biz_workitem add dataType varchar(20) default 'NORMAL' not null comment '数据类型，正常：NORMAL；模拟：SIMULATIVE';
alter table biz_workitem add sequenceNo varchar(200) null comment '单据号';

alter table biz_workitem_finished add dataType varchar(20) default 'NORMAL' not null comment '数据类型，正常：NORMAL；模拟：SIMULATIVE';
alter table biz_workitem_finished add sequenceNo varchar(200) null comment '单据号';

alter table biz_circulateitem add dataType varchar(20) default 'NORMAL' not null comment '数据类型，正常：NORMAL；模拟：SIMULATIVE';
alter table biz_circulateitem add sequenceNo varchar(200) null comment '单据号';

alter table biz_circulateitem_finished add dataType varchar(20) default 'NORMAL' not null comment '数据类型，正常：NORMAL；模拟：SIMULATIVE';
alter table biz_circulateitem_finished add sequenceNo varchar(200) null comment '单据号';

update biz_workitem bw set bw.sequenceNo = (select bwi.sequenceNo from biz_workflow_instance bwi
                                            where bw.instanceId= bwi.id);
update biz_workitem bw set bw.dataType= (select bwi.dataType from biz_workflow_instance bwi
                                         where bw.instanceId= bwi.id) where bw.instanceId in (select id from biz_workflow_instance);

update biz_workitem_finished bw set bw.sequenceNo = (select bwi.sequenceNo from biz_workflow_instance bwi
                                                     where bw.instanceId= bwi.id);
update biz_workitem_finished bw set bw.dataType= (select bwi.dataType from biz_workflow_instance bwi
                                                  where bw.instanceId= bwi.id) where bw.instanceId in (select id from biz_workflow_instance);

update biz_circulateitem bw set bw.sequenceNo = (select bwi.sequenceNo from biz_workflow_instance bwi
                                                 where bw.instanceId= bwi.id);
update biz_circulateitem bw set bw.dataType= (select bwi.dataType from biz_workflow_instance bwi
                                              where bw.instanceId= bwi.id) where bw.instanceId in (select id from biz_workflow_instance);

update biz_circulateitem_finished bw set bw.sequenceNo = (select bwi.sequenceNo from biz_workflow_instance bwi
                                                          where bw.instanceId= bwi.id);
update biz_circulateitem_finished bw set bw.dataType= (select bwi.dataType from biz_workflow_instance bwi
                                                       where bw.instanceId= bwi.id) where bw.instanceId in (select id from biz_workflow_instance);

alter table biz_workflow_instance add index idx_bwi_trustee(trustee);

alter table biz_workflow_instance add index idx_bwi_parentId(parentId);

alter table biz_workitem_finished add index idx_bwf_trustor(trustor);

alter table biz_workflow_instance add index idx_bwi_startTime_state_dataType(startTime, state, dataType);

alter table biz_workitem_finished add index idx_bwf_finishTime_state_dateType(finishTime, state, dataType);

alter table biz_workflow_instance add index idx_bwi_finishTime(finishTime);

create unique index uq_code on h_app_package (code);

create unique index uq_code on h_app_group (code);

drop index idx_type_ac on h_app_function;
create index idx_type_ac on h_app_function (appCode, type);
create index idx_parentId on h_app_function (parentId);

drop index idx_schemaCode on h_biz_schema;
create unique index uq_schemaCode on h_biz_schema (code);

create unique index uq_schema_code on h_biz_sheet (schemaCode, code);

drop index Idx_schemaCode on h_biz_property;

create index idx_schemaCode on h_biz_data_rule (schemaCode, propertyCode);

create index idx_schema_code on h_business_rule (schemaCode, code);

create unique index uq_schema_code on h_biz_query (schemaCode, code);

create index idx_queryId_actionCode on h_biz_query_action (queryId, actionCode);

create index idx_queryId on h_biz_query_sorter (queryId);

create unique index uq_queryId_clientType on h_biz_query_present (queryId, clientType);

create index idx_bizObjectId on h_biz_data_track (bizObjectId);

create index idx_track_id on h_biz_data_track_detail (trackId);

create index idx_schemaCode on h_workflow_header (schemaCode);

create index idx_workflowCode on h_workflow_permission (workflowCode);

alter table h_workflow_relative_event modify schemaCode varchar(40) not null comment '模型编码';
alter table h_workflow_relative_event modify workflowCode varchar(40) not null comment '流程编码';
alter table h_workflow_relative_event modify bizMethodCode varchar(40) not null comment '业务方法编码';

create index idx_workflowCode on biz_workitem (workflowCode);

create index idx_workflowCode on biz_workitem_finished (workflowCode);

create unique index uq_code on h_biz_database_pool (code);

create unique index uq_code on h_biz_service (code);

create unique index uq_service_code on h_biz_service_method (serviceCode, code);

create index idx_schemaCode on h_biz_method_mapping (schemaCode);
create index idx_service_methodCode on h_biz_method_mapping (serviceCode, methodCode);

create unique index uq_code on h_data_dictionary (code);

create index idx_dictionaryId on h_dictionary_record (dictionaryId);

create unique index uq_corpId on h_related_corp_setting (corpId);

update h_org_department set sourceId = null where sourceId = '';
create index idx_queryCode on h_org_department (queryCode);

drop index UK_rj7duahtop7qmf2ka0kxs57i0 on h_org_user;
drop index idx_corpId_userId on h_org_user;
create index idx_corpId_userId on h_org_user (userId, corpId);

create unique index idx_corpId_sourceId on h_org_role_group (corpId, sourceId);

drop index idx_rolde_name on h_org_role;
drop index idx_role_id on h_org_role;
create index idx_groupId on h_org_role (groupId);

drop index idx_role_user_composeid on h_org_role_user;
drop index idx_role_user_id on h_org_role_user;
drop index idx_role_user_sourceid on h_org_role_user;
create index idx_userId on h_org_role_user (userId);
create index idx_roleId on h_org_role_user (roleId);

drop index IDX_corpId on h_org_user_extend_attr;
drop index UK_code_corpId on h_org_user_extend_attr;
create unique index UK_code_corpId on h_org_user_extend_attr (corpId, code);

create index idx_sourceUser on h_org_user_transfer_record (sourceUserId);

create unique index uq_departmentId on h_perm_selection_scope (departmentId);

create index idx_userId on h_user_common_comment (userId);

create unique index uq_appCode on h_perm_app_package (appCode);

create index idx_appCode on h_perm_group (appCode);

create index idx_appPermGroupId on h_biz_perm_group (appPermGroupId);
create index idx_schemaCode on h_biz_perm_group (schemaCode);

create index idx_groupId on h_biz_perm_property (groupId);

create index idx_permissionGroupId on h_perm_biz_function (permissionGroupId);
create index idx_schemaCode on h_perm_biz_function (schemaCode);

create index idx_functionId on h_perm_function_condition (functionId);
create index idx_schemaCode on h_perm_function_condition (schemaCode);

create unique index uq_userId_type on h_perm_admin (userId, adminType);

create index idx_adminId on h_perm_admin_group (adminId);

create index idx_adminId on h_perm_apppackage_scope (adminId);

create index idx_adminId on h_perm_department_scope (adminId);


ALTER TABLE h_system_setting MODIFY COLUMN paramValue varchar(4000) default '';

alter table h_org_user modify gender varchar(6) null;