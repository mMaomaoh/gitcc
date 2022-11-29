ALTER TABLE h_im_work_record MODIFY COLUMN `title` varchar(200) default '';
ALTER TABLE h_im_work_record_history MODIFY COLUMN `title` varchar(200) default '';

ALTER TABLE h_im_message MODIFY COLUMN `title` varchar(200) default '';
ALTER TABLE h_im_message_history MODIFY COLUMN `title` varchar(200) default '';
ALTER TABLE  h_biz_data_track_detail ADD COLUMN  title varchar(200) NULL DEFAULT NULL COMMENT '留痕数据标题' AFTER name;
ALTER TABLE  h_biz_query_condition ADD COLUMN includeSubData bit(1) NULL DEFAULT NULL COMMENT '是否包含字数据' AFTER visible;
CREATE TABLE `h_user_draft` (
  `id` varchar(120) NOT NULL,
  `creater` varchar(120) DEFAULT NULL,
  `createdTime` datetime DEFAULT NULL,
  `deleted` bit(1) DEFAULT NULL,
  `modifier` varchar(120) DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `userId` varchar(100) NOT NULL COMMENT '用户ID',
  `name` varchar(200) NOT NULL COMMENT '标题【流程名称或者表单标题】',
  `bizObjectKey` varchar(100) DEFAULT NULL COMMENT 'BO数据对象ID',
  `formType` varchar(100) DEFAULT NULL COMMENT '表单类型：MODEL、WORKFLOW、WORKITEM',
  `workflowInstanceId` varchar(100) DEFAULT NULL COMMENT '流程实例ID',
  `schemaCode` varchar(100) DEFAULT NULL COMMENT '模型编码',
  `sheetCode` varchar(100) DEFAULT NULL COMMENT '表单编码',
  PRIMARY KEY (`id`),
  KEY `idx_user_draft_userId` (`userId`),
  KEY `idx_user_draft_objectKey` (`bizObjectKey`) USING BTREE
) ENGINE=InnoDB COMMENT='用户草稿';
ALTER TABLE biz_workflow_instance ADD COLUMN workflowName varchar(255) NULL COMMENT '流程模板名称';

ALTER TABLE biz_workflow_instance_bak ADD COLUMN workflowName varchar(255) NULL COMMENT '流程模板名称';
ALTER TABLE  h_biz_query_column ADD COLUMN syncDefaultFormat bit(1) NULL DEFAULT NULL COMMENT '是否同步默认格式';
CREATE TABLE `h_im_message_station` (
  `id` varchar(36) NOT NULL COMMENT '主键ID',
  `bizParams` longtext COMMENT '业务参数表',
  `content` longtext COMMENT '内容',
  `createdTime` datetime DEFAULT NULL COMMENT '创建时间',
  `messageType` varchar(40) DEFAULT NULL COMMENT '消息类型，STATION_MESSAGE-站内消息；COMMENT_MESSAGE-评论消息',
  `modifiedTime` datetime DEFAULT NULL COMMENT '修改时间',
  `title` varchar(100) DEFAULT NULL COMMENT '标题',
  `sender` varchar(42) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '消息关联的发起人',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_message_station_id` (`id`) USING BTREE
) ENGINE=InnoDB COMMENT='站内消息表';

CREATE TABLE `h_im_message_station_user` (
  `id` varchar(36)  NOT NULL COMMENT '主键ID',
  `modifiedTime` datetime DEFAULT NULL COMMENT '修改时间',
  `receiver` varchar(42)  DEFAULT NULL COMMENT '接收者',
  `messageId` varchar(36)  DEFAULT NULL COMMENT '消息id',
  `readState` varchar(255)  DEFAULT NULL COMMENT 'READED-已读、UNREADED-未读',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_message_station_id` (`id`) USING BTREE,
  KEY `idx_receiver` (`receiver`),
  KEY `idx_readState` (`readState`)
) ENGINE=InnoDB COMMENT='站内消息用户关系表';

