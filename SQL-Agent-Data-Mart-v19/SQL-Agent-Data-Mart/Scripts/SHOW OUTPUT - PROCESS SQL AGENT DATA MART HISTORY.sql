USE [SQL_AGENT_DATA_MART];
GO


-- View the job state from the latest run
SELECT TOP 1
	[ETL_KEY]
,	[START_DATE]
,	[END_DATE]
,	[BEGIN_INSTANCE_ID]
,	END_INSTANCE_ID
FROM [dbo].[ETL_HISTORY_LOG]
ORDER BY [ETL_KEY] DESC;


DECLARE @JOB_KEY	INT;

SELECT 
	@JOB_KEY = MAX(JOB_KEY)
FROM dbo.sysjobs;

SELECT 
	JOB_KEY
,	step_id
,	step_name
,	start_time
,	end_time
,	duration_seconds
FROM dbo.JOB_STEP_INSTANCE
WHERE JOB_KEY = @JOB_KEY

SELECT *
FROM [dbo].[JOB_STEP_DURATION]
WHERE JOB_KEY = @JOB_KEY;

SELECT *
FROM [dbo].[JOB_STEP_AVERAGE_DURATION]
WHERE JOB_KEY = @JOB_KEY;



