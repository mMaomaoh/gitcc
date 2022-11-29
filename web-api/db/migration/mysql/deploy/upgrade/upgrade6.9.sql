CREATE TABLE `h_workflow_admin` (
  `id` varchar(120) NOT NULL,
  `createdTime` datetime(0) NULL DEFAULT NULL,
  `creater` varchar(120) DEFAULT NULL,
  `deleted` bit(1) DEFAULT NULL,
  `modifiedTime` datetime(0) DEFAULT NULL,
  `modifier` varchar(120) DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `adminType` varchar(120) DEFAULT NULL COMMENT '授权范围',
  `workflowCode` varchar(200) DEFAULT NULL COMMENT '流程编码',
  `manageScope` varchar(512) DEFAULT NULL COMMENT '流程运维范围',
  `options` longtext COMMENT '扩展参数',
  PRIMARY KEY (`id`),
  KEY `idx_work_admin_workflowCode` (`workflowCode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE `h_workflow_admin_scope`  (
  `id` varchar(120) NOT NULL,
  `createdTime` datetime(0) DEFAULT NULL,
  `creater` varchar(120) DEFAULT NULL,
  `deleted` bit(1) DEFAULT NULL,
  `modifiedTime` datetime(0) DEFAULT NULL,
  `modifier` varchar(120) DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `adminId` varchar(120) DEFAULT NULL,
  `unitType` varchar(10) DEFAULT NULL,
  `unitId` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `idx_workflow_adminId`(`adminId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
ALTER TABLE biz_workitem ADD COLUMN workItemSource  varchar(120) NULL COMMENT '任务来源';

ALTER TABLE biz_workitem_finished ADD COLUMN workItemSource  varchar(120) NULL COMMENT '任务来源';
CREATE TABLE `h_system_sms_template` (
    `id` varchar(120) NOT NULL,
    `type` varchar(20) NOT NULL COMMENT '1待办、2催办、3事件通知',
    `code` varchar(20) NOT NULL COMMENT '模板编码',
    `name` varchar(40) NOT NULL COMMENT '模板名称',
    `content` text NOT NULL COMMENT '模板内容',
    `params` longtext DEFAULT NULL COMMENT '参数说明',
    `enabled` bit(1) DEFAULT NULL COMMENT '是否启用',
    `defaults` bit(1) DEFAULT NULL COMMENT '是否默认',
    `remarks` varchar(200) DEFAULT NULL COMMENT '备注',
    `deleted` bit(1) DEFAULT NULL COMMENT '是否删除',
    `creater` varchar(120) DEFAULT NULL,
    `createdTime` datetime DEFAULT NULL,
    `modifier` varchar(120) DEFAULT NULL,
    `modifiedTime` datetime DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `UK_code` (`code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `h_system_sms_template` VALUES ('2c928ff67de11137017de119dec601c2', 'TODO', 'Todo', '默认待办通知', '您有新的流程待处理，流程标题：${name}，请及时处理！', '[{\"key\":\"name\",\"value\":\"\"}]', b'1', b'1', NULL, b'0', NULL, NULL, NULL, NULL);
INSERT INTO `h_system_sms_template` VALUES ('2c928ff67de11137017de11d5b3001c4', 'URGE', 'Remind', '默认催办通知', '您的流程任务被人催办，流程标题：${name}，催办人${creater}，请及时处理！', '[{\"key\":\"name\",\"value\":\"流程的标题\"},{\"key\":\"creater\",\"value\":\"流程发起人\"}]', b'1', b'1', NULL, b'0', NULL, NULL, NULL, NULL);
INSERT INTO `h_system_setting` VALUES ('c82a2b8d5d5c11ecb2370242ac110005', 'sms.todo.switch', 'false', 'SMS_CONF', b'1', null);
INSERT INTO `h_system_setting` VALUES ('c82d39a85d5c11ecb2370242ac110006', 'sms.urge.switch', 'false', 'SMS_CONF', b'1', null);
ALTER TABLE h_biz_export_task ADD COLUMN fileSize int(11) NULL COMMENT '文件大小';

ALTER TABLE h_biz_schema ADD COLUMN modelType varchar(40) NULL DEFAULT NULL COMMENT '模型类型 LIST/TREE';
ALTER TABLE h_im_message ADD COLUMN smsParams longtext NULL COMMENT '短信模板参数';
ALTER TABLE h_im_message ADD COLUMN smsCode varchar(50) NULL COMMENT '短信模板编码';
ALTER TABLE h_im_message_history ADD COLUMN smsParams longtext NULL COMMENT '短信模板参数';
ALTER TABLE h_im_message_history ADD COLUMN smsCode varchar(50) NULL COMMENT '短信模板编码';

ALTER TABLE h_system_pair ADD COLUMN objectId varchar(120) NULL COMMENT '数据id';
ALTER TABLE h_system_pair ADD COLUMN schemaCode varchar(40) NULL COMMENT '模型编码';
ALTER TABLE h_system_pair ADD COLUMN formCode varchar(40) NULL COMMENT '表单编码';
ALTER TABLE h_system_pair ADD COLUMN workflowInstanceId varchar(120) NULL COMMENT '流程实例ID';

ALTER TABLE h_system_pair ADD INDEX `idx_bid_fcode`(`objectId`, `formCode`);