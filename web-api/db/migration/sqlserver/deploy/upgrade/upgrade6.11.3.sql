ALTER TABLE h_biz_query add options ntext;
GO

CREATE function getSelectionId(@selectionStr nvarchar(max)) returns nvarchar(200)
as
begin
    declare @beginIndex int;
    declare @endIndex int;
    declare @result nvarchar(200);
    if @selectionStr is null
        return null;


    set @beginIndex = charindex('"id"', @selectionStr);
    if @beginIndex = 0
        return @selectionStr;

    set @endIndex = charindex('"', @selectionStr, @beginIndex + 6);

    set @result = substring(@selectionStr,@beginIndex + 6, @endIndex - @beginIndex - 6)

    return @result;
end
go




CREATE proc modifyStaffAndDeptSelector
as
begin
    declare @vSchemaCode varchar(200);
    declare @vPropertyCode varchar(200);
    declare @iCount int;
    declare @iTableName varchar(200);
    declare @sql varchar(4000);
    declare properties cursor for
        select schemaCode, code
        from h_biz_property
        where propertyType in ('STAFF_SELECTOR', 'DEPARTMENT_SELECTOR')
          and defaultProperty = 0
          and published = 1;
    open properties;
    fetch next from properties into @vSchemaCode,@vPropertyCode
    while @@fetch_status = 0
        begin
            set @iCount = (select count(*)
                           from INFORMATION_SCHEMA.TABLES
                           where TABLE_TYPE = 'BASE TABLE'
                             and TABLE_NAME like concat('i%_', @vSchemaCode));
            if @iCount = 0
                begin
                    fetch next from properties into @vSchemaCode,@vPropertyCode
                    continue;
                end
            set @iTableName = (select TABLE_NAME
                               from INFORMATION_SCHEMA.TABLES
                               where TABLE_TYPE = 'BASE TABLE'
                                 and TABLE_NAME like concat('i%_', @vSchemaCode));

                            -- 更新数据
            set @sql = 'update ' + @iTableName + ' set ' + @vPropertyCode + ' = dbo.getSelectionId(' +
                       @vPropertyCode + ');';
            print @sql;
            execute (@sql);

            -- 修改字段类型
            set @sql = 'alter table ' + @iTableName + ' alter column ' + @vPropertyCode + ' nvarchar(200); ';
            print @sql;
            execute (@sql);
            fetch next from properties into @vSchemaCode,@vPropertyCode
        end
    close properties;
    deallocate properties;
end
go


