ALTER TABLE h_im_work_record MODIFY title varchar2(200) default null;
ALTER TABLE h_im_work_record_history MODIFY title varchar2(200) default '';

ALTER TABLE h_im_message MODIFY title varchar2(200) default '';
ALTER TABLE h_im_message_history MODIFY title varchar2(200) default '';
alter table H_BIZ_DATA_TRACK_DETAIL add (TITLE varchar2(200) null);
comment on column H_BIZ_DATA_TRACK_DETAIL.TITLE is '留痕数据标题';
alter table H_BIZ_QUERY_CONDITION add (INCLUDESUBDATA NUMBER(1,0) null);
comment on column H_BIZ_QUERY_CONDITION.INCLUDESUBDATA is '是否包含字数据';
create table H_USER_DRAFT
(
  ID                 VARCHAR2(120) not null,
  CREATER            VARCHAR2(120),
  CREATEDTIME        DATE,
  DELETED            NUMBER(1),
  MODIFIER           VARCHAR2(120),
  MODIFIEDTIME       DATE,
  REMARKS            VARCHAR2(200),
  USERID             VARCHAR2(100),
  NAME               VARCHAR2(200),
  BIZOBJECTKEY       VARCHAR2(100),
  FORMTYPE           VARCHAR2(100),
  WORKFLOWINSTANCEID VARCHAR2(100),
  SCHEMACODE         VARCHAR2(100),
  SHEETCODE          VARCHAR2(100)
);
comment on column H_USER_DRAFT.USERID is '用户ID';
comment on column H_USER_DRAFT.NAME is '标题【流程名称或者表单标题】';
comment on column H_USER_DRAFT.BIZOBJECTKEY is '草稿数据对应的业务对象ID';
comment on column H_USER_DRAFT.FORMTYPE is '表单类型：MODEL、WORKFLOW、WORKITEM';
comment on column H_USER_DRAFT.WORKFLOWINSTANCEID is '流程实例ID';
comment on column H_USER_DRAFT.SCHEMACODE is '模型编码';
comment on column H_USER_DRAFT.SHEETCODE is '表单编码';

create index IDX_USER_DRAFT_OBJECTKEY on H_USER_DRAFT (BIZOBJECTKEY);
create index IDX_USER_DRAFT_USERID on H_USER_DRAFT (USERID);
alter table BIZ_WORKFLOW_INSTANCE add workflowName varchar2(255);

comment on column BIZ_WORKFLOW_INSTANCE.workflowName is '流程模板名称';

alter table BIZ_WORKFLOW_INSTANCE_BAK add workflowName varchar2(255);

comment on column BIZ_WORKFLOW_INSTANCE_BAK.workflowName is '流程模板名称';
alter table H_BIZ_QUERY_COLUMN add (SYNCDEFAULTFORMAT NUMBER(1,0) null);
comment on column H_BIZ_QUERY_COLUMN.SYNCDEFAULTFORMAT is '是否同步默认格式';
CREATE TABLE  H_IM_MESSAGE_STATION
   (
   ID  VARCHAR2(36) NOT NULL ,
	 BIZPARAMS  CLOB,
	 CONTENT  CLOB,
	 CREATEDTIME  DATE,
	 MESSAGETYPE  VARCHAR2(40),
	 MODIFIEDTIME  DATE,
	 TITLE  VARCHAR2(100),
	 SENDER  VARCHAR2(42),
	 PRIMARY KEY ( ID )
   );
comment on column H_IM_MESSAGE_STATION.BIZPARAMS is '业务参数表';
comment on column H_IM_MESSAGE_STATION.CONTENT is '内容';
comment on column H_IM_MESSAGE_STATION.CREATEDTIME is '创建时间';
comment on column H_IM_MESSAGE_STATION.MODIFIEDTIME is '修改时间';
comment on column H_IM_MESSAGE_STATION.MESSAGETYPE is '消息类型';
comment on column H_IM_MESSAGE_STATION.TITLE is '标题';
comment on column H_IM_MESSAGE_STATION.SENDER is '消息关联的发起人';

CREATE TABLE H_IM_MESSAGE_STATION_USER
   (
   ID VARCHAR2(36) NOT NULL ,
	MODIFIEDTIME DATE,
	RECEIVER VARCHAR2(42),
	MESSAGEID VARCHAR2(36),
	READSTATE VARCHAR2(255),
	PRIMARY KEY (ID)
   ) ;
comment on column H_IM_MESSAGE_STATION_USER.receiver is '接收者';
comment on column H_IM_MESSAGE_STATION_USER.MODIFIEDTIME is '修改时间';
comment on column H_IM_MESSAGE_STATION_USER.messageId is '消息id';
comment on column H_IM_MESSAGE_STATION_USER.readState is 'READED-已读、UNREADED-未读';

create index idx_readState on H_IM_MESSAGE_STATION_USER (READSTATE);
create index idx_receiver on H_IM_MESSAGE_STATION_USER (RECEIVER);


