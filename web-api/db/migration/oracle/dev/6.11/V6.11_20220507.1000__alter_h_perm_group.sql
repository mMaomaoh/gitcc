ALTER TABLE h_perm_group ADD sortKey int DEFAULT NULL;
comment on column h_perm_group.sortKey is '排序字段';