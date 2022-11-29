--
-- A hint submitted by a user: Oracle DB MUST be created as "shared" and the
-- job_queue_processes parameter  must be greater than 2
-- However, these settings are pretty much standard after any
-- Oracle install, so most users need not worry about this.
--
-- Many other users (including the primary author of Quartz) have had success
-- runing in dedicated mode, so only consider the above as a hint ;-)
--
-- quartz定时任务脚本
--delete from qrtz_fired_triggers;
--delete from qrtz_simple_triggers;
--delete from qrtz_simprop_triggers;
--delete from qrtz_cron_triggers;
--delete from qrtz_blob_triggers;
--delete from qrtz_triggers;
--delete from qrtz_job_details;
--delete from qrtz_calendars;
--delete from qrtz_paused_trigger_grps;
--delete from qrtz_locks;
--delete from qrtz_scheduler_state;

--drop table qrtz_calendars;
--drop table qrtz_fired_triggers;
--drop table qrtz_blob_triggers;
--drop table qrtz_cron_triggers;
--drop table qrtz_simple_triggers;
--drop table qrtz_simprop_triggers;
--drop table qrtz_triggers;
--drop table qrtz_job_details;
--drop table qrtz_paused_trigger_grps;
--drop table qrtz_locks;
--drop table qrtz_scheduler_state;


