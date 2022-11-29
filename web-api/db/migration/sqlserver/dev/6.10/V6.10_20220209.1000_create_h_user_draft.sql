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