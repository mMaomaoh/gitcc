ALTER TABLE h_biz_rule ADD (dataConditionJoinType VARCHAR(40) DEFAULT null);
comment on column h_biz_rule.dataConditionJoinType is '触发数据条件连接类型';

ALTER TABLE h_biz_rule ADD (dataConditionJson CLOB);
comment on column h_biz_rule.dataConditionJson is '数据条件json';

ALTER TABLE h_perm_group ADD (authorType varchar2(40) DEFAULT null);

ALTER TABLE h_org_user ADD (pinYin VARCHAR(250) DEFAULT null);
comment on column h_org_user.pinYin is '姓名拼音';

ALTER TABLE h_org_user ADD (shortPinYin VARCHAR(250) DEFAULT null);
comment on column h_org_user.shortPinYin is '姓名简拼';

ALTER TABLE h_app_package ADD (appNameSpace varchar2(40) DEFAULT NULL);

-- ALTER TABLE h_perm_function_condition MODIFY (value CLOB);

create table h_open_api_event
(
  id varchar2(120) not null
    primary key,
  callback varchar2(400) null,
  clientId varchar2(30) null,
  eventTarget varchar2(300) null,
  eventTargetType varchar2(255) null,
  eventType varchar2(255) null
);

update h_biz_query_column set name = '拥有者' where propertyCode = 'owner';
update h_biz_query_column set name = '拥有者部门' where propertyCode = 'ownerDeptId';
update h_biz_query_condition set name = '拥有者' where propertyCode = 'owner';
update h_biz_query_condition set name = '拥有者部门' where propertyCode = 'ownerDeptId';
update h_biz_property set name = '拥有者' where code = 'owner';
update h_biz_property set name = '拥有者部门' where code = 'ownerDeptId';

CREATE TABLE h_access_token (
                              id varchar2(40)  NOT NULL PRIMARY KEY,
                              userId varchar2(40)  DEFAULT NULL,
                              leastUse int DEFAULT NULL,
                              accessToken varchar2(2000)  DEFAULT NULL,
                              createTime date DEFAULT NULL
);

create index idx_access_token_userId on h_access_token (userId);
ALTER TABLE h_biz_rule ADD (targetTableCode VARCHAR(40) DEFAULT null);
comment on column h_biz_rule.targetTableCode is '目标对象编码';

ALTER TABLE h_biz_rule ADD (ruleScopeChildJson CLOB);
comment on column h_biz_rule.ruleScopeChildJson is '子表查找范围json';

ALTER TABLE h_biz_rule ADD (ruleActionMainScopeJson CLOB);
comment on column h_biz_rule.ruleActionMainScopeJson is '执行动作中主表筛选条件json';


ALTER TABLE h_biz_rule ADD (insertConditionJoinType VARCHAR(40) DEFAULT null);
comment on column h_biz_rule.insertConditionJoinType is '条件连接类型';



DELETE FROM h_perm_admin WHERE id='2c928a4c6c043e48016c04c108300a90';

INSERT INTO h_perm_admin (id, creater, createdTime, deleted, modifier, modifiedTime, remarks, adminType, dataManage, dataQuery, userId)
VALUES ('2c928a4c6c043e48016c04c108300a90', '2c928e4c6a4d1d87016a4d1f2f760048', sysdate, 0, NULL, sysdate, NULL, 'ADMIN', 1, 1, '2c9280a26706a73a016706a93ccf002b');

-- 刪除审批意见类型数据项
DELETE FROM h_biz_property WHERE propertyType='COMMENT';
CREATE TABLE h_report_page
(
    id           varchar2(120) NOT NULL PRIMARY KEY,
    creater      varchar2(120),
    createdTime  date,
    deleted      number(1, 0),
    modifier     varchar2(120),
    modifiedTime date,
    remarks      varchar2(200),
    code         varchar2(40),
    icon         varchar2(50),
    pcAble       number(1, 0),
    name         varchar2(50),
    mobileAble   number(1, 0),
    appCode      varchar2(40),
    name_i18n    varchar2(1000)
);

-- 数据规则触发记录表
ALTER TABLE h_biz_rule_trigger
    ADD ( triggerMainObjectId varchar2(100));
ALTER TABLE h_biz_rule_trigger
    ADD ( triggerMainObjectName varchar2(200));
ALTER TABLE h_biz_rule_trigger
    ADD ( triggerTableType varchar2(40));
