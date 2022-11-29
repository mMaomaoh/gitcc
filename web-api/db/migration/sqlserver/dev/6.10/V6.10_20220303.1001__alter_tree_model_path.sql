-- 树形-批量向模型表中添加treePath_、treeLevel_字段
DROP PROCEDURE IF EXISTS addTreePathParam;
go
-- 1.创建存储过程
CREATE PROCEDURE addTreePathParam as
		DECLARE @vSchemaCode varchar(50)
		DECLARE @vTableName varchar(100)
		DECLARE @vAlterSQL varchar(500)
		DECLARE @nCount int
		DECLARE @nCount2 int

		DECLARE taskCursor CURSOR FOR select code from h_biz_schema where modelType = 'TREE' and published=1;
		open taskCursor
		fetch next from taskCursor into @vSchemaCode
		while(@@fetch_status = 0)
			BEGIN
					 select @vTableName = ('i' + appNameSpace + '_' + @vSchemaCode)  from h_app_package where code = (select appCode from h_app_function where code = @vSchemaCode);
					 if @vTableName is not null
							 BEGIN
										select @nCount = count(0)  from h_biz_property where schemaCode = @vSchemaCode and code = 'treePath_';
										if @nCount = 0
												BEGIN
														set @vAlterSQL = 'alter table ' + @vTableName +' add treePath_ varchar(200) default null'
														print '    execute start---> ' + @vAlterSQL
														execute (@vAlterSQL)
														print '    execute end  <--- '
														INSERT INTO h_biz_property (id, createdTime, deleted, code,defaultProperty, name, propertyEmpty,  propertyIndex, propertyLength, propertyType, published, schemaCode)
														VALUES (replace(newId(), '-', ''), getdate(), 0, 'treePath_', 0, '路径', 0, 0, 512, 'SHORT_TEXT', 1, @vSchemaCode);
												END
										select @nCount2 = count(0)  from h_biz_property where schemaCode = @vSchemaCode and code = 'treeLevel_';
										if @nCount2 = 0
												BEGIN
														set @vAlterSQL = 'alter table ' + @vTableName +' add treeLevel_ decimal(20,8) default 1'
														print '    execute start---> ' + @vAlterSQL
														execute (@vAlterSQL)
														print '    execute end  <--- '
														INSERT INTO h_biz_property (id, createdTime, deleted, code,defaultProperty, name, propertyEmpty,  propertyIndex, propertyLength, propertyType, published, schemaCode)
														VALUES (replace(newId(), '-', ''), getdate(), 0, 'treeLevel_', 0, '层级', 0, 0, 12, 'NUMERICAL', 1, @vSchemaCode);

												END
							 END
			fetch next from taskCursor into @vSchemaCode
			END

	 close taskCursor
	 deallocate taskCursor
go

-- 3.执行
EXEC addTreePathParam
go
-- 4.删除
DROP PROCEDURE IF EXISTS addTreePathParam
go