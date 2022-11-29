alter table h_user_favorites modify bizObjectType varchar2(40);

alter table h_user_favorites modify appCode varchar2(512);
alter table h_perm_admin_group ADD externalLinkVisible NUMBER(1,0) DEFAULT (1) NOT NULL ;
comment ON COLUMN h_perm_admin_group.externalLinkVisible IS '是否可查看外链';
ALTER TABLE H_APP_PACKAGE ADD FROMAPPMARKET NUMBER(1,0);
comment ON COLUMN H_APP_PACKAGE.FROMAPPMARKET IS '是否来自应用市场';
-- 视图多模型查询
ALTER TABLE h_biz_query_present ADD (queryViewDataSource CLOB DEFAULT NULL);
comment on column h_biz_query_present.queryViewDataSource is '视图属性-数据源';
ALTER TABLE h_biz_query_present ADD (schemaRelations CLOB DEFAULT NULL);
comment on column h_biz_query_present.schemaRelations is '视图多模型查询，关联关系';

ALTER TABLE h_biz_query_column ADD (schemaAlias VARCHAR2(100 BYTE) DEFAULT NULL);
comment on column h_biz_query_column.schemaAlias is '模型编码别名';
ALTER TABLE h_biz_query_column ADD (propertyAlias VARCHAR2(100 BYTE) DEFAULT NULL);
comment on column h_biz_query_column.propertyAlias is '数据项编码别名';
ALTER TABLE h_biz_query_column ADD (queryLevel NUMBER);
comment on column h_biz_query_column.queryLevel is '查询批次 1-主表 2-子表';

update h_biz_query_column set schemaAlias = schemaCode where schemaAlias is null ;
update h_biz_query_column set propertyAlias = propertyCode where propertyAlias is null;
alter table h_open_api_event add options clob;
comment on column h_open_api_event.options is '扩展参数';
alter table h_biz_datasource_method add inputParamConfig clob;
alter table BIZ_WORKFLOW_INSTANCE add source varchar2(255);
comment on column BIZ_WORKFLOW_INSTANCE.source is '来源';

alter table BIZ_WORKFLOW_INSTANCE_BAK add source varchar2(255);
comment on column BIZ_WORKFLOW_INSTANCE_BAK.source is '来源';
