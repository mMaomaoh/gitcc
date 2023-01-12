create or replace function getUnitId(selectionStr in varchar(4000))
    return varchar(200)
as
    beginIndex  int;
    endIndex  int;
    selectionId varchar(200);
begin
    if selectionStr is null then
        return selectionStr;
    end if;

    beginIndex := instr(selectionStr, '"id"');

    if beginIndex = 0 then
    	return selectionStr;
    end if;

    endIndex := instr(selectionStr, '"', beginIndex + 6);

    selectionId := substr(selectionStr, beginIndex + 6, endIndex - beginIndex - 6);
    return selectionId;
end;

create or replace function getUnitType(selectionStr varchar2) return varchar2
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

create or replace function getUnitIdAndType(selectionStr varchar2) return varchar2
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

create or replace function getMultiUnitId(selectionStr varchar2) return varchar2
as
    num int;
    indexFlag int;
    tempStr varchar2(2000);
    tempResult varchar2(2000);
    result varchar2(2000);
    strLength int;
    beginIndex int;
begin
    if selectionStr is null then
        return null;
    end if;

    select (length(selectionStr) - length(replace(selectionStr,'},{','')))/3 into num from dual;

    beginIndex := 1;

    for indexFlag in 1 .. num + 1 loop
        if indexFlag < num + 1 then
            select instr(selectionStr,'},{',beginIndex,1) - beginIndex into strLength from dual;
            select substr(selectionStr,beginIndex,strLength) into tempStr from dual;
        else
            select length(selectionStr) - beginIndex + 1 into strLength from dual;
            select substr(selectionStr,beginIndex,strLength) into tempStr from dual;
        end if;

        select getUnitId(tempStr) into tempResult from dual;

        if indexFlag = 1 then
                result := tempResult ;
            else
                result := result || ';' || tempResult ;
        end if;

        beginIndex := beginIndex + strLength + 3;

    end loop;

    return result;
end;
/

create or replace function getMultiUnitIdAndType(selectionStr varchar2) return varchar2
as
    num int;
    indexFlag int;
    tempStr varchar2(2000);
    tempResult varchar2(2000);
    result varchar2(2000);
    strLength int;
    beginIndex int;
begin
    if selectionStr is null then
        return null;
    end if;

    select (length(selectionStr) - length(replace(selectionStr,'},{','')))/3 into num from dual;

    beginIndex := 1;

    for indexFlag in 1 .. num + 1 loop
        if indexFlag < num + 1 then
            select instr(selectionStr,'},{',beginIndex,1) - beginIndex into strLength from dual;
            select substr(selectionStr,beginIndex,strLength) into tempStr from dual;
        else
            select length(selectionStr) - beginIndex + 1 into strLength from dual;
            select substr(selectionStr,beginIndex,strLength) into tempStr from dual;
        end if;

        select getUnitIdAndType(tempStr) into tempResult from dual;

        if indexFlag = 1 then
                result := tempResult ;
            else
                result := result || ';' || tempResult ;
        end if;

        beginIndex := beginIndex + strLength + 3;


    end loop;

    return result;
end;
/


CREATE OR REPLACE PROCEDURE modifySelector
AS
     vPropertyCode varchar(200);
     vPropertyType varchar(200);
     vSchemaCode varchar(200);
     iTableName varchar(200);
     iCount int;
     vSql varchar(4000);
     columnName varchar(200);
     newColumnName varchar(200);
     cursor properties is select schemaCode, code, propertyType
        from h_biz_property
        where propertyType in ('SELECTION', 'DEPARTMENT_MULTI_SELECTOR', 'STAFF_MULTI_SELECTOR')
          and published = 1;
BEGIN
	open properties;
	loop
		fetch properties into vSchemaCode, vPropertyCode, vPropertyType;

		exit when properties%notfound;
		iCount := (select count(*) from user_tables where table_name like upper(concat('I%\_', vSchemaCode)) escape '\');
		if iCount = 0 then
			continue;
		end if;

		columnName := '"' || vPropertyCode || '"';
		newColumnName := '"' || vPropertyCode || '__TEMP"';

		iTableName := (select table_name from user_tables where table_name like upper(concat('I%\_', vSchemaCode)) escape '\');

		vSql := 'alter table ' || iTableName || ' add ' || newColumnName || ' varchar(2000);';
		print(vSql);
		EXECUTE IMMEDIATE vSql;

		if vPropertyType = 'SELECTION'
		then
			vSql := 'update ' || iTableName || ' set ' || newColumnName || ' = getMultiUnitIdAndType(' || columnName || ')';
		else
			vSql := 'update ' || iTableName || ' set ' || newColumnName || ' = getMultiUnitId(' || columnName || ')';
		end if;
		print(vSql);
		EXECUTE IMMEDIATE vSql;
		commit;

		vSql := 'alter table ' || iTableName || ' drop column ' || columnName;
		print(vSql);
		EXECUTE IMMEDIATE vSql;

		vSql := 'alter table ' || iTableName || ' RENAME COLUMN ' || newColumnName || ' TO ' || columnName;
		print(vSql);
		EXECUTE IMMEDIATE vSql;
	end loop;
	close properties;
END;


CREATE OR REPLACE PROCEDURE modifyClob
AS
     vPropertyCode varchar(200);
     vPropertyType varchar(200);
     vSchemaCode varchar(200);
     iTableName varchar(200);
     iCount int;
     vSql varchar(4000);
     columnName varchar(200);
     newColumnName varchar(200);
     cursor properties is select schemaCode, code, propertyType
        from h_biz_property
        where propertyType in ('DROPDOWN_BOX', 'CHECKBOX', 'MULT_WORK_SHEET', 'DROPDOWN_MULTI_BOX')
          and published = 1;
BEGIN
	open properties;
	loop
		fetch properties into vSchemaCode, vPropertyCode, vPropertyType;

		exit when properties%notfound;
		iCount := (select count(*) from user_tables where table_name like upper(concat('I%\_', vSchemaCode)) escape '\');
		if iCount = 0 then
			continue;
		end if;

		columnName := '"' || vPropertyCode || '"';
		newColumnName := '"' || vPropertyCode || '__TEMP"';

		iTableName := (select table_name from user_tables where table_name like upper(concat('I%\_', vSchemaCode)) escape '\');

		if vPropertyType = 'DROPDOWN_BOX'
		then
			vSql := 'alter table ' || iTableName || ' add ' || newColumnName || ' varchar(200);';
		else
			vSql := 'alter table ' || iTableName || ' add ' || newColumnName || ' varchar(2000);';
		end if;
		print(vSql);
		EXECUTE IMMEDIATE vSql;

		vSql := 'update ' || iTableName || ' set ' || newColumnName || ' = to_char(' || columnName || ')';
		print(vSql);
		EXECUTE IMMEDIATE vSql;
		commit;

		vSql := 'alter table ' || iTableName || ' drop column ' || columnName;
		print(vSql);
		EXECUTE IMMEDIATE vSql;

		vSql := 'alter table ' || iTableName || ' RENAME COLUMN ' || newColumnName || ' TO ' || columnName;
		print(vSql);
		EXECUTE IMMEDIATE vSql;
	end loop;
	close properties;
END;
