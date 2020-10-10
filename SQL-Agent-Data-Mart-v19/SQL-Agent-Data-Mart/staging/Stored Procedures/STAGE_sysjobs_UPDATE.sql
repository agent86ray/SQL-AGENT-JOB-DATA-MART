CREATE PROCEDURE [staging].[STAGE_sysjobs_UPDATE]
AS
BEGIN
	/*
		Compare each job_id in the [staging].[sysjobs] table with the latest job_id row in the [dbo].[sysjobs] table 
		and determine if it should be inserted or updated in the [dbo].[sysjobs] table. It could also be no change.
	*/

	TRUNCATE TABLE [staging].[sysjobs_UPDATE];

	;WITH CTE_sysjobs_DIMENSIONS AS (
		SELECT
			[JOB_KEY]
		,	[job_id]
		,	[date_modified]
		,	ROW_NUMBER() OVER (
				PARTITION BY [job_id], [date_modified]
				ORDER BY [job_id], [date_modified] DESC
			) AS [ROW_NUMBER]
		FROM [dbo].[sysjobs]
	)
	, CTE_CURRENT_sysjobs_DIMENSION AS (
		SELECT
			[JOB_KEY]
		,	[job_id]
		,	[date_modified]
		FROM CTE_sysjobs_DIMENSIONS
		WHERE [ROW_NUMBER] = 1
	)
	, CTE_sysjobs AS (
		SELECT
			s.[ETL_KEY]
		,	s.[STAGING_KEY]
		,	CASE
				WHEN d.[job_id] IS NULL THEN 'I'	-- new job
				WHEN d.[job_id] IS NOT NULL AND s.[date_modified] > d.[date_modified] THEN 'U'
			END [Action]
		,	d.[JOB_KEY]
		,	s.[job_id]
		FROM [staging].[sysjobs] s
		LEFT JOIN CTE_CURRENT_sysjobs_DIMENSION d
		ON d.[job_id] = s.[job_id]
	)

	INSERT [staging].[sysjobs_UPDATE] (
		[ETL_KEY]
	,	[STAGING_KEY]
	,	[ACTION]
	,	[JOB_KEY]
	,	[job_id]
	)
	SELECT
		[ETL_KEY]
	,	[STAGING_KEY]
	,	[ACTION]
	,	[JOB_KEY]		-- NULL if insert
	,	[job_id]
	FROM CTE_sysjobs
	WHERE [Action] IN ('I', 'U');
END

