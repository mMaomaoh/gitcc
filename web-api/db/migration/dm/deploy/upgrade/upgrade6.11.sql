update h_biz_property set propertyLength = 200 where code='sequenceNo';

ALTER TABLE h_system_sequence_no add (schemaCode varchar2(120) null);
comment on column h_system_sequence_no.schemaCode is '数据模型编码';

ALTER TABLE h_system_sequence_no add (filterCondition varchar2(200) null);
comment on column h_system_sequence_no.filterCondition is '过滤条件';

alter table h_biz_query_condition add (filterType varchar2(10) null);
comment on column h_biz_query_condition.filterType is '查询条件筛选类型';

ALTER TABLE h_biz_query_present ADD (options CLOB DEFAULT NULL);
comment on column h_biz_query_present.options is '额外配置参数';

ALTER TABLE D_PROCESS_TASK rename column PROCESSINSTANCEID to PROCESSINSTANCEID_tmp;
ALTER TABLE D_PROCESS_TASK ADD PROCESSINSTANCEID varchar2(64) NULL;
update D_PROCESS_TASK set PROCESSINSTANCEID=trim(PROCESSINSTANCEID_tmp);
alter table D_PROCESS_TASK drop column PROCESSINSTANCEID_tmp;

ALTER TABLE D_PROCESS_TASK rename column TASKID to TASKID_tmp;
ALTER TABLE D_PROCESS_TASK ADD TASKID varchar2(50) DEFAULT '' not NULL ;
update D_PROCESS_TASK set TASKID=trim(TASKID_tmp);
alter table D_PROCESS_TASK drop column TASKID_tmp;

create table h_user_common_query (
  id varchar2(120) not null primary key,
  name	varchar2(100)	not null,
  type	varchar2(40)not null,
  schemaCode varchar2(40) not null,
  queryCode  varchar2(40) not null,
  userId varchar2(36) not null,
  sort	NUMBER(5) not null,
  patientia number(1, 0) default 0 not null,
  createdTime timestamp,
  modifiedTime timestamp,
  queryCondition CLOB
);
CREATE INDEX index_common_query_s_u ON h_user_common_query (schemaCode,userId);

CREATE TABLE H_BIZ_QUERY_GANTT
   (
   ID VARCHAR2(120) NOT NULL ,
	CREATER VARCHAR2(120),
	CREATEDTIME timestamp,
	DELETED NUMBER(1,0),
	MODIFIER VARCHAR2(120),
	MODIFIEDTIME timestamp,
	REMARKS VARCHAR2(200),
	QUERYID VARCHAR2(120),
	SCHEMACODE VARCHAR2(40),
	STARTTIMEPROPERTYCODE VARCHAR2(40),
	ENDTIMEPROPERTYCODE VARCHAR2(40),
	CONFIGJSON CLOB,
	PROGRESSPROPERTYCODE VARCHAR2(40),
	PREDEPENDENCYPROPERTYCODE VARCHAR2(40),
	ENDDEPENDENCYPROPERTYCODE VARCHAR2(40),
	LEVELPROPERTYCODE VARCHAR2(40),
	MILEPOSTCODE VARCHAR2(40),
	DEFAULTPRECISION VARCHAR2(40),
	SORTKEY VARCHAR2(40),
	TITLEPROPERTYCODE VARCHAR2(40),
	LIABLEMANCODE VARCHAR2(40),
	STATUSCODE VARCHAR2(40),
	 PRIMARY KEY (ID)
   ) ;
