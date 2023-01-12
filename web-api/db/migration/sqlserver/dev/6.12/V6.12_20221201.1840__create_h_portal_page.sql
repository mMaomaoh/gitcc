create table h_portal_page
(
    id                  nvarchar(36) not null
        primary key,
    createdTime         datetime,
    creater             nvarchar(120),
    deleted             bit,
    modifiedTime        datetime,
    modifier            nvarchar(120),
    remarks             nvarchar(200),
    code                nvarchar(50)  not null,
    name                nvarchar(200) not null,
    type                nvarchar(16)  not null,
    appCode             nvarchar(50),
    published           bit,
    status              nvarchar(16)  not null,
    defaultPage         bit,
    draftPortalJson     nvarchar(max),
    publishedPortalJson nvarchar(max)
)
go

create unique index uk_code
    on h_portal_page (code)
go

create index idx_type_appCode
    on h_portal_page (type, appCode)
go

