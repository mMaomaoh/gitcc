ALTER TABLE d_process_task MODIFY COLUMN taskId varchar(50) NOT NULL COMMENT '钉钉待办id' AFTER `processInstanceId`;
ALTER TABLE d_process_task MODIFY COLUMN processInstanceId varchar(64) NULL AFTER `id`;