comment on column H_BIZ_QUERY_GANTT.STARTTIMEPROPERTYCODE is '开始时间对应数据项code';
comment on column H_BIZ_QUERY_GANTT.ENDTIMEPROPERTYCODE is '结束时间对应数据项code';
comment on column H_BIZ_QUERY_GANTT.CONFIGJSON is '展示配置JSON数据';
comment on column H_BIZ_QUERY_GANTT.PROGRESSPROPERTYCODE is '进度对应数据项code';
comment on column H_BIZ_QUERY_GANTT.PREDEPENDENCYPROPERTYCODE is '前置依赖对应数据项code';
comment on column H_BIZ_QUERY_GANTT.ENDDEPENDENCYPROPERTYCODE is '后置依赖对应数据项code';
comment on column H_BIZ_QUERY_GANTT.LEVELPROPERTYCODE is '层级关系对应数据项code';
comment on column H_BIZ_QUERY_GANTT.MILEPOSTCODE is '里程碑任务对应数据项code';
comment on column H_BIZ_QUERY_GANTT.DEFAULTPRECISION is '默认时间精度';
comment on column H_BIZ_QUERY_GANTT.SORTKEY is '排序字段';
comment on column H_BIZ_QUERY_GANTT.TITLEPROPERTYCODE is '标题对应数据项code';
comment on column H_BIZ_QUERY_GANTT.LIABLEMANCODE is '责任人对应数据项code';
comment on column H_BIZ_QUERY_GANTT.STATUSCODE is '状态对应数据项code';

CREATE INDEX Idx_queryid ON H_BIZ_QUERY_GANTT (QUERYID) ;

CREATE INDEX Idx_schemaCode ON H_BIZ_QUERY_GANTT (SCHEMACODE) ;

alter table h_system_pair add uniqueCode varchar2(120);
comment on column h_system_pair.uniqueCode is '唯一码';
alter table h_system_pair add type varchar2(40);
comment on column h_system_pair.type is '类型';
alter table h_system_pair add expireTime timestamp;
comment on column h_system_pair.expireTime is '过期时间';
create unique index idx_u_code on h_system_pair (uniqueCode);

ALTER TABLE h_perm_group ADD sortKey int DEFAULT NULL;
comment on column h_perm_group.sortKey is '排序字段';

ALTER TABLE h_user_common_query ADD filterFixed number(1, 0) default 0 not null;
comment on column h_user_common_query.filterFixed is '窗口是否固定 1：固定 0：不固定';

ALTER TABLE h_user_common_query ADD conditionType number(1, 0) default 0 not null;
comment on column h_user_common_query.conditionType is '条件类型 1：全部 0：任一';

ALTER TABLE H_BIZ_SHEET MODIFY (PRINTTEMPLATEJSON VARCHAR2(2000 BYTE));
ALTER TABLE H_BIZ_SHEET_HISTORY MODIFY (PRINTTEMPLATEJSON VARCHAR2(2000 BYTE));

ALTER TABLE h_perm_biz_function ADD attribute CLOB DEFAULT NULL;
comment on column h_perm_biz_function.attribute is '拓展属性';

create table h_biz_button (
    id varchar2(120) primary key not null,
    createdTime timestamp,
    creater	varchar2(120),
    modifiedTime timestamp,
    modifier	varchar2(120),
    deleted number(1,0),
    remarks	varchar2(200),
    schemaCode varchar2(40),
    name	varchar2(200) not null,
    code	varchar2(40) not null,
    triggerCode	varchar2(40) not null,
    triggerType	varchar2(40) not null,
    showPermCode	varchar2(40) not null,
    showPermType	varchar2(40) not null,
    hint	varchar2(200),
    description clob,
    useLocation	varchar2(40) not null,
    bindAction	varchar2(40) not null,
    operateType	varchar2(40) not null,
    targetCode	varchar2(40),
    targetObjCode	varchar2(40),
    actionConfig clob,
    sortKey  int  null
 );

