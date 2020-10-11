﻿CREATE TABLE [dbo].[ETL_HISTORY_LOG]
(
	[ETL_KEY]				INT		IDENTITY	NOT NULL 
		CONSTRAINT PK_ETL_HISTORY_LOG
			PRIMARY KEY CLUSTERED
,	[START_DATE]			SMALLDATETIME	NOT NULL
		CONSTRAINT DF_ETL_HISTORY_START_DATE
			DEFAULT GETDATE()
,	[BEGIN_INSTANCE_ID]		INT		NOT NULL
,	[END_INSTANCE_ID]		INT		NOT NULL
,	[END_DATE]		SMALLDATETIME	NULL
,	[RESULT_CODE]	INT				NULL
)