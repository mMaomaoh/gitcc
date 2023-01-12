CREATE TABLE h_biz_import_task (
    id nvarchar(120) NOT NULL primary key,
    importTime datetime  NULL,
    startTime datetime  NULL,
    endTime datetime  NULL,
    userId nvarchar(120)  NULL,
    schemaCode nvarchar(200)  NULL,
    taskStatus nvarchar(200)  NULL,
    lastHeartTime datetime  NULL,
    threadName nvarchar(150)  NULL,
    operationResultJson ntext,
    originalFilename ntext
)
go

CREATE INDEX idx_h_b_i_t_userId ON h_biz_import_task (userId)
go

CREATE INDEX idx_h_b_i_t_schemaCode ON h_biz_import_task (schemaCode)
go

CREATE INDEX idx_h_b_i_t_threadName ON h_biz_import_task (threadName)
go

CREATE INDEX idx_h_b_i_t_heart ON h_biz_import_task (lastHeartTime,taskStatus)
go

create unique index uq_rp_code on h_report_page(code)
go

ALTER TABLE h_workflow_trust_rule add deptRangeType nvarchar(20);
GO

ALTER TABLE h_workflow_trust_rule add originatorDepartments ntext;
GO

update h_workflow_trust_rule set deptRangeType='ALL' where trustType='APPROVAL';

ALTER TABLE h_open_api_event ALTER COLUMN clientId nvarchar(100)
go
ALTER TABLE h_open_api_event ADD creater nvarchar(120)
go
ALTER TABLE h_open_api_event ADD createdTime datetime
go
ALTER TABLE h_open_api_event ADD modifier nvarchar(120)
go
ALTER TABLE h_open_api_event ADD modifiedTime datetime
go
ALTER TABLE h_open_api_event ADD remarks nvarchar(200)
go
ALTER TABLE h_open_api_event ADD deleted bit
go

CREATE TABLE h_subscribe_message (
  id nvarchar(100) not null primary key,
  callbackUrl nvarchar(255),
  eventTarget nvarchar(200),
  eventTargetType nvarchar(255),
  eventType nvarchar(255),
  eventKey nvarchar(200),
  eventParam ntext,
  applicationName nvarchar(200),
  pushTime datetime,
  retryTimes int,
  createdTime datetime,
  modifiedTime datetime,
  options ntext,
  status nvarchar(100)
)
go

CREATE TABLE h_subscribe_message_history (
  id nvarchar(100) not null primary key,
  callbackUrl nvarchar(255),
  eventTarget nvarchar(200),
  eventTargetType nvarchar(255),
  eventType nvarchar(255),
  eventKey nvarchar(200),
  eventParam ntext,
  applicationName nvarchar(200),
  pushTime datetime,
  retryTimes int,
  createdTime datetime,
  modifiedTime datetime,
  options ntext,
  status nvarchar(100)
)
go

ALTER TABLE h_biz_data_track ADD sourceSchemaCode nvarchar(50)
go
ALTER TABLE h_biz_data_track ADD sourceSchemaName nvarchar(200)
go
ALTER TABLE h_biz_data_track ADD sourceBizObjectId nvarchar(50)
go
ALTER TABLE h_biz_data_track ADD sourceBizObjectName nvarchar(200)
go

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


CREATE function getUnitId(@selectionStr nvarchar(max)) returns nvarchar(max)
as
begin
    declare @beginIndex int;
    declare @endIndex int;
    declare @result nvarchar(max);
    if @selectionStr is null
        return null;


    set @beginIndex = charindex('"id"', @selectionStr);
    if @beginIndex = 0
        return @selectionStr;

    set @endIndex = charindex('"', @selectionStr, @beginIndex + 6);

    set @result = substring(@selectionStr, @beginIndex + 6, @endIndex - @beginIndex - 6)

    return @result;
end
go


create function getUnitType(@selectionStr varchar(max)) returns nvarchar(max)
as
begin
    declare @beginIndex int;
    declare @result nvarchar(max);
    if @selectionStr is null
        return @selectionStr;

    set @beginIndex = charindex('"type"', @selectionStr)
    if @beginIndex = 0
        return @selectionStr;

    -- 截取type
    set @result = substring(@selectionStr, @beginIndex + 7, 1);

    return @result;
end
go


create function getUnitIdAndType(@selectionStr varchar(max)) returns nvarchar(max)
as
begin
    declare @selectionId nvarchar(max);
    declare @selectionType nvarchar(max);
    declare @result nvarchar(max);

    if @selectionStr is null
        return null;

    set @selectionId = dbo.getUnitId(@selectionStr);
    if @selectionId = @selectionStr
        return @selectionStr;
    set @selectionType = dbo.getUnitId(@selectionStr);
    if @selectionType = @selectionStr
        return @selectionStr;
    set @result = concat(@selectionId, '_', @selectionType);

    return @result;
