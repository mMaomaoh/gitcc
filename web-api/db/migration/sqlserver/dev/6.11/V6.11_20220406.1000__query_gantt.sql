CREATE TABLE h_biz_query_gantt (
  id nvarchar(120)  NOT NULL PRIMARY KEY,
  creater nvarchar(120) ,
  createdTime datetime  ,
  deleted bit  ,
  modifier nvarchar(120) ,
  modifiedTime datetime  ,
  remarks nvarchar(200) ,
  queryId nvarchar(36) ,
  schemaCode nvarchar(40) ,
  startTimePropertyCode nvarchar(40) ,
  endTimePropertyCode nvarchar(40) ,
  configJson ntext ,
  progressPropertyCode nvarchar(40) ,
  titlePropertyCode nvarchar(40) ,
  preDependencyPropertyCode nvarchar(40) ,
  endDependencyPropertyCode nvarchar(40) ,
  levelPropertyCode nvarchar(40) ,
  milepostCode nvarchar(40) ,
  defaultPrecision nvarchar(40) ,
  sortKey nvarchar(40) ,
  liableManCode nvarchar(40) ,
  statusCode nvarchar(40)
)
GO

CREATE  INDEX Idx_schemaCode
ON h_biz_query_gantt (
  schemaCode ASC
)
GO

CREATE  INDEX Idx_queryid
ON h_biz_query_gantt (
  queryId ASC
)
GO