comment on column h_biz_button.schemaCode is '模型编码';
comment on column h_biz_button.name is '按钮名称';
comment on column h_biz_button.code is '按钮编码';
comment on column h_biz_button.triggerCode is '调用方编码（视图、表单）';
comment on column h_biz_button.triggerType is '调用方类型（视图、表单）';
comment on column h_biz_button.showPermCode is '显示权限，绑定对象编码';
comment on column h_biz_button.showPermType is '显示权限，绑定对象类型';
comment on column h_biz_button.hint is '移入提示';
comment on column h_biz_button.description is '备注';
comment on column h_biz_button.useLocation is '使用位置';
comment on column h_biz_button.bindAction is '按钮操作';
comment on column h_biz_button.operateType is '操作类型';
comment on column h_biz_button.targetCode is '模板编码';
comment on column h_biz_button.targetObjCode is '目标对象编码';
comment on column h_biz_button.actionConfig is '按钮配置';
comment on column h_biz_button.sortKey is '排序';

create unique index IDX_S_CODE on h_biz_button (schemaCode, triggerType, triggerCode, code);

alter table h_biz_sheet add options clob;
comment on column h_biz_sheet.options is '扩展配置';
alter table h_biz_sheet_history add options clob;
comment on column h_biz_sheet_history.options is '扩展配置';

alter table h_app_package add builtInApp number(1, 0) default 0;
comment on column h_app_package.builtInApp is '内置应用 1：是 0：否';

CREATE INDEX idx_user_favorites_userId ON H_USER_FAVORITES ("USERID");

alter table h_biz_query_column add visible number(1, 0) default 1;
comment on column h_biz_query_column.visible is '是否显示';

update h_biz_query_column set visible = 1 where visible is null;

alter table h_biz_data_track_detail add code varchar2(40);
comment on column h_biz_data_track_detail.code is '留痕字段编码';

create table h_biz_data_track_child (
  id varchar2(120) not null primary key,
  detailId	varchar2(120),
  schemaCode	varchar2(40),
  beforeValue clob,
  afterValue  clob,
  modifiedProperties clob,
  sortKey	number(25,8),
  operationType varchar2(40)
);
CREATE INDEX index_track_child_s_u ON h_biz_data_track_child (detailId,operationType);

ALTER TABLE H_WORKFLOW_TRUST_RULE RENAME COLUMN CREATETIME TO CREATEDTIME;
ALTER TABLE H_WORKFLOW_TRUST_RULE ADD REMARKS VARCHAR2(200);
COMMENT ON COLUMN H_WORKFLOW_TRUST_RULE.REMARKS IS '备注';
ALTER TABLE H_WORKFLOW_TRUST_RULE ADD DELETED NUMBER(1,0);
COMMENT ON COLUMN H_WORKFLOW_TRUST_RULE.DELETED IS '删除标识';

ALTER TABLE H_WORKFLOW_TRUST RENAME COLUMN CREATETIME TO CREATEDTIME;
ALTER TABLE H_WORKFLOW_TRUST ADD MODIFIER VARCHAR2(120);
COMMENT ON COLUMN H_WORKFLOW_TRUST.MODIFIER IS '修改人';
ALTER TABLE H_WORKFLOW_TRUST ADD MODIFIEDTIME timestamp;
COMMENT ON COLUMN H_WORKFLOW_TRUST.MODIFIEDTIME IS '修改时间';
ALTER TABLE H_WORKFLOW_TRUST ADD REMARKS VARCHAR2(200);
COMMENT ON COLUMN H_WORKFLOW_TRUST.REMARKS IS '备注';
ALTER TABLE H_WORKFLOW_TRUST ADD DELETED NUMBER(1,0);
COMMENT ON COLUMN H_WORKFLOW_TRUST.DELETED IS '删除标识';

ALTER TABLE H_TIMER_JOB ADD TRIGGERTIME timestamp;
COMMENT ON COLUMN H_TIMER_JOB.TRIGGERTIME IS '触发时间';
ALTER TABLE H_JOB_RESULT ADD TRIGGERTIME timestamp;
COMMENT ON COLUMN H_JOB_RESULT.TRIGGERTIME IS '触发时间';

ALTER TABLE h_from_comment_attachment MODIFY refId VARCHAR2(200);

