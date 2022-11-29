

/* 无数据可不用执行 */


/*备份h_h_biz_perm_property数据项权限表表*/
create table if not exists h_biz_perm_property_bak select * from h_biz_perm_property p;

/***************************************新增h_biz_perm_property主表的历史数据***************************************************/
DELIMITER //
DROP PROCEDURE IF EXISTS insertPermProperty;
CREATE PROCEDURE insertPermProperty()
BEGIN
	DECLARE childPropertyCount INT DEFAULT 0;
  DECLARE groupIdCount  INT DEFAULT 0;
 	DECLARE childGroupIdCount  INT DEFAULT 0;
  DECLARE schemaCodeFirst VARCHAR(50) DEFAULT '';
	DECLARE schemaCodeMain VARCHAR(50) DEFAULT '';
	DECLARE propertyPermCount  INT DEFAULT 0;
	DECLARE done  INT DEFAULT 0;
	DECLARE taskCursor CURSOR FOR SELECT schemaCode FROM h_biz_property ;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
  OPEN taskCursor;
--                                  第一个游标循环开始
  cursor_loop:LOOP
			FETCH taskCursor INTO schemaCodeFirst ;
			IF done = 1 THEN
				LEAVE cursor_loop;
			ELSE
				SET groupIdCount= (SELECT count(*) FROM h_biz_perm_group AS g WHERE g.schemaCode = schemaCodeFirst );
				IF groupIdCount > 0 THEN
					BEGIN
						DECLARE done1  INT DEFAULT 0;
						DECLARE groupIdFist VARCHAR(50) DEFAULT '';
						DECLARE taskCursor1 CURSOR FOR SELECT id FROM h_biz_perm_group AS g WHERE g.schemaCode = schemaCodeFirst;
						DECLARE CONTINUE HANDLER FOR NOT FOUND SET done1 = 1;
						OPEN taskCursor1;
							cursor_loop1:LOOP
								FETCH taskCursor1 INTO groupIdFist ;
									IF done1 = 1 THEN
										LEAVE cursor_loop1;
									ELSE
										BEGIN
											DECLARE done2  INT DEFAULT 0;
											DECLARE propertyCodeFirst VARCHAR(50) DEFAULT '';
											DECLARE propertyName  VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL ;
											DECLARE propertyNameI18C  VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL ;
											DECLARE requiredFirst  INT DEFAULT 0;
											DECLARE propertyTypeFirst  VARCHAR(50) DEFAULT NULL;
											DECLARE time  VARCHAR(50) DEFAULT NULL;
											DECLARE propertyCount  INT DEFAULT 0;
											DECLARE taskCursor2 CURSOR FOR SELECT code FROM h_biz_property AS b WHERE b.schemaCode = schemaCodeFirst AND b.published = '1' AND b.defaultProperty='0';
											DECLARE CONTINUE HANDLER FOR NOT FOUND SET done2 = 1;
											OPEN taskCursor2;
												cursor_loop2:LOOP
													FETCH taskCursor2 INTO propertyCodeFirst;
													IF done2 =1 THEN
														LEAVE cursor_loop2;
													ELSE
														SET requiredFirst = (SELECT propertyEmpty FROM h_biz_property AS b WHERE b.schemaCode= schemaCodeFirst AND b.code = propertyCodeFirst);
														SET propertyCount = (SELECT COUNT(*) FROM h_biz_perm_property AS p WHERE p.propertyCode = propertyCodeFirst AND p.groupId = groupIdFist AND p.schemaCode = schemaCodeFirst  );
														IF propertyCount>0  THEN
															UPDATE `h_biz_perm_property` AS p SET p.required = requiredFirst WHERE p.groupId = groupIdFist AND p.bizPermType != 'CHECK';
														ELSE
															SET time = (SELECT createdTime FROM h_biz_property AS b WHERE b.schemaCode = schemaCodeFirst AND b.code = propertyCodeFirst);
															SET propertyTypeFirst = (SELECT propertyType FROM h_biz_property AS b WHERE b.schemaCode = schemaCodeFirst AND b.code = propertyCodeFirst);
															SET propertyName = (SELECT name FROM h_biz_property AS b WHERE b.schemaCode= schemaCodeFirst AND b.code = propertyCodeFirst);
															SET propertyNameI18C = (SELECT name_i18n FROM h_biz_property AS b WHERE b.schemaCode= schemaCodeFirst AND b.code = propertyCodeFirst);
															INSERT INTO h_biz_perm_property(`id`, `creater`, `createdTime`, `deleted`, `modifier`, `modifiedTime`, `remarks`, `bizPermType`, `groupId`, `name`, `name_i18n`, `propertyCode`, `propertyType`, `required`, `visible`, `writeAble`, `schemaCode`) values (replace(uuid(),"-",""),Null,time,0,Null,NULL,Null,'ADD',groupIdFist,propertyName,propertyNameI18C,propertyCodeFirst,propertyTypeFirst,requiredFirst,1,1,schemaCodeFirst);

															INSERT INTO `h_biz_perm_property`(`id`, `creater`, `createdTime`, `deleted`, `modifier`, `modifiedTime`, `remarks`, `bizPermType`, `groupId`, `name`, `name_i18n`, `propertyCode`, `propertyType`, `required`, `visible`, `writeAble`, `schemaCode`) values (replace(uuid(),"-",""),Null,time,0,Null,NULL,Null,'CHECK',groupIdFist,propertyName,propertyNameI18C,propertyCodeFirst,propertyTypeFirst,0,1,0,schemaCodeFirst);

															INSERT INTO `h_biz_perm_property`(`id`, `creater`, `createdTime`, `deleted`, `modifier`, `modifiedTime`, `remarks`, `bizPermType`, `groupId`, `name`, `name_i18n`, `propertyCode`, `propertyType`, `required`, `visible`, `writeAble`, `schemaCode`) values (replace(uuid(),"-",""),Null,time,0,Null,NULL,Null,'EDIT',groupIdFist,propertyName,propertyNameI18C,propertyCodeFirst,propertyTypeFirst,requiredFirst,1,1,schemaCodeFirst);
														END IF;
													END IF;
												END LOOP cursor_loop2;
										END;
									END IF;
							END LOOP cursor_loop1;
						CLOSE taskCursor1;
					END;
				END IF;
			END IF;
	  END LOOP cursor_loop;
   CLOSE taskCursor;
