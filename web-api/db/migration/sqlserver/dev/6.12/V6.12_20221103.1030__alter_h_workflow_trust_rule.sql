ALTER TABLE h_workflow_trust_rule add deptRangeType nvarchar(20);
GO

ALTER TABLE h_workflow_trust_rule add originatorDepartments ntext;
GO

update h_workflow_trust_rule set deptRangeType='ALL' where trustType='APPROVAL';