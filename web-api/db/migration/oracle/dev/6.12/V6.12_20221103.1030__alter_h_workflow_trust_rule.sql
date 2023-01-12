ALTER TABLE h_workflow_trust_rule ADD deptRangeType varchar2(20);
comment on column h_workflow_trust_rule.deptRangeType is '发起人部门范围类型，全部：ALL；部分：PART' ;

ALTER TABLE h_workflow_trust_rule add originatorDepartments clob;
comment on column h_workflow_trust_rule.originatorDepartments is '发起人部门id，逗号分隔';

update h_workflow_trust_rule set deptRangeType='ALL' where trustType='APPROVAL';