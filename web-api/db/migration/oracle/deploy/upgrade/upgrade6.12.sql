create table h_biz_import_task (
    id varchar2(120) primary key not null,
    importTime date,
    startTime date,
    endTime date,
    userId varchar2(120),
    schemaCode varchar2(200),
    taskStatus varchar2(200),
    lastHeartTime date,
    threadName varchar2(150),
    operationResultJson clob,
    originalFilename clob
);

CREATE INDEX idx_h_b_i_t_userId ON h_biz_import_task (userId);
CREATE INDEX idx_h_b_i_t_schemaCode ON h_biz_import_task (schemaCode);
CREATE INDEX idx_h_b_i_t_threadName ON h_biz_import_task (threadName);
CREATE INDEX idx_h_b_i_t_heart ON h_biz_import_task (lastHeartTime,taskStatus);

create unique index uq_rp_code on h_report_page (code);

ALTER TABLE h_workflow_trust_rule ADD deptRangeType varchar2(20);
comment on column h_workflow_trust_rule.deptRangeType is '发起人部门范围类型，全部：ALL；部分：PART' ;

ALTER TABLE h_workflow_trust_rule add originatorDepartments clob;
comment on column h_workflow_trust_rule.originatorDepartments is '发起人部门id，逗号分隔';

update h_workflow_trust_rule set deptRangeType='ALL' where trustType='APPROVAL';

ALTER TABLE H_OPEN_API_EVENT MODIFY CLIENTID VARCHAR2(100);

ALTER TABLE H_OPEN_API_EVENT ADD CREATER VARCHAR2(120);
COMMENT ON COLUMN H_OPEN_API_EVENT.CREATER IS '创建人';
ALTER TABLE H_OPEN_API_EVENT ADD CREATEDTIME DATE;
COMMENT ON COLUMN H_OPEN_API_EVENT.CREATEDTIME IS '创建时间';
ALTER TABLE H_OPEN_API_EVENT ADD MODIFIER VARCHAR2(120);
COMMENT ON COLUMN H_OPEN_API_EVENT.MODIFIER IS '修改人';
ALTER TABLE H_OPEN_API_EVENT ADD MODIFIEDTIME DATE;
COMMENT ON COLUMN H_OPEN_API_EVENT.MODIFIEDTIME IS '修改时间';
ALTER TABLE H_OPEN_API_EVENT ADD REMARKS VARCHAR2(200);
COMMENT ON COLUMN H_OPEN_API_EVENT.REMARKS IS '备注';
ALTER TABLE H_OPEN_API_EVENT ADD DELETED NUMBER(1,0);
COMMENT ON COLUMN H_OPEN_API_EVENT.DELETED IS '删除标识';

