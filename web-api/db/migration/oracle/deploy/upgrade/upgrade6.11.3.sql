ALTER TABLE h_biz_query add options clob;
comment on column h_biz_query.options is '扩展配置';

create function getSelectionId(selectionStr varchar2) return varchar2
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


create procedure modifyStaffAndDeptSelector(sensitive int)
as
    iTableName        VARCHAR2(200); -- 表名
    iCount       INT; -- 计数
    columnName VARCHAR2(200); -- 原字段名
    newColumnName  VARCHAR2(200); -- 新字段名
    vSql         VARCHAR2(2000); -- sql语句
begin

    -- 1.查询出所有人员单选 部门单选类型的数据
    -- 2.根据数据模型编码查询表名
    for properties in (select *
                       from H_BIZ_PROPERTY
                       where PROPERTYTYPE in ('STAFF_SELECTOR', 'DEPARTMENT_SELECTOR')
                         AND DEFAULTPROPERTY = '0'
                         and PUBLISHED = '1')
        loop
            -- 如果不存在表 就跳过执行
            SELECT COUNT(*)
            INTO iCount
            FROM USER_TABLES
            where TABLESPACE_NAME = 'USERS'
              AND TABLE_NAME like upper(CONCAT('I%\_', properties.SCHEMACODE)) ESCAPE '\';
            IF iCount = 0 THEN
                CONTINUE;
            END IF;
            SELECT TABLE_NAME
            INTO iTableName
            FROM ALL_TABLES
            where TABLESPACE_NAME = 'USERS'
              AND TABLE_NAME like upper(CONCAT('I%\_', properties.SCHEMACODE)) ESCAPE '\';

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
            vSql := 'ALTER TABLE ' || iTableName || ' ADD ' || newColumnName || ' VARCHAR2(200)';
            DBMS_OUTPUT.PUT_LINE(vSql);
            EXECUTE IMMEDIATE vSql;

            -- 把clob字段的内容更新至新字段
            vSql := 'UPDATE ' || iTableName || ' SET ' || newColumnName || ' = getSelectionId(TO_CHAR(' ||
                     columnName || '))';
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