--                                  第一个游标循环结束
END;
//
DELIMITER ;
CALL  insertPermProperty();

/***************************************新增h_biz_perm_property子表的历史数据***************************************************/
DELIMITER //
DROP PROCEDURE IF EXISTS insertChildPermProperty;
CREATE PROCEDURE insertChildPermProperty()
BEGIN
	DECLARE childPropertyCount INT DEFAULT 0;
  DECLARE groupIdCount  INT DEFAULT 0;
 	DECLARE childGroupIdCount  INT DEFAULT 0;
  DECLARE schemaCodeFirst VARCHAR(50) DEFAULT '';
	DECLARE schemaCodeMain VARCHAR(50) DEFAULT '';
	DECLARE propertyPermCount  INT DEFAULT 0;
	DECLARE done  INT DEFAULT 0;
	DECLARE taskCursor CURSOR FOR SELECT code FROM h_biz_property AS b WHERE  b.propertyType = 'CHILD_TABLE' ;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
  OPEN taskCursor;
--                                  第一个游标循环开始
		cursor_loop:LOOP
			FETCH taskCursor INTO schemaCodeFirst ;
			IF done = 1 THEN
				LEAVE cursor_loop;
			ELSE
				SET groupIdCount= (SELECT count(*) FROM h_biz_perm_group AS g WHERE g.schemaCode = schemaCodeFirst );
				SET childPropertyCount= (SELECT count(*) FROM h_biz_property AS b WHERE b.schemaCode = schemaCodeFirst AND b.defaultProperty = '0' AND b.published = '1' );
				IF   childPropertyCount > 0 THEN
 					SET schemaCodeMain = (SELECT schemaCode FROM h_biz_property AS b WHERE b.code = schemaCodeFirst AND b.published = '1' AND b.propertyType = 'CHILD_TABLE' );
 					SET childGroupIdCount = (SELECT count(*) FROM h_biz_perm_group AS g WHERE g.schemaCode = schemaCodeMain );
					IF childGroupIdCount> 0 THEN
							BEGIN
									DECLARE done1  INT DEFAULT 0;
									DECLARE groupIdFist VARCHAR(50) DEFAULT '';
									DECLARE taskCursor1 CURSOR FOR SELECT id FROM h_biz_perm_group AS g WHERE g.schemaCode = schemaCodeMain ;
									DECLARE CONTINUE HANDLER FOR NOT FOUND SET done1 = 1;
									OPEN taskCursor1;
										cursor_loop1:LOOP
											FETCH taskCursor1 INTO groupIdFist ;
												IF done1 = 1 THEN
													LEAVE cursor_loop1;
												ELSE
													BEGIN
														DECLARE done2  INT DEFAULT 0;
														DECLARE propertyCodeFirst VARCHAR(50) DEFAULT '';
														DECLARE propertyName  VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL ;
														DECLARE propertyNameI18C  VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL ;
														DECLARE requiredFirst  INT DEFAULT 0;
														DECLARE propertyTypeFirst  VARCHAR(50) DEFAULT NULL;
														DECLARE time  VARCHAR(50) DEFAULT NULL;
														DECLARE propertyCount  INT DEFAULT 0;
														DECLARE taskCursor2 CURSOR FOR SELECT code FROM h_biz_property AS b WHERE b.schemaCode = schemaCodeFirst AND b.published = '1' AND b.defaultProperty='0' GROUP BY code;
														DECLARE CONTINUE HANDLER FOR NOT FOUND SET done2 = 1;
														OPEN taskCursor2;
															cursor_loop2:LOOP
																FETCH taskCursor2 INTO propertyCodeFirst;
																IF done2 =1 THEN
																	LEAVE cursor_loop2;
																ELSE
																	SET requiredFirst = (SELECT propertyEmpty FROM h_biz_property AS b WHERE b.schemaCode= schemaCodeFirst AND b.code = propertyCodeFirst);
																	SET propertyCount = (SELECT COUNT(*) FROM h_biz_perm_property AS p WHERE p.propertyCode = propertyCodeFirst AND p.groupId = groupIdFist AND p.schemaCode = schemaCodeFirst  );
																	IF propertyCount>0  THEN
																		UPDATE `h_biz_perm_property` AS p SET p.required = requiredFirst WHERE p.groupId = groupIdFist AND p.bizPermType != 'CHECK';
																	ELSE
																		SET time = (SELECT createdTime FROM h_biz_property AS b WHERE b.schemaCode = schemaCodeFirst AND b.code = propertyCodeFirst);
																		SET propertyTypeFirst = (SELECT propertyType FROM h_biz_property AS b WHERE b.schemaCode = schemaCodeFirst AND b.code = propertyCodeFirst);
																		SET propertyName = (SELECT name FROM h_biz_property AS b WHERE b.schemaCode= schemaCodeFirst AND b.code = propertyCodeFirst);
																		SET propertyNameI18C = (SELECT name_i18n FROM h_biz_property AS b WHERE b.schemaCode= schemaCodeFirst AND b.code = propertyCodeFirst);
																		INSERT INTO h_biz_perm_property(`id`, `creater`, `createdTime`, `deleted`, `modifier`, `modifiedTime`, `remarks`, `bizPermType`, `groupId`, `name`, `name_i18n`, `propertyCode`, `propertyType`, `required`, `visible`, `writeAble`, `schemaCode`) values (replace(uuid(),"-",""),Null,time,0,Null,NULL,Null,'ADD',groupIdFist,propertyName,propertyNameI18C,propertyCodeFirst,propertyTypeFirst,requiredFirst,1,1,schemaCodeFirst);

																		INSERT INTO `h_biz_perm_property`(`id`, `creater`, `createdTime`, `deleted`, `modifier`, `modifiedTime`, `remarks`, `bizPermType`, `groupId`, `name`, `name_i18n`, `propertyCode`, `propertyType`, `required`, `visible`, `writeAble`, `schemaCode`) values (replace(uuid(),"-",""),Null,time,0,Null,NULL,Null,'CHECK',groupIdFist,propertyName,propertyNameI18C,propertyCodeFirst,propertyTypeFirst,0,1,0,schemaCodeFirst);

																		INSERT INTO `h_biz_perm_property`(`id`, `creater`, `createdTime`, `deleted`, `modifier`, `modifiedTime`, `remarks`, `bizPermType`, `groupId`, `name`, `name_i18n`, `propertyCode`, `propertyType`, `required`, `visible`, `writeAble`, `schemaCode`) values (replace(uuid(),"-",""),Null,time,0,Null,NULL,Null,'EDIT',groupIdFist,propertyName,propertyNameI18C,propertyCodeFirst,propertyTypeFirst,requiredFirst,1,1,schemaCodeFirst);
																	END IF;
																END IF;
															END LOOP cursor_loop2;
													END;
												END IF;
										END LOOP cursor_loop1;
									CLOSE taskCursor1;
							END;

 					END IF;
				END IF;
			END IF;
	  END LOOP cursor_loop;
  CLOSE taskCursor;
