alter table h_biz_data_track add sourceSchemaCode VARCHAR2(50);
comment on column h_biz_data_track.sourceSchemaCode is '源模型编码';
alter table h_biz_data_track add sourceSchemaName VARCHAR2(200);
comment on column h_biz_data_track.sourceSchemaName is '源模型名称';
alter table h_biz_data_track add sourceBizObjectId VARCHAR2(50);
comment on column h_biz_data_track.sourceBizObjectId is '源触发数据id';
alter table h_biz_data_track add sourceBizObjectName VARCHAR2(50);
comment on column h_biz_data_track.sourceBizObjectName is '源触发数据标题';