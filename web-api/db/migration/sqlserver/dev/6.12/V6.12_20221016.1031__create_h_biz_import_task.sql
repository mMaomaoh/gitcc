CREATE TABLE h_biz_import_task (
    id nvarchar(120) NOT NULL primary key,
    importTime datetime  NULL,
    startTime datetime  NULL,
    endTime datetime  NULL,
    userId nvarchar(120)  NULL,
    schemaCode nvarchar(200)  NULL,
    taskStatus nvarchar(200)  NULL,
    lastHeartTime datetime  NULL,
    threadName nvarchar(150)  NULL,
    operationResultJson ntext,
    originalFilename ntext
)
go

CREATE INDEX idx_h_b_i_t_userId ON h_biz_import_task (userId)
go

CREATE INDEX idx_h_b_i_t_schemaCode ON h_biz_import_task (schemaCode)
go

CREATE INDEX idx_h_b_i_t_threadName ON h_biz_import_task (threadName)
go

CREATE INDEX idx_h_b_i_t_heart ON h_biz_import_task (lastHeartTime,taskStatus)
go

