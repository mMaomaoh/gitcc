create unique index uq_ap_code on H_APP_GROUP (CODE);

drop index IDX_TYPE_AC;
create index idx_af_a_t on H_APP_FUNCTION (APPCODE, TYPE);
create index idx_af_parentId on H_APP_FUNCTION (PARENTID);

drop index IDX_BIZSCHEMA_SCHEMACODE;
create unique index uq_bs_code on H_BIZ_SCHEMA (CODE);

create index uq_bs_s_c on H_BIZ_SHEET (SCHEMACODE, CODE);

drop index IDX_BIZPROPERTY_SCHEMACODE;

create index idx_bdr_s_p on H_BIZ_DATA_RULE (SCHEMACODE, PROPERTYCODE);

create index idx_br_s_c on H_BUSINESS_RULE (SCHEMACODE, CODE);

create unique index uq_bq_s_c on H_BIZ_QUERY (SCHEMACODE, CODE);

create index idx_bqa_q_a on H_BIZ_QUERY_ACTION (QUERYID, ACTIONCODE);

create index idx_bqs_queryId on H_BIZ_QUERY_SORTER (QUERYID);

create unique index uq_bqp_q_c on h_biz_query_present (queryId, clientType);

create index idx_bdt_bizObjectId on h_biz_data_track (bizObjectId);

create index idx_bdtd_trackId on h_biz_data_track_detail (trackId);

create index idx_wh_schemaCode on h_workflow_header (schemaCode);

create index idx_wp_workflowCode on h_workflow_permission (workflowCode);

create index idx_bw_workflowCode on biz_workitem (workflowCode);

create index idx_bwf_workflowCode on biz_workitem_finished (workflowCode);

create unique index uq_bdp_code on h_biz_database_pool (code);

create unique index uq_biz_service_code on h_biz_service (code);

create unique index uq_bsm_s_c on h_biz_service_method (serviceCode, code);

create index idx_bmm_schemaCode on h_biz_method_mapping (schemaCode);
create index idx_bmm_s_m on h_biz_method_mapping (serviceCode, methodCode);

create unique index uq_dd_code on h_data_dictionary (code);

create index idx_dr_dictionaryId on h_dictionary_record (dictionaryId);

create unique index uq_rcs_corpId on h_related_corp_setting (corpId);

drop index UQ_DEPARTMENT_CORPID_SOURCEID;
create index idx_od_queryCode on h_org_department (queryCode);
create index idx_od_s_c on h_org_department (sourceId,corpId);

drop index IDX_H_ORG_ROLE_NAME;
create index idx_or_groupId on h_org_role (groupId);

ALTER TABLE h_org_role_group DROP CONSTRAINT UK_H_ORG_ROLE_GROUP_SOURCEID;
create unique index uq_org_c_s on h_org_role_group (sourceId,corpId);

ALTER TABLE h_org_role_user DROP CONSTRAINT IDX_ROLE_USER_COMPOSEID;
drop index IDX_ROLE_USER_SOURCEID;
create index idx_oru_roleId on h_org_role_user (roleId);

drop index IDX_CORPID;
ALTER TABLE h_org_user_extend_attr DROP CONSTRAINT UK_CODE_CORPID;
create unique index uq_orea_c_c on h_org_user_extend_attr (corpId, code);

create index idx_outr_sourceUserId on h_org_user_transfer_record (sourceUserId);

create unique index uq_pss_departmentId on h_perm_selection_scope (departmentId);

create index idx_ucc_userId on h_user_common_comment (userId);

create index idx_pg_appCode on h_perm_group (appCode);

create index idx_bpg_appPermGroupId on h_biz_perm_group (appPermGroupId);
create index idx_bpg_schemaCode on h_biz_perm_group (schemaCode);

create index idx_bpp_groupId on h_biz_perm_property (groupId);

create index idx_pbf_permissionGroupId on h_perm_biz_function (permissionGroupId);
create index idx_pbf_schemaCode on h_perm_biz_function (schemaCode);

create index idx_pfc_functionId on h_perm_function_condition (functionId);
create index idx_pfc_schemaCode on h_perm_function_condition (schemaCode);

create unique index uq_pa_u_a on h_perm_admin (userId, adminType);

create index idx_pag_adminId on h_perm_admin_group (adminId);

create index idx_pas_adminId on h_perm_apppackage_scope (adminId);

create index idx_pds_adminId on h_perm_department_scope (adminId);