CREATE TABLE qrtz_job_details
(
    SCHED_NAME VARCHAR2(120) NOT NULL,
    JOB_NAME  VARCHAR2(200) NOT NULL,
    JOB_GROUP VARCHAR2(200) NOT NULL,
    DESCRIPTION VARCHAR2(250) NULL,
    JOB_CLASS_NAME   VARCHAR2(250) NOT NULL,
    IS_DURABLE VARCHAR2(1) NOT NULL,
    IS_NONCONCURRENT VARCHAR2(1) NOT NULL,
    IS_UPDATE_DATA VARCHAR2(1) NOT NULL,
    REQUESTS_RECOVERY VARCHAR2(1) NOT NULL,
    JOB_DATA BLOB NULL,
    CONSTRAINT QRTZ_JOB_DETAILS_PK PRIMARY KEY (SCHED_NAME,JOB_NAME,JOB_GROUP)
);
CREATE TABLE qrtz_triggers
(
    SCHED_NAME VARCHAR2(120) NOT NULL,
    TRIGGER_NAME VARCHAR2(200) NOT NULL,
    TRIGGER_GROUP VARCHAR2(200) NOT NULL,
    JOB_NAME  VARCHAR2(200) NOT NULL,
    JOB_GROUP VARCHAR2(200) NOT NULL,
    DESCRIPTION VARCHAR2(250) NULL,
    NEXT_FIRE_TIME NUMBER(13) NULL,
    PREV_FIRE_TIME NUMBER(13) NULL,
    PRIORITY NUMBER(13) NULL,
    TRIGGER_STATE VARCHAR2(16) NOT NULL,
    TRIGGER_TYPE VARCHAR2(8) NOT NULL,
    START_TIME NUMBER(13) NOT NULL,
    END_TIME NUMBER(13) NULL,
    CALENDAR_NAME VARCHAR2(200) NULL,
    MISFIRE_INSTR NUMBER(2) NULL,
    JOB_DATA BLOB NULL,
    CONSTRAINT QRTZ_TRIGGERS_PK PRIMARY KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP),
    CONSTRAINT QRTZ_TRIGGER_TO_JOBS_FK FOREIGN KEY (SCHED_NAME,JOB_NAME,JOB_GROUP)
        REFERENCES QRTZ_JOB_DETAILS(SCHED_NAME,JOB_NAME,JOB_GROUP)
);
CREATE TABLE qrtz_simple_triggers
(
    SCHED_NAME VARCHAR2(120) NOT NULL,
    TRIGGER_NAME VARCHAR2(200) NOT NULL,
    TRIGGER_GROUP VARCHAR2(200) NOT NULL,
    REPEAT_COUNT NUMBER(7) NOT NULL,
    REPEAT_INTERVAL NUMBER(12) NOT NULL,
    TIMES_TRIGGERED NUMBER(10) NOT NULL,
    CONSTRAINT QRTZ_SIMPLE_TRIG_PK PRIMARY KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP),
    CONSTRAINT QRTZ_SIMPLE_TRIG_TO_TRIG_FK FOREIGN KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
        REFERENCES QRTZ_TRIGGERS(SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
);
CREATE TABLE qrtz_cron_triggers
(
    SCHED_NAME VARCHAR2(120) NOT NULL,
    TRIGGER_NAME VARCHAR2(200) NOT NULL,
    TRIGGER_GROUP VARCHAR2(200) NOT NULL,
    CRON_EXPRESSION VARCHAR2(120) NOT NULL,
    TIME_ZONE_ID VARCHAR2(80),
    CONSTRAINT QRTZ_CRON_TRIG_PK PRIMARY KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP),
    CONSTRAINT QRTZ_CRON_TRIG_TO_TRIG_FK FOREIGN KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
        REFERENCES QRTZ_TRIGGERS(SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
);
CREATE TABLE qrtz_simprop_triggers
(
    SCHED_NAME VARCHAR2(120) NOT NULL,
    TRIGGER_NAME VARCHAR2(200) NOT NULL,
    TRIGGER_GROUP VARCHAR2(200) NOT NULL,
    STR_PROP_1 VARCHAR2(512) NULL,
    STR_PROP_2 VARCHAR2(512) NULL,
    STR_PROP_3 VARCHAR2(512) NULL,
    INT_PROP_1 NUMBER(10) NULL,
    INT_PROP_2 NUMBER(10) NULL,
    LONG_PROP_1 NUMBER(13) NULL,
    LONG_PROP_2 NUMBER(13) NULL,
    DEC_PROP_1 NUMERIC(13,4) NULL,
    DEC_PROP_2 NUMERIC(13,4) NULL,
    BOOL_PROP_1 VARCHAR2(1) NULL,
    BOOL_PROP_2 VARCHAR2(1) NULL,
    CONSTRAINT QRTZ_SIMPROP_TRIG_PK PRIMARY KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP),
    CONSTRAINT QRTZ_SIMPROP_TRIG_TO_TRIG_FK FOREIGN KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
        REFERENCES QRTZ_TRIGGERS(SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
);
CREATE TABLE qrtz_blob_triggers
(
    SCHED_NAME VARCHAR2(120) NOT NULL,
    TRIGGER_NAME VARCHAR2(200) NOT NULL,
    TRIGGER_GROUP VARCHAR2(200) NOT NULL,
    BLOB_DATA BLOB NULL,
    CONSTRAINT QRTZ_BLOB_TRIG_PK PRIMARY KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP),
    CONSTRAINT QRTZ_BLOB_TRIG_TO_TRIG_FK FOREIGN KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
        REFERENCES QRTZ_TRIGGERS(SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
);
CREATE TABLE qrtz_calendars
(
    SCHED_NAME VARCHAR2(120) NOT NULL,
    CALENDAR_NAME  VARCHAR2(200) NOT NULL,
    CALENDAR BLOB NOT NULL,
    CONSTRAINT QRTZ_CALENDARS_PK PRIMARY KEY (SCHED_NAME,CALENDAR_NAME)
);
CREATE TABLE qrtz_paused_trigger_grps
(
    SCHED_NAME VARCHAR2(120) NOT NULL,
    TRIGGER_GROUP  VARCHAR2(200) NOT NULL,
    CONSTRAINT QRTZ_PAUSED_TRIG_GRPS_PK PRIMARY KEY (SCHED_NAME,TRIGGER_GROUP)
);
CREATE TABLE qrtz_fired_triggers
(
    SCHED_NAME VARCHAR2(120) NOT NULL,
    ENTRY_ID VARCHAR2(95) NOT NULL,
    TRIGGER_NAME VARCHAR2(200) NOT NULL,
    TRIGGER_GROUP VARCHAR2(200) NOT NULL,
    INSTANCE_NAME VARCHAR2(200) NOT NULL,
    FIRED_TIME NUMBER(13) NOT NULL,
    SCHED_TIME NUMBER(13) NOT NULL,
    PRIORITY NUMBER(13) NOT NULL,
    STATE VARCHAR2(16) NOT NULL,
    JOB_NAME VARCHAR2(200) NULL,
    JOB_GROUP VARCHAR2(200) NULL,
    IS_NONCONCURRENT VARCHAR2(1) NULL,
    REQUESTS_RECOVERY VARCHAR2(1) NULL,
    CONSTRAINT QRTZ_FIRED_TRIGGER_PK PRIMARY KEY (SCHED_NAME,ENTRY_ID)
);
CREATE TABLE qrtz_scheduler_state
(
    SCHED_NAME VARCHAR2(120) NOT NULL,
    INSTANCE_NAME VARCHAR2(200) NOT NULL,
    LAST_CHECKIN_TIME NUMBER(13) NOT NULL,
    CHECKIN_INTERVAL NUMBER(13) NOT NULL,
    CONSTRAINT QRTZ_SCHEDULER_STATE_PK PRIMARY KEY (SCHED_NAME,INSTANCE_NAME)
);
CREATE TABLE qrtz_locks
(
    SCHED_NAME VARCHAR2(120) NOT NULL,
    LOCK_NAME  VARCHAR2(40) NOT NULL,
    CONSTRAINT QRTZ_LOCKS_PK PRIMARY KEY (SCHED_NAME,LOCK_NAME)
);

