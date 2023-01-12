-- auto-generated definition
create table h_portal_page
(
    id                  varchar(36)  not null
        primary key,
    creater             varchar(120),
    createdtime         timestamp,
    deleted             boolean,
    modifier            varchar(120),
    modifiedtime        timestamp,
    remarks             varchar(200),
    code                varchar(50)  not null,
    name                varchar(200) not null,
    type                varchar(16)  not null,
    appCode             varchar(50),
    published           boolean      not null,
    status              varchar(16)  not null,
    defaultPage         boolean      not null,
    draftPortalJson     text,
    publishedPortalJson text
);
create index idx_h_p_p_type_appCode on h_portal_page (type, appCode);
create unique index uq_h_p_p_code on h_portal_page (code);