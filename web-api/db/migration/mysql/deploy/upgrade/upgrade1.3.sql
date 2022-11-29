/*
Navicat MySQL Data Transfer

Source Server         : dev_back_120.79.187.180
Source Server Version : 50724
Source Host           : 120.79.187.180:3306
Source Database       : h3bpm_dev

Target Server Type    : MYSQL
Target Server Version : 50724
File Encoding         : 65001

Date: 2019-04-17 16:21:26
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for base_security_client
-- ----------------------------
CREATE TABLE IF NOT EXISTS `base_security_client` (
  `id` varchar(120) NOT NULL,
  `createdTime` datetime DEFAULT NULL,
  `creater` varchar(120) DEFAULT NULL,
  `deleted` bit(1) DEFAULT NULL,
  `extend1` varchar(255) DEFAULT NULL,
  `extend2` varchar(255) DEFAULT NULL,
  `extend3` varchar(255) DEFAULT NULL,
  `extend4` int(11) DEFAULT NULL,
  `extend5` int(11) DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `modifier` varchar(120) DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `accessTokenValiditySeconds` int(11) NOT NULL,
  `additionInformation` varchar(255) DEFAULT NULL,
  `authorities` varchar(255) DEFAULT NULL,
  `authorizedGrantTypes` varchar(255) DEFAULT NULL,
  `autoApproveScopes` varchar(255) DEFAULT NULL,
  `clientId` varchar(100) DEFAULT NULL,
  `clientSecret` varchar(100) DEFAULT NULL,
  `refreshTokenValiditySeconds` int(11) NOT NULL,
  `registeredRedirectUris` varchar(255) DEFAULT NULL,
  `resourceIds` varchar(255) DEFAULT NULL,
  `scopes` varchar(255) DEFAULT NULL,
  `type` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for biz_circulateitem
-- ----------------------------
CREATE TABLE IF NOT EXISTS `biz_circulateitem` (
  `id` varchar(36) NOT NULL,
  `finishTime` datetime DEFAULT NULL,
  `receiveTime` datetime DEFAULT NULL,
  `startTime` datetime DEFAULT NULL,
  `state` varchar(20) DEFAULT NULL,
  `activityCode` varchar(200) DEFAULT NULL,
  `activityCodeName` varchar(200) DEFAULT NULL,
  `instanceId` varchar(36) DEFAULT NULL,
  `instanceName` varchar(200) DEFAULT NULL,
  `originator` varchar(200) DEFAULT NULL,
  `originatorName` varchar(200) DEFAULT NULL,
  `participant` varchar(200) DEFAULT NULL,
  `participantName` varchar(200) DEFAULT NULL,
  `sheetCode` varchar(200) DEFAULT NULL,
  `sourceId` varchar(200) DEFAULT NULL,
  `sourceName` varchar(200) DEFAULT NULL,
  `workflowCode` varchar(36) DEFAULT NULL,
  `workflowVersion` int(11) DEFAULT NULL,
  `activityName` varchar(200) DEFAULT NULL,
  `departmentId` varchar(200) DEFAULT NULL,
  `departmentName` varchar(200) DEFAULT NULL,
  `workItemType` varchar(20) DEFAULT NULL,
  `workflowTokenId` varchar(200) DEFAULT NULL,
  `stateValue` int(11) DEFAULT NULL,
  `workItemTypeValue` int(11) DEFAULT NULL,
  `expireTime1` datetime DEFAULT NULL,
  `expireTime2` datetime DEFAULT NULL,
  `appCode` varchar(200) DEFAULT NULL,
  `allowedTime` datetime DEFAULT NULL,
  `timeoutWarn1` datetime DEFAULT NULL,
  `timeoutWarn2` datetime DEFAULT NULL,
  `timeoutStrategy` varchar(20) DEFAULT NULL,
  `usedtime` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_multi` (`instanceId`,`activityCode`,`workflowTokenId`,`participant`),
  KEY `idx_workflowTokenId` (`workflowTokenId`),
  KEY `idx_sourceIdAndType` (`sourceId`,`workItemType`),
  KEY `idx_participant` (`participant`),
  KEY `idx_startTime` (`startTime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for biz_circulateitem_finished
-- ----------------------------
CREATE TABLE IF NOT EXISTS `biz_circulateitem_finished` (
  `finishTime` datetime DEFAULT NULL,
  `receiveTime` datetime DEFAULT NULL,
  `startTime` datetime DEFAULT NULL,
  `state` varchar(20) DEFAULT NULL,
  `activityCode` varchar(200) DEFAULT NULL,
  `delegant` varchar(200) DEFAULT NULL,
  `instanceId` varchar(36) DEFAULT NULL,
  `originator` varchar(200) DEFAULT NULL,
  `participant` varchar(200) DEFAULT NULL,
  `sheetCode` varchar(200) DEFAULT NULL,
  `sourceWorkItemId` varchar(200) DEFAULT NULL,
  `workflowCode` varchar(36) DEFAULT NULL,
  `workflowVersion` int(11) DEFAULT NULL,
  `id` varchar(36) NOT NULL,
  `activityName` varchar(200) DEFAULT NULL,
  `departmentId` varchar(200) DEFAULT NULL,
  `departmentName` varchar(200) DEFAULT NULL,
  `instanceName` varchar(200) DEFAULT NULL,
  `originatorName` varchar(200) DEFAULT NULL,
  `participantName` varchar(200) DEFAULT NULL,
  `sourceId` varchar(200) DEFAULT NULL,
  `sourceName` varchar(200) DEFAULT NULL,
  `workItemType` varchar(20) DEFAULT NULL,
  `workflowTokenId` varchar(200) DEFAULT NULL,
  `stateValue` int(11) DEFAULT NULL,
  `workItemTypeValue` int(11) DEFAULT NULL,
  `expireTime1` datetime DEFAULT NULL,
  `expireTime2` datetime DEFAULT NULL,
  `appCode` varchar(200) DEFAULT NULL,
  `allowedTime` datetime DEFAULT NULL,
  `timeoutWarn1` datetime DEFAULT NULL,
  `timeoutWarn2` datetime DEFAULT NULL,
  `timeoutStrategy` varchar(20) DEFAULT NULL,
  `usedtime` bigint(20) DEFAULT NULL,
  KEY `idx_multi` (`instanceId`,`activityCode`,`workflowTokenId`,`participant`),
  KEY `idx_workflowTokenId` (`workflowTokenId`),
  KEY `idx_sourceIdAndType` (`sourceId`,`workItemType`),
  KEY `idx_participant` (`participant`),
  KEY `idx_finishTime` (`finishTime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for biz_workflow_instance
-- ----------------------------
CREATE TABLE IF NOT EXISTS `biz_workflow_instance` (
  `id` varchar(36) NOT NULL COMMENT '流程实例表ID',
  `bizObjectId` varchar(36) DEFAULT NULL COMMENT '业务类ID',
  `instanceName` varchar(200) DEFAULT NULL COMMENT '流程实例名称',
  `workflowCode` varchar(200) DEFAULT NULL COMMENT '流程模板编码',
  `workflowVersion` int(11) DEFAULT NULL COMMENT '流程模板版本号',
  `originator` varchar(200) DEFAULT NULL COMMENT '发起人',
  `departmentId` varchar(200) DEFAULT NULL COMMENT '发起人所在的部门',
  `participant` varchar(200) DEFAULT NULL COMMENT '任务参与人',
  `state` varchar(200) DEFAULT NULL COMMENT '流程实例状态',
  `receiveTime` datetime DEFAULT NULL COMMENT '工作任务接收时间',
  `startTime` datetime DEFAULT NULL COMMENT '工作任务开始时间',
  `finishTime` datetime DEFAULT NULL COMMENT '工作任务完成时间',
  `usedTime` bigint(20) DEFAULT NULL COMMENT '工作任务耗时(自然时间)',
  `waitTime` bigint(20) DEFAULT NULL COMMENT '等待时间',
  `remark` varchar(200) DEFAULT NULL COMMENT '备注信息',
  `departmentName` varchar(200) DEFAULT NULL,
  `originatorName` varchar(200) DEFAULT NULL,
  `parentId` varchar(36) DEFAULT NULL,
  `stateValue` int(11) DEFAULT NULL,
  `workflowTokenId` varchar(36) DEFAULT NULL,
  `appCode` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_state` (`state`),
  KEY `idx_bwi_originator` (`originator`),
  KEY `idx_bwi_workflowCode` (`workflowCode`),
  KEY `idx_bwi_startTime` (`startTime`),
  KEY `idx_bwi_originator_state_starttime` (`originator`,`state`,`startTime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='流程实例表';

-- ----------------------------
-- Table structure for biz_workflow_token
-- ----------------------------
CREATE TABLE IF NOT EXISTS `biz_workflow_token` (
  `id` varchar(36) NOT NULL,
  `finishTime` datetime DEFAULT NULL,
  `receiveTime` datetime DEFAULT NULL,
  `startTime` datetime DEFAULT NULL,
  `state` varchar(20) DEFAULT NULL,
  `activityCode` varchar(200) DEFAULT NULL,
  `approvalCount` int(11) DEFAULT NULL,
  `disapprovalCount` int(11) DEFAULT NULL,
  `exceptional` varchar(20) DEFAULT NULL,
  `instanceId` varchar(36) DEFAULT NULL,
  `itemCount` int(11) DEFAULT NULL,
  `tokenId` int(11) DEFAULT NULL,
  `usedtime` bigint(20) DEFAULT NULL,
  `sourceActivityCode` varchar(200) DEFAULT NULL,
  `isRetrievable` int(11) DEFAULT NULL,
  `stateValue` int(11) DEFAULT NULL,
  `parentId` varchar(36) DEFAULT NULL,
  `isRejectBack` varchar(10) DEFAULT NULL,
  `activityType` varchar(20) DEFAULT NULL,
  `instanceState` varchar(20) DEFAULT NULL,
  `approvalExit` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_instanceId` (`instanceId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for biz_workitem
-- ----------------------------
CREATE TABLE IF NOT EXISTS `biz_workitem` (
  `id` varchar(36) NOT NULL COMMENT '待办表id',
  `workflowCode` varchar(200) DEFAULT NULL COMMENT '流程模板编码',
  `workflowVersion` int(11) DEFAULT NULL COMMENT '流程模板版本',
  `originator` varchar(200) DEFAULT NULL COMMENT '流程实例发起人',
  `participant` varchar(200) DEFAULT NULL COMMENT '参与者',
  `approval` varchar(200) DEFAULT NULL COMMENT '当前工作任务审批结果',
  `sheetCode` varchar(200) DEFAULT NULL COMMENT '表单编码',
  `instanceId` varchar(36) DEFAULT NULL COMMENT '流程实例ID',
  `startTime` datetime DEFAULT NULL COMMENT '流程开始时间',
  `finishTime` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '流程结束时间',
  `state` varchar(36) DEFAULT NULL COMMENT '工作任务状态',
  `receiveTime` datetime DEFAULT NULL COMMENT '处理时间',
  `activityCode` varchar(200) DEFAULT NULL COMMENT '活动节点编码',
  `usedTime` bigint(20) DEFAULT NULL COMMENT '工作任务耗时(自然时间)',
  `remark` varchar(200) DEFAULT NULL COMMENT '备注信息',
  `ownerId` varchar(200) DEFAULT '' COMMENT '接收人',
  `activityName` varchar(200) DEFAULT NULL,
  `departmentId` varchar(200) DEFAULT NULL,
  `departmentName` varchar(200) DEFAULT NULL,
  `instanceName` varchar(200) DEFAULT NULL,
  `originatorName` varchar(200) DEFAULT NULL,
  `participantName` varchar(200) DEFAULT NULL,
  `sourceId` varchar(200) DEFAULT NULL,
  `sourceName` varchar(200) DEFAULT NULL,
  `workItemType` varchar(20) DEFAULT NULL,
  `workflowTokenId` varchar(200) DEFAULT NULL,
  `stateValue` int(11) DEFAULT NULL,
  `workItemTypeValue` int(11) DEFAULT NULL,
  `approvalValue` int(11) DEFAULT NULL,
  `expireTime1` datetime DEFAULT NULL,
  `expireTime2` datetime DEFAULT NULL,
  `appCode` varchar(200) DEFAULT NULL,
  `allowedTime` datetime DEFAULT NULL,
  `timeoutWarn1` datetime DEFAULT NULL,
  `timeoutWarn2` datetime DEFAULT NULL,
  `timeoutStrategy` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `I_ReceiveTime` (`receiveTime`),
  KEY `idx_multi` (`instanceId`,`activityCode`,`workflowTokenId`,`participant`),
  KEY `idx_workflowTokenId` (`workflowTokenId`),
  KEY `idx_sourceIdAndType` (`sourceId`,`workItemType`),
  KEY `idx_participant` (`participant`),
  KEY `idx_startTime` (`startTime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='待办任务表';

-- ----------------------------
-- Table structure for biz_workitem_finished
-- ----------------------------
CREATE TABLE IF NOT EXISTS `biz_workitem_finished` (
  `id` varchar(36) NOT NULL COMMENT '已办表id',
  `workflowCode` varchar(200) DEFAULT NULL COMMENT '流程模板编码',
  `workflowVersion` int(11) DEFAULT NULL COMMENT '流程模板版本',
  `originator` varchar(200) DEFAULT NULL COMMENT '流程实例发起人',
  `participant` varchar(200) DEFAULT NULL COMMENT '参与者',
  `approval` varchar(200) DEFAULT NULL COMMENT '当前工作任务审批结果',
  `sheetCode` varchar(200) DEFAULT NULL COMMENT '表单编码',
  `instanceId` varchar(36) DEFAULT NULL COMMENT '流程实例ID',
  `startTime` datetime DEFAULT NULL COMMENT '流程开始时间',
  `finishTime` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '流程结束时间',
  `state` varchar(36) DEFAULT NULL COMMENT '工作任务状态',
  `receiveTime` datetime DEFAULT NULL COMMENT '处理时间',
  `activityCode` varchar(200) DEFAULT NULL COMMENT '活动节点编码',
  `usedTime` bigint(20) DEFAULT NULL COMMENT '工作任务耗时(自然时间)',
  `remark` varchar(200) DEFAULT NULL COMMENT '备注信息',
  `ownerId` varchar(200) DEFAULT '' COMMENT '接收人',
  `activityName` varchar(200) DEFAULT NULL,
  `departmentId` varchar(200) DEFAULT NULL,
  `departmentName` varchar(200) DEFAULT NULL,
  `instanceName` varchar(200) DEFAULT NULL,
  `originatorName` varchar(200) DEFAULT NULL,
  `participantName` varchar(200) DEFAULT NULL,
  `sourceId` varchar(200) DEFAULT NULL,
  `sourceName` varchar(200) DEFAULT NULL,
  `workItemType` varchar(20) DEFAULT NULL,
  `workflowTokenId` varchar(200) DEFAULT NULL,
  `stateValue` int(11) DEFAULT NULL,
  `workItemTypeValue` int(11) DEFAULT NULL,
  `approvalValue` int(11) DEFAULT NULL,
  `expireTime1` datetime DEFAULT NULL,
  `expireTime2` datetime DEFAULT NULL,
  `appCode` varchar(200) DEFAULT NULL,
  `allowedTime` datetime DEFAULT NULL,
  `timeoutWarn1` datetime DEFAULT NULL,
  `timeoutWarn2` datetime DEFAULT NULL,
  `timeoutStrategy` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `I_ReceiveTime` (`receiveTime`),
  KEY `idx_multi` (`instanceId`,`activityCode`,`workflowTokenId`,`participant`),
  KEY `idx_workflowTokenId` (`workflowTokenId`),
  KEY `idx_sourceIdAndType` (`sourceId`,`workItemType`),
  KEY `idx_participant` (`participant`),
  KEY `idx_finishTime` (`finishTime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='已办任务表';

-- ----------------------------
-- Table structure for h_app_function
-- ----------------------------
CREATE TABLE IF NOT EXISTS `h_app_function` (
  `id` varchar(120) NOT NULL,
  `createdTime` datetime DEFAULT NULL,
  `creater` varchar(120) DEFAULT NULL,
  `deleted` bit(1) DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `modifier` varchar(120) DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `appCode` varchar(40) DEFAULT NULL,
  `code` varchar(40) DEFAULT NULL,
  `icon` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `parentId` varchar(36) DEFAULT NULL,
  `sortKey` int(11) DEFAULT NULL,
  `type` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_hs5vdc0sdojwxfkv685ch9bqb` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for h_app_package
-- ----------------------------
CREATE TABLE IF NOT EXISTS `h_app_package` (
  `id` varchar(120) NOT NULL,
  `createdTime` datetime DEFAULT NULL,
  `creater` varchar(120) DEFAULT NULL,
  `deleted` bit(1) DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `modifier` varchar(120) DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `code` varchar(40) DEFAULT NULL,
  `disabled` bit(1) DEFAULT NULL,
  `logoUrlId` varchar(36) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `sortKey` int(11) DEFAULT NULL,
  `published` bit(1) DEFAULT NULL,
  `agentId` varchar(40) DEFAULT NULL,
  `logoUrl` varchar(200) DEFAULT NULL,
  `appKey` varchar(200) DEFAULT NULL,
  `appSecret` varchar(200) DEFAULT NULL,
  `enabled` bit(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for h_biz_attachment
-- ----------------------------
CREATE TABLE IF NOT EXISTS `h_biz_attachment` (
  `id` varchar(120) NOT NULL,
  `bizObjectId` varchar(36) NOT NULL,
  `bizPropertyCode` varchar(40) NOT NULL,
  `createdTime` datetime DEFAULT NULL,
  `creater` varchar(36) DEFAULT NULL,
  `fileExtension` varchar(30) DEFAULT NULL,
  `fileSize` int(11) DEFAULT NULL,
  `mimeType` varchar(50) DEFAULT NULL,
  `name` varchar(200) DEFAULT NULL,
  `parentBizObjectId` varchar(36) DEFAULT NULL,
  `parentSchemaCode` varchar(36) DEFAULT NULL,
  `refId` varchar(500) NOT NULL,
  `schemaCode` varchar(36) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_biz_attachment_schema_object_property` (`schemaCode`,`bizObjectId`,`bizPropertyCode`,`createdTime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for h_biz_comment
-- ----------------------------
CREATE TABLE IF NOT EXISTS `h_biz_comment` (
  `id` varchar(120) NOT NULL,
  `actionType` varchar(40) NOT NULL,
  `activityCode` varchar(40) DEFAULT NULL,
  `activityName` varchar(40) DEFAULT NULL,
  `bizObjectId` varchar(36) NOT NULL,
  `bizPropertyCode` varchar(40) DEFAULT NULL,
  `content` varchar(4000) DEFAULT NULL,
  `createdTime` datetime DEFAULT NULL,
  `creater` varchar(36) DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `modifier` varchar(36) DEFAULT NULL,
  `relUsers` varchar(2000) DEFAULT NULL,
  `result` varchar(40) DEFAULT NULL,
  `schemaCode` varchar(40) NOT NULL,
  `workItemId` varchar(36) NOT NULL,
  `workflowInstanceId` varchar(36) NOT NULL,
  `workflowTokenId` varchar(36) NOT NULL,
  `tokenId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_biz_comment_workflowInstanceId` (`workflowInstanceId`),
  KEY `idx_biz_comment_workItemId_actionType` (`workItemId`,`actionType`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for h_biz_method
-- ----------------------------
CREATE TABLE IF NOT EXISTS `h_biz_method` (
  `id` varchar(120) NOT NULL,
  `creater` varchar(120) DEFAULT NULL,
  `createdTime` datetime DEFAULT NULL,
  `deleted` bit(1) DEFAULT NULL,
  `modifier` varchar(120) DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `code` varchar(40) DEFAULT NULL,
  `defaultMethod` bit(1) DEFAULT NULL,
  `description` longtext,
  `methodType` varchar(40) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `schemaCode` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for h_biz_method_mapping
-- ----------------------------
CREATE TABLE IF NOT EXISTS `h_biz_method_mapping` (
  `id` varchar(120) NOT NULL,
  `createdTime` datetime DEFAULT NULL,
  `creater` varchar(120) DEFAULT NULL,
  `deleted` bit(1) DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `modifier` varchar(120) DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `bizMethodId` varchar(40) DEFAULT NULL,
  `inputMappingsJson` longtext,
  `methodCode` varchar(40) DEFAULT NULL,
  `outputMappingsJson` longtext,
  `schemaCode` varchar(40) DEFAULT NULL,
  `serviceCode` varchar(40) DEFAULT NULL,
  `serviceMethodCode` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for h_biz_property
-- ----------------------------
CREATE TABLE IF NOT EXISTS `h_biz_property` (
  `id` varchar(120) NOT NULL,
  `createdTime` datetime DEFAULT NULL,
  `creater` varchar(120) DEFAULT NULL,
  `deleted` bit(1) DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `modifier` varchar(120) DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `code` varchar(40) DEFAULT NULL,
  `defaultProperty` bit(1) DEFAULT NULL,
  `defaultValue` varchar(200) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `propertyEmpty` bit(1) DEFAULT NULL,
  `propertyIndex` bit(1) DEFAULT NULL,
  `propertyLength` int(11) DEFAULT NULL,
  `propertyType` varchar(40) DEFAULT NULL,
  `published` bit(1) DEFAULT NULL,
  `relativeCode` varchar(40) DEFAULT NULL,
  `schemaCode` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for h_biz_query
-- ----------------------------
CREATE TABLE IF NOT EXISTS `h_biz_query` (
  `id` varchar(120) NOT NULL,
  `createdTime` datetime DEFAULT NULL,
  `creater` varchar(120) DEFAULT NULL,
  `deleted` bit(1) DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `modifier` varchar(120) DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `code` varchar(40) DEFAULT NULL,
  `icon` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `schemaCode` varchar(40) DEFAULT NULL,
  `sortKey` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for h_biz_query_action
-- ----------------------------
CREATE TABLE IF NOT EXISTS `h_biz_query_action` (
  `id` varchar(120) NOT NULL,
  `createdTime` datetime DEFAULT NULL,
  `creater` varchar(120) DEFAULT NULL,
  `deleted` bit(1) DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `modifier` varchar(120) DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `actionCode` varchar(40) DEFAULT NULL,
  `associationCode` varchar(40) DEFAULT NULL,
  `associationType` varchar(40) DEFAULT NULL,
  `customService` bit(1) DEFAULT NULL,
  `icon` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `queryActionType` varchar(50) DEFAULT NULL,
  `queryId` varchar(36) DEFAULT NULL,
  `schemaCode` varchar(40) DEFAULT NULL,
  `serviceCode` varchar(40) DEFAULT NULL,
  `serviceMethod` varchar(40) DEFAULT NULL,
  `sortKey` int(11) DEFAULT NULL,
  `systemAction` bit(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for h_biz_query_column
-- ----------------------------
CREATE TABLE IF NOT EXISTS `h_biz_query_column` (
  `id` varchar(120) NOT NULL,
  `createdTime` datetime DEFAULT NULL,
  `creater` varchar(120) DEFAULT NULL,
  `deleted` bit(1) DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `modifier` varchar(120) DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `isSystem` bit(1) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `propertyCode` varchar(40) DEFAULT NULL,
  `propertyType` varchar(40) DEFAULT NULL,
  `queryId` varchar(36) DEFAULT NULL,
  `schemaCode` varchar(40) DEFAULT NULL,
  `sortKey` int(11) DEFAULT NULL,
  `sumType` varchar(40) DEFAULT NULL,
  `unit` int(11) DEFAULT NULL,
  `width` varchar(50) DEFAULT NULL,
  `displayFormat` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for h_biz_query_condition
-- ----------------------------
CREATE TABLE IF NOT EXISTS `h_biz_query_condition` (
  `id` varchar(120) NOT NULL,
  `createdTime` datetime DEFAULT NULL,
  `creater` varchar(120) DEFAULT NULL,
  `deleted` bit(1) DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `modifier` varchar(120) DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `choiceType` varchar(10) DEFAULT NULL,
  `dataStatus` varchar(40) DEFAULT NULL,
  `defaultState` int(11) DEFAULT NULL,
  `defaultValue` varchar(50) DEFAULT NULL,
  `displayType` varchar(10) DEFAULT NULL,
  `endValue` varchar(50) DEFAULT NULL,
  `isSystem`          bit(1)        DEFAULT NULL,
  `name`              varchar(50)   DEFAULT NULL,
  `options`           varchar(500)  DEFAULT NULL,
  `propertyCode`      varchar(40)   DEFAULT NULL,
  `propertyType`      varchar(40)   DEFAULT NULL,
  `queryId`           varchar(36)   DEFAULT NULL,
  `schemaCode`        varchar(40)   DEFAULT NULL,
  `sortKey`           int(11)       DEFAULT NULL,
  `startValue`        varchar(50)   DEFAULT NULL,
  `userOptionType`    varchar(10)   DEFAULT NULL,
  `visible`           bit(1)        DEFAULT NULL,
  `relativeQueryCode` varchar(40)   DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for h_biz_query_sorter
-- ----------------------------
CREATE TABLE IF NOT EXISTS `h_biz_query_sorter` (
  `id` varchar(120) NOT NULL,
  `createdTime` datetime DEFAULT NULL,
  `creater` varchar(120) DEFAULT NULL,
  `deleted` bit(1) DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `modifier` varchar(120) DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `direction` varchar(40) DEFAULT NULL,
  `isSystem` bit(1) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `propertyCode` varchar(40) DEFAULT NULL,
  `propertyType` varchar(40) DEFAULT NULL,
  `queryId` varchar(36) DEFAULT NULL,
  `schemaCode` varchar(40) DEFAULT NULL,
  `sortKey` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for h_biz_schema
-- ----------------------------
CREATE TABLE IF NOT EXISTS `h_biz_schema` (
  `id` varchar(120) NOT NULL,
  `createdTime` datetime DEFAULT NULL,
  `creater` varchar(120) DEFAULT NULL,
  `deleted` bit(1) DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `modifier` varchar(120) DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `code` varchar(40) DEFAULT NULL,
  `icon` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `published` bit(1) DEFAULT NULL,
  `summary` varchar(2000) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for h_biz_service
-- ----------------------------
CREATE TABLE IF NOT EXISTS `h_biz_service` (
  `id` varchar(120) NOT NULL,
  `createdTime` datetime DEFAULT NULL,
  `creater` varchar(120) DEFAULT NULL,
  `deleted` bit(1) DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `modifier` varchar(120) DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `code` varchar(40) DEFAULT NULL,
  `configJSON` longtext,
  `description` varchar(2000) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `serviceCategoryId` varchar(40) DEFAULT NULL,
  `adapterCode` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for h_biz_service_category
-- ----------------------------
CREATE TABLE IF NOT EXISTS `h_biz_service_category` (
  `id` varchar(120) NOT NULL,
  `createdTime` datetime DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for h_biz_service_method
-- ----------------------------
CREATE TABLE IF NOT EXISTS `h_biz_service_method` (
  `id` varchar(120) NOT NULL,
  `createdTime` datetime DEFAULT NULL,
  `creater` varchar(120) DEFAULT NULL,
  `deleted` bit(1) DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `modifier` varchar(120) DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `code` varchar(40) DEFAULT NULL,
  `configJSON` longtext,
  `description` varchar(2000) DEFAULT NULL,
  `inputParametersJson` longtext,
  `name` varchar(50) DEFAULT NULL,
  `outputParametersJson` longtext,
  `protocolAdapterType` varchar(40) DEFAULT NULL,
  `serviceCode` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for h_biz_sheet
-- ----------------------------
CREATE TABLE IF NOT EXISTS `h_biz_sheet` (
  `id` varchar(120) NOT NULL,
  `createdTime` datetime DEFAULT NULL,
  `creater` varchar(120) DEFAULT NULL,
  `deleted` bit(1) DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `modifier` varchar(120) DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `code` varchar(40) DEFAULT NULL,
  `draftAttributesJson` longtext,
  `draftViewJson` longtext,
  `icon` varchar(50) DEFAULT NULL,
  `mobileIsPc` bit(1) DEFAULT NULL,
  `mobileUrl` varchar(500) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `pcUrl` varchar(500) DEFAULT NULL,
  `printIsPc` bit(1) DEFAULT NULL,
  `printUrl` varchar(500) DEFAULT NULL,
  `published` bit(1) DEFAULT NULL,
  `publishedAttributesJson` longtext,
  `publishedViewJson` longtext,
  `schemaCode` varchar(40) DEFAULT NULL,
  `sheetType` varchar(50) DEFAULT NULL,
  `sortKey` int(11) DEFAULT NULL,
  `serialCode` varchar(255) DEFAULT NULL,
  `serialResetType` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for h_custom_page
-- ----------------------------
CREATE TABLE IF NOT EXISTS `h_custom_page` (
  `id` varchar(120) NOT NULL,
  `creater` varchar(120) DEFAULT NULL,
  `createdTime` datetime DEFAULT NULL,
  `deleted` bit(1) DEFAULT NULL,
  `modifier` varchar(120) DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `code` varchar(40) DEFAULT NULL,
  `icon` varchar(50) DEFAULT NULL,
  `mobileUrl` varchar(500) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `openMode` varchar(40) DEFAULT NULL,
  `pcUrl` varchar(500) DEFAULT NULL,
  `appCode` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for h_im_message
-- ----------------------------
CREATE TABLE IF NOT EXISTS `h_im_message` (
  `id` varchar(36) NOT NULL,
  `bizParams` longtext,
  `channel` varchar(40) DEFAULT NULL,
  `content` longtext,
  `createdTime` datetime DEFAULT NULL,
  `failRetry` bit(1) DEFAULT NULL,
  `failUserRetry` bit(1) DEFAULT NULL,
  `messageType` varchar(40) DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `receivers` longtext,
  `title` varchar(100) DEFAULT NULL,
  `tryTimes` int(11) DEFAULT NULL,
  `url` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_message_id` (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for h_im_message_history
-- ----------------------------
CREATE TABLE IF NOT EXISTS `h_im_message_history` (
  `id` varchar(36) NOT NULL,
  `bizParams` longtext,
  `channel` varchar(40) DEFAULT NULL,
  `content` longtext,
  `createdTime` datetime DEFAULT NULL,
  `failRetry` bit(1) DEFAULT NULL,
  `failUserRetry` bit(1) DEFAULT NULL,
  `messageType` varchar(40) DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `receivers` longtext,
  `title` varchar(100) DEFAULT NULL,
  `tryTimes` int(11) DEFAULT NULL,
  `url` varchar(500) DEFAULT NULL,
  `sendFailUserIds` longtext,
  `status` varchar(40) DEFAULT NULL,
  `taskId` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_message_history_id` (`id`) USING BTREE,
  KEY `idx_message_history_status` (`status`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for h_log_biz_object
-- ----------------------------
CREATE TABLE IF NOT EXISTS `h_log_biz_object` (
  `id` varchar(120) NOT NULL,
  `client` longtext,
  `detail` longtext,
  `ip` varchar(500) DEFAULT NULL,
  `operateNode` varchar(100) DEFAULT NULL,
  `operationType` varchar(50) DEFAULT NULL,
  `time` datetime DEFAULT NULL,
  `username` varchar(100) DEFAULT NULL,
  `workflowInstanceId` varchar(120) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for h_log_biz_service
-- ----------------------------
CREATE TABLE IF NOT EXISTS `h_log_biz_service` (
  `id` varchar(120) NOT NULL,
  `bizServiceStatus` varchar(20) DEFAULT NULL,
  `code` varchar(40) DEFAULT NULL,
  `createdTime` datetime DEFAULT NULL,
  `endTime` datetime DEFAULT NULL,
  `exception` longtext,
  `methodName` varchar(120) DEFAULT NULL,
  `options` longtext,
  `params` varchar(2000) DEFAULT NULL,
  `result` longtext,
  `server` varchar(200) DEFAULT NULL,
  `startTime` datetime DEFAULT NULL,
  `usedTime` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for h_log_login
-- ----------------------------
CREATE TABLE IF NOT EXISTS `h_log_login` (
  `id` varchar(120) NOT NULL,
  `browser` varchar(50) DEFAULT NULL,
  `clientAgent` varchar(500) DEFAULT NULL,
  `ipAddress` varchar(20) DEFAULT NULL,
  `loginSourceType` varchar(40) DEFAULT NULL,
  `loginTime` datetime DEFAULT NULL,
  `name` varchar(40) DEFAULT NULL,
  `userId` varchar(40) DEFAULT NULL,
  `username` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for h_log_metadata
-- ----------------------------
CREATE TABLE IF NOT EXISTS `h_log_metadata` (
  `id` varchar(120) NOT NULL,
  `bizKey` varchar(120) DEFAULT NULL,
  `metaData` longtext,
  `moduleName` varchar(60) DEFAULT NULL,
  `objId` varchar(120) DEFAULT NULL,
  `operateTime` datetime DEFAULT NULL,
  `operateType` int(11) DEFAULT NULL,
  `operator` varchar(120) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for h_log_workflow_exception
-- ----------------------------
CREATE TABLE IF NOT EXISTS `h_log_workflow_exception` (
  `id` varchar(120) NOT NULL,
  `creater` varchar(120) NOT NULL,
  `createrName` varchar(200) DEFAULT NULL,
  `detail` text,
  `extData` varchar(1000) DEFAULT NULL,
  `fixNotes` varchar(1000) DEFAULT NULL,
  `fixedTime` datetime DEFAULT NULL,
  `fixer` varchar(120) DEFAULT NULL,
  `fixerName` varchar(200) DEFAULT NULL,
  `status` varchar(40) NOT NULL,
  `summary` varchar(500) NOT NULL,
  `workflowCode` varchar(40) NOT NULL,
  `workflowInstanceId` varchar(120) NOT NULL,
  `workflowInstanceName` varchar(200) DEFAULT NULL,
  `workflowName` varchar(200) DEFAULT NULL,
  `workflowVersion` int(11) NOT NULL,
  `createdTime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for h_org_department
-- ----------------------------
CREATE TABLE IF NOT EXISTS `h_org_department` (
  `id` varchar(120) NOT NULL,
  `createdTime` datetime DEFAULT NULL,
  `creater` varchar(120) DEFAULT NULL,
  `deleted` bit(1) DEFAULT NULL,
  `extend1` varchar(255) DEFAULT NULL,
  `extend2` varchar(255) DEFAULT NULL,
  `extend3` varchar(255) DEFAULT NULL,
  `extend4` int(11) DEFAULT NULL,
  `extend5` int(11) DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `modifier` varchar(120) DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `calendarId` varchar(36) DEFAULT NULL,
  `employees` int(11) DEFAULT NULL,
  `leaf` bit(1) DEFAULT NULL,
  `managerId` varchar(36) DEFAULT NULL,
  `name` varchar(200) DEFAULT NULL,
  `parentId` varchar(36) DEFAULT NULL,
  `sortKey` bigint(20) DEFAULT NULL,
  `sourceId` varchar(40) DEFAULT NULL,
  `queryCode` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_m8jlxslrsucu3y6dv1lb1s5jf` (`sourceId`),
  KEY `idx_org_name` (`name`),
  KEY `idx_parent_id` (`parentId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for h_org_dept_user
-- ----------------------------
CREATE TABLE IF NOT EXISTS `h_org_dept_user` (
  `id` varchar(120) NOT NULL,
  `createdTime` datetime DEFAULT NULL,
  `creater` varchar(120) DEFAULT NULL,
  `deleted` bit(1) DEFAULT NULL,
  `extend1` varchar(255) DEFAULT NULL,
  `extend2` varchar(255) DEFAULT NULL,
  `extend3` varchar(255) DEFAULT NULL,
  `extend4` int(11) DEFAULT NULL,
  `extend5` int(11) DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `modifier` varchar(120) DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `deptId` varchar(36) DEFAULT NULL,
  `main` bit(1) DEFAULT NULL,
  `userId` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_du_user_id` (`userId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for h_org_role
-- ----------------------------
CREATE TABLE IF NOT EXISTS `h_org_role` (
  `id` varchar(120) NOT NULL,
  `createdTime` datetime DEFAULT NULL,
  `creater` varchar(120) DEFAULT NULL,
  `deleted` bit(1) DEFAULT NULL,
  `extend1` varchar(255) DEFAULT NULL,
  `extend2` varchar(255) DEFAULT NULL,
  `extend3` varchar(255) DEFAULT NULL,
  `extend4` int(11) DEFAULT NULL,
  `extend5` int(11) DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `modifier` varchar(120) DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `code` varchar(180) DEFAULT NULL,
  `groupId` varchar(36) DEFAULT NULL,
  `name` varchar(180) DEFAULT NULL,
  `sortKey` int(11) DEFAULT NULL,
  `sourceId` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_itk9w9ftn6a2vn5o8c7n83ymc` (`sourceId`),
  KEY `idx_role_id` (`id`),
  KEY `idx_rolde_code` (`code`),
  KEY `idx_rolde_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for h_org_role_group
-- ----------------------------
CREATE TABLE IF NOT EXISTS `h_org_role_group` (
  `id` varchar(120) NOT NULL,
  `createdTime` datetime DEFAULT NULL,
  `creater` varchar(120) DEFAULT NULL,
  `deleted` bit(1) DEFAULT NULL,
  `extend1` varchar(255) DEFAULT NULL,
  `extend2` varchar(255) DEFAULT NULL,
  `extend3` varchar(255) DEFAULT NULL,
  `extend4` int(11) DEFAULT NULL,
  `extend5` int(11) DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `modifier` varchar(120) DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `code` varchar(180) DEFAULT NULL,
  `defaultGroup` bit(1) DEFAULT NULL,
  `name` varchar(256) DEFAULT NULL,
  `roleId` varchar(36) DEFAULT NULL,
  `sortKey` int(11) DEFAULT NULL,
  `sourceId` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_role_group_id` (`id`),
  KEY `idx_role_group_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for h_org_role_user
-- ----------------------------
CREATE TABLE IF NOT EXISTS `h_org_role_user` (
  `id` varchar(120) NOT NULL,
  `createdTime` datetime DEFAULT NULL,
  `creater` varchar(120) DEFAULT NULL,
  `deleted` bit(1) DEFAULT NULL,
  `extend1` varchar(255) DEFAULT NULL,
  `extend2` varchar(255) DEFAULT NULL,
  `extend3` varchar(255) DEFAULT NULL,
  `extend4` int(11) DEFAULT NULL,
  `extend5` int(11) DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `modifier` varchar(120) DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `ouScope` varchar(4000) DEFAULT NULL,
  `roleId` varchar(36) DEFAULT NULL,
  `userId` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_role_user_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for h_org_user
-- ----------------------------
CREATE TABLE IF NOT EXISTS `h_org_user` (
  `id` varchar(120) NOT NULL,
  `createdTime` datetime DEFAULT NULL,
  `creater` varchar(120) DEFAULT NULL,
  `deleted` bit(1) DEFAULT NULL,
  `extend1` varchar(255) DEFAULT NULL,
  `extend2` varchar(255) DEFAULT NULL,
  `extend3` varchar(255) DEFAULT NULL,
  `extend4` int(11) DEFAULT NULL,
  `extend5` int(11) DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `modifier` varchar(120) DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `active` bit(1) DEFAULT NULL,
  `admin` bit(1) DEFAULT NULL,
  `appellation` varchar(40) DEFAULT NULL,
  `birthday` datetime DEFAULT NULL,
  `boss` bit(1) DEFAULT NULL,
  `departmentId` varchar(255) DEFAULT NULL,
  `departureDate` datetime DEFAULT NULL,
  `dingtalkId` varchar(100) DEFAULT NULL,
  `email` varchar(40) DEFAULT NULL,
  `employeeNo` varchar(40) DEFAULT NULL,
  `employeeRank` int(11) DEFAULT NULL,
  `entryDate` datetime DEFAULT NULL,
  `gender` varchar(5) DEFAULT NULL,
  `identityNo` varchar(18) DEFAULT NULL,
  `imgUrl` varchar(200) DEFAULT NULL,
  `leader` bit(1) DEFAULT NULL,
  `managerId` varchar(40) DEFAULT NULL,
  `mobile` varchar(100) DEFAULT NULL,
  `name` varchar(250) DEFAULT NULL,
  `officePhone` varchar(20) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL,
  `username` varchar(40) DEFAULT NULL,
  `privacyLevel` varchar(40) DEFAULT NULL,
  `secretaryId` varchar(36) DEFAULT NULL,
  `sortKey` bigint(20) DEFAULT NULL,
  `sourceId` varchar(50) DEFAULT NULL,
  `status` varchar(40) DEFAULT NULL,
  `userId` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_rj7duahtop7qmf2ka0kxs57i0` (`dingtalkId`),
  UNIQUE KEY `UK_phr7by4273l3804n3xc2gq15o` (`sourceId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for h_perm_admin
-- ----------------------------
CREATE TABLE IF NOT EXISTS `h_perm_admin` (
  `id` varchar(120) NOT NULL,
  `creater` varchar(120) DEFAULT NULL,
  `createdTime` datetime DEFAULT NULL,
  `deleted` bit(1) DEFAULT NULL,
  `modifier` varchar(120) DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `adminType` varchar(40) DEFAULT NULL,
  `dataManage` bit(1) DEFAULT NULL,
  `dataQuery` bit(1) DEFAULT NULL,
  `userId` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for h_perm_app_package
-- ----------------------------
CREATE TABLE IF NOT EXISTS `h_perm_app_package` (
  `id` varchar(120) NOT NULL,
  `createdTime` datetime DEFAULT NULL,
  `creater` varchar(120) DEFAULT NULL,
  `deleted` bit(1) DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `modifier` varchar(120) DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `appCode` varchar(40) DEFAULT NULL,
  `departments` longtext,
  `roles` longtext,
  `visibleType` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for h_perm_apppackage_scope
-- ----------------------------
CREATE TABLE IF NOT EXISTS `h_perm_apppackage_scope` (
  `id` varchar(120) NOT NULL,
  `creater` varchar(120) DEFAULT NULL,
  `createdTime` datetime DEFAULT NULL,
  `deleted` bit(1) DEFAULT NULL,
  `modifier` varchar(120) DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `adminId` varchar(40) DEFAULT NULL,
  `code` varchar(40) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for h_perm_biz_function
-- ----------------------------
CREATE TABLE IF NOT EXISTS `h_perm_biz_function` (
  `id` varchar(120) NOT NULL,
  `creater` varchar(120) DEFAULT NULL,
  `createdTime` datetime DEFAULT NULL,
  `deleted` bit(1) DEFAULT NULL,
  `modifier` varchar(120) DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `creatable` bit(1) DEFAULT NULL,
  `dataPermissionType` varchar(40) DEFAULT NULL,
  `deletable` bit(1) DEFAULT NULL,
  `editable` bit(1) DEFAULT NULL,
  `exportable` bit(1) DEFAULT NULL,
  `filterType` varchar(40) DEFAULT NULL,
  `functionCode` varchar(40) DEFAULT NULL,
  `importable` bit(1) DEFAULT NULL,
  `permissionGroupId` varchar(40) DEFAULT NULL,
  `schemaCode` varchar(40) DEFAULT NULL,
  `visible` bit(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for h_perm_department_scope
-- ----------------------------
CREATE TABLE IF NOT EXISTS `h_perm_department_scope` (
  `id` varchar(120) NOT NULL,
  `creater` varchar(120) DEFAULT NULL,
  `createdTime` datetime DEFAULT NULL,
  `deleted` bit(1) DEFAULT NULL,
  `modifier` varchar(120) DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `adminId` varchar(40) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `queryCode` varchar(128) DEFAULT NULL,
  `unitId` varchar(40) DEFAULT NULL,
  `unitType` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for h_perm_function_condition
-- ----------------------------
CREATE TABLE IF NOT EXISTS `h_perm_function_condition` (
  `id` varchar(120) NOT NULL,
  `creater` varchar(120) DEFAULT NULL,
  `createdTime` datetime DEFAULT NULL,
  `deleted` bit(1) DEFAULT NULL,
  `modifier` varchar(120) DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `operatorType` varchar(40) DEFAULT NULL,
  `propertyCode` varchar(40) DEFAULT NULL,
  `schemaCode` varchar(40) DEFAULT NULL,
  `value` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for h_perm_group
-- ----------------------------
CREATE TABLE IF NOT EXISTS `h_perm_group` (
  `id` varchar(120) NOT NULL,
  `createdTime` datetime DEFAULT NULL,
  `creater` varchar(120) DEFAULT NULL,
  `deleted` bit(1) DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `modifier` varchar(120) DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `appCode` varchar(40) DEFAULT NULL,
  `departments` longtext,
  `name` varchar(50) DEFAULT NULL,
  `roles` longtext,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for h_system_sequence_no
-- ----------------------------
CREATE TABLE IF NOT EXISTS `h_system_sequence_no` (
  `id` varchar(120) NOT NULL,
  `createdTime` datetime DEFAULT NULL,
  `creater` varchar(120) DEFAULT NULL,
  `deleted` bit(1) DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `modifier` varchar(120) DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `code` varchar(40) DEFAULT NULL,
  `maxLength` int(11) DEFAULT NULL,
  `resetDate` datetime DEFAULT NULL,
  `resetType` int(11) DEFAULT NULL,
  `serialNo` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for h_system_setting
-- ----------------------------
CREATE TABLE IF NOT EXISTS `h_system_setting` (
  `id` varchar(120) COLLATE utf8_bin NOT NULL,
  `paramCode` varchar(40) COLLATE utf8_bin DEFAULT NULL,
  `paramValue` varchar(200) COLLATE utf8_bin DEFAULT NULL,
  `settingType` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `checked` bit(1) DEFAULT NULL,
  `fileUploadType` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_1acm46hyhe6xq971mhf1xi5h0` (`paramCode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for h_system_setting_copy
-- ----------------------------
CREATE TABLE IF NOT EXISTS `h_system_setting_copy` (
  `id` varchar(120) COLLATE utf8_bin NOT NULL,
  `paramCode` varchar(40) COLLATE utf8_bin DEFAULT NULL,
  `paramValue` varchar(200) COLLATE utf8_bin DEFAULT NULL,
  `settingType` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_1acm46hyhe6xq971mhf1xi5h0` (`paramCode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for h_user_comment
-- ----------------------------
CREATE TABLE IF NOT EXISTS `h_user_comment` (
  `id` varchar(120) NOT NULL,
  `createdTime` datetime DEFAULT NULL,
  `creater` varchar(120) DEFAULT NULL,
  `deleted` bit(1) DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `modifier` varchar(120) DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `content` varchar(600) DEFAULT NULL,
  `sortKey` int(11) DEFAULT NULL,
  `userId` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for h_user_favorites
-- ----------------------------
CREATE TABLE IF NOT EXISTS `h_user_favorites` (
  `id` varchar(120) NOT NULL,
  `createdTime` datetime DEFAULT NULL,
  `creater` varchar(120) DEFAULT NULL,
  `deleted` bit(1) DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `modifier` varchar(120) DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `bizObjectKey` varchar(40) DEFAULT NULL,
  `bizObjectType` varchar(20) DEFAULT NULL,
  `userId` varchar(36) DEFAULT NULL,
  `appCode` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for h_user_guide
-- ----------------------------
CREATE TABLE IF NOT EXISTS `h_user_guide` (
  `id` varchar(120) NOT NULL,
  `creater` varchar(120) DEFAULT NULL,
  `createdTime` datetime DEFAULT NULL,
  `deleted` bit(1) DEFAULT NULL,
  `modifier` varchar(120) DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `display` bit(1) DEFAULT NULL,
  `pageType` varchar(20) NOT NULL,
  `userId` varchar(40) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for h_workflow_header
-- ----------------------------
CREATE TABLE IF NOT EXISTS `h_workflow_header` (
  `id` varchar(120) NOT NULL,
  `createdTime` datetime DEFAULT NULL,
  `creater` varchar(120) DEFAULT NULL,
  `deleted` bit(1) DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `modifier` varchar(120) DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `icon` varchar(50) DEFAULT NULL,
  `mobileOriginate` bit(1) DEFAULT NULL,
  `pcOriginate` bit(1) DEFAULT NULL,
  `schemaCode` varchar(40) DEFAULT NULL,
  `sortKey` int(11) DEFAULT NULL,
  `workflowCode` varchar(40) DEFAULT NULL,
  `workflowName` varchar(200) DEFAULT NULL,
  `published` bit(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_2t1h4foumcylj4hvrvhssf673` (`workflowCode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for h_workflow_permission
-- ----------------------------
CREATE TABLE IF NOT EXISTS `h_workflow_permission` (
  `id` varchar(120) NOT NULL,
  `createdTime` datetime DEFAULT NULL,
  `creater` varchar(120) DEFAULT NULL,
  `deleted` bit(1) DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `modifier` varchar(120) DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `unitId` varchar(36) DEFAULT NULL,
  `unitType` varchar(10) DEFAULT NULL,
  `workflowCode` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for h_workflow_relative_object
-- ----------------------------
CREATE TABLE IF NOT EXISTS `h_workflow_relative_object` (
  `id` varchar(120) NOT NULL,
  `relativeCode` varchar(40) DEFAULT NULL,
  `relativeType` varchar(40) DEFAULT NULL,
  `workflowCode` varchar(40) DEFAULT NULL,
  `workflowVersion` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for h_workflow_template
-- ----------------------------
CREATE TABLE IF NOT EXISTS `h_workflow_template` (
  `id` varchar(120) NOT NULL,
  `createdTime` datetime DEFAULT NULL,
  `creater` varchar(120) DEFAULT NULL,
  `deleted` bit(1) DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `modifier` varchar(120) DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `content` longtext,
  `templateType` varchar(10) DEFAULT NULL,
  `workflowCode` varchar(40) DEFAULT NULL,
  `workflowVersion` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT IGNORE INTO `base_security_client` (`id`, `createdTime`, `creater`, `deleted`, `extend1`, `extend2`, `extend3`, `extend4`, `extend5`, `modifiedTime`, `modifier`, `remarks`, `accessTokenValiditySeconds`, `additionInformation`, `authorities`, `authorizedGrantTypes`, `autoApproveScopes`, `clientId`, `clientSecret`, `refreshTokenValiditySeconds`, `registeredRedirectUris`, `resourceIds`, `scopes`, `type`)
VALUES ('8a5da52ed126447d359e70c05721a8aa', NULL, NULL, b'0', NULL, NULL, NULL, '0', '0', NULL, NULL, NULL, '28800', 'API', 'api', 'authorization_code,implicit,password,refresh_token', 'read,write', 'api', '{noop}c31b32364ce19ca8fcd150a417ecce58', '28800', 'http://127.0.0.1/admin,http://127.0.0.1/admin#/oauth,http://127.0.0.1/oauth', 'api', 'read,write', 'APP');

INSERT IGNORE INTO `h_org_user` (`id`, `createdTime`, `creater`, `deleted`, `extend1`, `extend2`, `extend3`, `extend4`, `extend5`, `modifiedTime`, `modifier`, `remarks`, `active`, `admin`, `appellation`, `birthday`, `boss`, `departmentId`, `departureDate`, `dingtalkId`, `email`, `employeeNo`, `employeeRank`, `entryDate`, `gender`, `identityNo`, `imgUrl`, `leader`, `managerId`, `mobile`, `name`, `officePhone`, `password`, `username`, `privacyLevel`, `secretaryId`, `sortKey`, `sourceId`, `status`, `userId`)
VALUES ('2c9280a26706a73a016706a93ccf002b', NULL, NULL, b'0', NULL, NULL, NULL, NULL, NULL, '2019-02-22 13:54:42', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'admin', NULL, '{bcrypt}$2a$10$NvgvcocBqMn050z4nC0I6OeAhO5ERjM74pvMtSGLghPhWI5ed5myG', 'admin', NULL, NULL, NULL, NULL, NULL, NULL);

-- 修改用户名称字段的字符编码
ALTER TABLE `h_org_user` CHANGE `name` `name` varchar(180) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL ;


CREATE TABLE IF NOT EXISTS `h_biz_rule` (
  `id` varchar(120) NOT NULL,
  `creater` varchar(120) DEFAULT NULL,
  `createdTime` datetime DEFAULT NULL,
  `deleted` bit(1) DEFAULT NULL,
  `modifier` varchar(120) DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `conditionJoinType` varchar(40) DEFAULT NULL COMMENT '条件连接类型',
  `enabled` bit(1) DEFAULT NULL COMMENT '是否启用',
  `name` varchar(100) DEFAULT NULL COMMENT '数据规则名称',
  `ruleActionJson` longtext COMMENT '执行动作',
  `ruleScopeJson` longtext COMMENT '查找范围',
  `sourceSchemaCode` varchar(40) DEFAULT NULL COMMENT '规则所属模型编码',
  `targetSchemaCode` varchar(40) DEFAULT NULL COMMENT '目标模型编码',
  `triggerActionType` varchar(40) DEFAULT NULL COMMENT '触发动作类型',
  `triggerConditionType` varchar(40) DEFAULT NULL COMMENT '触发条件类型',
  `triggerSchemaCode` varchar(40) DEFAULT NULL COMMENT '触发模型编码',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT '数据规则';


ALTER TABLE `h_biz_rule` ADD COLUMN `chooseAction` varchar(100) DEFAULT NULL COMMENT '目标模型导航编码';


ALTER TABLE `h_biz_query_condition` ADD COLUMN `accurateSearch` bit(1) DEFAULT NULL COMMENT '精确查找';
ALTER TABLE `h_biz_query_condition` ADD COLUMN `displayFormat` varchar(40) DEFAULT NULL COMMENT '显示格式';


CREATE TABLE IF NOT EXISTS `h_biz_rule_trigger` (
  `id` varchar(120) NOT NULL,
  `creater` varchar(120) DEFAULT NULL,
  `createdTime` datetime DEFAULT NULL,
  `deleted` bit(1) DEFAULT NULL,
  `modifier` varchar(120) DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `conditionJoinType` varchar(40) DEFAULT NULL COMMENT '条件连接类型',
  `ruleId` varchar(100) DEFAULT NULL COMMENT '数据规则id',
  `ruleName` varchar(100) DEFAULT NULL COMMENT '数据规则名称',
  `targetSchemaCode` varchar(40) DEFAULT NULL COMMENT '目标模型编码',
  `triggerActionType` varchar(40) DEFAULT NULL COMMENT '触发动作类型',
  `triggerConditionType` varchar(40) DEFAULT NULL COMMENT '触发条件类型',
  `triggerObjectId` varchar(100) DEFAULT NULL COMMENT '触发对象Id',
  `triggerSchemaCode` varchar(40) DEFAULT NULL COMMENT '触发对象模型编码',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT '数据规则触发记录';

CREATE TABLE IF NOT EXISTS `h_biz_rule_effect` (
  `id` varchar(120) NOT NULL,
  `creater` varchar(120) DEFAULT NULL,
  `createdTime` datetime DEFAULT NULL,
  `deleted` bit(1) DEFAULT NULL,
  `modifier` varchar(120) DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `actionType` varchar(40) DEFAULT NULL COMMENT '动作类型',
  `actionValue` varchar(255) DEFAULT NULL COMMENT '动作值',
  `lastValue` longtext COMMENT '规则执行前数据',
  `setValue` longtext COMMENT '规则执行后数据',
  `targetObjectId` varchar(100) DEFAULT NULL COMMENT '目标对象id',
  `targetPropertyCode` varchar(40) DEFAULT NULL COMMENT '目标属性',
  `targetSchemaCode` varchar(40) DEFAULT NULL COMMENT '目标模型编码',
  `triggerActionType` varchar(40) DEFAULT NULL COMMENT '触发动作类型',
  `triggerId` varchar(100) DEFAULT NULL COMMENT '规则触发id',
  `triggerObjectId` varchar(100) DEFAULT NULL COMMENT '触发对象id',
  `triggerSchemaCode` varchar(40) DEFAULT NULL COMMENT '触发对象模型编码',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT '数据规则执行影响数据记录';


ALTER TABLE `h_biz_query_condition` MODIFY `defaultValue` VARCHAR(500) DEFAULT NULL COMMENT '默认值';


ALTER TABLE `h_perm_biz_function` ADD COLUMN `nodeType` VARCHAR(40) DEFAULT NULL COMMENT '节点类型';


CREATE TABLE IF NOT EXISTS `h_workflow_relative_event`
(
  `id`            varchar(120) NOT NULL,
  `creater`       varchar(120) DEFAULT NULL,
  `createdTime`   datetime     DEFAULT NULL,
  `deleted`       bit(1)       DEFAULT NULL,
  `modifier`      varchar(120) DEFAULT NULL,
  `modifiedTime`  datetime     DEFAULT NULL,
  `remarks`       varchar(200) DEFAULT NULL,
  `schemaCode`    varchar(40)  DEFAULT NULL COMMENT '模型编码',
  `workflowCode`  varchar(40)  DEFAULT NULL COMMENT '流程编码',
  `bizMethodCode` varchar(40)  DEFAULT NULL COMMENT '业务方法编码',
  PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8 COMMENT '流程关联业务方法';
 -- ----------------------------
-- Table structure for biz_work_record
 -- ----------------------------
CREATE TABLE IF NOT EXISTS `h_im_work_record`(
`id` varchar(42) NOT NULL  ,
  `workitemId` varchar(64) DEFAULT NULL ,
  `recordId` varchar(80) DEFAULT NULL,
  `requestId` varchar(80) DEFAULT NULL,
  `receivers` longtext ,
  `title` varchar(100) DEFAULT NULL  ,
  `content` varchar(200) DEFAULT NULL  ,
  `url` varchar(500) DEFAULT NULL  ,
  `receiveTime` datetime DEFAULT NULL  ,
  `tryTimes` int(36) DEFAULT NULL ,
  `failRetry` varchar(200) DEFAULT NULL ,
  `messageType` varchar(200) DEFAULT NULL  ,
  `failUserRetry` bit(1) DEFAULT NULL,
  `WorkRecordStatus` varchar(40) NOT NULL ,
  `channel` varchar(40) DEFAULT NULL ,
  `bizParams` longtext ,
  `createdTime` datetime DEFAULT NULL  ,
  `modifiedTime` datetime DEFAULT NULL ,
  PRIMARY KEY (`id`),
  KEY `I_RecordId` (`recordId`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='待办事项表';

-- ----------------------------
-- Table structure for biz_work_record_history
-- ----------------------------
CREATE TABLE IF NOT EXISTS `h_im_work_record_history`(
  `id` varchar(42) NOT NULL  ,
  `workitemId` varchar(64) DEFAULT NULL ,
  `recordId` varchar(80) DEFAULT NULL,
  `requestId` varchar(80) DEFAULT NULL,
  `receivers` longtext ,
  `title` varchar(100) DEFAULT NULL  ,
  `content` varchar(200) DEFAULT NULL  ,
  `url` varchar(500) DEFAULT NULL  ,
  `receiveTime` datetime DEFAULT NULL  ,
  `tryTimes` int(36) DEFAULT NULL ,
  `failRetry` varchar(200) DEFAULT NULL ,
  `messageType` varchar(200) DEFAULT NULL  ,
  `failUserRetry` bit(1) DEFAULT NULL,
  `WorkRecordStatus` varchar(40) NOT NULL,
  `status` varchar(40) DEFAULT NULL,
  `channel` varchar(40) DEFAULT NULL  ,
  `bizParams` longtext,
  `createdTime` datetime DEFAULT NULL  ,
  `modifiedTime` datetime DEFAULT NULL ,
  `taskId` varchar(42)  NULL COMMENT '待办事项历史任务id',
  PRIMARY KEY (`id`),
  KEY `I_RecordId` (`recordId`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='待办事项历史纪录表';


CREATE TABLE `h_im_urge_task` (
  `id` varchar(64) COLLATE utf8_bin NOT NULL,
  `instanceId` varchar(120) COLLATE utf8_bin NOT NULL COMMENT '流程实例id',
  `text` varchar(255) COLLATE utf8_bin NOT NULL COMMENT '催办内容',
  `userId` varchar(80) COLLATE utf8_bin NOT NULL COMMENT '催办用户id',
  `opTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '催办时间',
  `urgeType` int(255) NOT NULL DEFAULT '0' COMMENT '催办类型，0：客户端ding消息；1：web端钉钉通知',
  `messageId` varchar(120) COLLATE utf8_bin DEFAULT NULL COMMENT '钉钉消息id',
  PRIMARY KEY (`id`),
  KEY `IDX_HASTEN_INST_USERID` (`instanceId`,`userId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='催办表';

CREATE TABLE `h_im_urge_workitem` (
  `id` varchar(64) COLLATE utf8_bin NOT NULL,
  `workitemId` varchar(120) COLLATE utf8_bin NOT NULL COMMENT '代办id',
  `userId` varchar(80) COLLATE utf8_bin NOT NULL COMMENT '催办用户id',
  `createTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '催办时间',
  `modifyTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `urgeCount` int(255) NOT NULL DEFAULT '1' COMMENT '催办次数',
  PRIMARY KEY (`id`),
  KEY `IDX_URGE_ITEMID_USERID` (`workitemId`,`userId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='催办代办表';

ALTER TABLE `base_security_client` MODIFY `registeredRedirectUris` varchar(2000) DEFAULT NULL;

ALTER TABLE `h_biz_sheet` ADD COLUMN `externalLinkAble` bit(1) DEFAULT 0 COMMENT '是否开启外链';

ALTER TABLE `h_app_function` ADD COLUMN `name_i18n` VARCHAR(1000) DEFAULT NULL COMMENT '双语言';
ALTER TABLE `h_app_package` ADD COLUMN `name_i18n` VARCHAR(1000) DEFAULT NULL COMMENT '双语言';
ALTER TABLE `h_biz_sheet` ADD COLUMN `name_i18n` VARCHAR(1000) DEFAULT NULL COMMENT '双语言';
ALTER TABLE `h_biz_property` ADD COLUMN `name_i18n` VARCHAR(1000) DEFAULT NULL COMMENT '双语言';
ALTER TABLE `h_biz_query` ADD COLUMN `name_i18n` VARCHAR(1000) DEFAULT NULL COMMENT '双语言';
ALTER TABLE `h_biz_query_action` ADD COLUMN `name_i18n` VARCHAR(1000) DEFAULT NULL COMMENT '双语言';
ALTER TABLE `h_biz_query_column` ADD COLUMN `name_i18n` VARCHAR(1000) DEFAULT NULL COMMENT '双语言';
ALTER TABLE `h_biz_query_condition` ADD COLUMN `name_i18n` VARCHAR(1000) DEFAULT NULL COMMENT '双语言';
ALTER TABLE `h_biz_query_sorter` ADD COLUMN `name_i18n` VARCHAR(1000) DEFAULT NULL COMMENT '双语言';
ALTER TABLE `h_biz_schema` ADD COLUMN `name_i18n` VARCHAR(1000) DEFAULT NULL COMMENT '双语言';
ALTER TABLE `h_custom_page` ADD COLUMN `name_i18n` VARCHAR(1000) DEFAULT NULL COMMENT '双语言';
ALTER TABLE `h_workflow_header` ADD COLUMN `name_i18n` VARCHAR(1000) DEFAULT NULL COMMENT '双语言';

DROP TABLE IF EXISTS `h_biz_perm_group`;
CREATE TABLE `h_biz_perm_group` (
  `id` varchar(120) NOT NULL,
  `creater` varchar(120) DEFAULT NULL,
  `createdTime` datetime DEFAULT NULL,
  `deleted` bit(1) DEFAULT NULL,
  `modifier` varchar(120) DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `enabled` bit(1) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `name_i18n` varchar(1000) DEFAULT NULL,
  `roles` longtext,
  `schemaCode` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `h_biz_perm_property`;
CREATE TABLE `h_biz_perm_property` (
  `id` varchar(120) NOT NULL,
  `creater` varchar(120) DEFAULT NULL,
  `createdTime` datetime DEFAULT NULL,
  `deleted` bit(1) DEFAULT NULL,
  `modifier` varchar(120) DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `bizPermType` varchar(40) DEFAULT NULL,
  `groupId` varchar(40) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `name_i18n` varchar(1000) DEFAULT NULL,
  `propertyCode` varchar(40) DEFAULT NULL,
  `propertyType` varchar(40) DEFAULT NULL,
  `required` bit(1) DEFAULT NULL,
  `visible` bit(1) DEFAULT NULL,
  `writeAble` bit(1) DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of h_biz_perm_property
-- ----------------------------



INSERT IGNORE INTO `h_org_user` (`id`, `createdTime`, `creater`, `deleted`, `extend1`, `extend2`, `extend3`, `extend4`, `extend5`, `modifiedTime`, `modifier`, `remarks`, `active`, `admin`, `appellation`, `birthday`, `boss`, `departmentId`, `departureDate`, `dingtalkId`, `email`, `employeeNo`, `employeeRank`, `entryDate`, `gender`, `identityNo`, `imgUrl`, `leader`, `managerId`, `mobile`, `name`, `officePhone`, `password`, `username`, `privacyLevel`, `secretaryId`, `sortKey`, `sourceId`, `status`, `userId`)
VALUES ('2ccf3b346706a6d3016706dc51c0022b', '2019-06-05 19:30:30', NULL, b'0', NULL, NULL, NULL, NULL, NULL, '2019-06-05 19:30:30', NULL, NULL, b'1', b'1', NULL, NULL, b'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, b'0', NULL, NULL, 'xuser', NULL, '{bcrypt}$2a$10$NvgvcocBqMn050z4nC0I6OeAhO5ERjM74pvMtSGLghPhWI5ed5myG', 'xuser', NULL, NULL, NULL, NULL, NULL, NULL);

ALTER TABLE `h_biz_sheet` ADD COLUMN `draftHtmlJson` longtext DEFAULT NULL COMMENT '草稿在线设计与编辑json';
ALTER TABLE `h_biz_sheet` ADD COLUMN `publishedHtmlJson` longtext DEFAULT NULL COMMENT '发布在线设计与编辑json';
ALTER TABLE `h_biz_sheet` ADD COLUMN `draftActionsJson` longtext DEFAULT NULL COMMENT '草稿在线设计与编辑按钮json';
ALTER TABLE `h_biz_sheet` ADD COLUMN `publishedActionsJson` longtext DEFAULT NULL COMMENT '发布在线设计与编辑j按钮json';

INSERT IGNORE INTO `h_org_department` (`id`, `createdTime`, `creater`, `deleted`, `extend1`, `extend2`, `extend3`, `extend4`, `extend5`, `modifiedTime`, `modifier`, `remarks`, `calendarId`, `employees`, `leaf`, `managerId`, `name`, `parentId`, `sortKey`, `sourceId`, `queryCode`)
VALUES ('06ef8c9a3f3b6669a34036a3001e6340', '2019-03-22 11:25:05', NULL, b'0', '', '', NULL, NULL, NULL, '2019-05-14 13:44:21', NULL, NULL, NULL, NULL, b'0', '', '外部', NULL, '0', NULL, '');

UPDATE `h_org_user` SET `departmentId`='06ef8c9a3f3b6669a34036a3001e6340' WHERE `id`='2ccf3b346706a6d3016706dc51c0022b';

INSERT IGNORE INTO `h_org_dept_user` (`id`, `createdTime`, `creater`, `deleted`, `modifiedTime`, `modifier`, `remarks`, `deptId`, `main`, `userId`)
VALUES ('07df8b34e4469a00169a36a336450cf3', '2019-03-22 11:25:07', NULL, b'0','2019-03-22 11:25:07', NULL, NULL, '06ef8c9a3f3b6669a34036a3001e6340', NULL, '2ccf3b346706a6d3016706dc51c0022b');

ALTER TABLE `h_biz_perm_property` ADD COLUMN `schemaCode` VARCHAR(40) DEFAULT NULL COMMENT '模型编码';

UPDATE `h_org_department` SET `parentId`='06ef8c9a3f3b6669a34036a3001e63401' WHERE `id`='06ef8c9a3f3b6669a34036a3001e6340';

INSERT IGNORE INTO `base_security_client` (`id`,  `deleted`, `accessTokenValiditySeconds`, `additionInformation`, `authorities`, `authorizedGrantTypes`, `autoApproveScopes`, `clientId`, `clientSecret`, `refreshTokenValiditySeconds`, `registeredRedirectUris`, `resourceIds`, `scopes`, `type`)
VALUES ('52ed17238a5da59e71a8aa26447d0c05', b'0', '3600', 'API', 'openapi', 'client_credentials', 'read,write', 'xclient', '{noop}0a417ecce58c31b32364ce19ca8fcd15', '3600', '', 'api', 'read,write', 'APP');


UPDATE `h_org_user` SET `name`='外部用户' WHERE `id`='2ccf3b346706a6d3016706dc51c0022b';

ALTER TABLE `h_perm_function_condition` ADD `functionId` varchar(40) DEFAULT NULL;

ALTER TABLE `h_org_dept_user` ADD `sortKey` varchar(200) DEFAULT NULL;
ALTER TABLE `h_org_dept_user` ADD `leader` bit(1) DEFAULT NULL;
ALTER TABLE `biz_workflow_instance` ADD `sheetBizObjectId` varchar(36) DEFAULT NULL COMMENT '主流程子表中的行数据关联id';
ALTER TABLE `biz_workflow_instance` ADD `sheetSchemaCode` varchar(64) DEFAULT NULL COMMENT '子表字段编码';

ALTER TABLE `h_biz_sheet` ADD COLUMN `shortCode` varchar(50) DEFAULT NULL COMMENT '表单外链短码';

INSERT IGNORE INTO `h_org_department` (`id`, `createdTime`, `creater`, `deleted`, `extend1`, `extend2`, `extend3`, `extend4`, `extend5`, `modifiedTime`, `modifier`, `remarks`, `calendarId`, `employees`, `leaf`, `managerId`, `name`, `parentId`, `sortKey`, `sourceId`, `queryCode`)
VALUES ('1803c80ed28a3e25871d58808019816e', '2019-03-22 11:25:05', NULL, b'0', '', '', NULL, NULL, NULL, '2019-05-14 13:44:21', NULL, NULL, NULL, NULL, b'0', '', '管理部门', 'fc57a56529ef4e089b5b23162f063ca9', '0', NULL, '');
UPDATE `h_org_user` SET `departmentId`='1803c80ed28a3e25871d58808019816e' WHERE `id`='2c9280a26706a73a016706a93ccf002b';
INSERT IGNORE INTO `h_org_dept_user` (`id`, `createdTime`, `creater`, `deleted`, `modifiedTime`, `modifier`, `remarks`, `deptId`, `main`, `userId`)
VALUES ('a92a7856f16132c6a1884b08c3233236', '2019-03-22 11:25:07', NULL, b'0','2019-03-22 11:25:07', NULL, NULL, '1803c80ed28a3e25871d58808019816e', NULL, '2c9280a26706a73a016706a93ccf002b');

ALTER TABLE `h_biz_sheet` ADD COLUMN `printTemplateJson` varchar(1000) DEFAULT NULL COMMENT '关联的打印模板';
ALTER TABLE `h_biz_sheet` ADD COLUMN `qrCodeAble` VARCHAR(40) DEFAULT NULL COMMENT '是否开启二维码';

ALTER TABLE `h_im_work_record_history` MODIFY `taskId` varchar(42) DEFAULT NULL;

CREATE TABLE `h_biz_remind` (
  `id` varchar(120) COLLATE utf8_bin NOT NULL,
  `creater` varchar(120) COLLATE utf8_bin DEFAULT NULL,
  `createdTime` datetime DEFAULT NULL,
  `deleted` bit(1) DEFAULT NULL,
  `modifier` varchar(120) COLLATE utf8_bin DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `remarks` varchar(200) COLLATE utf8_bin DEFAULT NULL,
  `conditionType` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `dateOption` varchar(300) COLLATE utf8_bin DEFAULT NULL,
  `dateType` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `depIds` longtext COLLATE utf8_bin,
  `enabled` bit(1) DEFAULT NULL,
  `filterType` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `intervalTime` int(11) DEFAULT NULL,
  `msgTemplate` varchar(500) COLLATE utf8_bin DEFAULT NULL,
  `remindType` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `roleCondition` longtext COLLATE utf8_bin,
  `roleIds` longtext COLLATE utf8_bin,
  `schemaCode` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `sheetCode` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `userDataOptions` longtext COLLATE utf8_bin,
  `userIds` longtext COLLATE utf8_bin,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='表单消息提醒表';

ALTER TABLE h_biz_remind MODIFY  `msgTemplate` longtext DEFAULT NULL;
ALTER TABLE `h_biz_property` ADD COLUMN `sortKey` int(11) DEFAULT NULL COMMENT '排序字段';

ALTER TABLE `h_log_biz_service` ADD COLUMN `schemaCode` VARCHAR (40) NULL DEFAULT NULL COMMENT '业务模型编码' COLLATE 'utf8_bin';
ALTER TABLE `h_log_biz_service` ADD COLUMN `bizObjectId` VARCHAR (200) NULL DEFAULT NULL COMMENT '业务对象ID' COLLATE 'utf8_bin';


CREATE TABLE IF NOT EXISTS `h_system_pair` (
  `id` varchar(120) NOT NULL,
  `paramCode` varchar(200) DEFAULT NULL,
  `pairValue` longtext,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_9tviae6s7glway1kpyiybg4yp` (`paramCode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `h_job_result` (
  `id` varchar(120) COLLATE utf8_bin NOT NULL,
  `jobName` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `beanName` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `methodName` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `methodParams` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `year` int(10) DEFAULT NULL,
  `cronExpression` varchar(80) COLLATE utf8_bin DEFAULT NULL,
  `jobRunType` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `createTime` datetime DEFAULT NULL,
  `executeStatus` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='定时任务执行结果表';


CREATE TABLE `h_timer_job` (
  `id` varchar(120) COLLATE utf8_bin NOT NULL,
  `jobName` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `beanName` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `methodName` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `methodParams` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `year` int(10) DEFAULT NULL,
  `cronExpression` varchar(80) COLLATE utf8_bin DEFAULT NULL,
  `status` int(11) DEFAULT NULL COMMENT '状态（1正常 0暂停）',
  `jobRunType` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `remark` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `createTime` datetime DEFAULT NULL,
  `updateTime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='定时任务表';


ALTER TABLE `h_biz_sheet` ADD COLUMN `pdfAble` VARCHAR (40) DEFAULT NULL COMMENT '开启pdf';


/***********************************************更新部门表queryCode字段长度***********************************************/
ALTER TABLE h_org_department MODIFY queryCode varchar(512) default null;

