CREATE TABLE h_source_code (
  id varchar2(120) PRIMARY KEY NOT NULL,
  code varchar2(120) NOT NULL,
  createdTime TIMESTAMP,
  creater varchar2(120),
  deleted number(1),
  modifiedTime TIMESTAMP,
  modifier varchar2(120),
  remarks varchar2(200),
  content clob,
  codeType varchar2(15),
  published number(1),
  version int,
  originalVersion int
);
comment on column h_source_code.code is '源代码编码';
comment on column h_source_code.content is '源码';
comment on column h_source_code.codeType is '源码类型';
comment on column h_source_code.published is '是否生效';
comment on column h_source_code.version is '版本号';
comment on column h_source_code.originalVersion is '源版本号';
create index idx_h_source_code_code on h_source_code (code);

CREATE TABLE h_source_code_template (
  id varchar2(120) PRIMARY KEY NOT NULL,
  code varchar2(120) NOT NULL,
  createdTime TIMESTAMP,
  creater varchar2(120),
  deleted number(1),
  modifiedTime TIMESTAMP,
  modifier varchar2(120),
  remarks varchar2(200),
  content clob,
  codeType varchar2(15),
  name varchar2(100)
);
comment on column h_source_code.version is '模板编码';
comment on column h_source_code.version is '源码';
comment on column h_source_code.version is '源码类型';
comment on column h_source_code.version is '模板名称';
create unique index idx_h_s_c_t_code on h_source_code_template (code, codeType);

