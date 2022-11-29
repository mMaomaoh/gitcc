alter table h_biz_query_column add visible number(1, 0) default 1;
comment on column h_biz_query_column.visible is '是否显示';

update h_biz_query_column set visible = 1 where visible is null;