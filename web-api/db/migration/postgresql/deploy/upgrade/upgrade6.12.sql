CREATE UNIQUE INDEX uq_code ON h_report_page USING btree (code);

ALTER TABLE h_workflow_trust_rule ADD COLUMN deptRangeType varchar(20) DEFAULT NULL;

ALTER TABLE h_workflow_trust_rule ADD COLUMN originatorDepartments text DEFAULT NULL;

update h_workflow_trust_rule set deptRangeType='ALL' where trustType='APPROVAL';

alter table h_open_api_event add creater varchar(120);
comment on column h_open_api_event.creater is '创建人';
alter table h_open_api_event add createdtime timestamp;
comment on column h_open_api_event.createdtime is '创建时间';
alter table h_open_api_event add modifier varchar(120);
comment on column h_open_api_event.modifier is '修改人';
alter table h_open_api_event add modifiedtime timestamp;
comment on column h_open_api_event.modifiedtime is '修改时间';
alter table h_open_api_event add remarks varchar(200);
comment on column h_open_api_event.remarks is '备注';
alter table h_open_api_event add deleted bool;
comment on column h_open_api_event.deleted is '删除标识';

CREATE TABLE h_subscribe_message (
  id varchar(100) not null,
  callbackUrl varchar(255),
  eventTarget varchar(200),
  eventTargetType varchar(255),
  eventType varchar(255),
  eventKey varchar(200),
  eventParam text,
  applicationName varchar(200),
  pushTime timestamp,
  retryTimes int4,
  createdTime timestamp,
  modifiedTime timestamp,
  options text,
  status varchar(100),
  CONSTRAINT h_subscribe_message_pkey PRIMARY KEY (id)
);
comment on column h_subscribe_message.callbackUrl is '回调地址';
comment on column h_subscribe_message.eventTarget is '事件对象';
comment on column h_subscribe_message.eventTargetType is '事件对象类型';
comment on column h_subscribe_message.eventType is '事件触发类型';
comment on column h_subscribe_message.eventKey is '事件标识符';
comment on column h_subscribe_message.eventParam is '时间推送内容';
comment on column h_subscribe_message.applicationName is '容器名称';
comment on column h_subscribe_message.pushTime is '推送时间';
comment on column h_subscribe_message.retryTimes is '重试次数';
comment on column h_subscribe_message.createdTime is '创建时间';
comment on column h_subscribe_message.modifiedTime is '修改时间';
comment on column h_subscribe_message.options is '扩展参数';
comment on column h_subscribe_message.status is '推送状态';

CREATE TABLE h_subscribe_message_history (
  id varchar(100) not null,
  callbackUrl varchar(255),
  eventTarget varchar(200),
  eventTargetType varchar(255),
  eventType varchar(255),
  eventKey varchar(200),
  eventParam text,
  applicationName varchar(200),
  pushTime timestamp,
  retryTimes int4,
  createdTime timestamp,
  modifiedTime timestamp,
  options text,
  status varchar(100),
  CONSTRAINT h_subscribe_message_history_pkey PRIMARY KEY (id)
);
comment on column h_subscribe_message_history.callbackUrl is '回调地址';
comment on column h_subscribe_message_history.eventTarget is '事件对象';
comment on column h_subscribe_message_history.eventTargetType is '事件对象类型';
comment on column h_subscribe_message_history.eventType is '事件触发类型';
comment on column h_subscribe_message_history.eventKey is '事件标识符';
comment on column h_subscribe_message_history.eventParam is '时间推送内容';
comment on column h_subscribe_message_history.applicationName is '容器名称';
comment on column h_subscribe_message_history.pushTime is '推送时间';
comment on column h_subscribe_message_history.retryTimes is '重试次数';
comment on column h_subscribe_message_history.createdTime is '创建时间';
comment on column h_subscribe_message_history.modifiedTime is '修改时间';
comment on column h_subscribe_message_history.options is '扩展参数';
comment on column h_subscribe_message_history.status is '推送状态';


alter table h_biz_data_track add sourceSchemaCode varchar(50);
alter table h_biz_data_track add sourceSchemaName varchar(200);
alter table h_biz_data_track add sourceBizObjectId varchar(50);
alter table h_biz_data_track add sourceBizObjectName varchar(200);

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


create function getUnitId(selectionstr character varying) returns character varying
    language plpgsql
as
$$
declare
    beginIndex int;
    endIndex int;
    tempStr    varchar(4000);
    result varchar(200);