end
go


CREATE function getMultiUnitId(@selectionStr nvarchar(max)) returns nvarchar(max)
as
begin
    declare @num int;
    declare @i int;
    declare @tempStr nvarchar(max);
    declare @tempResult nvarchar(max);
    declare @result nvarchar(max);
    declare @beginIndex int;
    declare @length int;

    if @selectionStr is null
        return null;

    set @num = (len(@selectionStr) - len(replace(@selectionStr, '},{', ''))) / 3;
    set @beginIndex = 1;
    set @i = 1;

    while @i <= @num + 1
        begin
            if (@i  < @num + 1)
                begin
                    set @length = charindex('},{',@selectionStr,@beginIndex) - @beginIndex;
                    set @tempStr = substring(@selectionStr,@beginIndex,@length);
                end
            else
                begin
                    set @length = len(@selectionStr) - @beginIndex + 1;
                    set @tempStr = substring(@selectionStr,@beginIndex,@length);
                end

            set @tempResult = dbo.getUnitId(@tempStr);

            if (@i = 1)
                set @result = @tempResult ;
            else
                set @result = CONCAT(@result, ';', @tempResult) ;

            set @beginIndex = @beginIndex + @length + 3;
            set @i = @i + 1;
        end

    return @result;
end
go

CREATE function getMultiUnitIdAndType(@selectionStr nvarchar(max)) returns nvarchar(max)
as
begin
    declare @num int;
    declare @i int;
    declare @tempStr nvarchar(max);
    declare @tempResult nvarchar(max);
    declare @result nvarchar(max);
    declare @beginIndex int;
    declare @length int;

    if @selectionStr is null
        return null;

    set @num = (len(@selectionStr) - len(replace(@selectionStr, '},{', ''))) / 3;
    set @beginIndex = 1;
    set @i = 1;

    while @i <= @num + 1
        begin
            if (@i  < @num + 1)
                begin
                set @length = charindex('},{',@selectionStr,@beginIndex) - @beginIndex;
                set @tempStr = substring(@selectionStr,@beginIndex,@length);
                end
            else
                begin
                    set @length = len(@selectionStr) - @beginIndex + 1;
                    set @tempStr = substring(@selectionStr,@beginIndex,@length);
                end

            set @tempResult = dbo.getUnitIdAndType (@tempStr);

            if (@i = 1)
                set @result = @tempResult ;
            else
                set @result = CONCAT(@result, ';', @tempResult) ;

            set @beginIndex = @beginIndex + @length + 3;
            set @i = @i + 1;
        end

    return @result;
end
go

