ALTER TABLE biz_workflow_instance ADD COLUMN workflowName varchar(255) NULL COMMENT '流程模板名称';

ALTER TABLE biz_workflow_instance_bak ADD COLUMN workflowName varchar(255) NULL COMMENT '流程模板名称';