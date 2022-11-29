update h_biz_property set propertyLength = 200 where code='sequenceNo';

ALTER TABLE h_system_sequence_no add schemaCode varchar(120) COMMENT '数据模型编码';

ALTER TABLE h_system_sequence_no add filterCondition varchar(200) COMMENT '过滤条件';