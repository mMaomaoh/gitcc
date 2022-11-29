-- h_user_common_query表增加filterFixed字段
ALTER TABLE h_user_common_query ADD COLUMN filterFixed bit(1) DEFAULT 0 COMMENT '窗口是否固定 1：固定 0：不固定';
ALTER TABLE h_user_common_query ADD COLUMN conditionType bit(1) DEFAULT 0 COMMENT '条件类型 1：全部 0：任一';
