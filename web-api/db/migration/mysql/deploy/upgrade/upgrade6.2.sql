UPDATE h_org_role SET corpId='main' WHERE roleType='SYS';
create unique index uq_schemaCode_code on h_biz_property (schemaCode, code);
alter table h_perm_admin
    add appManage bit null comment '是否拥有创建应用的权限';
alter table h_related_corp_setting
    add enabled bit null comment '是否禁用';
alter table h_org_user
    add enabled bit null comment '是否禁用';
alter table h_org_department
    add enabled bit null comment '是否禁用';
update h_related_corp_setting set enabled = 1 where id != '';
update h_org_user set enabled = 1 where id != '';
update h_org_department set enabled = 1 where id != '';
CREATE TABLE IF NOT EXISTS `h_biz_sheet_history` (
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
 `externalLinkAble` bit(1) DEFAULT NULL,
 `name_i18n` varchar(1000) DEFAULT NULL,
 `draftHtmlJson` longtext DEFAULT NULL,
 `publishedHtmlJson` longtext DEFAULT NULL,
 `draftActionsJson` longtext DEFAULT NULL,
 `publishedActionsJson` longtext DEFAULT NULL,
 `shortCode` varchar(50) DEFAULT NULL,
 `printTemplateJson` varchar(1000) DEFAULT NULL,
 `qrCodeAble` varchar(40) DEFAULT NULL,
 `tempAuthSchemaCodes` varchar(3500) DEFAULT NULL,
 `borderMode` varchar(10) DEFAULT NULL,
 `layoutType` varchar(20) DEFAULT NULL,
 `formComment` bit(1) DEFAULT NULL,
 `pdfAble` varchar(40) DEFAULT NULL,
 `publishBy` varchar(120) DEFAULT NULL,
 `version` int(20) DEFAULT 1,
 PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
ALTER table h_biz_query_action add column extend1 varchar(100) default null;

