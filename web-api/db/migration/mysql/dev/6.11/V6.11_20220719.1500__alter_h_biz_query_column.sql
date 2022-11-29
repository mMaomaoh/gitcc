alter table h_biz_query_column add visible bit default true null comment '是否显示';

update h_biz_query_column set visible = true where visible is null;