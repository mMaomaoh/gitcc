package app.modules.bizbus;

import com.authine.cloudpivot.engine.service.bizservice.BizDatabaseConnectionPoolService;
import com.authine.cloudpivot.engine.service.bizservice.BizServiceMethodService;
import com.authine.cloudpivot.engine.spi.metadata.ProtocolAdapter;
import com.authine.cloudpivot.engine.spi.metadata.vo.ServiceConfigVO;
import com.authine.cloudpivot.engine.spi.runtime.ProtocolAdapterRuntimeFactory;
import com.authine.cloudpivot.engine.spi.runtime.ProtocolAdapterRuntimeService;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * 自定义协议适配器（运行态）
 *
 * @author luoee
 * @date 2022/12/5
 */
//@Service
public class CustomDataSqlProtocolAdapterRuntimeFactory implements ProtocolAdapterRuntimeFactory {

    @Autowired
    private BizServiceMethodService bizServiceMethodService;

    @Autowired
    private BizDatabaseConnectionPoolService connectionPoolService;

    @Override
    public ProtocolAdapterRuntimeService getRuntimeService(ProtocolAdapter protocolAdapter, String bizServiceCode,
                                                           ServiceConfigVO bizServiceConfig) {
        return new CustomDataSqlProtocolAdapterRuntimeServiceImpl(bizServiceMethodService, connectionPoolService,
                bizServiceCode, bizServiceConfig);
    }

    @Override
    public String getProtocolAdapterType() {
        return "custom_data_sql";
    }

}