alter table biz_workitem add dataType varchar2(20) default 'NORMAL' not null;
comment on column biz_workitem.dataType is '数据类型，正常：NORMAL；模拟：SIMULATIVE';
alter table biz_workitem add sequenceNo varchar2(200) null;
comment on column biz_workitem.sequenceNo is '单据号';

alter table biz_workitem_finished add dataType varchar2(20) default 'NORMAL' not null;
comment on column biz_workitem_finished.dataType is '数据类型，正常：NORMAL；模拟：SIMULATIVE';
alter table biz_workitem_finished add sequenceNo varchar2(200) null;
comment on column biz_workitem_finished.sequenceNo is '单据号';

alter table biz_circulateitem add dataType varchar2(20) default 'NORMAL' not null;
comment on column biz_circulateitem.dataType is '数据类型，正常：NORMAL；模拟：SIMULATIVE';
alter table biz_circulateitem add sequenceNo varchar2(200) null;
comment on column biz_circulateitem.sequenceNo is '单据号';

alter table biz_circulateitem_finished add dataType varchar2(20) default 'NORMAL' not null;
comment on column biz_circulateitem_finished.dataType is '数据类型，正常：NORMAL；模拟：SIMULATIVE';
alter table biz_circulateitem_finished add sequenceNo varchar2(200) null;
comment on column biz_circulateitem_finished.sequenceNo is '单据号';

update biz_workitem bw set bw.sequenceNo = (select bwi.sequenceNo from biz_workflow_instance bwi
                                            where bw.instanceId= bwi.id);
update biz_workitem bw set bw.dataType= (select bwi.dataType from biz_workflow_instance bwi
                                         where bw.instanceId= bwi.id)  where bw.instanceId in (select id from biz_workflow_instance);

update biz_workitem_finished bw set bw.sequenceNo = (select bwi.sequenceNo from biz_workflow_instance bwi
                                                     where bw.instanceId= bwi.id);
update biz_workitem_finished bw set bw.dataType= (select bwi.dataType from biz_workflow_instance bwi
                                                  where bw.instanceId= bwi.id)  where bw.instanceId in (select id from biz_workflow_instance);

update biz_circulateitem bw set bw.sequenceNo = (select bwi.sequenceNo from biz_workflow_instance bwi
                                                 where bw.instanceId= bwi.id);
update biz_circulateitem bw set bw.dataType= (select bwi.dataType from biz_workflow_instance bwi
                                              where bw.instanceId= bwi.id)  where bw.instanceId in (select id from biz_workflow_instance);

update biz_circulateitem_finished bw set bw.sequenceNo = (select bwi.sequenceNo from biz_workflow_instance bwi
                                                          where bw.instanceId= bwi.id);
update biz_circulateitem_finished bw set bw.dataType= (select bwi.dataType from biz_workflow_instance bwi
                                                       where bw.instanceId= bwi.id)  where bw.instanceId in (select id from biz_workflow_instance);

create index idx_bwi_trustee on biz_workflow_instance (trustee);

create index idx_bwi_parentId on biz_workflow_instance (parentId);

create index idx_bwf_trustor on biz_workitem_finished (trustor);

create index idx_bwi_s_s_d on biz_workflow_instance (startTime, state, dataType);

create index idx_bwf_f_s_d on biz_workitem_finished (finishTime, state, dataType);

create index idx_bwi_finishTime on biz_workflow_instance (finishTime);

create unique index uq_ap_code on H_APP_GROUP (CODE);

drop index IDX_TYPE_AC;
create index idx_af_a_t on H_APP_FUNCTION (APPCODE, TYPE);
create index idx_af_parentId on H_APP_FUNCTION (PARENTID);

drop index IDX_BIZSCHEMA_SCHEMACODE;
create unique index uq_bs_code on H_BIZ_SCHEMA (CODE);

create index uq_bs_s_c on H_BIZ_SHEET (SCHEMACODE, CODE);

drop index IDX_BIZPROPERTY_SCHEMACODE;