INSERT INTO h_source_code_template (id, code, createdTime, creater, deleted, modifiedTime, modifier, remarks, content, codeType, name) VALUES ('2c928d4484f5cd9b0184f5d048e204dd', 'AvailableHandlerTemplate', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, '0', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, NULL, 'package com.authine.cloudpivot.engine.service.bizrule.handler;'||chr(10)||chr(10)||'import com.authine.cloudpivot.engine.service.bizrule.handler.context.Request;'||chr(10)||chr(10)||'public class SourceCodeTemplateClassName extends AvailableHandler {'||chr(10)||'    @Override'||chr(10)||'    public Object handle(Request request) {'||chr(10)||'        return super.handle(request);'||chr(10)||'    }'||chr(10)||'}'||chr(10)||'', 'BUSINESS_RULE', '默认业务规则-流程生效');
INSERT INTO h_source_code_template (id, code, createdTime, creater, deleted, modifiedTime, modifier, remarks, content, codeType, name) VALUES ('2c928d4484f5cd9b0184f5d07d4004e0', 'CancelHandlerTemplate', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, '0', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, NULL, 'package com.authine.cloudpivot.engine.service.bizrule.handler;'||chr(10)||chr(10)||'import com.authine.cloudpivot.engine.service.bizrule.handler.context.Request;'||chr(10)||chr(10)||'public class SourceCodeTemplateClassName extends CancelHandler {'||chr(10)||'    @Override'||chr(10)||'    public Object handle(Request request) {'||chr(10)||'        return super.handle(request);'||chr(10)||'    }'||chr(10)||'}'||chr(10)||'', 'BUSINESS_RULE', '默认业务规则-流程取消');
INSERT INTO h_source_code_template (id, code, createdTime, creater, deleted, modifiedTime, modifier, remarks, content, codeType, name) VALUES ('2c928d4484f5cd9b0184f5d09bb404e3', 'CreateHandlerTemplate', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, '0', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, NULL, 'package com.authine.cloudpivot.engine.service.bizrule.handler;'||chr(10)||chr(10)||'import com.authine.cloudpivot.engine.domain.runtime.BizObject;'||chr(10)||chr(10)||'public class SourceCodeTemplateClassName extends CreateHandler {'||chr(10)||'    @Override'||chr(10)||'    protected BizObject create(BizObject bizObject) {'||chr(10)||'        return super.create(bizObject);'||chr(10)||'    }'||chr(10)||'}'||chr(10)||'', 'BUSINESS_RULE', '默认业务规则-新增');
INSERT INTO h_source_code_template (id, code, createdTime, creater, deleted, modifiedTime, modifier, remarks, content, codeType, name) VALUES ('2c928d4484f5cd9b0184f5d09bbb04e5', 'DeleteHandlerTemplate', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, '0', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, NULL, 'package com.authine.cloudpivot.engine.service.bizrule.handler;'||chr(10)||chr(10)||'import com.authine.cloudpivot.engine.domain.runtime.BizObject;'||chr(10)||chr(10)||'public class SourceCodeTemplateClassName extends DeleteHandler {'||chr(10)||'    @Override'||chr(10)||'    protected void delete(BizObject bizObject) {'||chr(10)||'        super.delete(bizObject);'||chr(10)||'    }'||chr(10)||'}'||chr(10)||'', 'BUSINESS_RULE', '默认业务规则-删除');
INSERT INTO h_source_code_template (id, code, createdTime, creater, deleted, modifiedTime, modifier, remarks, content, codeType, name) VALUES ('2c928d4484f5cd9b0184f5d09bc104e7', 'GetListHandlerTemplate', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, '0', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, NULL, 'package com.authine.cloudpivot.engine.service.bizrule.handler;'||chr(10)||chr(10)||'import com.authine.cloudpivot.engine.component.query.api.Page;'||chr(10)||'import com.authine.cloudpivot.foundation.orm.api.model.BizObjectQueryObject;'||chr(10)||chr(10)||'import java.util.Map;'||chr(10)||chr(10)||'public class SourceCodeTemplateClassName extends GetListHandler {'||chr(10)||chr(10)||'    @Override'||chr(10)||'    protected Page<Map<String, Object>> getList(BizObjectQueryObject bizObjectQueryObject) {'||chr(10)||'        return super.getList(bizObjectQueryObject);'||chr(10)||'    }'||chr(10)||'}'||chr(10)||'', 'BUSINESS_RULE', '默认业务规则-获取列表');
INSERT INTO h_source_code_template (id, code, createdTime, creater, deleted, modifiedTime, modifier, remarks, content, codeType, name) VALUES ('2c928d4484f5cd9b0184f5d09bc904e9', 'LoadHandlerTemplate', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, '0', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, NULL, 'package com.authine.cloudpivot.engine.service.bizrule.handler;'||chr(10)||chr(10)||'import com.authine.cloudpivot.engine.domain.runtime.BizObject;'||chr(10)||'import com.authine.cloudpivot.foundation.orm.api.model.BizObjectOptions;'||chr(10)||chr(10)||'import java.util.Optional;'||chr(10)||chr(10)||'public class SourceCodeTemplateClassName extends LoadHandler {'||chr(10)||chr(10)||'    @Override'||chr(10)||'    protected Optional<BizObject> load(BizObject bizObject, BizObjectOptions options) {'||chr(10)||'        return super.load(bizObject, options);'||chr(10)||'    }'||chr(10)||'}'||chr(10)||'', 'BUSINESS_RULE', '默认业务规则-查询');
INSERT INTO h_source_code_template (id, code, createdTime, creater, deleted, modifiedTime, modifier, remarks, content, codeType, name) VALUES ('2c928d4484f5cd9b0184f5d09bcf04eb', 'UpdateHandlerTemplate', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, '0', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, NULL, 'package com.authine.cloudpivot.engine.service.bizrule.handler;'||chr(10)||chr(10)||'import com.authine.cloudpivot.engine.domain.runtime.BizObject;'||chr(10)||'import com.authine.cloudpivot.foundation.orm.api.model.BizObjectOptions;'||chr(10)||chr(10)||'public class SourceCodeTemplateClassName extends UpdateHandler {'||chr(10)||'    @Override'||chr(10)||'    protected Object update(BizObject bizObject, BizObjectOptions options) {'||chr(10)||'        return super.update(bizObject, options);'||chr(10)||'    }'||chr(10)||'}'||chr(10)||'', 'BUSINESS_RULE', '默认业务规则-更新');
INSERT INTO h_source_code_template (id, code, createdTime, creater, deleted, modifiedTime, modifier, remarks, content, codeType, name) VALUES ('2c928d4484fa33380184fa34d96d04d6', 'CustomizedHandlerTemplate', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, '0', TO_DATE( '2022-12-09 15:36:19', 'SYYYY-MM-DD HH24:MI:SS' ), NULL, NULL, 'package com.authine.cloudpivot.engine.service.bizrule.handler;'||chr(10)||chr(10)||'import com.authine.cloudpivot.engine.domain.runtime.BizObject;'||chr(10)||'import com.authine.cloudpivot.engine.service.bizrule.handler.context.Request;'||chr(10)||chr(10)||'import java.util.Map;'||chr(10)||chr(10)||'public class SourceCodeTemplateClassName extends BaseHandler {'||chr(10)||'    @Override'||chr(10)||'    public Object handle(Request request) {'||chr(10)||'        //获取bo'||chr(10)||'        BizObject bizObject = request.getData().getBizObject();'||chr(10)||'        //获取自定义业务规则执行参数'||chr(10)||'        Map<String, Object> param = request.getData().getCustomParams();'||chr(10)||'        //do something'||chr(10)||'        return bizObject;'||chr(10)||'    }'||chr(10)||'}'||chr(10)||'', 'BUSINESS_RULE', '自定义业务规则');

ALTER TABLE h_business_rule ADD (developmentMode varchar2(15));
comment on column h_business_rule.developmentMode is '业务规则开发模式(图形化：DEFAULT，在线编码：CODING)';