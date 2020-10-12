CREATE PROCEDURE [dbo].[ACCUMULATE_JOB_STEP_DURATION]
	@BEGIN_JOB_INSTANCE INT
,	@END_JOB_INSTANCE	INT
AS
BEGIN
	/*
		Accumulate the duration for jobs with a [JOB_INSTANCE_ID] in the range of @BEGIN_JOB_INSTANCE
		and @END_JOB_INSTANCE.

		Filter out any job instances where not all steps were completed.
	*/

	;WITH CTE_JOB_STEPS AS (
		SELECT 
			j.[JOB_KEY]
		,	j.[JOB_INSTANCE_ID]
		,	j.[step_id]
		,	j.[duration_seconds]
		FROM [dbo].[JOB_STEP_INSTANCE] j
		JOIN [dbo].[JOB_INSTANCE_ALL_STEPS_COMPLETED] s
		ON j.[JOB_KEY] = s.[JOB_KEY] AND j.[JOB_INSTANCE_ID] = s.INSTANCE_ID
		WHERE [JOB_INSTANCE_ID] BETWEEN @BEGIN_JOB_INSTANCE AND @END_JOB_INSTANCE
	)

	, CTE_SUM_STEPS AS (
		SELECT
			[JOB_KEY]
		,	[step_id]
		,	COUNT(*)				AS [JOB_STEP_COUNT]
		,	SUM([duration_seconds])	AS [JOB_STEP_TOTAL_SECONDS]
		FROM CTE_JOB_STEPS
		GROUP BY [JOB_KEY], [step_id]
	)

	INSERT [dbo].[JOB_STEP_DURATION] (
		[JOB_KEY]					
	,	[step_id]					
	,	[JOB_STEP_COUNT]			
	,	[JOB_STEP_TOTAL_SECONDS]
	)
	SELECT
		[JOB_KEY]					
	,	[step_id]					
	,	[JOB_STEP_COUNT]			
	,	[JOB_STEP_TOTAL_SECONDS]
	FROM CTE_SUM_STEPS;
END
