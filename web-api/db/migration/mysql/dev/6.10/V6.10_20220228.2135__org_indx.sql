create unique index uq_corpId_sourceId on h_org_department (corpId, sourceId);

create unique index uq_corpId_sourceId on h_org_role (corpId, sourceId);

drop index idx_rolde_code on h_org_role;
create unique index uq_role_code on h_org_role (code);

drop index idx_role_group_code on h_org_role_group;
drop index idx_role_group_id on h_org_role_group;
create unique index uq_role_group_code on h_org_role_group (code);

create index idx_corpId_userId on h_org_user (userId,corpId);

create index idx_dept_id on h_org_dept_user (deptId);