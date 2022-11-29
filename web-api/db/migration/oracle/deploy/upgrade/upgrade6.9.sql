create table H_WORKFLOW_ADMIN
(
  ID           VARCHAR2(120) not null,
  CREATER      VARCHAR2(120),
  CREATEDTIME  DATE,
  DELETED      NUMBER(1),
  MODIFIER     VARCHAR2(120),
  MODIFIEDTIME DATE,
  REMARKS      VARCHAR2(200),
  ADMINTYPE    VARCHAR2(120),
  WORKFLOWCODE VARCHAR2(200),
  MANAGESCOPE  VARCHAR2(512),
  OPTIONS      CLOB
);
create index IDX_WORKFLOW_ADMIN_CODE on H_WORKFLOW_ADMIN (WORKFLOWCODE);
create table H_WORKFLOW_ADMIN_SCOPE
(
  ID           VARCHAR2(120) not null,
  CREATER      VARCHAR2(120),
  CREATEDTIME  DATE,
  DELETED      NUMBER(1),
  MODIFIER     VARCHAR2(120),
  MODIFIEDTIME DATE,
  REMARKS      VARCHAR2(200),
  ADMINID      VARCHAR2(120),
  UNITTYPE     VARCHAR2(120),
  UNITID       VARCHAR2(36)
);
create index IDX_WORKFLOW_ADMINID on H_WORKFLOW_ADMIN_SCOPE (ADMINID);
alter table BIZ_WORKITEM add WORKITEMSOURCE varchar2(120);
comment on column BIZ_WORKITEM.WORKITEMSOURCE is '任务来源';

alter table BIZ_WORKITEM_FINISHED add WORKITEMSOURCE varchar2(120);
comment on column BIZ_WORKITEM_FINISHED.WORKITEMSOURCE is '任务来源';
CREATE TABLE h_system_sms_template (
    id varchar2(120) NOT NULL primary key,
    type varchar2(20) NOT NULL,
    code varchar2(20) NOT NULL,
    name varchar2(40) NOT NULL,
    content CLOB NOT NULL,
    params CLOB DEFAULT NULL,
    enabled NUMBER(1) DEFAULT NULL,
    defaults NUMBER(1) DEFAULT NULL,
    remarks varchar2(200) DEFAULT NULL,
    deleted NUMBER(1) DEFAULT NULL,
    creater varchar2(120) DEFAULT NULL,
    createdTime date DEFAULT NULL,
    modifier varchar2(120) DEFAULT NULL,
    modifiedTime date DEFAULT NULL
);

INSERT INTO h_system_sms_template VALUES ('2c928ff67de11137017de119dec601c2', 'TODO', 'Todo', '默认待办通知', '您有新的流程待处理，流程标题：${name}，请及时处理！', '[{\"key\":\"name\",\"value\":\"\"}]', 1, 1, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO h_system_sms_template VALUES ('2c928ff67de11137017de11d5b3001c4', 'URGE', 'Remind', '默认催办通知', '您的流程任务被人催办，流程标题：${name}，催办人${creater}，请及时处理！', '[{\"key\":\"name\",\"value\":\"流程的标题\"},{\"key\":\"creater\",\"value\":\"流程发起人\"}]', 1, 1, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO h_system_setting VALUES ('c82a2b8d5d5c11ecb2370242ac110005', 'sms.todo.switch', 'false', 'SMS_CONF', 1, null);
INSERT INTO h_system_setting VALUES ('c82d39a85d5c11ecb2370242ac110006', 'sms.urge.switch', 'false', 'SMS_CONF', 1, null);
ALTER TABLE h_biz_export_task ADD (fileSize int NULL);

alter table H_BIZ_SCHEMA add MODELTYPE varchar2(120);
comment on column H_BIZ_SCHEMA.MODELTYPE is '模型类型 LIST/TREE';
ALTER TABLE h_im_message ADD (smsParams CLOB null);
ALTER TABLE h_im_message ADD (smsCode varchar2(50) null);

ALTER TABLE h_im_message_history ADD (smsParams CLOB null);
ALTER TABLE h_im_message_history ADD (smsCode varchar2(50) null);

alter table h_system_pair add objectId varchar2(120);
comment on column h_system_pair.objectId is '数据id';

alter table h_system_pair add schemaCode varchar2(40);
comment on column h_system_pair.schemaCode is '模型编码';

alter table h_system_pair add formCode varchar2(40);
comment on column h_system_pair.formCode is '表单编码';

alter table h_system_pair add workflowInstanceId varchar2(120);
comment on column h_system_pair.workflowInstanceId is '流程实例ID';

CREATE INDEX "idx_bid_fcode" ON  H_SYSTEM_PAIR (OBJECTID, FORMCODE);