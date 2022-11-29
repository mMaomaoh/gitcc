
CREATE TABLE h_biz_button (
  id nvarchar(120) NOT NULL primary key,
  createdTime datetime  NULL,
  creater nvarchar(120)  NULL,
  deleted bit  NULL,
  remarks nvarchar(200)  NULL,
  modifiedTime datetime  NULL,
  modifier nvarchar(120)  NULL,
  schemaCode nvarchar(40)  NULL ,
  name nvarchar(200) NOT NULL,
  code nvarchar(40) NOT NULL,
  triggerCode nvarchar(40) NOT NULL,
  triggerType nvarchar(40) NOT NULL,
  showPermCode nvarchar(40) NOT NULL,
  showPermType nvarchar(40) NOT NULL,
  hint nvarchar(200),
  description ntext,
  useLocation nvarchar(40) NOT NULL,
  bindAction nvarchar(40) NOT NULL,
  operateType nvarchar(40) NOT NULL,
  targetCode nvarchar(40),
  targetObjCode nvarchar(40),
  actionConfig ntext,
  sortKey int
)
go
create unique index idx_s_code on h_biz_button(schemaCode, triggerType, triggerCode, code);
go