alter table H_APP_PACKAGE
    add groupId varchar(120) ;

comment on column H_APP_PACKAGE.groupId is '应用分组id' ;
create table h_app_group (
  id varchar(120)
		constraint h_app_group_pk
			primary key,
  creater varchar2(120 )  ,
  createdtime date  ,
  deleted number(1)  ,
  modifier varchar2(120 )  ,
  modifiedtime date  ,
  remarks varchar2(200 )  ,
  code varchar2(40 )  ,
  disabled number(1)  ,
  name varchar2(50 )  ,
  sortkey number  ,
  name_i18n varchar2(1000 )
);


INSERT INTO h_app_group (
 id, creater, createdtime, deleted, modifier, modifiedtime, remarks, code, disabled, name, sortkey, name_i18n
)
VALUES
	(
	'2c928fe6785dbfbb01785dc6277a0d0',
	NULL,
	TO_DATE( '2021-04-16 15:48:25', 'SYYYY-MM-DD HH24:MI:SS' ),
	'0',
	NULL,
	TO_DATE( '2021-04-16 15:48:36', 'SYYYY-MM-DD HH24:MI:SS' ),
	NULL,
	'default',
	NULL,
	'默认',
	'1',
NULL 
	); 
INSERT INTO h_app_group (
 id, creater, createdtime, deleted, modifier, modifiedtime, remarks, code, disabled, name, sortkey, name_i18n
)
VALUES
	(
	'2c928fe6785dbfbb01785dc6277a0d1',
	NULL,
	TO_DATE( '2021-04-26 15:48:25', 'SYYYY-MM-DD HH24:MI:SS' ),
	'0',
	NULL,
	TO_DATE( '2021-04-26 15:48:36', 'SYYYY-MM-DD HH24:MI:SS' ),
	NULL,
	'all',
	NULL,
	'全部',
	'0',
NULL
	);

update h_app_package set groupId='2c928fe6785dbfbb01785dc6277a0000' where groupId is null or groupId='';
-- auto-generated definition
create table H_ORG_DIRECT_MANAGER
(
    ID             VARCHAR2(120) not null
        constraint H_ORG_DIRECT_MANAGER_PK
            primary key,
    createdTime  DATE default current_timestamp,
    CREATER        VARCHAR2(120),
    modifiedTime DATE,
    MODIFIER       VARCHAR2(120),
    REMARKS        VARCHAR2(200),
    userId       VARCHAR2(36)  not null,
    deptId       VARCHAR2(36)  not null,
    managerId    VARCHAR2(36)  not null
);

comment on table H_ORG_DIRECT_MANAGER is '直属主管配置表';

comment on column H_ORG_DIRECT_MANAGER.createdTime is '创建时间';

comment on column H_ORG_DIRECT_MANAGER.CREATER is '创建人';

comment on column H_ORG_DIRECT_MANAGER.modifiedTime is '修改时间';

comment on column H_ORG_DIRECT_MANAGER.MODIFIER is '修改人';

comment on column H_ORG_DIRECT_MANAGER.REMARKS is '备注';

comment on column H_ORG_DIRECT_MANAGER.userId is '用户编号';

comment on column H_ORG_DIRECT_MANAGER.deptId is '部门编号';

comment on column H_ORG_DIRECT_MANAGER.managerId is '直属主管编号';

create unique index UQ_DIRECT_USER_DEPT
    on H_ORG_DIRECT_MANAGER (userId, deptId);

ALTER TABLE H_BIZ_SHEET ADD printJson CLOB;

comment on column H_BIZ_SHEET.printJson is '打印模板json' ;
