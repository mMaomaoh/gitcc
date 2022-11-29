ALTER TABLE h_biz_query_condition ADD filterType nvarchar(10) NULL
go
ALTER TABLE h_biz_query_present ADD options ntext
go
update h_biz_property set propertyLength = 200 where code='sequenceNo';
go
ALTER TABLE h_system_sequence_no add schemaCode nvarchar(120);
go
ALTER TABLE h_system_sequence_no add filterCondition nvarchar(200);
go

ALTER TABLE d_process_task ALTER COLUMN processInstanceId nvarchar(64) NULL;
ALTER TABLE d_process_task ALTER COLUMN taskId nvarchar(50) NOT NULL;
GO

create table h_user_common_query (
  id nvarchar(120) NOT NULL PRIMARY KEY,
  name	nvarchar(100),
  type	nvarchar(40),
  schemaCode nvarchar(40) ,
  queryCode nvarchar(40) ,
  userId nvarchar(36) ,
  sort	smallint,
  patientia bit,
  createdTime datetime,
  modifiedTime datetime,
  queryCondition ntext
)
go

CREATE  INDEX index_common_query_s_u
ON h_user_common_query (
  schemaCode ,userId
)
GO

CREATE TABLE h_biz_query_gantt (
  id nvarchar(120)  NOT NULL PRIMARY KEY,
  creater nvarchar(120) ,
  createdTime datetime  ,
  deleted bit  ,
  modifier nvarchar(120) ,
  modifiedTime datetime  ,
  remarks nvarchar(200) ,
  queryId nvarchar(36) ,
  schemaCode nvarchar(40) ,
  startTimePropertyCode nvarchar(40) ,
  endTimePropertyCode nvarchar(40) ,
  configJson ntext ,
  progressPropertyCode nvarchar(40) ,
  titlePropertyCode nvarchar(40) ,
  preDependencyPropertyCode nvarchar(40) ,
  endDependencyPropertyCode nvarchar(40) ,
  levelPropertyCode nvarchar(40) ,
  milepostCode nvarchar(40) ,
  defaultPrecision nvarchar(40) ,
  sortKey nvarchar(40) ,
  liableManCode nvarchar(40) ,
  statusCode nvarchar(40)
)
GO

CREATE  INDEX Idx_schemaCode
ON h_biz_query_gantt (
  schemaCode ASC
)
GO

CREATE  INDEX Idx_queryid
ON h_biz_query_gantt (
  queryId ASC
)
GO


ALTER TABLE h_system_pair add uniqueCode nvarchar(120);
GO
ALTER TABLE h_system_pair add type nvarchar(40);
GO
ALTER TABLE h_system_pair add expireTime datetime;
GO

ALTER TABLE h_perm_group add sortKey int ;
GO

ALTER TABLE h_user_common_query ADD filterFixed bit DEFAULT 0 ;
ALTER TABLE h_user_common_query ADD conditionType bit DEFAULT 0;
GO

ALTER TABLE h_biz_sheet ALTER COLUMN printTemplateJson ntext NULL;
ALTER TABLE h_biz_sheet_history ALTER COLUMN printTemplateJson ntext NULL;
go

ALTER TABLE h_perm_biz_function ADD attribute ntext
GO


CREATE TABLE h_biz_button (
  id nvarchar(120) NOT NULL primary key,
  createdTime datetime  NULL,
  creater nvarchar(120)  NULL,
  deleted bit  NULL,
  remarks nvarchar(200)  NULL,
  modifiedTime datetime  NULL,
  modifier nvarchar(120)  NULL,
  schemaCode nvarchar(40)  NULL ,
  name nvarchar(200) NOT NULL,
  code nvarchar(40) NOT NULL,
  triggerCode nvarchar(40) NOT NULL,
  triggerType nvarchar(40) NOT NULL,
  showPermCode nvarchar(40) NOT NULL,
  showPermType nvarchar(40) NOT NULL,
  hint nvarchar(200),
  description ntext,
  useLocation nvarchar(40) NOT NULL,
  bindAction nvarchar(40) NOT NULL,
  operateType nvarchar(40) NOT NULL,
  targetCode nvarchar(40),
  targetObjCode nvarchar(40),
  actionConfig ntext,
  sortKey int
)
go
create unique index idx_s_code on h_biz_button(schemaCode, triggerType, triggerCode, code);
go

ALTER TABLE h_biz_sheet add options ntext;
GO
ALTER TABLE h_biz_sheet_history add options ntext;
GO

alter table h_app_package add builtInApp bit DEFAULT 0;
GO

