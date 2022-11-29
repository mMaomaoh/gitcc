alter table h_biz_perm_group add appPermGroupId varchar(120) null;
go
create table h_perm_admin_group
(
    id           nvarchar(120) not null
        primary key,
    createdTime  datetime,
    creater      nvarchar(120),
    deleted      bit,
    modifiedTime datetime,
    modifier     nvarchar(120),
    remarks      nvarchar(200),
    appCode      nvarchar(40),
    departmentsJson  ntext,
    name         nvarchar(50),
    appPackagesJson        ntext,
    adminId   nvarchar(120)
)
go
alter table h_perm_admin add roleManage bit null;
GO
update h_perm_admin set roleManage = 1 where adminType in ('SYS_MNG', 'ADMIN');
create table h_report_datasource_permission
(
       id           nvarchar(120) not null
        primary key,
   creater              nvarchar(120),
   createdTime          datetime,
   modifier             nvarchar(120) ,
   modifiedTime         datetime,
   remarks              nvarchar(256),
   objectId             nvarchar(64),
   userScope            ntext,
   ownerId              nvarchar(32),
   nodeType             bit
)
go


CREATE UNIQUE INDEX uq_object_id
   ON h_report_datasource_permission(objectId);
GO
CREATE TABLE h_biz_batch_update_record (
	id nvarchar (36) NOT NULL PRIMARY KEY,
	schemaCode nvarchar (40),
	propertyCode nvarchar (200),
	userId nvarchar (36),
	modifiedTime datetime,
	propertyName nvarchar (200),
	total INT,
	successCount INT,
	failCount INT,
	modifiedValue ntext
)
GO

ALTER TABLE h_perm_biz_function ADD batchUpdateAble bit;
go
create table h_user_common_comment (
  id nvarchar (36) NOT NULL PRIMARY KEY,
  createdTime datetime ,
  creater nvarchar(120) ,
  deleted BIT ,
  modifiedTime datetime ,
  modifier nvarchar(120) ,
  remarks nvarchar(200) ,
  content ntext ,
	sortKey INT,
  userId nvarchar(36)
)
go
ALTER TABLE h_biz_datasource_method ADD  shared bit ;
ALTER TABLE h_biz_datasource_method ADD  userIds ntext;
GO
