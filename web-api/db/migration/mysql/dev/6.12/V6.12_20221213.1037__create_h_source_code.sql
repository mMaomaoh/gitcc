CREATE TABLE `h_source_code` (
  `id` varchar(120) NOT NULL,
  `code` varchar(120) NOT NULL COMMENT '源代码编码',
  `createdTime` datetime DEFAULT NULL,
  `creater` varchar(120) DEFAULT NULL,
  `deleted` bit(1) DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `modifier` varchar(120) DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `content` longtext COMMENT '源码',
  `codeType` varchar(15) DEFAULT NULL COMMENT '源码类型',
  `published` bit(1) DEFAULT NULL COMMENT '是否生效',
  `version` int DEFAULT NULL COMMENT '版本号',
  `originalVersion` int DEFAULT NULL COMMENT '源版本号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;
create index idx_h_source_code_code on h_source_code (code);

CREATE TABLE `h_source_code_template` (
  `id` varchar(120) NOT NULL,
  `code` varchar(120) NOT NULL COMMENT '模板编码',
  `createdTime` datetime DEFAULT NULL,
  `creater` varchar(120) DEFAULT NULL,
  `deleted` bit(1) DEFAULT NULL,
  `modifiedTime` datetime DEFAULT NULL,
  `modifier` varchar(120) DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `content` longtext COMMENT '源码',
  `codeType` varchar(15) DEFAULT NULL COMMENT '源码类型',
  `name` varchar(100) DEFAULT NULL COMMENT '模板名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;
create unique index idx_h_source_code_template_code on h_source_code_template (code, codeType);

INSERT INTO `h_source_code_template` (`id`, `code`, `createdTime`, `creater`, `deleted`, `modifiedTime`, `modifier`, `remarks`, `content`, `codeType`, `name`) VALUES ('2c928d4484f5cd9b0184f5d048e204dd', 'AvailableHandlerTemplate', '2022-12-09 15:36:19', NULL, b'0', '2022-12-09 15:36:22', NULL, NULL, 'package com.authine.cloudpivot.engine.service.bizrule.handler;\n\nimport com.authine.cloudpivot.engine.service.bizrule.handler.context.Request;\n\npublic class SourceCodeTemplateClassName extends AvailableHandler {\n    @Override\n    public Object handle(Request request) {\n        return super.handle(request);\n    }\n}\n', 'BUSINESS_RULE', '默认业务规则-流程生效');
INSERT INTO `h_source_code_template` (`id`, `code`, `createdTime`, `creater`, `deleted`, `modifiedTime`, `modifier`, `remarks`, `content`, `codeType`, `name`) VALUES ('2c928d4484f5cd9b0184f5d07d4004e0', 'CancelHandlerTemplate', '2022-12-09 15:36:32', NULL, b'0', '2022-12-09 15:36:40', NULL, NULL, 'package com.authine.cloudpivot.engine.service.bizrule.handler;\n\nimport com.authine.cloudpivot.engine.service.bizrule.handler.context.Request;\n\npublic class SourceCodeTemplateClassName extends CancelHandler {\n    @Override\n    public Object handle(Request request) {\n        return super.handle(request);\n    }\n}\n', 'BUSINESS_RULE', '默认业务规则-流程取消');
INSERT INTO `h_source_code_template` (`id`, `code`, `createdTime`, `creater`, `deleted`, `modifiedTime`, `modifier`, `remarks`, `content`, `codeType`, `name`) VALUES ('2c928d4484f5cd9b0184f5d09bb404e3', 'CreateHandlerTemplate', '2022-12-09 15:36:40', NULL, b'0', '2022-12-09 15:36:40', NULL, NULL, 'package com.authine.cloudpivot.engine.service.bizrule.handler;\n\nimport com.authine.cloudpivot.engine.domain.runtime.BizObject;\n\npublic class SourceCodeTemplateClassName extends CreateHandler {\n    @Override\n    protected BizObject create(BizObject bizObject) {\n        return super.create(bizObject);\n    }\n}\n', 'BUSINESS_RULE', '默认业务规则-新增');
INSERT INTO `h_source_code_template` (`id`, `code`, `createdTime`, `creater`, `deleted`, `modifiedTime`, `modifier`, `remarks`, `content`, `codeType`, `name`) VALUES ('2c928d4484f5cd9b0184f5d09bbb04e5', 'DeleteHandlerTemplate', '2022-12-09 15:36:40', NULL, b'0', '2022-12-09 15:36:40', NULL, NULL, 'package com.authine.cloudpivot.engine.service.bizrule.handler;\n\nimport com.authine.cloudpivot.engine.service.bizrule.handler.context.Request;\n\npublic class SourceCodeTemplateClassName extends CancelHandler {\n    @Override\n    public Object handle(Request request) {\n        return super.handle(request);\n    }\n}\n', 'BUSINESS_RULE', '默认业务规则-删除');
INSERT INTO `h_source_code_template` (`id`, `code`, `createdTime`, `creater`, `deleted`, `modifiedTime`, `modifier`, `remarks`, `content`, `codeType`, `name`) VALUES ('2c928d4484f5cd9b0184f5d09bc104e7', 'GetListHandlerTemplate', '2022-12-09 15:36:40', NULL, b'0', '2022-12-09 15:36:40', NULL, NULL, 'package com.authine.cloudpivot.engine.service.bizrule.handler;\n\nimport com.authine.cloudpivot.engine.component.query.api.Page;\nimport com.authine.cloudpivot.foundation.orm.api.model.BizObjectQueryObject;\n\nimport java.util.Map;\n\npublic class SourceCodeTemplateClassName extends GetListHandler {\n\n    @Override\n    protected Page<Map<String, Object>> getList(BizObjectQueryObject bizObjectQueryObject) {\n        return super.getList(bizObjectQueryObject);\n    }\n}\n', 'BUSINESS_RULE', '默认业务规则-获取列表');
INSERT INTO `h_source_code_template` (`id`, `code`, `createdTime`, `creater`, `deleted`, `modifiedTime`, `modifier`, `remarks`, `content`, `codeType`, `name`) VALUES ('2c928d4484f5cd9b0184f5d09bc904e9', 'LoadHandlerTemplate', '2022-12-09 15:36:40', NULL, b'0', '2022-12-09 15:36:40', NULL, NULL, 'package com.authine.cloudpivot.engine.service.bizrule.handler;\n\nimport com.authine.cloudpivot.engine.domain.runtime.BizObject;\nimport com.authine.cloudpivot.foundation.orm.api.model.BizObjectOptions;\n\nimport java.util.Optional;\n\npublic class SourceCodeTemplateClassName extends LoadHandler {\n\n    @Override\n    protected Optional<BizObject> load(BizObject bizObject, BizObjectOptions options) {\n        return super.load(bizObject, options);\n    }\n}\n', 'BUSINESS_RULE', '默认业务规则-查询');
INSERT INTO `h_source_code_template` (`id`, `code`, `createdTime`, `creater`, `deleted`, `modifiedTime`, `modifier`, `remarks`, `content`, `codeType`, `name`) VALUES ('2c928d4484f5cd9b0184f5d09bcf04eb', 'UpdateHandlerTemplate', '2022-12-09 15:36:40', NULL, b'0', '2022-12-09 15:36:40', NULL, NULL, 'package com.authine.cloudpivot.engine.service.bizrule.handler;\n\nimport com.authine.cloudpivot.engine.domain.runtime.BizObject;\nimport com.authine.cloudpivot.foundation.orm.api.model.BizObjectOptions;\n\npublic class SourceCodeTemplateClassName extends UpdateHandler {\n    @Override\n    protected Object update(BizObject bizObject, BizObjectOptions options) {\n        return super.update(bizObject, options);\n    }\n}\n', 'BUSINESS_RULE', '默认业务规则-更新');
INSERT INTO `h_source_code_template` (`id`, `code`, `createdTime`, `creater`, `deleted`, `modifiedTime`, `modifier`, `remarks`, `content`, `codeType`, `name`) VALUES ('2c928d4484fa33380184fa34d96d04d6', 'CustomizedHandlerTemplate', '2022-12-10 12:04:38', NULL, b'0', '2022-12-10 12:04:38', NULL, NULL, 'package com.authine.cloudpivot.engine.service.bizrule.handler;\n\nimport com.authine.cloudpivot.engine.domain.runtime.BizObject;\nimport com.authine.cloudpivot.engine.service.bizrule.handler.context.Request;\n\nimport java.util.Map;\n\npublic class SourceCodeTemplateClassName extends BaseHandler {\n    @Override\n    public Object handle(Request request) {\n        //获取bo\n        BizObject bizObject = request.getData().getBizObject();\n        //获取自定义业务规则执行参数\n        Map<String, Object> param = request.getData().getCustomParams();\n        //do something\n        return bizObject;\n    }\n}\n', 'BUSINESS_RULE', '自定义业务规则');

ALTER TABLE h_business_rule ADD developmentMode VARCHAR(15) DEFAULT NULL COMMENT '业务规则开发模式(图形化：DEFAULT，在线编码：CODING)';