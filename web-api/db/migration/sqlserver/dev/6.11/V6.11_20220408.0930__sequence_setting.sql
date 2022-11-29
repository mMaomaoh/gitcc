update h_biz_property set propertyLength = 200 where code='sequenceNo';
go
ALTER TABLE h_system_sequence_no add schemaCode nvarchar(120);
go
ALTER TABLE h_system_sequence_no add filterCondition nvarchar(200);
go