/***********************************************更新部门权限表queryCode字段长度***********************************************/
ALTER TABLE h_perm_department_scope MODIFY queryCode varchar(512) default null;

/***********************************************更新数据项表propertyLength值***********************************************/
UPDATE h_biz_property SET propertyLength = 512 WHERE code = 'ownerDeptQueryCode';


/*************************************************更新部门表queryCode规则*************************************************/
DROP PROCEDURE IF EXISTS updateDepartQueryCode;
delimiter //
CREATE PROCEDURE updateDepartQueryCode(IN vParentId VARCHAR(50), IN vParentQueryCode VARCHAR(100))
BEGIN
  DECLARE done INT DEFAULT 0;

  DECLARE vDeptId VARCHAR(50) DEFAULT '';
  DECLARE vSourceId VARCHAR(50) DEFAULT '';

  DECLARE taskCursor CURSOR FOR SELECT id, sourceId FROM h_org_department t WHERE t.parentId = vParentId;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SET @@max_sp_recursion_depth = 300; /*设置递归最大深度*/

  OPEN taskCursor;

  REPEAT
    FETCH taskCursor INTO vDeptId, vSourceId;

    IF NOT done THEN

      /*SELECT vParentQueryCode;*/

      SET @vFullQueryCode = concat(vParentQueryCode, '#', vSourceId);

      /*SELECT @vFullQueryCode;*/

      /*更新queryCode，规则 parentQueryCode+'#'+sourceId */
      SET @sql1 = concat('update h_org_department d set d.queryCode = \'', @vFullQueryCode, '\' where d.id = \'', vDeptId, '\'');

      /*SELECT @sql1;*/

      PREPARE stmt1 FROM @sql1;
      EXECUTE stmt1;

      /*SELECT @vFullQueryCode;*/

      CALL updateDepartQueryCode(vDeptId, @vFullQueryCode);

    /*ELSE
      SELECT 'no child.';*/

    END IF;
  UNTIL done END REPEAT;
  CLOSE taskCursor;
