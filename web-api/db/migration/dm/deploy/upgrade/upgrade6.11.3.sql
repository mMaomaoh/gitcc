ALTER TABLE h_biz_query add options clob;
comment on column h_biz_query.options is '扩展配置';

CREATE OR REPLACE FUNCTION "GETSELECTIONID"("SELECTIONSTR" IN VARCHAR(4000))
RETURN VARCHAR(200)

AS
    vResult VARCHAR(200);
    beginIndex int;
    endIndex int;
BEGIN
    IF SELECTIONSTR is null THEN
     return null;
    END IF;
    
    beginIndex := instr(SELECTIONSTR, '"id"');
    if beginIndex = 0 then
    	return SELECTIONSTR;
    end if;
    
    endIndex := instr(SELECTIONSTR, '"', beginIndex + 6);
    
    vResult := substr(SELECTIONSTR, beginIndex + 6, endIndex - beginIndex - 6);
    RETURN vResult;
END;


CREATE OR REPLACE PROCEDURE "MODIFYSTAFFANDDEPTSELECTOR"
AS
     vPropertyCode varchar(200);
     vSchemaCode varchar(200);
     iTableName varchar(200);
     iCount int;
     vSql varchar(4000);
     columnName varchar(200);
     newColumnName varchar(200);
     cursor properties is select schemaCode, code
        from h_biz_property
        where propertyType in ('STAFF_SELECTOR', 'DEPARTMENT_SELECTOR')
          and defaultProperty = 0
          and published = 1; 
BEGIN
	open properties;
	loop
		fetch properties into vSchemaCode, vPropertyCode;
		
		exit when properties%notfound;
		iCount := (select count(*) from user_tables where table_name like upper(concat('I%_', vSchemaCode)));
		if iCount = 0 then
			continue;
		end if;	
		
		columnName := '"' || vPropertyCode || '"';
		newColumnName := '"' || vPropertyCode || '__TEMP"';
		
		iTableName := (select table_name from user_tables where table_name like upper(concat('I%_', vSchemaCode))); 
		
		vSql := 'alter table ' || iTableName || ' add ' || newColumnName || ' varchar(200);';
		print(vSql);
		EXECUTE IMMEDIATE vSql;
		
		vSql := 'update ' || iTableName || ' set ' || newColumnName || ' = JSON_VALUE(' || columnName || ',''$.id'')';
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


