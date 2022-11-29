ALTER TABLE h_biz_sheet ADD COLUMN existDraft bit(1) NULL  COMMENT '是否存在未发布的草稿内容';

update  h_biz_schema set deleted = 1 where code in (select code from h_app_function where deleted = 1 and type = 'BizModel');