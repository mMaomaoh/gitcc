ALTER TABLE D_PROCESS_TASK rename column PROCESSINSTANCEID to PROCESSINSTANCEID_tmp;
ALTER TABLE D_PROCESS_TASK ADD PROCESSINSTANCEID varchar2(64) NULL;
update D_PROCESS_TASK set PROCESSINSTANCEID=trim(PROCESSINSTANCEID_tmp);
alter table D_PROCESS_TASK drop column PROCESSINSTANCEID_tmp;

ALTER TABLE D_PROCESS_TASK rename column TASKID to TASKID_tmp;
ALTER TABLE D_PROCESS_TASK ADD TASKID varchar2(50) DEFAULT '' not NULL ;
update D_PROCESS_TASK set TASKID=trim(TASKID_tmp);
alter table D_PROCESS_TASK drop column TASKID_tmp;