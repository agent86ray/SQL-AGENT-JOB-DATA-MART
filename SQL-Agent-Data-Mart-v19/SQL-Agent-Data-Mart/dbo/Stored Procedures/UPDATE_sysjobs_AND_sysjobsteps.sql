CREATE PROCEDURE [dbo].[UPDATE_sysjobs_AND_sysjobsteps]
AS
BEGIN
	/*

		sysjobs and sysjobsteps are being handled as type 2 slowly changing dimensions.

		For sysjobs whether an Insert or Update we insert a new row from staging. For sysjobsteps insert
		every row from staging.
	*/

	-- Set the JOB_KEY values for Inserts
	UPDATE [staging].[sysjobs_UPDATE]
		SET [JOB_KEY] = NEXT VALUE FOR [dbo].[JOB_KEY]
	WHERE [ACTION] = 'I';

	-- INSERT new rows into sysjobs whether we determined an INSERT or an UPDATE
	INSERT [dbo].[sysjobs] (
	  [JOB_KEY]
	, [job_id]
	, [originating_server_id]
	, [name]
	, [enabled]
	, [description]
	, [start_step_id]
	, [category_id]
	, [owner_sid]
	, [notify_level_eventlog]
	, [notify_level_email]
	, [notify_level_netsend]
	, [notify_level_page]
	, [notify_email_operator_id]
	, [notify_netsend_operator_id]
	, [notify_page_operator_id]
	, [delete_level]
	, [date_created]
	, [date_modified]
	, [version_number]
	, [ETL_KEY]
	, [STAGING_KEY]
	)
	SELECT
	  u.[JOB_KEY]
	, j.[job_id]
	, j.[originating_server_id]
	, j.[name]
	, j.[enabled]
	, j.[description]
	, j.[start_step_id]
	, j.[category_id]
	, j.[owner_sid]
	, j.[notify_level_eventlog]
	, j.[notify_level_email]
	, j.[notify_level_netsend]
	, j.[notify_level_page]
	, j.[notify_email_operator_id]
	, j.[notify_netsend_operator_id]
	, j.[notify_page_operator_id]
	, j.[delete_level]
	, j.[date_created]
	, j.[date_modified]
	, j.[version_number]
	, j.[ETL_KEY]
	, j.[STAGING_KEY]	
	FROM [staging].[sysjobs_UPDATE] u
	JOIN [staging].[sysjobs] j
	ON j.[job_id] = u.[job_id];

	-- INSERT new rows into sysjobsteps
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
	  u.[JOB_KEY]
	, s.[job_id]
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
	, s.[ETL_KEY]
	, s.[STAGING_KEY]	
	FROM [staging].[sysjobs_UPDATE] u
	JOIN [staging].[sysjobsteps] s
	ON s.[job_id] = u.[job_id];
END
