create table h_im_message_station (
  id nvarchar(36) NOT NULL PRIMARY KEY,
  bizParams ntext,
  content ntext,
  createdTime datetime,
  messageType nvarchar(40),
  modifiedTime datetime,
  title nvarchar(100),
  sender nvarchar(42)
)
go

create table h_im_message_station_user (
  id nvarchar(36)  NOT NULL PRIMARY KEY,
  modifiedTime datetime,
  receiver nvarchar(42),
  messageId nvarchar(36),
  readState nvarchar(255)
)
go

create index idx_receiver on h_im_message_station_user (receiver)
go
create index idx_readState on h_im_message_station_user (readState)
go