-- 树形-批量向模型表中添加treePath_、treeLevel_字段
-- 1.创建
create  or replace procedure addTreePathParam as
begin
    declare
        cursor csr is select code from h_biz_schema where modelType = 'TREE' and published=1;
        vSchemaCode VARCHAR(200);
        vTableName VARCHAR(200);
		nCount3 number;
        nCount number;
        nCount2 number;
		idCount number;
        v_sql varchar2(1000);
        vUser varchar2(128) ;
        treePath_ varchar2(20) := 'treePath_';
        treeLevel_ varchar2(20) := 'treeLevel_';
    begin
        select username INTO vUser from user_users;
        for row_schema_code in csr loop
                vSchemaCode := row_schema_code.code;
                select UPPER(('i' || appNameSpace || '_' || vSchemaCode)) into vTableName from h_app_package where code = (select appCode from h_app_function where code = vSchemaCode);
				select count(0) into nCount3 from user_tables where table_name = vTableName;
				if nCount3 = 1 then
					select COUNT(0) into idCount FROM USER_TAB_COLUMNS WHERE TABLE_NAME = vTableName  and COLUMN_NAME = 'ID';
					select count(0) into nCount from h_biz_property where schemaCode = vSchemaCode and code = 'treePath_';
					-- 字段大小写判断
					if idCount > 0 then
						treePath_ := 'TREEPATH_';
						treeLevel_ := 'TREELEVEL_';
				    else
				        treePath_ := 'treePath_';
                        treeLevel_ := 'treeLevel_';
					end if;
					if nCount = 0 then
						v_sql := 'ALTER TABLE "'||vUser||'"."'||vTableName||'" ADD ("'||treePath_||'" VARCHAR2(512 BYTE) DEFAULT null)';
						execute immediate v_sql;
                        v_sql :='COMMENT ON COLUMN "'||vUser||'"."'||vTableName||'"."'||treePath_||'" is ''路径''';
                        execute immediate v_sql;
						v_sql := 'INSERT INTO h_biz_property (id, createdTime, creater, deleted, code, defaultProperty, name, propertyEmpty, propertyIndex, propertyLength, propertyType, published,schemaCode) VALUES (LOWER(sys_guid()), sysdate, NULL, 0,'||'''treePath_'', 0, ''路径'', 0, 0, 12, ''SHORT_TEXT'', 1,'''||vSchemaCode||''')';
						execute immediate v_sql;
					end if;
					select count(0) into nCount2 from h_biz_property where schemaCode = vSchemaCode and code = 'treeLevel_';
					if nCount2 = 0 then
						v_sql := 'ALTER TABLE "'||vUser||'"."'||vTableName||'" ADD ("'||treeLevel_||'" NUMBER(25,8) DEFAULT 1)';
						execute immediate v_sql;
                        v_sql :='COMMENT ON COLUMN "'||vUser||'"."'||vTableName||'"."'||treeLevel_||'" is ''层级''';
                        execute immediate v_sql;
						v_sql := 'INSERT INTO h_biz_property (id, createdTime, creater, deleted, code, defaultProperty, defaultValue, name, propertyEmpty, propertyIndex, propertyLength, propertyType, published, schemaCode) VALUES (LOWER(sys_guid()), sysdate, NULL, 0,'||'''treeLevel_'', 0, 1, ''层级'', 0,  0, 12, ''NUMERICAL'', 1, '''||vSchemaCode||''')';
						execute immediate v_sql;
					end if;
				end if;
            end loop;
    end;
end addTreePathParam;
/

-- 2.执行!!!!!!输入库所属用户名 （获取当前用户 select username from user_users）
call addTreePathParam();

-- 3.删除
drop procedure  addTreePathParam;


alter table h_org_user add userWorkStatus varchar(32) null;
update h_org_user set userWorkStatus  = 'NORMAL' where deleted = 0;
update h_org_user set userWorkStatus  = 'DIMISSION' where deleted = 1;

create table h_org_user_transfer_record
(
    id              varchar(120)  not null primary key,
    processUserId   varchar(120)  null,
    processTime     date      null,
    sourceUserId    varchar(120)  null,
    receiveUserId   varchar(120)  null,
    transferType    varchar(32)   null,
    transferSize    int           null,
    comments         varchar(2048) null
);


create table h_org_user_transfer_detail
(
    id           varchar(120) not null primary key,
    recordId     varchar(120) not null,
    transferData clob         null
);
create index idx_record_id on h_org_user_transfer_detail (recordId);

update h_system_sms_template set params = '[{"key":"name","value":""}]' where id = '2c928ff67de11137017de119dec601c2';
update h_system_sms_template set params = '[{"key":"name","value":"流程的标题"},{"key":"creater","value":"流程发起人"}]' where id = '2c928ff67de11137017de11d5b3001c4';

ALTER TABLE h_biz_sheet ADD (existDraft number(1,0));
comment on column h_biz_sheet.existDraft is '是否存在未发布的草稿内容';

update  h_biz_schema set deleted = 1 where code in (select code from h_app_function where deleted = 1 and type = 'BizModel');

create unique index uq_department_corpId_sourceId on h_org_department (corpId, sourceId);
create unique index uq_user_corpId_sourceId on h_org_role (corpId, sourceId);
drop index idx_h_org_role_code;
create unique index uq_role_code on h_org_role (code);
create index idx_corpId_userId on h_org_user (userId,corpId);

ALTER TABLE H_USER_FAVORITES MODIFY  BIZOBJECTKEY VARCHAR2(200);

ALTER TABLE H_ORG_USER MODIFY IMGURLID VARCHAR2(200);
ALTER TABLE H_APP_PACKAGE MODIFY LOGOURLID VARCHAR2(200);

ALTER TABLE H_BIZ_ATTACHMENT MODIFY (BIZOBJECTID VARCHAR2(200) );