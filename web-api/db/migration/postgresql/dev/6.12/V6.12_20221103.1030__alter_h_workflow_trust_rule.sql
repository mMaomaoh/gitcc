ALTER TABLE h_workflow_trust_rule ADD COLUMN deptRangeType varchar(20) DEFAULT NULL;

ALTER TABLE h_workflow_trust_rule ADD COLUMN originatorDepartments text DEFAULT NULL;

update h_workflow_trust_rule set deptRangeType='ALL' where trustType='APPROVAL';