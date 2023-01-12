ALTER TABLE h_open_api_event MODIFY COLUMN clientId varchar(100);

ALTER TABLE h_open_api_event ADD creater varchar(120) NULL COMMENT '创建人';
ALTER TABLE h_open_api_event ADD createdTime DATETIME NULL COMMENT '创建时间';
ALTER TABLE h_open_api_event ADD modifier varchar(120) NULL COMMENT '修改人';
ALTER TABLE h_open_api_event ADD modifiedTime DATETIME NULL COMMENT '修改时间';
ALTER TABLE h_open_api_event ADD remarks varchar(200) NULL COMMENT '备注';
ALTER TABLE h_open_api_event ADD deleted bit(1) NULL COMMENT '删除标识';

CREATE TABLE h_subscribe_message (
  id varchar(100) NOT NULL,
  callbackUrl varchar(255) COMMENT '回调地址',
  eventTarget varchar(200) COMMENT '事件对象',
  eventTargetType varchar(255) COMMENT '事件对象类型',
  eventType varchar(255) COMMENT '事件触发类型',
  eventKey varchar(200) COMMENT '事件标识符',
  eventParam longtext COMMENT '时间推送内容',
  applicationName varchar(200) COMMENT '容器名称',
  pushTime datetime COMMENT '推送时间',
  retryTimes int(11) COMMENT '重试次数',
  createdTime datetime COMMENT '创建时间',
  modifiedTime datetime COMMENT '修改时间',
  options longtext COMMENT '扩展参数',
  status varchar(100) COMMENT '推送状态',
  PRIMARY KEY (id)
) ENGINE=InnoDB;


CREATE TABLE h_subscribe_message_history (
  id varchar(100) NOT NULL,
  callbackUrl varchar(255) COMMENT '回调地址',
  eventTarget varchar(200) COMMENT '事件对象',
  eventTargetType varchar(255) COMMENT '事件对象类型',
  eventType varchar(255) COMMENT '事件触发类型',
  eventKey varchar(200) COMMENT '事件标识符',
  eventParam longtext COMMENT '时间推送内容',
  applicationName varchar(200) COMMENT '容器名称',
  pushTime datetime COMMENT '推送时间',
  retryTimes int(11) COMMENT '重试次数',
  createdTime datetime COMMENT '创建时间',
  modifiedTime datetime COMMENT '修改时间',
  options longtext COMMENT '扩展参数',
  status varchar(100) COMMENT '推送状态',
  PRIMARY KEY (id)
) ENGINE=InnoDB;