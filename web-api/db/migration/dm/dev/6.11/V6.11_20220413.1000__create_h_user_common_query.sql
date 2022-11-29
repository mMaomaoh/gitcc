create table h_user_common_query (
  id varchar2(120) not null primary key,
  name	varchar2(100)	not null,
  type	varchar2(40)not null,
  schemaCode varchar2(40) not null,
  queryCode  varchar2(40) not null,
  userId varchar2(36) not null,
  sort	NUMBER(5) not null,
  patientia number(1, 0) default 0 not null,
  createdTime timestamp,
  modifiedTime timestamp,
  queryCondition CLOB
);
CREATE INDEX index_common_query_s_u ON h_user_common_query (schemaCode,userId);
