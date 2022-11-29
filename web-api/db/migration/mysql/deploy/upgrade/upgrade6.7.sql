DROP TABLE IF EXISTS `h_system_notify_setting`;
CREATE TABLE `h_system_notify_setting` (
  `id` varchar(120) NOT NULL,
  `corpId` varchar(120) DEFAULT NULL,
  `unitType` varchar(20) DEFAULT NULL,
  `msgChannelType` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
-- 批量向模型表中添加version字段
DROP PROCEDURE IF EXISTS addVersionParam;
-- 1.创建存储过程
DELIMITER //
CREATE PROCEDURE `addVersionParam`(IN vDBName VARCHAR(100))
BEGIN
    DECLARE vSchemaCode VARCHAR(50) DEFAULT '';
    DECLARE vTableName VARCHAR(100) DEFAULT '';
    DECLARE vAlterSQL VARCHAR(500) DEFAULT '';
    DECLARE nCount int DEFAULT 0;
    DECLARE nCount2 int DEFAULT 0;
    DECLARE nCount3 int DEFAULT 0;
    DECLARE nCount4 int DEFAULT 0;
    DECLARE done INT DEFAULT 0;
    DECLARE taskCursor CURSOR FOR SELECT table_name
                                  FROM INFORMATION_SCHEMA.TABLES
                                  WHERE table_schema = vDBName and table_name LIKE "i%";
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    OPEN taskCursor;
    REPEAT
        FETCH taskCursor INTO vTableName;
        IF NOT done THEN
            set vSchemaCode = SUBSTR(vTableName, LOCATE('_', vTableName) + 1);
            -- 判断是否为模型相关表
            SELECT count(*) into nCount4 FROM h_biz_schema where `code` = vSchemaCode;
            if nCount4 > 0 THEN
                -- 判断表是否存在（可省略）
                SELECT count(*)
                into nCount3
                FROM information_schema.TABLES
                WHERE TABLE_SCHEMA = vDBName and table_name = vTableName;
                if nCount3 > 0 THEN
                    -- 判断该表是否存在该字段
                    SELECT count(*)
                    into nCount2
                    FROM information_schema.columns
                    WHERE TABLE_SCHEMA = vDBName
                      and table_name = vTableName
                      AND column_name = 'version';
                    if nCount2 = 0 THEN
                        SET vAlterSQL = concat('ALTER TABLE ', vTableName,
                                               ' ADD COLUMN `version` decimal(25, 8) default  0.00000000  COMMENT \'版本号\'');
                    ELSE
                        SET vAlterSQL = concat('ALTER TABLE ', vTableName,
                                               ' MODIFY COLUMN `version` decimal(25, 8) default  0.00000000  COMMENT \'版本号\'');
                    end if;
                    set @vSql = vAlterSQL;
                    PREPARE stmt FROM @vSql;
                    EXECUTE stmt;
                    select count(*)
                    into nCount
                    from h_biz_property
                    where schemaCode = vSchemaCode and `code` = 'version';
                    if nCount = 0 THEN
                        INSERT INTO `h_biz_property` (`id`, `createdTime`, `creater`, `deleted`, `modifiedTime`, `code`,
                                                      `defaultProperty`, `defaultValue`, `name`, `propertyEmpty`,
                                                      `propertyIndex`, `propertyLength`, `propertyType`, `published`,
                                                      `relativeCode`, `schemaCode`, `repeated`)
                        VALUES (replace(uuid(), '-', ''), now(), NULL, false, now(), 'version', true, '0', '版本号', false,
                                false, 12, 'NUMERICAL', true, NULL, vSchemaCode, 0);
                    ELSE
                        UPDATE h_biz_property
                        set propertyType='NUMERICAL',
                            defaultValue='0',
                            `name`='版本号'
                        where schemaCode = vSchemaCode
                          and `code` = 'version';
                    end if;
                end if;
            end if;
        END IF;
    UNTIL done END REPEAT;
    CLOSE taskCursor;
END;
//
DELIMITER ;
-- 2.执行存储过程 !!! 默认当前库，可修改需要执行的库名
CALL addVersionParam(database());
-- 3.执行完删除
DROP PROCEDURE IF EXISTS addVersionParam;
alter table h_related_corp_setting add syncConfig varchar(2048) null;

alter table h_related_corp_setting add customizeRelateType varchar(64) null;

alter table h_related_corp_setting add mailListConfig varchar(2048) null;
alter table h_report_datasource_permission add parentObjectId varchar(64) null after objectId;
alter table h_biz_database_pool add datasourceType varchar(40) null;
update h_biz_database_pool set datasourceType = 'DATABASE';
alter table h_biz_database_pool add externInfo longtext null;
ALTER TABLE h_app_function 
ADD INDEX idx_type_ac (type, appCode) USING BTREE;
-- 附件表refid索引
ALTER TABLE `h_biz_attachment` ADD INDEX idx_h_biz_attachment_refid(`refid`);

-- 流程模板 编码和版本号联合索引
ALTER TABLE `h_workflow_template` ADD INDEX `idx_workflow_template_code_verison` (`workflowCode`,`workflowVersion`);

-- 展示字段 视图id和排序值联合索引
ALTER TABLE `h_biz_query_column` ADD INDEX `idx_biz_query_column_queryId_sortKey` (`queryId`,`sortKey`);

-- 查询字段 视图id和排序值联合索引
ALTER TABLE `h_biz_query_condition` ADD INDEX `idx_biz_query_condition_queryId_sortKey` (`queryId`,`sortKey`);

-- 用户表 账号名和组织id联合索引
ALTER TABLE `h_org_user` ADD INDEX `idx_org_user_username_corpid` (`username`,`corpId`);
