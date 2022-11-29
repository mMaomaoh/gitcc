EXEC sp_rename 'h_workflow_trust_rule.createTime', 'createdTime', 'COLUMN' 
GO
ALTER TABLE h_workflow_trust_rule ADD remarks nvarchar(200) NULL 
GO
ALTER TABLE h_workflow_trust_rule ADD deleted bit NULL 
GO

EXEC sp_rename 'h_workflow_trust.createTime' , 'createdTime', 'COLUMN' 
GO
ALTER TABLE h_workflow_trust ADD modifier nvarchar(120) NULL 
GO
ALTER TABLE h_workflow_trust ADD modifiedTime datetime NULL 
GO
ALTER TABLE h_workflow_trust ADD remarks nvarchar(200) NULL 
GO
ALTER TABLE h_workflow_trust ADD deleted bit NULL 
GO

ALTER TABLE h_timer_job ADD triggerTime datetime NULL
GO
ALTER TABLE h_job_result ADD triggerTime datetime NULL
GO