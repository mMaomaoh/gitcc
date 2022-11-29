update h_biz_property set propertyLength = 200 where code='sequenceNo';

ALTER TABLE h_system_sequence_no add (schemaCode varchar2(120) null);
comment on column h_system_sequence_no.schemaCode is '数据模型编码';

ALTER TABLE h_system_sequence_no add (filterCondition varchar2(200) null);
comment on column h_system_sequence_no.filterCondition is '过滤条件';