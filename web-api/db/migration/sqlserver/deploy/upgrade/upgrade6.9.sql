CREATE TABLE h_workflow_admin (
	id nvarchar(120) NOT NULL PRIMARY KEY,
	creater nvarchar(120),
	createdTime datetime,
	deleted bit,
	modifier nvarchar(120),
	modifiedTime datetime,
	remarks nvarchar(200),
	adminType nvarchar(120),
	workflowCode nvarchar(200),
	manageScope nvarchar(512),
	options ntext
)
GO
CREATE TABLE h_workflow_admin_scope (
	id nvarchar(120) NOT NULL PRIMARY KEY,
	creater nvarchar(120),
	createdTime datetime,
	deleted bit,
	modifier nvarchar(120),
	modifiedTime datetime,
	remarks nvarchar(200),
	adminId nvarchar(120),
	unitType nvarchar(10),
	unitId nvarchar(36)
)
GO
ALTER TABLE biz_workitem ADD workItemSource nvarchar(120);
GO

ALTER TABLE biz_workitem_finished ADD workItemSource nvarchar(120);
GO
CREATE TABLE h_system_sms_template (
    id nvarchar(120) NOT NULL primary key,
    type nvarchar(20) NOT NULL,
    code nvarchar(20) NOT NULL,
    name nvarchar(40) NOT NULL,
    content ntext NOT NULL,
    params ntext DEFAULT NULL,
    enabled bit DEFAULT NULL,
    defaults bit DEFAULT NULL,
    remarks nvarchar(200) DEFAULT NULL,
    deleted bit DEFAULT NULL,
    creater nvarchar(120) DEFAULT NULL,
    createdTime datetime DEFAULT NULL,
    modifier nvarchar(120) DEFAULT NULL,
    modifiedTime datetime DEFAULT NULL
)
go

INSERT INTO h_system_sms_template VALUES ('2c928ff67de11137017de119dec601c2', 'TODO', 'Todo', '默认待办通知', '您有新的流程待处理，流程标题：${name}，请及时处理！', '[{\"key\":\"name\",\"value\":\"\"}]', '1', '1', NULL, '0', NULL, NULL, NULL, NULL);
INSERT INTO h_system_sms_template VALUES ('2c928ff67de11137017de11d5b3001c4', 'URGE', 'Remind', '默认催办通知', '您的流程任务被人催办，流程标题：${name}，催办人${creater}，请及时处理！', '[{\"key\":\"name\",\"value\":\"流程的标题\"},{\"key\":\"creater\",\"value\":\"流程发起人\"}]', '1', '1', NULL, '0', NULL, NULL, NULL, NULL);
INSERT INTO h_system_setting VALUES ('c82a2b8d5d5c11ecb2370242ac110005', 'sms.todo.switch', 'false', 'SMS_CONF', '1', null);
INSERT INTO h_system_setting VALUES ('c82d39a85d5c11ecb2370242ac110006', 'sms.urge.switch', 'false', 'SMS_CONF', '1', null);
ALTER TABLE h_biz_export_task ADD fileSize int NULL;

ALTER TABLE H_BIZ_SCHEMA add MODELTYPE nvarchar(40);
GO
ALTER TABLE h_im_message ADD smsParams ntext null;
ALTER TABLE h_im_message ADD smsCode nvarchar(50) null;

ALTER TABLE h_im_message_history ADD smsParams ntext null;
ALTER TABLE h_im_message_history ADD smsCode nvarchar(50) null;

ALTER TABLE h_system_pair add objectId nvarchar(120);
GO
ALTER TABLE h_system_pair add schemaCode nvarchar(40);
GO
ALTER TABLE h_system_pair add formCode nvarchar(40);
GO
ALTER TABLE h_system_pair add workflowInstanceId nvarchar(120);
GO
create index idx_bid_fcode on h_system_pair (objectId, formCode)
go