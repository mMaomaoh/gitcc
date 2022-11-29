UPDATE h_org_role SET corpId='main' WHERE roleType='SYS';
create unique index UQ_SCHEMACODE_CODE on h_biz_property (schemaCode, code);
alter table H_PERM_ADMIN add APPMANAGE NUMBER;

comment on column H_PERM_ADMIN.APPMANAGE is '是有拥有创建应用的权限';
alter table H_RELATED_CORP_SETTING add ENABLED NUMBER;

comment on column H_RELATED_CORP_SETTING.ENABLED is '是否禁用';

alter table H_ORG_USER add ENABLED NUMBER;

comment on column H_ORG_USER.ENABLED is '是否禁用';

alter table H_ORG_DEPARTMENT add ENABLED NUMBER;

comment on column H_ORG_DEPARTMENT.ENABLED is '是否禁用';

UPDATE H_RELATED_CORP_SETTING SET ENABLED = 1 WHERE ID != '';
UPDATE H_ORG_USER SET ENABLED = 1 WHERE ID != '';
UPDATE H_ORG_DEPARTMENT SET ENABLED = 1 WHERE ID != '';
create table h_biz_sheet_history(
    id                      varchar2(120)          not null
    primary key,
    createdTime             date                   null,
    creater                 varchar2(120)          null,
    deleted                 number(1, 0)           null,
    modifiedTime            date                   null,
    modifier                varchar2(120)          null,
    remarks                 varchar2(200)          null,
    code                    varchar2(40)           null,
    draftAttributesJson     CLOB                   null,
    draftViewJson           CLOB                   null,
    icon                    varchar2(50)           null,
    mobileIsPc              number(1, 0)           null,
    mobileUrl               varchar2(500)          null,
    name                    varchar2(50)           null,
    pcUrl                   varchar2(500)          null,
    printIsPc               number(1, 0)           null,
    printUrl                varchar2(500)          null,
    published               number(1, 0)           null,
    publishedAttributesJson CLOB                   null,
    publishedViewJson       CLOB                   null,
    schemaCode              varchar2(40)           null,
    sheetType               varchar2(50)           null,
    sortKey                 int                    null,
    serialCode              varchar2(255)          null,
    serialResetType         varchar2(40)           null,
    externalLinkAble        number(1, 0) default 0 null,
    name_i18n               varchar2(1000)         null,
    draftHtmlJson           CLOB                   null,
    publishedHtmlJson       CLOB                   null,
    draftActionsJson        CLOB                   null,
    publishedActionsJson    CLOB                   null,
    shortCode               varchar2(50)           null,
    printTemplateJson       varchar2(1000)         null,
    qrCodeAble              varchar2(40)           null,
    tempAuthSchemaCodes     varchar2(3500)         null,
    borderMode              varchar2(10)           null,
    layoutType              varchar2(20)           null,
    formComment             number(1,0)            null,
    pdfAble                 varchar2(40)            null,
    publishBy               varchar2(120)           null,
    version                 number(20, 0) default 1 null
);
ALTER table h_biz_query_action add extend1 varchar(100) default null;

