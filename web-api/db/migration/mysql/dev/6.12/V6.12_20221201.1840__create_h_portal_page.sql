create table h_portal_page
(
    id                  varchar(36)  not null
        primary key,
    createdTime         datetime     null,
    creater             varchar(120) null,
    deleted             bit          null,
    modifiedTime        datetime     null,
    modifier            varchar(120) null,
    remarks             varchar(200) null,
    code                varchar(50)  not null comment '编码',
    name                varchar(200) not null comment '名称',
    type                varchar(16)  not null comment '类型 门户/应用',
    appCode             varchar(50)  null comment '应用编码',
    published           bit          not null comment '发布状态 草稿/已发布',
    status              varchar(16)  not null comment '状态 启用/禁用',
    defaultPage         bit          not null comment '是否默认页面',
    draftPortalJson     text         null comment '草稿画布',
    publishedPortalJson text         null comment '已发布画布',
    constraint uq_code unique (code)
);
create index idx_type_appCode on h_portal_page (type, appCode);