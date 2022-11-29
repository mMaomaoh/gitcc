ALTER TABLE `h_biz_rule` ADD COLUMN `dataConditionJoinType` varchar(40) DEFAULT NULL COMMENT '触发数据条件连接类型';

ALTER TABLE `h_biz_rule` ADD COLUMN `dataConditionJson` longtext COMMENT '数据条件json';

ALTER TABLE `h_perm_group` ADD COLUMN `authorType` varchar(40) DEFAULT NULL COMMENT ' 授权类型';


ALTER TABLE `h_org_user` ADD COLUMN `pinYin` VARCHAR(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '姓名拼音';
ALTER TABLE `h_org_user` ADD COLUMN `shortPinYin` VARCHAR(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '姓名简拼';

ALTER TABLE `h_app_package` ADD COLUMN `appNameSpace` varchar(40) DEFAULT NULL COMMENT '应用命名空间';

ALTER TABLE h_perm_function_condition MODIFY COLUMN `value` LONGTEXT;

create table h_open_api_event
(
	id varchar(120) not null
		primary key,
	callback varchar(400) null comment '回调地址',
	clientId varchar(30) null comment '客户端编号',
	eventTarget varchar(300) null comment '事件对象',
	eventTargetType varchar(255) null comment '事件对象类型',
	eventType varchar(255) null comment '事件触发类型'
);

update h_biz_query_column set `name` = '拥有者' where propertyCode = 'owner';
update h_biz_query_column set `name` = '拥有者部门' where propertyCode = 'ownerDeptId';
update h_biz_query_condition set `name` = '拥有者' where propertyCode = 'owner';
update h_biz_query_condition set `name` = '拥有者部门' where propertyCode = 'ownerDeptId';
update h_biz_property set `name` = '拥有者' where code = 'owner';
update h_biz_property set `name` = '拥有者部门' where code = 'ownerDeptId';

CREATE TABLE `h_access_token` (
  `id` varchar(40) COLLATE utf8_bin NOT NULL,
  `userId` varchar(40) COLLATE utf8_bin DEFAULT NULL,
  `leastUse` tinyint(1) DEFAULT NULL,
  `accessToken` varchar(2000) COLLATE utf8_bin DEFAULT NULL,
  `createTime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_access_token_userId` (`userId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
ALTER TABLE `h_biz_rule` ADD COLUMN `targetTableCode` varchar(40) DEFAULT NULL COMMENT '目标对象编码';

ALTER TABLE `h_biz_rule` ADD COLUMN `ruleScopeChildJson` longtext COMMENT '子表查找范围json';

ALTER TABLE `h_biz_rule` ADD COLUMN `ruleActionMainScopeJson` longtext COMMENT '执行动作中主表筛选条件json';

ALTER TABLE `h_biz_rule` ADD COLUMN `insertConditionJoinType` varchar(40) DEFAULT NULL COMMENT '条件连接类型';


-- 放错到版本19
DELETE FROM h_perm_admin WHERE id='2c928a4c6c043e48016c04c108300a90';

INSERT INTO `h_perm_admin` (`id`, `creater`, `createdTime`, `deleted`, `modifier`, `modifiedTime`, `remarks`, `adminType`, `dataManage`, `dataQuery`, `userId`)
VALUES ('2c928a4c6c043e48016c04c108300a90', '2c928e4c6a4d1d87016a4d1f2f760048', '2019-9-6 10:23:15', '\0', NULL, '2019-9-6 10:23:15', NULL, 'ADMIN', true, true, '2c9280a26706a73a016706a93ccf002b');

-- 刪除审批意见类型数据项
DELETE FROM h_biz_property WHERE propertyType='COMMENT';

CREATE TABLE IF NOT EXISTS `h_report_page` (
  `id` varchar(120) NOT NULL,
  `creater` varchar(120) DEFAULT NULL,
  `createdTime` datetime DEFAULT NULL,
  `deleted` bit(1) DEFAULT NULL,
  `modifier` varchar(120) DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `code` varchar(40) DEFAULT NULL,
  `icon` varchar(50) DEFAULT NULL,
  `pcAble` bit(1) DEFAULT NULL COMMENT 'PC是否可见',
  `name` varchar(50) DEFAULT NULL,
  `mobileAble` bit(1) DEFAULT NULL COMMENT '移动端是否可见',
  `appCode` varchar(40) DEFAULT NULL,
  `name_i18n` varchar(1000) COLLATE utf8_bin DEFAULT NULL COMMENT '双语言',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- 数据规则触发记录表
ALTER TABLE `h_biz_rule_trigger` ADD COLUMN `triggerMainObjectId` varchar(100) DEFAULT NULL COMMENT '触发主表对象Id';
ALTER TABLE `h_biz_rule_trigger` ADD COLUMN `triggerMainObjectName` varchar(200) COLLATE utf8_bin DEFAULT '' COMMENT '触发主表对象数据标题';
ALTER TABLE `h_biz_rule_trigger` ADD COLUMN `triggerTableType` varchar(40) DEFAULT NULL COMMENT '触发表类型：主表，子表';
ALTER TABLE `h_biz_rule_trigger` ADD COLUMN `sourceAppCode` varchar(40) DEFAULT NULL COMMENT '触发应用编码';
ALTER TABLE `h_biz_rule_trigger` ADD COLUMN `sourceAppName` varchar(50) DEFAULT NULL COMMENT '触发应用名称';
ALTER TABLE `h_biz_rule_trigger` ADD COLUMN `sourceSchemaCode` varchar(40) DEFAULT NULL COMMENT '触发对象所属模型编码';
ALTER TABLE `h_biz_rule_trigger` ADD COLUMN `sourceSchemaName` varchar(50) DEFAULT NULL COMMENT '触发对象所属模型名称';
ALTER TABLE `h_biz_rule_trigger` ADD COLUMN `targetSchemaName` varchar(50) DEFAULT NULL COMMENT '目标所属模型名称';
ALTER TABLE `h_biz_rule_trigger` ADD COLUMN `targetTableCode` varchar(40) DEFAULT NULL COMMENT '目标表编码';
ALTER TABLE `h_biz_rule_trigger` ADD COLUMN `success` bit(1) DEFAULT NULL COMMENT '是否执行成功';
ALTER TABLE `h_biz_rule_trigger` ADD COLUMN `failLog` longtext COMMENT '执行失败日志';
ALTER TABLE `h_biz_rule_trigger` ADD COLUMN `effect` bit(1) DEFAULT NULL COMMENT '执行是否有影响数据';

-- 数据规则影响数据表
ALTER TABLE `h_biz_rule_effect` ADD COLUMN `targetTableType` varchar(40) DEFAULT NULL COMMENT '目标表类型：主表，子表';
ALTER TABLE `h_biz_rule_effect` ADD COLUMN `targetTableCode` varchar(40) DEFAULT NULL COMMENT '目标表编码';
ALTER TABLE `h_biz_rule_effect` ADD COLUMN `targetMainObjectId` varchar(100) DEFAULT NULL COMMENT '目标主表对象Id';
ALTER TABLE `h_biz_rule_effect` ADD COLUMN `targetMainObjectName` varchar(200) COLLATE utf8_bin DEFAULT '' COMMENT '目标主表对象数据标题';
ALTER TABLE `h_biz_rule_effect` ADD COLUMN `targetPropertyLastValue` longtext COMMENT '字段修改前数据';
ALTER TABLE `h_biz_rule_effect` ADD COLUMN `targetPropertySetValue` longtext COMMENT '字段修改后数据';
ALTER TABLE `h_biz_rule_effect` ADD COLUMN `targetPropertyName` varchar(50) DEFAULT NULL COMMENT '目标字段名称';
ALTER TABLE `h_biz_rule_effect` ADD COLUMN `targetPropertyType` varchar(40) DEFAULT NULL COMMENT '目标字段类型';

ALTER TABLE `h_report_page` ADD COLUMN `reportObjectId` varchar(40) DEFAULT NULL COMMENT '报表编码';
CREATE TABLE `h_biz_query_present` (
   `id` varchar(120) COLLATE utf8_bin NOT NULL,
   `creater` varchar(120) COLLATE utf8_bin DEFAULT NULL,
   `createdTime` datetime DEFAULT NULL,
   `deleted` bit(1) DEFAULT NULL,
   `modifier` varchar(120) COLLATE utf8_bin DEFAULT NULL,
   `modifiedTime` datetime DEFAULT NULL,
   `remarks` varchar(200) COLLATE utf8_bin DEFAULT NULL,
   `queryId` varchar(36) COLLATE utf8_bin DEFAULT NULL,
   `schemaCode` varchar(40) COLLATE utf8_bin DEFAULT NULL,
   `clientType` varchar(40) DEFAULT NULL COMMENT 'PC或者MOBILE端',
   `htmlJson` longtext COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '列表htmlJson数据',
   `actionsJson` longtext COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '列表action操作JSON数据',
   `columnsJson` longtext COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '列表展示字段columnJSON数据',
   PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;


ALTER TABLE `h_biz_query` ADD COLUMN `queryPresentationType` varchar(40) DEFAULT 'LIST' COMMENT '列表视图类型';

ALTER TABLE `h_biz_query` ADD COLUMN `showOnPc` bit(1) DEFAULT NULL COMMENT 'PC是否可见';

ALTER TABLE `h_biz_query` ADD COLUMN `showOnMobile` bit(1) DEFAULT NULL COMMENT '移动端是否可见';

ALTER TABLE `h_biz_query` ADD COLUMN `publish` bit(1) DEFAULT NULL COMMENT '发布状态';

ALTER TABLE `h_biz_query_column` ADD COLUMN `clientType` varchar(40) DEFAULT 'PC' COMMENT 'PC或者MOBILE端';

ALTER TABLE `h_biz_query_condition` ADD COLUMN `clientType` varchar(40) DEFAULT 'PC' COMMENT 'PC或者MOBILE端';

ALTER TABLE `h_biz_query_sorter` ADD COLUMN `clientType` varchar(40) DEFAULT 'PC' COMMENT 'PC或者MOBILE端';

ALTER TABLE `h_biz_query_action` ADD COLUMN `clientType` varchar(40) DEFAULT 'PC' COMMENT 'PC或者MOBILE端';


ALTER TABLE `h_org_department` ADD COLUMN `dingDeptManagerId` varchar(255) DEFAULT NULL COMMENT '钉钉部门主管id集合';

ALTER TABLE `h_org_role_user` ADD COLUMN `userSourceId` varchar(255) DEFAULT NULL COMMENT '钉钉用户id非unionId';
ALTER TABLE `h_org_role_user` ADD COLUMN `roleSourceId` varchar(255) DEFAULT NULL COMMENT '钉钉角色id';

-- 更新数据
update h_org_role_user,h_org_role set h_org_role_user.roleSourceId = h_org_role.sourceId WHERE h_org_role_user.roleId = h_org_role.id;

update h_org_role_user,h_org_user set h_org_role_user.userSourceId = h_org_user.userId WHERE h_org_role_user.userId = h_org_user.id;


ALTER TABLE `h_org_dept_user` ADD COLUMN `userSourceId` varchar(255) DEFAULT NULL COMMENT '钉钉用户id非unionId';
ALTER TABLE `h_org_dept_user` ADD COLUMN `deptSourceId` varchar(255) DEFAULT NULL COMMENT '钉钉部门id';

-- 更新数据
update h_org_dept_user,h_org_department set h_org_dept_user.deptSourceId = h_org_department.sourceId WHERE h_org_dept_user.deptId = h_org_department.id;

update h_org_dept_user,h_org_user set h_org_dept_user.userSourceId = h_org_user.userId WHERE h_org_dept_user.userId = h_org_user.id;


-- 角色用户关联表联合索引
ALTER TABLE `h_org_role_user` ADD INDEX `idx_role_user_sourceid` (`userSourceId`,`roleSourceId`);

-- 部门用户关联表联合索引
ALTER TABLE `h_org_dept_user` ADD INDEX `idx_dept_user_composeid` (`userId`,`deptId`);

-- 修改部门名称字段的字符编码
ALTER TABLE `h_org_department` CHANGE `name` `name` varchar(180) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL ;

-- 修改角色名称字段的字符编码
ALTER TABLE `h_org_role` CHANGE `name` `name` varchar(180) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL ;

-- 修改日志表内容字段的字符编码
ALTER TABLE `h_log_metadata` CHANGE `metaData` `metaData` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL ;
ALTER TABLE `h_app_function` ADD COLUMN `pcAble` bit(1) DEFAULT 1 COMMENT 'PC是否可见';

ALTER TABLE `h_app_function` ADD COLUMN `mobileAble` bit(1) DEFAULT 1 COMMENT '移动端是否可见';

UPDATE `h_app_function` SET `pcAble`=0 WHERE `type`='Report' AND `code` IN (SELECT `code` FROM `h_report_page` WHERE `pcAble`=0);

UPDATE `h_app_function` SET `mobileAble`=0 WHERE `type`='Report' AND `code` IN (SELECT `code` FROM `h_report_page` WHERE `mobileAble`=0);

CREATE TABLE `d_process_instance` (
  `id` varchar(42) NOT NULL,
  `processCode` varchar(120) NOT NULL COMMENT '钉钉模板code',
  `originator` varchar(64) NOT NULL COMMENT '实例发起人的userid',
  `title` varchar(64) DEFAULT NULL COMMENT '实例的标题',
  `url` varchar(255) NOT NULL COMMENT '实例在审批应用里的跳转url，需要同时适配移动端和pc端',
  `processInstanceId` varchar(64) NOT NULL COMMENT '钉钉实例id',
  `wfInstanceId` varchar(64) NOT NULL COMMENT '云枢流程实例id',
  `formComponents` longtext COMMENT '表单参数',
  `status` varchar(42) DEFAULT NULL COMMENT '钉钉实例状态，分为COMPLETED, TERMINATED',
  `result` varchar(42) DEFAULT NULL COMMENT '任务结果，分为agree和refuse',
  `createTime` datetime DEFAULT NULL,
  `requestId` varchar(42) DEFAULT NULL COMMENT '钉钉每次请求的id',
  `wfWorkItemId` varchar(64) DEFAULT NULL,
  `bizProcessStatus` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`)
  -- UNIQUE KEY `IDX_UNIQUE_WFIID` (`wfInstanceId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `d_process_task` (
  `id` varchar(42) NOT NULL,
  `processInstanceId` varchar(64) NOT NULL,
  `taskId` bigint(20) NOT NULL,
  `userId` varchar(64) NOT NULL COMMENT '钉钉用户id',
  `url` varchar(255) DEFAULT NULL COMMENT '待办任务跳转url',
  `wfWorkItemId` varchar(42) NOT NULL COMMENT '云枢业务任务id',
  `wfInstanceId` varchar(42) NOT NULL,
  `status` varchar(64) DEFAULT NULL COMMENT '任务状态，分为CANCELED和COMPLETED',
  `result` varchar(64) DEFAULT NULL COMMENT '任务结果，氛围agree和refuse',
  `createTime` datetime DEFAULT NULL,
  `requestId` varchar(42) DEFAULT NULL COMMENT '钉钉每次请求的id',
  `bizProcessStatus` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `d_process_template` (
  `id` varchar(42) NOT NULL,
  `tempCode` varchar(64) NOT NULL COMMENT '云枢业务定义的模板code',
  `processCode` varchar(120) NOT NULL COMMENT '钉钉模板code',
  `processName` varchar(64) NOT NULL COMMENT '模板名称',
  `agentId` decimal(10,0) NOT NULL COMMENT '企业微应用标识',
  `formField` longtext COMMENT '表单字段',
  `createTime` datetime DEFAULT NULL,
  `requestId` varchar(42) DEFAULT NULL COMMENT '钉钉每次请求的id',
  `bizProcessStatus` varchar(64) DEFAULT NULL,
  `wfWorkItemId` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_UNIQUE_TEMP_CODE` (`tempCode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='钉钉流程模板';
