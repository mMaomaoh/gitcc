ALTER TABLE h_user_favorites
MODIFY COLUMN bizObjectType varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
MODIFY COLUMN appCode varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL;
ALTER TABLE h_perm_admin_group ADD externalLinkVisible bit(1) NOT NULL DEFAULT TRUE COMMENT '是否可查看外链';
ALTER TABLE h_app_package ADD fromAppMarket bit(1) COMMENT '是否来自应用市场';
-- 视图多模型查询

ALTER TABLE h_biz_query_present
ADD COLUMN queryViewDataSource longtext NULL COMMENT '视图属性-数据源' AFTER columnsJson,
ADD COLUMN schemaRelations longtext NULL COMMENT '视图多模型查询，关联关系' AFTER queryViewDataSource;

ALTER TABLE h_biz_query_column
ADD COLUMN schemaAlias varchar(100)  NULL DEFAULT NULL COMMENT '模型编码别名' AFTER clientType,
ADD COLUMN propertyAlias varchar(100) NULL DEFAULT NULL COMMENT '数据项编码别名' AFTER schemaAlias,
ADD COLUMN queryLevel int(4) NULL DEFAULT 1 COMMENT '查询批次 1-主表 2-子表' AFTER propertyAlias;

update h_biz_query_column set schemaAlias = schemaCode where schemaAlias is null ;
update h_biz_query_column set propertyAlias = propertyCode where propertyAlias is null;
ALTER TABLE h_open_api_event
ADD COLUMN options longtext NULL COMMENT '扩展参数' AFTER eventType;
alter table h_biz_datasource_method add inputParamConfig text null;
ALTER TABLE biz_workflow_instance
ADD COLUMN source varchar(255) NULL COMMENT '来源';

ALTER TABLE biz_workflow_instance_bak
ADD COLUMN source varchar(255) NULL COMMENT '来源';
