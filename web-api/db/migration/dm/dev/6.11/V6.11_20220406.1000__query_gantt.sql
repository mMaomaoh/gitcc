CREATE TABLE H_BIZ_QUERY_GANTT
   (
   ID VARCHAR2(120) NOT NULL ,
	CREATER VARCHAR2(120),
	CREATEDTIME timestamp,
	DELETED NUMBER(1,0),
	MODIFIER VARCHAR2(120),
	MODIFIEDTIME timestamp,
	REMARKS VARCHAR2(200),
	QUERYID VARCHAR2(120),
	SCHEMACODE VARCHAR2(40),
	STARTTIMEPROPERTYCODE VARCHAR2(40),
	ENDTIMEPROPERTYCODE VARCHAR2(40),
	CONFIGJSON CLOB,
	PROGRESSPROPERTYCODE VARCHAR2(40),
	PREDEPENDENCYPROPERTYCODE VARCHAR2(40),
	ENDDEPENDENCYPROPERTYCODE VARCHAR2(40),
	LEVELPROPERTYCODE VARCHAR2(40),
	MILEPOSTCODE VARCHAR2(40),
	DEFAULTPRECISION VARCHAR2(40),
	SORTKEY VARCHAR2(40),
	TITLEPROPERTYCODE VARCHAR2(40),
	LIABLEMANCODE VARCHAR2(40),
	STATUSCODE VARCHAR2(40),
	 PRIMARY KEY (ID)
   ) ;
comment on column H_BIZ_QUERY_GANTT.STARTTIMEPROPERTYCODE is '开始时间对应数据项code';
comment on column H_BIZ_QUERY_GANTT.ENDTIMEPROPERTYCODE is '结束时间对应数据项code';
comment on column H_BIZ_QUERY_GANTT.CONFIGJSON is '展示配置JSON数据';
comment on column H_BIZ_QUERY_GANTT.PROGRESSPROPERTYCODE is '进度对应数据项code';
comment on column H_BIZ_QUERY_GANTT.PREDEPENDENCYPROPERTYCODE is '前置依赖对应数据项code';
comment on column H_BIZ_QUERY_GANTT.ENDDEPENDENCYPROPERTYCODE is '后置依赖对应数据项code';
comment on column H_BIZ_QUERY_GANTT.LEVELPROPERTYCODE is '层级关系对应数据项code';
comment on column H_BIZ_QUERY_GANTT.MILEPOSTCODE is '里程碑任务对应数据项code';
comment on column H_BIZ_QUERY_GANTT.DEFAULTPRECISION is '默认时间精度';
comment on column H_BIZ_QUERY_GANTT.SORTKEY is '排序字段';
comment on column H_BIZ_QUERY_GANTT.TITLEPROPERTYCODE is '标题对应数据项code';
comment on column H_BIZ_QUERY_GANTT.LIABLEMANCODE is '责任人对应数据项code';
comment on column H_BIZ_QUERY_GANTT.STATUSCODE is '状态对应数据项code';

CREATE INDEX Idx_queryid ON H_BIZ_QUERY_GANTT (QUERYID) ;

CREATE INDEX Idx_schemaCode ON H_BIZ_QUERY_GANTT (SCHEMACODE) ;
