/*无数据可不运行此sql存储过程*/
/*备份h_biz_query_action  列表操作按钮表*/
create table if not exists h_biz_query_action_bak select * from h_biz_query_action a;

/***************************************新增h_biz_query_action 拥有者修改操作按钮PC端的历史数据***************************************************/
DELIMITER //
DROP PROCEDURE IF EXISTS insertBizQueryAction;
CREATE PROCEDURE insertBizQueryAction()
BEGIN
	DECLARE childSchemaCount INT DEFAULT 0;
	DECLARE schemaCodeFirst VARCHAR(50) DEFAULT '';
	DECLARE createdTimeFirst VARCHAR(50) DEFAULT '';
	DECLARE createrFirst VARCHAR(50) DEFAULT '';
	DECLARE modifierFirst VARCHAR(50) DEFAULT '';
	DECLARE queryIdFirst VARCHAR(50) DEFAULT '';
	DECLARE editOwnerCount INT DEFAULT 0;
	DECLARE done  INT DEFAULT 0;
	DECLARE taskCursor CURSOR FOR SELECT queryId FROM h_biz_query_action AS a GROUP BY a.queryId ;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
  OPEN taskCursor;
--                                  第一个游标循环开始
		cursor_loop:LOOP
			FETCH taskCursor INTO queryIdFirst ;
			IF done = 1 THEN
				LEAVE cursor_loop;
			ELSE
				SET schemaCodeFirst= (SELECT schemaCode FROM h_biz_query_action AS a WHERE a.queryId = queryIdFirst GROUP BY a.schemaCode limit 1 );
				SET createrFirst= (SELECT creater FROM h_biz_query_action AS a WHERE a.queryId = queryIdFirst GROUP BY a.creater limit 1 );
				SET modifierFirst= (SELECT modifier FROM h_biz_query_action AS a WHERE a.queryId = queryIdFirst GROUP BY a.modifier limit 1 );
				SET createdTimeFirst= (SELECT createdTime FROM h_biz_query_action AS a WHERE a.queryId = queryIdFirst GROUP BY a.createdTime limit 1 );
				SET editOwnerCount = (SELECT COUNT(*) FROM h_biz_query_action AS a WHERE a.queryId = queryIdFirst AND a.queryActionType = 'EDITOWNER' );
				IF editOwnerCount < 1 THEN
					INSERT INTO `h_biz_query_action`( `id`,
														`creater`,
														`createdTime`,
														`deleted`,
														`modifier`,
														`modifiedTime`,
														`remarks`,
														`actionCode`,
														`associationCode`,
														`associationType`,
														`customService`,
														`icon`,
														`name`,
														`queryActionType`,
														`queryId`,
														`schemaCode`,
														`serviceCode`,
														`serviceMethod`,
														`sortKey`,
														`systemAction`,
														`name_i18n`,
														`clientType`)
													values
													(replace(uuid(),"-",""),createrFirst,createdTimeFirst,0,modifierFirst,Null,NULL,'editowner',Null,Null,0,
													NULL,'修改拥有者','EDITOWNER',queryIdFirst,schemaCodeFirst,NULL,NULL,'6',0,NULL,'PC');
				END IF;
			END IF;
		END LOOP cursor_loop;
  CLOSE taskCursor;
END;
//
DELIMITER ;
CALL  insertBizQueryAction();
ALTER TABLE `biz_workitem` ADD COLUMN `isTrust` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否被委托，0：否；1：是';
ALTER TABLE `biz_workitem` ADD COLUMN `trustor` varchar(42) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '委托人ID';
ALTER TABLE `biz_workitem` ADD COLUMN `trustorName` varchar(80) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '委托人名称';

ALTER TABLE `biz_workitem_finished` ADD COLUMN `isTrust` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否被委托，0：否；1：是';
ALTER TABLE `biz_workitem_finished` ADD COLUMN `trustor` varchar(42) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '委托人ID';
ALTER TABLE `biz_workitem_finished` ADD COLUMN `trustorName` varchar(80) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '委托人名称';