CREATE TABLE h_subscribe_message (
  id varchar2(100) primary key not null,
  callbackUrl varchar2(255),
  eventTarget varchar2(200),
  eventTargetType varchar2(255),
  eventType varchar2(255),
  eventKey varchar2(200),
  eventParam clob,
  applicationName varchar2(200),
  pushTime date,
  retryTimes number(3, 0),
  createdTime date,
  modifiedTime date,
  options clob,
  status varchar2(100)
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
  id varchar2(100) primary key not null,
  callbackUrl varchar2(255),
  eventTarget varchar2(200),
  eventTargetType varchar2(255),
  eventType varchar2(255),
  eventKey varchar2(200),
  eventParam clob,
  applicationName varchar2(200),
  pushTime date,
  retryTimes number(3, 0),
  createdTime date,
  modifiedTime date,
  options clob,
  status varchar2(100)
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


alter table h_biz_data_track add sourceSchemaCode VARCHAR2(50);
comment on column h_biz_data_track.sourceSchemaCode is '源模型编码';
alter table h_biz_data_track add sourceSchemaName VARCHAR2(200);
comment on column h_biz_data_track.sourceSchemaName is '源模型名称';
alter table h_biz_data_track add sourceBizObjectId VARCHAR2(50);
comment on column h_biz_data_track.sourceBizObjectId is '源触发数据id';
alter table h_biz_data_track add sourceBizObjectName VARCHAR2(50);
comment on column h_biz_data_track.sourceBizObjectName is '源触发数据标题';

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


create function getUnitId(selectionStr varchar2) return varchar2
as
    beginIndex    int;
    endIndex    int;
    selectionId varchar2(200);
begin
    if selectionStr is null then
        return selectionStr;
    end if;

    select instr(selectionStr, '"id"') into beginIndex from DUAL;

    select instr(selectionStr, '"', beginIndex + 6) into endIndex from dual;

    select substr(selectionStr, beginIndex + 6, endIndex - beginIndex - 6) into selectionId from DUAL;
    return selectionId;
end;
/

create function getUnitType(selectionStr varchar2) return varchar2
as
    beginIndex    int;
    selectionType varchar2(200);
begin
    if selectionStr is null then
        return selectionStr;
    end if;

    select instr(selectionStr, '"type"') into beginIndex from dual;

    if beginIndex = 0 then
        return selectionStr ;
    end if;

    select substr(selectionStr, beginIndex + 7, 1) into selectionType from dual;
    return selectionType;
end;
/

create function getUnitIdAndType(selectionStr varchar2) return varchar2
as
    selectionId varchar2(100);
    selectionType varchar2(50);
    result varchar2(200);
begin
    if selectionStr is null then
        return selectionStr;
    end if;

    select getUnitId(selectionStr) into selectionId from dual;
    if selectionId = selectionStr then
        return selectionStr;
    end if;
    select getUnitType(selectionStr) into selectionType from dual;
    if selectionType = selectionStr then
        return selectionStr;
    end if;
    select selectionId || '_' || selectionType into result from dual;

    return result;
end;
/

create function getMultiUnitId(selectionStr varchar2) return varchar2
as
    num int;
    indexFlag int;
    tempStr varchar2(2000);
    tempResult varchar2(2000);
    result varchar2(2000);
    length int;
    beginIndex int;
begin
    if selectionStr is null then
        return null;
    end if;

    select (length(selectionStr) - length(replace(selectionStr,'},{','')))/3 into num from dual;

    beginIndex := 1;

    for indexFlag in 1 .. num + 1 loop
        if indexFlag < num + 1 then
            select instr(selectionStr,'},{',beginIndex,1) - beginIndex + 1 into length from dual;
            select substr(selectionStr,beginIndex,length) into tempStr from dual;
        else
            select length(selectionStr) - beginIndex + 1 into length from dual;
            select substr(selectionStr,beginIndex,length) into tempStr from dual;
        end if;

        select getUnitId(tempStr) into tempResult from dual;

        if indexFlag = 1 then
                result := tempResult ;
            else
                result := result || ';' || tempResult ;
        end if;

        beginIndex := beginIndex + length + 3;

--         select beginIndex + length + 3 into beginIndex from dual;
    end loop;

    return result;
end;
/

create function getMultiUnitIdAndType(selectionStr varchar2) return varchar2
as
    num int;
    indexFlag int;
    tempStr varchar2(2000);
    tempResult varchar2(2000);
    result varchar2(2000);
    length int;
    beginIndex int;
begin
    if selectionStr is null then
        return null;
    end if;

    select (length(selectionStr) - length(replace(selectionStr,'},{','')))/3 into num from dual;

    beginIndex := 1;

    for indexFlag in 1 .. num + 1 loop
        if indexFlag < num + 1 then
            select instr(selectionStr,'},{',beginIndex,1) - beginIndex + 1 into length from dual;
            select substr(selectionStr,beginIndex,length) into tempStr from dual;
        else
            select length(selectionStr) - beginIndex + 1 into length from dual;
            select substr(selectionStr,beginIndex,length) into tempStr from dual;
        end if;

        select getUnitIdAndType(tempStr) into tempResult from dual;

        if indexFlag = 1 then
                result := tempResult ;
            else
                result := result || ';' || tempResult ;
        end if;

        beginIndex := beginIndex + length + 3;

--         select beginIndex + length + 3 into beginIndex from dual;
    end loop;

    return result;
end;
/

create procedure modifySelector(sensitive int)
as
    iTableName    VARCHAR2(200); -- 表名
    iCount        INT; -- 计数
    columnName    VARCHAR2(200); -- 原字段名
    newColumnName VARCHAR2(200); -- 新字段名
    vSql          VARCHAR2(2000); -- sql语句
begin

    -- 1.查询出所有人员单选 部门单选类型的数据
    -- 2.根据数据模型编码查询表名
    for properties in (select *
                       from H_BIZ_PROPERTY
                       where PROPERTYTYPE in ('SELECTION', 'DEPARTMENT_MULTI_SELECTOR', 'STAFF_MULTI_SELECTOR')
                         and PUBLISHED = '1')
        loop
            -- 如果不存在表 就跳过执行
            SELECT COUNT(*)
            INTO iCount
            FROM USER_TABLES
            where TABLE_NAME like upper(CONCAT('I%\_', properties.SCHEMACODE)) escape '\'
              and TABLESPACE_NAME = 'USERS';
            IF iCount = 0 THEN
                CONTINUE;
            END IF;
            SELECT TABLE_NAME
            INTO iTableName
            FROM ALL_TABLES
            where TABLE_NAME like upper(CONCAT('I%\_', properties.SCHEMACODE)) escape '\'
              and TABLESPACE_NAME = 'USERS';

            DBMS_OUTPUT.PUT_LINE(iTableName);

            -- 默认为大小写敏感
            columnName := '"' || properties.CODE || '"';
            newColumnName := '"' || properties.CODE || '__TEMP"';
            if length(properties.CODE) > 20 then
                newColumnName := '"' || substr(properties.CODE,1,20) || '__TEMP"';
            end if;

            -- 大小写不敏感时需转换成大写
            if sensitive = 0 then
                select upper(properties.CODE) into columnName from dual;
                if length(properties.CODE) > 20 then
                    select upper(substr(properties.CODE,1,20)) || '__TEMP' into newColumnName from dual;
                    else
                    select upper(properties.CODE) || '__TEMP' into newColumnName from dual;
                end if;
            end if;

            DBMS_OUTPUT.PUT_LINE(columnName);
            DBMS_OUTPUT.PUT_LINE(newColumnName);

            -- 添加新字段
            vSql := 'ALTER TABLE ' || iTableName || ' ADD ' || newColumnName || ' VARCHAR2(2000)';
            DBMS_OUTPUT.PUT_LINE(vSql);
            EXECUTE IMMEDIATE vSql;

            if properties.PROPERTYTYPE = 'SELECTION'
            then
                -- 把clob字段的内容更新至新字段
                vSql := 'UPDATE ' || iTableName || ' SET ' || newColumnName || ' = getMultiUnitIdAndType(TO_CHAR(' || columnName || '))';
            else
                vSql := 'UPDATE ' || iTableName || ' SET ' || newColumnName || ' = getMultiUnitId(TO_CHAR(' ||
                        columnName || '))';
            end if;

            DBMS_OUTPUT.PUT_LINE(vSql);
            EXECUTE IMMEDIATE vSql;
            COMMIT;

            -- 删除原有字段
            vSql := 'ALTER TABLE ' || iTableName || ' DROP COLUMN ' || columnName;
            DBMS_OUTPUT.PUT_LINE(vSql);
            EXECUTE IMMEDIATE vSql;

            -- 把新字段的名称修改为原有字段
            vSql := 'ALTER TABLE ' || iTableName || ' RENAME COLUMN ' || newColumnName || ' TO ' || columnName;
            DBMS_OUTPUT.PUT_LINE(vSql);
            EXECUTE IMMEDIATE vSql;
        end loop;
end;
/

create procedure modifyClob(sensitive int)
as
    iTableName    VARCHAR2(200); -- 表名
    iCount        INT; -- 计数
    columnName    VARCHAR2(200); -- 原字段名
    newColumnName VARCHAR2(200); -- 新字段名
    vSql          VARCHAR2(2000); -- sql语句
begin

    -- 1.查询出所有人员单选 部门单选类型的数据
    -- 2.根据数据模型编码查询表名
    for properties in (select *
                       from H_BIZ_PROPERTY
                       where PROPERTYTYPE in ('DROPDOWN_BOX', 'CHECKBOX', 'MULT_WORK_SHEET', 'DROPDOWN_MULTI_BOX')
                         and PUBLISHED = '1')
        loop
            -- 如果不存在表 就跳过执行
            SELECT COUNT(*)
            INTO iCount
            FROM USER_TABLES
            where TABLE_NAME like upper(CONCAT('I%\_', properties.SCHEMACODE)) escape '\'
              and TABLESPACE_NAME = 'USERS';
            IF iCount = 0 THEN
                CONTINUE;
            END IF;
            SELECT TABLE_NAME
            INTO iTableName
            FROM ALL_TABLES
            where TABLE_NAME like upper(CONCAT('I%\_', properties.SCHEMACODE)) escape '\'
              and TABLESPACE_NAME = 'USERS';

            DBMS_OUTPUT.PUT_LINE(iTableName);

            -- 默认为大小写敏感
            columnName := '"' || properties.CODE || '"';
            if length(properties.CODE) > 20 then
                newColumnName := '"' || substr(properties.CODE,1,20) || '__TEMP"';
            else
                newColumnName := '"' || properties.CODE || '__TEMP"';
            end if;

            -- 大小写不敏感时需转换成大写
            if sensitive = 0 then
                select upper(properties.CODE) into columnName from dual;
                if length(properties.CODE) > 20 then
                    select upper(substr(properties.CODE,1,20)) || '__TEMP' into newColumnName from dual;
                    else
                    select upper(properties.CODE) || '__TEMP' into newColumnName from dual;
                end if;
            end if;
            DBMS_OUTPUT.PUT_LINE(columnName);
            DBMS_OUTPUT.PUT_LINE(newColumnName);

            -- 添加新字段
            if properties.PROPERTYTYPE = 'DROPDOWN_BOX'
                then
                    vSql := 'ALTER TABLE ' || iTableName || ' ADD ' || newColumnName || ' VARCHAR2(200)';
                else
                    vSql := 'ALTER TABLE ' || iTableName || ' ADD ' || newColumnName || ' VARCHAR2(2000)';
            end if;
            DBMS_OUTPUT.PUT_LINE(vSql);
            EXECUTE IMMEDIATE vSql;

            -- 把clob字段的内容更新至新字段
            vSql := 'UPDATE ' || iTableName || ' SET ' || newColumnName || ' = TO_CHAR(' || columnName || ')';
            DBMS_OUTPUT.PUT_LINE(vSql);
            EXECUTE IMMEDIATE vSql;
            COMMIT;

            -- 删除原有字段
            vSql := 'ALTER TABLE ' || iTableName || ' DROP COLUMN ' || columnName;
            DBMS_OUTPUT.PUT_LINE(vSql);
            EXECUTE IMMEDIATE vSql;

            -- 把新字段的名称修改为原有字段
            vSql := 'ALTER TABLE ' || iTableName || ' RENAME COLUMN ' || newColumnName || ' TO ' || columnName;
            DBMS_OUTPUT.PUT_LINE(vSql);
            EXECUTE IMMEDIATE vSql;
        end loop;
end;
/

CREATE TABLE h_source_code (
  id varchar2(120) PRIMARY KEY NOT NULL,
  code varchar2(120) NOT NULL,
  createdTime TIMESTAMP,
  creater varchar2(120),
  deleted number(1),
  modifiedTime TIMESTAMP,
  modifier varchar2(120),
  remarks varchar2(200),
  content clob,
  codeType varchar2(15),
  published number(1),
  version int,
  originalVersion int
);
comment on column h_source_code.code is '源代码编码';
comment on column h_source_code.content is '源码';
comment on column h_source_code.codeType is '源码类型';
comment on column h_source_code.published is '是否生效';
comment on column h_source_code.version is '版本号';
comment on column h_source_code.originalVersion is '源版本号';
create index idx_h_source_code_code on h_source_code (code);

CREATE TABLE h_source_code_template (
  id varchar2(120) PRIMARY KEY NOT NULL,
  code varchar2(120) NOT NULL,
  createdTime TIMESTAMP,
  creater varchar2(120),
  deleted number(1),
  modifiedTime TIMESTAMP,
  modifier varchar2(120),
  remarks varchar2(200),
  content clob,
  codeType varchar2(15),
  name varchar2(100)
);
comment on column h_source_code.version is '模板编码';
comment on column h_source_code.version is '源码';
comment on column h_source_code.version is '源码类型';
comment on column h_source_code.version is '模板名称';
create unique index idx_h_s_c_t_code on h_source_code_template (code, codeType);

INSERT INTO h_source_code_template (id, code, createdTime, creater, deleted, modifiedTime, modifier, remarks, content, codeType, name) VALUES ('2c928d4484f5cd9b0184f5d048e204dd', 'AvailableHandlerTemplate', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, '0', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, NULL, 'package com.authine.cloudpivot.engine.service.bizrule.handler;'||chr(10)||chr(10)||'import com.authine.cloudpivot.engine.service.bizrule.handler.context.Request;'||chr(10)||chr(10)||'public class SourceCodeTemplateClassName extends AvailableHandler {'||chr(10)||'    @Override'||chr(10)||'    public Object handle(Request request) {'||chr(10)||'        return super.handle(request);'||chr(10)||'    }'||chr(10)||'}'||chr(10)||'', 'BUSINESS_RULE', '默认业务规则-流程生效');
INSERT INTO h_source_code_template (id, code, createdTime, creater, deleted, modifiedTime, modifier, remarks, content, codeType, name) VALUES ('2c928d4484f5cd9b0184f5d07d4004e0', 'CancelHandlerTemplate', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, '0', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, NULL, 'package com.authine.cloudpivot.engine.service.bizrule.handler;'||chr(10)||chr(10)||'import com.authine.cloudpivot.engine.service.bizrule.handler.context.Request;'||chr(10)||chr(10)||'public class SourceCodeTemplateClassName extends CancelHandler {'||chr(10)||'    @Override'||chr(10)||'    public Object handle(Request request) {'||chr(10)||'        return super.handle(request);'||chr(10)||'    }'||chr(10)||'}'||chr(10)||'', 'BUSINESS_RULE', '默认业务规则-流程取消');
INSERT INTO h_source_code_template (id, code, createdTime, creater, deleted, modifiedTime, modifier, remarks, content, codeType, name) VALUES ('2c928d4484f5cd9b0184f5d09bb404e3', 'CreateHandlerTemplate', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, '0', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, NULL, 'package com.authine.cloudpivot.engine.service.bizrule.handler;'||chr(10)||chr(10)||'import com.authine.cloudpivot.engine.domain.runtime.BizObject;'||chr(10)||chr(10)||'public class SourceCodeTemplateClassName extends CreateHandler {'||chr(10)||'    @Override'||chr(10)||'    protected BizObject create(BizObject bizObject) {'||chr(10)||'        return super.create(bizObject);'||chr(10)||'    }'||chr(10)||'}'||chr(10)||'', 'BUSINESS_RULE', '默认业务规则-新增');
INSERT INTO h_source_code_template (id, code, createdTime, creater, deleted, modifiedTime, modifier, remarks, content, codeType, name) VALUES ('2c928d4484f5cd9b0184f5d09bbb04e5', 'DeleteHandlerTemplate', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, '0', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, NULL, 'package com.authine.cloudpivot.engine.service.bizrule.handler;'||chr(10)||chr(10)||'import com.authine.cloudpivot.engine.domain.runtime.BizObject;'||chr(10)||chr(10)||'public class SourceCodeTemplateClassName extends DeleteHandler {'||chr(10)||'    @Override'||chr(10)||'    protected void delete(BizObject bizObject) {'||chr(10)||'        super.delete(bizObject);'||chr(10)||'    }'||chr(10)||'}'||chr(10)||'', 'BUSINESS_RULE', '默认业务规则-删除');
INSERT INTO h_source_code_template (id, code, createdTime, creater, deleted, modifiedTime, modifier, remarks, content, codeType, name) VALUES ('2c928d4484f5cd9b0184f5d09bc104e7', 'GetListHandlerTemplate', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, '0', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, NULL, 'package com.authine.cloudpivot.engine.service.bizrule.handler;'||chr(10)||chr(10)||'import com.authine.cloudpivot.engine.component.query.api.Page;'||chr(10)||'import com.authine.cloudpivot.foundation.orm.api.model.BizObjectQueryObject;'||chr(10)||chr(10)||'import java.util.Map;'||chr(10)||chr(10)||'public class SourceCodeTemplateClassName extends GetListHandler {'||chr(10)||chr(10)||'    @Override'||chr(10)||'    protected Page<Map<String, Object>> getList(BizObjectQueryObject bizObjectQueryObject) {'||chr(10)||'        return super.getList(bizObjectQueryObject);'||chr(10)||'    }'||chr(10)||'}'||chr(10)||'', 'BUSINESS_RULE', '默认业务规则-获取列表');
INSERT INTO h_source_code_template (id, code, createdTime, creater, deleted, modifiedTime, modifier, remarks, content, codeType, name) VALUES ('2c928d4484f5cd9b0184f5d09bc904e9', 'LoadHandlerTemplate', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, '0', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, NULL, 'package com.authine.cloudpivot.engine.service.bizrule.handler;'||chr(10)||chr(10)||'import com.authine.cloudpivot.engine.domain.runtime.BizObject;'||chr(10)||'import com.authine.cloudpivot.foundation.orm.api.model.BizObjectOptions;'||chr(10)||chr(10)||'import java.util.Optional;'||chr(10)||chr(10)||'public class SourceCodeTemplateClassName extends LoadHandler {'||chr(10)||chr(10)||'    @Override'||chr(10)||'    protected Optional<BizObject> load(BizObject bizObject, BizObjectOptions options) {'||chr(10)||'        return super.load(bizObject, options);'||chr(10)||'    }'||chr(10)||'}'||chr(10)||'', 'BUSINESS_RULE', '默认业务规则-查询');
INSERT INTO h_source_code_template (id, code, createdTime, creater, deleted, modifiedTime, modifier, remarks, content, codeType, name) VALUES ('2c928d4484f5cd9b0184f5d09bcf04eb', 'UpdateHandlerTemplate', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, '0', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, NULL, 'package com.authine.cloudpivot.engine.service.bizrule.handler;'||chr(10)||chr(10)||'import com.authine.cloudpivot.engine.domain.runtime.BizObject;'||chr(10)||'import com.authine.cloudpivot.foundation.orm.api.model.BizObjectOptions;'||chr(10)||chr(10)||'public class SourceCodeTemplateClassName extends UpdateHandler {'||chr(10)||'    @Override'||chr(10)||'    protected Object update(BizObject bizObject, BizObjectOptions options) {'||chr(10)||'        return super.update(bizObject, options);'||chr(10)||'    }'||chr(10)||'}'||chr(10)||'', 'BUSINESS_RULE', '默认业务规则-更新');
INSERT INTO h_source_code_template (id, code, createdTime, creater, deleted, modifiedTime, modifier, remarks, content, codeType, name) VALUES ('2c928d4484fa33380184fa34d96d04d6', 'CustomizedHandlerTemplate', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, '0', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, NULL, 'package com.authine.cloudpivot.engine.service.bizrule.handler;'||chr(10)||chr(10)||'import com.authine.cloudpivot.engine.domain.runtime.BizObject;'||chr(10)||'import com.authine.cloudpivot.engine.service.bizrule.handler.context.Request;'||chr(10)||chr(10)||'import java.util.Map;'||chr(10)||chr(10)||'public class SourceCodeTemplateClassName extends BaseHandler {'||chr(10)||'    @Override'||chr(10)||'    public Object handle(Request request) {'||chr(10)||'        //获取bo'||chr(10)||'        BizObject bizObject = request.getData().getBizObject();'||chr(10)||'        //获取自定义业务规则执行参数'||chr(10)||'        Map<String, Object> param = request.getData().getCustomParams();'||chr(10)||'        //do something'||chr(10)||'        return bizObject;'||chr(10)||'    }'||chr(10)||'}'||chr(10)||'', 'BUSINESS_RULE', '自定义业务规则');

ALTER TABLE h_business_rule ADD (developmentMode varchar2(15));
comment on column h_business_rule.developmentMode is '业务规则开发模式(图形化：DEFAULT，在线编码：CODING)';