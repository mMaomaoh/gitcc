ALTER TABLE h_system_pair ADD COLUMN uniqueCode varchar(120) NULL COMMENT '唯一码';
ALTER TABLE h_system_pair ADD COLUMN type varchar(40) NULL COMMENT '类型';
ALTER TABLE h_system_pair ADD COLUMN expireTime datetime(3) NULL COMMENT '过期时间';
create unique index idx_u_code on h_system_pair (uniqueCode);