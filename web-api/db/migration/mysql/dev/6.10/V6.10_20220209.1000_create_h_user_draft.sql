CREATE TABLE `h_user_draft` (
  `id` varchar(120) NOT NULL,
  `creater` varchar(120) DEFAULT NULL,
  `createdTime` datetime DEFAULT NULL,
  `deleted` bit(1) DEFAULT NULL,
  `modifier` varchar(120) DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `userId` varchar(100) NOT NULL COMMENT '用户ID',
  `name` varchar(200) NOT NULL COMMENT '标题【流程名称或者表单标题】',
  `bizObjectKey` varchar(100) DEFAULT NULL COMMENT 'BO数据对象ID',
  `formType` varchar(100) DEFAULT NULL COMMENT '表单类型：MODEL、WORKFLOW、WORKITEM',
  `workflowInstanceId` varchar(100) DEFAULT NULL COMMENT '流程实例ID',
  `schemaCode` varchar(100) DEFAULT NULL COMMENT '模型编码',
  `sheetCode` varchar(100) DEFAULT NULL COMMENT '表单编码',
  PRIMARY KEY (`id`),
  KEY `idx_user_draft_userId` (`userId`),
  KEY `idx_user_draft_objectKey` (`bizObjectKey`) USING BTREE
) ENGINE=InnoDB COMMENT='用户草稿';
