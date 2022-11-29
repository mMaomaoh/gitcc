alter table h_org_user add userWorkStatus varchar(32) null;
update h_org_user set userWorkStatus  = 'NORMAL' where deleted = 0;
update h_org_user set userWorkStatus  = 'DIMISSION' where deleted = 1;

create table h_org_user_transfer_record
(
    id              varchar(120)  not null primary key,
    processUserId   varchar(120)  null,
    processTime     timestamp      null,
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
    transferData clob         null
);
create index idx_record_id on h_org_user_transfer_detail (recordId);