alter table h_biz_query_condition add (filterType varchar2(10) null);
comment on column h_biz_query_condition.filterType is '查询条件筛选类型';

ALTER TABLE h_biz_query_present ADD (options CLOB DEFAULT NULL);
comment on column h_biz_query_present.options is '额外配置参数';
