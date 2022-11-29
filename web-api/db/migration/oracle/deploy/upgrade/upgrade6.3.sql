create table h_perm_selection_scope
(
    id varchar(128) default '' not null
        constraint H_PERM_SELECTION_SCOPE_PK
            primary key,
    createdTime date,
    creater varchar2(120),
    deleted number,
    modifiedTime date,
    modifier varchar2(120),
    remarks varchar2(200),
    departmentId varchar2(120),
    deptVisibleType varchar2(40),
    deptVisibleScope clob,
    staffVisibleType varchar2(40),
    staffVisibleScope clob
);

alter table H_ORG_ROLE_GROUP add parentId varchar(120);

comment on column H_ORG_ROLE_GROUP.parentId is '上一级角色组id';
/*==============================================================*/
/* Table: h_org_inc_sync_record                                 */
/*==============================================================*/

create table H_ORG_INC_SYNC_RECORD
(
    id varchar(128) default '' not null
        constraint H_ORG_INC_SYNC_RECORD_PK
            primary key,
    syncSourceType       char(10) default 'DINGTALK',
    createTime           date default CURRENT_TIMESTAMP,
    updateTime           date default CURRENT_TIMESTAMP ,
    corpId               varchar(120) default NULL ,
    eventType            varchar(50) default NULL ,
    eventInfo            CLOB ,
    handleStatus         varchar(20) default NULL ,
    retryCount           int default NULL
);
comment on table H_ORG_INC_SYNC_RECORD is '增量同步记录表';
comment on column H_ORG_INC_SYNC_RECORD.id is '主键';
comment on column H_ORG_INC_SYNC_RECORD.syncSourceType is '同步源类型，钉钉|企业微信 等 默认为钉钉';
comment on column H_ORG_INC_SYNC_RECORD.createTime is '创建时间';
comment on column H_ORG_INC_SYNC_RECORD.updateTime is '修改时间';
comment on column H_ORG_INC_SYNC_RECORD.corpId is '组织corpId';
comment on column H_ORG_INC_SYNC_RECORD.eventType is '钉钉回调事件类型';
comment on column H_ORG_INC_SYNC_RECORD.eventInfo is '事件数据';
comment on column H_ORG_INC_SYNC_RECORD.handleStatus is '处理状态';
comment on column H_ORG_INC_SYNC_RECORD.retryCount is '重试次数';
alter table h_biz_service_category add createdBy varchar(120);
alter table h_biz_service_category add modifiedBy varchar(120);
alter table h_biz_datasource_category add createdBy varchar(120);
alter table h_biz_datasource_category add modifiedBy varchar(120);
ALTER TABLE H_BUSINESS_RULE ADD ENABLED NUMBER(1);
ALTER TABLE H_BUSINESS_RULE ADD QUOTEPROPERTY CLOB;

comment on column H_BUSINESS_RULE.ENABLED is '是否生效';
comment on column H_BUSINESS_RULE.QUOTEPROPERTY is '引用编码 数据模型编码.数据项编码 ,分割';

update h_business_rule set enabled = 1 where enabled is null;
alter table H_BIZ_PERM_PROPERTY add ENCRYPTVISIBLE NUMBER;

comment on column H_BIZ_PERM_PROPERTY.ENCRYPTVISIBLE is '是否可见加密';

UPDATE H_BIZ_PERM_PROPERTY SET ENCRYPTVISIBLE = 0 WHERE ID != '';
create table h_business_rule_runmap
(
	id varchar(120)
		constraint H_BUSINESS_RULE_RUNMAP_PK
			primary key,
	ruleCode varchar(40),
	ruleName varchar(100),
	ruleType varchar(15),
	nodeCode varchar(40),
	nodeName varchar(100),
	nodeType varchar(15),
	targetSchemaCode varchar(40),
	triggerSchemaCode varchar(40)
);

comment on column h_business_rule_runmap.id is '主键';

comment on column h_business_rule_runmap.ruleCode is '规则编码';

comment on column h_business_rule_runmap.ruleName is '规则名称';

comment on column h_business_rule_runmap.ruleType is '规则类型';

comment on column h_business_rule_runmap.nodeCode is '节点编码';

comment on column h_business_rule_runmap.nodeName is '节点名称';

comment on column h_business_rule_runmap.nodeType is '节点类型';

comment on column h_business_rule_runmap.targetSchemaCode is '目标对象模型编码';

comment on column h_business_rule_runmap.triggerSchemaCode is '触发对象模型编码';

alter table H_BIZ_PROPERTY add ENCRYPTOPTION varchar(40);

comment on column H_BIZ_PROPERTY.ENCRYPTOPTION is '加密类型';
