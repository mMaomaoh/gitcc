alter table h_biz_data_track_detail add code varchar2(40);
comment on column h_biz_data_track_detail.code is '留痕字段编码';

create table h_biz_data_track_child (
  id varchar2(120) not null primary key,
  detailId	varchar2(120),
  schemaCode	varchar2(40),
  beforeValue clob,
  afterValue  clob,
  modifiedProperties clob,
  sortKey	number(25,8),
  operationType varchar2(40)
);
CREATE INDEX index_track_child_s_u ON h_biz_data_track_child (detailId,operationType);