--                                  第一个游标循环结束
END;
//
DELIMITER ;
CALL  insertChildPermProperty();
#
# Quartz seems to work best with the driver mm.mysql-2.0.7-bin.jar
#
# PLEASE consider using mysql with innodb tables to avoid locking issues
#
# In your Quartz properties file, you'll need to set
# org.quartz.jobStore.driverDelegateClass = org.quartz.impl.jdbcjobstore.StdJDBCDelegate
#

#DROP TABLE IF EXISTS QRTZ_FIRED_TRIGGERS;
#DROP TABLE IF EXISTS QRTZ_PAUSED_TRIGGER_GRPS;
#DROP TABLE IF EXISTS QRTZ_SCHEDULER_STATE;
#DROP TABLE IF EXISTS QRTZ_LOCKS;
#DROP TABLE IF EXISTS QRTZ_SIMPLE_TRIGGERS;
#DROP TABLE IF EXISTS QRTZ_SIMPROP_TRIGGERS;
#DROP TABLE IF EXISTS QRTZ_CRON_TRIGGERS;
#DROP TABLE IF EXISTS QRTZ_BLOB_TRIGGERS;
#DROP TABLE IF EXISTS QRTZ_TRIGGERS;
#DROP TABLE IF EXISTS QRTZ_JOB_DETAILS;
#DROP TABLE IF EXISTS QRTZ_CALENDARS;


CREATE TABLE IF NOT EXISTS QRTZ_JOB_DETAILS
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    JOB_NAME  VARCHAR(200) NOT NULL,
    JOB_GROUP VARCHAR(200) NOT NULL,
    DESCRIPTION VARCHAR(250) NULL,
    JOB_CLASS_NAME   VARCHAR(250) NOT NULL,
    IS_DURABLE VARCHAR(1) NOT NULL,
    IS_NONCONCURRENT VARCHAR(1) NOT NULL,
    IS_UPDATE_DATA VARCHAR(1) NOT NULL,
    REQUESTS_RECOVERY VARCHAR(1) NOT NULL,
    JOB_DATA BLOB NULL,
    PRIMARY KEY (SCHED_NAME,JOB_NAME,JOB_GROUP)
);

CREATE TABLE IF NOT EXISTS QRTZ_TRIGGERS
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    TRIGGER_NAME VARCHAR(200) NOT NULL,
    TRIGGER_GROUP VARCHAR(200) NOT NULL,
    JOB_NAME  VARCHAR(200) NOT NULL,
    JOB_GROUP VARCHAR(200) NOT NULL,
    DESCRIPTION VARCHAR(250) NULL,
    NEXT_FIRE_TIME BIGINT(13) NULL,
    PREV_FIRE_TIME BIGINT(13) NULL,
    PRIORITY INTEGER NULL,
    TRIGGER_STATE VARCHAR(16) NOT NULL,
    TRIGGER_TYPE VARCHAR(8) NOT NULL,
    START_TIME BIGINT(13) NOT NULL,
    END_TIME BIGINT(13) NULL,
    CALENDAR_NAME VARCHAR(200) NULL,
    MISFIRE_INSTR SMALLINT(2) NULL,
    JOB_DATA BLOB NULL,
    PRIMARY KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP),
    FOREIGN KEY (SCHED_NAME,JOB_NAME,JOB_GROUP)
        REFERENCES QRTZ_JOB_DETAILS(SCHED_NAME,JOB_NAME,JOB_GROUP)
);

CREATE TABLE IF NOT EXISTS QRTZ_SIMPLE_TRIGGERS
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    TRIGGER_NAME VARCHAR(200) NOT NULL,
    TRIGGER_GROUP VARCHAR(200) NOT NULL,
    REPEAT_COUNT BIGINT(7) NOT NULL,
    REPEAT_INTERVAL BIGINT(12) NOT NULL,
    TIMES_TRIGGERED BIGINT(10) NOT NULL,
    PRIMARY KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP),
    FOREIGN KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
        REFERENCES QRTZ_TRIGGERS(SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
);

