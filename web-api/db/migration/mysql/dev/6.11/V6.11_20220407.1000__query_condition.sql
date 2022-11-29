ALTER TABLE  h_biz_query_condition ADD COLUMN filterType varchar(10)  NULL DEFAULT NULL COMMENT '查询条件筛选类型';

ALTER TABLE h_biz_query_present ADD COLUMN options longtext NULL COMMENT '额外配置参数';