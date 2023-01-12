CREATE TABLE h_source_code (
  id varchar(120) NOT NULL,
  code varchar(120) NOT NULL,
  createdTime TIMESTAMP,
  creater varchar(120),
  deleted bool,
  modifiedTime TIMESTAMP,
  modifier varchar(120),
  remarks varchar(200),
  content text,
  codeType varchar(15),
  published bool,
  version int4,
  originalVersion int4,
  CONSTRAINT h_source_code_pkey PRIMARY KEY (id)
);
comment on column h_source_code.code is '源代码编码';
comment on column h_source_code.content is '源码';
comment on column h_source_code.codeType is '源码类型';
comment on column h_source_code.published is '是否生效';
comment on column h_source_code.version is '版本号';
comment on column h_source_code.originalVersion is '源版本号';
CREATE INDEX idx_h_source_code_code ON h_source_code USING btree (code);

CREATE TABLE h_source_code_template (
  id varchar(120) NOT NULL,
  code varchar(120) NOT NULL,
  createdTime TIMESTAMP,
  creater varchar(120),
  deleted bool,
  modifiedTime TIMESTAMP,
  modifier varchar(120),
  remarks varchar(200),
  content text,
  codeType varchar(15),
  name varchar(100)
);
comment on column h_source_code.version is '模板编码';
comment on column h_source_code.version is '源码';
comment on column h_source_code.version is '源码类型';
comment on column h_source_code.version is '模板名称';
CREATE UNIQUE INDEX idx_h_source_code_template_code ON h_source_code_template USING btree (code, codeType);

