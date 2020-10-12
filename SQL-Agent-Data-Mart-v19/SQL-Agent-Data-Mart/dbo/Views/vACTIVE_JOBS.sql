CREATE VIEW [dbo].[vACTIVE_JOBS]
AS
	SELECT 
		[REFRESH_KEY]
	,	COALESCE(j.[name], CONVERT(NVARCHAR(128), a.[job_id])) AS [JobName]
	,	[CURRENT_DURATION]
	,	[EXECUTION_COUNT]
	,	[AVERAGE_DURATION]
	,	[ESTIMATED_COMPLETION]
	FROM [dbo].[ACTIVE_JOBS] a
	JOIN [dbo].[JOB_CURRENT] c 
	ON c.[job_id] = a.[job_id]
	JOIN [dbo].[sysjobs] j
	ON j.[JOB_KEY] = c.[JOB_KEY]
	WHERE [REFRESH_KEY] = (
		SELECT 
			MAX([REFRESH_KEY])
		FROM [dbo].[ACTIVE_JOBS_REFRESH]
	);
