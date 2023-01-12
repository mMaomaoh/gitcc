CREATE function getUnitId(@selectionStr nvarchar(max)) returns nvarchar(max)
as
begin
    declare @beginIndex int;
    declare @endIndex int;
    declare @result nvarchar(max);
    if @selectionStr is null
        return null;


    set @beginIndex = charindex('"id"', @selectionStr);
    if @beginIndex = 0
        return @selectionStr;

    set @endIndex = charindex('"', @selectionStr, @beginIndex + 6);

    set @result = substring(@selectionStr, @beginIndex + 6, @endIndex - @beginIndex - 6)

    return @result;
end
go


create function getUnitType(@selectionStr varchar(max)) returns nvarchar(max)
as
begin
    declare @beginIndex int;
    declare @result nvarchar(max);
    if @selectionStr is null
        return @selectionStr;

    set @beginIndex = charindex('"type"', @selectionStr)
    if @beginIndex = 0
        return @selectionStr;

    -- 截取type
    set @result = substring(@selectionStr, @beginIndex + 7, 1);

    return @result;
end
go


create function getUnitIdAndType(@selectionStr varchar(max)) returns nvarchar(max)
as
begin
    declare @selectionId nvarchar(max);
    declare @selectionType nvarchar(max);
    declare @result nvarchar(max);

    if @selectionStr is null
        return null;

    set @selectionId = dbo.getUnitId(@selectionStr);
    if @selectionId = @selectionStr
        return @selectionStr;
    set @selectionType = dbo.getUnitId(@selectionStr);
    if @selectionType = @selectionStr
        return @selectionStr;
    set @result = concat(@selectionId, '_', @selectionType);

    return @result;
end
go


CREATE function getMultiUnitId(@selectionStr nvarchar(max)) returns nvarchar(max)
as
begin
    declare @num int;
    declare @i int;
    declare @tempStr nvarchar(max);
    declare @tempResult nvarchar(max);
    declare @result nvarchar(max);
    declare @beginIndex int;
    declare @length int;

    if @selectionStr is null
        return null;

    set @num = (len(@selectionStr) - len(replace(@selectionStr, '},{', ''))) / 3;
    set @beginIndex = 1;
    set @i = 1;

    while @i <= @num + 1
        begin
            if (@i  < @num + 1)
                begin
                    set @length = charindex('},{',@selectionStr,@beginIndex) - @beginIndex;
                    set @tempStr = substring(@selectionStr,@beginIndex,@length);
                end
            else
                begin
                    set @length = len(@selectionStr) - @beginIndex + 1;
                    set @tempStr = substring(@selectionStr,@beginIndex,@length);
                end

            set @tempResult = dbo.getUnitId(@tempStr);

            if (@i = 1)
                set @result = @tempResult ;
            else
                set @result = CONCAT(@result, ';', @tempResult) ;

            set @beginIndex = @beginIndex + @length + 3;
            set @i = @i + 1;
        end

    return @result;
end
go

CREATE function getMultiUnitIdAndType(@selectionStr nvarchar(max)) returns nvarchar(max)
as
begin
    declare @num int;
    declare @i int;
    declare @tempStr nvarchar(max);
    declare @tempResult nvarchar(max);
    declare @result nvarchar(max);
    declare @beginIndex int;
    declare @length int;

    if @selectionStr is null
        return null;

    set @num = (len(@selectionStr) - len(replace(@selectionStr, '},{', ''))) / 3;
    set @beginIndex = 1;
    set @i = 1;

    while @i <= @num + 1
        begin
            if (@i  < @num + 1)
                begin
                set @length = charindex('},{',@selectionStr,@beginIndex) - @beginIndex;
                set @tempStr = substring(@selectionStr,@beginIndex,@length);
                end
            else
                begin
                    set @length = len(@selectionStr) - @beginIndex + 1;
                    set @tempStr = substring(@selectionStr,@beginIndex,@length);
                end

            set @tempResult = dbo.getUnitIdAndType (@tempStr);

            if (@i = 1)
                set @result = @tempResult ;
            else
                set @result = CONCAT(@result, ';', @tempResult) ;

            set @beginIndex = @beginIndex + @length + 3;
            set @i = @i + 1;
        end

    return @result;