INSERT INTO h_source_code_template (id, code, createdTime, creater, deleted, modifiedTime, modifier, remarks, content, codeType, name) VALUES ('2c928d4484f5cd9b0184f5d048e204dd', 'AvailableHandlerTemplate', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, '0', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, NULL, 'package com.authine.cloudpivot.engine.service.bizrule.handler;\n\nimport com.authine.cloudpivot.engine.service.bizrule.handler.context.Request;\n\npublic class SourceCodeTemplateClassName extends AvailableHandler {\n    @Override\n    public Object handle(Request request) {\n        return super.handle(request);\n    }\n}\n', 'BUSINESS_RULE', '默认业务规则-流程生效');
INSERT INTO h_source_code_template (id, code, createdTime, creater, deleted, modifiedTime, modifier, remarks, content, codeType, name) VALUES ('2c928d4484f5cd9b0184f5d07d4004e0', 'CancelHandlerTemplate', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, '0', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, NULL, 'package com.authine.cloudpivot.engine.service.bizrule.handler;\n\nimport com.authine.cloudpivot.engine.service.bizrule.handler.context.Request;\n\npublic class SourceCodeTemplateClassName extends CancelHandler {\n    @Override\n    public Object handle(Request request) {\n        return super.handle(request);\n    }\n}\n', 'BUSINESS_RULE', '默认业务规则-流程取消');
INSERT INTO h_source_code_template (id, code, createdTime, creater, deleted, modifiedTime, modifier, remarks, content, codeType, name) VALUES ('2c928d4484f5cd9b0184f5d09bb404e3', 'CreateHandlerTemplate', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, '0', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, NULL, 'package com.authine.cloudpivot.engine.service.bizrule.handler;\n\nimport com.authine.cloudpivot.engine.domain.runtime.BizObject;\n\npublic class SourceCodeTemplateClassName extends CreateHandler {\n    @Override\n    protected BizObject create(BizObject bizObject) {\n        return super.create(bizObject);\n    }\n}\n', 'BUSINESS_RULE', '默认业务规则-新增');
INSERT INTO h_source_code_template (id, code, createdTime, creater, deleted, modifiedTime, modifier, remarks, content, codeType, name) VALUES ('2c928d4484f5cd9b0184f5d09bbb04e5', 'DeleteHandlerTemplate', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, '0', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, NULL, 'package com.authine.cloudpivot.engine.service.bizrule.handler;\n\nimport com.authine.cloudpivot.engine.service.bizrule.handler.context.Request;\n\npublic class SourceCodeTemplateClassName extends CancelHandler {\n    @Override\n    public Object handle(Request request) {\n        return super.handle(request);\n    }\n}\n', 'BUSINESS_RULE', '默认业务规则-删除');
INSERT INTO h_source_code_template (id, code, createdTime, creater, deleted, modifiedTime, modifier, remarks, content, codeType, name) VALUES ('2c928d4484f5cd9b0184f5d09bc104e7', 'GetListHandlerTemplate', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, '0', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, NULL, 'package com.authine.cloudpivot.engine.service.bizrule.handler;\n\nimport com.authine.cloudpivot.engine.component.query.api.Page;\nimport com.authine.cloudpivot.foundation.orm.api.model.BizObjectQueryObject;\n\nimport java.util.Map;\n\npublic class SourceCodeTemplateClassName extends GetListHandler {\n\n    @Override\n    protected Page<Map<String, Object>> getList(BizObjectQueryObject bizObjectQueryObject) {\n        return super.getList(bizObjectQueryObject);\n    }\n}\n', 'BUSINESS_RULE', '默认业务规则-获取列表');
INSERT INTO h_source_code_template (id, code, createdTime, creater, deleted, modifiedTime, modifier, remarks, content, codeType, name) VALUES ('2c928d4484f5cd9b0184f5d09bc904e9', 'LoadHandlerTemplate', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, '0', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, NULL, 'package com.authine.cloudpivot.engine.service.bizrule.handler;\n\nimport com.authine.cloudpivot.engine.domain.runtime.BizObject;\nimport com.authine.cloudpivot.foundation.orm.api.model.BizObjectOptions;\n\nimport java.util.Optional;\n\npublic class SourceCodeTemplateClassName extends LoadHandler {\n\n    @Override\n    protected Optional<BizObject> load(BizObject bizObject, BizObjectOptions options) {\n        return super.load(bizObject, options);\n    }\n}\n', 'BUSINESS_RULE', '默认业务规则-查询');
INSERT INTO h_source_code_template (id, code, createdTime, creater, deleted, modifiedTime, modifier, remarks, content, codeType, name) VALUES ('2c928d4484f5cd9b0184f5d09bcf04eb', 'UpdateHandlerTemplate', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, '0', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, NULL, 'package com.authine.cloudpivot.engine.service.bizrule.handler;\n\nimport com.authine.cloudpivot.engine.domain.runtime.BizObject;\nimport com.authine.cloudpivot.foundation.orm.api.model.BizObjectOptions;\n\npublic class SourceCodeTemplateClassName extends UpdateHandler {\n    @Override\n    protected Object update(BizObject bizObject, BizObjectOptions options) {\n        return super.update(bizObject, options);\n    }\n}\n', 'BUSINESS_RULE', '默认业务规则-更新');
INSERT INTO h_source_code_template (id, code, createdTime, creater, deleted, modifiedTime, modifier, remarks, content, codeType, name) VALUES ('2c928d4484fa33380184fa34d96d04d6', 'CustomizedHandlerTemplate', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, '0', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, NULL, 'package com.authine.cloudpivot.engine.service.bizrule.handler;\n\nimport com.authine.cloudpivot.engine.domain.runtime.BizObject;\nimport com.authine.cloudpivot.engine.service.bizrule.handler.context.Request;\n\nimport java.util.Map;\n\npublic class SourceCodeTemplateClassName extends BaseHandler {\n    @Override\n    public Object handle(Request request) {\n        //获取bo\n        BizObject bizObject = request.getData().getBizObject();\n        //获取自定义业务规则执行参数\n        Map<String, Object> param = request.getData().getCustomParams();\n        //do something\n        return bizObject;\n    }\n}\n', 'BUSINESS_RULE', '自定义业务规则');

ALTER TABLE h_business_rule ADD developmentMode varchar(15);
comment on column h_business_rule.developmentMode is '业务规则开发模式(图形化：DEFAULT，在线编码：CODING)';