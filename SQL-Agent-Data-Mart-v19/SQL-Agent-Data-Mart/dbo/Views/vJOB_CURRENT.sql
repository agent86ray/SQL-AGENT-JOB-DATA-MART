CREATE VIEW [dbo].[vJOB_CURRENT]
AS
	SELECT 
		c.[JOB_KEY]
	,	j.[name]
	,	c.[job_id]
	,	c.[JOB_STEP_COUNT]
	,	j.date_modified
	FROM [dbo].[JOB_CURRENT] c
	JOIN [dbo].[sysjobs] j
	ON j.[JOB_KEY] = c.[JOB_KEY]
	LEFT JOIN [dbo].[JOB_EXCLUDE] x
	ON x.[job_id] = j.[job_id]
	WHERE x.[name] IS NULL;
