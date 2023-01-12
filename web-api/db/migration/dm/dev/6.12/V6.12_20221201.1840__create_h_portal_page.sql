create table h_portal_page
(
    id                  varchar2(36)  not null
        primary key,
    createdTime         timestamp   ,
    creater             varchar2(120) ,
    deleted             number(1,0) ,
    modifiedTime        timestamp     ,
    modifier            varchar2(120) ,
    remarks             varchar2(200) ,
    code                varchar2(50)  not null ,
    name                varchar2(200) not null ,
    type                varchar2(16)  not null ,
    appCode             varchar2(50)  ,
    published           number(1, 0)  not null ,
    status              varchar2(16)  not null ,
    defaultPage         number(1, 0)  not null ,
    draftPortalJson     clob         ,
    publishedPortalJson clob
);
create unique index uq_h_p_p_code on h_portal_page (code);
create index idx_h_p_p_type_appCode on h_portal_page (type, appCode);
