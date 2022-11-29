ALTER TABLE h_biz_query add options text DEFAULT NULL COMMENT '扩展配置';

DELIMITER $$
create function getSelectionId(selectionStr varchar(4000)) returns varchar(200) DETERMINISTIC
begin
    declare beginIndex int;
    declare endIndex int;
    declare result varchar(200);
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
DELIMITER ;

DELIMITER $$
create procedure modifyStaffAndDeptSelector()
begin
    declare vPropertyCode varchar(200);
    declare vSchemaCode varchar(200);
    DECLARE done INT DEFAULT 0;
    declare iTableName varchar(200);
    declare iCount int;
    declare iSql varchar(4000);
    -- 查询出所有人员单选、部门单选类型的控件
    declare properties cursor for
        select schemaCode, code
        from h_biz_property
        where propertyType in ('STAFF_SELECTOR', 'DEPARTMENT_SELECTOR')
          and defaultProperty = 0
          and published = 1;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    open properties;
    repeat
        fetch properties into vSchemaCode, vPropertyCode;
        if !done then
            select count(*)
            into iCount
            from INFORMATION_SCHEMA.TABLES
            WHERE TABLE_SCHEMA = database()
              and table_name LIKE concat('i%_', vSchemaCode);

            if iCount = 1 then
                select TABLE_NAME
                into iTableName
                FROM INFORMATION_SCHEMA.TABLES
                WHERE TABLE_SCHEMA = database()
                  and table_name LIKE concat('i%_', vSchemaCode);

-- 更新数据 只保留id
                set iSql = concat('update ', iTableName, ' set ', vPropertyCode, ' = getSelectionId(',
                                  vPropertyCode, ')');
                select iSql;
                set @vSql = iSql;
                PREPARE stmt FROM @vSql;
                EXECUTE stmt;

                -- 修改字段类型
                set iSql = concat('alter table ', iTableName, ' modify ', vPropertyCode, ' varchar(200)');
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