begin

    if selectionStr is null then
        return null;
    end if;

    select position('"id"' in selectionStr) into beginIndex;
    if beginIndex = 0 then
        return selectionStr;
    end if;

    select substr(selectionStr, beginIndex + 6) into tempStr;

    select position('"' in tempStr) into endIndex;

    select substr(tempStr, 0, endIndex) into result;

    return result;
end;
$$;

create function getUnitType(selectionstr character varying) returns character varying
    language plpgsql
as
$$
declare
    beginIndex int;
    result varchar(200);
begin

    if selectionStr is null then
        return null;
    end if;

    select position('"type"' in selectionStr) into beginIndex;
    if beginIndex = 0 then
        return selectionStr;
    end if;

    select substr(selectionStr, beginIndex + 7, 1) into result;

    return result;
end;
$$;


create function getUnitIdAndType(selectionstr character varying) returns character varying
    language plpgsql
as
$$
declare
    selectionType varchar(4000);
    selectionId    varchar(4000);
    result varchar(200);
begin

    if selectionStr is null then
        return null;
    end if;

    select getUnitId(selectionStr) into selectionId;
    if selectionId = selectionstr then
        return selectionstr;
    end if;
    select getUnitType(selectionStr) into selectionType;
    if selectionType = selectionstr then
        return selectionstr;
    end if;
    select selectionId || '_' || selectionType into result;
    return result;
end;
$$;

create function getMultiUnitId(selectionstr character varying) returns character varying
    language plpgsql
as
$$
declare
    num int;
    tempStr varchar(4000);
    tempResult varchar(4000);
    result varchar(4000);
begin

    if selectionStr is null then
        return null;
    end if;

    num := 1;

    for tempStr in select regexp_split_to_table(selectionStr,'},{')
    loop
        select getunitid(tempStr) into tempResult;

        if(num = 1) then
            select tempResult into result;
        else
            select result || ';' || tempResult into result;
        end if;
        num := num + 1;
    end loop;

    return result;
end;
$$;

create function getMultiUnitIdAndType(selectionstr character varying) returns character varying
    language plpgsql
as
$$
declare
    num int;
    tempStr varchar(4000);
    tempResult varchar(4000);
    result varchar(4000);
begin

    if selectionStr is null then
        return null;
    end if;

    num = 1;

    for tempStr in select regexp_split_to_table(selectionStr,'},{')
    loop
        select getunitidandtype(tempStr) into tempResult;

        if( num = 1) then
            select tempResult into result;
        else
            select result || ';' || tempResult into result;
        end if;
        num = num + 1;
    end loop;

    return result;
end;
$$;

create procedure modifyselector()
    language plpgsql
as
$$
declare
    vSchemaCode   varchar(200);
    vPropertyCode varchar(200);
    vPropertyType varchar(200);
    iCount        int;
    iTableName    varchar(200);
    vSql          varchar(4000);
    -- 查询出人员单选、部门单选类型的数据项
    properties cursor for
        select schemaCode, code, propertyType
        from h_biz_property
        where propertyType in ('STAFF_MULTI_SELECTOR', 'DEPARTMENT_MULTI_SELECTOR', 'SELECTION')
          and published = '1';
begin
    open properties;
    fetch properties into vSchemaCode,vPropertyCode,vPropertyType;

    while FOUND
        loop
            -- 判断是否存在i表
            select count(*) into iCount from pg_tables where tablename like 'i%\_' || lower(vSchemaCode);
            if iCount = 0 then
                fetch properties into vSchemaCode,vPropertyCode,vPropertyType;
                continue;
            end if;

            select tablename into iTableName from pg_tables where tablename like 'i%\_' || lower(vSchemaCode);

            -- 更新数据
            if vPropertyType = 'SELECTION' then
                vSql := 'update ' || iTableName || ' set "' || vPropertyCode || '" = getMultiUnitIdAndType("' || vPropertyCode || '");';
            else
                vSql := 'update ' || iTableName || ' set "' || vPropertyCode || '" = getMultiUnitId("' || vPropertyCode || '");';
            end if;

            RAISE NOTICE '%', vSql;
            execute (vSql);
            fetch properties into vSchemaCode,vPropertyCode,vPropertyType;
        end loop;
end;
$$;

create procedure modifydropdownandaddress()
    language plpgsql
as
$$
declare
    vSchemaCode   varchar(200);
    vPropertyCode varchar(200);
    iCount        int;
    iTableName    varchar(200);
    vSql          varchar(4000);
    -- 查询出人员单选、部门单选类型的数据项
    properties cursor for
        select schemaCode, code
        from h_biz_property
        where propertyType = 'DROPDOWN_BOX'
          and published = '1';
