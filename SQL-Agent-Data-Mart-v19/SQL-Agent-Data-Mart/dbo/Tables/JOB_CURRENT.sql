﻿CREATE TABLE [dbo].[JOB_CURRENT]
(
	[JOB_KEY]	INT NOT NULL
		CONSTRAINT PK_JOB_CURRENT
			PRIMARY KEY CLUSTERED
,	[job_id]	[UNIQUEIDENTIFIER]	NOT NULL
,	[JOB_STEP_COUNT]	INT NOT NULL
)

