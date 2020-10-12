CREATE PROCEDURE [dbo].[UPDATE_JOB_INSTANCE]
AS
BEGIN
	/*
		Incremental load of JOB_INSTANCE table from [staging].[sysjobhistory]. INSERT new rows where
		the JOB_KEY does not exist in the JOB_INSTANCE table.

	*/

	INSERT [dbo].[JOB_INSTANCE] (
	  [JOB_KEY]
	, [INSTANCE_ID]
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
	,	[instance_id]
	, h.[job_id]
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
	FROM [staging].[sysjobhistory] h
	JOIN [dbo].[JOB_CURRENT] c
	ON c.[job_id] = h.[job_id]
	WHERE h.[step_id] = 0;				-- only get job outcome rows
END