create index idx_bdr_s_p on H_BIZ_DATA_RULE (SCHEMACODE, PROPERTYCODE);

create index idx_br_s_c on H_BUSINESS_RULE (SCHEMACODE, CODE);

create unique index uq_bq_s_c on H_BIZ_QUERY (SCHEMACODE, CODE);

create index idx_bqa_q_a on H_BIZ_QUERY_ACTION (QUERYID, ACTIONCODE);

create index idx_bqs_queryId on H_BIZ_QUERY_SORTER (QUERYID);

create unique index uq_bqp_q_c on h_biz_query_present (queryId, clientType);

create index idx_bdt_bizObjectId on h_biz_data_track (bizObjectId);

create index idx_bdtd_trackId on h_biz_data_track_detail (trackId);

create index idx_wh_schemaCode on h_workflow_header (schemaCode);

create index idx_wp_workflowCode on h_workflow_permission (workflowCode);

create index idx_bw_workflowCode on biz_workitem (workflowCode);

create index idx_bwf_workflowCode on biz_workitem_finished (workflowCode);

create unique index uq_bdp_code on h_biz_database_pool (code);

create unique index uq_biz_service_code on h_biz_service (code);

create unique index uq_bsm_s_c on h_biz_service_method (serviceCode, code);

create index idx_bmm_schemaCode on h_biz_method_mapping (schemaCode);
create index idx_bmm_s_m on h_biz_method_mapping (serviceCode, methodCode);

create unique index uq_dd_code on h_data_dictionary (code);

create index idx_dr_dictionaryId on h_dictionary_record (dictionaryId);

create unique index uq_rcs_corpId on h_related_corp_setting (corpId);

drop index UQ_DEPARTMENT_CORPID_SOURCEID;
create index idx_od_queryCode on h_org_department (queryCode);
create index idx_od_s_c on h_org_department (sourceId,corpId);

drop index IDX_H_ORG_ROLE_NAME;
create index idx_or_groupId on h_org_role (groupId);

ALTER TABLE h_org_role_group DROP CONSTRAINT UK_H_ORG_ROLE_GROUP_SOURCEID;
create unique index uq_org_c_s on h_org_role_group (sourceId,corpId);

ALTER TABLE h_org_role_user DROP CONSTRAINT IDX_ROLE_USER_COMPOSEID;
drop index IDX_ROLE_USER_SOURCEID;
create index idx_oru_roleId on h_org_role_user (roleId);

drop index IDX_CORPID;
ALTER TABLE h_org_user_extend_attr DROP CONSTRAINT UK_CODE_CORPID;
create unique index uq_orea_c_c on h_org_user_extend_attr (corpId, code);

create index idx_outr_sourceUserId on h_org_user_transfer_record (sourceUserId);

create unique index uq_pss_departmentId on h_perm_selection_scope (departmentId);

create index idx_ucc_userId on h_user_common_comment (userId);

create index idx_pg_appCode on h_perm_group (appCode);

create index idx_bpg_appPermGroupId on h_biz_perm_group (appPermGroupId);
create index idx_bpg_schemaCode on h_biz_perm_group (schemaCode);

create index idx_bpp_groupId on h_biz_perm_property (groupId);

create index idx_pbf_permissionGroupId on h_perm_biz_function (permissionGroupId);
create index idx_pbf_schemaCode on h_perm_biz_function (schemaCode);

create index idx_pfc_functionId on h_perm_function_condition (functionId);
create index idx_pfc_schemaCode on h_perm_function_condition (schemaCode);

create unique index uq_pa_u_a on h_perm_admin (userId, adminType);

create index idx_pag_adminId on h_perm_admin_group (adminId);

create index idx_pas_adminId on h_perm_apppackage_scope (adminId);

create index idx_pds_adminId on h_perm_department_scope (adminId);
ALTER TABLE h_system_setting MODIFY paramValue VARCHAR2(4000);

alter table H_ORG_USER modify GENDER VARCHAR2(6);