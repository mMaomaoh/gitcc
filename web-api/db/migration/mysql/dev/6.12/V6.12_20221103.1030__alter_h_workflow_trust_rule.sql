ALTER TABLE `h_workflow_trust_rule` ADD COLUMN `deptRangeType` varchar(20) DEFAULT NULL COMMENT '发起人部门范围类型，全部：ALL；部分：PART';

ALTER TABLE `h_workflow_trust_rule` ADD COLUMN `originatorDepartments` longtext DEFAULT NULL COMMENT '发起人部门id，逗号分隔';

update h_workflow_trust_rule set deptRangeType='ALL' where trustType='APPROVAL';