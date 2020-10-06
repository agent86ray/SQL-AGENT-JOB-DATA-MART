CREATE TABLE [staging].[sysjobhistory]
(
	[instance_id] [int] NOT NULL,
	[job_id] [uniqueidentifier] NOT NULL,
	[step_id] [int] NOT NULL,
	[step_name] [sysname] NOT NULL,
	[sql_message_id] [int] NOT NULL,
	[sql_severity] [int] NOT NULL,
	[message] [nvarchar](4000) NULL,
	[run_status] [int] NOT NULL,
	[run_date] [int] NOT NULL,
	[run_time] [int] NOT NULL,
	[run_duration] [int] NOT NULL,
	[operator_id_emailed] [int] NOT NULL,
	[operator_id_netsent] [int] NOT NULL,
	[operator_id_paged] [int] NOT NULL,
	[retries_attempted] [int] NOT NULL,
	[server] [sysname] NOT NULL,
	[ETL_KEY]		INT NOT NULL,
	[STAGING_KEY]	INT	IDENTITY NOT NULL
)
