alter table h_biz_sheet add options clob;
comment on column h_biz_sheet.options is '扩展配置';
alter table h_biz_sheet_history add options clob;
comment on column h_biz_sheet_history.options is '扩展配置';