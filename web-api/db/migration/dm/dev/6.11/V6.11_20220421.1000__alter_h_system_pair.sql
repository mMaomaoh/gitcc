alter table h_system_pair add uniqueCode varchar2(120);
comment on column h_system_pair.uniqueCode is '唯一码';
alter table h_system_pair add type varchar2(40);
comment on column h_system_pair.type is '类型';
alter table h_system_pair add expireTime date;
comment on column h_system_pair.expireTime is '过期时间';
create unique index idx_u_code on h_system_pair (uniqueCode);
