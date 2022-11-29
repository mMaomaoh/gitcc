ALTER TABLE h_user_common_query ADD filterFixed number(1, 0) default 0 not null;
comment on column h_user_common_query.filterFixed is '窗口是否固定 1：固定 0：不固定';

ALTER TABLE h_user_common_query ADD conditionType number(1, 0) default 0 not null;
comment on column h_user_common_query.conditionType is '条件类型 1：全部 0：任一';