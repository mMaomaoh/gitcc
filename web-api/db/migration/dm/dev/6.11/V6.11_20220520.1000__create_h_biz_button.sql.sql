create table h_biz_button (
    id varchar2(120) primary key not null,
    createdTime timestamp,
    creater	varchar2(120),
    modifiedTime timestamp,
    modifier	varchar2(120),
    deleted number(1,0),
    remarks	varchar2(200),
    schemaCode varchar2(40),
    name	varchar2(200) not null,
    code	varchar2(40) not null,
    triggerCode	varchar2(40) not null,
    triggerType	varchar2(40) not null,
    showPermCode	varchar2(40) not null,
    showPermType	varchar2(40) not null,
    hint	varchar2(200),
    description clob,
    useLocation	varchar2(40) not null,
    bindAction	varchar2(40) not null,
    operateType	varchar2(40) not null,
    targetCode	varchar2(40),
    targetObjCode	varchar2(40),
    actionConfig clob,
    sortKey  int  null
 );

comment on column h_biz_button.schemaCode is '模型编码';
comment on column h_biz_button.name is '按钮名称';
comment on column h_biz_button.code is '按钮编码';
comment on column h_biz_button.triggerCode is '调用方编码（视图、表单）';
comment on column h_biz_button.triggerType is '调用方类型（视图、表单）';
comment on column h_biz_button.showPermCode is '显示权限，绑定对象编码';
comment on column h_biz_button.showPermType is '显示权限，绑定对象类型';
comment on column h_biz_button.hint is '移入提示';
comment on column h_biz_button.description is '备注';
comment on column h_biz_button.useLocation is '使用位置';
comment on column h_biz_button.bindAction is '按钮操作';
comment on column h_biz_button.operateType is '操作类型';
comment on column h_biz_button.targetCode is '模板编码';
comment on column h_biz_button.targetObjCode is '目标对象编码';
comment on column h_biz_button.actionConfig is '按钮配置';
comment on column h_biz_button.sortKey is '排序';

create unique index IDX_S_CODE on h_biz_button (schemaCode, triggerType, triggerCode, code);