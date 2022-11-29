ALTER TABLE h_biz_sheet ADD (existDraft number(1,0));
comment on column h_biz_sheet.existDraft is '是否存在未发布的草稿内容';