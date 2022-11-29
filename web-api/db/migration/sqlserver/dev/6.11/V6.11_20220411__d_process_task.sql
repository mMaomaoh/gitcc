ALTER TABLE d_process_task ALTER COLUMN processInstanceId nvarchar(64) NULL;
ALTER TABLE d_process_task ALTER COLUMN taskId nvarchar(50) NOT NULL;
GO