CREATE PROCEDURE [dbo].[GET_ACTIVE_JOBS]
AS
BEGIN
	DECLARE 
		@SESSION_ID				INT
	,	@REFRESH_KEY			INT = NEXT VALUE FOR [dbo].[REFRESH_KEY]
	,	@REFRESH_DATE			SMALLDATETIME = CONVERT(SMALLDATETIME, GETDATE());

	SELECT
		@SESSION_ID = MAX(session_id)
	FROM msdb.dbo.syssessions;

	;WITH CTE_JOBS_RUNNING AS (
		SELECT
			c.[JOB_KEY]
		, 	a.[job_id]
		,	a.[start_execution_date]
		,	a.[last_executed_step_id]
		,	a.[last_executed_step_date]
		FROM msdb.dbo.sysjobactivity a
		LEFT JOIN [dbo].[JOB_CURRENT] c
		ON c.[job_id] = a.[job_id]
		WHERE a.session_id = @SESSION_ID
		AND a.start_execution_date IS NOT NULL
		AND stop_execution_date IS NULL
	)

	--
	--SELECT * FROM CTE_JOBS_RUNNING
	--

	, CTE_JOB_STEPS_REMAINING_DURATION AS (
		SELECT
		 	a.[JOB_KEY]
		,	SUM(d.[AVERAGE_STEP_DURATION]) [job_step_average_duration]
		FROM CTE_JOBS_RUNNING a
		LEFT JOIN [dbo].[JOB_STEP_AVERAGE_DURATION] d
		ON d.[JOB_KEY] = a.[JOB_KEY]
		WHERE d.[step_id] > COALESCE(a.[last_executed_step_id], 0)
		GROUP BY a.[JOB_KEY]
	)

	--
	--SELECT * FROM CTE_JOB_STEPS_REMAINING_DURATION
	--

	INSERT [dbo].[ACTIVE_JOBS] (
		[REFRESH_KEY]
	,	[job_id]
	,	[CURRENT_DURATION]
	,	[EXECUTION_COUNT]
	,	[AVERAGE_DURATION]
	,	[ESTIMATED_COMPLETION]
	)
	SELECT
		@REFRESH_KEY
	,	a.[job_id]	
	,	DATEDIFF(second, a.[start_execution_date], GETDATE())	AS [current_duration]
	,	0	-- TO DO: get the number of times the job has run?
	,	d.[job_step_average_duration]	-- based on last step executed
	,	CONVERT(
			SMALLDATETIME
		,
			DATEADD(
				second
			,	d.[job_step_average_duration] + DATEDIFF(second, a.[start_execution_date], GETDATE())
			, a.[start_execution_date]
			) 
		) AS [estimated_completion]
	FROM CTE_JOBS_RUNNING a
	LEFT JOIN CTE_JOB_STEPS_REMAINING_DURATION d
	ON d.[JOB_KEY] = a.[JOB_KEY];

	INSERT [dbo].[ACTIVE_JOBS_REFRESH] (
		[REFRESH_KEY]
	,	[REFRESH_DATE]
	)
	SELECT
	 	@REFRESH_KEY
	,	@REFRESH_DATE;
END
