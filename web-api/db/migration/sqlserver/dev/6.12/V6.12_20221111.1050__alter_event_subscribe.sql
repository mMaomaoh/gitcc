ALTER TABLE h_open_api_event ALTER COLUMN clientId nvarchar(100)
go
ALTER TABLE h_open_api_event ADD creater nvarchar(120)
go
ALTER TABLE h_open_api_event ADD createdTime datetime
go
ALTER TABLE h_open_api_event ADD modifier nvarchar(120)
go
ALTER TABLE h_open_api_event ADD modifiedTime datetime
go
ALTER TABLE h_open_api_event ADD remarks nvarchar(200)
go
ALTER TABLE h_open_api_event ADD deleted bit
go

CREATE TABLE h_subscribe_message (
  id nvarchar(100) not null primary key,
  callbackUrl nvarchar(255),
  eventTarget nvarchar(200),
  eventTargetType nvarchar(255),
  eventType nvarchar(255),
  eventKey nvarchar(200),
  eventParam ntext,
  applicationName nvarchar(200),
  pushTime datetime,
  retryTimes int,
  createdTime datetime,
  modifiedTime datetime,
  options ntext,
  status nvarchar(100)
)
go

CREATE TABLE h_subscribe_message_history (
  id nvarchar(100) not null primary key,
  callbackUrl nvarchar(255),
  eventTarget nvarchar(200),
  eventTargetType nvarchar(255),
  eventType nvarchar(255),
  eventKey nvarchar(200),
  eventParam ntext,
  applicationName nvarchar(200),
  pushTime datetime,
  retryTimes int,
  createdTime datetime,
  modifiedTime datetime,
  options ntext,
  status nvarchar(100)
)
go
