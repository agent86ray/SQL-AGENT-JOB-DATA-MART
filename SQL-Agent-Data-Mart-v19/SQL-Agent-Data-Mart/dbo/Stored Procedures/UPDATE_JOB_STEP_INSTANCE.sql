CREATE PROCEDURE [dbo].[UPDATE_JOB_STEP_INSTANCE]
AS
BEGIN
	/*
		Incremental load of JOB_STEP_INSTANCE table from [staging].[sysjobhistory]. INSERT new rows where
		the JOB_KEY does not exist in the JOB_INSTANCE table.

	*/

	INSERT [dbo].[JOB_STEP_INSTANCE] (
	  [JOB_KEY]
	, [JOB_INSTANCE_ID]
	, [JOB_STEP_INSTANCE_ID]
	, [job_id]
	, [step_id]
	, [step_name]
	, [sql_message_id]
	, [sql_severity]
	, [message]
	, [run_status]
	, [run_date]
	, [run_time]
	, [run_duration]
	, [operator_id_emailed]
	, [operator_id_netsent]
	, [operator_id_paged]
	, [retries_attempted]
	, [server]
	, [start_time]
	, [end_time]
	, [duration_seconds]
	, [ETL_KEY]	
	, [STAGING_KEY]	
	)
	SELECT
		c.JOB_KEY  
	,	j.[INSTANCE_ID]	-- JOB_INSTANCE
	,	h.[instance_id]	-- JOB_STEP_INSTANCE_ID
	, h.[job_id]
	, h.[step_id]
	, h.[step_name]
	, h.[sql_message_id]
	, h.[sql_severity]
	, h.[message]
	, h.[run_status]
	, h.[run_date]
	, h.[run_time]
	, h.[run_duration]
	, h.[operator_id_emailed]
	, h.[operator_id_netsent]
	, h.[operator_id_paged]
	, h.[retries_attempted]
	, h.[server]
	, h.[start_time]
	, h.[end_time]
	, h.[duration_seconds]
	, h.[ETL_KEY]
	, h.[STAGING_KEY]
	FROM [staging].[sysjobhistory] h
	JOIN [dbo].[JOB_CURRENT] c
	ON c.[job_id] = h.[job_id]
	JOIN [dbo].[JOB_INSTANCE] j
	ON j.[JOB_KEY] = c.[JOB_KEY]
		-- only get job step outcome rows
	WHERE h.[step_id] > 0			
		-- get JOB_INSTANCE based on range of start_time and end_time
	AND h.[start_time] BETWEEN j.[start_time] AND j.[end_time];				
END

