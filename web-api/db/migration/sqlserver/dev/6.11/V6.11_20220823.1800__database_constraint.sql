create unique index uk_code on h_app_package (code)
go

create unique index uk_code on h_app_group (code)
go

drop index idx_type_ac on h_app_function
go
create index idx_a_t on h_app_function (appCode, type)
go
create index idx_parentId on h_app_function (parentId)
go

create index idx_s_c on h_biz_sheet (schemaCode, code)
go

drop index Idx_schemaCode on h_biz_property
go
create unique index uq_s_c on h_biz_property (schemaCode, code)
go

create index idx_bdr_s_p on h_biz_data_rule (schemaCode, propertyCode)
go

create unique index uq_bdr_s_c on h_business_rule (schemaCode, code)
go

create unique index uq_bq_s_c on h_biz_query (schemaCode, code)
go

create index idx_bqa_q_a on h_biz_query_action (queryId, actionCode)
go

create index idx_bqs_queryId on h_biz_query_sorter (queryId)
go

create unique index uq_bqp_q_c on h_biz_query_present (queryId,clientType)
go

create index idx_bdt_bizObjectId on h_biz_data_track (bizObjectId)
go

create index idx_bdtd_trackId on h_biz_data_track_detail (trackId)
go

create index idx_wh_schemaCode on h_workflow_header (workflowCode)
go

create index idx_wp_workflowCode on h_workflow_permission (workflowCode)
go

create index idx_wa_workflowCode on h_workflow_admin (workflowCode)
go

create index idx_was_adminId on h_workflow_admin_scope (adminId)
go

create unique index uq_bdp_code on h_biz_database_pool (code)
go

create unique index uq_bs_code on h_biz_service (code)
go

create unique index uq_bsm_s_m on h_biz_service_method (serviceCode,code)
go

create index idx_bmm_schemaCode on h_biz_method_mapping (schemaCode)
go
create index idx_bmm_s_m on h_biz_method_mapping (serviceCode,methodCode)
go

create unique index uq_dd_code on h_data_dictionary (code)
go

create index idx_dr_dictionaryId on h_dictionary_record (dictionaryId)
go

create unique index uq_rcs_corpId on h_related_corp_setting (corpId)
go

drop index uq_corpId_sourceId on h_org_department
go
create index idx_od_queryCode on h_org_department(queryCode)
go

drop index UK_rj7duahtop7qmf2ka0kxs57i0 on h_org_user
go

drop index idx_role_group_id on h_org_role_group
go
drop index idx_role_group_code on h_org_role_group
go

drop index idx_role_id on h_org_role
go
drop index idx_rolde_code on h_org_role
go
drop index idx_rolde_name on h_org_role
go
create index idx_or_groupId on h_org_role(groupId)
go

drop index idx_role_user_id on h_org_role_user
go
drop index idx_role_user_sourceid on h_org_role_user
go
alter table h_org_role_user drop constraint idx_role_user_composeid
go
create index idx_oru_roleId on h_org_role_user(roleId)
go
create index idx_oru_userId on h_org_role_user(userId)
go

drop index IDX_corpId on h_org_user_extend_attr
go
alter table h_org_user_extend_attr drop constraint UK_code_corpId
go
create unique index idx_ouea_c_c on h_org_user_extend_attr(corpId,code)
go

create unique index uq_pss_departmentId on h_perm_selection_scope(departmentId)
go

create index idx_ucc_userId on h_user_common_comment(userId)
go

create unique index idx_pap_appCode on h_perm_app_package(appCode)
go

create index idx_pg_appCode on h_perm_group(appCode)
go

create index idx_bpg_appPermGroupId on h_biz_perm_group(appPermGroupId)
go
create index idx_bpg_schemaCode on h_biz_perm_group(schemaCode)
go

create index idx_bpp_groupId on h_biz_perm_property(groupId)
go

create index idx_pbf_permissionGroupId on h_perm_biz_function(permissionGroupId)
go
create index idx_pbf_schemaCode on h_perm_biz_function(schemaCode)
go

create index idx_pfc_functionId on h_perm_function_condition(functionId)
go
create index idx_pfc_schemaCode on h_perm_function_condition(schemaCode)
go

create unique index uq_pa_u_a on h_perm_admin(userId,adminType)
go

create index idx_pag_adminId on h_perm_admin_group(adminId)
go

create index idx_pas_adminId on h_perm_apppackage_scope(adminId)
go

create index idx_pds_adminId on h_perm_department_scope(adminId)
go