CREATE proc modifySelector
as
begin
    declare @vSchemaCode varchar(200);
    declare @vPropertyCode varchar(200);
    declare @vPropertyType varchar(200);
    declare @iCount int;
    declare @iTableName varchar(200);
    declare @sql varchar(4000);
    declare properties cursor for
        select schemaCode, code, propertyType
        from h_biz_property
        where propertyType in ('STAFF_MULTI_SELECTOR', 'DEPARTMENT_MULTI_SELECTOR', 'SELECTION')
          and published = 1;
    open properties;
    fetch next from properties into @vSchemaCode,@vPropertyCode,@vPropertyType
    while @@fetch_status = 0
        begin
            set @iCount = (select count(*)
                           from INFORMATION_SCHEMA.TABLES
                           where TABLE_TYPE = 'BASE TABLE'
                             and TABLE_NAME like concat('i%\_', @vSchemaCode) escape '\');
            if @iCount = 0
                begin
                    fetch next from properties into @vSchemaCode,@vPropertyCode,@vPropertyType
                    continue;
                end
            set @iTableName = (select TABLE_NAME
                               from INFORMATION_SCHEMA.TABLES
                               where TABLE_TYPE = 'BASE TABLE'
                                 and TABLE_NAME like concat('i%\_', @vSchemaCode) escape '\');

            -- 更新数据
            if (@vPropertyType = 'SELECTION')
                set @sql = 'update ' + @iTableName + ' set ' + @vPropertyCode + ' = dbo.getMultiUnitIdAndType(' +
                           @vPropertyCode + ');';
            else
                set @sql = 'update ' + @iTableName + ' set ' + @vPropertyCode + ' = dbo.getMultiUnitId(' +
                           @vPropertyCode + ');';
            print @sql;
            execute (@sql);
            fetch next from properties into @vSchemaCode,@vPropertyCode,@vPropertyType
        end
    close properties;
    deallocate properties;
end
go

CREATE proc modifyDropdownAndAddress
as
begin
    declare @vSchemaCode varchar(200);
    declare @vPropertyCode varchar(200);
    declare @vPropertyType varchar(200);
    declare @iCount int;
    declare @iTableName varchar(200);
    declare @sql varchar(4000);
    declare properties cursor for
        select schemaCode, code, propertyType
        from h_biz_property
        where propertyType in ('DROPDOWN_BOX', 'ADDRESS')
          and published = 1;
    open properties;
    fetch next from properties into @vSchemaCode,@vPropertyCode,@vPropertyType
    while @@fetch_status = 0
        begin
            set @iCount = (select count(*)
                           from INFORMATION_SCHEMA.TABLES
                           where TABLE_TYPE = 'BASE TABLE'
                             and TABLE_NAME like concat('i%\_', @vSchemaCode)  escape '\');
            if @iCount = 0
                begin
                    fetch next from properties into @vSchemaCode,@vPropertyCode,@vPropertyType
                    continue;
                end
            set @iTableName = (select TABLE_NAME
                               from INFORMATION_SCHEMA.TABLES
                               where TABLE_TYPE = 'BASE TABLE'
                                 and TABLE_NAME like concat('i%\_', @vSchemaCode) escape '\');

            if (@vPropertyType = 'DROPDOWN_BOX')
                set @sql = 'alter table ' + @iTableName + ' alter column ' + @vPropertyCode + ' nvarchar(200); ';
            else
                set @sql = 'alter table ' + @iTableName + ' alter column ' + @vPropertyCode + ' nvarchar(500); ';
            print @sql;
            execute (@sql);

            fetch next from properties into @vSchemaCode,@vPropertyCode,@vPropertyType
        end
    close properties;
    deallocate properties;
end
go

CREATE TABLE h_source_code (
  id nvarchar(120) NOT NULL PRIMARY KEY,
  code nvarchar(120) NOT NULL,
  createdTime datetime,
  creater nvarchar(120),
  deleted bit,
  modifiedTime datetime,
  modifier nvarchar(120),
  remarks nvarchar(200),
  content nvarchar(max),
  codeType nvarchar(15),
  published bit,
  version int,
  originalVersion int
);

CREATE INDEX idx_h_source_code_code ON h_source_code (code);

CREATE TABLE h_source_code_template (
  id nvarchar(120) NOT NULL PRIMARY KEY,
  code nvarchar(120) NOT NULL,
  createdTime datetime,
  creater nvarchar(120),
  deleted bit,
  modifiedTime datetime,
  modifier nvarchar(120),
  remarks nvarchar(200),
  content nvarchar(max),
  codeType nvarchar(15),
  name nvarchar(100)
);

CREATE UNIQUE INDEX idx_h_source_code_template_code ON h_source_code_template (code, codeType);

INSERT INTO h_source_code_template (id, code, createdTime, creater, deleted, modifiedTime, modifier, remarks, content, codeType, name) VALUES ('2c928d4484f5cd9b0184f5d048e204dd', 'AvailableHandlerTemplate', '2022-12-09 15:36:19', NULL, '0', '2022-12-09 15:36:19', NULL, NULL, 'package com.authine.cloudpivot.engine.service.bizrule.handler;\n\nimport com.authine.cloudpivot.engine.service.bizrule.handler.context.Request;\n\npublic class SourceCodeTemplateClassName extends AvailableHandler {\n    @Override\n    public Object handle(Request request) {\n        return super.handle(request);\n    }\n}\n', 'BUSINESS_RULE', '默认业务规则-流程生效');
INSERT INTO h_source_code_template (id, code, createdTime, creater, deleted, modifiedTime, modifier, remarks, content, codeType, name) VALUES ('2c928d4484f5cd9b0184f5d07d4004e0', 'CancelHandlerTemplate', '2022-12-09 15:36:19', NULL, '0', '2022-12-09 15:36:19', NULL, NULL, 'package com.authine.cloudpivot.engine.service.bizrule.handler;\n\nimport com.authine.cloudpivot.engine.service.bizrule.handler.context.Request;\n\npublic class SourceCodeTemplateClassName extends CancelHandler {\n    @Override\n    public Object handle(Request request) {\n        return super.handle(request);\n    }\n}\n', 'BUSINESS_RULE', '默认业务规则-流程取消');
INSERT INTO h_source_code_template (id, code, createdTime, creater, deleted, modifiedTime, modifier, remarks, content, codeType, name) VALUES ('2c928d4484f5cd9b0184f5d09bb404e3', 'CreateHandlerTemplate', '2022-12-09 15:36:19', NULL, '0', '2022-12-09 15:36:19', NULL, NULL, 'package com.authine.cloudpivot.engine.service.bizrule.handler;\n\nimport com.authine.cloudpivot.engine.domain.runtime.BizObject;\n\npublic class SourceCodeTemplateClassName extends CreateHandler {\n    @Override\n    protected BizObject create(BizObject bizObject) {\n        return super.create(bizObject);\n    }\n}\n', 'BUSINESS_RULE', '默认业务规则-新增');
INSERT INTO h_source_code_template (id, code, createdTime, creater, deleted, modifiedTime, modifier, remarks, content, codeType, name) VALUES ('2c928d4484f5cd9b0184f5d09bbb04e5', 'DeleteHandlerTemplate', '2022-12-09 15:36:19', NULL, '0', '2022-12-09 15:36:19', NULL, NULL, 'package com.authine.cloudpivot.engine.service.bizrule.handler;\r\n\r\nimport com.authine.cloudpivot.engine.domain.runtime.BizObject;\r\n\r\npublic class SourceCodeTemplateClassName extends DeleteHandler {\r\n    @Override\r\n    protected void delete(BizObject bizObject) {\r\n        super.delete(bizObject);\r\n    }\r\n}\r\n', 'BUSINESS_RULE', '默认业务规则-删除');
INSERT INTO h_source_code_template (id, code, createdTime, creater, deleted, modifiedTime, modifier, remarks, content, codeType, name) VALUES ('2c928d4484f5cd9b0184f5d09bc104e7', 'GetListHandlerTemplate', '2022-12-09 15:36:19', NULL, '0', '2022-12-09 15:36:19', NULL, NULL, 'package com.authine.cloudpivot.engine.service.bizrule.handler;\n\nimport com.authine.cloudpivot.engine.component.query.api.Page;\nimport com.authine.cloudpivot.foundation.orm.api.model.BizObjectQueryObject;\n\nimport java.util.Map;\n\npublic class SourceCodeTemplateClassName extends GetListHandler {\n\n    @Override\n    protected Page<Map<String, Object>> getList(BizObjectQueryObject bizObjectQueryObject) {\n        return super.getList(bizObjectQueryObject);\n    }\n}\n', 'BUSINESS_RULE', '默认业务规则-获取列表');
INSERT INTO h_source_code_template (id, code, createdTime, creater, deleted, modifiedTime, modifier, remarks, content, codeType, name) VALUES ('2c928d4484f5cd9b0184f5d09bc904e9', 'LoadHandlerTemplate', '2022-12-09 15:36:19', NULL, '0', '2022-12-09 15:36:19', NULL, NULL, 'package com.authine.cloudpivot.engine.service.bizrule.handler;\n\nimport com.authine.cloudpivot.engine.domain.runtime.BizObject;\nimport com.authine.cloudpivot.foundation.orm.api.model.BizObjectOptions;\n\nimport java.util.Optional;\n\npublic class SourceCodeTemplateClassName extends LoadHandler {\n\n    @Override\n    protected Optional<BizObject> load(BizObject bizObject, BizObjectOptions options) {\n        return super.load(bizObject, options);\n    }\n}\n', 'BUSINESS_RULE', '默认业务规则-查询');
INSERT INTO h_source_code_template (id, code, createdTime, creater, deleted, modifiedTime, modifier, remarks, content, codeType, name) VALUES ('2c928d4484f5cd9b0184f5d09bcf04eb', 'UpdateHandlerTemplate', '2022-12-09 15:36:19', NULL, '0', '2022-12-09 15:36:19', NULL, NULL, 'package com.authine.cloudpivot.engine.service.bizrule.handler;\n\nimport com.authine.cloudpivot.engine.domain.runtime.BizObject;\nimport com.authine.cloudpivot.foundation.orm.api.model.BizObjectOptions;\n\npublic class SourceCodeTemplateClassName extends UpdateHandler {\n    @Override\n    protected Object update(BizObject bizObject, BizObjectOptions options) {\n        return super.update(bizObject, options);\n    }\n}\n', 'BUSINESS_RULE', '默认业务规则-更新');
INSERT INTO h_source_code_template (id, code, createdTime, creater, deleted, modifiedTime, modifier, remarks, content, codeType, name) VALUES ('2c928d4484fa33380184fa34d96d04d6', 'CustomizedHandlerTemplate', '2022-12-09 15:36:19', NULL, '0', '2022-12-09 15:36:19', NULL, NULL, 'package com.authine.cloudpivot.engine.service.bizrule.handler;\n\nimport com.authine.cloudpivot.engine.domain.runtime.BizObject;\nimport com.authine.cloudpivot.engine.service.bizrule.handler.context.Request;\n\nimport java.util.Map;\n\npublic class SourceCodeTemplateClassName extends BaseHandler {\n    @Override\n    public Object handle(Request request) {\n        //获取bo\n        BizObject bizObject = request.getData().getBizObject();\n        //获取自定义业务规则执行参数\n        Map<String, Object> param = request.getData().getCustomParams();\n        //do something\n        return bizObject;\n    }\n}\n', 'BUSINESS_RULE', '自定义业务规则');

ALTER TABLE h_business_rule ADD developmentMode nvarchar(15);

go