END;


/*************************************************调用更新部门权限表 存储过程*************************************************/
DROP PROCEDURE IF EXISTS updateDepartInit;
CREATE PROCEDURE updateDepartInit()
BEGIN

  /*备份部门表*/
  /*create table if not exists h_org_department_bak select * from h_org_department t;*/

  /*跟新跟部门的queryCode = 1*/
  update h_org_department set queryCode = '1' where sourceId = '1';
  select id into @id from h_org_department  where sourceId = '1';

  /*select @id;*/

  CALL updateDepartQueryCode(@id, '1');

END;
//
delimiter ;
call updateDepartInit();


/*************************************************更新部门权限表queryCode规则*************************************************/
update h_perm_department_scope s set s.queryCode = (select d.queryCode from h_org_department d where d.id = s.unitId and s.unitType = 'DEPARTMENT');
/*commit;*/


/***************************************更新i表的queryCode***************************************************/
DROP PROCEDURE IF EXISTS updateITableQueryCode;
delimiter //
CREATE PROCEDURE updateITableQueryCode()
BEGIN
  DECLARE vTableName VARCHAR(50) DEFAULT '';
  DECLARE done INT DEFAULT 0;
  DECLARE vQueryCodeCount INT DEFAULT 0;

  DECLARE taskCursor CURSOR FOR SELECT table_name FROM information_schema.tables WHERE table_schema=database() AND table_name like 'i_%' AND table_rows > 0;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
  OPEN taskCursor;

  REPEAT
    FETCH taskCursor INTO vTableName;
    IF NOT done THEN

      SET vQueryCodeCount = (SELECT count(*) FROM information_schema.columns WHERE table_name = vTableName AND table_schema=database() AND column_name = 'ownerDeptQueryCode');
      IF vQueryCodeCount > 0 THEN

        /*SELECT vTableName;*/

        SET @alterSQL = concat('ALTER TABLE ', vTableName, ' MODIFY ownerDeptQueryCode varchar(512) default null');
        PREPARE stmt1 FROM @alterSQL;
        EXECUTE stmt1;

        SET @sql = concat('update ', vTableName, ' t set t.ownerDeptQueryCode = (select d.queryCode from h_org_department d where d.id = t.ownerDeptId)');

        /*SELECT @sql;*/

        PREPARE stmt FROM @sql;
        EXECUTE stmt;

      END IF;

    END IF;
  UNTIL done END REPEAT;
  CLOSE taskCursor;
