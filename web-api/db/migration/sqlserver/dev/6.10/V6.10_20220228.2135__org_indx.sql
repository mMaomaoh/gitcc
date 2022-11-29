create unique index uq_corpId_sourceId on h_org_department (corpId, sourceId)
go
create unique index uq_corpId_sourceId on h_org_role (corpId, sourceId)
go
create unique index uq_role_code on h_org_role (code)
go
create unique index uq_role_group_code on h_org_role_group (code)
go
create index idx_corpId_userId on h_org_user (userId,corpId)
go
create index idx_dept_id on h_org_dept_user (deptId)
go
