alter table biz_workitem add dataType nvarchar(20) default 'NORMAL' not null;
go
alter table biz_workitem add sequenceNo nvarchar(200) null;
go

alter table biz_workitem_finished add dataType nvarchar(20) default 'NORMAL' not null;
go
alter table biz_workitem_finished add sequenceNo nvarchar(200) null;
go

alter table biz_circulateitem add dataType nvarchar(20) default 'NORMAL' not null;
go
alter table biz_circulateitem add sequenceNo nvarchar(200) null;
go

alter table biz_circulateitem_finished add dataType nvarchar(20) default 'NORMAL' not null;
go
alter table biz_circulateitem_finished add sequenceNo nvarchar(200) null;
go

update bw set bw.dataType = (select bwi.dataType from biz_workflow_instance bwi where bwi.id = bw.instanceId) from biz_workitem bw
where bw.instanceId in (select id from biz_workflow_instance);
go
update bw set bw.sequenceNo = (select bwi.sequenceNo from biz_workflow_instance bwi where bwi.id = bw.instanceId) from biz_workitem bw;
go

update bw set bw.dataType = (select bwi.dataType from biz_workflow_instance bwi where bwi.id = bw.instanceId) from biz_workitem_finished bw
where bw.instanceId in (select id from biz_workflow_instance);
go
update bw set bw.sequenceNo = (select bwi.sequenceNo from biz_workflow_instance bwi where bwi.id = bw.instanceId) from biz_workitem_finished bw;
go

update bw set bw.dataType = (select bwi.dataType from biz_workflow_instance bwi where bwi.id = bw.instanceId) from biz_circulateitem bw
where bw.instanceId in (select id from biz_workflow_instance);
go
update bw set bw.sequenceNo = (select bwi.sequenceNo from biz_workflow_instance bwi where bwi.id = bw.instanceId) from biz_circulateitem bw;
go

update bw set bw.dataType = (select bwi.dataType from biz_workflow_instance bwi where bwi.id = bw.instanceId) from biz_circulateitem_finished bw
where bw.instanceId in (select id from biz_workflow_instance);
go
update bw set bw.sequenceNo = (select bwi.sequenceNo from biz_workflow_instance bwi where bwi.id = bw.instanceId) from biz_circulateitem_finished bw;
go

create index idx_bwi_trustee on biz_workflow_instance (trustee);
go

create index idx_bwi_parentId on biz_workflow_instance (parentId);
go

create index idx_bwf_trustor on biz_workitem_finished (trustor);
go

create index idx_bwi_s_s_d on biz_workflow_instance (startTime, state, dataType);
go

create index idx_bwf_f_s_d on biz_workitem_finished (finishTime, state, dataType);
go

create index idx_bwi_finishTime on biz_workflow_instance (finishTime);
go