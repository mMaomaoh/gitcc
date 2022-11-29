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

