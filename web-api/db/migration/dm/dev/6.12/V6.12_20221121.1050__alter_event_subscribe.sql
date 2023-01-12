ALTER TABLE H_OPEN_API_EVENT MODIFY CLIENTID VARCHAR2(100);

ALTER TABLE H_OPEN_API_EVENT ADD CREATER VARCHAR2(120);
COMMENT ON COLUMN H_OPEN_API_EVENT.CREATER IS '创建人';
ALTER TABLE H_OPEN_API_EVENT ADD CREATEDTIME TIMESTAMP;
COMMENT ON COLUMN H_OPEN_API_EVENT.CREATEDTIME IS '创建时间';
ALTER TABLE H_OPEN_API_EVENT ADD MODIFIER VARCHAR2(120);
COMMENT ON COLUMN H_OPEN_API_EVENT.MODIFIER IS '修改人';
ALTER TABLE H_OPEN_API_EVENT ADD MODIFIEDTIME TIMESTAMP;
COMMENT ON COLUMN H_OPEN_API_EVENT.MODIFIEDTIME IS '修改时间';
ALTER TABLE H_OPEN_API_EVENT ADD REMARKS VARCHAR2(200);
COMMENT ON COLUMN H_OPEN_API_EVENT.REMARKS IS '备注';
ALTER TABLE H_OPEN_API_EVENT ADD DELETED NUMBER(1,0);
COMMENT ON COLUMN H_OPEN_API_EVENT.DELETED IS '删除标识';

CREATE TABLE h_subscribe_message (
  id varchar2(100) primary key not null,
  callbackUrl varchar2(255),
  eventTarget varchar2(200),
  eventTargetType varchar2(255),
  eventType varchar2(255),
  eventKey varchar2(200),
  eventParam clob,
  applicationName varchar2(200),
  pushTime TIMESTAMP,
  retryTimes number(3, 0),
  createdTime TIMESTAMP,
  modifiedTime TIMESTAMP,
  options clob,
  status varchar2(100)
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
  id varchar2(100) primary key not null,
  callbackUrl varchar2(255),
  eventTarget varchar2(200),
  eventTargetType varchar2(255),
  eventType varchar2(255),
  eventKey varchar2(200),
  eventParam clob,
  applicationName varchar2(200),
  pushTime TIMESTAMP,
  retryTimes number(3, 0),
  createdTime TIMESTAMP,
  modifiedTime TIMESTAMP,
  options clob,
  status varchar2(100)
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