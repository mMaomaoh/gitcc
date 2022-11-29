-- 附件表 （最近一次交易签名 使用）
ALTER TABLE h_biz_attachment ADD deleted bit NULL DEFAULT 1;
ALTER TABLE h_user_favorites ALTER COLUMN appCode nvarchar(512) COLLATE Chinese_PRC_CI_AS NULL
GO

ALTER TABLE h_user_favorites ALTER COLUMN bizObjectType nvarchar(512) COLLATE Chinese_PRC_CI_AS NULL
GO
ALTER TABLE h_perm_admin_group ADD externalLinkVisible bit NOT NULL DEFAULT 1;
GO
ALTER TABLE h_app_package ADD fromAppMarket bit;
-- 视图多模型查询
ALTER TABLE h_biz_query_present ADD queryViewDataSource ntext
go
ALTER TABLE h_biz_query_present ADD schemaRelations ntext
go

ALTER TABLE h_biz_query_column ADD schemaAlias nvarchar(100)
go
ALTER TABLE h_biz_query_column ADD propertyAlias nvarchar(100)
go
ALTER TABLE h_biz_query_column ADD queryLevel int DEFAULT 1 NULL
go

update h_biz_query_column set schemaAlias = schemaCode where schemaAlias is null
go
update h_biz_query_column set propertyAlias = propertyCode where propertyAlias is null
go
alter table h_open_api_event add options ntext;
go
alter table h_biz_datasource_method add inputParamConfig ntext;
go
ALTER TABLE biz_workflow_instance ADD source nvarchar(255);
go
ALTER TABLE biz_workflow_instance_bak ADD source nvarchar(255);
go
