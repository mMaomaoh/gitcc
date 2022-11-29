alter table h_biz_data_track_detail add code nvarchar(40)
GO

create table h_biz_data_track_child (
  id nvarchar(120) NOT NULL PRIMARY KEY,
  detailId	nvarchar(100),
  schemaCode	nvarchar(40),
  beforeValue ntext,
  afterValue ntext,
  modifiedProperties ntext,
  sortKey	decimal(25,8),
  operationType nvarchar(40)
)
go

CREATE  INDEX index_track_child_s_u
ON h_biz_data_track_child (
  detailId ,operationType
)
GO