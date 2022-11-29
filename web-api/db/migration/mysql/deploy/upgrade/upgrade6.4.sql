alter table h_app_package
	add groupId varchar(120) null comment '应用分组id';
DROP TABLE IF EXISTS `h_app_group`;
CREATE TABLE `h_app_group`  (
  `id` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `createdTime` datetime(0) NULL DEFAULT NULL,
  `creater` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `deleted` bit(1) NULL DEFAULT NULL,
  `modifiedTime` datetime(0) NULL DEFAULT NULL,
  `modifier` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `remarks` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `code` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `disabled` bit(1) NULL DEFAULT NULL,
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `sortKey` int(11) NULL DEFAULT NULL,
  `name_i18n` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '双语言',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;


INSERT INTO `h_app_group`(`id`, `createdTime`, `creater`, `deleted`, `modifiedTime`, `modifier`, `remarks`, `code`, `disabled`, `name`, `sortKey`, `name_i18n`) VALUES ('2c928fe6785dbfbb01785dc6277a0000', '2021-03-23 14:29:31', '2c9280a26706a73a016706a93ccf002b', b'0', '2021-03-23 14:29:31', NULL, NULL, 'default', NULL, '默认', 1, NULL);
INSERT INTO `h_app_group`(`id`, `createdTime`, `creater`, `deleted`, `modifiedTime`, `modifier`, `remarks`, `code`, `disabled`, `name`, `sortKey`, `name_i18n`) VALUES ('2c928fe6785dbfbb01785dc6277a0001', '2021-04-26 17:50:31', '2c9280a26706a73a016706a93ccf002b', b'0', '2021-04-26 17:50:31', NULL, NULL, 'all', NULL, '全部', 0, NULL);

update h_app_package set groupId='2c928fe6785dbfbb01785dc6277a0000' where groupId is null or groupId='';
create table h_org_direct_manager
(
    id           varchar(120)                           not null
        primary key,
    createdTime  datetime     default CURRENT_TIMESTAMP null comment '创建时间',
    creater      varchar(120) default ''                null comment '创建人',
    modifiedTime datetime     default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP comment '修改时间',
    modifier     varchar(120) default ''                null comment '修改人',
    remarks      varchar(200) default ''                null comment '备注',
    userId       varchar(36)  default ''                not null comment '用户id',
    deptId       varchar(36)  default ''                not null comment '部门id',
    managerId    varchar(36)  default ''                not null comment '直属主管id',
    constraint uq_direct_user_dept
        unique (userId, deptId)
)
    comment '直属主管配置表';
ALTER TABLE h_biz_sheet ADD COLUMN printJson longtext comment '打印模板json';
