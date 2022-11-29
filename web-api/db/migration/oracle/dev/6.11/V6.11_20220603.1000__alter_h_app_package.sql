alter table h_app_package add builtInApp number(1, 0) default 0;
comment on column h_app_package.builtInApp is '内置应用 1：是 0：否';