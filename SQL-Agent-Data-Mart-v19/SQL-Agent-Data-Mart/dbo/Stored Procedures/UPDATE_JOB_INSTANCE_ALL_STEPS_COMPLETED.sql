CREATE PROCEDURE [dbo].[UPDATE_JOB_INSTANCE_ALL_STEPS_COMPLETED]
	@BEGIN_JOB_INSTANCE INT
,	@END_JOB_INSTANCE	INT
AS
BEGIN
	/*

		Determine the unique COUNT of job steps completed for the JOB_INSTANCE values in
		the range of @BEGIN_JOB_INSTANCE and @END_JOB_INSTANCE parameter values.

		If a job step is executed more than one (e.g. failed one or more times, retried one or more
		times, etc.) only count the step once.

		INSERT rows into  [dbo].[JOB_INSTANCE_ALL_STEPS_COMPLETED] where the steps completed in
		the job instance equals the number of steps in the job.

		We want to exclude job instances where not all steps were completed becuase it would
		skew the average duration calculation.

	*/

	-- Get the count job steps completed
	; WITH CTE_JOB_STEPS_COMPLETED AS (
		SELECT
		 	[JOB_INSTANCE_ID]
		,	[JOB_KEY]
		,	COUNT(*)	AS [STEPS_COMPLETED]
		FROM [dbo].[JOB_STEP_INSTANCE] j
		WHERE [JOB_INSTANCE_ID] BETWEEN @BEGIN_JOB_INSTANCE AND @END_JOB_INSTANCE
		GROUP BY [JOB_INSTANCE_ID], [JOB_KEY] 	
	)

	, CTE_DISTINCT_JOBS AS (
		SELECT DISTINCT
			[JOB_KEY]
		FROM CTE_JOB_STEPS_COMPLETED 
	)

	-- Get the count of job steps for these jobs
	, CTE_JOB_STEPS_COUNT AS (
		SELECT
			s.[JOB_KEY]
		,	COUNT(*)	AS [STEP_COUNT]
		FROM [dbo].[sysjobsteps] s
		JOIN CTE_DISTINCT_JOBS j 
		ON j.[JOB_KEY] = s.[JOB_KEY]
		GROUP BY s.[JOB_KEY]
	)

	INSERT [dbo].[JOB_INSTANCE_ALL_STEPS_COMPLETED] (
		[JOB_KEY]
	,	[INSTANCE_ID]
	)	
	SELECT
	 	c.[JOB_KEY]
	,	c.[JOB_INSTANCE_ID]
	FROM CTE_JOB_STEPS_COMPLETED c
	JOIN CTE_JOB_STEPS_COUNT s
	ON s.[JOB_KEY] = c.[JOB_KEY]
	WHERE c.[STEPS_COMPLETED] = s.[STEP_COUNT];
END
