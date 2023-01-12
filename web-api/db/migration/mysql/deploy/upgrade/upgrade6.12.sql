CREATE TABLE `h_biz_import_task` (
    `id` varchar(36) COLLATE utf8_bin NOT NULL COMMENT 'primary key',
    `importTime` datetime DEFAULT NULL COMMENT '导入时间',
    `startTime` datetime DEFAULT NULL COMMENT '开始时间',
    `endTime` datetime DEFAULT NULL COMMENT '结束时间',
    `userId` varchar(36) COLLATE utf8_bin DEFAULT NULL COMMENT '用户id',
    `schemaCode` varchar(50) COLLATE utf8_bin DEFAULT NULL COMMENT '模型编码',
    `taskStatus` varchar(50) COLLATE utf8_bin DEFAULT NULL COMMENT '任务状态',
    `lastHeartTime` datetime DEFAULT NULL COMMENT '最近一次心跳时间',
    `threadName` varchar(150) COLLATE utf8_bin DEFAULT NULL COMMENT '任务执行线程',
    `operationResultJson` longtext COMMENT '导入操作结果',
    `originalFilename` longtext COMMENT '文件名',
    PRIMARY KEY (`id`),
    KEY `idx_h_biz_import_task_userId` (`userId`) USING BTREE,
    KEY `idx_h_biz_import_task_schemaCode` (`schemaCode`) USING BTREE,
    KEY `idx_h_biz_import_task_threadName` (`threadName`) USING BTREE,
    KEY `idx_h_biz_import_task_heart` (`lastHeartTime`,`taskStatus`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

create unique index uq_code on h_report_page (code);

ALTER TABLE `h_workflow_trust_rule` ADD COLUMN `deptRangeType` varchar(20) DEFAULT NULL COMMENT '发起人部门范围类型，全部：ALL；部分：PART';

ALTER TABLE `h_workflow_trust_rule` ADD COLUMN `originatorDepartments` longtext DEFAULT NULL COMMENT '发起人部门id，逗号分隔';

update h_workflow_trust_rule set deptRangeType='ALL' where trustType='APPROVAL';

ALTER TABLE h_open_api_event MODIFY COLUMN clientId varchar(100);

ALTER TABLE h_open_api_event ADD creater varchar(120) NULL COMMENT '创建人';
ALTER TABLE h_open_api_event ADD createdTime DATETIME NULL COMMENT '创建时间';
ALTER TABLE h_open_api_event ADD modifier varchar(120) NULL COMMENT '修改人';
ALTER TABLE h_open_api_event ADD modifiedTime DATETIME NULL COMMENT '修改时间';
ALTER TABLE h_open_api_event ADD remarks varchar(200) NULL COMMENT '备注';
ALTER TABLE h_open_api_event ADD deleted bit(1) NULL COMMENT '删除标识';

CREATE TABLE h_subscribe_message (
  id varchar(100) NOT NULL,
  callbackUrl varchar(255) COMMENT '回调地址',
  eventTarget varchar(200) COMMENT '事件对象',
  eventTargetType varchar(255) COMMENT '事件对象类型',
  eventType varchar(255) COMMENT '事件触发类型',
  eventKey varchar(200) COMMENT '事件标识符',
  eventParam longtext COMMENT '时间推送内容',
  applicationName varchar(200) COMMENT '容器名称',
  pushTime datetime COMMENT '推送时间',
  retryTimes int(11) COMMENT '重试次数',
  createdTime datetime COMMENT '创建时间',
  modifiedTime datetime COMMENT '修改时间',
  options longtext COMMENT '扩展参数',
  status varchar(100) COMMENT '推送状态',
  PRIMARY KEY (id)
) ENGINE=InnoDB;


CREATE TABLE h_subscribe_message_history (
  id varchar(100) NOT NULL,
  callbackUrl varchar(255) COMMENT '回调地址',
  eventTarget varchar(200) COMMENT '事件对象',
  eventTargetType varchar(255) COMMENT '事件对象类型',
  eventType varchar(255) COMMENT '事件触发类型',
  eventKey varchar(200) COMMENT '事件标识符',
  eventParam longtext COMMENT '时间推送内容',
  applicationName varchar(200) COMMENT '容器名称',
  pushTime datetime COMMENT '推送时间',
  retryTimes int(11) COMMENT '重试次数',
  createdTime datetime COMMENT '创建时间',
  modifiedTime datetime COMMENT '修改时间',
  options longtext COMMENT '扩展参数',
  status varchar(100) COMMENT '推送状态',
  PRIMARY KEY (id)
) ENGINE=InnoDB;

alter table h_biz_data_track add sourceSchemaCode varchar(50) null comment '源模型编码';
alter table h_biz_data_track add sourceSchemaName varchar(200) null comment '源模型名称';
alter table h_biz_data_track add sourceBizObjectId varchar(50) null comment '源触发数据id';
alter table h_biz_data_track add sourceBizObjectName varchar(200) null comment '源触发数据标题';

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


DELIMITER $$
create function getUnitId(selectionStr mediumtext) returns mediumtext DETERMINISTIC
begin
    declare beginIndex int;
    declare endIndex int;
    declare result mediumtext;
    if selectionStr is null then
        return selectionStr;
    end if;

    -- [{"id":"123","type":3}]
    -- 先找到"id"对应的下标
    select LOCATE('"id"', selectionStr) into beginIndex;

    if beginIndex = 0 then
        return selectionStr;
    end if;

    -- 在拼接 "id":" 的长度，找到id结尾的下标
    select LOCATE('"', selectionStr, beginIndex + 6) into endIndex;

    if endIndex = 0 then
        return null;
    end if;

    -- 截取id
    select substr(selectionStr, beginIndex + 6, endIndex - beginIndex - 6) into result;

    return result;
end $$

DELIMITER $$
create function getUnitType(selectionStr mediumtext) returns mediumtext DETERMINISTIC
begin
    declare beginIndex int;
    declare result mediumtext;
    if selectionStr is null then
        return selectionStr;
    end if;

    -- [{"id":"123","type":3}]
    -- 先找到"id"对应的下标
    select LOCATE('"type"', selectionStr) into beginIndex;

    if beginIndex = 0 then
        return selectionStr;
    end if;

    -- 截取type
    select substr(selectionStr, beginIndex + 7, 1) into result;

    return result;
end $$

DELIMITER $$
create function getUnitIdAndType(selectionStr mediumtext) returns mediumtext DETERMINISTIC
begin
    declare selectionId mediumtext;
    declare selectionType mediumtext;
    declare result mediumtext;

    if selectionStr is null then
        return null;
    end if;

    select getUnitId(selectionStr) into selectionId;
    if(strcmp(selectionId ,selectionStr) = 0) then
        return selectionStr;
    end if;

    select getUnitType(selectionStr) into selectionType;
    if(strcmp(selectionType ,selectionStr) = 0) then
        return selectionStr;
    end if;

    select CONCAT(selectionId,'_',selectionType) into result;

    return result;
end $$

DELIMITER $$
create function getMultiUnitId(selectionStr mediumtext) returns mediumtext DETERMINISTIC
begin
    declare num int;
    declare i int;
    declare tempStr mediumtext;
    declare tempResult mediumtext;
    declare result mediumtext;

    if selectionStr is null then
        return null;
    end if;

    select (length(selectionStr) - length(replace(selectionStr,'},{','')))/3 into num;

    set i = 1;

    while i <= num + 1 do
        select substring_index(substring_index(selectionStr,'},{',i),'},{',-1) into tempStr;
        select getUnitId(tempStr) into tempResult;
        if( i = 1)
            then
                select tempResult into result;
            else
                select CONCAT(result,';',tempResult) into result;
            end if;
        set i = i+1;
    end while ;

    return result;
end $$

DELIMITER $$
create function getMultiUnitIdAndType(selectionStr mediumtext) returns mediumtext DETERMINISTIC
begin
    declare num int;
    declare i int;
    declare tempStr mediumtext;
    declare tempResult mediumtext;
    declare result mediumtext;

    if selectionStr is null then
        return null;
    end if;

    select (length(selectionStr) - length(replace(selectionStr,'},{','')))/3 into num;

    set i = 1;

    while i <= num + 1 do
        select substring_index(substring_index(selectionStr,'},{',i),'},{',-1) into tempStr;
        select getUnitIdAndType(tempStr) into tempResult;
        if( i = 1)
            then
                select tempResult into result;
            else
                select CONCAT(result,';',tempResult) into result;
            end if;
        set i = i+1;
    end while ;

    return result;
end $$
DELIMITER ;

DELIMITER $$
create procedure modifySelector()
begin
    declare vPropertyType varchar(200);
    declare vPropertyCode varchar(200);
    declare vSchemaCode varchar(200);
    DECLARE done INT DEFAULT 0;
    declare iTableName varchar(200);
    declare iCount int;
    declare iSql varchar(4000);
    -- 查询出所有人员单选、部门单选类型的控件
    declare properties cursor for
        select schemaCode, code, propertyType
        from h_biz_property
        where propertyType in ('STAFF_MULTI_SELECTOR', 'DEPARTMENT_MULTI_SELECTOR','SELECTION')  and published = 1;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    open properties;
    repeat
        fetch properties into vSchemaCode, vPropertyCode, vPropertyType;
        if !done then
            select count(*)
            into iCount
            from INFORMATION_SCHEMA.TABLES
            WHERE TABLE_SCHEMA = database()
              and table_name LIKE concat('i%\_', vSchemaCode);

            if iCount = 1 then
                select TABLE_NAME
                into iTableName
                FROM INFORMATION_SCHEMA.TABLES
                WHERE TABLE_SCHEMA = database()
                  and table_name LIKE concat('i%\_', vSchemaCode);

                if(vPropertyType = 'SELECTION')
                    then
                        set iSql = concat('update ', iTableName, ' set ', vPropertyCode, ' = getMultiUnitIdAndType(', vPropertyCode, ')');
                    else
                        set iSql = concat('update ', iTableName, ' set ', vPropertyCode, ' = getMultiUnitId(', vPropertyCode, ')');
                end if;
                select iSql;
                set @vSql = iSql;
                PREPARE stmt FROM @vSql;
                EXECUTE stmt;

            end if;
        end if;
    until done end repeat;
    close properties;
end $$
DELIMITER ;

DELIMITER $$
create procedure modifyDropdownAndAddress()
begin
    declare vPropertyType varchar(200);
    declare vPropertyCode varchar(200);
    declare vSchemaCode varchar(200);
    DECLARE done INT DEFAULT 0;
    declare iTableName varchar(200);
    declare iCount int;
    declare iSql varchar(200);
    -- 查询出所有人员单选、部门单选类型的控件
    declare properties cursor for
        select schemaCode, code,propertyType
        from h_biz_property
        where propertyType in ('DROPDOWN_BOX','ADDRESS')  and published = 1;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    open properties;
    repeat
        fetch properties into vSchemaCode, vPropertyCode, vPropertyType;
        if !done then
            select count(*)
            into iCount
            from INFORMATION_SCHEMA.TABLES
            WHERE TABLE_SCHEMA = database()
              and table_name LIKE concat('i%\_', vSchemaCode);

            if iCount = 1 then
                select TABLE_NAME
                into iTableName
                FROM INFORMATION_SCHEMA.TABLES
                WHERE TABLE_SCHEMA = database()
                  and table_name LIKE concat('i%\_', vSchemaCode);

                -- 修改字段类型
                if(vPropertyType = 'DROPDOWN_BOX')
                    then
                        set iSql = concat('alter table ', iTableName, ' modify ', vPropertyCode, ' varchar(200)');
                    else
                        set iSql = concat('alter table ', iTableName, ' modify ', vPropertyCode, ' varchar(500)');
                    end if;
                select iSql;
                set @vSql = iSql;
                PREPARE stmt FROM @vSql;
                EXECUTE stmt;
            end if;
        end if;
    until done end repeat;
    close properties;
end $$
DELIMITER ;

CREATE TABLE `h_source_code` (
  `id` varchar(120) NOT NULL,
  `code` varchar(120) NOT NULL COMMENT '源代码编码',
  `createdTime` datetime DEFAULT NULL,
  `creater` varchar(120) DEFAULT NULL,
  `deleted` bit(1) DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `modifier` varchar(120) DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `content` longtext COMMENT '源码',
  `codeType` varchar(15) DEFAULT NULL COMMENT '源码类型',
  `published` bit(1) DEFAULT NULL COMMENT '是否生效',
  `version` int DEFAULT NULL COMMENT '版本号',
  `originalVersion` int DEFAULT NULL COMMENT '源版本号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;
create index idx_h_source_code_code on h_source_code (code);

CREATE TABLE `h_source_code_template` (
  `id` varchar(120) NOT NULL,
  `code` varchar(120) NOT NULL COMMENT '模板编码',
  `createdTime` datetime DEFAULT NULL,
  `creater` varchar(120) DEFAULT NULL,
  `deleted` bit(1) DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `modifier` varchar(120) DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `content` longtext COMMENT '源码',
  `codeType` varchar(15) DEFAULT NULL COMMENT '源码类型',
  `name` varchar(100) DEFAULT NULL COMMENT '模板名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;
create unique index idx_h_source_code_template_code on h_source_code_template (code, codeType);

INSERT INTO `h_source_code_template` (`id`, `code`, `createdTime`, `creater`, `deleted`, `modifiedTime`, `modifier`, `remarks`, `content`, `codeType`, `name`) VALUES ('2c928d4484f5cd9b0184f5d048e204dd', 'AvailableHandlerTemplate', '2022-12-09 15:36:19', NULL, b'0', '2022-12-09 15:36:22', NULL, NULL, 'package com.authine.cloudpivot.engine.service.bizrule.handler;\n\nimport com.authine.cloudpivot.engine.service.bizrule.handler.context.Request;\n\npublic class SourceCodeTemplateClassName extends AvailableHandler {\n    @Override\n    public Object handle(Request request) {\n        return super.handle(request);\n    }\n}\n', 'BUSINESS_RULE', '默认业务规则-流程生效');
INSERT INTO `h_source_code_template` (`id`, `code`, `createdTime`, `creater`, `deleted`, `modifiedTime`, `modifier`, `remarks`, `content`, `codeType`, `name`) VALUES ('2c928d4484f5cd9b0184f5d07d4004e0', 'CancelHandlerTemplate', '2022-12-09 15:36:32', NULL, b'0', '2022-12-09 15:36:40', NULL, NULL, 'package com.authine.cloudpivot.engine.service.bizrule.handler;\n\nimport com.authine.cloudpivot.engine.service.bizrule.handler.context.Request;\n\npublic class SourceCodeTemplateClassName extends CancelHandler {\n    @Override\n    public Object handle(Request request) {\n        return super.handle(request);\n    }\n}\n', 'BUSINESS_RULE', '默认业务规则-流程取消');
INSERT INTO `h_source_code_template` (`id`, `code`, `createdTime`, `creater`, `deleted`, `modifiedTime`, `modifier`, `remarks`, `content`, `codeType`, `name`) VALUES ('2c928d4484f5cd9b0184f5d09bb404e3', 'CreateHandlerTemplate', '2022-12-09 15:36:40', NULL, b'0', '2022-12-09 15:36:40', NULL, NULL, 'package com.authine.cloudpivot.engine.service.bizrule.handler;\n\nimport com.authine.cloudpivot.engine.domain.runtime.BizObject;\n\npublic class SourceCodeTemplateClassName extends CreateHandler {\n    @Override\n    protected BizObject create(BizObject bizObject) {\n        return super.create(bizObject);\n    }\n}\n', 'BUSINESS_RULE', '默认业务规则-新增');
INSERT INTO `h_source_code_template` (`id`, `code`, `createdTime`, `creater`, `deleted`, `modifiedTime`, `modifier`, `remarks`, `content`, `codeType`, `name`) VALUES ('2c928d4484f5cd9b0184f5d09bbb04e5', 'DeleteHandlerTemplate', '2022-12-09 15:36:40', NULL, b'0', '2022-12-09 15:36:40', NULL, NULL, 'package com.authine.cloudpivot.engine.service.bizrule.handler;\r\n\r\nimport com.authine.cloudpivot.engine.domain.runtime.BizObject;\r\n\r\npublic class SourceCodeTemplateClassName extends DeleteHandler {\r\n    @Override\r\n    protected void delete(BizObject bizObject) {\r\n        super.delete(bizObject);\r\n    }\r\n}\r\n', 'BUSINESS_RULE', '默认业务规则-删除');
INSERT INTO `h_source_code_template` (`id`, `code`, `createdTime`, `creater`, `deleted`, `modifiedTime`, `modifier`, `remarks`, `content`, `codeType`, `name`) VALUES ('2c928d4484f5cd9b0184f5d09bc104e7', 'GetListHandlerTemplate', '2022-12-09 15:36:40', NULL, b'0', '2022-12-09 15:36:40', NULL, NULL, 'package com.authine.cloudpivot.engine.service.bizrule.handler;\n\nimport com.authine.cloudpivot.engine.component.query.api.Page;\nimport com.authine.cloudpivot.foundation.orm.api.model.BizObjectQueryObject;\n\nimport java.util.Map;\n\npublic class SourceCodeTemplateClassName extends GetListHandler {\n\n    @Override\n    protected Page<Map<String, Object>> getList(BizObjectQueryObject bizObjectQueryObject) {\n        return super.getList(bizObjectQueryObject);\n    }\n}\n', 'BUSINESS_RULE', '默认业务规则-获取列表');
INSERT INTO `h_source_code_template` (`id`, `code`, `createdTime`, `creater`, `deleted`, `modifiedTime`, `modifier`, `remarks`, `content`, `codeType`, `name`) VALUES ('2c928d4484f5cd9b0184f5d09bc904e9', 'LoadHandlerTemplate', '2022-12-09 15:36:40', NULL, b'0', '2022-12-09 15:36:40', NULL, NULL, 'package com.authine.cloudpivot.engine.service.bizrule.handler;\n\nimport com.authine.cloudpivot.engine.domain.runtime.BizObject;\nimport com.authine.cloudpivot.foundation.orm.api.model.BizObjectOptions;\n\nimport java.util.Optional;\n\npublic class SourceCodeTemplateClassName extends LoadHandler {\n\n    @Override\n    protected Optional<BizObject> load(BizObject bizObject, BizObjectOptions options) {\n        return super.load(bizObject, options);\n    }\n}\n', 'BUSINESS_RULE', '默认业务规则-查询');
INSERT INTO `h_source_code_template` (`id`, `code`, `createdTime`, `creater`, `deleted`, `modifiedTime`, `modifier`, `remarks`, `content`, `codeType`, `name`) VALUES ('2c928d4484f5cd9b0184f5d09bcf04eb', 'UpdateHandlerTemplate', '2022-12-09 15:36:40', NULL, b'0', '2022-12-09 15:36:40', NULL, NULL, 'package com.authine.cloudpivot.engine.service.bizrule.handler;\n\nimport com.authine.cloudpivot.engine.domain.runtime.BizObject;\nimport com.authine.cloudpivot.foundation.orm.api.model.BizObjectOptions;\n\npublic class SourceCodeTemplateClassName extends UpdateHandler {\n    @Override\n    protected Object update(BizObject bizObject, BizObjectOptions options) {\n        return super.update(bizObject, options);\n    }\n}\n', 'BUSINESS_RULE', '默认业务规则-更新');
INSERT INTO `h_source_code_template` (`id`, `code`, `createdTime`, `creater`, `deleted`, `modifiedTime`, `modifier`, `remarks`, `content`, `codeType`, `name`) VALUES ('2c928d4484fa33380184fa34d96d04d6', 'CustomizedHandlerTemplate', '2022-12-10 12:04:38', NULL, b'0', '2022-12-10 12:04:38', NULL, NULL, 'package com.authine.cloudpivot.engine.service.bizrule.handler;\n\nimport com.authine.cloudpivot.engine.domain.runtime.BizObject;\nimport com.authine.cloudpivot.engine.service.bizrule.handler.context.Request;\n\nimport java.util.Map;\n\npublic class SourceCodeTemplateClassName extends BaseHandler {\n    @Override\n    public Object handle(Request request) {\n        //获取bo\n        BizObject bizObject = request.getData().getBizObject();\n        //获取自定义业务规则执行参数\n        Map<String, Object> param = request.getData().getCustomParams();\n        //do something\n        return bizObject;\n    }\n}\n', 'BUSINESS_RULE', '自定义业务规则');

ALTER TABLE h_business_rule ADD developmentMode VARCHAR(15) DEFAULT NULL COMMENT '业务规则开发模式(图形化：DEFAULT，在线编码：CODING)';