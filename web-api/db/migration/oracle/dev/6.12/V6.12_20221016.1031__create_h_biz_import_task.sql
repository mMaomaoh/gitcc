create table h_biz_import_task (
    id varchar2(120) primary key not null,
    importTime date,
    startTime date,
    endTime date,
    userId varchar2(120),
    schemaCode varchar2(200),
    taskStatus varchar2(200),
    lastHeartTime date,
    threadName varchar2(150),
    operationResultJson clob,
    originalFilename clob
);

CREATE INDEX idx_h_b_i_t_userId ON h_biz_import_task (userId);
CREATE INDEX idx_h_b_i_t_schemaCode ON h_biz_import_task (schemaCode);
CREATE INDEX idx_h_b_i_t_threadName ON h_biz_import_task (threadName);
CREATE INDEX idx_h_b_i_t_heart ON h_biz_import_task (lastHeartTime,taskStatus);
