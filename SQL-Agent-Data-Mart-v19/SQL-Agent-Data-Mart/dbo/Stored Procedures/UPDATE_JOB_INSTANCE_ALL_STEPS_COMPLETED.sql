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
	-- Get every step completed for the job instance; using count(*) rather than distinct
	;WITH CTE_JOB_STEPS_COMPLETED AS (
		SELECT
			[JOB_KEY]
		,	[INSTANCE_ID]
		,	[step_id]	-- Use step_uid from sysjobsteps?
		,	COUNT(*)	AS [JOB_STEP_COMPLETED_COUNT]
		FROM [dbo].[JOB_STEP_INSTANCE]
		WHERE [INSTANCE_ID] BETWEEN @BEGIN_JOB_INSTANCE AND @END_JOB_INSTANCE
		GROUP BY [JOB_KEY], [INSTANCE_ID], [step_id]
	)
	, CTE_JOB_STEPS_COUNT AS (
		SELECT
			[JOB_KEY]
		,	[INSTANCE_ID]
		,	COUNT(*)	AS [JOB_STEP_COMPLETED_COUNT]
		FROM CTE_JOB_STEPS_COMPLETED
		GROUP BY [JOB_KEY], [INSTANCE_ID]
	)

	INSERT [dbo].[JOB_INSTANCE_ALL_STEPS_COMPLETED] (
		[JOB_KEY]
	,	[INSTANCE_ID]
	)
	SELECT
		s.[JOB_KEY]
	,	s.[INSTANCE_ID]
	FROM  CTE_JOB_STEPS_COUNT s
	JOIN [dbo].[JOB_CURRENT] c
	ON c.[JOB_KEY] = s.[JOB_KEY]
	WHERE c.[JOB_STEP_COUNT] = s.[JOB_STEP_COMPLETED_COUNT];
END
