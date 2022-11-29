create unique index uq_corpId_sourceId on h_org_role (corpId, sourceId);
drop index idx_h_org_role_code;
create unique index uq_role_code on h_org_role (code);
create index idx_corpId_userId on h_org_user (userId,corpId);
create index idx_dept_id on h_org_dept_user (deptId);
