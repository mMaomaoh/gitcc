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
            where TABLE_NAME like upper(CONCAT('I%\_', properties.SCHEMACODE))
              and TABLESPACE_NAME = 'USERS';
            IF iCount = 0 THEN
                CONTINUE;
            END IF;
            SELECT TABLE_NAME
            INTO iTableName
            FROM ALL_TABLES
            where TABLE_NAME like upper(CONCAT('I%\_', properties.SCHEMACODE))
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