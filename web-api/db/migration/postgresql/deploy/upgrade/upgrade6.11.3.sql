ALTER TABLE h_biz_query ADD COLUMN options text DEFAULT NULL;

commit;

create function getselectionid(selectionstr character varying) returns character varying
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

create procedure modifystaffanddeptselector()
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
        where propertyType in ('STAFF_SELECTOR', 'DEPARTMENT_SELECTOR')
          and defaultProperty = '0'
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

            -- 更新数据
            vSql := 'update ' || iTableName || ' set "' || vPropertyCode || '" = getSelectionId("' || vPropertyCode ||
                     '");';
            RAISE NOTICE '%', vSql;
            execute (vSql);

            -- 修改字段类型
            vSql := 'alter table ' || iTableName || ' alter column "' || vPropertyCode || '" type varchar(200);';
            RAISE NOTICE '%', vSql;
            execute (vSql);
            fetch properties into vSchemaCode,vPropertyCode;
        end loop;
end;
$$;