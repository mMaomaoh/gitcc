create table h_user_common_query (
  id varchar2(120) primary key not null,
  name	varchar2(100)	not null,
  type	varchar2(40)    not null,
  schemaCode varchar2(40) not null,
  queryCode  varchar2(40) not null,
  userId varchar2(36) not null,
  sort	NUMBER(5) not null,
  patientia number(1, 0) default 0 not null,
  createdTime date,
  modifiedTime date,
  queryCondition CLOB
  );
comment on column h_user_common_query.id is 'ID';
comment on column h_user_common_query.name is '名字';
comment on column h_user_common_query.type is '类型 VIEW_QUERY:视图查询 VIEW_EXPORT_QUERY:视图导出查询';
comment on column h_user_common_query.schemaCode is '模型编码';
comment on column h_user_common_query.queryCode is '需要查询对象的code';
comment on column h_user_common_query.userId is '用户ID';
comment on column h_user_common_query.sort is '排序号';
comment on column h_user_common_query.patientia is '是否默认 1：默认 0：非默认';
comment on column h_user_common_query.createdTime is '创建的时间';
comment on column h_user_common_query.modifiedTime is '更新时间';
comment on column h_user_common_query.queryCondition is '查询条件';

CREATE INDEX index_common_query_s_u ON h_user_common_query (schemaCode,userId);
