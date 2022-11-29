alter table h_org_user add userWorkStatus varchar(32) null
go
update h_org_user set userWorkStatus  = 'NORMAL' where deleted = 0
go
update h_org_user set userWorkStatus  = 'DIMISSION' where deleted = 1
go

create table h_org_user_transfer_record
(
    id              nvarchar(120)  not null primary key,
    processUserId   nvarchar(120)  null,
    processTime     datetime      null,
    sourceUserId    nvarchar(120)  null,
    receiveUserId   nvarchar(120)  null,
    transferType    nvarchar(32)   null,
    transferSize    int           null,
    comments         nvarchar(2048) null
)
go

create table h_org_user_transfer_detail
(
    id           nvarchar(120) not null primary key,
    recordId     nvarchar(120) not null,
    transferData ntext         null
)
go

create index idx_record_id on h_org_user_transfer_detail (recordId)
go