alter table biz_workitem add dataType varchar(20) default 'NORMAL' not null comment '数据类型，正常：NORMAL；模拟：SIMULATIVE';
alter table biz_workitem add sequenceNo varchar(200) null comment '单据号';

alter table biz_workitem_finished add dataType varchar(20) default 'NORMAL' not null comment '数据类型，正常：NORMAL；模拟：SIMULATIVE';
alter table biz_workitem_finished add sequenceNo varchar(200) null comment '单据号';

alter table biz_circulateitem add dataType varchar(20) default 'NORMAL' not null comment '数据类型，正常：NORMAL；模拟：SIMULATIVE';
alter table biz_circulateitem add sequenceNo varchar(200) null comment '单据号';

alter table biz_circulateitem_finished add dataType varchar(20) default 'NORMAL' not null comment '数据类型，正常：NORMAL；模拟：SIMULATIVE';
alter table biz_circulateitem_finished add sequenceNo varchar(200) null comment '单据号';

update biz_workitem bw set bw.sequenceNo = (select bwi.sequenceNo from biz_workflow_instance bwi
                                            where bw.instanceId= bwi.id);
update biz_workitem bw set bw.dataType= (select bwi.dataType from biz_workflow_instance bwi
                                         where bw.instanceId= bwi.id) where bw.instanceId in (select id from biz_workflow_instance);

update biz_workitem_finished bw set bw.sequenceNo = (select bwi.sequenceNo from biz_workflow_instance bwi
                                                     where bw.instanceId= bwi.id);
update biz_workitem_finished bw set bw.dataType= (select bwi.dataType from biz_workflow_instance bwi
                                                  where bw.instanceId= bwi.id) where bw.instanceId in (select id from biz_workflow_instance);

update biz_circulateitem bw set bw.sequenceNo = (select bwi.sequenceNo from biz_workflow_instance bwi
                                                 where bw.instanceId= bwi.id);
update biz_circulateitem bw set bw.dataType= (select bwi.dataType from biz_workflow_instance bwi
                                              where bw.instanceId= bwi.id) where bw.instanceId in (select id from biz_workflow_instance);

update biz_circulateitem_finished bw set bw.sequenceNo = (select bwi.sequenceNo from biz_workflow_instance bwi
                                                          where bw.instanceId= bwi.id);
update biz_circulateitem_finished bw set bw.dataType= (select bwi.dataType from biz_workflow_instance bwi
                                                       where bw.instanceId= bwi.id) where bw.instanceId in (select id from biz_workflow_instance);

alter table biz_workflow_instance add index idx_bwi_trustee(trustee);

alter table biz_workflow_instance add index idx_bwi_parentId(parentId);

alter table biz_workitem_finished add index idx_bwf_trustor(trustor);

alter table biz_workflow_instance add index idx_bwi_startTime_state_dataType(startTime, state, dataType);

alter table biz_workitem_finished add index idx_bwf_finishTime_state_dateType(finishTime, state, dataType);

alter table biz_workflow_instance add index idx_bwi_finishTime(finishTime);