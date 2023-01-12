alter table h_biz_data_track add sourceSchemaCode varchar(50) null comment '源模型编码';
alter table h_biz_data_track add sourceSchemaName varchar(200) null comment '源模型名称';
alter table h_biz_data_track add sourceBizObjectId varchar(50) null comment '源触发数据id';
alter table h_biz_data_track add sourceBizObjectName varchar(200) null comment '源触发数据标题';