create index idx_qrtz_j_req_recovery on qrtz_job_details(SCHED_NAME,REQUESTS_RECOVERY);
create index idx_qrtz_j_grp on qrtz_job_details(SCHED_NAME,JOB_GROUP);

create index idx_qrtz_t_j on qrtz_triggers(SCHED_NAME,JOB_NAME,JOB_GROUP);
create index idx_qrtz_t_jg on qrtz_triggers(SCHED_NAME,JOB_GROUP);
create index idx_qrtz_t_c on qrtz_triggers(SCHED_NAME,CALENDAR_NAME);
create index idx_qrtz_t_g on qrtz_triggers(SCHED_NAME,TRIGGER_GROUP);
create index idx_qrtz_t_state on qrtz_triggers(SCHED_NAME,TRIGGER_STATE);
create index idx_qrtz_t_n_state on qrtz_triggers(SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP,TRIGGER_STATE);
create index idx_qrtz_t_n_g_state on qrtz_triggers(SCHED_NAME,TRIGGER_GROUP,TRIGGER_STATE);
create index idx_qrtz_t_next_fire_time on qrtz_triggers(SCHED_NAME,NEXT_FIRE_TIME);
create index idx_qrtz_t_nft_st on qrtz_triggers(SCHED_NAME,TRIGGER_STATE,NEXT_FIRE_TIME);
create index idx_qrtz_t_nft_misfire on qrtz_triggers(SCHED_NAME,MISFIRE_INSTR,NEXT_FIRE_TIME);
create index idx_qrtz_t_nft_st_misfire on qrtz_triggers(SCHED_NAME,MISFIRE_INSTR,NEXT_FIRE_TIME,TRIGGER_STATE);
create index idx_qrtz_t_nft_st_misfire_grp on qrtz_triggers(SCHED_NAME,MISFIRE_INSTR,NEXT_FIRE_TIME,TRIGGER_GROUP,TRIGGER_STATE);

create index idx_qrtz_ft_trig_inst_name on qrtz_fired_triggers(SCHED_NAME,INSTANCE_NAME);
create index idx_qrtz_ft_inst_job_req_rcvry on qrtz_fired_triggers(SCHED_NAME,INSTANCE_NAME,REQUESTS_RECOVERY);
create index idx_qrtz_ft_j_g on qrtz_fired_triggers(SCHED_NAME,JOB_NAME,JOB_GROUP);
create index idx_qrtz_ft_jg on qrtz_fired_triggers(SCHED_NAME,JOB_GROUP);
create index idx_qrtz_ft_t_g on qrtz_fired_triggers(SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP);
create index idx_qrtz_ft_tg on qrtz_fired_triggers(SCHED_NAME,TRIGGER_GROUP);


create table h_form_comment
(
    id              varchar(42)                    not null
        primary key,
    content         varchar2(3000)                 null,
    commentator     varchar2(42)                   not null,
    commentatorName varchar2(80)                   not null,
    departmentId    varchar2(42)                   null,
    schemaCode      varchar2(42)                   not null,
    bizObjectId     varchar2(42)                   not null,
    replyCommentId  varchar2(42)                   null,
    replyUserId     varchar2(42)                   null,
    replyUserName   varchar2(80)                   null,
    originCommentId varchar2(42)                   null,
    floor           int          default 0         not null,
    state           varchar2(20) default 'ENABLED' not null,
    deleted         number(1, 0) default 0         not null,
    attachmentNum   int          default 0         not null,
    modifier        varchar2(42)                   null,
    createdTime     date         default sysdate   not null,
    modifiedTime    date                           null,
    text            varchar2(4000)                 null
);

