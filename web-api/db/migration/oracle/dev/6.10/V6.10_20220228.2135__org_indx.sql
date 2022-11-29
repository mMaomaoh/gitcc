create unique index uq_department_corpId_sourceId on h_org_department (corpId, sourceId);
create unique index uq_user_corpId_sourceId on h_org_role (corpId, sourceId);
drop index idx_h_org_role_code;
create unique index uq_role_code on h_org_role (code);
create index idx_corpId_userId on h_org_user (userId,corpId);
