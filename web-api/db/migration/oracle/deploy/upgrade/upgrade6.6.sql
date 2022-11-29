alter table H_BIZ_PERM_GROUP add appPermGroupId varchar2(120) ;

comment on column H_BIZ_PERM_GROUP.appPermGroupId is '关联的应用管理权限组ID';
create table h_perm_admin_group (
  id varchar(120)
		constraint h_perm_admin_group_pk
			primary key,
  creater varchar2(120 byte)  ,
  createdtime date  ,
  deleted number(1)  ,
  modifier varchar2(120 byte)  ,
  modifiedtime date  ,
  remarks varchar2(200 byte)  ,
  departmentsJson CLOB  ,
  appPackagesJson CLOB  ,
  name varchar2(50 byte)  ,
  adminId varchar(120)
  );

ALTER TABLE h_perm_admin ADD roleManage NUMBER(1);
comment ON COLUMN h_perm_admin.roleManage IS '角色管理权限';
UPDATE h_perm_admin SET roleManage = 1 WHERE adminType IN ('SYS_MNG', 'ADMIN');

create table h_report_datasource_permission
(
	id varchar(36) primary key,
   creater              varchar2(120),
   createdTime          date,
   modifier             varchar2(120) ,
   modifiedTime         date,
   remarks              varchar2(256),
   objectId             varchar2(64),
   userScope            CLOB,
   ownerId              varchar2(32),
   nodeType             number(1)
);

create unique index uq_object_id
	on h_report_datasource_permission (objectId);
create table h_biz_batch_update_record (
  id varchar(36) primary key,
  schemaCode varchar2(40)  ,
  propertyCode varchar2(200)  ,
  userId varchar2(36),
  modifiedTime date,
  propertyName varchar2(200),
  total NUMBER(10,0),
  successCount NUMBER(10,0),
  failCount NUMBER(10,0),
  modifiedValue CLOB
  );

ALTER TABLE h_perm_biz_function ADD batchUpdateAble NUMBER(1);
comment ON COLUMN h_perm_biz_function.batchUpdateAble IS '批量修改';
create table h_user_common_comment (
  id varchar(36) primary key,
  createdTime date,
  creater varchar2(120),
  deleted NUMBER(1),
  modifiedTime date,
  modifier varchar2(120),
  remarks varchar2(200),
	content CLOB,
	sortKey number(11),
  userId varchar2(36)
  );
ALTER TABLE h_biz_datasource_method ADD  shared NUMBER(1) ;
ALTER TABLE h_biz_datasource_method ADD  userIds CLOB;
