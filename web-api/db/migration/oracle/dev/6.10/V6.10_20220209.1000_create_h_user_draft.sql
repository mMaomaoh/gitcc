create table H_USER_DRAFT
(
  ID                 VARCHAR2(120) not null,
  CREATER            VARCHAR2(120),
  CREATEDTIME        DATE,
  DELETED            NUMBER(1),
  MODIFIER           VARCHAR2(120),
  MODIFIEDTIME       DATE,
  REMARKS            VARCHAR2(200),
  USERID             VARCHAR2(100),
  NAME               VARCHAR2(200),
  BIZOBJECTKEY       VARCHAR2(100),
  FORMTYPE           VARCHAR2(100),
  WORKFLOWINSTANCEID VARCHAR2(100),
  SCHEMACODE         VARCHAR2(100),
  SHEETCODE          VARCHAR2(100)
);
comment on column H_USER_DRAFT.USERID is '用户ID';
comment on column H_USER_DRAFT.NAME is '标题【流程名称或者表单标题】';
comment on column H_USER_DRAFT.BIZOBJECTKEY is '草稿数据对应的业务对象ID';
comment on column H_USER_DRAFT.FORMTYPE is '表单类型：MODEL、WORKFLOW、WORKITEM';
comment on column H_USER_DRAFT.WORKFLOWINSTANCEID is '流程实例ID';
comment on column H_USER_DRAFT.SCHEMACODE is '模型编码';
comment on column H_USER_DRAFT.SHEETCODE is '表单编码';

create index IDX_USER_DRAFT_OBJECTKEY on H_USER_DRAFT (BIZOBJECTKEY);
create index IDX_USER_DRAFT_USERID on H_USER_DRAFT (USERID);