ALTER TABLE `biz_workflow_instance` ADD COLUMN `isTrustStart` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否被委托发起，0：否；1：是';
ALTER TABLE `biz_workflow_instance` ADD COLUMN `trustee` varchar(42) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '被委托人ID';
ALTER TABLE `biz_workflow_instance` ADD COLUMN `trusteeName` varchar(80) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '被委托人名称';


CREATE TABLE `h_workflow_trust` (
    `id` varchar(42) COLLATE utf8_bin NOT NULL,
    `workflowTrustRuleId` varchar(42) COLLATE utf8_bin NOT NULL,
    `workflowCode` varchar(40) COLLATE utf8_bin NOT NULL,
    `creater` varchar(42) COLLATE utf8_bin DEFAULT NULL,
    `createTime` datetime DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `IDX_PROXY_RULE_WFCODE` (`workflowTrustRuleId`,`workflowCode`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='流程委托表';

CREATE TABLE `h_workflow_trust_rule` (
    `id` varchar(42) COLLATE utf8_bin NOT NULL,
    `trustor` varchar(42) COLLATE utf8_bin NOT NULL COMMENT '委托人id',
    `trustorName` varchar(80) CHARACTER SET utf8mb4 NOT NULL COMMENT '委托人名称',
    `trustee` varchar(42) COLLATE utf8_bin NOT NULL COMMENT '受托人id',
    `trusteeName` varchar(80) CHARACTER SET utf8mb4 NOT NULL COMMENT '受托人名称',
    `trustType` varchar(20) COLLATE utf8_bin NOT NULL COMMENT '委托类型，流程审批：APPROVAL；流程发起：START',
    `startTime` datetime DEFAULT NULL COMMENT '委托开始时间',
    `endTime` datetime DEFAULT NULL COMMENT '委托结束时间',
    `rangeType` varchar(20) COLLATE utf8_bin NOT NULL COMMENT '委托范围类型，全部：ALL；部分：PART',
    `state` varchar(20) COLLATE utf8_bin DEFAULT NULL COMMENT '委托规则状态，RUN;STOP',
    `creater` varchar(42) COLLATE utf8_bin DEFAULT NULL,
    `createTime` datetime DEFAULT NULL,
    `modifier` varchar(42) COLLATE utf8_bin DEFAULT NULL,
    `modifiedTime` datetime DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `IDX_WF_TRUSTOR` (`trustor`),
    KEY `IDX_WF_TRUSTEE` (`trustee`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='流程、任务委托规则';


CREATE TABLE `h_biz_database_pool` (
    `id` varchar(120) NOT NULL,
    `creater` varchar(120) DEFAULT NULL,
    `createdTime` datetime DEFAULT NULL,
    `deleted` bit(1) DEFAULT NULL,
    `modifier` varchar(120) DEFAULT NULL,
    `modifiedTime` datetime DEFAULT NULL,
    `remarks` varchar(200) DEFAULT NULL,
    `code` varchar(40) COLLATE utf8_bin NOT NULL COMMENT '数据库连接池编码',
    `name` varchar(50) CHARACTER SET utf8mb4 NOT NULL COMMENT '数据库连接池名称',
    `description` varchar(2000) DEFAULT NULL COMMENT '描述',
    `databaseType` varchar(15) NOT NULL COMMENT '数据库类型',
    `jdbcUrl` varchar(200) DEFAULT NULL COMMENT '数据库连接串',
    `username` varchar(40) DEFAULT NULL COMMENT '账号',
    `password` varchar(40) DEFAULT NULL COMMENT '密码',
    PRIMARY KEY (`id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='业务数据库连接池';


ALTER TABLE `biz_workflow_instance` DROP COLUMN `isTrustStart`;
ALTER TABLE `biz_workflow_instance` ADD COLUMN `trustType` varchar(20) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '委托类型，流程审批：APPROVAL；流程发起：START';

ALTER TABLE `h_org_user` ADD COLUMN `position` varchar(80) DEFAULT NULL COMMENT '职位';


ALTER TABLE `h_perm_biz_function` ADD COLUMN `editOwnerAble` BIT(1) DEFAULT NULL COMMENT '更新拥有者';

CREATE TABLE `h_log_synchro` (
    `id` varchar(42) COLLATE utf8_bin NOT NULL,
    `trackId` varchar(60) COLLATE utf8_bin NOT NULL COMMENT '同步批次',
    `creater` varchar(42) COLLATE utf8_bin DEFAULT NULL COMMENT '创建人',
    `createdTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '数据创建时间',
    `startTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '同步开始时间',
    `endTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '同步结束时间',
    `fixer` varchar(42) COLLATE utf8_bin DEFAULT NULL COMMENT '修复人',
    `fixedTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '最新的修复时间',
    `fixedCount` int(11) NOT NULL DEFAULT 0 COMMENT '修复次数',
    `fixNotes` varchar(1000) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '修复说明',
    `fixedStatus` varchar(40) COLLATE utf8_bin DEFAULT NULL COMMENT '修复状态',
    `executeStatus` varchar(40) COLLATE utf8_bin DEFAULT NULL COMMENT '执行状态',
    PRIMARY KEY (`id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='组织同步操作日志';

ALTER TABLE `h_org_synchronize_log` ADD COLUMN `corpId` varchar(120) DEFAULT NULL COMMENT '组织corpId';

ALTER TABLE `h_org_synchronize_log` ADD COLUMN `status` varchar(40) DEFAULT NULL COMMENT '状态';


ALTER TABLE `h_biz_database_pool` MODIFY `password` varchar(300)  DEFAULT NULL ;


ALTER TABLE `h_biz_property`
    ADD INDEX `Idx_schemaCode` (`schemaCode`) USING BTREE ;

ALTER TABLE `h_biz_schema`
    ADD INDEX `idx_schemaCode` (`code`) USING BTREE ;
CREATE TABLE IF NOT EXISTS `h_business_rule` (
  `id` varchar(120) NOT NULL,
  `createdTime` datetime DEFAULT NULL,
  `creater` varchar(120) DEFAULT NULL,
  `deleted` bit(1) DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `modifier` varchar(120) DEFAULT NULL,
  `node` longtext,
  `route` longtext,
  `schedulerSetting` longtext,
  `bizRuleType` varchar(15) DEFAULT NULL,
  `defaultRule` bit(1) DEFAULT NULL,
  `code` varchar(40) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `schemaCode` varchar(40) DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE IF NOT EXISTS `h_log_business_rule_header` (
  `id` varchar(120) NOT NULL,
  `businessRuleCode` varchar(40) DEFAULT NULL,
  `businessRuleName` varchar(200) DEFAULT NULL,
  `endTime` datetime DEFAULT NULL,
  `flowInstanceId` varchar(120) DEFAULT NULL,
  `originator` varchar(40) DEFAULT NULL,
  `schemaCode` varchar(40) DEFAULT NULL,
  `startTime` datetime DEFAULT NULL,
  `success` bit(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE IF NOT EXISTS `h_log_business_rule_content` (
  `id` varchar(120) NOT NULL,
  `exceptionContent` longtext,
  `exceptionNodeCode` varchar(120) DEFAULT NULL,
  `exceptionNodeName` varchar(200) DEFAULT NULL,
  `flowInstanceId` varchar(120) DEFAULT NULL,
  `triggerCoreData` longtext,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE IF NOT EXISTS `h_log_business_rule_node` (
  `id` varchar(120) NOT NULL,
  `endTime` datetime DEFAULT NULL,
  `flowInstanceId` varchar(120) DEFAULT NULL,
  `nodeCode` varchar(120) DEFAULT NULL,
  `nodeInstanceId` varchar(120) DEFAULT NULL,
  `nodeName` varchar(200) DEFAULT NULL,
  `nodeSequence` int(11) DEFAULT NULL,
  `startTime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE IF NOT EXISTS `h_log_business_rule_data_trace` (
  `id` varchar(120) NOT NULL,
  `flowInstanceId` varchar(120) DEFAULT NULL,
  `nodeCode` varchar(120) DEFAULT NULL,
  `nodeInstanceId` varchar(120) DEFAULT NULL,
  `nodeName` varchar(200) DEFAULT NULL,
  `ruleTriggerActionType` varchar(40) DEFAULT NULL,
  `targetObjectId` varchar(120) DEFAULT NULL,
  `targetSchemaCode` varchar(40) DEFAULT NULL,
  `traceLastData` longtext,
  `traceSetData` longtext,
  `traceUpdateDetail` longtext,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



ALTER TABLE `h_im_message` ADD COLUMN `externalLink` bit(1) DEFAULT NULL COMMENT '是否是外部链接';
ALTER TABLE `h_im_message_history` ADD COLUMN `externalLink` bit(1) DEFAULT NULL COMMENT '是否是外部链接';

ALTER TABLE `h_biz_schema` ADD COLUMN `businessRuleEnable` bit(1) DEFAULT 0;

ALTER TABLE `h_business_rule`
MODIFY COLUMN `node`  longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL AFTER `modifier`;


ALTER TABLE `h_workflow_header` ADD COLUMN `externalLinkEnable` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否开启外链';
ALTER TABLE `h_workflow_header` ADD COLUMN `shortCode` varchar(50) DEFAULT NULL COMMENT '外链短码';
ALTER TABLE `h_log_business_rule_content`
    MODIFY COLUMN `triggerCoreData` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL AFTER `flowInstanceId`;


ALTER TABLE `h_log_business_rule_data_trace`
    MODIFY COLUMN `traceLastData` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL AFTER `targetSchemaCode`,
    MODIFY COLUMN `traceSetData` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL AFTER `traceLastData`,
    MODIFY COLUMN `traceUpdateDetail` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_german2_ci NULL AFTER `traceSetData`;


ALTER TABLE `h_log_business_rule_header`
    ADD INDEX `idx_h_log_business_rule_header_flowInstanceId` (`flowInstanceId`) USING BTREE ;

ALTER TABLE `h_log_business_rule_content`
    ADD INDEX `idx_h_log_business_rule_content_flowInstanceId` (`flowInstanceId`) USING BTREE ;

ALTER TABLE `h_log_business_rule_node`
    ADD INDEX `idx_h_log_business_rule_node_flowInstanceId` (`flowInstanceId`) USING BTREE ;

ALTER TABLE `h_log_business_rule_data_trace`
    ADD INDEX `idx_h_log_business_rule_data_trace_flowInstanceId` (`flowInstanceId`) USING BTREE ;

UPDATE h_biz_schema SET `businessRuleEnable`=0 WHERE 1=1;

ALTER TABLE `h_perm_admin`
    ADD COLUMN `parentId` varchar(120) COLLATE utf8_bin NULL COMMENT '基于哪个创建的' AFTER `userId`;

ALTER TABLE `h_perm_department_scope`
    MODIFY COLUMN `name`  varchar(200) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL AFTER `adminId`;

ALTER TABLE `biz_workflow_instance` ADD COLUMN `schemaCode` varchar(40) DEFAULT NULL COMMENT '模型编码';

-- 冗余schemaCode
update biz_workflow_instance w SET w.schemaCode = (
    SELECT t.schemaCode FROM h_workflow_header t WHERE w.workflowCode=t.workflowCode
);
UPDATE h_biz_schema SET `businessRuleEnable`=1;

ALTER TABLE `h_business_rule`
    MODIFY COLUMN `id` varchar(120) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL FIRST,
    MODIFY COLUMN `creater` varchar(120) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL AFTER `createdTime`,
    MODIFY COLUMN `modifier` varchar(120) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL AFTER `modifiedTime`,
    MODIFY COLUMN `bizRuleType` varchar(15) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL AFTER `schedulerSetting`,
    MODIFY COLUMN `code` varchar(40) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL AFTER `defaultRule`,
    MODIFY COLUMN `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL AFTER `code`,
    MODIFY COLUMN `schemaCode` varchar(40) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL AFTER `name`,
    MODIFY COLUMN `remarks` varchar(200) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL AFTER `schemaCode`;

ALTER TABLE `h_log_business_rule_header`
    MODIFY COLUMN `schemaCode` varchar(40) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL AFTER `originator`,
    ADD COLUMN `sourceFlowInstanceId` varchar(120) NULL AFTER `success`,
    ADD COLUMN `repair` bit(1) NULL DEFAULT NULL AFTER `sourceFlowInstanceId`,
    ADD COLUMN `extend` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL AFTER `repair`;

-- 数据库没有数据可以不用执行存储过程
DROP PROCEDURE IF EXISTS addDefaultBusinessRule;
DELIMITER //
CREATE PROCEDURE addDefaultBusinessRule()
BEGIN
    DECLARE stopflag INT DEFAULT 0;
    DECLARE tempSchemaCode VARCHAR(400) DEFAULT NULL;
    DECLARE businessRuleCount INT DEFAULT 0;
    DECLARE schemaCode_cur CURSOR FOR SELECT `code` FROM h_biz_schema WHERE `code` IN (SELECT `code` FROM `h_app_function`);
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET stopflag=1;
    OPEN schemaCode_cur;

    cursor_loop:LOOP
    FETCH schemaCode_cur into tempSchemaCode;
    IF stopflag =1 THEN
    LEAVE cursor_loop;
    ELSE
    SELECT COUNT(*) INTO businessRuleCount FROM `h_business_rule` WHERE `schemaCode`=tempSchemaCode AND `code`='Create';
    IF businessRuleCount<1 THEN
    INSERT IGNORE INTO `h_business_rule`(`id`, `createdTime`, `creater`, `deleted`, `modifiedTime`, `modifier`, `node`, `route`, `schedulerSetting`, `bizRuleType`, `defaultRule`, `code`, `name`, `schemaCode`, `remarks`) VALUES (REPLACE(UUID(),"-",""), '2020-05-07 19:49:00', NULL, 0, '2020-05-07 19:49:00', NULL, '[{\"height\":40,\"logic\":false,\"nodeCode\":\"Start\",\"nodeName\":\"开始\",\"nodeType\":\"START\",\"width\":158,\"x\":327,\"y\":36},{\"height\":40,\"logic\":false,\"nodeCode\":\"End\",\"nodeName\":\"结束\",\"nodeType\":\"END\",\"width\":158,\"x\":327,\"y\":196},{\"height\":40,\"logic\":false,\"nodeCode\":\"Create\",\"nodeName\":\"新增数据\",\"nodeType\":\"SYSTEM_CREATE\",\"width\":158,\"x\":327,\"y\":116}]', '[{\"points\":[\"406, 76\",\"406, 116\"],\"postNode\":\"Create\",\"preNode\":\"Start\",\"routeCondition\":true},{\"points\":[\"406, 156\",\"406, 196\"],\"postNode\":\"End\",\"preNode\":\"Create\",\"routeCondition\":true}]', NULL, 'DATA_OP', 1, 'Create', '新增', tempSchemaCode, NULL);
END IF;

SELECT COUNT(*) INTO businessRuleCount FROM `h_business_rule` WHERE `schemaCode`=tempSchemaCode AND `code`='Update';
IF businessRuleCount<1 THEN
INSERT IGNORE INTO `h_business_rule`(`id`, `createdTime`, `creater`, `deleted`, `modifiedTime`, `modifier`, `node`, `route`, `schedulerSetting`, `bizRuleType`, `defaultRule`, `code`, `name`, `schemaCode`, `remarks`) VALUES (REPLACE(UUID(),"-",""), '2020-05-07 19:49:00', NULL, 0, '2020-05-07 19:49:00', NULL, '[{\"height\":40,\"logic\":false,\"nodeCode\":\"Start\",\"nodeName\":\"开始\",\"nodeType\":\"START\",\"width\":158,\"x\":327,\"y\":36},{\"height\":40,\"logic\":false,\"nodeCode\":\"End\",\"nodeName\":\"结束\",\"nodeType\":\"END\",\"width\":158,\"x\":327,\"y\":196},{\"height\":40,\"logic\":false,\"nodeCode\":\"Update\",\"nodeName\":\"更新数据\",\"nodeType\":\"SYSTEM_UPDATE\",\"width\":158,\"x\":327,\"y\":116}]', '[{\"points\":[\"406, 76\",\"406, 116\"],\"postNode\":\"Update\",\"preNode\":\"Start\",\"routeCondition\":true},{\"points\":[\"406, 156\",\"406, 196\"],\"postNode\":\"End\",\"preNode\":\"Update\",\"routeCondition\":true}]', NULL, 'DATA_OP', 1, 'Update', '更新', tempSchemaCode, NULL);
END IF;

SELECT COUNT(*) INTO businessRuleCount FROM `h_business_rule` WHERE `schemaCode`=tempSchemaCode AND `code`='Delete';
IF businessRuleCount<1 THEN
INSERT IGNORE INTO `h_business_rule`(`id`, `createdTime`, `creater`, `deleted`, `modifiedTime`, `modifier`, `node`, `route`, `schedulerSetting`, `bizRuleType`, `defaultRule`, `code`, `name`, `schemaCode`, `remarks`) VALUES (REPLACE(UUID(),"-",""), '2020-05-07 19:49:00', NULL, 0, '2020-05-07 19:49:00', NULL, '[{\"height\":40,\"logic\":false,\"nodeCode\":\"Start\",\"nodeName\":\"开始\",\"nodeType\":\"START\",\"width\":158,\"x\":327,\"y\":36},{\"height\":40,\"logic\":false,\"nodeCode\":\"End\",\"nodeName\":\"结束\",\"nodeType\":\"END\",\"width\":158,\"x\":327,\"y\":196},{\"height\":40,\"logic\":false,\"nodeCode\":\"Delete\",\"nodeName\":\"删除数据\",\"nodeType\":\"SYSTEM_DELETE\",\"width\":158,\"x\":327,\"y\":116}]', '[{\"points\":[\"406, 76\",\"406, 116\"],\"postNode\":\"Delete\",\"preNode\":\"Start\",\"routeCondition\":true},{\"points\":[\"406, 156\",\"406, 196\"],\"postNode\":\"End\",\"preNode\":\"Delete\",\"routeCondition\":true}]', NULL, 'DATA_OP', 1, 'Delete', '删除', tempSchemaCode, NULL);
END IF;

SELECT COUNT(*) INTO businessRuleCount FROM `h_business_rule` WHERE `schemaCode`=tempSchemaCode AND `code`='Load';
IF businessRuleCount<1 THEN
INSERT IGNORE INTO `h_business_rule`(`id`, `createdTime`, `creater`, `deleted`, `modifiedTime`, `modifier`, `node`, `route`, `schedulerSetting`, `bizRuleType`, `defaultRule`, `code`, `name`, `schemaCode`, `remarks`) VALUES (REPLACE(UUID(),"-",""), '2020-05-07 19:49:00', NULL, 0, '2020-05-07 19:49:00', NULL, '[{\"height\":40,\"logic\":false,\"nodeCode\":\"Start\",\"nodeName\":\"开始\",\"nodeType\":\"START\",\"width\":158,\"x\":327,\"y\":36},{\"height\":40,\"logic\":false,\"nodeCode\":\"End\",\"nodeName\":\"结束\",\"nodeType\":\"END\",\"width\":158,\"x\":327,\"y\":196}]', '[{\"points\":[\"406, 76\",\"406, 196\"],\"postNode\":\"End\",\"preNode\":\"Start\",\"routeCondition\":true}]', NULL, 'DATA_OP', 1, 'Load', '查询', tempSchemaCode, NULL);
END IF;

SELECT COUNT(*) INTO businessRuleCount FROM `h_business_rule` WHERE `schemaCode`=tempSchemaCode AND `code`='GetList';
IF businessRuleCount<1 THEN
INSERT IGNORE INTO `h_business_rule`(`id`, `createdTime`, `creater`, `deleted`, `modifiedTime`, `modifier`, `node`, `route`, `schedulerSetting`, `bizRuleType`, `defaultRule`, `code`, `name`, `schemaCode`, `remarks`) VALUES (REPLACE(UUID(),"-",""), '2020-05-07 19:49:00', NULL, 0, '2020-05-07 19:49:00', NULL, '[{\"height\":40,\"logic\":false,\"nodeCode\":\"Start\",\"nodeName\":\"开始\",\"nodeType\":\"START\",\"width\":158,\"x\":327,\"y\":36},{\"height\":40,\"logic\":false,\"nodeCode\":\"End\",\"nodeName\":\"结束\",\"nodeType\":\"END\",\"width\":158,\"x\":327,\"y\":196},{\"dataSourceType\":\"GET_LIST\",\"height\":40,\"logic\":false,\"methodMapping\":null,\"nodeCode\":\"GetList\",\"nodeName\":\"获取集合数据\",\"nodeType\":\"GET_LIST\",\"width\":158,\"x\":327,\"y\":116}]', '[{\"points\":[\"406, 76\",\"406, 116\"],\"postNode\":\"GetList\",\"preNode\":\"Start\",\"routeCondition\":true},{\"points\":[\"406, 156\",\"406, 196\"],\"postNode\":\"End\",\"preNode\":\"GetList\",\"routeCondition\":true}]', NULL, 'GET_LIST', 1, 'GetList', '获取列表', tempSchemaCode, NULL);
END IF;

SELECT COUNT(*) INTO businessRuleCount FROM `h_business_rule` WHERE `schemaCode`=tempSchemaCode AND `code`='Cancel';
IF businessRuleCount<1 THEN
INSERT IGNORE INTO `h_business_rule`(`id`, `createdTime`, `creater`, `deleted`, `modifiedTime`, `modifier`, `node`, `route`, `schedulerSetting`, `bizRuleType`, `defaultRule`, `code`, `name`, `schemaCode`, `remarks`) VALUES (REPLACE(UUID(),"-",""), '2020-05-07 19:49:00', NULL, 0, '2020-05-07 19:49:00', NULL, '[{\"height\":40,\"logic\":false,\"nodeCode\":\"Start\",\"nodeName\":\"开始\",\"nodeType\":\"START\",\"width\":158,\"x\":327,\"y\":36},{\"height\":40,\"logic\":false,\"nodeCode\":\"End\",\"nodeName\":\"结束\",\"nodeType\":\"END\",\"width\":158,\"x\":327,\"y\":196}]', '[{\"points\":[\"406, 76\",\"406, 196\"],\"postNode\":\"End\",\"preNode\":\"Start\",\"routeCondition\":true}]', NULL, 'DATA_OP', 1, 'Cancel', '流程作废', tempSchemaCode, NULL);
END IF;

SELECT COUNT(*) INTO businessRuleCount FROM `h_business_rule` WHERE `schemaCode`=tempSchemaCode AND `code`='Available';
IF businessRuleCount<1 THEN
INSERT IGNORE INTO `h_business_rule`(`id`, `createdTime`, `creater`, `deleted`, `modifiedTime`, `modifier`, `node`, `route`, `schedulerSetting`, `bizRuleType`, `defaultRule`, `code`, `name`, `schemaCode`, `remarks`) VALUES (REPLACE(UUID(),"-",""), '2020-05-07 19:49:00', NULL, 0, '2020-05-07 19:49:00', NULL, '[{\"height\":40,\"logic\":false,\"nodeCode\":\"Start\",\"nodeName\":\"开始\",\"nodeType\":\"START\",\"width\":158,\"x\":327,\"y\":36},{\"height\":40,\"logic\":false,\"nodeCode\":\"End\",\"nodeName\":\"结束\",\"nodeType\":\"END\",\"width\":158,\"x\":327,\"y\":196}]', '[{\"points\":[\"406, 76\",\"406, 196\"],\"postNode\":\"End\",\"preNode\":\"Start\",\"routeCondition\":true}]', NULL, 'DATA_OP', 1, 'Available', '流程生效', tempSchemaCode, NULL);
END IF;

END IF;
END LOOP cursor_loop;
CLOSE schemaCode_cur;
END;
//
DELIMITER ;

CALL addDefaultBusinessRule();

