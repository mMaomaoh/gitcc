CREATE TABLE `h_im_message_station` (
  `id` varchar(36) NOT NULL COMMENT '主键ID',
  `bizParams` longtext COMMENT '业务参数表',
  `content` longtext COMMENT '内容',
  `createdTime` datetime DEFAULT NULL COMMENT '创建时间',
  `messageType` varchar(40) DEFAULT NULL COMMENT '消息类型，STATION_MESSAGE-站内消息；COMMENT_MESSAGE-评论消息',
  `modifiedTime` datetime DEFAULT NULL COMMENT '修改时间',
  `title` varchar(100) DEFAULT NULL COMMENT '标题',
  `sender` varchar(42) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '消息关联的发起人',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_message_station_id` (`id`) USING BTREE
) ENGINE=InnoDB COMMENT='站内消息表';

CREATE TABLE `h_im_message_station_user` (
  `id` varchar(36)  NOT NULL COMMENT '主键ID',
  `modifiedTime` datetime DEFAULT NULL COMMENT '修改时间',
  `receiver` varchar(42)  DEFAULT NULL COMMENT '接收者',
  `messageId` varchar(36)  DEFAULT NULL COMMENT '消息id',
  `readState` varchar(255)  DEFAULT NULL COMMENT 'READED-已读、UNREADED-未读',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_message_station_id` (`id`) USING BTREE,
  KEY `idx_receiver` (`receiver`),
  KEY `idx_readState` (`readState`)
) ENGINE=InnoDB COMMENT='站内消息用户关系表';