-- !!!树形-批量向模型表中添加treePath_、treeLevel_字段
DROP PROCEDURE IF EXISTS addTreePathParam;
-- 1.创建存储过程
DELIMITER &&
CREATE PROCEDURE `addTreePathParam`()
BEGIN
    DECLARE vSchemaCode VARCHAR(50) DEFAULT '';
    DECLARE vTableName VARCHAR(100) DEFAULT '';
    DECLARE vAlterSQL VARCHAR(500) DEFAULT '';
    DECLARE nCount int DEFAULT 0;
    DECLARE nCount2 int DEFAULT 0;
    DECLARE done INT DEFAULT 0;
    DECLARE taskCursor CURSOR FOR select code from h_biz_schema where modelType = 'TREE' and published=1;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    OPEN taskCursor;
    REPEAT
        FETCH taskCursor INTO vSchemaCode;
        IF NOT done THEN

					 select CONCAT("i", appNameSpace, "_",vSchemaCode) into vTableName from h_app_package where `code` = (select appCode from h_app_function where code = vSchemaCode);
					 if vTableName is not null then
						 select count(0) into nCount from h_biz_property where schemaCode = vSchemaCode and code = 'treePath_';
						 if nCount = 0 then
								SET vAlterSQL = concat('ALTER TABLE ', vTableName, ' ADD COLUMN `treePath_` varchar(200) default null COMMENT \'路径\'');
								set @vSql = vAlterSQL;
								PREPARE stmt FROM @vSql;
								EXECUTE stmt;
								INSERT INTO `h_biz_property` (`id`, `createdTime`, `deleted`, `code`,`defaultProperty`, `name`, `propertyEmpty`,  `propertyIndex`, `propertyLength`, `propertyType`, `published`, `schemaCode`)
								VALUES (replace(uuid(), '-', ''), now(), false, 'treePath_', false, '路径', false, false, 512, 'SHORT_TEXT', true, vSchemaCode);
						 end if;
						 select count(0) into nCount2 from h_biz_property where schemaCode = vSchemaCode and code = 'treeLevel_';
						 if nCount2 = 0 then
							SET vAlterSQL = concat('ALTER TABLE ', vTableName, ' ADD COLUMN `treeLevel_` decimal(25, 8) default 1 COMMENT \'层级\'');
								set @vSql = vAlterSQL;
								PREPARE stmt FROM @vSql;
								EXECUTE stmt;
								INSERT INTO `h_biz_property` (`id`, `createdTime`, `deleted`, `code`,`defaultProperty`, `name`, `propertyEmpty`,  `propertyIndex`, `propertyLength`, `propertyType`, `published`, `schemaCode`)
								VALUES (replace(uuid(), '-', ''), now(), false, 'treeLevel_', false, '层级', false, false, 12, 'NUMERICAL', true, vSchemaCode);
						 end if;
					 end if;
        END IF;
    UNTIL done END REPEAT;
    CLOSE taskCursor;
END;
&&
DELIMITER ;
-- 2.执行存储过程 !!! 默认当前库，可修改需要执行的库名
CALL addTreePathParam();
-- 3.执行完删除
DROP PROCEDURE IF EXISTS addTreePathParam;


-- !!!刷新树形模型 treePath_、treeLevel_字段
DROP PROCEDURE IF EXISTS doBuildTreePath;
DELIMITER &&
CREATE PROCEDURE doBuildTreePath(IN vTableName VARCHAR(50), IN vParentId VARCHAR(50), IN vPath VARCHAR(512))
BEGIN

  DECLARE done INT DEFAULT 0;
  DECLARE vId VARCHAR(50) DEFAULT '';
  DECLARE vTreePath VARCHAR(512) DEFAULT '';

  DECLARE taskCursor CURSOR FOR (select id, treePath_ from tree_view_temp);
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

	DROP VIEW IF EXISTS tree_view_temp;
	SET @sqlstr = CONCAT('CREATE VIEW tree_view_temp as SELECT id,treePath_ FROM ', vTableName, ' WHERE parentId = \'',  vParentId, '\'');
	if vParentId is null then
		SET @sqlstr = CONCAT('CREATE VIEW tree_view_temp as SELECT id,treePath_ FROM ', vTableName, ' WHERE parentId is null');
	end if;
	PREPARE stmt FROM @sqlstr;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

  SET @@max_sp_recursion_depth = 30;

  OPEN taskCursor;
  REPEAT
    FETCH taskCursor INTO vId, vTreePath;
    IF NOT done THEN