CREATE TABLE IF NOT EXISTS QRTZ_CRON_TRIGGERS
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    TRIGGER_NAME VARCHAR(200) NOT NULL,
    TRIGGER_GROUP VARCHAR(200) NOT NULL,
    CRON_EXPRESSION VARCHAR(200) NOT NULL,
    TIME_ZONE_ID VARCHAR(80),
    PRIMARY KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP),
    FOREIGN KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
        REFERENCES QRTZ_TRIGGERS(SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
);

CREATE TABLE IF NOT EXISTS QRTZ_SIMPROP_TRIGGERS
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    TRIGGER_NAME VARCHAR(200) NOT NULL,
    TRIGGER_GROUP VARCHAR(200) NOT NULL,
    STR_PROP_1 VARCHAR(512) NULL,
    STR_PROP_2 VARCHAR(512) NULL,
    STR_PROP_3 VARCHAR(512) NULL,
    INT_PROP_1 INT NULL,
    INT_PROP_2 INT NULL,
    LONG_PROP_1 BIGINT NULL,
    LONG_PROP_2 BIGINT NULL,
    DEC_PROP_1 NUMERIC(13,4) NULL,
    DEC_PROP_2 NUMERIC(13,4) NULL,
    BOOL_PROP_1 VARCHAR(1) NULL,
    BOOL_PROP_2 VARCHAR(1) NULL,
    PRIMARY KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP),
    FOREIGN KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
    REFERENCES QRTZ_TRIGGERS(SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
);

CREATE TABLE IF NOT EXISTS QRTZ_BLOB_TRIGGERS
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    TRIGGER_NAME VARCHAR(200) NOT NULL,
    TRIGGER_GROUP VARCHAR(200) NOT NULL,
    BLOB_DATA BLOB NULL,
    PRIMARY KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP),
    FOREIGN KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
        REFERENCES QRTZ_TRIGGERS(SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
);

CREATE TABLE IF NOT EXISTS QRTZ_CALENDARS
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    CALENDAR_NAME  VARCHAR(200) NOT NULL,
    CALENDAR BLOB NOT NULL,
    PRIMARY KEY (SCHED_NAME,CALENDAR_NAME)
);

CREATE TABLE IF NOT EXISTS QRTZ_PAUSED_TRIGGER_GRPS
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    TRIGGER_GROUP  VARCHAR(200) NOT NULL,
    PRIMARY KEY (SCHED_NAME,TRIGGER_GROUP)
);

CREATE TABLE IF NOT EXISTS QRTZ_FIRED_TRIGGERS
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    ENTRY_ID VARCHAR(95) NOT NULL,
    TRIGGER_NAME VARCHAR(200) NOT NULL,
    TRIGGER_GROUP VARCHAR(200) NOT NULL,
    INSTANCE_NAME VARCHAR(200) NOT NULL,
    FIRED_TIME BIGINT(13) NOT NULL,
    SCHED_TIME BIGINT(13) NOT NULL,
    PRIORITY INTEGER NOT NULL,
    STATE VARCHAR(16) NOT NULL,
    JOB_NAME VARCHAR(200) NULL,
    JOB_GROUP VARCHAR(200) NULL,
    IS_NONCONCURRENT VARCHAR(1) NULL,
    REQUESTS_RECOVERY VARCHAR(1) NULL,
    PRIMARY KEY (SCHED_NAME,ENTRY_ID)
);

CREATE TABLE IF NOT EXISTS QRTZ_SCHEDULER_STATE
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    INSTANCE_NAME VARCHAR(200) NOT NULL,
    LAST_CHECKIN_TIME BIGINT(13) NOT NULL,
    CHECKIN_INTERVAL BIGINT(13) NOT NULL,
    PRIMARY KEY (SCHED_NAME,INSTANCE_NAME)
);

CREATE TABLE IF NOT EXISTS QRTZ_LOCKS
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    LOCK_NAME  VARCHAR(40) NOT NULL,
    PRIMARY KEY (SCHED_NAME,LOCK_NAME)
);

