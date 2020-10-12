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

	INSERT [dbo].[JOB_CURRENT] (
		[JOB_KEY]
	,	[job_id]
	)
	SELECT
		s.[JOB_KEY]
	,	s.[job_id]
	FROM  CTE_CURRENT_JOB s
	LEFT JOIN [dbo].[JOB_CURRENT] c
	ON s.[JOB_KEY] = c.[JOB_KEY]
	WHERE c.[JOB_KEY] IS NULL;
END

