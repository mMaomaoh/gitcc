alter table h_org_user add userWorkStatus varchar(32) null;
update h_org_user set userWorkStatus  = 'NORMAL' where deleted is false;
update h_org_user set userWorkStatus  = 'DIMISSION' where deleted is true;

create table h_org_user_transfer_record
(
    id              varchar(120)  not null primary key,
    processUserId   varchar(120)  null,
    processTime     datetime      null,
    sourceUserId    varchar(120)  null,
    receiveUserId   varchar(120)  null,
    transferType    varchar(32)   null,
    transferSize    int           null,
    comments         varchar(2048) null
);


create table h_org_user_transfer_detail
(
    id           varchar(120) not null primary key,
    recordId     varchar(120) not null,
    transferData text         null
);
create index idx_record_id on h_org_user_transfer_detail (recordId);