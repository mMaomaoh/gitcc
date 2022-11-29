ALTER TABLE `h_biz_sheet` ADD COLUMN `tempAuthSchemaCodes` varchar (350) DEFAULT null COMMENT '临时授权的SchemaCode 以,分割';
ALTER TABLE `h_biz_sheet` ADD COLUMN `borderMode` varchar (10) DEFAULT null COMMENT '表单是否支持边框模式,close或open';
ALTER TABLE `h_biz_sheet` ADD COLUMN `layout` varchar (20) DEFAULT null COMMENT '表单边框布局,horizontal-左右布局,vertical-上下布局';

ALTER TABLE `h_biz_sheet` change `layout` `layoutType` varchar(20);

CREATE TABLE `h_perm_license` (
  `id` varchar(42) COLLATE utf8_bin NOT NULL,
  `bizId` varchar(42) COLLATE utf8_bin NOT NULL COMMENT '授权的业务id',
  `bizType` varchar(42) COLLATE utf8_bin NOT NULL COMMENT '业务类型，USER：用户；DEPART：部门；ROLE：角色',
  `createdTime` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

ALTER TABLE `h_biz_schema` MODIFY `remarks` varchar(2000) DEFAULT NULL;
ALTER TABLE `h_org_department` ADD COLUMN `isShow` bit(1) DEFAULT 1 COMMENT '部门是否可见';

ALTER TABLE `h_org_department` ADD COLUMN `deptType` varchar(40) DEFAULT 'DEPT' COMMENT '部门类型';

ALTER TABLE `h_org_role_group` ADD COLUMN `roleType` varchar(40) DEFAULT 'SYS' COMMENT '角色类型';

ALTER TABLE `h_org_role` ADD COLUMN `roleType` varchar(40) DEFAULT 'SYS' COMMENT '角色类型';

ALTER TABLE `h_org_role_user` ADD COLUMN `unitType` varchar(40) DEFAULT 'USER' COMMENT '角色关联类型';

ALTER TABLE `h_org_role_user` ADD COLUMN `deptId` varchar(40)  COMMENT '角色关联部门ID';

update `h_org_role_group` set roleType = 'DINGTALK' where sourceId is not null;

update `h_org_role` set roleType = 'DINGTALK' where sourceId is not null;

ALTER TABLE d_process_template CHANGE wfWorkItemId queryId VARCHAR(42) DEFAULT NULL COMMENT '列表ID';

INSERT INTO `h_system_setting`(`id`, `paramCode`, `paramValue`, `settingType`, `checked`, `fileUploadType`) VALUES ('2c928e636f3fe9b5016f3feb81c70000', 'dingtalk.isSynEdu', 'false', 'DINGTALK_BASE', b'0', NULL);

ALTER TABLE `h_system_pair`
MODIFY COLUMN `paramCode`  varchar(200) BINARY CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL AFTER `id`;

DROP index UK_9tviae6s7glway1kpyiybg4yp on `h_system_pair`;
ALTER TABLE `h_biz_perm_group` ADD COLUMN `departments` longtext COMMENT '部门范围';
ALTER TABLE `h_biz_perm_group` ADD COLUMN `authorType` varchar(40) DEFAULT null COMMENT '授权类型';

ALTER TABLE `h_biz_rule` ADD COLUMN `triggerSchemaCodeIsGroup` bit(1) DEFAULT 0 COMMENT '主表加子表数据项';

ALTER TABLE `h_biz_sheet`
    MODIFY COLUMN `shortCode`  varchar(50) BINARY CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '表单外链短码';

ALTER TABLE `biz_workflow_instance` ADD COLUMN `sequenceNo` varchar(200) DEFAULT null COMMENT '单据号';
ALTER TABLE `h_org_user` ADD COLUMN `imgUrlId` varchar(40) DEFAULT NULL COMMENT '头像id';
ALTER TABLE `h_biz_query_condition` ADD COLUMN `dateType` varchar(40) DEFAULT null COMMENT '日期快捷方式';
