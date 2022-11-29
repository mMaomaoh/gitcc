ALTER TABLE H_BIZ_SHEET ADD formSystemVersion varchar2(32);

comment on column H_BIZ_SHEET.formSystemVersion is '系统版本号' ;
alter table h_biz_property add options clob;

comment on column h_biz_property.options is '数据项属性' ;
create table h_biz_data_rule (
  id varchar(120)
		constraint h_biz_data_rule_pk
			primary key,
  creater varchar2(120)  ,
  createdtime date  ,
  deleted number(1)  ,
  modifier varchar2(120)  ,
  modifiedtime date  ,
  remarks varchar2(200)  ,
  schemaCode varchar2(40)  ,
  propertyCode varchar2(40)  ,
  options CLOB  ,
  dataRuleType varchar2(40)  ,
  checkType number(1)
);
alter table h_biz_export_task add refId varchar(200);

comment on column h_biz_export_task.refId is '附件id';

alter table h_biz_export_task add schemaCode varchar(200);

comment on column h_biz_export_task.schemaCode is '数据模型编码';

alter table h_biz_export_task add expireTime date;

comment on column h_biz_export_task.expireTime is '过期时间';
ALTER TABLE H_BIZ_SHEET ADD formTrack NUMBER(1);

comment on column H_BIZ_SHEET.formTrack is '是否开启表单留痕' ;

ALTER TABLE H_BIZ_SHEET ADD trackDataCodes CLOB;

comment on column H_BIZ_SHEET.trackDataCodes is '需要留痕的表单数据项code,用 ; 号分割' ;

update H_BIZ_SHEET set formTrack = 0 where formTrack is null or formTrack = '';


ALTER TABLE H_BIZ_SHEET_HISTORY ADD formTrack NUMBER(1);

comment on column H_BIZ_SHEET_HISTORY.formTrack is '是否开启表单留痕' ;

ALTER TABLE H_BIZ_SHEET_HISTORY ADD trackDataCodes CLOB;

comment on column H_BIZ_SHEET_HISTORY.trackDataCodes is '需要留痕的表单数据项code,用 ; 号分割' ;

update H_BIZ_SHEET_HISTORY set formTrack = 0 where formTrack is null or formTrack = '';

ALTER TABLE H_PERM_ADMIN ADD dataDictionaryManage NUMBER(1);

comment on column H_PERM_ADMIN.dataDictionaryManage is '是否有数据字典管理权限' ;

update H_PERM_ADMIN set dataDictionaryManage = 0 where dataDictionaryManage is null or dataDictionaryManage = '';


create table h_data_dictionary (
  id varchar2(120)
        constraint h_data_dictionary_pk
			primary key,
  createdTime date,
  creater varchar2(120),
  deleted number(1) ,
  modifiedTime date,
  modifier varchar2(120),
  remarks varchar2(200),
  name varchar2(50),
  code varchar2(50),
  dictionaryType varchar2(40) ,
  sortKey number(11) ,
  status number(1),
  classificationId varchar2(120)
) ;

create table h_dictionary_class (
  id varchar2(120)
        constraint h_dictionary_class_pk
			primary key,
  createdTime date,
  creater varchar2(120),
  deleted number(1) ,
  modifiedTime date,
  modifier varchar2(120),
  remarks varchar2(200),
  name varchar2(50),
  sortKey number(11)
);

CREATE TABLE h_dictionary_record (
  id varchar2(120)
          constraint h_dictionary_record_pk
			primary key,
  createdTime date,
  creater varchar2(120) ,
  deleted number(1) ,
  modifiedTime date ,
  modifier varchar2(120) ,
  remarks varchar2(200) ,
  name varchar2(50) ,
  code varchar2(50) ,
  dictionaryId varchar2(120) ,
  sortKey number(11) ,
  parentId varchar2(120) ,
  status number(1)
);

create table h_biz_data_track (
  id varchar2(120)
          constraint h_biz_data_track_pk
			primary key,
  createdTime date,
  creater varchar2(120),
  deleted number(1),
  modifiedTime date,
  modifier varchar2(120),
  remarks varchar2(200),
  title varchar2(200),
  bizObjectId varchar2(120),
  departmentId varchar2(120),
  departmentName varchar2(50),
  creatorName varchar2(50),
  schemaCode varchar2(40),
  sheetCode varchar2(40)
);

create table h_biz_data_track_detail (
  id varchar2(120)
          constraint h_biz_data_track_detail_pk
			primary key,
  createdTime date ,
  creater varchar2(120) ,
  deleted number(1) ,
  modifiedTime date ,
  modifier varchar2(120) ,
  remarks varchar2(200) ,
  trackId varchar2(120) ,
  bizObjectId varchar2(120) ,
  name varchar2(50) ,
  beforeValue CLOB ,
  afterValue CLOB ,
  type varchar2(40),
  departmentName varchar2(50),
  creatorName varchar2(50)
);
ALTER TABLE H_DICTIONARY_RECORD ADD initialUsed NUMBER(1);

comment on column H_DICTIONARY_RECORD.initialUsed is '字典数据历史使用状态' ;

update H_DICTIONARY_RECORD set initialUsed = 0 where initialUsed is null or initialUsed = '';

alter table H_BIZ_QUERY_CONDITION modify options VARCHAR2(2048);
ALTER TABLE H_BIZ_SHEET ADD draftSchemaOptionsJson CLOB;

ALTER TABLE H_BIZ_QUERY_CONDITION ADD temp_switch_column CLOB;

UPDATE H_BIZ_QUERY_CONDITION SET temp_switch_column = "TO_CLOB" (options);

COMMIT;

ALTER TABLE H_BIZ_QUERY_CONDITION DROP COLUMN options;

ALTER TABLE H_BIZ_QUERY_CONDITION RENAME COLUMN temp_switch_column TO options;

comment on column H_BIZ_QUERY_CONDITION.options is '下拉选项' ;