create index idx_user_favorites_userId on h_user_favorites (userId);
go

alter table h_biz_query_column add visible bit default 1
go
update h_biz_query_column set visible = 1 where visible is null;
go

alter table h_biz_data_track_detail add code nvarchar(40)
GO

create table h_biz_data_track_child (
  id nvarchar(120) NOT NULL PRIMARY KEY,
  detailId	nvarchar(100),
  schemaCode	nvarchar(40),
  beforeValue ntext,
  afterValue ntext,
  modifiedProperties ntext,
  sortKey	decimal(25,8),
  operationType nvarchar(40)
)
go

CREATE  INDEX index_track_child_s_u
ON h_biz_data_track_child (
  detailId ,operationType
)
GO

EXEC sp_rename 'h_workflow_trust_rule.createTime', 'createdTime', 'COLUMN'
GO
ALTER TABLE h_workflow_trust_rule ADD remarks nvarchar(200) NULL
GO
ALTER TABLE h_workflow_trust_rule ADD deleted bit NULL
GO

EXEC sp_rename 'h_workflow_trust.createTime' , 'createdTime', 'COLUMN'
GO
ALTER TABLE h_workflow_trust ADD modifier nvarchar(120) NULL
GO
ALTER TABLE h_workflow_trust ADD modifiedTime datetime NULL
GO
ALTER TABLE h_workflow_trust ADD remarks nvarchar(200) NULL
GO
ALTER TABLE h_workflow_trust ADD deleted bit NULL
GO

ALTER TABLE h_timer_job ADD triggerTime datetime NULL
GO
ALTER TABLE h_job_result ADD triggerTime datetime NULL
GO

ALTER TABLE h_from_comment_attachment  ALTER COLUMN refId nvarchar(200)  ;
go

alter table biz_workitem add dataType nvarchar(20) default 'NORMAL' not null;
go
alter table biz_workitem add sequenceNo nvarchar(200) null;
go

alter table biz_workitem_finished add dataType nvarchar(20) default 'NORMAL' not null;
go
alter table biz_workitem_finished add sequenceNo nvarchar(200) null;
go

alter table biz_circulateitem add dataType nvarchar(20) default 'NORMAL' not null;
go
alter table biz_circulateitem add sequenceNo nvarchar(200) null;
go

alter table biz_circulateitem_finished add dataType nvarchar(20) default 'NORMAL' not null;
go
alter table biz_circulateitem_finished add sequenceNo nvarchar(200) null;
go

update bw set bw.dataType = (select bwi.dataType from biz_workflow_instance bwi where bwi.id = bw.instanceId) from biz_workitem bw
where bw.instanceId in (select id from biz_workflow_instance);
go
update bw set bw.sequenceNo = (select bwi.sequenceNo from biz_workflow_instance bwi where bwi.id = bw.instanceId) from biz_workitem bw;
go

update bw set bw.dataType = (select bwi.dataType from biz_workflow_instance bwi where bwi.id = bw.instanceId) from biz_workitem_finished bw
where bw.instanceId in (select id from biz_workflow_instance);
go
update bw set bw.sequenceNo = (select bwi.sequenceNo from biz_workflow_instance bwi where bwi.id = bw.instanceId) from biz_workitem_finished bw;
go

update bw set bw.dataType = (select bwi.dataType from biz_workflow_instance bwi where bwi.id = bw.instanceId) from biz_circulateitem bw
where bw.instanceId in (select id from biz_workflow_instance);
go
update bw set bw.sequenceNo = (select bwi.sequenceNo from biz_workflow_instance bwi where bwi.id = bw.instanceId) from biz_circulateitem bw;
go

update bw set bw.dataType = (select bwi.dataType from biz_workflow_instance bwi where bwi.id = bw.instanceId) from biz_circulateitem_finished bw
where bw.instanceId in (select id from biz_workflow_instance);
go
update bw set bw.sequenceNo = (select bwi.sequenceNo from biz_workflow_instance bwi where bwi.id = bw.instanceId) from biz_circulateitem_finished bw;
go

create index idx_bwi_trustee on biz_workflow_instance (trustee);
go

create index idx_bwi_parentId on biz_workflow_instance (parentId);
go

create index idx_bwf_trustor on biz_workitem_finished (trustor);
go

create index idx_bwi_s_s_d on biz_workflow_instance (startTime, state, dataType);
go

create index idx_bwf_f_s_d on biz_workitem_finished (finishTime, state, dataType);
go

create index idx_bwi_finishTime on biz_workflow_instance (finishTime);
go