create index IDX_FORM_OBJ_ID on h_form_comment (bizObjectId);

ALTER TABLE h_biz_property ADD (relativePropertyCode VARCHAR2(80) DEFAULT null);
comment on column h_biz_property.relativePropertyCode is '关联表单显示字段';

create index idx_h_biz_attachment_boi on h_biz_attachment (bizObjectId);
alter table H_BIZ_ATTACHMENT modify PARENTBIZOBJECTID default '';
create index idx_h_biz_attachment_pboi on h_biz_attachment (parentBizObjectId);

-- create index idx_h_org_role_code on h_org_role (code);

-- 這里有问题
-- alter table H_IM_WORK_RECORD_HISTORY modify CONTENT VARCHAR2(3000);

-- ALTER TABLE h_im_work_record MODIFY content varchar2(3000) default '';

-- ALTER TABLE h_form_comment ADD  (text varchar2(4000));
-- comment on column h_form_comment.text is '评论内容html格式';

create table h_from_comment_attachment
(
    id            varchar2(42)               not null
        primary key,
    bizObjectId   varchar2(42)               not null,
    schemaCode    varchar2(42)               not null,
    commentId     varchar2(42)               not null,
    fileExtension varchar2(30)               null,
    fileSize      int       default 0       not null,
    mimeType      varchar2(50)               not null,
    name          varchar2(255)              not null,
    refId         varchar2(80)               not null,
    createdTime   date default sysdate not null,
    creater       varchar2(42)               not null
);

create index IDX_F_C_A_COMM_ID on h_from_comment_attachment (commentId);
create index IDX_F_C_A_REF_ID on h_from_comment_attachment (refId);
ALTER TABLE h_org_user ADD (dingUserJson CLOB DEFAULT null);
comment on column h_org_user.dingUserJson is '钉钉同步过来的json数据记录';

CREATE TABLE h_related_corp_setting (
                                        id varchar2(120)  NOT NULL   primary key,
                                        creater varchar2(120)  DEFAULT NULL,
                                        createdTime date DEFAULT NULL,
                                        deleted number(1, 0) DEFAULT NULL,
                                        modifier varchar2(120)  DEFAULT NULL,
                                        modifiedTime date DEFAULT NULL,
                                        remarks varchar2(200)  DEFAULT NULL,
                                        agentId varchar2(120)  DEFAULT NULL,
                                        appSecret varchar2(120)  DEFAULT NULL,
                                        appkey varchar2(120)  DEFAULT NULL,
                                        corpId varchar2(120)  DEFAULT NULL,
                                        corpSecret varchar2(120)  DEFAULT NULL,
                                        exportHost varchar2(36)  DEFAULT NULL,
                                        extend1 varchar2(120)  DEFAULT NULL,
                                        extend2 varchar2(120)  DEFAULT NULL,
                                        extend3 varchar2(120)  DEFAULT NULL,
                                        extend4 varchar2(120)  DEFAULT NULL,
                                        extend5 varchar2(120)  DEFAULT NULL,
                                        headerNum int DEFAULT NULL,
                                        name varchar2(240)  DEFAULT NULL,
                                        orgType varchar2(12)  DEFAULT NULL,
                                        relatedType varchar2(12)  DEFAULT NULL,
                                        scanAppId varchar2(120)  DEFAULT NULL,
                                        scanAppSecret varchar2(200)  DEFAULT NULL,
                                        redirectUri varchar2(200)  DEFAULT NULL,
                                        synRedirectUri varchar2(120)  DEFAULT NULL,
                                        pcServerUrl varchar2(120)  DEFAULT NULL,
                                        mobileServerUrl varchar2(120)  DEFAULT NULL,
                                        syncType varchar2(12)  DEFAULT NULL
);

ALTER TABLE h_org_department ADD (corpId VARCHAR2(256) DEFAULT null);
ALTER TABLE h_org_department_history ADD (corpId VARCHAR2(256) DEFAULT null);

ALTER TABLE h_org_user ADD (corpId VARCHAR2(256) DEFAULT null);
comment on column h_org_user.corpId is '用户新增组织外键关联';

ALTER TABLE h_org_role_group ADD (corpId VARCHAR2(256) DEFAULT null);
comment on column h_org_role_group.corpId is '角色组新增组织外键关联';

ALTER TABLE h_org_role ADD (corpId VARCHAR(256) DEFAULT null);
comment on column h_org_role.corpId is '角色新增组织外键关联';