begin
    open properties;
    fetch properties into vSchemaCode,vPropertyCode;

    while FOUND
        loop
            -- 判断是否存在i表
            select count(*) into iCount from pg_tables where tablename like 'i%\_' || lower(vSchemaCode);
            if iCount = 0 then
                fetch properties into vSchemaCode,vPropertyCode;
                continue;
            end if;

            select tablename into iTableName from pg_tables where tablename like 'i%\_' || lower(vSchemaCode);

            -- 修改字段类型
            vSql := 'alter table ' || iTableName || ' alter column "' || vPropertyCode || '" type varchar(200);';
            RAISE NOTICE '%', vSql;
            execute (vSql);
            fetch properties into vSchemaCode,vPropertyCode;
        end loop;
end;
$$;

CREATE TABLE h_source_code (
  id varchar(120) NOT NULL,
  code varchar(120) NOT NULL,
  createdTime TIMESTAMP,
  creater varchar(120),
  deleted bool,
  modifiedTime TIMESTAMP,
  modifier varchar(120),
  remarks varchar(200),
  content text,
  codeType varchar(15),
  published bool,
  version int4,
  originalVersion int4,
  CONSTRAINT h_source_code_pkey PRIMARY KEY (id)
);
comment on column h_source_code.code is '源代码编码';
comment on column h_source_code.content is '源码';
comment on column h_source_code.codeType is '源码类型';
comment on column h_source_code.published is '是否生效';
comment on column h_source_code.version is '版本号';
comment on column h_source_code.originalVersion is '源版本号';
CREATE INDEX idx_h_source_code_code ON h_source_code USING btree (code);

CREATE TABLE h_source_code_template (
  id varchar(120) NOT NULL,
  code varchar(120) NOT NULL,
  createdTime TIMESTAMP,
  creater varchar(120),
  deleted bool,
  modifiedTime TIMESTAMP,
  modifier varchar(120),
  remarks varchar(200),
  content text,
  codeType varchar(15),
  name varchar(100)
);
comment on column h_source_code.version is '模板编码';
comment on column h_source_code.version is '源码';
comment on column h_source_code.version is '源码类型';
comment on column h_source_code.version is '模板名称';
CREATE UNIQUE INDEX idx_h_source_code_template_code ON h_source_code_template USING btree (code, codeType);

