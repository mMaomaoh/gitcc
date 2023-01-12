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