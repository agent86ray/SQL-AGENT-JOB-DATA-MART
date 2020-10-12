/*

USE [SQL_AGENT_DATA_MART];
GO


-- clear HISTORY tables

TRUNCATE TABLE [dbo].[ETL_HISTORY_LOG];

TRUNCATE TABLE [dbo].[JOB_INSTANCE];

TRUNCATE TABLE [dbo].[JOB_STEP_INSTANCE];


-- HISTORY queries

SELECT *
FROM [dbo].[ETL_HISTORY_LOG];

SELECT *
FROM [staging].[sysjobhistory]
ORDER BY [instance_id];

SELECT *
FROM [dbo].[JOB_INSTANCE]
ORDER BY [JOB_KEY], [INSTANCE_ID];


SELECT *
FROM [dbo].[JOB_STEP_INSTANCE]
ORDER BY [JOB_KEY], [INSTANCE_ID], [step_id];

SELECT *
FROM  [dbo].[JOB_INSTANCE_ALL_STEPS_COMPLETED]


*/