END;
//
delimiter ;
CALL updateITableQueryCode();



/*如果存在：则删除存储过程*/
DROP PROCEDURE IF EXISTS deleteBOAndWorkflow;
delimiter //

/*创建*/
CREATE PROCEDURE deleteBOAndWorkflow()
BEGIN
  DECLARE vWorkflowCode VARCHAR(50) DEFAULT ''; /*流程编码*/
  DECLARE vWorkflowInstanceId VARCHAR(50) DEFAULT ''; /*流程实例id*/
  DECLARE vBizObjectId VARCHAR(50) DEFAULT ''; /*业务对象id*/
  DECLARE vSchemaCode VARCHAR(50) DEFAULT ''; /*业务模型编码*/
  DECLARE vTableName VARCHAR(50) DEFAULT ''; /*业务表*/

  DECLARE done INT DEFAULT 0; /*定义游标结束标记*/

  DECLARE taskCursor CURSOR FOR select t.id, t.workflowCode, t.bizObjectId from biz_workflow_instance t;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  OPEN taskCursor;
  REPEAT
    FETCH taskCursor INTO vWorkflowInstanceId, vWorkflowCode, vBizObjectId;

    IF NOT done THEN
      SET vSchemaCode = (select h.schemaCode from h_workflow_header h where h.workflowCode = vWorkflowCode);
      /*select vSchemaCode;*/

      IF vSchemaCode <> '' THEN
        SET vTableName = concat('i_', vSchemaCode);
        /*select vTableName;*/

        SET @tSQL = concat('select count(1) into @vTableCount from information_schema.tables where table_schema=database() and table_name = \'', vTableName, '\'');

        PREPARE tStmt FROM @tSQL;
        EXECUTE tStmt;
        DEALLOCATE PREPARE tStmt; /*释放资源*/

        /*select @vTableCount;*/
        /*判断表是否存在*/
        IF @vTableCount > 0 THEN

          SET @sql = concat('select count(*) into @vDataCount from ', vTableName, ' where id = \'', vBizObjectId, '\'');

          PREPARE stmt FROM @sql;
          EXECUTE stmt;
          DEALLOCATE PREPARE stmt;

          /*select @vDataCount;*/
          /*判断i表是否有数据*/
          IF @vDataCount = 0 THEN
             /*set vWorkflowInstanceId = 'aaaaa';*/
             /*select @vDataCount, vWorkflowInstanceId, vWorkflowCode, vBizObjectId, vSchemaCode;*/

             SET @sql1 = concat('delete from biz_workflow_instance where id = \'', vWorkflowInstanceId, '\'');
             SET @sql2 = concat('delete from biz_workflow_token where instanceId = \'', vWorkflowInstanceId, '\'');
             SET @sql3 = concat('delete from biz_workitem where instanceId = \'', vWorkflowInstanceId, '\'');
             SET @sql4 = concat('delete from biz_workitem_finished where instanceId = \'', vWorkflowInstanceId, '\'');
             SET @sql5 = concat('delete from biz_circulateitem where instanceId = \'', vWorkflowInstanceId, '\'');
             SET @sql6 = concat('delete from biz_circulateitem_finished where instanceId = \'', vWorkflowInstanceId, '\'');

             PREPARE stmtDel1 FROM @sql1;
             PREPARE stmtDel2 FROM @sql2;
             PREPARE stmtDel3 FROM @sql3;
             PREPARE stmtDel4 FROM @sql4;
             PREPARE stmtDel5 FROM @sql5;
             PREPARE stmtDel6 FROM @sql6;

             EXECUTE stmtDel1;
             EXECUTE stmtDel2;
             EXECUTE stmtDel3;
             EXECUTE stmtDel4;
             EXECUTE stmtDel5;
             EXECUTE stmtDel6;

             DEALLOCATE PREPARE stmtDel1;
             DEALLOCATE PREPARE stmtDel2;
             DEALLOCATE PREPARE stmtDel3;
             DEALLOCATE PREPARE stmtDel4;
             DEALLOCATE PREPARE stmtDel5;
             DEALLOCATE PREPARE stmtDel6;

          END IF;

        END IF;

      END IF;

    END IF;
  UNTIL done END REPEAT;

  CLOSE taskCursor;
