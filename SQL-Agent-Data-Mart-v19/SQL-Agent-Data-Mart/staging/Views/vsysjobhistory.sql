CREATE VIEW [staging].[vsysjobhistory]
AS 
	WITH CTE_EXCLUDE_JOBS AS (
		SELECT [job_id]
		FROM [msdb].[dbo].[sysjobs]
		WHERE [name] IN (
			'PROCESS SQL AGENT DATA MART DIMENSIONS'
		,	'PROCESS SQL AGENT DATA MART HISTORY'
		,	'PROCESS SQL AGENT DATA MART ACTIVITY'
		)
	)

	SELECT 
		c.[JOB_KEY]
	,	c.[name]
	,	c.[JOB_STEP_COUNT]
	,	h.[instance_id]
	,	h.[job_id]
	,	h.[step_id]
	,	h.[start_time]
	,	h.[end_time]
	,	h.[duration_seconds]
	,	IIF(x.[job_id] IS NULL, 'Y', 'N') AS [INCLUDE]
	FROM [staging].[sysjobhistory] h
	JOIN [dbo].[vJOB_CURRENT] c
	ON c.[job_id] = h.[job_id]
	LEFT JOIN CTE_EXCLUDE_JOBS x
	ON x.[job_id] = h.[job_id]
	WHERE x.[job_id] IS NULL;