end
go

CREATE proc modifySelector
as
begin
    declare @vSchemaCode varchar(200);
    declare @vPropertyCode varchar(200);
    declare @vPropertyType varchar(200);
    declare @iCount int;
    declare @iTableName varchar(200);
    declare @sql varchar(4000);
    declare properties cursor for
        select schemaCode, code, propertyType
        from h_biz_property
        where propertyType in ('STAFF_MULTI_SELECTOR', 'DEPARTMENT_MULTI_SELECTOR', 'SELECTION')
          and published = 1;
    open properties;
    fetch next from properties into @vSchemaCode,@vPropertyCode,@vPropertyType
    while @@fetch_status = 0
        begin
            set @iCount = (select count(*)
                           from INFORMATION_SCHEMA.TABLES
                           where TABLE_TYPE = 'BASE TABLE'
                             and TABLE_NAME like concat('i%\_', @vSchemaCode) escape '\');
            if @iCount = 0
                begin
                    fetch next from properties into @vSchemaCode,@vPropertyCode,@vPropertyType
                    continue;
                end
            set @iTableName = (select TABLE_NAME
                               from INFORMATION_SCHEMA.TABLES
                               where TABLE_TYPE = 'BASE TABLE'
                                 and TABLE_NAME like concat('i%\_', @vSchemaCode) escape '\');

            -- 更新数据
            if (@vPropertyType = 'SELECTION')
                set @sql = 'update ' + @iTableName + ' set ' + @vPropertyCode + ' = dbo.getMultiUnitIdAndType(' +
                           @vPropertyCode + ');';
            else
                set @sql = 'update ' + @iTableName + ' set ' + @vPropertyCode + ' = dbo.getMultiUnitId(' +
                           @vPropertyCode + ');';
            print @sql;
            execute (@sql);
            fetch next from properties into @vSchemaCode,@vPropertyCode,@vPropertyType
        end
    close properties;
    deallocate properties;
end
go

CREATE proc modifyDropdownAndAddress
as
begin
    declare @vSchemaCode varchar(200);
    declare @vPropertyCode varchar(200);
    declare @vPropertyType varchar(200);
    declare @iCount int;
    declare @iTableName varchar(200);
    declare @sql varchar(4000);
    declare properties cursor for
        select schemaCode, code, propertyType
        from h_biz_property
        where propertyType in ('DROPDOWN_BOX', 'ADDRESS')
          and published = 1;
    open properties;
    fetch next from properties into @vSchemaCode,@vPropertyCode,@vPropertyType
    while @@fetch_status = 0
        begin
            set @iCount = (select count(*)
                           from INFORMATION_SCHEMA.TABLES
                           where TABLE_TYPE = 'BASE TABLE'
                             and TABLE_NAME like concat('i%\_', @vSchemaCode) escape '\');
            if @iCount = 0
                begin
                    fetch next from properties into @vSchemaCode,@vPropertyCode,@vPropertyType
                    continue;
                end
            set @iTableName = (select TABLE_NAME
                               from INFORMATION_SCHEMA.TABLES
                               where TABLE_TYPE = 'BASE TABLE'
                                 and TABLE_NAME like concat('i%\_', @vSchemaCode) escape '\');

            if (@vPropertyType = 'DROPDOWN_BOX')
                set @sql = 'alter table ' + @iTableName + ' alter column ' + @vPropertyCode + ' nvarchar(200); ';
            else
                set @sql = 'alter table ' + @iTableName + ' alter column ' + @vPropertyCode + ' nvarchar(500); ';
            print @sql;
            execute (@sql);

            fetch next from properties into @vSchemaCode,@vPropertyCode,@vPropertyType
        end
    close properties;
    deallocate properties;
end
go