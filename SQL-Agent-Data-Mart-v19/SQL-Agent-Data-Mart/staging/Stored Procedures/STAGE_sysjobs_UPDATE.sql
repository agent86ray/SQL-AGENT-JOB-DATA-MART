CREATE PROCEDURE [staging].[STAGE_sysjobs_UPDATE]
AS
BEGIN
	/*
		Compare each job_id in the [staging].[sysjobs] table with the latest job_id row in the [dbo].[sysjobs] table 
		and determine if it should be inserted or updated in the [dbo].[sysjobs] table. It could also be no change.
	*/

	TRUNCATE TABLE [staging].[sysjobs_UPDATE];

	;WITH CTE_sysjobs AS (
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
		LEFT JOIN[dbo].[vJOB_CURRENT] d
		ON d.[job_id] = s.[job_id]
		-- EXCLUDE jobs
		LEFT JOIN [dbo].[JOB_EXCLUDE] x
		ON x.[job_id] = s.[job_id]
		WHERE x.[name] IS NULL
	)

	INSERT [staging].[sysjobs_UPDATE] (
		[ETL_KEY]
	,	[STAGING_KEY]
	,	[ACTION]
	,	[job_id]
	,	[JOB_KEY]
	,	[NEW_JOB_KEY]
	)
	SELECT
		[ETL_KEY]
	,	[STAGING_KEY]
	,	[ACTION]
	,	[job_id]
	,	[JOB_KEY]		-- NULL if insert
	,	NEXT VALUE FOR [dbo].[JOB_KEY]
	FROM CTE_sysjobs
	WHERE [Action] IN ('I', 'U');
END

