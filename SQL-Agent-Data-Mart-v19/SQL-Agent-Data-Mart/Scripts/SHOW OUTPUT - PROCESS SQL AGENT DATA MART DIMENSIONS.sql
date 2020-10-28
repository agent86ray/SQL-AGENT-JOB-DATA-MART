USE SQL_AGENT_DATA_MART
GO

DECLARE @JOB_KEY	INT;

SELECT 
	@JOB_KEY = MAX(JOB_KEY)
FROM dbo.sysjobs;

SELECT 
	job_id
,	[name]
FROM dbo.sysjobs
WHERE JOB_KEY = @JOB_KEY;

SELECT
	job_id
,	step_id
,	step_name
FROM dbo.sysjobsteps
WHERE JOB_KEY = @JOB_KEY;

SELECT 
	*
FROM dbo.JOB_CURRENT
WHERE JOB_KEY = @JOB_KEY;


