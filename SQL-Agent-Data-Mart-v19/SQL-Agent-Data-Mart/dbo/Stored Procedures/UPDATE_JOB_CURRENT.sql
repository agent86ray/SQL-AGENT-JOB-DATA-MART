CREATE PROCEDURE [dbo].[UPDATE_JOB_CURRENT]
AS
BEGIN
	/*

		INSERT any new jobs into the [dbo].[JOB_CURRENT] table.

	*/
	-- Get the "current" row for each job
	;WITH CTE_CURRENT_JOB AS (
		SELECT
			[JOB_KEY]
		,	[job_id]
		,	ROW_NUMBER() OVER (
				PARTITION BY [job_id], [date_modified]
				ORDER BY [job_id], [date_modified] DESC
			) AS [ROW_NUMBER]
		FROM [dbo].[sysjobs]
	)
	, CTE_JOB_STEP_COUNT AS (
		SELECT
			s.[JOB_KEY]
		,	COUNT(*)	AS [JOB_STEP_COUNT]
		FROM [dbo].[sysjobsteps] s
		JOIN CTE_CURRENT_JOB c
		ON c.[JOB_KEY] = s.[JOB_KEY]
		GROUP BY s.[JOB_KEY]
	)

	INSERT [dbo].[JOB_CURRENT] (
		[JOB_KEY]
	,	[job_id]
	,	[JOB_STEP_COUNT]
	)
	SELECT
		j.[JOB_KEY]
	,	j.[job_id]
	,	ISNULL(n.[JOB_STEP_COUNT], 0)
	FROM  CTE_CURRENT_JOB j
	LEFT JOIN CTE_JOB_STEP_COUNT n
	ON n.JOB_KEY = j.JOB_KEY
	LEFT JOIN [dbo].[JOB_CURRENT] c
	ON c.[JOB_KEY] = j.[JOB_KEY]
	WHERE c.[JOB_KEY] IS NULL;

	-- remove rows that are no longer current
	;WITH CTE_JOBS AS (
		SELECT
			[JOB_KEY]
		,	[job_id]
		,	ROW_NUMBER() OVER (
				PARTITION BY [job_id]
				ORDER BY [job_id], [JOB_KEY] DESC
			) AS [ROW_NUMBER]
		FROM [dbo].[JOB_CURRENT]
	)

	DELETE c
	FROM [dbo].[JOB_CURRENT] c
	JOIN CTE_JOBS x
	ON x.[JOB_KEY] = c.[JOB_KEY]
	WHERE x.[ROW_NUMBER] > 1;
END