CREATE INDEX IDX_QRTZ_J_REQ_RECOVERY ON QRTZ_JOB_DETAILS(SCHED_NAME,REQUESTS_RECOVERY);
CREATE INDEX IDX_QRTZ_J_GRP ON QRTZ_JOB_DETAILS(SCHED_NAME,JOB_GROUP);
CREATE INDEX IDX_QRTZ_T_J ON QRTZ_TRIGGERS(SCHED_NAME,JOB_NAME,JOB_GROUP);
CREATE INDEX IDX_QRTZ_T_JG ON QRTZ_TRIGGERS(SCHED_NAME,JOB_GROUP);
CREATE INDEX IDX_QRTZ_T_C ON QRTZ_TRIGGERS(SCHED_NAME,CALENDAR_NAME);
CREATE INDEX IDX_QRTZ_T_G ON QRTZ_TRIGGERS(SCHED_NAME,TRIGGER_GROUP);
CREATE INDEX IDX_QRTZ_T_STATE ON QRTZ_TRIGGERS(SCHED_NAME,TRIGGER_STATE);
CREATE INDEX IDX_QRTZ_T_N_STATE ON QRTZ_TRIGGERS(SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP,TRIGGER_STATE);
CREATE INDEX IDX_QRTZ_T_N_G_STATE ON QRTZ_TRIGGERS(SCHED_NAME,TRIGGER_GROUP,TRIGGER_STATE);
CREATE INDEX IDX_QRTZ_T_NEXT_FIRE_TIME ON QRTZ_TRIGGERS(SCHED_NAME,NEXT_FIRE_TIME);
CREATE INDEX IDX_QRTZ_T_NFT_ST ON QRTZ_TRIGGERS(SCHED_NAME,TRIGGER_STATE,NEXT_FIRE_TIME);
CREATE INDEX IDX_QRTZ_T_NFT_MISFIRE ON QRTZ_TRIGGERS(SCHED_NAME,MISFIRE_INSTR,NEXT_FIRE_TIME);
CREATE INDEX IDX_QRTZ_T_NFT_ST_MISFIRE ON QRTZ_TRIGGERS(SCHED_NAME,MISFIRE_INSTR,NEXT_FIRE_TIME,TRIGGER_STATE);
CREATE INDEX IDX_QRTZ_T_NFT_ST_MISFIRE_GRP ON QRTZ_TRIGGERS(SCHED_NAME,MISFIRE_INSTR,NEXT_FIRE_TIME,TRIGGER_GROUP,TRIGGER_STATE);
CREATE INDEX IDX_QRTZ_FT_TRIG_INST_NAME ON QRTZ_FIRED_TRIGGERS(SCHED_NAME,INSTANCE_NAME);
CREATE INDEX IDX_QRTZ_FT_INST_JOB_REQ_RCVRY ON QRTZ_FIRED_TRIGGERS(SCHED_NAME,INSTANCE_NAME,REQUESTS_RECOVERY);
CREATE INDEX IDX_QRTZ_FT_J_G ON QRTZ_FIRED_TRIGGERS(SCHED_NAME,JOB_NAME,JOB_GROUP);
CREATE INDEX IDX_QRTZ_FT_JG ON QRTZ_FIRED_TRIGGERS(SCHED_NAME,JOB_GROUP);
CREATE INDEX IDX_QRTZ_FT_T_G ON QRTZ_FIRED_TRIGGERS(SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP);
CREATE INDEX IDX_QRTZ_FT_TG ON QRTZ_FIRED_TRIGGERS(SCHED_NAME,TRIGGER_GROUP);