INSERT INTO h_source_code_template (id, code, createdTime, creater, deleted, modifiedTime, modifier, remarks, content, codeType, name) VALUES ('2c928d4484f5cd9b0184f5d048e204dd', 'AvailableHandlerTemplate', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, '0', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, NULL, 'package com.authine.cloudpivot.engine.service.bizrule.handler;\n\nimport com.authine.cloudpivot.engine.service.bizrule.handler.context.Request;\n\npublic class SourceCodeTemplateClassName extends AvailableHandler {\n    @Override\n    public Object handle(Request request) {\n        return super.handle(request);\n    }\n}\n', 'BUSINESS_RULE', '默认业务规则-流程生效');
INSERT INTO h_source_code_template (id, code, createdTime, creater, deleted, modifiedTime, modifier, remarks, content, codeType, name) VALUES ('2c928d4484f5cd9b0184f5d07d4004e0', 'CancelHandlerTemplate', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, '0', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, NULL, 'package com.authine.cloudpivot.engine.service.bizrule.handler;\n\nimport com.authine.cloudpivot.engine.service.bizrule.handler.context.Request;\n\npublic class SourceCodeTemplateClassName extends CancelHandler {\n    @Override\n    public Object handle(Request request) {\n        return super.handle(request);\n    }\n}\n', 'BUSINESS_RULE', '默认业务规则-流程取消');
INSERT INTO h_source_code_template (id, code, createdTime, creater, deleted, modifiedTime, modifier, remarks, content, codeType, name) VALUES ('2c928d4484f5cd9b0184f5d09bb404e3', 'CreateHandlerTemplate', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, '0', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, NULL, 'package com.authine.cloudpivot.engine.service.bizrule.handler;\n\nimport com.authine.cloudpivot.engine.domain.runtime.BizObject;\n\npublic class SourceCodeTemplateClassName extends CreateHandler {\n    @Override\n    protected BizObject create(BizObject bizObject) {\n        return super.create(bizObject);\n    }\n}\n', 'BUSINESS_RULE', '默认业务规则-新增');
INSERT INTO h_source_code_template (id, code, createdTime, creater, deleted, modifiedTime, modifier, remarks, content, codeType, name) VALUES ('2c928d4484f5cd9b0184f5d09bbb04e5', 'DeleteHandlerTemplate', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, '0', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, NULL, 'package com.authine.cloudpivot.engine.service.bizrule.handler;\r\n\r\nimport com.authine.cloudpivot.engine.domain.runtime.BizObject;\r\n\r\npublic class SourceCodeTemplateClassName extends DeleteHandler {\r\n    @Override\r\n    protected void delete(BizObject bizObject) {\r\n        super.delete(bizObject);\r\n    }\r\n}\r\n', 'BUSINESS_RULE', '默认业务规则-删除');
INSERT INTO h_source_code_template (id, code, createdTime, creater, deleted, modifiedTime, modifier, remarks, content, codeType, name) VALUES ('2c928d4484f5cd9b0184f5d09bc104e7', 'GetListHandlerTemplate', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, '0', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, NULL, 'package com.authine.cloudpivot.engine.service.bizrule.handler;\n\nimport com.authine.cloudpivot.engine.component.query.api.Page;\nimport com.authine.cloudpivot.foundation.orm.api.model.BizObjectQueryObject;\n\nimport java.util.Map;\n\npublic class SourceCodeTemplateClassName extends GetListHandler {\n\n    @Override\n    protected Page<Map<String, Object>> getList(BizObjectQueryObject bizObjectQueryObject) {\n        return super.getList(bizObjectQueryObject);\n    }\n}\n', 'BUSINESS_RULE', '默认业务规则-获取列表');
INSERT INTO h_source_code_template (id, code, createdTime, creater, deleted, modifiedTime, modifier, remarks, content, codeType, name) VALUES ('2c928d4484f5cd9b0184f5d09bc904e9', 'LoadHandlerTemplate', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, '0', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, NULL, 'package com.authine.cloudpivot.engine.service.bizrule.handler;\n\nimport com.authine.cloudpivot.engine.domain.runtime.BizObject;\nimport com.authine.cloudpivot.foundation.orm.api.model.BizObjectOptions;\n\nimport java.util.Optional;\n\npublic class SourceCodeTemplateClassName extends LoadHandler {\n\n    @Override\n    protected Optional<BizObject> load(BizObject bizObject, BizObjectOptions options) {\n        return super.load(bizObject, options);\n    }\n}\n', 'BUSINESS_RULE', '默认业务规则-查询');
INSERT INTO h_source_code_template (id, code, createdTime, creater, deleted, modifiedTime, modifier, remarks, content, codeType, name) VALUES ('2c928d4484f5cd9b0184f5d09bcf04eb', 'UpdateHandlerTemplate', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, '0', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, NULL, 'package com.authine.cloudpivot.engine.service.bizrule.handler;\n\nimport com.authine.cloudpivot.engine.domain.runtime.BizObject;\nimport com.authine.cloudpivot.foundation.orm.api.model.BizObjectOptions;\n\npublic class SourceCodeTemplateClassName extends UpdateHandler {\n    @Override\n    protected Object update(BizObject bizObject, BizObjectOptions options) {\n        return super.update(bizObject, options);\n    }\n}\n', 'BUSINESS_RULE', '默认业务规则-更新');
INSERT INTO h_source_code_template (id, code, createdTime, creater, deleted, modifiedTime, modifier, remarks, content, codeType, name) VALUES ('2c928d4484fa33380184fa34d96d04d6', 'CustomizedHandlerTemplate', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, '0', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, NULL, 'package com.authine.cloudpivot.engine.service.bizrule.handler;\n\nimport com.authine.cloudpivot.engine.domain.runtime.BizObject;\nimport com.authine.cloudpivot.engine.service.bizrule.handler.context.Request;\n\nimport java.util.Map;\n\npublic class SourceCodeTemplateClassName extends BaseHandler {\n    @Override\n    public Object handle(Request request) {\n        //获取bo\n        BizObject bizObject = request.getData().getBizObject();\n        //获取自定义业务规则执行参数\n        Map<String, Object> param = request.getData().getCustomParams();\n        //do something\n        return bizObject;\n    }\n}\n', 'BUSINESS_RULE', '自定义业务规则');

ALTER TABLE h_business_rule ADD developmentMode varchar(15);
comment on column h_business_rule.developmentMode is '业务规则开发模式(图形化：DEFAULT，在线编码：CODING)';