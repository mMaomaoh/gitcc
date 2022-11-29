alter table h_biz_query_column add visible bit default 1
go
update h_biz_query_column set visible = 1 where visible is null
go