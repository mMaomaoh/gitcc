ALTER TABLE `h_biz_data_track_detail` ADD COLUMN `code` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '留痕字段编码' AFTER `creatorName`;

CREATE TABLE if not exists `h_biz_data_track_child` (
  `id` varchar(120) NOT NULL,
  `detailId` varchar(120) DEFAULT NULL COMMENT '留痕详情ID',
  `schemaCode` varchar(40) DEFAULT NULL COMMENT '子表模型编码',
  `beforeValue` longtext COMMENT '留痕字段新值',
  `afterValue` longtext COMMENT '留痕字段旧值',
  `modifiedProperties` longtext COMMENT '修改的字段',
  `sortKey` decimal(25,8) DEFAULT NULL COMMENT '排序号',
  `operationType` varchar(40) DEFAULT NULL COMMENT '子表操作类型：Added、Modified、Deleted',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_h_track_child_detail_op` (`detailId`,`operationType`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;