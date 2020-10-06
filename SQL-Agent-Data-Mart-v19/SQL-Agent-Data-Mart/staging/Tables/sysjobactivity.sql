﻿CREATE TABLE [staging].[sysjobactivity]
(
	[session_id] [int] NOT NULL,
	[job_id] [uniqueidentifier] NOT NULL,
	[run_requested_date] [datetime] NULL,
	[run_requested_source] [sysname] NULL,
	[queued_date] [datetime] NULL,
	[start_execution_date] [datetime] NULL,
	[last_executed_step_id] [int] NULL,
	[last_executed_step_date] [datetime] NULL,
	[stop_execution_date] [datetime] NULL,
	[job_history_id] [int] NULL,
	[next_scheduled_run_date] [datetime] NULL,
	[ETL_KEY]		INT NOT NULL,
	[STAGING_KEY]	INT	IDENTITY NOT NULL
)
