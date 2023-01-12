CREATE TABLE `h_biz_import_task` (
    `id` varchar(36) COLLATE utf8_bin NOT NULL COMMENT 'primary key',
    `importTime` datetime DEFAULT NULL COMMENT '导入时间',
    `startTime` datetime DEFAULT NULL COMMENT '开始时间',
    `endTime` datetime DEFAULT NULL COMMENT '结束时间',
    `userId` varchar(36) COLLATE utf8_bin DEFAULT NULL COMMENT '用户id',
    `schemaCode` varchar(50) COLLATE utf8_bin DEFAULT NULL COMMENT '模型编码',
    `taskStatus` varchar(50) COLLATE utf8_bin DEFAULT NULL COMMENT '任务状态',
    `lastHeartTime` datetime DEFAULT NULL COMMENT '最近一次心跳时间',
    `threadName` varchar(150) COLLATE utf8_bin DEFAULT NULL COMMENT '任务执行线程',
    `operationResultJson` longtext COMMENT '导入操作结果',
    `originalFilename` longtext COMMENT '文件名',
    PRIMARY KEY (`id`),
    KEY `idx_h_biz_import_task_userId` (`userId`) USING BTREE,
    KEY `idx_h_biz_import_task_schemaCode` (`schemaCode`) USING BTREE,
    KEY `idx_h_biz_import_task_threadName` (`threadName`) USING BTREE,
    KEY `idx_h_biz_import_task_heart` (`lastHeartTime`,`taskStatus`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;