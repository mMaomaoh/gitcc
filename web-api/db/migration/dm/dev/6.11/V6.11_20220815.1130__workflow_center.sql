alter table biz_workitem add dataType varchar2(20) default 'NORMAL' not null;
comment on column biz_workitem.dataType is '数据类型，正常：NORMAL；模拟：SIMULATIVE';
alter table biz_workitem add sequenceNo varchar2(200) null;
comment on column biz_workitem.sequenceNo is '单据号';

alter table biz_workitem_finished add dataType varchar2(20) default 'NORMAL' not null;
comment on column biz_workitem_finished.dataType is '数据类型，正常：NORMAL；模拟：SIMULATIVE';
alter table biz_workitem_finished add sequenceNo varchar2(200) null;
comment on column biz_workitem_finished.sequenceNo is '单据号';

alter table biz_circulateitem add dataType varchar2(20) default 'NORMAL' not null;
comment on column biz_circulateitem.dataType is '数据类型，正常：NORMAL；模拟：SIMULATIVE';
alter table biz_circulateitem add sequenceNo varchar2(200) null;
comment on column biz_circulateitem.sequenceNo is '单据号';

alter table biz_circulateitem_finished add dataType varchar2(20) default 'NORMAL' not null;
comment on column biz_circulateitem_finished.dataType is '数据类型，正常：NORMAL；模拟：SIMULATIVE';
alter table biz_circulateitem_finished add sequenceNo varchar2(200) null;
comment on column biz_circulateitem_finished.sequenceNo is '单据号';

update biz_workitem bw set bw.sequenceNo = (select bwi.sequenceNo from biz_workflow_instance bwi
                                            where bw.instanceId= bwi.id);
update biz_workitem bw set bw.dataType= (select bwi.dataType from biz_workflow_instance bwi
                                         where bw.instanceId= bwi.id)  where bw.instanceId in (select id from biz_workflow_instance);

update biz_workitem_finished bw set bw.sequenceNo = (select bwi.sequenceNo from biz_workflow_instance bwi
                                                     where bw.instanceId= bwi.id);
update biz_workitem_finished bw set bw.dataType= (select bwi.dataType from biz_workflow_instance bwi
                                                  where bw.instanceId= bwi.id)  where bw.instanceId in (select id from biz_workflow_instance);

update biz_circulateitem bw set bw.sequenceNo = (select bwi.sequenceNo from biz_workflow_instance bwi
                                                 where bw.instanceId= bwi.id);
update biz_circulateitem bw set bw.dataType= (select bwi.dataType from biz_workflow_instance bwi
                                              where bw.instanceId= bwi.id)  where bw.instanceId in (select id from biz_workflow_instance);

update biz_circulateitem_finished bw set bw.sequenceNo = (select bwi.sequenceNo from biz_workflow_instance bwi
                                                          where bw.instanceId= bwi.id);
update biz_circulateitem_finished bw set bw.dataType= (select bwi.dataType from biz_workflow_instance bwi
                                                       where bw.instanceId= bwi.id)  where bw.instanceId in (select id from biz_workflow_instance);

create index idx_bwi_trustee on biz_workflow_instance (trustee);

create index idx_bwi_parentId on biz_workflow_instance (parentId);

create index idx_bwf_trustor on biz_workitem_finished (trustor);

create index idx_bwi_s_s_d on biz_workflow_instance (startTime, state, dataType);

create index idx_bwf_f_s_d on biz_workitem_finished (finishTime, state, dataType);

create index idx_bwi_finishTime on biz_workflow_instance (finishTime);
