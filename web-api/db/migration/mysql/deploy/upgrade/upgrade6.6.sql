alter table h_biz_perm_group add appPermGroupId varchar(120) null comment '关联的应用管理权限组ID';
CREATE TABLE `h_perm_admin_group` (
  `id` varchar(120) NOT NULL,
  `createdTime` datetime DEFAULT NULL,
  `creater` varchar(120) DEFAULT NULL,
  `deleted` bit(1) DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `modifier` varchar(120) DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `departmentsJson` longtext,
  `name` varchar(50) DEFAULT NULL,
  `appPackagesJson` longtext,
  `adminId` varchar(120) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

ALTER TABLE h_perm_admin ADD COLUMN roleManage bit(1) comment '角色管理权限';
UPDATE h_perm_admin SET roleManage = TRUE WHERE adminType IN ('SYS_MNG', 'ADMIN');
create table h_report_datasource_permission
(
   id                   varchar(32) not null,
   creater              varchar(32) default NULL,
   createdTime          datetime default NULL,
   modifier             varchar(32) default NULL,
   modifiedTime         datetime default NULL,
   remarks              varchar(256) default NULL,
   objectId             varchar(64) comment '数据流节点',
   userScope            longtext comment '用户使用范围',
   ownerId              varchar(32),
   nodeType             bit comment '节点类型',
   primary key (id)
)
ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE = utf8_bin;

alter table h_report_datasource_permission comment '报表高级数据源权限设置';

/*==============================================================*/
/* Index: uq_object_id                                          */
/*==============================================================*/
create unique index uq_object_id on h_report_datasource_permission
(
   objectId
);
DROP TABLE IF EXISTS `h_biz_batch_update_record`;
CREATE TABLE `h_biz_batch_update_record`  (
  `id` varchar(36) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `schemaCode` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `propertyCode` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `userId` varchar(36) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `modifiedTime` datetime(0) NULL DEFAULT NULL,
  `propertyName` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `total` int(10) NULL DEFAULT NULL,
  `successCount` int(10) NULL DEFAULT NULL,
  `failCount` int(10) NULL DEFAULT NULL,
  `modifiedValue` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '列表数据批量修改记录' ROW_FORMAT = Dynamic;


ALTER table h_perm_biz_function add column batchUpdateAble bit(1) default null comment '批量修改';
DROP TABLE IF EXISTS `h_user_common_comment`;
CREATE TABLE `h_user_common_comment` (
  `id` varchar(120) NOT NULL,
  `createdTime` datetime DEFAULT NULL,
  `creater` varchar(120) DEFAULT NULL,
  `deleted` bit(1) DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `modifier` varchar(120) DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `content` varchar(4000) DEFAULT NULL,
  `sortKey` int(11) DEFAULT NULL,
  `userId` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户常用意见表';
ALTER TABLE h_biz_datasource_method ADD COLUMN shared bit(1);
ALTER TABLE h_biz_datasource_method ADD COLUMN userIds longtext;