END;
//
delimiter ;
/*调用存储过程*/
CALL deleteBOAndWorkflow();

ALTER TABLE `h_perm_biz_function` ADD COLUMN `printAble` BIT(1) DEFAULT NULL COMMENT '是否打印';

update h_biz_property t set t.propertyType = 'SHORT_TEXT' where t.code = 'id' and t.propertyType = 'WORK_SHEET';

ALTER TABLE `h_timer_job` ADD COLUMN `taskId` VARCHAR(120) DEFAULT NULL COMMENT '任务id';
ALTER TABLE `h_job_result` ADD COLUMN `taskId` VARCHAR(120) DEFAULT NULL COMMENT '任务id';


CREATE TABLE `h_org_department_history` (
  `id` varchar(120) COLLATE utf8_bin NOT NULL,
  `creater` varchar(120) COLLATE utf8_bin DEFAULT NULL,
  `createdTime` datetime DEFAULT NULL,
  `deleted` bit(1) DEFAULT NULL,
  `modifier` varchar(120) COLLATE utf8_bin DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `remarks` varchar(200) COLLATE utf8_bin DEFAULT NULL,
  `extend1` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `extend2` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `extend3` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `extend4` int(11) DEFAULT NULL,
  `extend5` int(11) DEFAULT NULL,
  `calendarId` varchar(36) COLLATE utf8_bin DEFAULT NULL,
  `employees` int(11) DEFAULT NULL,
  `leaf` bit(1) DEFAULT NULL,
  `managerId` varchar(2000) COLLATE utf8_bin DEFAULT NULL,
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `parentId` varchar(36) COLLATE utf8_bin DEFAULT NULL,
  `queryCode` varchar(512) COLLATE utf8_bin DEFAULT NULL,
  `sortKey` bigint(20) DEFAULT NULL,
  `sourceId` varchar(40) COLLATE utf8_bin DEFAULT NULL,
  `targetParentId` varchar(36) COLLATE utf8_bin DEFAULT NULL,
  `targetQueryCode` varchar(512) COLLATE utf8_bin DEFAULT NULL,
  `changeTime` datetime DEFAULT NULL,
  `version` int(10) DEFAULT NULL,
  `changeAction` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_hist_source_id` (`sourceId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
