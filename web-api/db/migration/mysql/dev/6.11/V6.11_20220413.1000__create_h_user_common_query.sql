CREATE TABLE if not exists `h_user_common_query` (
  `id` varchar(120) NOT NULL COMMENT '主键id',
  `name` varchar(100) DEFAULT NULL COMMENT '名字',
  `type` varchar(40) CHARACTER SET utf8 NOT NULL DEFAULT 'VIEW_QUERY' COMMENT '类型 VIEW_QUERY:视图查询 VIEW_EXPORT_QUERY:视图导出查询 ',
  `schemaCode` varchar(40) NOT NULL COMMENT '模型编码',
  `queryCode` varchar(40) NOT NULL COMMENT '需要查询对象的code',
  `userId` varchar(36) NOT NULL COMMENT '用户ID',
  `sort` smallint(6) DEFAULT '0' COMMENT '序列号',
  `patientia` bit(1) DEFAULT 0 COMMENT '是否默认 1：默认 0：非默认',
  `createdTime` datetime NOT NULL COMMENT '创建时间',
  `modifiedTime` datetime DEFAULT NULL COMMENT '更新时间',
  `queryCondition` text DEFAULT NULL COMMENT '查询条件',
  KEY `index_common_query_s_u` (`schemaCode`,`userId`) USING BTREE COMMENT '用户常用查询schemaCode_userId索引'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户常用查询条件';