CREATE TABLE h_org_synchronize_log (
                                       id varchar2(120)  NOT NULL   primary key,
                                       targetType varchar2(30)  DEFAULT NULL,
                                       trackId varchar2(60)  DEFAULT NULL,
                                       targetId varchar2(120)  DEFAULT NULL,
                                       errorType varchar2(1000)  DEFAULT NULL
);

ALTER TABLE h_biz_sheet ADD (formComment number(1,0) DEFAULT 0);
comment on column h_biz_sheet.formComment is '是否开启表单评论';


ALTER TABLE H_ORG_DEPARTMENT DROP CONSTRAINT UK_h_org_department_sourceId;

ALTER TABLE H_ORG_ROLE DROP CONSTRAINT UK_h_org_role_sourceId;

create table h_biz_export_task
(
    id                     varchar2(36) not null
        primary key,
    createdTime             date            null,
    creater                 varchar2(120)   null,
    deleted                 number(1, 0)    null,
    modifiedTime            date            null,
    modifier                varchar2(120)   null,
    remarks                 varchar2(200)   null,
    startTime 		        date  		    null ,
    endTime 		        date  		    null ,
    message                 varchar2(4000)  null,
    taskStatus              varchar2(50)    null,
    exportResultStatus      varchar2(50)     null,
    userId                  varchar2(36)     null,
    path                     varchar2(120)   null
);

-- 删除部门用户关联重复项 保留最旧的记录
delete from h_org_dept_user where id in(
    select a.id from (
                         select hodu.id from h_org_dept_user hodu where hodu.id in(
                             select a.id from h_org_dept_user a
                                                  LEFT JOIN
                                              (
                                                  select count(a.userId) as num,a.deptId,a.userId,MIN(a.createdTime) from h_org_dept_user a GROUP BY a.deptId,a.userId having count(a.userId) > 1
                                              ) b on a.deptId = b.deptId and a.userId = b.userId
                             where b.num is not null
                         ) and hodu.id not in(
                             select  a.id from h_org_dept_user a
                                                   LEFT JOIN
                                               (
                                                   select count(a.userId) num,a.deptId,a.userId,MIN(a.createdTime) minTime from h_org_dept_user a GROUP BY a.deptId,a.userId having count(a.userId) > 1
                                               ) b on a.deptId = b.deptId and a.userId = b.userId and a.createdTime = b.minTime
                             where b.num is not null
                         )
                     ) a
);
-- 建立部门用户联合唯一索引
DROP INDEX idx_dept_user_composeid;

alter table h_org_dept_user add constraint idx_dept_user_composeid unique(userId,deptId);

-- 删除角色用户关联重复项 保留最旧的记录
delete from h_org_role_user where id in(
    select a.id from (
                         select hodu.id from h_org_role_user hodu where hodu.id in(
                             select a.id from h_org_role_user a
                                                  LEFT JOIN
                                              (
                                                  select count(a.userId) num,a.roleId,a.userId,MIN(a.createdTime) from h_org_role_user a GROUP BY a.roleId,a.userId having count(a.userId) > 1
                                              ) b on a.roleId = b.roleId and a.userId = b.userId
                             where b.num is not null
                         ) and hodu.id not in(
                             select  a.id from h_org_role_user a
                                                   LEFT JOIN
                                               (
                                                   select count(a.userId) num,a.roleId,a.userId,MIN(a.createdTime) minTime from h_org_role_user a GROUP BY a.roleId,a.userId having count(a.userId) > 1
                                               ) b on a.roleId = b.roleId and a.userId = b.userId and a.createdTime = b.minTime
                             where b.num is not null
                         )
                     ) a
);

-- 建立角色用户联合唯一索引
alter table h_org_role_user add constraint idx_role_user_composeid unique(userId,roleId);



update d_process_task hpt set hpt.userId = (select hou.id from h_org_user hou where hpt.userId = hou.userId)
where exists (select userId from h_org_user hou where hou.userId = hpt.userId);

update d_process_instance hpi set hpi.originator = (select hou.id from h_org_user hou where hpi.originator = hou.userId)
where exists (select hou.userId from h_org_user hou where hou.userId = hpi.originator);


-- ALTER TABLE h_biz_sheet MODIFY COLUMN tempAuthSchemaCodes varchar2(3500) DEFAULT NULL;

ALTER TABLE h_biz_sheet MODIFY  (tempAuthSchemaCodes varchar2(3500));
