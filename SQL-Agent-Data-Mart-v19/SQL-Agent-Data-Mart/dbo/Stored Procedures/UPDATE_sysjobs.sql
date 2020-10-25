CREATE PROCEDURE [dbo].[UPDATE_sysjobs]
AS
BEGIN
	/*

		UPDATE_sysjobs
		
		sysjobs is implemented as a type 2 slowly changing dimension. The [staging].[sysjobs_UPDATE] 
		table has the details on the new or updated sysjobs rows in the [staging].[sysjobs] table.

		A new row is added to sysjobs for any row in staging that represents a new job or an updated job.

		To make sure that this stored procedure can be rerun without error, if a row exists in sysjobs
		where the JOB_KEY matches the NEW_JOB_KEY in the [staging].[sysjobs_UPDATE] table, the row will
		be skipped. This covers the edge case where an error occurs in the UPDATE-SQL-AGENT-Dimensions
		SSIS package, it gets rerun, but this stored procedure completed successfully during the prior
		run where the error was raised.
	*/

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
	  u.[NEW_JOB_KEY]
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
	ON j.[job_id] = u.[job_id]
	LEFT JOIN [dbo].[sysjobs] d
	ON d.[JOB_KEY] = u.[NEW_JOB_KEY]
	WHERE d.JOB_KEY IS NULL;
END
