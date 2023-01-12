package app.modules.orm;

import com.authine.cloudpivot.foundation.orm.spi.EngineModelService;
import com.authine.cloudpivot.foundation.orm.spi.TableNameStrategy;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

/**
 * i表物理表名拓展
 *
 * @author luoee
 * @date 2022/12/5
 */
//@Service
public class CustomTableNameStrategyImpl implements TableNameStrategy {

    private final static String ITABLE_PREFIX = "i";

    private final EngineModelService engineModelService;
    private final RedisTemplate<String, String> redisTemplate;

    public CustomTableNameStrategyImpl(EngineModelService engineModelService,
                                       @Qualifier("stringRedisTemplate") RedisTemplate<String, String> redisTemplate) {
        this.engineModelService = engineModelService;
        this.redisTemplate = redisTemplate;
    }

    /**
     * 根据编码获取表名称
     *
     * @param logicName 逻辑表名
     * @return 物理表名
     */
    private String getPhysicalTableName(String logicName) {
        String schemaCode = logicName;
        String nameSpace = getNameSpaceFromRedis(schemaCode);
        if (StringUtils.isNotEmpty(nameSpace) && !"-".equals(nameSpace)) {
            return ITABLE_PREFIX + nameSpace + String.format("_%s", schemaCode);
        }

        engineModelService.ensureInitNamespace(schemaCode);
        nameSpace = getNameSpaceFromRedis(schemaCode);
        if (StringUtils.isNotEmpty(nameSpace) && !"-".equals(nameSpace)) {
            return ITABLE_PREFIX + nameSpace + String.format("_%s", schemaCode);
        }

        return String.format("%s_%s", ITABLE_PREFIX, schemaCode);
    }

    @Override
    public String getPhysicalTableName(String logicName, String nameSpace) {
        if (StringUtils.isBlank(nameSpace)) {
            return getPhysicalTableName(logicName);
        }
        return String.format("%s_%s", ITABLE_PREFIX + nameSpace, logicName);
    }

    private String getNameSpaceFromRedis(String schemaCode) {
        return redisTemplate.opsForValue().get(schemaCode + "_NAMESPACE");
    }

}