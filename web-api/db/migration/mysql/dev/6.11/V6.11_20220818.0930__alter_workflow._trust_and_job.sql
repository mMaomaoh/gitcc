ALTER TABLE h_workflow_trust_rule CHANGE createTime createdTime datetime NULL;
ALTER TABLE h_workflow_trust_rule ADD remarks varchar(200) NULL COMMENT '备注';
ALTER TABLE h_workflow_trust_rule ADD deleted bit(1) NULL COMMENT '删除标识';

ALTER TABLE h_workflow_trust CHANGE createTime createdTime datetime NULL;
ALTER TABLE h_workflow_trust ADD modifier varchar(120) NULL COMMENT '修改人';
ALTER TABLE h_workflow_trust ADD modifiedTime DATETIME NULL COMMENT '修改时间';
ALTER TABLE h_workflow_trust ADD remarks varchar(200) NULL COMMENT '备注';
ALTER TABLE h_workflow_trust ADD deleted bit(1) NULL COMMENT '删除标识';

ALTER TABLE h_timer_job ADD triggerTime datetime NULL COMMENT '触发时间';
ALTER TABLE h_job_result ADD triggerTime datetime NULL COMMENT '触发时间';