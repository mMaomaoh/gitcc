ALTER TABLE h_im_work_record ALTER COLUMN title nvarchar(200) NULL
GO
ALTER TABLE h_im_work_record_history ALTER COLUMN title nvarchar(200) NULL
GO
ALTER TABLE h_im_message ALTER COLUMN title nvarchar(200) NULL
GO
ALTER TABLE h_im_message_history ALTER COLUMN title nvarchar(200) NULL
GO
ALTER TABLE h_biz_data_track_detail ADD title nvarchar(200) NULL
go
ALTER TABLE h_biz_query_condition ADD includeSubData bit NULL
go
create table h_user_draft (
	id nvarchar(120) NOT NULL PRIMARY KEY,
	creater nvarchar(120),
	createdTime datetime,
	deleted bit,
	modifier nvarchar(120),
	modifiedTime datetime,
	remarks nvarchar(200),
	userId nvarchar(100),
	name nvarchar(200),
	bizObjectKey nvarchar(100),
	formType nvarchar(100),
	workflowInstanceId nvarchar(100),
	schemaCode nvarchar(100),
	sheetCode nvarchar(100)
)
go

create index idx_user_draft_userId on h_user_draft (userId)
go
create index idx_user_draft_objectKey on h_user_draft (bizObjectKey)
go
ALTER TABLE biz_workflow_instance ADD workflowName nvarchar(255);
go

ALTER TABLE biz_workflow_instance_bak ADD workflowName nvarchar(255);
go
ALTER TABLE h_biz_query_column ADD syncDefaultFormat bit NULL
go
create table h_im_message_station (
  id nvarchar(36) NOT NULL PRIMARY KEY,
  bizParams ntext,
  content ntext,
  createdTime datetime,
  messageType nvarchar(40),
  modifiedTime datetime,
  title nvarchar(100),
  sender nvarchar(42)
)
go

create table h_im_message_station_user (
  id nvarchar(36)  NOT NULL PRIMARY KEY,
  modifiedTime datetime,
  receiver nvarchar(42),
  messageId nvarchar(36),
  readState nvarchar(255)
)
go

create index idx_receiver on h_im_message_station_user (receiver)
go
create index idx_readState on h_im_message_station_user (readState)
go

-- 树形-批量向模型表中添加treePath_、treeLevel_字段
DROP PROCEDURE IF EXISTS addTreePathParam;
go
-- 1.创建存储过程
CREATE PROCEDURE addTreePathParam as
		DECLARE @vSchemaCode varchar(50)
		DECLARE @vTableName varchar(100)
		DECLARE @vAlterSQL varchar(500)
		DECLARE @nCount int
		DECLARE @nCount2 int

		DECLARE taskCursor CURSOR FOR select code from h_biz_schema where modelType = 'TREE' and published=1;
		open taskCursor
		fetch next from taskCursor into @vSchemaCode
		while(@@fetch_status = 0)
			BEGIN
					 select @vTableName = ('i' + appNameSpace + '_' + @vSchemaCode)  from h_app_package where code = (select appCode from h_app_function where code = @vSchemaCode);
					 if @vTableName is not null
							 BEGIN
										select @nCount = count(0)  from h_biz_property where schemaCode = @vSchemaCode and code = 'treePath_';
										if @nCount = 0
												BEGIN
														set @vAlterSQL = 'alter table ' + @vTableName +' add treePath_ varchar(200) default null'
														print '    execute start---> ' + @vAlterSQL
														execute (@vAlterSQL)
														print '    execute end  <--- '
														INSERT INTO h_biz_property (id, createdTime, deleted, code,defaultProperty, name, propertyEmpty,  propertyIndex, propertyLength, propertyType, published, schemaCode)
														VALUES (replace(newId(), '-', ''), getdate(), 0, 'treePath_', 0, '路径', 0, 0, 512, 'SHORT_TEXT', 1, @vSchemaCode);
												END
										select @nCount2 = count(0)  from h_biz_property where schemaCode = @vSchemaCode and code = 'treeLevel_';
										if @nCount2 = 0
												BEGIN
														set @vAlterSQL = 'alter table ' + @vTableName +' add treeLevel_ decimal(20,8) default 1'
														print '    execute start---> ' + @vAlterSQL
														execute (@vAlterSQL)
														print '    execute end  <--- '
														INSERT INTO h_biz_property (id, createdTime, deleted, code,defaultProperty, name, propertyEmpty,  propertyIndex, propertyLength, propertyType, published, schemaCode)
														VALUES (replace(newId(), '-', ''), getdate(), 0, 'treeLevel_', 0, '层级', 0, 0, 12, 'NUMERICAL', 1, @vSchemaCode);

												END
							 END
			fetch next from taskCursor into @vSchemaCode
			END

	 close taskCursor
	 deallocate taskCursor
go

-- 3.执行
EXEC addTreePathParam
go
-- 4.删除
DROP PROCEDURE IF EXISTS addTreePathParam
go

alter table h_org_user add userWorkStatus varchar(32) null
go
update h_org_user set userWorkStatus  = 'NORMAL' where deleted = 0
go
update h_org_user set userWorkStatus  = 'DIMISSION' where deleted = 1
go

create table h_org_user_transfer_record
(
    id              nvarchar(120)  not null primary key,
    processUserId   nvarchar(120)  null,
    processTime     datetime      null,
    sourceUserId    nvarchar(120)  null,
    receiveUserId   nvarchar(120)  null,
    transferType    nvarchar(32)   null,
    transferSize    int           null,
    comments         nvarchar(2048) null
)
go

create table h_org_user_transfer_detail
(
    id           nvarchar(120) not null primary key,
    recordId     nvarchar(120) not null,
    transferData ntext         null
)
go

create index idx_record_id on h_org_user_transfer_detail (recordId)
go

update h_system_sms_template set params = '[{"key":"name","value":""}]' where id = '2c928ff67de11137017de119dec601c2';
update h_system_sms_template set params = '[{"key":"name","value":"流程的标题"},{"key":"creater","value":"流程发起人"}]' where id = '2c928ff67de11137017de11d5b3001c4';

alter table h_biz_sheet add existDraft BIT default 1;
go

update  h_biz_schema set deleted = 1 where code in (select code from h_app_function where deleted = 1 and type = 'BizModel')
go
create unique index uq_corpId_sourceId on h_org_department (corpId, sourceId)
go
create unique index uq_corpId_sourceId on h_org_role (corpId, sourceId)
go
create unique index uq_role_code on h_org_role (code)
go
create unique index uq_role_group_code on h_org_role_group (code)
go
create index idx_corpId_userId on h_org_user (userId,corpId)
go
create index idx_dept_id on h_org_dept_user (deptId)
go

ALTER TABLE h_user_favorites ALTER COLUMN bizObjectKey nvarchar(200) COLLATE Chinese_PRC_CI_AS NULL
go

ALTER TABLE h_org_user  ALTER COLUMN imgUrlId nvarchar(200) ;
ALTER TABLE h_app_package  ALTER COLUMN logoUrlId nvarchar(200)  ;
go

ALTER TABLE h_biz_attachment ALTER COLUMN bizObjectId nvarchar(200) NOT NULL
go