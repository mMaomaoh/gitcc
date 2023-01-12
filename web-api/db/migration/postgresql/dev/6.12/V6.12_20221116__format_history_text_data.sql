create function getUnitId(selectionstr character varying) returns character varying
    language plpgsql
as
$$
declare
    beginIndex int;
    endIndex int;
    tempStr    varchar(4000);
    result varchar(200);
begin

    if selectionStr is null then
        return null;
    end if;

    select position('"id"' in selectionStr) into beginIndex;
    if beginIndex = 0 then
        return selectionStr;
    end if;

    select substr(selectionStr, beginIndex + 6) into tempStr;

    select position('"' in tempStr) into endIndex;

    select substr(tempStr, 0, endIndex) into result;

    return result;
end;
$$;

create function getUnitType(selectionstr character varying) returns character varying
    language plpgsql
as
$$
declare
    beginIndex int;
    result varchar(200);
begin

    if selectionStr is null then
        return null;
    end if;

    select position('"type"' in selectionStr) into beginIndex;
    if beginIndex = 0 then
        return selectionStr;
    end if;

    select substr(selectionStr, beginIndex + 7, 1) into result;

    return result;
end;
$$;


create function getUnitIdAndType(selectionstr character varying) returns character varying
    language plpgsql
as
$$
declare
    selectionType varchar(4000);
    selectionId    varchar(4000);
    result varchar(200);
begin

    if selectionStr is null then
        return null;
    end if;

    select getUnitId(selectionStr) into selectionId;
    if selectionId = selectionstr then
        return selectionstr;
    end if;
    select getUnitType(selectionStr) into selectionType;
    if selectionType = selectionstr then
        return selectionstr;
    end if;
    select selectionId || '_' || selectionType into result;
    return result;
end;
$$;

create function getMultiUnitId(selectionstr character varying) returns character varying
    language plpgsql
as
$$
declare
    num int;
    tempStr varchar(4000);
    tempResult varchar(4000);
    result varchar(4000);
begin

    if selectionStr is null then
        return null;
    end if;

    num := 1;

    for tempStr in select regexp_split_to_table(selectionStr,'},{')
    loop
        select getunitid(tempStr) into tempResult;

        if(num = 1) then
            select tempResult into result;
        else
            select result || ';' || tempResult into result;
        end if;
        num := num + 1;
    end loop;

    return result;
end;
$$;

create function getMultiUnitIdAndType(selectionstr character varying) returns character varying
    language plpgsql
as
$$
declare
    num int;
    tempStr varchar(4000);
    tempResult varchar(4000);
    result varchar(4000);
begin

    if selectionStr is null then
        return null;
    end if;

    num = 1;

    for tempStr in select regexp_split_to_table(selectionStr,'},{')
    loop
        select getunitidandtype(tempStr) into tempResult;

        if( num = 1) then
            select tempResult into result;
        else
            select result || ';' || tempResult into result;
        end if;
        num = num + 1;
    end loop;

    return result;
end;
$$;

create procedure modifyselector()
    language plpgsql
as
$$
declare
    vSchemaCode   varchar(200);
    vPropertyCode varchar(200);
    vPropertyType varchar(200);
    iCount        int;
    iTableName    varchar(200);
    vSql          varchar(4000);
    -- 查询出人员单选、部门单选类型的数据项
    properties cursor for
        select schemaCode, code, propertyType
        from h_biz_property
        where propertyType in ('STAFF_MULTI_SELECTOR', 'DEPARTMENT_MULTI_SELECTOR', 'SELECTION')
          and published = '1';
begin
    open properties;
    fetch properties into vSchemaCode,vPropertyCode,vPropertyType;

    while FOUND
        loop
            -- 判断是否存在i表
            select count(*) into iCount from pg_tables where tablename like 'i%\_' || lower(vSchemaCode);
            if iCount = 0 then
                fetch properties into vSchemaCode,vPropertyCode,vPropertyType;
                continue;
            end if;

            select tablename into iTableName from pg_tables where tablename like 'i%\_' || lower(vSchemaCode);

            -- 更新数据
            if vPropertyType = 'SELECTION' then
                vSql := 'update ' || iTableName || ' set "' || vPropertyCode || '" = getMultiUnitIdAndType("' || vPropertyCode || '");';
            else
                vSql := 'update ' || iTableName || ' set "' || vPropertyCode || '" = getMultiUnitId("' || vPropertyCode || '");';
            end if;

            RAISE NOTICE '%', vSql;
            execute (vSql);
            fetch properties into vSchemaCode,vPropertyCode,vPropertyType;
        end loop;
end;
$$;

create procedure modifydropdownandaddress()
    language plpgsql
as
$$
declare
    vSchemaCode   varchar(200);
    vPropertyCode varchar(200);
    iCount        int;
    iTableName    varchar(200);
    vSql          varchar(4000);
    -- 查询出人员单选、部门单选类型的数据项
    properties cursor for
        select schemaCode, code
        from h_biz_property
        where propertyType = 'DROPDOWN_BOX'
          and published = '1';
begin
    open properties;
    fetch properties into vSchemaCode,vPropertyCode;

    while FOUND
        loop
            -- 判断是否存在i表
            select count(*) into iCount from pg_tables where tablename like 'i%\_' || lower(vSchemaCode);
            if iCount = 0 then
                fetch properties into vSchemaCode,vPropertyCode;
                continue;
            end if;

            select tablename into iTableName from pg_tables where tablename like 'i%\_' || lower(vSchemaCode);

            -- 修改字段类型
            vSql := 'alter table ' || iTableName || ' alter column "' || vPropertyCode || '" type varchar(200);';
            RAISE NOTICE '%', vSql;
            execute (vSql);
            fetch properties into vSchemaCode,vPropertyCode;
        end loop;
end;
$$;
