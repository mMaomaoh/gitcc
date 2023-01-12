alter table h_open_api_event add creater varchar(120);
comment on column h_open_api_event.creater is '创建人';
alter table h_open_api_event add createdtime timestamp;
comment on column h_open_api_event.createdtime is '创建时间';
alter table h_open_api_event add modifier varchar(120);
comment on column h_open_api_event.modifier is '修改人';
alter table h_open_api_event add modifiedtime timestamp;
comment on column h_open_api_event.modifiedtime is '修改时间';
alter table h_open_api_event add remarks varchar(200);
comment on column h_open_api_event.remarks is '备注';
alter table h_open_api_event add deleted bool;
comment on column h_open_api_event.deleted is '删除标识';

CREATE TABLE h_subscribe_message (
  id varchar(100) not null,
  callbackUrl varchar(255),
  eventTarget varchar(200),
  eventTargetType varchar(255),
  eventType varchar(255),
  eventKey varchar(200),
  eventParam text,
  applicationName varchar(200),
  pushTime timestamp,
  retryTimes int4,
  createdTime timestamp,
  modifiedTime timestamp,
  options text,
  status varchar(100),
  CONSTRAINT h_subscribe_message_pkey PRIMARY KEY (id)
);
comment on column h_subscribe_message.callbackUrl is '回调地址';
comment on column h_subscribe_message.eventTarget is '事件对象';
comment on column h_subscribe_message.eventTargetType is '事件对象类型';
comment on column h_subscribe_message.eventType is '事件触发类型';
comment on column h_subscribe_message.eventKey is '事件标识符';
comment on column h_subscribe_message.eventParam is '时间推送内容';
comment on column h_subscribe_message.applicationName is '容器名称';
comment on column h_subscribe_message.pushTime is '推送时间';
comment on column h_subscribe_message.retryTimes is '重试次数';
comment on column h_subscribe_message.createdTime is '创建时间';
comment on column h_subscribe_message.modifiedTime is '修改时间';
comment on column h_subscribe_message.options is '扩展参数';
comment on column h_subscribe_message.status is '推送状态';

CREATE TABLE h_subscribe_message_history (
  id varchar(100) not null,
  callbackUrl varchar(255),
  eventTarget varchar(200),
  eventTargetType varchar(255),
  eventType varchar(255),
  eventKey varchar(200),
  eventParam text,
  applicationName varchar(200),
  pushTime timestamp,
  retryTimes int4,
  createdTime timestamp,
  modifiedTime timestamp,
  options text,
  status varchar(100),
  CONSTRAINT h_subscribe_message_history_pkey PRIMARY KEY (id)
);
comment on column h_subscribe_message_history.callbackUrl is '回调地址';
comment on column h_subscribe_message_history.eventTarget is '事件对象';
comment on column h_subscribe_message_history.eventTargetType is '事件对象类型';
comment on column h_subscribe_message_history.eventType is '事件触发类型';
comment on column h_subscribe_message_history.eventKey is '事件标识符';
comment on column h_subscribe_message_history.eventParam is '时间推送内容';
comment on column h_subscribe_message_history.applicationName is '容器名称';
comment on column h_subscribe_message_history.pushTime is '推送时间';
comment on column h_subscribe_message_history.retryTimes is '重试次数';
comment on column h_subscribe_message_history.createdTime is '创建时间';
comment on column h_subscribe_message_history.modifiedTime is '修改时间';
comment on column h_subscribe_message_history.options is '扩展参数';
comment on column h_subscribe_message_history.status is '推送状态';