-- auto-generated definition
create table h_perm_selection_scope
(
    id                varchar(120) not null
        primary key,
    createdTime       datetime     null,
    creater           varchar(120) null,
    deleted           bit          null,
    modifiedTime      datetime     null,
    modifier          varchar(120) null,
    remarks           varchar(200) null,
    departmentId      varchar(120) null,
    deptVisibleType   varchar(40)  null,
    deptVisibleScope  longtext     null,
    staffVisibleType  varchar(40)  null,
    staffVisibleScope longtext     null
)
    charset = utf8;
alter table h_org_role_group
	add parentId varchar(120) null comment '上一级角色组id';


/*==============================================================*/
/* Table: h_org_inc_sync_record                                 */
/*==============================================================*/
create table h_org_inc_sync_record
(
   id                   varchar(120) not null,
   syncSourceType       char(10) default 'DINGTALK' comment '同步源类型，钉钉|企业微信 等 默认为钉钉',
   createTime           datetime default CURRENT_TIMESTAMP comment '创建时间',
   updateTime           datetime default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP comment '修改时间',
   corpId               varchar(120) default NULL comment '组织corpId',
   eventType            varchar(50) default NULL comment '钉钉回调事件类型',
   eventInfo            text comment '事件数据',
   handleStatus         varchar(20) default NULL comment '处理状态',
   retryCount           int(11) default NULL comment '重试次数',
   primary key (id)
)
ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE = utf8_bin;

alter table h_org_inc_sync_record comment '增量同步记录表';
alter table h_biz_service_category add createdBy varchar(120) comment '创建人';
alter table h_biz_service_category add modifiedBy varchar(120) comment '更新人';
alter table h_biz_datasource_category add createdBy varchar(120) comment '创建人';
alter table h_biz_datasource_category add modifiedBy varchar(120) comment '更新人';
ALTER TABLE h_business_rule ADD enabled bit(1) NULL DEFAULT NULL comment '是否生效';
ALTER TABLE h_business_rule ADD quoteProperty longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL comment '引用编码 数据模型编码.数据项编码 ,分割';

update h_business_rule set enabled = 1 where enabled is null;
alter table h_biz_perm_property
    add encryptVisible bit null comment '是否可见加密';

update h_biz_perm_property set encryptVisible = 0 where id != '';
CREATE TABLE `h_business_rule_runmap` (
  `id` varchar(120) NOT NULL COMMENT '主键',
  `ruleCode` varchar(40) NOT NULL COMMENT '规则编码',
  `ruleName` varchar(100) DEFAULT NULL COMMENT '规则名称',
  `ruleType` varchar(15) NOT NULL COMMENT '规则类型',
  `nodeCode` varchar(40) NOT NULL COMMENT '节点编码',
  `nodeName` varchar(100) DEFAULT NULL COMMENT '节点名称',
  `nodeType` varchar(15) NOT NULL COMMENT '节点类型',
  `targetSchemaCode` varchar(40) NOT NULL COMMENT '目标对象模型编码',
  `triggerSchemaCode` varchar(40) NOT NULL COMMENT '触发对象模型编码',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
alter table h_biz_property
    add encryptOption bit null comment '加密类型';
