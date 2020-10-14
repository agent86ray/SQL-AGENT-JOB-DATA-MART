CREATE VIEW [dbo].[vJOB_CURRENT]
AS
	SELECT 
		c.[JOB_KEY]
	,	j.[name]
	,	c.[job_id]
	,	c.[JOB_STEP_COUNT]
	FROM [dbo].[JOB_CURRENT] c
	JOIN [dbo].[sysjobs] j
	ON j.[JOB_KEY] = c.[JOB_KEY];