-- 	     call log(concat('开始执行 1 vTableName=', vTableName, ' vParentId=', IFNULL(vParentId, '')));
		   SET @sql1 = concat('select count(0) into @item_count from ', vTableName , ' where id = \'', vId, '\'');
       PREPARE stmt1 FROM @sql1;
			 EXECUTE stmt1;
			 if @item_count > 0 then
					SET @vFullPath = concat(vPath, '/', vId);
					SET @sql1 = concat('update ', vTableName, ' set treePath_ = \'', @vFullPath, '\', treeLevel_ = length(\'', @vFullPath,'\')-length(replace(\'',@vFullPath,'\',\'/\',\'\')) where id = \'', vId, '\'');
					PREPARE stmt1 FROM @sql1;
					EXECUTE stmt1;
					CALL doBuildTreePath(vTableName, vId, @vFullPath);
			 end if;
    END IF;
  UNTIL done END REPEAT;
  CLOSE taskCursor;
END;
&&
DELIMITER ;
DROP PROCEDURE IF EXISTS buildTreePath;
DELIMITER &&
CREATE PROCEDURE buildTreePath()
BEGIN
    DECLARE vSchemaCode VARCHAR(50) DEFAULT '';
    DECLARE vTableName VARCHAR(100) DEFAULT '';
    DECLARE done INT DEFAULT 0;
    DECLARE taskCursor CURSOR FOR select code from h_biz_schema where modelType = 'TREE' and  published=1;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    OPEN taskCursor;
    REPEAT
        FETCH taskCursor INTO vSchemaCode;
        IF NOT done THEN
					 select CONCAT("i", appNameSpace, "_",vSchemaCode) into vTableName from h_app_package where `code` = (select appCode from h_app_function where code = vSchemaCode);
					 if vTableName is not null then
						    call doBuildTreePath(vTableName, null, '');
					 end if;
        END IF;
    UNTIL done END REPEAT;
    CLOSE taskCursor;
END;
&&
DELIMITER ;

CALL buildTreePath();

DROP PROCEDURE IF EXISTS buildTreePath;
DROP PROCEDURE IF EXISTS doBuildTreePath;

alter table h_org_user add userWorkStatus varchar(32) null;
update h_org_user set userWorkStatus  = 'NORMAL' where deleted is false;
update h_org_user set userWorkStatus  = 'DIMISSION' where deleted is true;

create table h_org_user_transfer_record
(
    id              varchar(120)  not null primary key,
    processUserId   varchar(120)  null,
    processTime     datetime      null,
    sourceUserId    varchar(120)  null,
    receiveUserId   varchar(120)  null,
    transferType    varchar(32)   null,
    transferSize    int           null,
    comments         varchar(2048) null
);


create table h_org_user_transfer_detail
(
    id           varchar(120) not null primary key,
    recordId     varchar(120) not null,
    transferData text         null
);
create index idx_record_id on h_org_user_transfer_detail (recordId);

update h_system_sms_template set params = '[{"key":"name","value":""}]' where id = '2c928ff67de11137017de119dec601c2';
update h_system_sms_template set params = '[{"key":"name","value":"流程的标题"},{"key":"creater","value":"流程发起人"}]' where id = '2c928ff67de11137017de11d5b3001c4';

ALTER TABLE h_biz_sheet ADD COLUMN existDraft bit(1) NULL  COMMENT '是否存在未发布的草稿内容';

update  h_biz_schema set deleted = 1 where code in (select code from h_app_function where deleted = 1 and type = 'BizModel');

create unique index uq_corpId_sourceId on h_org_department (corpId, sourceId);

create unique index uq_corpId_sourceId on h_org_role (corpId, sourceId);

drop index idx_rolde_code on h_org_role;
create unique index uq_role_code on h_org_role (code);

drop index idx_role_group_code on h_org_role_group;
drop index idx_role_group_id on h_org_role_group;
create unique index uq_role_group_code on h_org_role_group (code);

create index idx_corpId_userId on h_org_user (userId,corpId);

create index idx_dept_id on h_org_dept_user (deptId);

ALTER TABLE h_user_favorites MODIFY COLUMN bizObjectKey varchar(200) DEFAULT NULL AFTER remarks;

ALTER TABLE h_org_user MODIFY COLUMN imgUrlId varchar(200) DEFAULT NULL COMMENT '头像id';
ALTER TABLE h_app_package MODIFY COLUMN logoUrlId varchar(200) DEFAULT NULL ;

ALTER TABLE h_biz_attachment MODIFY COLUMN `bizObjectId` varchar(200) NOT NULL AFTER `id`;