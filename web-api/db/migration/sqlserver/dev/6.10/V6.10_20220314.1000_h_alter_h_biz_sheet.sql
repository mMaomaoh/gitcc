alter table h_biz_sheet add existDraft BIT default 1;
go


update  h_biz_schema set deleted = 1 where code in (select code from h_app_function where deleted = 1 and type = 'BizModel');
go