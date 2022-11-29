alter table BIZ_WORKFLOW_INSTANCE add workflowName varchar2(255);

comment on column BIZ_WORKFLOW_INSTANCE.workflowName is '流程模板名称';

alter table BIZ_WORKFLOW_INSTANCE_BAK add workflowName varchar2(255);

comment on column BIZ_WORKFLOW_INSTANCE_BAK.workflowName is '流程模板名称';