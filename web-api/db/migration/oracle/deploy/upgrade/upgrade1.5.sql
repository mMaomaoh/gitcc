ALTER TABLE h_biz_sheet ADD (tempAuthSchemaCodes VARCHAR(350) DEFAULT null);
comment on column h_biz_sheet.tempAuthSchemaCodes is '临时授权的SchemaCode 以,分割';
ALTER TABLE h_biz_sheet ADD (borderMode VARCHAR(10) DEFAULT null);
comment on column h_biz_sheet.borderMode is '表单是否支持边框模式,close或open';
ALTER TABLE h_biz_sheet ADD (layout VARCHAR(20) DEFAULT null);
comment on column h_biz_sheet.layout is '表单边框布局,horizontal-左右布局,vertical-上下布局';

ALTER TABLE h_biz_sheet rename column layout to layoutType;

CREATE TABLE h_perm_license
(
    id                varchar(42) NOT NULL,
    bizId             varchar(42) NOT NULL,
    bizType           varchar(42) NOT NULL,
    createdTime       date        NOT NULL,
    PRIMARY KEY (id)
);

ALTER TABLE H_BIZ_SCHEMA MODIFY  (remarks VARCHAR(2000));
ALTER TABLE h_org_department ADD (isShow number(1,0) DEFAULT 1);
comment on column h_org_department.isShow is '部门是否可见';

ALTER TABLE h_org_department ADD (deptType VARCHAR(40) DEFAULT 'DEPT');
comment on column h_org_department.deptType is '部门类型';

ALTER TABLE h_org_role_group ADD (roleType VARCHAR(40) DEFAULT 'SYS');
comment on column h_org_role_group.roleType is '角色类型';

ALTER TABLE h_org_role ADD (roleType VARCHAR(40) DEFAULT 'SYS');
comment on column h_org_role.roleType is '角色类型';

ALTER TABLE h_org_role_user ADD (unitType VARCHAR(40) DEFAULT 'USER');
comment on column h_org_role_user.unitType is '角色关联类型';

ALTER TABLE h_org_role_user ADD (deptId VARCHAR(40) );
comment on column h_org_role_user.deptId is '角色关联部门ID';

UPDATE h_org_role_group SET roleType = 'DINGTALK' WHERE  sourceId is not null;

UPDATE h_org_role SET roleType = 'DINGTALK' WHERE  sourceId is not null;

ALTER TABLE d_process_template RENAME COLUMN wfWorkItemId TO queryId;
ALTER TABLE d_process_template MODIFY (queryId VARCHAR(42));
comment on column d_process_template.queryId is '列表ID';

INSERT INTO h_system_setting(id, paramCode, paramValue, settingType, checked, fileUploadType)
VALUES ('2c928e636f3fe9b5016f3feb81c70000', 'dingtalk.isSynEdu', 'false', 'DINGTALK_BASE', 0, NULL);

-- DROP index UK_h_system_pair_paramCode;
alter table h_system_pair drop constraint UK_h_system_pair_paramCode;
ALTER TABLE h_biz_perm_group ADD (departments clob DEFAULT null);
comment on column h_biz_perm_group.departments is '部门范围';

ALTER TABLE h_biz_perm_group ADD (authorType VARCHAR(40) DEFAULT null);
comment on column h_biz_perm_group.authorType is '授权类型';

ALTER TABLE h_biz_rule ADD (triggerSchemaCodeIsGroup number(1, 0) DEFAULT null);
comment on column h_biz_rule.triggerSchemaCodeIsGroup is '主表加子表数据项';

ALTER TABLE biz_workflow_instance ADD (sequenceNo VARCHAR(200) DEFAULT null);
comment on column biz_workflow_instance.sequenceNo is '单据号';
ALTER TABLE h_org_user ADD (imgUrlId VARCHAR(40) DEFAULT null);
comment on column h_org_user.imgUrlId is '头像id';

ALTER TABLE h_biz_query_condition ADD (dateType VARCHAR(40) DEFAULT null);
comment on column h_biz_query_condition.dateType is '日期快捷方式';
