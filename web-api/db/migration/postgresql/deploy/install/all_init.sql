-- base_security_client definition

-- Drop table

-- DROP TABLE base_security_client;

CREATE TABLE base_security_client (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	extend1 varchar(255) NULL,
	extend2 varchar(255) NULL,
	extend3 varchar(255) NULL,
	extend4 int4 NULL,
	extend5 int4 NULL,
	accesstokenvalidityseconds int4 NOT NULL,
	additioninformation varchar(255) NULL,
	authorities varchar(255) NULL,
	authorizedgranttypes varchar(255) NULL,
	autoapprovescopes varchar(255) NULL,
	clientid varchar(100) NULL,
	clientsecret varchar(100) NULL,
	refreshtokenvalidityseconds int4 NOT NULL,
	registeredredirecturis varchar(2000) NULL,
	resourceids varchar(255) NULL,
	scopes varchar(255) NULL,
	"type" varchar(10) NULL,
	CONSTRAINT base_security_client_pkey PRIMARY KEY (id)
);


-- biz_circulateitem definition

-- Drop table

-- DROP TABLE biz_circulateitem;

CREATE TABLE biz_circulateitem (
	id varchar(36) NOT NULL,
	finishtime timestamp NULL,
	receivetime timestamp NULL,
	starttime timestamp NULL,
	activitycode varchar(200) NULL,
	activityname varchar(200) NULL,
	allowedtime timestamp NULL,
	appcode varchar(200) NULL,
	"datatype" varchar(20) NULL,
	departmentid varchar(200) NULL,
	departmentname varchar(200) NULL,
	sheetcode varchar(200) NULL,
	instanceid varchar(36) NULL,
	instancename varchar(200) NULL,
	originator varchar(200) NULL,
	originatorname varchar(200) NULL,
	participant varchar(200) NULL,
	participantname varchar(200) NULL,
	sequenceno varchar(200) NULL,
	sortkey int8 NULL,
	sourceid varchar(200) NULL,
	sourcename varchar(200) NULL,
	state varchar(20) NULL,
	timeoutstrategy varchar(20) NULL,
	timeoutwarn1 timestamp NULL,
	timeoutwarn2 timestamp NULL,
	usedtime int8 NULL,
	workitemtype varchar(20) NULL,
	workflowcode varchar(36) NULL,
	workflowtokenid varchar(200) NULL,
	workflowversion int4 NULL,
	CONSTRAINT biz_circulateitem_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_c_multi ON biz_circulateitem USING btree (instanceid, activitycode, workflowtokenid, participant);
CREATE INDEX idx_c_participant ON biz_circulateitem USING btree (participant);
CREATE INDEX idx_c_sourceidandtype ON biz_circulateitem USING btree (sourceid, workitemtype);
CREATE INDEX idx_c_starttime ON biz_circulateitem USING btree (starttime);
CREATE INDEX idx_c_workflowtokenid ON biz_circulateitem USING btree (workflowtokenid);


-- biz_circulateitem_finished definition

-- Drop table

-- DROP TABLE biz_circulateitem_finished;

CREATE TABLE biz_circulateitem_finished (
	id varchar(36) NOT NULL,
	finishtime timestamp NULL,
	receivetime timestamp NULL,
	starttime timestamp NULL,
	activitycode varchar(200) NULL,
	activityname varchar(200) NULL,
	allowedtime timestamp NULL,
	appcode varchar(200) NULL,
	"datatype" varchar(20) NULL,
	departmentid varchar(200) NULL,
	departmentname varchar(200) NULL,
	sheetcode varchar(200) NULL,
	instanceid varchar(36) NULL,
	instancename varchar(200) NULL,
	originator varchar(200) NULL,
	originatorname varchar(200) NULL,
	participant varchar(200) NULL,
	participantname varchar(200) NULL,
	sequenceno varchar(200) NULL,
	sortkey int8 NULL,
	sourceid varchar(200) NULL,
	sourcename varchar(200) NULL,
	state varchar(20) NULL,
	timeoutstrategy varchar(20) NULL,
	timeoutwarn1 timestamp NULL,
	timeoutwarn2 timestamp NULL,
	usedtime int8 NULL,
	workitemtype varchar(20) NULL,
	workflowcode varchar(36) NULL,
	workflowtokenid varchar(200) NULL,
	workflowversion int4 NULL,
	CONSTRAINT biz_circulateitem_finished_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_cf_finishtime ON biz_circulateitem_finished USING btree (finishtime);
CREATE INDEX idx_cf_multi ON biz_circulateitem_finished USING btree (instanceid, activitycode, workflowtokenid, participant);
CREATE INDEX idx_cf_participant ON biz_circulateitem_finished USING btree (participant);
CREATE INDEX idx_cf_sourceidandtype ON biz_circulateitem_finished USING btree (sourceid, workitemtype);
CREATE INDEX idx_cf_workflowtokenid ON biz_circulateitem_finished USING btree (workflowtokenid);


-- biz_workflow_instance definition

-- Drop table

-- DROP TABLE biz_workflow_instance;

CREATE TABLE biz_workflow_instance (
	id varchar(36) NOT NULL,
	finishtime timestamp NULL,
	receivetime timestamp NULL,
	starttime timestamp NULL,
	appcode varchar(200) NULL,
	bizobjectid varchar(36) NULL,
	"datatype" varchar(20) NULL,
	departmentid varchar(200) NULL,
	departmentname varchar(200) NULL,
	instancename varchar(200) NULL,
	originator varchar(200) NULL,
	originatorname varchar(200) NULL,
	parentid varchar(36) NULL,
	remark varchar(200) NULL,
	runmode varchar(20) NULL,
	schemacode varchar(40) NULL,
	sequenceno varchar(200) NULL,
	sheetbizobjectid varchar(36) NULL,
	sheetschemacode varchar(64) NULL,
	"source" varchar(255) NULL,
	state varchar(20) NULL,
	trusttype varchar(20) NULL,
	trustee varchar(42) NULL,
	trusteename varchar(80) NULL,
	usedtime int8 NULL,
	waittime int8 NULL,
	workflowcode varchar(200) NULL,
	workflowname varchar(255) NULL,
	workflowtokenid varchar(36) NULL,
	workflowversion int4 NULL,
	CONSTRAINT biz_workflow_instance_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_bwi_finishtime ON biz_workflow_instance USING btree (finishtime);
CREATE INDEX idx_bwi_originator ON biz_workflow_instance USING btree (originator);
CREATE INDEX idx_bwi_originator_state_starttime ON biz_workflow_instance USING btree (originator, state, starttime);
CREATE INDEX idx_bwi_parentid ON biz_workflow_instance USING btree (parentid);
CREATE INDEX idx_bwi_starttime ON biz_workflow_instance USING btree (starttime);
CREATE INDEX idx_bwi_starttime_state_datatype ON biz_workflow_instance USING btree (starttime, state, datatype);
CREATE INDEX idx_bwi_state ON biz_workflow_instance USING btree (state);
CREATE INDEX idx_bwi_trustee ON biz_workflow_instance USING btree (trustee);
CREATE INDEX idx_bwi_workflowcode ON biz_workflow_instance USING btree (workflowcode);


-- biz_workflow_instance_bak definition

-- Drop table

-- DROP TABLE biz_workflow_instance_bak;

CREATE TABLE biz_workflow_instance_bak (
	id varchar(36) NOT NULL,
	finishtime timestamp NULL,
	receivetime timestamp NULL,
	starttime timestamp NULL,
	appcode varchar(200) NULL,
	bizobjectid varchar(36) NULL,
	"datatype" varchar(20) NULL,
	departmentid varchar(200) NULL,
	departmentname varchar(200) NULL,
	instancename varchar(200) NULL,
	originator varchar(200) NULL,
	originatorname varchar(200) NULL,
	parentid varchar(36) NULL,
	remark varchar(200) NULL,
	runmode varchar(20) NULL,
	schemacode varchar(40) NULL,
	sequenceno varchar(200) NULL,
	sheetbizobjectid varchar(36) NULL,
	sheetschemacode varchar(64) NULL,
	"source" varchar(255) NULL,
	state varchar(20) NULL,
	trusttype varchar(20) NULL,
	trustee varchar(42) NULL,
	trusteename varchar(80) NULL,
	usedtime int8 NULL,
	waittime int8 NULL,
	workflowcode varchar(200) NULL,
	workflowname varchar(255) NULL,
	workflowtokenid varchar(36) NULL,
	workflowversion int4 NULL,
	backuptime timestamp NULL,
	CONSTRAINT biz_workflow_instance_bak_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_bwib_originator ON biz_workflow_instance_bak USING btree (originator);
CREATE INDEX idx_bwib_originator_state_starttime ON biz_workflow_instance_bak USING btree (originator, state, starttime);
CREATE INDEX idx_bwib_starttime ON biz_workflow_instance_bak USING btree (starttime);
CREATE INDEX idx_bwib_state ON biz_workflow_instance_bak USING btree (state);
CREATE INDEX idx_bwib_workflowcode ON biz_workflow_instance_bak USING btree (workflowcode);


-- biz_workflow_token definition

-- Drop table

-- DROP TABLE biz_workflow_token;

CREATE TABLE biz_workflow_token (
	id varchar(36) NOT NULL,
	finishtime timestamp NULL,
	receivetime timestamp NULL,
	starttime timestamp NULL,
	activitycode varchar(200) NULL,
	activitytype varchar(20) NULL,
	approvalcount int4 NULL,
	approvalexit varchar(20) NULL,
	disapprovalcount int4 NULL,
	exceptional varchar(20) NULL,
	instanceid varchar(36) NULL,
	instancestate varchar(20) NULL,
	isrejectback varchar(10) NULL,
	isretrievable int4 NULL,
	isskipped bool NULL,
	itemcount int4 NULL,
	sourceactivitycode varchar(200) NULL,
	state varchar(20) NULL,
	tokenid int4 NULL,
	usedtime int8 NULL,
	CONSTRAINT biz_workflow_token_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_bwt_instanceid ON biz_workflow_token USING btree (instanceid);


-- biz_workitem definition

-- Drop table

-- DROP TABLE biz_workitem;

CREATE TABLE biz_workitem (
	id varchar(36) NOT NULL,
	finishtime timestamp NULL,
	receivetime timestamp NULL,
	starttime timestamp NULL,
	activitycode varchar(200) NULL,
	activityname varchar(200) NULL,
	allowedtime timestamp NULL,
	appcode varchar(200) NULL,
	"datatype" varchar(20) NULL,
	departmentid varchar(200) NULL,
	departmentname varchar(200) NULL,
	sheetcode varchar(200) NULL,
	instanceid varchar(36) NULL,
	instancename varchar(200) NULL,
	originator varchar(200) NULL,
	originatorname varchar(200) NULL,
	participant varchar(200) NULL,
	participantname varchar(200) NULL,
	sequenceno varchar(200) NULL,
	sortkey int8 NULL,
	sourceid varchar(200) NULL,
	sourcename varchar(200) NULL,
	state varchar(20) NULL,
	timeoutstrategy varchar(20) NULL,
	timeoutwarn1 timestamp NULL,
	timeoutwarn2 timestamp NULL,
	usedtime int8 NULL,
	workitemtype varchar(20) NULL,
	workflowcode varchar(36) NULL,
	workflowtokenid varchar(200) NULL,
	workflowversion int4 NULL,
	approval varchar(20) NULL,
	batchoperate bool NULL,
	istrust bool NULL,
	roottaskid varchar(42) NULL,
	sourcetaskid varchar(42) NULL,
	trustor varchar(42) NULL,
	trustorname varchar(80) NULL,
	workitemsource varchar(120) NULL,
	CONSTRAINT biz_workitem_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_wi_multi ON biz_workitem USING btree (instanceid, activitycode, workflowtokenid, participant);
CREATE INDEX idx_wi_participant ON biz_workitem USING btree (participant);
CREATE INDEX idx_wi_receivetime ON biz_workitem USING btree (receivetime);
CREATE INDEX idx_wi_sourceidandtype ON biz_workitem USING btree (sourceid, workitemtype);
CREATE INDEX idx_wi_starttime ON biz_workitem USING btree (starttime);
CREATE INDEX idx_wi_workflowcode ON biz_workitem USING btree (workflowcode);
CREATE INDEX idx_wi_workflowtokenid ON biz_workitem USING btree (workflowtokenid);


-- biz_workitem_finished definition

-- Drop table

-- DROP TABLE biz_workitem_finished;

CREATE TABLE biz_workitem_finished (
	id varchar(36) NOT NULL,
	finishtime timestamp NULL,
	receivetime timestamp NULL,
	starttime timestamp NULL,
	activitycode varchar(200) NULL,
	activityname varchar(200) NULL,
	allowedtime timestamp NULL,
	appcode varchar(200) NULL,
	"datatype" varchar(20) NULL,
	departmentid varchar(200) NULL,
	departmentname varchar(200) NULL,
	sheetcode varchar(200) NULL,
	instanceid varchar(36) NULL,
	instancename varchar(200) NULL,
	originator varchar(200) NULL,
	originatorname varchar(200) NULL,
	participant varchar(200) NULL,
	participantname varchar(200) NULL,
	sequenceno varchar(200) NULL,
	sortkey int8 NULL,
	sourceid varchar(200) NULL,
	sourcename varchar(200) NULL,
	state varchar(20) NULL,
	timeoutstrategy varchar(20) NULL,
	timeoutwarn1 timestamp NULL,
	timeoutwarn2 timestamp NULL,
	usedtime int8 NULL,
	workitemtype varchar(20) NULL,
	workflowcode varchar(200) NULL,
	workflowtokenid varchar(200) NULL,
	workflowversion int4 NULL,
	approval varchar(200) NULL,
	batchoperate bool NULL,
	istrust bool NULL,
	roottaskid varchar(42) NULL,
	sourcetaskid varchar(42) NULL,
	trustor varchar(42) NULL,
	trustorname varchar(80) NULL,
	workitemsource varchar(120) NULL,
	CONSTRAINT biz_workitem_finished_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_bwf_finishtime ON biz_workitem_finished USING btree (finishtime);
CREATE INDEX idx_bwf_finishtime_state_datetype ON biz_workitem_finished USING btree (finishtime, state, datatype);
CREATE INDEX idx_bwf_multi ON biz_workitem_finished USING btree (instanceid, activitycode, workflowtokenid, participant);
CREATE INDEX idx_bwf_participant ON biz_workitem_finished USING btree (participant);
CREATE INDEX idx_bwf_sourceidandtype ON biz_workitem_finished USING btree (sourceid, workitemtype);
CREATE INDEX idx_bwf_trustor ON biz_workitem_finished USING btree (trustor);
CREATE INDEX idx_bwf_workflowcode ON biz_workitem_finished USING btree (workflowcode);
CREATE INDEX idx_bwf_workflowtokenid ON biz_workitem_finished USING btree (workflowtokenid);
CREATE INDEX idx_wif_receivetime ON biz_workitem_finished USING btree (receivetime);


-- d_process_instance definition

-- Drop table

-- DROP TABLE d_process_instance;

CREATE TABLE d_process_instance (
	id varchar(36) NOT NULL,
	bizprocessstatus varchar(64) NULL,
	createtime timestamp NULL,
	formcomponents text NULL,
	originator varchar(64) NULL,
	processcode varchar(120) NULL,
	processinstanceid varchar(64) NULL,
	requestid varchar(42) NULL,
	"result" varchar(64) NULL,
	status varchar(64) NULL,
	title varchar(64) NULL,
	url varchar(255) NULL,
	wfinstanceid varchar(64) NULL,
	wfworkitemid varchar(64) NULL,
	CONSTRAINT d_process_instance_pkey PRIMARY KEY (id)
);


-- d_process_task definition

-- Drop table

-- DROP TABLE d_process_task;

CREATE TABLE d_process_task (
	id varchar(36) NOT NULL,
	bizprocessstatus varchar(64) NULL,
	createtime timestamp NULL,
	processinstanceid varchar(64) NULL,
	requestid varchar(42) NULL,
	"result" varchar(64) NULL,
	status varchar(64) NULL,
	taskid varchar(50) NULL,
	url varchar(255) NULL,
	userid varchar(64) NULL,
	wfinstanceid varchar(64) NULL,
	wfworkitemid varchar(64) NULL,
	CONSTRAINT d_process_task_pkey PRIMARY KEY (id)
);


-- d_process_template definition

-- Drop table

-- DROP TABLE d_process_template;

CREATE TABLE d_process_template (
	id varchar(36) NOT NULL,
	agentid int8 NULL,
	bizprocessstatus varchar(64) NULL,
	createtime timestamp NULL,
	formfield text NULL,
	processcode varchar(120) NULL,
	processname varchar(64) NULL,
	queryid varchar(42) NULL,
	requestid varchar(42) NULL,
	tempcode varchar(64) NULL,
	CONSTRAINT d_process_template_pkey PRIMARY KEY (id)
);
CREATE UNIQUE INDEX idx_unique_temp_code ON d_process_template USING btree (tempcode);


-- h_app_function definition

-- Drop table

-- DROP TABLE h_app_function;

CREATE TABLE h_app_function (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	appcode varchar(40) NULL,
	code varchar(40) NULL,
	icon varchar(50) NULL,
	mobileable bool NULL,
	"name" varchar(50) NULL,
	name_i18n varchar(1000) NULL,
	parentid varchar(36) NULL,
	pcable bool NULL,
	sortkey int4 NULL,
	"type" varchar(40) NULL,
	CONSTRAINT h_app_function_pkey PRIMARY KEY (id),
	CONSTRAINT uk_hs5vdc0sdojwxfkv685ch9bqb UNIQUE (code)
);
CREATE INDEX idx_af_parentid ON h_app_function USING btree (parentid);
CREATE INDEX idx_af_type_ac ON h_app_function USING btree (appcode, type);


-- h_app_group definition

-- Drop table

-- DROP TABLE h_app_group;

CREATE TABLE h_app_group (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	code varchar(40) NULL,
	"name" varchar(50) NULL,
	name_i18n varchar(1000) NULL,
	sortkey int4 NULL,
	CONSTRAINT h_app_group_pkey PRIMARY KEY (id)
);
CREATE UNIQUE INDEX uq_ag_code ON h_app_group USING btree (code);


-- h_app_package definition

-- Drop table

-- DROP TABLE h_app_package;

CREATE TABLE h_app_package (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	agentid varchar(40) NULL,
	appkey varchar(200) NULL,
	appnamespace varchar(40) NULL,
	appsecret varchar(200) NULL,
	builtinapp bool NULL,
	code varchar(40) NULL,
	enabled bool NULL,
	fromappmarket bool NULL,
	groupid varchar(120) NULL,
	logourl varchar(200) NULL,
	logourlid varchar(200) NULL,
	"name" varchar(50) NULL,
	name_i18n varchar(1000) NULL,
	sortkey int4 NULL,
	CONSTRAINT h_app_package_pkey PRIMARY KEY (id)
);
CREATE UNIQUE INDEX uq_ap_code ON h_app_package USING btree (code);


-- h_biz_attachment definition

-- Drop table

-- DROP TABLE h_biz_attachment;

CREATE TABLE h_biz_attachment (
	id varchar(120) NOT NULL,
	base64imagestr text NULL,
	bizobjectid varchar(36) NOT NULL,
	bizpropertycode varchar(40) NOT NULL,
	createdtime timestamp NULL,
	creater varchar(36) NULL,
	fileextension varchar(30) NULL,
	filesize int4 NULL,
	mimetype varchar(50) NULL,
	"name" varchar(200) NULL,
	parentbizobjectid varchar(36) NULL,
	parentschemacode varchar(36) NULL,
	refid varchar(500) NOT NULL,
	schemacode varchar(36) NOT NULL,
	CONSTRAINT h_biz_attachment_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_biz_attachment_schema_object_property ON h_biz_attachment USING btree (schemacode, bizobjectid, bizpropertycode, createdtime);
CREATE INDEX idx_h_biz_attachment_bizobjectid ON h_biz_attachment USING btree (bizobjectid);
CREATE INDEX idx_h_biz_attachment_parentbizobjectid ON h_biz_attachment USING btree (parentbizobjectid);
CREATE INDEX idx_h_biz_attachment_refid ON h_biz_attachment USING btree (refid);


-- h_biz_batch_update_record definition

-- Drop table

-- DROP TABLE h_biz_batch_update_record;

CREATE TABLE h_biz_batch_update_record (
	id varchar(120) NOT NULL,
	failcount int4 NULL,
	modifiedtime timestamp NULL,
	modifiedvalue text NULL,
	propertycode varchar(200) NULL,
	propertyname varchar(200) NULL,
	schemacode varchar(40) NULL,
	successcount int4 NULL,
	total int4 NULL,
	userid varchar(36) NULL,
	CONSTRAINT h_biz_batch_update_record_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_batch_update_record_schemacode ON h_biz_batch_update_record USING btree (userid, schemacode);


-- h_biz_button definition

-- Drop table

-- DROP TABLE h_biz_button;

CREATE TABLE h_biz_button (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	actionconfig text NULL,
	bindaction varchar(40) NULL,
	code varchar(40) NULL,
	description text NULL,
	hint varchar(200) NULL,
	"name" varchar(200) NULL,
	operatetype varchar(40) NULL,
	schemacode varchar(40) NULL,
	showpermcode varchar(40) NULL,
	showpermtype varchar(40) NULL,
	sortkey int4 NULL,
	targetcode varchar(40) NULL,
	targetobjcode varchar(40) NULL,
	triggercode varchar(40) NULL,
	triggertype varchar(40) NULL,
	uselocation varchar(40) NULL,
	CONSTRAINT h_biz_button_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_bb_schemacode ON h_biz_button USING btree (schemacode);


-- h_biz_comment definition

-- Drop table

-- DROP TABLE h_biz_comment;

CREATE TABLE h_biz_comment (
	id varchar(120) NOT NULL,
	actiontype varchar(40) NOT NULL,
	activitycode varchar(40) NULL,
	activityname varchar(40) NULL,
	bizobjectid varchar(36) NOT NULL,
	bizpropertycode varchar(40) NOT NULL,
	"content" varchar(4000) NULL,
	createdtime timestamp NULL,
	creater varchar(36) NULL,
	modifiedtime timestamp NULL,
	modifier varchar(36) NULL,
	relusers varchar(4000) NULL,
	"result" varchar(40) NOT NULL,
	schemacode varchar(40) NOT NULL,
	tokenid int4 NULL,
	workitemid varchar(36) NOT NULL,
	workflowinstanceid varchar(36) NOT NULL,
	workflowtokenid varchar(36) NOT NULL,
	CONSTRAINT h_biz_comment_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_biz_comment_workflowinstanceid ON h_biz_comment USING btree (workflowinstanceid);
CREATE INDEX idx_biz_comment_workitemid_actiontype ON h_biz_comment USING btree (workitemid, actiontype);


-- h_biz_data_rule definition

-- Drop table

-- DROP TABLE h_biz_data_rule;

CREATE TABLE h_biz_data_rule (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	checktype int4 NULL,
	dataruletype varchar(40) NULL,
	"options" text NULL,
	propertycode varchar(40) NULL,
	schemacode varchar(40) NULL,
	CONSTRAINT h_biz_data_rule_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_bdr_schemacode ON h_biz_data_rule USING btree (schemacode, propertycode);


-- h_biz_data_track definition

-- Drop table

-- DROP TABLE h_biz_data_track;

CREATE TABLE h_biz_data_track (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	bizobjectid varchar(255) NULL,
	creatorname varchar(255) NULL,
	departmentid varchar(255) NULL,
	departmentname varchar(255) NULL,
	schemacode varchar(255) NULL,
	sheetcode varchar(255) NULL,
	title varchar(255) NULL,
	CONSTRAINT h_biz_data_track_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_bdr_bizobjectid ON h_biz_data_track USING btree (bizobjectid);


-- h_biz_data_track_child definition

-- Drop table

-- DROP TABLE h_biz_data_track_child;

CREATE TABLE h_biz_data_track_child (
	id varchar(120) NOT NULL,
	aftervalue text NULL,
	beforevalue text NULL,
	detailid varchar(120) NULL,
	modifiedproperties text NULL,
	operationtype varchar(40) NULL,
	schemacode varchar(40) NULL,
	sortkey numeric(19, 2) NULL,
	CONSTRAINT h_biz_data_track_child_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_h_track_child_detail_op ON h_biz_data_track_child USING btree (detailid, operationtype);


-- h_biz_data_track_detail definition

-- Drop table

-- DROP TABLE h_biz_data_track_detail;

CREATE TABLE h_biz_data_track_detail (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	aftervalue text NULL,
	beforevalue text NULL,
	bizobjectid varchar(120) NULL,
	code varchar(40) NULL,
	creatorname varchar(255) NULL,
	departmentname varchar(255) NULL,
	"name" varchar(600) NULL,
	title varchar(600) NULL,
	trackid varchar(120) NULL,
	"type" varchar(40) NULL,
	CONSTRAINT h_biz_data_track_detail_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_bdtd_track_id ON h_biz_data_track_detail USING btree (trackid);


-- h_biz_database_pool definition

-- Drop table

-- DROP TABLE h_biz_database_pool;

CREATE TABLE h_biz_database_pool (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	code varchar(40) NULL,
	databasetype varchar(15) NULL,
	datasourcetype varchar(40) NULL,
	description varchar(2000) NULL,
	driverclassname varchar(50) NULL,
	externinfo text NULL,
	jdbcurl varchar(200) NULL,
	"name" varchar(50) NULL,
	"password" varchar(300) NULL,
	username varchar(40) NULL,
	CONSTRAINT h_biz_database_pool_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_dp_code ON h_biz_database_pool USING btree (code);


-- h_biz_datasource_category definition

-- Drop table

-- DROP TABLE h_biz_datasource_category;

CREATE TABLE h_biz_datasource_category (
	id varchar(120) NOT NULL,
	createdby varchar(120) NULL,
	createdtime timestamp NULL,
	modifiedby varchar(120) NULL,
	modifiedtime timestamp NULL,
	"name" varchar(255) NULL,
	CONSTRAINT h_biz_datasource_category_pkey PRIMARY KEY (id)
);


-- h_biz_datasource_method definition

-- Drop table

-- DROP TABLE h_biz_datasource_method;

CREATE TABLE h_biz_datasource_method (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	code varchar(40) NULL,
	databaseconnectid varchar(128) NULL,
	datasourcecategoryid varchar(128) NULL,
	inputparamconfig text NULL,
	"name" varchar(256) NULL,
	reportobjectid varchar(32) NULL,
	reporttablename varchar(32) NULL,
	shared bool NULL,
	sqlconfig varchar(512) NULL,
	userids text NULL,
	CONSTRAINT h_biz_datasource_method_pkey PRIMARY KEY (id)
);
CREATE UNIQUE INDEX uk_dm_code ON h_biz_datasource_method USING btree (code);


-- h_biz_export_task definition

-- Drop table

-- DROP TABLE h_biz_export_task;

CREATE TABLE h_biz_export_task (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	endtime timestamp NULL,
	expiretime timestamp NULL,
	exportresultstatus varchar(255) NULL,
	filesize int4 NULL,
	message varchar(4000) NULL,
	"path" varchar(255) NULL,
	refid varchar(255) NULL,
	schemacode varchar(255) NULL,
	starttime timestamp NULL,
	taskstatus varchar(255) NULL,
	userid varchar(255) NULL,
	CONSTRAINT h_biz_export_task_pkey PRIMARY KEY (id)
);


-- h_biz_method definition

-- Drop table

-- DROP TABLE h_biz_method;

CREATE TABLE h_biz_method (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	code varchar(40) NULL,
	defaultmethod bool NULL,
	description text NULL,
	methodtype varchar(40) NULL,
	"name" varchar(100) NULL,
	schemacode varchar(40) NULL,
	CONSTRAINT h_biz_method_pkey PRIMARY KEY (id)
);


-- h_biz_method_mapping definition

-- Drop table

-- DROP TABLE h_biz_method_mapping;

CREATE TABLE h_biz_method_mapping (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	businessruleid varchar(40) NULL,
	inputmappingsjson text NULL,
	methodcode varchar(40) NULL,
	nodecode varchar(40) NULL,
	outputmappingsjson text NULL,
	schemacode varchar(40) NULL,
	servicecode varchar(40) NULL,
	servicemethodcode varchar(40) NULL,
	CONSTRAINT h_biz_method_mapping_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_bdtd_schemacode ON h_biz_method_mapping USING btree (schemacode);
CREATE INDEX idx_service_methodcode ON h_biz_method_mapping USING btree (servicecode, methodcode);


-- h_biz_object_relation definition

-- Drop table

-- DROP TABLE h_biz_object_relation;

CREATE TABLE h_biz_object_relation (
	id varchar(120) NOT NULL,
	createtime timestamp NULL,
	srcid varchar(42) NULL,
	srcparentid varchar(42) NULL,
	srcparentsc varchar(42) NULL,
	srcsc varchar(42) NULL,
	targetid varchar(42) NULL,
	targetparentid varchar(42) NULL,
	targetparentsc varchar(42) NULL,
	targetsc varchar(42) NULL,
	CONSTRAINT h_biz_object_relation_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_sc_id ON h_biz_object_relation USING btree (targetsc, targetid);


-- h_biz_perm_group definition

-- Drop table

-- DROP TABLE h_biz_perm_group;

CREATE TABLE h_biz_perm_group (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	apppermgroupid varchar(120) NULL,
	authortype varchar(40) NULL,
	departments text NULL,
	enabled bool NULL,
	"name" varchar(50) NULL,
	name_i18n varchar(1000) NULL,
	roles text NULL,
	schemacode varchar(40) NULL,
	CONSTRAINT h_biz_perm_group_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_apppermgroupid ON h_biz_perm_group USING btree (apppermgroupid);
CREATE INDEX idx_bpg_schemacode ON h_biz_perm_group USING btree (schemacode);


-- h_biz_perm_property definition

-- Drop table

-- DROP TABLE h_biz_perm_property;

CREATE TABLE h_biz_perm_property (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	bizpermtype varchar(40) NULL,
	encryptvisible bool NULL,
	groupid varchar(40) NULL,
	"name" varchar(600) NULL,
	name_i18n varchar(1000) NULL,
	propertycode varchar(40) NULL,
	propertytype varchar(40) NULL,
	required bool NULL,
	schemacode varchar(40) NULL,
	visible bool NULL,
	writeable bool NULL,
	CONSTRAINT h_biz_perm_property_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_bpp_groupid ON h_biz_perm_property USING btree (groupid);


-- h_biz_property definition

-- Drop table

-- DROP TABLE h_biz_property;

CREATE TABLE h_biz_property (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	code varchar(40) NULL,
	defaultproperty bool NULL,
	defaultvalue varchar(4000) NULL,
	encryptoption varchar(40) NULL,
	"name" varchar(600) NULL,
	name_i18n varchar(1000) NULL,
	"options" text NULL,
	propertyempty bool NULL,
	propertyindex bool NULL,
	propertylength int4 NULL,
	propertytype varchar(40) NULL,
	published bool NULL,
	relativecode varchar(40) NULL,
	relativepropertycode varchar(40) NULL,
	relativequotecode text NULL,
	repeated bool NULL,
	schemacode varchar(40) NULL,
	selectionjson text NULL,
	sortkey int4 NULL,
	CONSTRAINT h_biz_property_pkey PRIMARY KEY (id)
);
CREATE UNIQUE INDEX uq_schemacode_code ON h_biz_property USING btree (schemacode, code);


-- h_biz_query definition

-- Drop table

-- DROP TABLE h_biz_query;

CREATE TABLE h_biz_query (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	code varchar(40) NULL,
	icon varchar(50) NULL,
	"name" varchar(50) NULL,
	name_i18n varchar(1000) NULL,
	publish bool NULL,
	querypresentationtype varchar(40) NULL,
	schemacode varchar(40) NULL,
	showonmobile bool NULL,
	showonpc bool NULL,
	sortkey int4 NULL,
	CONSTRAINT h_biz_query_pkey PRIMARY KEY (id)
);
CREATE INDEX uq_bq_schema_code ON h_biz_query USING btree (schemacode, code);


-- h_biz_query_action definition

-- Drop table

-- DROP TABLE h_biz_query_action;

CREATE TABLE h_biz_query_action (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	actioncode varchar(40) NULL,
	clienttype varchar(40) NULL,
	customservice bool NULL,
	extend1 varchar(255) NULL,
	icon varchar(50) NULL,
	"name" varchar(50) NULL,
	name_i18n varchar(1000) NULL,
	associationtype varchar(40) NULL,
	queryactiontype varchar(50) NULL,
	queryid varchar(36) NULL,
	associationcode varchar(40) NULL,
	schemacode varchar(40) NULL,
	servicecode varchar(40) NULL,
	servicemethod varchar(40) NULL,
	sortkey int4 NULL,
	systemaction bool NULL,
	CONSTRAINT h_biz_query_action_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_bqa_queryid_actioncode ON h_biz_query_action USING btree (queryid, actioncode);


-- h_biz_query_column definition

-- Drop table

-- DROP TABLE h_biz_query_column;

CREATE TABLE h_biz_query_column (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	clienttype varchar(40) NULL,
	displayformat int4 NULL,
	issystem bool NULL,
	"name" varchar(600) NULL,
	name_i18n varchar(1000) NULL,
	propertyalias varchar(100) NULL,
	propertycode varchar(40) NULL,
	propertytype varchar(40) NULL,
	queryid varchar(36) NULL,
	querylevel int4 NULL,
	schemaalias varchar(100) NULL,
	schemacode varchar(40) NULL,
	sortkey int4 NULL,
	sumtype varchar(40) NULL,
	syncdefaultformat bool NULL,
	unit int4 NULL,
	visible bool NULL,
	width varchar(50) NULL,
	CONSTRAINT h_biz_query_column_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_bqc_biz_query_column_queryid_sortkey ON h_biz_query_column USING btree (queryid, sortkey);


-- h_biz_query_condition definition

-- Drop table

-- DROP TABLE h_biz_query_condition;

CREATE TABLE h_biz_query_condition (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	accuratesearch bool NULL,
	choicetype varchar(10) NULL,
	clienttype varchar(40) NULL,
	datastatus varchar(40) NULL,
	datetype int4 NULL,
	defaultstate int4 NULL,
	defaultvalue varchar(500) NULL,
	displayformat varchar(40) NULL,
	displaytype varchar(10) NULL,
	endvalue varchar(50) NULL,
	filtertype varchar(10) NULL,
	includesubdata bool NULL,
	issystem bool NULL,
	"name" varchar(600) NULL,
	name_i18n varchar(1000) NULL,
	"options" text NULL,
	propertycode varchar(40) NULL,
	propertytype varchar(40) NULL,
	queryid varchar(36) NULL,
	relativequerycode varchar(40) NULL,
	schemacode varchar(40) NULL,
	sortkey int4 NULL,
	startvalue varchar(50) NULL,
	useroptiontype varchar(10) NULL,
	visible bool NULL,
	CONSTRAINT h_biz_query_condition_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_biz_query_condition_queryid_sortkey ON h_biz_query_condition USING btree (queryid, sortkey);


-- h_biz_query_gantt definition

-- Drop table

-- DROP TABLE h_biz_query_gantt;

CREATE TABLE h_biz_query_gantt (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	configjson text NULL,
	defaultprecision varchar(40) NULL,
	enddependencypropertycode varchar(40) NULL,
	endtimepropertycode varchar(40) NULL,
	levelpropertycode varchar(40) NULL,
	liablemancode varchar(40) NULL,
	milepostcode varchar(40) NULL,
	predependencypropertycode varchar(40) NULL,
	progresspropertycode varchar(40) NULL,
	queryid varchar(36) NULL,
	schemacode varchar(40) NULL,
	sortkey varchar(40) NULL,
	starttimepropertycode varchar(40) NULL,
	statuscode varchar(40) NULL,
	titlepropertycode varchar(40) NULL,
	CONSTRAINT h_biz_query_gantt_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_bqg_queryid ON h_biz_query_gantt USING btree (queryid);
CREATE INDEX idx_bqg_schemacode ON h_biz_query_gantt USING btree (schemacode);


-- h_biz_query_present definition

-- Drop table

-- DROP TABLE h_biz_query_present;

CREATE TABLE h_biz_query_present (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	actionsjson text NULL,
	clienttype varchar(40) NULL,
	columnsjson text NULL,
	htmljson text NULL,
	"options" text NULL,
	queryid varchar(36) NULL,
	queryviewdatasource text NULL,
	schemacode varchar(40) NULL,
	schemarelations text NULL,
	CONSTRAINT h_biz_query_present_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_qp_queryid ON h_biz_query_present USING btree (queryid);


-- h_biz_query_sorter definition

-- Drop table

-- DROP TABLE h_biz_query_sorter;

CREATE TABLE h_biz_query_sorter (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	clienttype varchar(40) NULL,
	direction varchar(40) NULL,
	issystem bool NULL,
	"name" varchar(600) NULL,
	name_i18n varchar(1000) NULL,
	propertycode varchar(40) NULL,
	propertytype varchar(40) NULL,
	queryid varchar(36) NULL,
	schemacode varchar(40) NULL,
	sortkey int4 NULL,
	CONSTRAINT h_biz_query_sorter_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_bqs_queryid ON h_biz_query_sorter USING btree (queryid);


-- h_biz_remind definition

-- Drop table

-- DROP TABLE h_biz_remind;

CREATE TABLE h_biz_remind (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	conditiontype varchar(20) NULL,
	dateoption varchar(300) NULL,
	datetype varchar(20) NULL,
	depids text NULL,
	enabled bool NULL,
	filtertype varchar(20) NULL,
	intervaltime int4 NULL,
	msgtemplate text NULL,
	remindtype varchar(20) NULL,
	rolecondition text NULL,
	roleids text NULL,
	schemacode varchar(100) NULL,
	sheetcode varchar(100) NULL,
	userdataoptions text NULL,
	userids text NULL,
	CONSTRAINT h_biz_remind_pkey PRIMARY KEY (id)
);


-- h_biz_rule definition

-- Drop table

-- DROP TABLE h_biz_rule;

CREATE TABLE h_biz_rule (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	chooseaction varchar(100) NULL,
	conditionjointype varchar(40) NULL,
	dataconditionjointype varchar(40) NULL,
	dataconditionjson text NULL,
	enabled bool NULL,
	insertconditionjointype varchar(40) NULL,
	"name" varchar(100) NULL,
	ruleactionjson text NULL,
	ruleactionmainscopejson text NULL,
	rulescopechildjson text NULL,
	rulescopejson text NULL,
	sourceschemacode varchar(40) NULL,
	targetschemacode varchar(40) NULL,
	targettablecode varchar(40) NULL,
	triggeractiontype varchar(40) NULL,
	triggerconditiontype varchar(40) NULL,
	triggerschemacode varchar(40) NULL,
	triggerschemacodeisgroup bool NULL,
	CONSTRAINT h_biz_rule_pkey PRIMARY KEY (id)
);


-- h_biz_rule_effect definition

-- Drop table

-- DROP TABLE h_biz_rule_effect;

CREATE TABLE h_biz_rule_effect (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	actiontype varchar(40) NULL,
	actionvalue varchar(255) NULL,
	lastvalue text NULL,
	setvalue text NULL,
	targetmainobjectid varchar(100) NULL,
	targetmainobjectname varchar(200) NULL,
	targetobjectid varchar(100) NULL,
	targetpropertycode varchar(40) NULL,
	targetpropertylastvalue text NULL,
	targetpropertyname varchar(50) NULL,
	targetpropertysetvalue text NULL,
	targetpropertytype int4 NULL,
	targetschemacode varchar(40) NULL,
	targettablecode varchar(40) NULL,
	targettabletype varchar(40) NULL,
	triggeractiontype varchar(40) NULL,
	triggerid varchar(100) NULL,
	triggerobjectid varchar(100) NULL,
	triggerschemacode varchar(40) NULL,
	CONSTRAINT h_biz_rule_effect_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_bre_trigger_id ON h_biz_rule_effect USING btree (triggerid);


-- h_biz_rule_trigger definition

-- Drop table

-- DROP TABLE h_biz_rule_trigger;

CREATE TABLE h_biz_rule_trigger (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	conditionjointype varchar(40) NULL,
	effect bool NULL,
	faillog text NULL,
	ruleid varchar(100) NULL,
	rulename varchar(100) NULL,
	sourceappcode varchar(40) NULL,
	sourceappname varchar(50) NULL,
	sourceschemacode varchar(40) NULL,
	sourceschemaname varchar(50) NULL,
	success bool NULL,
	targetschemacode varchar(40) NULL,
	targetschemaname varchar(50) NULL,
	targettablecode varchar(40) NULL,
	triggeractiontype varchar(40) NULL,
	triggerconditiontype varchar(40) NULL,
	triggermainobjectid varchar(100) NULL,
	triggermainobjectname varchar(200) NULL,
	triggerobjectid varchar(100) NULL,
	triggerschemacode varchar(40) NULL,
	triggertabletype varchar(40) NULL,
	CONSTRAINT h_biz_rule_trigger_pkey PRIMARY KEY (id)
);


-- h_biz_schema definition

-- Drop table

-- DROP TABLE h_biz_schema;

CREATE TABLE h_biz_schema (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	businessruleenable bool NULL,
	code varchar(40) NULL,
	icon varchar(50) NULL,
	modeltype varchar(40) NULL,
	"name" varchar(50) NULL,
	name_i18n varchar(1000) NULL,
	published bool NULL,
	summary varchar(2000) NULL,
	CONSTRAINT h_biz_schema_pkey PRIMARY KEY (id)
);
CREATE UNIQUE INDEX uq_schemacode ON h_biz_schema USING btree (code);


-- h_biz_service definition

-- Drop table

-- DROP TABLE h_biz_service;

CREATE TABLE h_biz_service (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	adaptercode varchar(40) NULL,
	code varchar(40) NULL,
	configjson text NULL,
	description varchar(2000) NULL,
	"name" varchar(50) NULL,
	servicecategoryid varchar(40) NULL,
	shared bool NULL,
	userids text NULL,
	CONSTRAINT h_biz_service_pkey PRIMARY KEY (id)
);
CREATE UNIQUE INDEX uq_s_code ON h_biz_service USING btree (code);


-- h_biz_service_category definition

-- Drop table

-- DROP TABLE h_biz_service_category;

CREATE TABLE h_biz_service_category (
	id varchar(120) NOT NULL,
	createdby varchar(120) NULL,
	createdtime timestamp NULL,
	modifiedby varchar(120) NULL,
	modifiedtime timestamp NULL,
	"name" varchar(50) NULL,
	CONSTRAINT h_biz_service_category_pkey PRIMARY KEY (id)
);


-- h_biz_service_method definition

-- Drop table

-- DROP TABLE h_biz_service_method;

CREATE TABLE h_biz_service_method (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	code varchar(40) NULL,
	configjson text NULL,
	description varchar(2000) NULL,
	inputparametersjson text NULL,
	"name" varchar(50) NULL,
	outputparametersjson text NULL,
	protocoladaptertype varchar(40) NULL,
	servicecode varchar(40) NULL,
	CONSTRAINT h_biz_service_method_pkey PRIMARY KEY (id)
);
CREATE UNIQUE INDEX uq_sm_code ON h_biz_service_method USING btree (code);


-- h_biz_sheet definition

-- Drop table

-- DROP TABLE h_biz_sheet;

CREATE TABLE h_biz_sheet (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	bordermode varchar(10) NULL,
	code varchar(40) NULL,
	draftactionsjson text NULL,
	draftattributesjson text NULL,
	drafthtmljson text NULL,
	draftschemaoptionsjson text NULL,
	draftviewjson text NULL,
	existdraft bool NULL,
	externallinkable bool NULL,
	formcomment bool NULL,
	formsystemversion varchar(32) NULL,
	formtrack bool NULL,
	sheettype varchar(50) NULL,
	icon varchar(50) NULL,
	layouttype varchar(20) NULL,
	mobileispc bool NULL,
	mobileurl varchar(500) NULL,
	"name" varchar(50) NULL,
	name_i18n varchar(1000) NULL,
	"options" text NULL,
	pcurl varchar(500) NULL,
	pdfable varchar(40) NULL,
	printispc bool NULL,
	printjson text NULL,
	printtemplatejson text NULL,
	printurl varchar(500) NULL,
	published bool NULL,
	publishedactionsjson text NULL,
	publishedattributesjson text NULL,
	publishedhtmljson text NULL,
	publishedviewjson text NULL,
	qrcodeable varchar(40) NULL,
	schemacode varchar(40) NULL,
	serialcode varchar(255) NULL,
	serialresettype varchar(40) NULL,
	shortcode varchar(50) NULL,
	sortkey int4 NULL,
	tempauthschemacodes varchar(3500) NULL,
	trackdatacodes text NULL,
	CONSTRAINT h_biz_sheet_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_bs_schemacode ON h_biz_sheet USING btree (schemacode, code);


-- h_biz_sheet_history definition

-- Drop table

-- DROP TABLE h_biz_sheet_history;

CREATE TABLE h_biz_sheet_history (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	bordermode varchar(10) NULL,
	code varchar(40) NULL,
	draftactionsjson text NULL,
	draftattributesjson text NULL,
	drafthtmljson text NULL,
	draftviewjson text NULL,
	externallinkable bool NULL,
	formcomment bool NULL,
	formtrack bool NULL,
	sheettype varchar(50) NULL,
	icon varchar(50) NULL,
	layouttype varchar(20) NULL,
	mobileispc bool NULL,
	mobileurl varchar(500) NULL,
	"name" varchar(50) NULL,
	name_i18n varchar(1000) NULL,
	"options" text NULL,
	pcurl varchar(500) NULL,
	pdfable varchar(40) NULL,
	printispc bool NULL,
	printtemplatejson text NULL,
	printurl varchar(500) NULL,
	publishby varchar(120) NULL,
	published bool NULL,
	publishedactionsjson text NULL,
	publishedattributesjson text NULL,
	publishedhtmljson text NULL,
	publishedviewjson text NULL,
	qrcodeable varchar(40) NULL,
	schemacode varchar(40) NULL,
	serialcode varchar(255) NULL,
	serialresettype varchar(40) NULL,
	shortcode varchar(50) NULL,
	sortkey int4 NULL,
	tempauthschemacodes varchar(3500) NULL,
	trackdatacodes text NULL,
	"version" int4 NULL,
	CONSTRAINT h_biz_sheet_history_pkey PRIMARY KEY (id)
);


-- h_business_rule definition

-- Drop table

-- DROP TABLE h_business_rule;

CREATE TABLE h_business_rule (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	bizruletype varchar(15) NULL,
	code varchar(40) NULL,
	defaultrule bool NULL,
	enabled bool NULL,
	"name" varchar(100) NULL,
	node text NULL,
	quoteproperty text NULL,
	route text NULL,
	schedulersetting text NULL,
	schemacode varchar(40) NULL,
	CONSTRAINT h_business_rule_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_br_schema_code ON h_business_rule USING btree (schemacode, code);


-- h_business_rule_runmap definition

-- Drop table

-- DROP TABLE h_business_rule_runmap;

CREATE TABLE h_business_rule_runmap (
	id varchar(120) NOT NULL,
	nodecode varchar(40) NULL,
	nodename varchar(100) NULL,
	nodetype varchar(15) NULL,
	rulecode varchar(40) NULL,
	rulename varchar(100) NULL,
	ruletype varchar(15) NULL,
	targetschemacode varchar(40) NULL,
	triggerschemacode varchar(40) NULL,
	CONSTRAINT h_business_rule_runmap_pkey PRIMARY KEY (id)
);


-- h_custom_page definition

-- Drop table

-- DROP TABLE h_custom_page;

CREATE TABLE h_custom_page (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	appcode varchar(40) NULL,
	code varchar(40) NULL,
	icon varchar(50) NULL,
	mobileurl varchar(500) NULL,
	"name" varchar(50) NULL,
	name_i18n varchar(1000) NULL,
	openmode varchar(40) NULL,
	pcurl varchar(500) NULL,
	CONSTRAINT h_custom_page_pkey PRIMARY KEY (id)
);


-- h_data_dictionary definition

-- Drop table

-- DROP TABLE h_data_dictionary;

CREATE TABLE h_data_dictionary (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	classificationid varchar(120) NULL,
	code varchar(50) NULL,
	dictionarytype varchar(20) NULL,
	"name" varchar(50) NULL,
	sortkey int4 NULL,
	status bool NULL,
	CONSTRAINT h_data_dictionary_pkey PRIMARY KEY (id)
);
CREATE UNIQUE INDEX uq_dd_code ON h_data_dictionary USING btree (code);


-- h_dictionary_class definition

-- Drop table

-- DROP TABLE h_dictionary_class;

CREATE TABLE h_dictionary_class (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	"name" varchar(50) NULL,
	sortkey int4 NULL,
	CONSTRAINT h_dictionary_class_pkey PRIMARY KEY (id)
);


-- h_dictionary_record definition

-- Drop table

-- DROP TABLE h_dictionary_record;

CREATE TABLE h_dictionary_record (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	code varchar(50) NULL,
	dictionaryid varchar(120) NULL,
	initialused bool NULL,
	"name" varchar(50) NULL,
	parentid varchar(255) NULL,
	sortkey int4 NULL,
	status bool NULL,
	CONSTRAINT h_dictionary_record_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_dr_dictionaryid ON h_dictionary_record USING btree (dictionaryid);


-- h_form_comment definition

-- Drop table

-- DROP TABLE h_form_comment;

CREATE TABLE h_form_comment (
	id varchar(120) NOT NULL,
	attachmentnum int4 NOT NULL,
	bizobjectid varchar(42) NOT NULL,
	commentator varchar(42) NOT NULL,
	commentatorname varchar(80) NOT NULL,
	"content" varchar(3000) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	departmentid varchar(42) NULL,
	floor int4 NOT NULL,
	modifiedtime timestamp NULL,
	modifier varchar(42) NULL,
	origincommentid varchar(42) NULL,
	replycommentid varchar(42) NULL,
	replyuserid varchar(42) NULL,
	replyusername varchar(80) NULL,
	schemacode varchar(42) NOT NULL,
	state varchar(20) NOT NULL,
	"text" varchar(5000) NULL,
	CONSTRAINT h_form_comment_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_form_obj_id ON h_form_comment USING btree (bizobjectid);


-- h_from_comment_attachment definition

-- Drop table

-- DROP TABLE h_from_comment_attachment;

CREATE TABLE h_from_comment_attachment (
	id varchar(120) NOT NULL,
	base64imagestr text NULL,
	bizobjectid varchar(42) NOT NULL,
	commentid varchar(42) NOT NULL,
	createdtime timestamp NULL,
	creater varchar(42) NOT NULL,
	fileextension varchar(30) NULL,
	filesize int4 NULL,
	mimetype varchar(50) NOT NULL,
	"name" varchar(255) NOT NULL,
	refid varchar(200) NOT NULL,
	schemacode varchar(42) NOT NULL,
	CONSTRAINT h_from_comment_attachment_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_f_c_a_comm_id ON h_from_comment_attachment USING btree (commentid);
CREATE INDEX idx_f_c_a_ref_id ON h_from_comment_attachment USING btree (refid);


-- h_im_message definition

-- Drop table

-- DROP TABLE h_im_message;

CREATE TABLE h_im_message (
	id varchar(36) NOT NULL,
	bizparams text NULL,
	channel varchar(40) NULL,
	"content" text NULL,
	createdtime timestamp NULL,
	externallink bool NULL,
	failretry bool NULL,
	failuserretry bool NULL,
	messagetype varchar(40) NULL,
	modifiedtime timestamp NULL,
	receivers text NULL,
	title varchar(200) NULL,
	trytimes int4 NULL,
	url varchar(500) NULL,
	smscode varchar(50) NULL,
	smsparams text NULL,
	CONSTRAINT h_im_message_pkey PRIMARY KEY (id)
);


-- h_im_message_history definition

-- Drop table

-- DROP TABLE h_im_message_history;

CREATE TABLE h_im_message_history (
	id varchar(36) NOT NULL,
	bizparams text NULL,
	channel varchar(40) NULL,
	"content" text NULL,
	createdtime timestamp NULL,
	externallink bool NULL,
	failretry bool NULL,
	failuserretry bool NULL,
	messagetype varchar(40) NULL,
	modifiedtime timestamp NULL,
	receivers text NULL,
	title varchar(200) NULL,
	trytimes int4 NULL,
	url varchar(500) NULL,
	sendfailuserids text NULL,
	smscode varchar(50) NULL,
	smsparams text NULL,
	status varchar(40) NULL,
	taskid varchar(40) NULL,
	CONSTRAINT h_im_message_history_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_message_history_status ON h_im_message_history USING btree (status);


-- h_im_message_station definition

-- Drop table

-- DROP TABLE h_im_message_station;

CREATE TABLE h_im_message_station (
	id varchar(120) NOT NULL,
	bizparams text NULL,
	"content" text NULL,
	createdtime timestamp NULL,
	messagetype varchar(40) NULL,
	modifiedtime timestamp NULL,
	sender varchar(42) NULL,
	title varchar(200) NULL,
	CONSTRAINT h_im_message_station_pkey PRIMARY KEY (id)
);


-- h_im_message_station_user definition

-- Drop table

-- DROP TABLE h_im_message_station_user;

CREATE TABLE h_im_message_station_user (
	id varchar(120) NOT NULL,
	messageid varchar(36) NULL,
	modifiedtime timestamp NULL,
	readstate varchar(255) NULL,
	receiver varchar(42) NULL,
	CONSTRAINT h_im_message_station_user_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_imsu_readstate ON h_im_message_station_user USING btree (readstate);
CREATE INDEX idx_imsu_receiver ON h_im_message_station_user USING btree (receiver);


-- h_im_urge_task definition

-- Drop table

-- DROP TABLE h_im_urge_task;

CREATE TABLE h_im_urge_task (
	id varchar(120) NOT NULL,
	instanceid varchar(120) NOT NULL,
	messageid varchar(120) NULL,
	optime timestamp NULL,
	"text" varchar(255) NOT NULL,
	urgetype int4 NULL,
	userid varchar(80) NOT NULL,
	CONSTRAINT h_im_urge_task_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_hasten_inst_userid ON h_im_urge_task USING btree (instanceid, userid);


-- h_im_urge_workitem definition

-- Drop table

-- DROP TABLE h_im_urge_workitem;

CREATE TABLE h_im_urge_workitem (
	id varchar(120) NOT NULL,
	createtime timestamp NULL,
	modifytime timestamp NULL,
	urgecount int4 NULL,
	userid varchar(255) NULL,
	workitemid varchar(255) NULL,
	CONSTRAINT h_im_urge_workitem_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_urge_itemid_userid ON h_im_urge_workitem USING btree (workitemid, userid);


-- h_im_work_record definition

-- Drop table

-- DROP TABLE h_im_work_record;

CREATE TABLE h_im_work_record (
	id varchar(36) NOT NULL,
	bizparams text NULL,
	channel varchar(40) NULL,
	"content" text NULL,
	createdtime timestamp NULL,
	failretry bool NULL,
	failuserretry bool NULL,
	messagetype varchar(200) NULL,
	modifiedtime timestamp NULL,
	receivers text NULL,
	recordid varchar(100) NULL,
	requestid varchar(100) NULL,
	title varchar(200) NULL,
	trytimes int4 NULL,
	url varchar(500) NULL,
	workrecordstatus varchar(40) NULL,
	workitemid varchar(100) NULL,
	CONSTRAINT h_im_work_record_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_iwr_recordid ON h_im_work_record USING btree (recordid);


-- h_im_work_record_history definition

-- Drop table

-- DROP TABLE h_im_work_record_history;

CREATE TABLE h_im_work_record_history (
	id varchar(36) NOT NULL,
	bizparams text NULL,
	channel varchar(40) NULL,
	"content" text NULL,
	createdtime timestamp NULL,
	failretry bool NULL,
	failuserretry bool NULL,
	messagetype varchar(40) NULL,
	modifiedtime timestamp NULL,
	receivers text NULL,
	recordid varchar(100) NULL,
	requestid varchar(100) NULL,
	title varchar(200) NULL,
	trytimes int4 NULL,
	url varchar(500) NULL,
	workrecordstatus varchar(40) NULL,
	workitemid varchar(100) NULL,
	status varchar(40) NULL,
	taskid varchar(42) NULL,
	CONSTRAINT h_im_work_record_history_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_iwrh_recordid ON h_im_work_record_history USING btree (recordid);


-- h_job_result definition

-- Drop table

-- DROP TABLE h_job_result;

CREATE TABLE h_job_result (
	id varchar(120) NOT NULL,
	beanname varchar(100) NULL,
	createtime timestamp NULL,
	cronexpression varchar(80) NULL,
	executestatus varchar(20) NULL,
	jobname varchar(100) NULL,
	jobruntype varchar(20) NULL,
	methodname varchar(100) NULL,
	methodparams varchar(255) NULL,
	taskid varchar(120) NULL,
	triggertime timestamp NULL,
	"year" int4 NULL,
	CONSTRAINT h_job_result_pkey PRIMARY KEY (id)
);


-- h_log_biz_object definition

-- Drop table

-- DROP TABLE h_log_biz_object;

CREATE TABLE h_log_biz_object (
	id varchar(120) NOT NULL,
	client text NULL,
	detail text NULL,
	ip varchar(500) NULL,
	operatenode varchar(100) NULL,
	operationtype varchar(50) NULL,
	"time" timestamp NULL,
	username varchar(100) NULL,
	workflowinstanceid varchar(120) NULL,
	CONSTRAINT h_log_biz_object_pkey PRIMARY KEY (id)
);


-- h_log_biz_service definition

-- Drop table

-- DROP TABLE h_log_biz_service;

CREATE TABLE h_log_biz_service (
	id varchar(120) NOT NULL,
	bizobjectid varchar(200) NULL,
	bizservicestatus varchar(20) NULL,
	code varchar(40) NULL,
	createdtime timestamp NULL,
	endtime timestamp NULL,
	"exception" text NULL,
	methodname varchar(120) NULL,
	"options" text NULL,
	params varchar(2000) NULL,
	"result" text NULL,
	schemacode varchar(40) NULL,
	"server" varchar(200) NULL,
	starttime timestamp NULL,
	usedtime int8 NULL,
	CONSTRAINT h_log_biz_service_pkey PRIMARY KEY (id)
);


-- h_log_business_rule_content definition

-- Drop table

-- DROP TABLE h_log_business_rule_content;

CREATE TABLE h_log_business_rule_content (
	id varchar(120) NOT NULL,
	exceptioncontent text NULL,
	exceptionnodecode varchar(120) NULL,
	exceptionnodename varchar(200) NULL,
	flowinstanceid varchar(120) NULL,
	triggercoredata text NULL,
	CONSTRAINT h_log_business_rule_content_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_h_log_business_rule_content_flowinstanceid ON h_log_business_rule_content USING btree (flowinstanceid);


-- h_log_business_rule_data_trace definition

-- Drop table

-- DROP TABLE h_log_business_rule_data_trace;

CREATE TABLE h_log_business_rule_data_trace (
	id varchar(120) NOT NULL,
	flowinstanceid varchar(120) NULL,
	nodecode varchar(120) NULL,
	nodeinstanceid varchar(120) NULL,
	nodename varchar(200) NULL,
	ruletriggeractiontype varchar(40) NULL,
	targetobjectid varchar(120) NULL,
	targetschemacode varchar(40) NULL,
	tracelastdata text NULL,
	tracesetdata text NULL,
	traceupdatedetail text NULL,
	CONSTRAINT h_log_business_rule_data_trace_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_h_log_business_rule_data_trace_flowinstanceid ON h_log_business_rule_data_trace USING btree (flowinstanceid);


-- h_log_business_rule_header definition

-- Drop table

-- DROP TABLE h_log_business_rule_header;

CREATE TABLE h_log_business_rule_header (
	id varchar(120) NOT NULL,
	businessrulecode varchar(40) NULL,
	businessrulename varchar(200) NULL,
	endtime timestamp NULL,
	extend varchar(255) NULL,
	flowinstanceid varchar(120) NULL,
	originator varchar(40) NULL,
	repair bool NULL,
	schemacode varchar(40) NULL,
	sourceflowinstanceid varchar(120) NULL,
	starttime timestamp NULL,
	success bool NULL,
	CONSTRAINT h_log_business_rule_header_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_h_log_business_rule_header_flowinstanceid ON h_log_business_rule_header USING btree (flowinstanceid);


-- h_log_business_rule_node definition

-- Drop table

-- DROP TABLE h_log_business_rule_node;

CREATE TABLE h_log_business_rule_node (
	id varchar(120) NOT NULL,
	endtime timestamp NULL,
	flowinstanceid varchar(120) NULL,
	nodecode varchar(120) NULL,
	nodeinstanceid varchar(120) NULL,
	nodename varchar(200) NULL,
	nodesequence int4 NULL,
	starttime timestamp NULL,
	CONSTRAINT h_log_business_rule_node_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_h_log_business_rule_node_flowinstanceid ON h_log_business_rule_node USING btree (flowinstanceid);


-- h_log_login definition

-- Drop table

-- DROP TABLE h_log_login;

CREATE TABLE h_log_login (
	id varchar(120) NOT NULL,
	browser varchar(50) NULL,
	clientagent varchar(500) NULL,
	ipaddress varchar(20) NULL,
	loginsourcetype varchar(40) NULL,
	logintime timestamp NULL,
	"name" varchar(40) NULL,
	userid varchar(40) NULL,
	username varchar(40) NULL,
	CONSTRAINT h_log_login_pkey PRIMARY KEY (id)
);


-- h_log_metadata definition

-- Drop table

-- DROP TABLE h_log_metadata;

CREATE TABLE h_log_metadata (
	id varchar(120) NOT NULL,
	bizkey varchar(120) NULL,
	metadata text NULL,
	modulename varchar(60) NULL,
	objid varchar(120) NULL,
	operatetime timestamp NULL,
	operatetype int4 NULL,
	"operator" varchar(120) NULL,
	CONSTRAINT h_log_metadata_pkey PRIMARY KEY (id)
);


-- h_log_synchro definition

-- Drop table

-- DROP TABLE h_log_synchro;

CREATE TABLE h_log_synchro (
	id varchar(120) NOT NULL,
	createdtime timestamp NULL,
	creater varchar(120) NOT NULL,
	endtime timestamp NULL,
	executestatus varchar(40) NOT NULL,
	fixnotes varchar(1000) NULL,
	fixedcount int4 NULL,
	fixedstatus varchar(40) NOT NULL,
	fixedtime timestamp NULL,
	fixer varchar(120) NULL,
	starttime timestamp NULL,
	trackid varchar(255) NULL,
	CONSTRAINT h_log_synchro_pkey PRIMARY KEY (id)
);


-- h_log_workflow_exception definition

-- Drop table

-- DROP TABLE h_log_workflow_exception;

CREATE TABLE h_log_workflow_exception (
	id varchar(120) NOT NULL,
	createdtime timestamp NULL,
	creater varchar(120) NOT NULL,
	creatername varchar(200) NULL,
	detail text NULL,
	extdata varchar(1000) NULL,
	fixnotes varchar(1000) NULL,
	fixedtime timestamp NULL,
	fixer varchar(120) NULL,
	fixername varchar(200) NULL,
	status varchar(40) NOT NULL,
	summary varchar(500) NOT NULL,
	workflowcode varchar(40) NOT NULL,
	workflowinstanceid varchar(120) NOT NULL,
	workflowinstancename varchar(200) NULL,
	workflowname varchar(200) NULL,
	workflowversion int4 NOT NULL,
	CONSTRAINT h_log_workflow_exception_pkey PRIMARY KEY (id)
);


-- h_open_api_event definition

-- Drop table

-- DROP TABLE h_open_api_event;

CREATE TABLE h_open_api_event (
	id varchar(120) NOT NULL,
	callback varchar(400) NULL,
	clientid varchar(200) NULL,
	eventtarget varchar(300) NULL,
	eventtargettype varchar(255) NULL,
	eventtype varchar(255) NULL,
	"options" text NULL,
	CONSTRAINT h_open_api_event_pkey PRIMARY KEY (id)
);


-- h_org_department definition

-- Drop table

-- DROP TABLE h_org_department;

CREATE TABLE h_org_department (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	extend1 varchar(255) NULL,
	extend2 varchar(255) NULL,
	extend3 varchar(255) NULL,
	extend4 int4 NULL,
	extend5 int4 NULL,
	calendarid varchar(36) NULL,
	corpid varchar(255) NULL,
	depttype varchar(40) NULL,
	dingdeptmanagerid varchar(255) NULL,
	employees int4 NULL,
	enabled bool NULL,
	isshow bool NULL,
	leaf bool NULL,
	managerid varchar(36) NULL,
	"name" varchar(200) NULL,
	parentid varchar(36) NULL,
	querycode varchar(255) NULL,
	sortkey int8 NULL,
	sourceid varchar(40) NULL,
	CONSTRAINT h_org_department_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_od_org_name ON h_org_department USING btree (name);
CREATE INDEX idx_od_parent_id ON h_org_department USING btree (parentid);
CREATE INDEX idx_od_querycode ON h_org_department USING btree (querycode);


-- h_org_department_history definition

-- Drop table

-- DROP TABLE h_org_department_history;

CREATE TABLE h_org_department_history (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	extend1 varchar(255) NULL,
	extend2 varchar(255) NULL,
	extend3 varchar(255) NULL,
	extend4 int4 NULL,
	extend5 int4 NULL,
	calendarid varchar(36) NULL,
	changeaction varchar(20) NULL,
	changetime timestamp NULL,
	corpid varchar(255) NULL,
	employees int4 NULL,
	leaf bool NULL,
	managerid varchar(2000) NULL,
	"name" varchar(200) NULL,
	parentid varchar(36) NULL,
	querycode varchar(512) NULL,
	sortkey int8 NULL,
	sourceid varchar(40) NULL,
	targetparentid varchar(36) NULL,
	targetquerycode varchar(512) NULL,
	"version" int4 NULL,
	CONSTRAINT h_org_department_history_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_hist_source_id ON h_org_department_history USING btree (sourceid);


-- h_org_dept_user definition

-- Drop table

-- DROP TABLE h_org_dept_user;

CREATE TABLE h_org_dept_user (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	deptid varchar(36) NULL,
	deptsourceid varchar(255) NULL,
	leader bool NULL,
	main bool NULL,
	sortkey int8 NULL,
	userid varchar(36) NULL,
	usersourceid varchar(255) NULL,
	CONSTRAINT h_org_dept_user_pkey PRIMARY KEY (id)
);
CREATE UNIQUE INDEX idx_dept_user_composeid ON h_org_dept_user USING btree (userid, deptid);
CREATE INDEX idx_du_user_id ON h_org_dept_user USING btree (userid);


-- h_org_direct_manager definition

-- Drop table

-- DROP TABLE h_org_direct_manager;

CREATE TABLE h_org_direct_manager (
	id varchar(120) NOT NULL,
	createdtime timestamp NULL,
	creater varchar(120) NULL,
	deptid varchar(36) NULL,
	managerid varchar(36) NULL,
	modifiedtime timestamp NULL,
	modifier varchar(120) NULL,
	remarks varchar(200) NULL,
	userid varchar(36) NULL,
	CONSTRAINT h_org_direct_manager_pkey PRIMARY KEY (id)
);
CREATE UNIQUE INDEX uq_direct_user_dept ON h_org_direct_manager USING btree (userid, deptid);


-- h_org_inc_sync_record definition

-- Drop table

-- DROP TABLE h_org_inc_sync_record;

CREATE TABLE h_org_inc_sync_record (
	id varchar(120) NOT NULL,
	corpid varchar(255) NULL,
	createtime timestamp NULL,
	eventinfo text NULL,
	eventtype varchar(255) NULL,
	handlestatus varchar(255) NULL,
	retrycount int4 NULL,
	syncsourcetype int4 NULL,
	updatetime timestamp NULL,
	CONSTRAINT h_org_inc_sync_record_pkey PRIMARY KEY (id)
);


-- h_org_role definition

-- Drop table

-- DROP TABLE h_org_role;

CREATE TABLE h_org_role (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	extend1 varchar(255) NULL,
	extend2 varchar(255) NULL,
	extend3 varchar(255) NULL,
	extend4 int4 NULL,
	extend5 int4 NULL,
	code varchar(255) NULL,
	corpid varchar(255) NULL,
	groupid varchar(36) NULL,
	"name" varchar(255) NULL,
	roletype varchar(40) NULL,
	sortkey int4 NULL,
	sourceid varchar(40) NULL,
	CONSTRAINT h_org_role_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_rolde_groupid ON h_org_role USING btree (groupid);
CREATE UNIQUE INDEX uq_role_code ON h_org_role USING btree (code);


-- h_org_role_group definition

-- Drop table

-- DROP TABLE h_org_role_group;

CREATE TABLE h_org_role_group (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	code varchar(255) NULL,
	corpid varchar(255) NULL,
	defaultgroup bool NULL,
	"name" varchar(256) NULL,
	parentid varchar(120) NULL,
	roleid varchar(36) NULL,
	roletype varchar(40) NULL,
	sortkey int4 NULL,
	sourceid varchar(40) NULL,
	CONSTRAINT h_org_role_group_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_role_group_id ON h_org_role_group USING btree (id);
CREATE UNIQUE INDEX uq_role_group_code ON h_org_role_group USING btree (code);


-- h_org_role_user definition

-- Drop table

-- DROP TABLE h_org_role_user;

CREATE TABLE h_org_role_user (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	deptid varchar(36) NULL,
	ouscope varchar(4000) NULL,
	roleid varchar(36) NULL,
	rolesourceid varchar(255) NULL,
	unittype varchar(40) NULL,
	usscope text NULL,
	userid varchar(36) NULL,
	usersourceid varchar(255) NULL,
	CONSTRAINT h_org_role_user_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_oru_roleid ON h_org_role_user USING btree (roleid);
CREATE INDEX idx_oru_userid ON h_org_role_user USING btree (userid);


-- h_org_synchronize_log definition

-- Drop table

-- DROP TABLE h_org_synchronize_log;

CREATE TABLE h_org_synchronize_log (
	id varchar(120) NOT NULL,
	corpid varchar(255) NULL,
	errortype varchar(255) NULL,
	issyncrolescope int4 NOT NULL,
	status varchar(255) NULL,
	targetid varchar(255) NULL,
	targettype varchar(1000) NULL,
	trackid varchar(255) NULL,
	CONSTRAINT h_org_synchronize_log_pkey PRIMARY KEY (id)
);


-- h_org_synchronize_task definition

-- Drop table

-- DROP TABLE h_org_synchronize_task;

CREATE TABLE h_org_synchronize_task (
	id varchar(120) NOT NULL,
	endtime timestamp NULL,
	message varchar(255) NULL,
	starttime timestamp NULL,
	syncresult varchar(255) NULL,
	taskstatus varchar(255) NULL,
	userid varchar(255) NULL,
	CONSTRAINT h_org_synchronize_task_pkey PRIMARY KEY (id)
);


-- h_org_user definition

-- Drop table

-- DROP TABLE h_org_user;

CREATE TABLE h_org_user (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	extend1 varchar(255) NULL,
	extend2 varchar(255) NULL,
	extend3 varchar(255) NULL,
	extend4 int4 NULL,
	extend5 int4 NULL,
	active bool NULL,
	"admin" bool NULL,
	appellation varchar(40) NULL,
	birthday timestamp NULL,
	boss bool NULL,
	corpid varchar(255) NULL,
	departmentid varchar(255) NULL,
	departuredate timestamp NULL,
	dinguserjson text NULL,
	dingtalkid varchar(100) NULL,
	email varchar(40) NULL,
	employeeno varchar(40) NULL,
	employeerank int4 NULL,
	enabled bool NULL,
	entrydate timestamp NULL,
	gender varchar(10) NULL,
	identityno varchar(18) NULL,
	imgurl varchar(200) NULL,
	imgurlid varchar(200) NULL,
	leader bool NULL,
	managerid varchar(40) NULL,
	mobile varchar(100) NULL,
	"name" varchar(250) NULL,
	officephone varchar(20) NULL,
	"password" varchar(100) NULL,
	pinyin varchar(250) NULL,
	"position" varchar(80) NULL,
	privacylevel varchar(40) NULL,
	secretaryid varchar(36) NULL,
	shortpinyin varchar(250) NULL,
	sortkey int8 NULL,
	sourceid varchar(50) NULL,
	status varchar(40) NULL,
	userid varchar(255) NULL,
	userworkstatus varchar(40) NULL,
	username varchar(100) NULL,
	CONSTRAINT h_org_user_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_org_user_username_corpid ON h_org_user USING btree (username, corpid);
CREATE INDEX idx_ou_corpid_userid ON h_org_user USING btree (userid, corpid);


-- h_org_user_extend_attr definition

-- Drop table

-- DROP TABLE h_org_user_extend_attr;

CREATE TABLE h_org_user_extend_attr (
	id varchar(120) NOT NULL,
	belong varchar(120) NULL,
	code varchar(120) NULL,
	corpid varchar(255) NULL,
	createdby varchar(120) NULL,
	createdtime timestamp NULL,
	deleted int2 NULL,
	"enable" int2 NULL,
	mapkey varchar(120) NULL,
	modifiedby varchar(120) NULL,
	modifiedtime timestamp NULL,
	"name" varchar(255) NULL,
	CONSTRAINT h_org_user_extend_attr_pkey PRIMARY KEY (id)
);
CREATE UNIQUE INDEX uk_code_corpid ON h_org_user_extend_attr USING btree (corpid, code);


-- h_org_user_transfer_detail definition

-- Drop table

-- DROP TABLE h_org_user_transfer_detail;

CREATE TABLE h_org_user_transfer_detail (
	id varchar(120) NOT NULL,
	recordid varchar(255) NULL,
	transferdata text NULL,
	CONSTRAINT h_org_user_transfer_detail_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_outd_record_id ON h_org_user_transfer_detail USING btree (recordid);


-- h_org_user_transfer_record definition

-- Drop table

-- DROP TABLE h_org_user_transfer_record;

CREATE TABLE h_org_user_transfer_record (
	id varchar(120) NOT NULL,
	"comments" varchar(2048) NULL,
	processtime timestamp NULL,
	processuserid varchar(255) NULL,
	receiveuserid varchar(120) NULL,
	sourceuserid varchar(120) NULL,
	transfersize int4 NULL,
	transfertype varchar(120) NULL,
	CONSTRAINT h_org_user_transfer_record_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_outr_sourceuser ON h_org_user_transfer_record USING btree (sourceuserid);


-- h_org_user_union_extend_attr definition

-- Drop table

-- DROP TABLE h_org_user_union_extend_attr;

CREATE TABLE h_org_user_union_extend_attr (
	id varchar(120) NOT NULL,
	createdby varchar(120) NULL,
	createdtime timestamp NULL,
	deleted int2 NULL,
	extendattrid varchar(120) NULL,
	mapval varchar(500) NULL,
	modifiedby varchar(120) NULL,
	modifiedtime timestamp NULL,
	userid varchar(120) NULL,
	CONSTRAINT h_org_user_union_extend_attr_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_ouuea_extendattrid ON h_org_user_union_extend_attr USING btree (extendattrid);
CREATE INDEX idx_ouuea_userid ON h_org_user_union_extend_attr USING btree (userid);
CREATE UNIQUE INDEX uk_userid_attrid ON h_org_user_union_extend_attr USING btree (userid, extendattrid);


-- h_perm_admin definition

-- Drop table

-- DROP TABLE h_perm_admin;

CREATE TABLE h_perm_admin (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	admintype varchar(40) NULL,
	appmanage bool NULL,
	datadictionarymanage bool NULL,
	datamanage bool NULL,
	dataquery bool NULL,
	parentid varchar(120) NULL,
	rolemanage bool NULL,
	userid varchar(40) NULL,
	CONSTRAINT h_perm_admin_pkey PRIMARY KEY (id)
);
CREATE UNIQUE INDEX uq_userid_type ON h_perm_admin USING btree (userid, admintype);


-- h_perm_admin_group definition

-- Drop table

-- DROP TABLE h_perm_admin_group;

CREATE TABLE h_perm_admin_group (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	adminid varchar(255) NULL,
	apppackagesjson text NULL,
	departmentsjson text NULL,
	externallinkvisible bool NULL,
	CONSTRAINT h_perm_admin_group_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_pag_adminid ON h_perm_admin_group USING btree (adminid);


-- h_perm_app_package definition

-- Drop table

-- DROP TABLE h_perm_app_package;

CREATE TABLE h_perm_app_package (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	appcode varchar(40) NULL,
	departments text NULL,
	roles text NULL,
	visibletype varchar(40) NULL,
	CONSTRAINT h_perm_app_package_pkey PRIMARY KEY (id)
);
CREATE UNIQUE INDEX uq_appcode ON h_perm_app_package USING btree (appcode);


-- h_perm_apppackage_scope definition

-- Drop table

-- DROP TABLE h_perm_apppackage_scope;

CREATE TABLE h_perm_apppackage_scope (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	adminid varchar(40) NULL,
	code varchar(40) NULL,
	"name" varchar(50) NULL,
	CONSTRAINT h_perm_apppackage_scope_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_pas_adminid ON h_perm_apppackage_scope USING btree (adminid);


-- h_perm_biz_function definition

-- Drop table

-- DROP TABLE h_perm_biz_function;

CREATE TABLE h_perm_biz_function (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	"attribute" text NULL,
	batchprintable bool NULL,
	batchupdateable bool NULL,
	creatable bool NULL,
	datapermissiontype varchar(40) NULL,
	deletable bool NULL,
	editownerable bool NULL,
	editable bool NULL,
	exportable bool NULL,
	filtertype varchar(40) NULL,
	functioncode varchar(40) NULL,
	importable bool NULL,
	nodetype varchar(40) NULL,
	permissiongroupid varchar(40) NULL,
	printable bool NULL,
	schemacode varchar(40) NULL,
	visible bool NULL,
	CONSTRAINT h_perm_biz_function_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_pbf_permissiongroupid ON h_perm_biz_function USING btree (permissiongroupid);
CREATE INDEX idx_pbf_schemacode ON h_perm_biz_function USING btree (schemacode);


-- h_perm_department_scope definition

-- Drop table

-- DROP TABLE h_perm_department_scope;

CREATE TABLE h_perm_department_scope (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	adminid varchar(40) NULL,
	"name" varchar(200) NULL,
	querycode varchar(255) NULL,
	unitid varchar(40) NULL,
	unittype varchar(10) NULL,
	CONSTRAINT h_perm_department_scope_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_pds_adminid ON h_perm_department_scope USING btree (adminid);


-- h_perm_function_condition definition

-- Drop table

-- DROP TABLE h_perm_function_condition;

CREATE TABLE h_perm_function_condition (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	functionid varchar(40) NULL,
	operatortype varchar(40) NULL,
	propertycode varchar(40) NULL,
	schemacode varchar(40) NULL,
	value text NULL,
	CONSTRAINT h_perm_function_condition_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_pfc__schemacode ON h_perm_function_condition USING btree (schemacode);
CREATE INDEX idx_pfc_functionid ON h_perm_function_condition USING btree (functionid);


-- h_perm_group definition

-- Drop table

-- DROP TABLE h_perm_group;

CREATE TABLE h_perm_group (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	appcode varchar(40) NULL,
	authortype varchar(40) NULL,
	departments text NULL,
	"name" varchar(50) NULL,
	roles text NULL,
	sortkey int4 NULL,
	CONSTRAINT h_perm_group_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_pg_appcode ON h_perm_group USING btree (appcode);


-- h_perm_license definition

-- Drop table

-- DROP TABLE h_perm_license;

CREATE TABLE h_perm_license (
	id varchar(120) NOT NULL,
	bizid varchar(42) NULL,
	biztype varchar(42) NULL,
	createdtime timestamp NULL,
	CONSTRAINT h_perm_license_pkey PRIMARY KEY (id)
);


-- h_perm_selection_scope definition

-- Drop table

-- DROP TABLE h_perm_selection_scope;

CREATE TABLE h_perm_selection_scope (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	departmentid varchar(255) NULL,
	deptvisiblescope text NULL,
	deptvisibletype varchar(255) NULL,
	staffvisiblescope text NULL,
	staffvisibletype varchar(255) NULL,
	CONSTRAINT h_perm_selection_scope_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_pss_departmentid ON h_perm_selection_scope USING btree (departmentid);


-- h_related_corp_setting definition

-- Drop table

-- DROP TABLE h_related_corp_setting;

CREATE TABLE h_related_corp_setting (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	agentid varchar(120) NULL,
	appsecret varchar(120) NULL,
	appkey varchar(120) NULL,
	corpid varchar(120) NULL,
	corpsecret varchar(120) NULL,
	customizerelatetype varchar(64) NULL,
	enabled bool NULL,
	exporthost varchar(32) NULL,
	extend1 varchar(120) NULL,
	extend2 varchar(120) NULL,
	extend3 varchar(120) NULL,
	extend4 varchar(120) NULL,
	extend5 varchar(120) NULL,
	headernum int4 NULL,
	maillistconfig varchar(2048) NULL,
	mobileserverurl varchar(128) NULL,
	"name" varchar(64) NULL,
	orgtype varchar(12) NULL,
	pcserverurl varchar(120) NULL,
	redirecturi varchar(128) NULL,
	relatedtype varchar(64) NULL,
	scanappid varchar(120) NULL,
	scanappsecret varchar(120) NULL,
	synredirecturi varchar(128) NULL,
	syncconfig varchar(2048) NULL,
	synctype varchar(12) NULL,
	CONSTRAINT h_related_corp_setting_pkey PRIMARY KEY (id)
);
CREATE UNIQUE INDEX uq_corpid ON h_related_corp_setting USING btree (corpid);


-- h_report_datasource_permission definition

-- Drop table

-- DROP TABLE h_report_datasource_permission;

CREATE TABLE h_report_datasource_permission (
	id varchar(120) NOT NULL,
	creater varchar(32) NULL,
	createdtime timestamp NULL,
	modifier varchar(32) NULL,
	modifiedtime timestamp NULL,
	nodetype int4 NULL,
	objectid varchar(64) NULL,
	ownerid varchar(32) NULL,
	parentobjectid varchar(64) NULL,
	remarks varchar(256) NULL,
	userscope text NULL,
	CONSTRAINT h_report_datasource_permission_pkey PRIMARY KEY (id)
);
CREATE UNIQUE INDEX uq_object_id ON h_report_datasource_permission USING btree (objectid);


-- h_report_page definition

-- Drop table

-- DROP TABLE h_report_page;

CREATE TABLE h_report_page (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	appcode varchar(40) NULL,
	code varchar(40) NULL,
	icon varchar(50) NULL,
	mobileable bool NULL,
	"name" varchar(50) NULL,
	name_i18n varchar(1000) NULL,
	pcable bool NULL,
	reportobjectid varchar(40) NULL,
	CONSTRAINT h_report_page_pkey PRIMARY KEY (id)
);


-- h_system_notify_setting definition

-- Drop table

-- DROP TABLE h_system_notify_setting;

CREATE TABLE h_system_notify_setting (
	id varchar(120) NOT NULL,
	corpid varchar(120) NULL,
	msgchanneltype varchar(20) NULL,
	unittype varchar(20) NULL,
	CONSTRAINT h_system_notify_setting_pkey PRIMARY KEY (id)
);


-- h_system_pair definition

-- Drop table

-- DROP TABLE h_system_pair;

CREATE TABLE h_system_pair (
	id varchar(120) NOT NULL,
	expiretime timestamp NULL,
	formcode varchar(40) NULL,
	objectid varchar(120) NULL,
	paramcode varchar(200) NULL,
	pairvalue text NULL,
	schemacode varchar(40) NULL,
	"type" varchar(40) NULL,
	uniquecode varchar(120) NULL,
	workflowinstanceid varchar(120) NULL,
	CONSTRAINT h_system_pair_pkey PRIMARY KEY (id)
);
CREATE UNIQUE INDEX h_system_pair_un ON h_system_pair USING btree (uniquecode);
CREATE INDEX idx_sp_bid_fcode ON h_system_pair USING btree (objectid, formcode);


-- h_system_sequence_no definition

-- Drop table

-- DROP TABLE h_system_sequence_no;

CREATE TABLE h_system_sequence_no (
	id varchar(120) NOT NULL,
	code varchar(40) NULL,
	filtercondition varchar(200) NULL,
	maxlength int4 NULL,
	resetdate timestamp NULL,
	resettype int4 NULL,
	schemacode varchar(120) NULL,
	serialno int4 NULL,
	CONSTRAINT h_system_sequence_no_pkey PRIMARY KEY (id)
);


-- h_system_setting definition

-- Drop table

-- DROP TABLE h_system_setting;

CREATE TABLE h_system_setting (
	id varchar(120) NOT NULL,
	checked bool NULL,
	fileuploadtype varchar(20) NULL,
	paramcode varchar(40) NULL,
	settingtype varchar(20) NULL,
	paramvalue varchar(4000) NULL,
	CONSTRAINT h_system_setting_pkey PRIMARY KEY (id),
	CONSTRAINT uk_1acm46hyhe6xq971mhf1xi5h0 UNIQUE (paramcode)
);


-- h_system_sms_template definition

-- Drop table

-- DROP TABLE h_system_sms_template;

CREATE TABLE h_system_sms_template (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	code varchar(20) NULL,
	"content" text NULL,
	"defaults" bool NULL,
	enabled bool NULL,
	"name" varchar(40) NULL,
	params text NULL,
	"type" varchar(20) NULL,
	CONSTRAINT h_system_sms_template_pkey PRIMARY KEY (id),
	CONSTRAINT uk_sst_code UNIQUE (code)
);


-- h_timer_job definition

-- Drop table

-- DROP TABLE h_timer_job;

CREATE TABLE h_timer_job (
	id varchar(120) NOT NULL,
	beanname varchar(100) NULL,
	createtime timestamp NULL,
	cronexpression varchar(80) NULL,
	jobname varchar(100) NULL,
	jobruntype varchar(20) NULL,
	methodname varchar(100) NULL,
	methodparams varchar(255) NULL,
	remark varchar(100) NULL,
	status int4 NULL,
	taskid varchar(120) NULL,
	triggertime timestamp NULL,
	updatetime timestamp NULL,
	"year" int4 NULL,
	CONSTRAINT h_timer_job_pkey PRIMARY KEY (id),
	CONSTRAINT idx_h_timer_job_taskid UNIQUE (taskid)
);


-- h_user_comment definition

-- Drop table

-- DROP TABLE h_user_comment;

CREATE TABLE h_user_comment (
	id varchar(120) NOT NULL,
	"content" varchar(600) NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	sortkey int4 NULL,
	userid varchar(36) NULL,
	CONSTRAINT h_user_comment_pkey PRIMARY KEY (id)
);


-- h_user_common_comment definition

-- Drop table

-- DROP TABLE h_user_common_comment;

CREATE TABLE h_user_common_comment (
	id varchar(120) NOT NULL,
	"content" varchar(4000) NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	sortkey int4 NULL,
	userid varchar(36) NULL,
	CONSTRAINT h_user_common_comment_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_ucc_userid ON h_user_common_comment USING btree (userid);


-- h_user_common_query definition

-- Drop table

-- DROP TABLE h_user_common_query;

CREATE TABLE h_user_common_query (
	id varchar(120) NOT NULL,
	conditiontype bool NOT NULL,
	createdtime timestamp NULL,
	filterfixed bool NOT NULL,
	modifiedtime timestamp NULL,
	"name" varchar(100) NULL,
	patientia bool NOT NULL,
	querycode varchar(40) NULL,
	querycondition text NULL,
	schemacode varchar(40) NULL,
	sort int4 NULL,
	"type" varchar(40) NULL,
	userid varchar(36) NULL,
	CONSTRAINT h_user_common_query_pkey PRIMARY KEY (id)
);
CREATE INDEX index_common_query_s_u ON h_user_common_query USING btree (schemacode, userid);


-- h_user_draft definition

-- Drop table

-- DROP TABLE h_user_draft;

CREATE TABLE h_user_draft (
	id varchar(120) NOT NULL,
	bizobjectkey varchar(100) NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	formtype varchar(100) NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	"name" varchar(200) NULL,
	remarks varchar(200) NULL,
	schemacode varchar(100) NULL,
	sheetcode varchar(100) NULL,
	userid varchar(100) NULL,
	workflowinstanceid varchar(100) NULL,
	CONSTRAINT h_user_draft_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_user_draft_objectkey ON h_user_draft USING btree (bizobjectkey);
CREATE INDEX idx_user_draft_userid ON h_user_draft USING btree (userid);


-- h_user_favorites definition

-- Drop table

-- DROP TABLE h_user_favorites;

CREATE TABLE h_user_favorites (
	id varchar(120) NOT NULL,
	appcode varchar(512) NULL,
	bizobjectkey varchar(255) NULL,
	bizobjecttype varchar(40) NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	userid varchar(36) NULL,
	CONSTRAINT h_user_favorites_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_user_favorites_userid ON h_user_favorites USING btree (userid);


-- h_user_guide definition

-- Drop table

-- DROP TABLE h_user_guide;

CREATE TABLE h_user_guide (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	display bool NULL,
	pagetype varchar(20) NOT NULL,
	userid varchar(40) NOT NULL,
	CONSTRAINT h_user_guide_pkey PRIMARY KEY (id)
);


-- h_workflow_admin definition

-- Drop table

-- DROP TABLE h_workflow_admin;

CREATE TABLE h_workflow_admin (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	admintype varchar(120) NULL,
	managescope varchar(512) NULL,
	"options" text NULL,
	workflowcode varchar(200) NULL,
	CONSTRAINT h_workflow_admin_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_work_admin_workflowcode ON h_workflow_admin USING btree (workflowcode);


-- h_workflow_admin_scope definition

-- Drop table

-- DROP TABLE h_workflow_admin_scope;

CREATE TABLE h_workflow_admin_scope (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	adminid varchar(120) NULL,
	unitid varchar(36) NULL,
	unittype varchar(10) NULL,
	CONSTRAINT h_workflow_admin_scope_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_workflow_adminid ON h_workflow_admin_scope USING btree (adminid);


-- h_workflow_header definition

-- Drop table

-- DROP TABLE h_workflow_header;

CREATE TABLE h_workflow_header (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	externallinkenable bool NULL,
	icon varchar(50) NULL,
	mobileoriginate bool NULL,
	name_i18n varchar(1000) NULL,
	pcoriginate bool NULL,
	published bool NULL,
	schemacode varchar(40) NULL,
	shortcode varchar(50) NULL,
	sortkey int4 NULL,
	visibletype varchar(40) NULL,
	workflowcode varchar(40) NULL,
	workflowname varchar(200) NULL,
	CONSTRAINT h_workflow_header_pkey PRIMARY KEY (id),
	CONSTRAINT uk_wh_workflowcode UNIQUE (workflowcode)
);
CREATE INDEX idx_wh_schemacode ON h_workflow_header USING btree (schemacode);


-- h_workflow_permission definition

-- Drop table

-- DROP TABLE h_workflow_permission;

CREATE TABLE h_workflow_permission (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	unitid varchar(36) NULL,
	unittype varchar(10) NULL,
	workflowcode varchar(40) NULL,
	CONSTRAINT h_workflow_permission_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_wp_workflowcode ON h_workflow_permission USING btree (workflowcode);


-- h_workflow_relative_event definition

-- Drop table

-- DROP TABLE h_workflow_relative_event;

CREATE TABLE h_workflow_relative_event (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	bizmethodcode varchar(40) NULL,
	schemacode varchar(40) NULL,
	workflowcode varchar(40) NULL,
	CONSTRAINT h_workflow_relative_event_pkey PRIMARY KEY (id)
);


-- h_workflow_relative_object definition

-- Drop table

-- DROP TABLE h_workflow_relative_object;

CREATE TABLE h_workflow_relative_object (
	id varchar(120) NOT NULL,
	relativecode varchar(40) NULL,
	relativetype varchar(40) NULL,
	workflowcode varchar(40) NULL,
	workflowversion int4 NULL,
	CONSTRAINT h_workflow_relative_object_pkey PRIMARY KEY (id)
);


-- h_workflow_template definition

-- Drop table

-- DROP TABLE h_workflow_template;

CREATE TABLE h_workflow_template (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	"content" text NULL,
	templatetype varchar(10) NULL,
	workflowcode varchar(40) NULL,
	workflowversion int4 NULL,
	CONSTRAINT h_workflow_template_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_workflow_template_code_verison ON h_workflow_template USING btree (workflowcode, workflowversion);


-- h_workflow_template_bak definition

-- Drop table

-- DROP TABLE h_workflow_template_bak;

CREATE TABLE h_workflow_template_bak (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	backuptime timestamp NULL,
	"content" text NULL,
	templatetype varchar(10) NULL,
	workflowcode varchar(40) NULL,
	workflowversion int4 NULL,
	CONSTRAINT h_workflow_template_bak_pkey PRIMARY KEY (id)
);


-- h_workflow_trust definition

-- Drop table

-- DROP TABLE h_workflow_trust;

CREATE TABLE h_workflow_trust (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	workflowcode varchar(40) NULL,
	workflowtrustruleid varchar(42) NULL,
	CONSTRAINT h_workflow_trust_pkey PRIMARY KEY (id)
);
CREATE UNIQUE INDEX idx_proxy_rule_wfcode ON h_workflow_trust USING btree (workflowtrustruleid, workflowcode);


-- h_workflow_trust_rule definition

-- Drop table

-- DROP TABLE h_workflow_trust_rule;

CREATE TABLE h_workflow_trust_rule (
	id varchar(120) NOT NULL,
	creater varchar(120) NULL,
	createdtime timestamp NULL,
	deleted bool NULL,
	modifier varchar(120) NULL,
	modifiedtime timestamp NULL,
	remarks varchar(200) NULL,
	endtime timestamp NULL,
	rangetype varchar(20) NULL,
	starttime timestamp NULL,
	state varchar(20) NULL,
	trusttype varchar(20) NULL,
	trustee varchar(42) NULL,
	trusteename varchar(80) NULL,
	trustor varchar(42) NULL,
	trustorname varchar(80) NULL,
	CONSTRAINT h_workflow_trust_rule_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_wf_trustee ON h_workflow_trust_rule USING btree (trustee);
CREATE INDEX idx_wf_trustor ON h_workflow_trust_rule USING btree (trustor);


-- qrtz_calendars definition

-- Drop table

-- DROP TABLE qrtz_calendars;

CREATE TABLE qrtz_calendars (
	sched_name varchar(120) NOT NULL,
	calendar_name varchar(200) NOT NULL,
	calendar bytea NOT NULL,
	CONSTRAINT qrtz_calendars_pkey PRIMARY KEY (sched_name, calendar_name)
);


-- qrtz_fired_triggers definition

-- Drop table

-- DROP TABLE qrtz_fired_triggers;

CREATE TABLE qrtz_fired_triggers (
	sched_name varchar(120) NOT NULL,
	entry_id varchar(95) NOT NULL,
	trigger_name varchar(200) NOT NULL,
	trigger_group varchar(200) NOT NULL,
	instance_name varchar(200) NOT NULL,
	fired_time int8 NOT NULL,
	sched_time int8 NOT NULL,
	priority int4 NOT NULL,
	state varchar(16) NOT NULL,
	job_name varchar(200) NULL,
	job_group varchar(200) NULL,
	is_nonconcurrent bool NULL,
	requests_recovery bool NULL,
	CONSTRAINT qrtz_fired_triggers_pkey PRIMARY KEY (sched_name, entry_id)
);
CREATE INDEX idx_qrtz_ft_inst_job_req_rcvry ON qrtz_fired_triggers USING btree (sched_name, instance_name, requests_recovery);
CREATE INDEX idx_qrtz_ft_j_g ON qrtz_fired_triggers USING btree (sched_name, job_name, job_group);
CREATE INDEX idx_qrtz_ft_jg ON qrtz_fired_triggers USING btree (sched_name, job_group);
CREATE INDEX idx_qrtz_ft_t_g ON qrtz_fired_triggers USING btree (sched_name, trigger_name, trigger_group);
CREATE INDEX idx_qrtz_ft_tg ON qrtz_fired_triggers USING btree (sched_name, trigger_group);
CREATE INDEX idx_qrtz_ft_trig_inst_name ON qrtz_fired_triggers USING btree (sched_name, instance_name);


-- qrtz_job_details definition

-- Drop table

-- DROP TABLE qrtz_job_details;

CREATE TABLE qrtz_job_details (
	sched_name varchar(120) NOT NULL,
	job_name varchar(200) NOT NULL,
	job_group varchar(200) NOT NULL,
	description varchar(250) NULL,
	job_class_name varchar(250) NOT NULL,
	is_durable bool NOT NULL,
	is_nonconcurrent bool NOT NULL,
	is_update_data bool NOT NULL,
	requests_recovery bool NOT NULL,
	job_data bytea NULL,
	CONSTRAINT qrtz_job_details_pkey PRIMARY KEY (sched_name, job_name, job_group)
);
CREATE INDEX idx_qrtz_j_grp ON qrtz_job_details USING btree (sched_name, job_group);
CREATE INDEX idx_qrtz_j_req_recovery ON qrtz_job_details USING btree (sched_name, requests_recovery);


-- qrtz_locks definition

-- Drop table

-- DROP TABLE qrtz_locks;

CREATE TABLE qrtz_locks (
	sched_name varchar(120) NOT NULL,
	lock_name varchar(40) NOT NULL,
	CONSTRAINT qrtz_locks_pkey PRIMARY KEY (sched_name, lock_name)
);


-- qrtz_paused_trigger_grps definition

-- Drop table

-- DROP TABLE qrtz_paused_trigger_grps;

CREATE TABLE qrtz_paused_trigger_grps (
	sched_name varchar(120) NOT NULL,
	trigger_group varchar(200) NOT NULL,
	CONSTRAINT qrtz_paused_trigger_grps_pkey PRIMARY KEY (sched_name, trigger_group)
);


-- qrtz_scheduler_state definition

-- Drop table

-- DROP TABLE qrtz_scheduler_state;

CREATE TABLE qrtz_scheduler_state (
	sched_name varchar(120) NOT NULL,
	instance_name varchar(200) NOT NULL,
	last_checkin_time int8 NOT NULL,
	checkin_interval int8 NOT NULL,
	CONSTRAINT qrtz_scheduler_state_pkey PRIMARY KEY (sched_name, instance_name)
);


-- qrtz_triggers definition

-- Drop table

-- DROP TABLE qrtz_triggers;

CREATE TABLE qrtz_triggers (
	sched_name varchar(120) NOT NULL,
	trigger_name varchar(200) NOT NULL,
	trigger_group varchar(200) NOT NULL,
	job_name varchar(200) NOT NULL,
	job_group varchar(200) NOT NULL,
	description varchar(250) NULL,
	next_fire_time int8 NULL,
	prev_fire_time int8 NULL,
	priority int4 NULL,
	trigger_state varchar(16) NOT NULL,
	trigger_type varchar(8) NOT NULL,
	start_time int8 NOT NULL,
	end_time int8 NULL,
	calendar_name varchar(200) NULL,
	misfire_instr int2 NULL,
	job_data bytea NULL,
	CONSTRAINT qrtz_triggers_pkey PRIMARY KEY (sched_name, trigger_name, trigger_group),
	CONSTRAINT qrtz_triggers_sched_name_job_name_job_group_fkey FOREIGN KEY (sched_name,job_name,job_group) REFERENCES qrtz_job_details(sched_name,job_name,job_group)
);
CREATE INDEX idx_qrtz_t_c ON qrtz_triggers USING btree (sched_name, calendar_name);
CREATE INDEX idx_qrtz_t_g ON qrtz_triggers USING btree (sched_name, trigger_group);
CREATE INDEX idx_qrtz_t_j ON qrtz_triggers USING btree (sched_name, job_name, job_group);
CREATE INDEX idx_qrtz_t_jg ON qrtz_triggers USING btree (sched_name, job_group);
CREATE INDEX idx_qrtz_t_n_g_state ON qrtz_triggers USING btree (sched_name, trigger_group, trigger_state);
CREATE INDEX idx_qrtz_t_n_state ON qrtz_triggers USING btree (sched_name, trigger_name, trigger_group, trigger_state);
CREATE INDEX idx_qrtz_t_next_fire_time ON qrtz_triggers USING btree (sched_name, next_fire_time);
CREATE INDEX idx_qrtz_t_nft_misfire ON qrtz_triggers USING btree (sched_name, misfire_instr, next_fire_time);
CREATE INDEX idx_qrtz_t_nft_st ON qrtz_triggers USING btree (sched_name, trigger_state, next_fire_time);
CREATE INDEX idx_qrtz_t_nft_st_misfire ON qrtz_triggers USING btree (sched_name, misfire_instr, next_fire_time, trigger_state);
CREATE INDEX idx_qrtz_t_nft_st_misfire_grp ON qrtz_triggers USING btree (sched_name, misfire_instr, next_fire_time, trigger_group, trigger_state);
CREATE INDEX idx_qrtz_t_state ON qrtz_triggers USING btree (sched_name, trigger_state);


-- qrtz_blob_triggers definition

-- Drop table

-- DROP TABLE qrtz_blob_triggers;

CREATE TABLE qrtz_blob_triggers (
	sched_name varchar(120) NOT NULL,
	trigger_name varchar(200) NOT NULL,
	trigger_group varchar(200) NOT NULL,
	blob_data bytea NULL,
	CONSTRAINT qrtz_blob_triggers_pkey PRIMARY KEY (sched_name, trigger_name, trigger_group),
	CONSTRAINT qrtz_blob_triggers_sched_name_trigger_name_trigger_group_fkey FOREIGN KEY (sched_name,trigger_name,trigger_group) REFERENCES qrtz_triggers(sched_name,trigger_name,trigger_group)
);


-- qrtz_cron_triggers definition

-- Drop table

-- DROP TABLE qrtz_cron_triggers;

CREATE TABLE qrtz_cron_triggers (
	sched_name varchar(120) NOT NULL,
	trigger_name varchar(200) NOT NULL,
	trigger_group varchar(200) NOT NULL,
	cron_expression varchar(120) NOT NULL,
	time_zone_id varchar(80) NULL,
	CONSTRAINT qrtz_cron_triggers_pkey PRIMARY KEY (sched_name, trigger_name, trigger_group),
	CONSTRAINT qrtz_cron_triggers_sched_name_trigger_name_trigger_group_fkey FOREIGN KEY (sched_name,trigger_name,trigger_group) REFERENCES qrtz_triggers(sched_name,trigger_name,trigger_group)
);


-- qrtz_simple_triggers definition

-- Drop table

-- DROP TABLE qrtz_simple_triggers;

CREATE TABLE qrtz_simple_triggers (
	sched_name varchar(120) NOT NULL,
	trigger_name varchar(200) NOT NULL,
	trigger_group varchar(200) NOT NULL,
	repeat_count int8 NOT NULL,
	repeat_interval int8 NOT NULL,
	times_triggered int8 NOT NULL,
	CONSTRAINT qrtz_simple_triggers_pkey PRIMARY KEY (sched_name, trigger_name, trigger_group),
	CONSTRAINT qrtz_simple_triggers_sched_name_trigger_name_trigger_group_fkey FOREIGN KEY (sched_name,trigger_name,trigger_group) REFERENCES qrtz_triggers(sched_name,trigger_name,trigger_group)
);


-- qrtz_simprop_triggers definition

-- Drop table

-- DROP TABLE qrtz_simprop_triggers;

CREATE TABLE qrtz_simprop_triggers (
	sched_name varchar(120) NOT NULL,
	trigger_name varchar(200) NOT NULL,
	trigger_group varchar(200) NOT NULL,
	str_prop_1 varchar(512) NULL,
	str_prop_2 varchar(512) NULL,
	str_prop_3 varchar(512) NULL,
	int_prop_1 int4 NULL,
	int_prop_2 int4 NULL,
	long_prop_1 int8 NULL,
	long_prop_2 int8 NULL,
	dec_prop_1 numeric(13, 4) NULL,
	dec_prop_2 numeric(13, 4) NULL,
	bool_prop_1 bool NULL,
	bool_prop_2 bool NULL,
	CONSTRAINT qrtz_simprop_triggers_pkey PRIMARY KEY (sched_name, trigger_name, trigger_group),
	CONSTRAINT qrtz_simprop_triggers_sched_name_trigger_name_trigger_grou_fkey FOREIGN KEY (sched_name,trigger_name,trigger_group) REFERENCES qrtz_triggers(sched_name,trigger_name,trigger_group)
);

INSERT INTO base_security_client VALUES ('52ed17238a5da59e71a8aa26447d0c05', NULL, NULL, 'f', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3600.00000000000000000000000000000000000000000000000000000, 'API', 'openapi', 'client_credentials', 'read,write', 'xclient', '{noop}0a417ecce58c31b32364ce19ca8fcd15', 3600.00000000000000000000000000000000000000000000000000000, '', 'api', 'read,write', 'APP');
INSERT INTO base_security_client VALUES ('8a5da52ed126447d359e70c05721a8aa', NULL, NULL, 'f', NULL, NULL, NULL, 0.00000000000000000000000000000000000000000000000000000, 0.00000000000000000000000000000000000000000000000000000, NULL, NULL, NULL, 28800.00000000000000000000000000000000000000000000000000000, 'API', 'api', 'authorization_code,implicit,password,refresh_token', 'read,write', 'api', '{noop}c31b32364ce19ca8fcd150a417ecce58', 28800.00000000000000000000000000000000000000000000000000000, 'http://127.0.0.1/admin,http://127.0.0.1/admin#/oauth,http://127.0.0.1/oauth', 'api', 'read,write', 'APP');


INSERT INTO h_app_group VALUES ('2c928fe6785dbfbb01785dc6277a0000', '2c9280a26706a73a016706a93ccf002b', '2021-03-23 14:29:31', 'f', NULL, '2021-03-23 14:29:31', NULL, 'default', '默认', NULL, 1);
INSERT INTO h_app_group VALUES ('2c928fe6785dbfbb01785dc6277a0001', '2c9280a26706a73a016706a93ccf002b', '2021-04-26 17:50:31', 'f', NULL, '2021-04-26 17:50:31', NULL, 'all', '全部', NULL, 0);

INSERT INTO h_org_department
(id, createdTime, creater, deleted, extend1, extend2, extend3, extend4, extend5, modifiedTime, modifier, remarks, calendarId, employees, leaf, managerId, name, parentId, sortKey, sourceId, queryCode, dingDeptManagerId, isShow, deptType, corpId, enabled)
VALUES('06ef8c9a3f3b6669a34036a3001e6340', '2019-03-22 11:25:05', NULL, 'f', '', '', NULL, NULL, NULL, '2019-05-14 13:44:21', NULL, NULL, NULL, NULL, 'f', '', '外部', '06ef8c9a3f3b6669a34036a3001e63401', 0, NULL, '', NULL, 't', 'DEPT', NULL, 't');
INSERT INTO h_org_department
(id, createdTime, creater, deleted, extend1, extend2, extend3, extend4, extend5, modifiedTime, modifier, remarks, calendarId, employees, leaf, managerId, name, parentId, sortKey, sourceId, queryCode, dingDeptManagerId, isShow, deptType, corpId, enabled)
VALUES('1803c80ed28a3e25871d58808019816e', '2019-03-22 11:25:05', NULL, 'f', '', '', NULL, NULL, NULL, '2019-05-14 13:44:21', NULL, NULL, NULL, NULL, 'f', '', '管理部门', 'fc57a56529ef4e089b5b23162f063ca9', 0, NULL, '', NULL, 't', 'DEPT', NULL, 't');

INSERT INTO h_org_dept_user
(id, createdTime, creater, deleted, modifiedTime, modifier, remarks, deptId, main, userId, sortKey, leader, userSourceId, deptSourceId)
VALUES('07df8b34e4469a00169a36a336450cf3', '2019-03-22 11:25:07', NULL, 'f', '2019-03-22 11:25:07', NULL, NULL, '06ef8c9a3f3b6669a34036a3001e6340', NULL, '2ccf3b346706a6d3016706dc51c0022b', NULL, NULL, NULL, NULL);
INSERT INTO h_org_dept_user
(id, createdTime, creater, deleted, modifiedTime, modifier, remarks, deptId, main, userId, sortKey, leader, userSourceId, deptSourceId)
VALUES('a92a7856f16132c6a1884b08c3233236', '2019-03-22 11:25:07', NULL, 'f', '2019-03-22 11:25:07', NULL, NULL, '1803c80ed28a3e25871d58808019816e', NULL, '2c9280a26706a73a016706a93ccf002b', NULL, NULL, NULL, NULL);

INSERT INTO h_org_user
(id, createdTime, creater, deleted, extend1, extend2, extend3, extend4, extend5, modifiedTime, modifier, remarks, active, admin, appellation, birthday, boss, departmentId, departureDate, dingtalkId, email, employeeNo, employeeRank, entryDate, gender, identityNo, imgUrl, leader, managerId, mobile, name, officePhone, password, username, privacyLevel, secretaryId, sortKey, sourceId, status, userId, pinYin, shortPinYin, imgUrlId, dingUserJson, corpId, position, enabled, userWorkStatus)
VALUES('2c9280a26706a73a016706a93ccf002b', NULL, NULL, 'f', NULL, NULL, NULL, NULL, NULL, '2021-09-01 16:16:11', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1803c80ed28a3e25871d58808019816e', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'admin', NULL, '{bcrypt}$2a$10$NvgvcocBqMn050z4nC0I6OeAhO5ERjM74pvMtSGLghPhWI5ed5myG', 'admin', NULL, NULL, NULL, NULL, NULL, 'admin', 'admin', 'admin', NULL, NULL, 'main', NULL, 't', 'NORMAL');
INSERT INTO h_org_user
(id, createdTime, creater, deleted, extend1, extend2, extend3, extend4, extend5, modifiedTime, modifier, remarks, active, admin, appellation, birthday, boss, departmentId, departureDate, dingtalkId, email, employeeNo, employeeRank, entryDate, gender, identityNo, imgUrl, leader, managerId, mobile, name, officePhone, password, username, privacyLevel, secretaryId, sortKey, sourceId, status, userId, pinYin, shortPinYin, imgUrlId, dingUserJson, corpId, position, enabled, userWorkStatus)
VALUES('2ccf3b346706a6d3016706dc51c0022b', '2019-06-05 19:30:30', NULL, 'f', NULL, NULL, NULL, NULL, NULL, '2019-06-05 19:30:30', NULL, NULL, 't', 't', NULL, NULL, 'f', '06ef8c9a3f3b6669a34036a3001e6340', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'f', NULL, NULL, '外部用户', NULL, '{bcrypt}$2a$10$NvgvcocBqMn050z4nC0I6OeAhO5ERjM74pvMtSGLghPhWI5ed5myG', 'xuser', NULL, NULL, NULL, NULL, NULL, 'xuser', NULL, NULL, NULL, NULL, 'main', NULL, 't', 'NORMAL');

INSERT INTO h_perm_admin
(id, creater, createdTime, deleted, modifier, modifiedTime, remarks, adminType, dataManage, dataQuery, userId, parentId, appManage, dataDictionaryManage, roleManage)
VALUES('2c928a4c6c043e48016c04c108300a90', '2c928e4c6a4d1d87016a4d1f2f760048', '2019-09-06 10:23:15', 'f', NULL, '2019-09-06 10:23:15', NULL, 'ADMIN', 't', 't', '2c9280a26706a73a016706a93ccf002b', NULL, NULL, 'f', 't');

INSERT INTO h_system_setting
(id, paramCode, paramValue, settingType, checked, fileUploadType)
VALUES('2c928e636f3fe9b5016f3feb81c70000', 'dingtalk.isSynEdu', 'false', 'DINGTALK_BASE', 'f', NULL);
INSERT INTO h_system_setting
(id, paramCode, paramValue, settingType, checked, fileUploadType)
VALUES('c82a2b8d5d5c11ecb2370242ac110005', 'sms.todo.switch', 'false', 'SMS_CONF', 't', NULL);
INSERT INTO h_system_setting
(id, paramCode, paramValue, settingType, checked, fileUploadType)
VALUES('c82d39a85d5c11ecb2370242ac110006', 'sms.urge.switch', 'false', 'SMS_CONF', 't', NULL);

ALTER TABLE h_biz_query ADD COLUMN options text DEFAULT NULL;

commit;