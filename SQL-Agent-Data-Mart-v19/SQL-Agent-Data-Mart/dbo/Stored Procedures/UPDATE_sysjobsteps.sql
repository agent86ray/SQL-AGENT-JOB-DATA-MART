CREATE PROCEDURE [dbo].[UPDATE_sysjobsteps]
AS
BEGIN
	/*
		UPDATE_sysjobsteps
		
		sysjobsteps is implemented as a type 2 slowly changing dimension. However, to determine what changed,
		we rely solely on the current sysjobs row. The details of new or changed sysjobs is recorded in the
		[staging].[sysjobs_UPDATE] table.

		The [staging].[sysjobsteps] table is used to determine the rows to add to the sysjobsteps table. All rows are 
		extracted from the msdb sysjobsteps table in order to make this work. Whether any sysjobstep row actually
		changed is ignored; all rows from staging are added with the NEW_JOB_KEY.

		To make sure that this stored procedure can be rerun without error, if a row exists in sysjobsteps
		where the JOB_KEY matches the NEW_JOB_KEY in the [staging].[sysjobs_UPDATE] table and the [step_id] matches, 
		the row will be skipped. This covers the edge case where an error occurs in the UPDATE-SQL-AGENT-Dimensions
		SSIS package, it gets rerun, but this stored procedure completed successfully during the prior
		run where the error was raised.
	*/
	INSERT [dbo].[sysjobsteps] (
	  [JOB_KEY]
	, [job_id]
	, [step_id]
	, [step_name]
	, [subsystem]
	, [command]
	, [flags]
	, [additional_parameters]
	, [cmdexec_success_code]
	, [on_success_action]
	, [on_success_step_id]
	, [on_fail_action]
	, [on_fail_step_id]
	, [server]
	, [database_name]
	, [database_user_name]
	, [retry_attempts]
	, [retry_interval]
	, [os_run_priority]
	, [output_file_name]
	, [last_run_outcome]
	, [last_run_duration]
	, [last_run_retries]
	, [last_run_date]
	, [last_run_time]
	, [proxy_id]
	, [step_uid]	
	, [ETL_KEY]
	, [STAGING_KEY]	
	)
	SELECT
	  u.[NEW_JOB_KEY]
	, s.[job_id]
	, s.[step_id]
	, s.[step_name]
	, s.[subsystem]
	, s.[command]
	, s.[flags]
	, s.[additional_parameters]
	, s.[cmdexec_success_code]
	, s.[on_success_action]
	, s.[on_success_step_id]
	, s.[on_fail_action]
	, s.[on_fail_step_id]
	, s.[server]
	, s.[database_name]
	, s.[database_user_name]
	, s.[retry_attempts]
	, s.[retry_interval]
	, s.[os_run_priority]
	, s.[output_file_name]
	, s.[last_run_outcome]
	, s.[last_run_duration]
	, s.[last_run_retries]
	, s.[last_run_date]
	, s.[last_run_time]
	, s.[proxy_id]
	, s.[step_uid]	
	, s.[ETL_KEY]
	, s.[STAGING_KEY]	
	FROM [staging].[sysjobs_UPDATE] u
	JOIN [staging].[sysjobsteps] s
	ON s.[job_id] = u.[job_id]
	LEFT JOIN [dbo].[sysjobsteps] d
	ON d.[JOB_KEY] = u.[NEW_JOB_KEY] AND d.[step_id] = s.[step_id]
	WHERE d.[JOB_KEY] IS NULL;
END