ALTER TABLE h_biz_rule_trigger
    ADD ( sourceAppCode varchar2(40));
ALTER TABLE h_biz_rule_trigger
    ADD ( sourceAppName varchar2(50));
ALTER TABLE h_biz_rule_trigger
    ADD ( sourceSchemaCode varchar2(40));
ALTER TABLE h_biz_rule_trigger
    ADD ( sourceSchemaName varchar2(50));
ALTER TABLE h_biz_rule_trigger
    ADD ( targetSchemaName varchar2(50));
ALTER TABLE h_biz_rule_trigger
    ADD ( targetTableCode varchar2(40));
ALTER TABLE h_biz_rule_trigger
    ADD ( success number(1, 0));
ALTER TABLE h_biz_rule_trigger
    ADD ( failLog CLOB);
ALTER TABLE h_biz_rule_trigger
    ADD ( effect number(1, 0));

-- 数据规则影响数据表
ALTER TABLE h_biz_rule_effect
    ADD ( targetTableType varchar2(40));
ALTER TABLE h_biz_rule_effect
    ADD ( targetTableCode varchar2(40));
ALTER TABLE h_biz_rule_effect
    ADD ( targetMainObjectId varchar2(100));
ALTER TABLE h_biz_rule_effect
    ADD ( targetMainObjectName varchar2(200));
ALTER TABLE h_biz_rule_effect
    ADD ( targetPropertyLastValue CLOB);
ALTER TABLE h_biz_rule_effect
    ADD ( targetPropertySetValue CLOB);
ALTER TABLE h_biz_rule_effect
    ADD ( targetPropertyName varchar2(50));
ALTER TABLE h_biz_rule_effect
    ADD ( targetPropertyType varchar2(40));


ALTER TABLE h_report_page
    ADD ( reportObjectId varchar2(40));
CREATE TABLE h_biz_query_present (
  id varchar2(120)  NOT NULL primary key,
  creater varchar2(120)  DEFAULT NULL,
  createdTime date DEFAULT NULL,
  deleted number(1, 0) DEFAULT NULL,
  modifier varchar2(120)  DEFAULT NULL,
  modifiedTime date DEFAULT NULL,
  remarks varchar2(200)  DEFAULT NULL,
  queryId varchar2(36) DEFAULT NULL,
  schemaCode varchar2(40) DEFAULT NULL,
  clientType varchar2(40)  DEFAULT NULL,
  htmlJson clob  DEFAULT NULL,
  actionsJson clob  DEFAULT NULL,
  columnsJson clob  DEFAULT NULL
);

comment on column h_biz_query_present.clientType is 'PC或者MOBILE端';
comment on column h_biz_query_present.htmlJson is '列表htmlJson数据';
comment on column h_biz_query_present.actionsJson is '列表action操作JSON数据';
comment on column h_biz_query_present.columnsJson is '列表展示字段columnJSON数据';

ALTER TABLE h_biz_query ADD (queryPresentationType VARCHAR(40) DEFAULT 'LIST');
comment on column h_biz_query.queryPresentationType is '列表视图类型';

ALTER TABLE h_biz_query ADD (showOnPc number(1, 0) DEFAULT NULL);
comment on column h_biz_query.showOnPc is 'PC是否可见';

ALTER TABLE h_biz_query ADD (showOnMobile number(1, 0) DEFAULT NULL);
comment on column h_biz_query.showOnMobile is '移动端是否可见';

ALTER TABLE h_biz_query ADD (publish number(1, 0) DEFAULT NULL);
comment on column h_biz_query.publish is '发布状态';


ALTER TABLE h_biz_query_column ADD (clientType VARCHAR(40) DEFAULT 'PC');
comment on column h_biz_query_column.clientType is 'PC或者MOBILE端';


ALTER TABLE h_biz_query_condition ADD (clientType VARCHAR(40) DEFAULT 'PC');
comment on column h_biz_query_condition.clientType is 'PC或者MOBILE端';

ALTER TABLE h_biz_query_sorter ADD (clientType VARCHAR(40) DEFAULT 'PC');
comment on column h_biz_query_sorter.clientType is 'PC或者MOBILE端';


ALTER TABLE h_biz_query_action ADD (clientType VARCHAR(40) DEFAULT 'PC');
comment on column h_biz_query_action.clientType is 'PC或者MOBILE端';

ALTER TABLE h_org_department ADD (dingDeptManagerId VARCHAR(255) DEFAULT null);
comment on column h_org_department.dingDeptManagerId is '钉钉部门主管id集合';


