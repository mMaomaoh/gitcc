package app.modules.bizbus;

import com.authine.cloudpivot.engine.spi.adapter.AbstractProtocolAdapterService;
import com.authine.cloudpivot.engine.spi.metadata.AdapterConfigParam;
import com.authine.cloudpivot.engine.spi.metadata.ProtocolAdapter;
import com.google.common.collect.Lists;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.util.Collections;
import java.util.List;

/**
 * 自定义协议适配器
 */
@Slf4j
//@Component
public class CustomDataSqlProtocolAdapterServiceImpl extends AbstractProtocolAdapterService {

    private ProtocolAdapter protocolAdapter = new ProtocolAdapter() {
        @Override
        public String getCode() {
            return "custom_data_sql";
        }

        @Override
        public String getName() {
            return "Custom Database Sql适配器";
        }

        @Override
        public AdapterConfigParam getConfig() {
            final List<AdapterConfigParam.Param> commonList = Lists.newArrayList();
            commonList.add(new AdapterConfigParam.Param(DATABASE_CONNECTION_POOL_CODE, "数据库连接池编码", "数据库连接池", true));
            return new AdapterConfigParam(Collections.emptyList(), commonList);
        }

        @Override
        public String getDescription() {
            return "Custom Database Sql Adapter";
        }
    };

    @Override
    public ProtocolAdapter getProtocolAdapter() {
        return protocolAdapter;
    }
}