create unique index uk_code on h_app_package (code)
go

create unique index uk_code on h_app_group (code)
go

drop index idx_type_ac on h_app_function
go
create index idx_a_t on h_app_function (appCode, type)
go
create index idx_parentId on h_app_function (parentId)
go

create index idx_s_c on h_biz_sheet (schemaCode, code)
go

drop index Idx_schemaCode on h_biz_property
go
create unique index uq_s_c on h_biz_property (schemaCode, code)
go

create index idx_bdr_s_p on h_biz_data_rule (schemaCode, propertyCode)
go

create unique index uq_bdr_s_c on h_business_rule (schemaCode, code)
go

create unique index uq_bq_s_c on h_biz_query (schemaCode, code)
go

create index idx_bqa_q_a on h_biz_query_action (queryId, actionCode)
go

create index idx_bqs_queryId on h_biz_query_sorter (queryId)
go

create unique index uq_bqp_q_c on h_biz_query_present (queryId,clientType)
go

create index idx_bdt_bizObjectId on h_biz_data_track (bizObjectId)
go

create index idx_bdtd_trackId on h_biz_data_track_detail (trackId)
go

create index idx_wh_schemaCode on h_workflow_header (workflowCode)
go

create index idx_wp_workflowCode on h_workflow_permission (workflowCode)
go

create index idx_wa_workflowCode on h_workflow_admin (workflowCode)
go

create index idx_was_adminId on h_workflow_admin_scope (adminId)
go

create unique index uq_bdp_code on h_biz_database_pool (code)
go

create unique index uq_bs_code on h_biz_service (code)
go

create unique index uq_bsm_s_m on h_biz_service_method (serviceCode,code)
go

create index idx_bmm_schemaCode on h_biz_method_mapping (schemaCode)
go
create index idx_bmm_s_m on h_biz_method_mapping (serviceCode,methodCode)
go

create unique index uq_dd_code on h_data_dictionary (code)
go

create index idx_dr_dictionaryId on h_dictionary_record (dictionaryId)
go

create unique index uq_rcs_corpId on h_related_corp_setting (corpId)
go

drop index uq_corpId_sourceId on h_org_department
go
create index idx_od_queryCode on h_org_department(queryCode)
go

drop index UK_rj7duahtop7qmf2ka0kxs57i0 on h_org_user
go

drop index idx_role_group_id on h_org_role_group
go
drop index idx_role_group_code on h_org_role_group
go

drop index idx_role_id on h_org_role
go
drop index idx_rolde_code on h_org_role
go
drop index idx_rolde_name on h_org_role
go
create index idx_or_groupId on h_org_role(groupId)
go

drop index idx_role_user_id on h_org_role_user
go
drop index idx_role_user_sourceid on h_org_role_user
go
alter table h_org_role_user drop constraint idx_role_user_composeid
go
create index idx_oru_roleId on h_org_role_user(roleId)
go
create index idx_oru_userId on h_org_role_user(userId)
go

drop index IDX_corpId on h_org_user_extend_attr
go
alter table h_org_user_extend_attr drop constraint UK_code_corpId
go
create unique index idx_ouea_c_c on h_org_user_extend_attr(corpId,code)
go

create unique index uq_pss_departmentId on h_perm_selection_scope(departmentId)
go

create index idx_ucc_userId on h_user_common_comment(userId)
go

create unique index idx_pap_appCode on h_perm_app_package(appCode)
go

create index idx_pg_appCode on h_perm_group(appCode)
go

create index idx_bpg_appPermGroupId on h_biz_perm_group(appPermGroupId)
go
create index idx_bpg_schemaCode on h_biz_perm_group(schemaCode)
go

create index idx_bpp_groupId on h_biz_perm_property(groupId)
go

create index idx_pbf_permissionGroupId on h_perm_biz_function(permissionGroupId)
go
create index idx_pbf_schemaCode on h_perm_biz_function(schemaCode)
go

create index idx_pfc_functionId on h_perm_function_condition(functionId)
go
create index idx_pfc_schemaCode on h_perm_function_condition(schemaCode)
go

create unique index uq_pa_u_a on h_perm_admin(userId,adminType)
go

create index idx_pag_adminId on h_perm_admin_group(adminId)
go

create index idx_pas_adminId on h_perm_apppackage_scope(adminId)
go

create index idx_pds_adminId on h_perm_department_scope(adminId)
go

ALTER TABLE h_system_setting  ALTER COLUMN paramValue nvarchar(4000);
go

alter table h_org_user alter column gender nvarchar(6) null
go