ALTER TABLE h_org_role_user ADD (userSourceId VARCHAR(255) DEFAULT null);
comment on column h_org_role_user.userSourceId is '钉钉用户id非unionId';
ALTER TABLE h_org_role_user ADD (roleSourceId VARCHAR(255) DEFAULT null);
comment on column h_org_role_user.roleSourceId is '钉钉角色id';

-- 更新数据
-- update h_org_role_user,h_org_role set h_org_role_user.roleSourceId = h_org_role.sourceId WHERE h_org_role_user.roleId = h_org_role.id;
--
-- update h_org_role_user,h_org_user set h_org_role_user.userSourceId = h_org_user.userId WHERE h_org_role_user.userId = h_org_user.id;


ALTER TABLE h_org_dept_user ADD (userSourceId VARCHAR(255) DEFAULT null);
comment on column h_org_dept_user.userSourceId is '钉钉用户id非unionId';
ALTER TABLE h_org_dept_user ADD (deptSourceId VARCHAR(255) DEFAULT null);
comment on column h_org_dept_user.deptSourceId is '钉钉部门id';

-- 更新数据
-- update h_org_dept_user,h_org_department set h_org_dept_user.deptSourceId = h_org_department.sourceId WHERE h_org_dept_user.deptId = h_org_department.id;

-- update h_org_dept_user,h_org_user set h_org_dept_user.userSourceId = h_org_user.userId WHERE h_org_dept_user.userId = h_org_user.id;

-- 角色用户关联表联合索引
CREATE INDEX idx_role_user_sourceid ON h_org_role_user(userSourceId,roleSourceId);

-- 部门用户关联表联合索引
CREATE INDEX idx_dept_user_composeid ON h_org_dept_user(userId,deptId);

ALTER TABLE h_app_function ADD (pcAble number(1,0) DEFAULT 1);

ALTER TABLE h_app_function ADD (mobileAble number(1,0) DEFAULT 1);

UPDATE h_app_function SET pcAble=0 WHERE type='Report' AND code IN (SELECT code FROM h_report_page WHERE pcAble=0);

UPDATE h_app_function SET mobileAble=0 WHERE type='Report' AND code IN (SELECT code FROM h_report_page WHERE mobileAble=0);

CREATE TABLE d_process_instance
(
    id                varchar(42)  NOT NULL,
    processCode       varchar(120) NOT NULL,
    originator        varchar(64)  NOT NULL,
    title             varchar(64) DEFAULT NULL,
    url               varchar(255) NOT NULL,
    processInstanceId varchar(64)  NOT NULL,
    wfInstanceId      varchar(64)  NOT NULL,
    formComponents    clob,
    status            varchar(42) DEFAULT NULL,
    result            varchar(42) DEFAULT NULL,
    createTime        date        DEFAULT NULL,
    requestId         varchar(42) DEFAULT NULL,
    wfWorkItemId      varchar(64) DEFAULT NULL,
    bizProcessStatus  varchar(64) DEFAULT NULL,
    PRIMARY KEY (id)
    -- UNIQUE KEY IDX_UNIQUE_WFIID (wfInstanceId)
);

CREATE TABLE d_process_task
(
    id                varchar(42) NOT NULL,
    processInstanceId varchar(64) NOT NULL,
    taskId            int         NOT NULL,
    userId            varchar(64) NOT NULL,
    url               varchar(255) DEFAULT NULL,
    wfWorkItemId      varchar(42) NOT NULL,
    wfInstanceId      varchar(42) NOT NULL,
    status            varchar(64)  DEFAULT NULL,
    result            varchar(64)  DEFAULT NULL,
    createTime        date         DEFAULT NULL,
    requestId         varchar(42)  DEFAULT NULL,
    bizProcessStatus  varchar(64)  DEFAULT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE d_process_template
(
    id               varchar(42)    NOT NULL,
    tempCode         varchar(64)    NOT NULL,
    processCode      varchar(120)   NOT NULL,
    processName      varchar(64)    NOT NULL,
    agentId          decimal(10, 0) NOT NULL,
    formField        clob,
    createTime       date        DEFAULT NULL,
    requestId        varchar(42) DEFAULT NULL,
    bizProcessStatus varchar(64) DEFAULT NULL,
    wfWorkItemId     varchar(64) DEFAULT NULL,
    PRIMARY KEY (id)
);

create index idx_d_process_template_tc on d_process_template (tempCode);
