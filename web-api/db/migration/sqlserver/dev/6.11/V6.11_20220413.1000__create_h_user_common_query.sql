create table h_user_common_query (
  id nvarchar(120) NOT NULL PRIMARY KEY,
  name	nvarchar(100),
  type	nvarchar(40),
  schemaCode nvarchar(40) ,
  queryCode nvarchar(40) ,
  userId nvarchar(36) ,
  sort	smallint,
  patientia bit,
  createdTime datetime,
  modifiedTime datetime,
  queryCondition ntext
)
go

CREATE  INDEX index_common_query_s_u
ON h_user_common_query (
  schemaCode ,userId
)
GO
