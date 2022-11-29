
CREATE TABLE `h_biz_button` (
  `id` varchar(120) NOT NULL,
  `createdTime` datetime DEFAULT NULL,
  `creater` varchar(120) DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `modifier` varchar(120) DEFAULT NULL,
  `schemaCode` varchar(40) DEFAULT NULL COMMENT '模型编码',
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '按钮名称',
  `code` varchar(40) DEFAULT NULL COMMENT '按钮编码',
  `triggerCode` varchar(40) DEFAULT NULL COMMENT '调用方编码（视图、表单）',
  `triggerType` varchar(40) DEFAULT NULL COMMENT '调用方类型（视图、表单）',
  `showPermCode` varchar(40) DEFAULT NULL COMMENT '显示权限，绑定对象编码',
  `showPermType` varchar(40) DEFAULT NULL COMMENT '显示权限，绑定对象类型',
  `hint` varchar(200) DEFAULT NULL COMMENT '移入提示',
  `description` text COMMENT '描述',
  `useLocation` varchar(40) NOT NULL COMMENT '使用位置 ',
  `bindAction` varchar(40) NOT NULL COMMENT '按钮操作',
  `operateType` varchar(40) NOT NULL COMMENT '操作类型',
  `targetCode` varchar(40) DEFAULT NULL COMMENT '目标编码',
  `targetObjCode` varchar(40) DEFAULT NULL COMMENT '目标对象编码',
  `actionConfig` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '按钮操作配置',
  `deleted` bit(1) DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL COMMENT '备注',
  `sortKey` int(8) DEFAULT NULL COMMENT '排序',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

create unique index idx_s_code on h_biz_button (schemaCode, triggerType, triggerCode, code);