COMMIT;
CREATE TABLE `h_form_comment` (
    `id` varchar(42) COLLATE utf8_bin NOT NULL,
    `content` varchar(3000) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '评论内容',
    `commentator` varchar(42) COLLATE utf8_bin NOT NULL COMMENT '评论人id',
    `commentatorName` varchar(80) CHARACTER SET utf8mb4 NOT NULL COMMENT '评论人名称',
    `departmentId` varchar(42) COLLATE utf8_bin DEFAULT NULL COMMENT '评论人部门id',
    `schemaCode` varchar(42) COLLATE utf8_bin NOT NULL COMMENT '模型编码',
    `bizObjectId` varchar(42) COLLATE utf8_bin NOT NULL COMMENT '表单id',
    `replyCommentId` varchar(42) COLLATE utf8_bin DEFAULT NULL COMMENT '被回复的评论id',
    `replyUserId` varchar(42) COLLATE utf8_bin DEFAULT NULL COMMENT '被回复的用户id',
    `replyUserName` varchar(80) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '被回复的用户名称',
    `originCommentId` varchar(42) COLLATE utf8_bin DEFAULT NULL COMMENT '最原始的评论id',
    `floor` int(11) NOT NULL DEFAULT '0' COMMENT '评论层级，最原始评论从0开始',
    `state` varchar(20) COLLATE utf8_bin NOT NULL DEFAULT 'ENABLED' COMMENT '评论状态，可用：ENABLED；禁用：DISABLED；',
    `deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否被删除，0：否；1：是',
    `attachmentNum` int(11) NOT NULL DEFAULT '0' COMMENT '附件数量',
    `modifier` varchar(42) COLLATE utf8_bin DEFAULT NULL COMMENT '删除/更新用户id',
    `createdTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '数据创建时间',
    `modifiedTime` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '删除/更新时间',
    PRIMARY KEY (`id`),
    KEY `IDX_FORM_OBJ_ID` (`bizObjectId`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='表单评论表';

CREATE TABLE `h_from_comment_attachment` (
    `id` varchar(42) COLLATE utf8_bin NOT NULL,
    `bizObjectId` varchar(42) COLLATE utf8_bin NOT NULL COMMENT '表单id',
    `schemaCode` varchar(42) COLLATE utf8_bin NOT NULL COMMENT '模型编码',
    `commentId` varchar(42) COLLATE utf8_bin NOT NULL COMMENT '评论id',
    `fileExtension` varchar(30) COLLATE utf8_bin DEFAULT NULL COMMENT '文件后缀名',
    `fileSize` int(11) NOT NULL DEFAULT '0' COMMENT '文件大小',
    `mimeType` varchar(50) COLLATE utf8_bin NOT NULL COMMENT '文件媒体类型',
    `name` varchar(255) COLLATE utf8_bin NOT NULL COMMENT '文件名称，带后缀',
    `refId` varchar(80) COLLATE utf8_bin NOT NULL COMMENT '上传到文件系统的文件id',
    `createdTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '上传时间',
    `creater` varchar(42) COLLATE utf8_bin NOT NULL COMMENT '上传用户id',
    PRIMARY KEY (`id`),
    KEY `IDX_F_C_A_COMM_ID` (`commentId`),
    KEY `IDX_F_C_A_REF_ID` (`refId`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='表单评论附件表';



ALTER TABLE `h_form_comment` ADD COLUMN `text` varchar(5000) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '评论内容html格式';


ALTER TABLE `h_biz_property` ADD COLUMN `relativePropertyCode` varchar(40) COLLATE utf8_bin DEFAULT NULL COMMENT '关联表单显示字段';


alter table `h_biz_attachment` add index idx_h_biz_attachment_bizObjectId(`bizObjectId`);
alter table `h_biz_attachment` modify column parentBizObjectId varchar(36) default '';
alter table `h_biz_attachment` add index idx_h_biz_attachment_parentBizObjectId(`parentBizObjectId`);


ALTER TABLE h_im_work_record MODIFY COLUMN `content` varchar(3000) default '';
ALTER TABLE h_im_work_record_history MODIFY COLUMN `content` varchar(3000) default '';
/* 无数据可不用执行 */


/*备份h_biz_query_column  列表展示项表*/
create table if not exists h_biz_query_column_bak select * from h_biz_query_column c;

/***************************************新增h_biz_query_column 子表的历史数据***************************************************/
DELIMITER //
DROP PROCEDURE IF EXISTS insertBizQueryColumn;
CREATE PROCEDURE insertBizQueryColumn()
BEGIN
	DECLARE childSchemaCount INT DEFAULT 0;
	DECLARE schemaCodeFirst VARCHAR(50) DEFAULT '';
	DECLARE done  INT DEFAULT 0;
	DECLARE taskCursor CURSOR FOR SELECT code FROM h_biz_property AS p WHERE  p.published='1' AND p.propertyType = 'CHILD_TABLE' GROUP BY code;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
  OPEN taskCursor;
--                                  第一个游标循环开始
		cursor_loop:LOOP
			FETCH taskCursor INTO schemaCodeFirst ;
			IF done = 1 THEN
				LEAVE cursor_loop;
			ELSE
				SET childSchemaCount= (SELECT count(*) FROM h_biz_query_column AS c WHERE c.propertyCode = schemaCodeFirst );
				IF   childSchemaCount > 0 THEN
					BEGIN
						DECLARE done2  INT DEFAULT 0;
						DECLARE queryIdFirst VARCHAR(50) DEFAULT '';
						DECLARE taskCursor2 CURSOR FOR SELECT queryId FROM h_biz_query_column AS c WHERE c.propertyCode = schemaCodeFirst GROUP BY queryId;
						DECLARE CONTINUE HANDLER FOR NOT FOUND SET done2 = 1;
						OPEN taskCursor2;
							cursor_loop2:LOOP
								FETCH taskCursor2 INTO queryIdFirst;
								IF done2 =1 THEN
									LEAVE cursor_loop2;
								ELSE
									BEGIN
										DECLARE propertyCodeFirst VARCHAR(50) DEFAULT '';
										DECLARE propertyCount  INT DEFAULT 0;
										DECLARE done3  INT DEFAULT 0;
										DECLARE taskCursor3 CURSOR FOR SELECT code FROM h_biz_property AS p WHERE p.schemaCode = schemaCodeFirst AND p.published = '1' AND p.defaultProperty='0' GROUP BY code ;
										DECLARE CONTINUE HANDLER FOR NOT FOUND SET done3 = 1;
										OPEN taskCursor3;
											cursor_loop3:LOOP
												FETCH taskCursor3 INTO propertyCodeFirst;
												IF done3 =1 THEN
													LEAVE cursor_loop3;
												ELSE
													SET propertyCount = (SELECT count(*) FROM h_biz_query_column AS c WHERE c.schemaCode = schemaCodeFirst  AND c.propertyCode= propertyCodeFirst AND c.queryId = queryIdFirst);
													IF  propertyCount = 0 THEN
															BEGIN
																DECLARE sortKeyFirst INT DEFAULT 1;
																DECLARE propertyName  VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL ;
																DECLARE propertyNameI18C  VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL ;
																DECLARE propertyTypeFirst  VARCHAR(50) DEFAULT NULL;
																DECLARE modifyTime  datetime DEFAULT NULL;
																DECLARE createTime  datetime DEFAULT NULL;
																DECLARE done4  INT DEFAULT 0;
																DECLARE clientTypeFirst VARCHAR(50) DEFAULT NULL;
																DECLARE taskCursor4 CURSOR FOR SELECT clientType FROM h_biz_query_column  AS c WHERE c.propertyCode = schemaCodeFirst AND c.queryId = queryIdFirst ;
																DECLARE CONTINUE HANDLER FOR NOT FOUND SET done4 = 1;
																OPEN taskCursor4;
																	cursor_loop4:LOOP
																		FETCH taskCursor4 INTO clientTypeFirst;
																		IF done4 =1 THEN
																			LEAVE cursor_loop4;
																		ELSE
																			SET modifyTime = (SELECT modifiedTime FROM h_biz_property  AS p WHERE p.schemaCode = schemaCodeFirst  AND p.code= propertyCodeFirst);
																			SET propertyName = (SELECT name FROM h_biz_property  AS p WHERE p.schemaCode = schemaCodeFirst  AND p.code= propertyCodeFirst);
																			SET propertyTypeFirst = (SELECT propertyType FROM h_biz_property  AS p WHERE p.schemaCode = schemaCodeFirst  AND p.code= propertyCodeFirst);
																			SET propertyNameI18C = (SELECT name_i18n FROM h_biz_property  AS p  WHERE p.schemaCode = schemaCodeFirst  AND p.code= propertyCodeFirst);
																			SET sortKeyFirst = (SELECT sortKey FROM h_biz_property  AS p WHERE p.schemaCode = schemaCodeFirst  AND p.code= propertyCodeFirst);
																			INSERT INTO `h_biz_query_column`
																			(`id` ,
																			`creater` ,`createdTime` ,`deleted` ,`modifier` ,`modifiedTime` ,`remarks` ,`isSystem` ,`name` ,`propertyCode` ,`propertyType` ,`queryId` ,`schemaCode` ,`sortKey` ,`sumType` ,`unit` ,`width` ,`displayFormat` ,`name_i18n` ,`clientType` )
																			values
																			(replace(uuid(),"-",""),Null,NULL,0,modifyTime,Null,NULL,NULL,propertyName,propertyCodeFirst,propertyTypeFirst,
																				queryIdFirst,schemaCodeFirst,sortKeyFirst,'STATISTICS',0,162,2,propertyNameI18C,clientTypeFirst);
																		END IF;
																	END LOOP cursor_loop4;
																CLOSE taskCursor4;
															END;
													END IF;
												END IF;
											END LOOP cursor_loop3;
										CLOSE taskCursor3;
									END;
								END IF;
							END LOOP cursor_loop2;
						CLOSE taskCursor2;
					END;
				END IF;
			END IF;
		END LOOP cursor_loop;
  CLOSE taskCursor;
END;
//
DELIMITER ;
CALL  insertBizQueryColumn();





ALTER TABLE `h_org_user` ADD COLUMN `dingUserJson` longtext COMMENT '钉钉同步过来的json数据记录';
ALTER TABLE `h_org_user` MODIFY `dingUserJson` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL ;
CREATE TABLE `h_related_corp_setting` (
    `id` varchar(120)  NOT NULL,
    `creater` varchar(120)  DEFAULT NULL,
    `createdTime` datetime DEFAULT NULL,
    `deleted` bit(1) DEFAULT NULL,
    `modifier` varchar(120)  DEFAULT NULL,
    `modifiedTime` datetime DEFAULT NULL,
    `remarks` varchar(200)  DEFAULT NULL,
    `agentId` varchar(120)  DEFAULT NULL,
    `appSecret` varchar(120) CHARACTER SET utf8mb4  DEFAULT NULL,
    `appkey` varchar(120)  DEFAULT NULL,
    `corpId` varchar(120) CHARACTER SET utf8mb4  DEFAULT NULL COMMENT '组织的corpId',
    `corpSecret` varchar(120) CHARACTER SET utf8mb4  DEFAULT NULL COMMENT '组织的corpSecret',
    `exportHost` varchar(32) CHARACTER SET utf8mb4  DEFAULT NULL COMMENT '多机器转发的地址',
    `extend1` varchar(120)  DEFAULT NULL,
    `extend2` varchar(120)  DEFAULT NULL,
    `extend3` varchar(120)  DEFAULT NULL,
    `extend4` varchar(120)  DEFAULT NULL,
    `extend5` varchar(120)  DEFAULT NULL,
    `headerNum` int(11) NOT NULL COMMENT ' 企业标记，用于部门sourceid',
    `name` varchar(64) CHARACTER SET utf8mb4  DEFAULT NULL COMMENT '公司名称',
    `orgType` varchar(12) CHARACTER SET utf8mb4  DEFAULT NULL COMMENT '第三方类型',
    `relatedType` varchar(12) CHARACTER SET utf8mb4  DEFAULT NULL COMMENT '组织类型',
    `scanAppId` varchar(120) CHARACTER SET utf8mb4  DEFAULT NULL COMMENT '扫码登录appid',
    `scanAppSecret` varchar(120) CHARACTER SET utf8mb4  DEFAULT NULL COMMENT '扫码登录Secret',
    `redirectUri` varchar(128) CHARACTER SET utf8mb4  DEFAULT NULL COMMENT '登录回调地址',
    `synRedirectUri` varchar(128) CHARACTER SET utf8mb4  DEFAULT NULL COMMENT '增量回调地址',
    `pcServerUrl` varchar(128) CHARACTER SET utf8mb4  DEFAULT NULL COMMENT 'pc端地址',
    `mobileServerUrl` varchar(128) CHARACTER SET utf8mb4  DEFAULT NULL COMMENT '手机端地址',
    `syncType` varchar(12) CHARACTER SET utf8mb4  DEFAULT NULL COMMENT '同步方式',
    PRIMARY KEY (`id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_croatian_ci;


-- 用户新增组织外键关联
ALTER TABLE `h_org_user`
    ADD COLUMN `corpId` varchar(256) NULL DEFAULT NULL;
-- 角色组新增组织外键关联
ALTER TABLE `h_org_role_group`
    ADD COLUMN `corpId` varchar(256) NULL DEFAULT NULL;
-- 角色新增组织外键关联
ALTER TABLE `h_org_role`
    ADD COLUMN `corpId` varchar(256) NULL DEFAULT NULL;
-- 部门新增组织外键关联
ALTER TABLE `h_org_department`
    ADD COLUMN `corpId` varchar(256) NULL DEFAULT NULL;
-- 部门历史新增组织外键关联
ALTER TABLE `h_org_department_history`
    ADD COLUMN `corpId` varchar(256) NULL DEFAULT NULL;

CREATE TABLE IF NOT EXISTS `h_org_synchronize_log`(
  `id` varchar(120) NOT NULL,
  `targetType` varchar(30) DEFAULT NULL COMMENT '同步类型 部门|用户|角色|某个部门|某个角色用户',
  `trackId` varchar(60) DEFAULT NULL COMMENT '同步批次',
  `targetId` varchar(120) DEFAULT NULL COMMENT '目标源数据',
  `errorType` varchar(1000) DEFAULT NULL COMMENT '错误原因',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `h_biz_sheet` ADD COLUMN `formComment` bit(1) DEFAULT 0 COMMENT '是否开启表单评论';

-- 部门
ALTER TABLE `h_org_department` DROP INDEX `UK_m8jlxslrsucu3y6dv1lb1s5jf`;

-- 用户
ALTER TABLE `h_org_user` DROP INDEX `UK_phr7by4273l3804n3xc2gq15o`;

-- 角色
ALTER TABLE `h_org_role` DROP INDEX `UK_itk9w9ftn6a2vn5o8c7n83ymc`;

CREATE TABLE `h_biz_export_task` (
    `id` varchar(36) COLLATE utf8_bin NOT NULL COMMENT 'primary key',
    `startTime` datetime DEFAULT NULL COMMENT '开始时间',
    `endTime` datetime DEFAULT NULL COMMENT '结束时间',
    `message` varchar(4000) COLLATE utf8_bin DEFAULT NULL COMMENT '失败信息',
    `taskStatus` varchar(50) COLLATE utf8_bin DEFAULT NULL COMMENT '任务状态',
    `syncResult` varchar(50) COLLATE utf8_bin DEFAULT NULL COMMENT '同步结果',
    `userId` varchar(36) COLLATE utf8_bin DEFAULT NULL COMMENT '谁同步的',
    `createdTime` datetime DEFAULT NULL COMMENT '生成时间',
    `creater` varchar(120) COLLATE utf8_bin DEFAULT NULL COMMENT '创建者',
    `deleted` bit(1) DEFAULT NULL COMMENT '是否删除',
    `modifiedTime` datetime DEFAULT NULL COMMENT '修改时间' ,
    `modifier` varchar(120) COLLATE utf8_bin DEFAULT NULL COMMENT '修改者',
    `remarks` varchar(200) COLLATE utf8_bin DEFAULT NULL COMMENT '备注信息',
    PRIMARY KEY (`id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

ALTER TABLE `h_biz_export_task` CHANGE `syncResult` `exportResultStatus` varchar(50) COLLATE utf8_bin DEFAULT NULL COMMENT '同步结果';

ALTER TABLE `h_biz_export_task` ADD COLUMN `path` varchar(120) DEFAULT NULL COMMENT '文件路径';

-- 删除部门用户关联重复项 保留最旧的记录
delete from h_org_dept_user where id in(
    select a.id from (
                         select hodu.id from h_org_dept_user hodu where hodu.id in(
                             select a.id from h_org_dept_user a
                                                  LEFT JOIN
                                              (
                                                  select count(a.userId) num,a.deptId,a.userId,MIN(a.createdTime) from h_org_dept_user a GROUP BY a.deptId,a.userId having num > 1
                                              ) b on a.deptId = b.deptId and a.userId = b.userId
                             where b.num is not null
                         ) and hodu.id not in(
                             select  a.id from h_org_dept_user a
                                                   LEFT JOIN
                                               (
                                                   select count(a.userId) num,a.deptId,a.userId,MIN(a.createdTime) minTime from h_org_dept_user a GROUP BY a.deptId,a.userId having num > 1
                                               ) b on a.deptId = b.deptId and a.userId = b.userId and a.createdTime = b.minTime
                             where b.num is not null
                         )
                     ) a
);
-- 建立部门用户联合唯一索引
ALTER TABLE `h_org_dept_user`
DROP INDEX `idx_dept_user_composeid`,
    ADD UNIQUE INDEX `idx_dept_user_composeid`(`userId`, `deptId`) USING BTREE;

-- 删除角色用户关联重复项 保留最旧的记录
delete from h_org_role_user where id in(
    select a.id from (
                         select hodu.id from h_org_role_user hodu where hodu.id in(
                             select a.id from h_org_role_user a
                                                  LEFT JOIN
                                              (
                                                  select count(a.userId) num,a.roleId,a.userId,MIN(a.createdTime) from h_org_role_user a GROUP BY a.roleId,a.userId having num > 1
                                              ) b on a.roleId = b.roleId and a.userId = b.userId
                             where b.num is not null
                         ) and hodu.id not in(
                             select  a.id from h_org_role_user a
                                                   LEFT JOIN
                                               (
                                                   select count(a.userId) num,a.roleId,a.userId,MIN(a.createdTime) minTime from h_org_role_user a GROUP BY a.roleId,a.userId having num > 1
                                               ) b on a.roleId = b.roleId and a.userId = b.userId and a.createdTime = b.minTime
                             where b.num is not null
                         )
                     ) a
);

-- 建立角色用户联合唯一索引
ALTER TABLE `h_org_role_user` ADD UNIQUE INDEX `idx_role_user_composeid`(`userId`, `roleId`) USING BTREE;


-- 字段调整为用户主键
update d_process_task,h_org_user set d_process_task.userId = h_org_user.id where h_org_user.userId = d_process_task.userId;

update d_process_instance,h_org_user set d_process_instance.originator = h_org_user.id where h_org_user.userId = d_process_instance.originator;


DROP PROCEDURE IF EXISTS updateCorpIdIsNull;

DELIMITER //

CREATE PROCEDURE updateCorpIdIsNull()
BEGIN

    DECLARE MY_CORPID VARCHAR(50);
    DECLARE IS_CLOUD_PIVOT VARCHAR(50);

    SET MY_CORPID = (select hss.paramValue from h_system_setting hss where hss.paramCode = 'dingtalk.client.corpId');
    if MY_CORPID is not null then
    update h_org_user set corpId = MY_CORPID where corpId is null;
    update h_org_department set corpId = MY_CORPID where corpId is null;
    update h_org_role set corpId = MY_CORPID where corpId is null;
    update h_org_role_group set corpId = MY_CORPID where corpId is null;
    else
    SET IS_CLOUD_PIVOT = (select hss.paramValue from h_system_setting hss where hss.paramCode = 'cloudpivot.load.is_cloud_pivot');
    if IS_CLOUD_PIVOT = '1' then
        update h_org_user set corpId = 'main' where corpId is null;
        update h_org_department set corpId = 'main' where corpId is null;
        update h_org_role set corpId = 'main' where corpId is null;
        update h_org_role_group set corpId = 'main' where corpId is null;
    end if;
end if;

END;
//

DELIMITER ;

CALL updateCorpIdIsNull();


ALTER TABLE `h_biz_sheet` MODIFY COLUMN `tempAuthSchemaCodes` varchar(3500) DEFAULT NULL COMMENT '临时授权的SchemaCode 以,分割';
