# 注意
dm.ini配置文件更改
# DM不支持表中同时包含聚集KEY和大字段，要使用CLOB字段，只能使用非聚集性主键
PK_WITH_CLUSTER = 0
# 屏蔽保留字admin(系统表使用)
EXCLUDE_RESERVED_WORDS = admin