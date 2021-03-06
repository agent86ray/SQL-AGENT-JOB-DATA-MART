﻿/*

USE [SQL_AGENT_DATA_MART];
GO


--
-- queries for PROCESS SQL AGENT DATA MART HISTORY job
--


-- View the results from the latest run
-- Incremental update based on BEGIN_INSTANCE_ID and END_INSTANCE_ID
SELECT TOP 1
	[ETL_KEY]
,	[START_DATE]
,	[END_DATE]
,	[BEGIN_INSTANCE_ID]
,	END_INSTANCE_ID
FROM [dbo].[ETL_HISTORY_LOG]
ORDER BY [ETL_KEY] DESC;


SELECT *
FROM [dbo].[JOB_INSTANCE_ALL_STEPS_COMPLETED]
WHERE [INSTANCE_ID] >= 3890		-- BEGIN_INSTANCE_ID from above
ORDER BY [INSTANCE_ID] DESC;

--SELECT *
--FROM [staging].[sysjobhistory];


-- View the rows extracted from msdb.dbo.sysjobhistory.
-- Filter out the SQL AGENT DATA MART jobs. We don't want
-- to see them.
SELECT 
	h.*
,	d.*
FROM [staging].[vsysjobhistory] h
JOIN [dbo].[JOB_STEP_AVERAGE_DURATION] d
ON d.[JOB_KEY] = h.[JOB_KEY] AND d.[step_id] = h.[step_id]
ORDER BY h.[instance_id], h.[JOB_KEY], h.[step_id];
GO

-----------------------------------------------------------


SELECT *
FROM  [dbo].[JOB_STEP_AVERAGE_DURATION]
WHERE [JOB_KEY] BETWEEN 181 AND 182;


-- Show JOB_INSTANCE and JOB_STEP_INSTANCE -----------------------------
DECLARE 
	@ETL_KEY			INT
,	@BEGIN_INSTANCE_ID	INT
,	@END_INSTANCE_ID	INT;

EXEC [dbo].[GET_ETL_HISTORY_LOG]
	@P_ETL_KEY = @ETL_KEY OUTPUT
,	@P_BEGIN_INSTANCE_ID = @BEGIN_INSTANCE_ID OUTPUT
,	@P_END_INSTANCE_ID = @END_INSTANCE_ID OUTPUT;

SELECT j.*
FROM [dbo].[JOB_INSTANCE] j
WHERE j.[INSTANCE_ID] BETWEEN @BEGIN_INSTANCE_ID AND @END_INSTANCE_ID;

SELECT s.*
FROM [dbo].[JOB_INSTANCE] j
JOIN [dbo].[JOB_STEP_INSTANCE] s
ON s.[JOB_INSTANCE_ID] = j.[INSTANCE_ID]
WHERE j.[INSTANCE_ID] BETWEEN @BEGIN_INSTANCE_ID AND @END_INSTANCE_ID;

----------------------------------------------------------------------


SELECT *
FROM [dbo].[JOB_STEP_INSTANCE];




SELECT *
FROM [dbo].[vJOB_CURRENT]
ORDER BY [name];


SELECT *
FROM  [dbo].[JOB_STEP_AVERAGE_DURATION]
WHERE [JOB_KEY] BETWEEN 181 AND 182;


SELECT *
FROM [dbo].[JOB_CURRENT] c
JOIN [dbo].[sysjobs] j ON j.[JOB_KEY] = c.[JOB];


SELECT *
FROM [dbo].[JOB_INSTANCE]
ORDER BY [JOB_KEY], [INSTANCE_ID];



SELECT *
FROM [dbo].[JOB_STEP_INSTANCE]
WHERE [JOB_INSTANCE_ID] BETWEEN 92 AND 101
ORDER BY [JOB_KEY], [JOB_INSTANCE_ID], [step_id];

SELECT *
FROM  [dbo].[JOB_INSTANCE_ALL_STEPS_COMPLETED]


SELECT *
FROM [dbo].[JOB_STEP_DURATION] 
WHERE [JOB_KEY] = 132
ORDER BY [JOB_KEY]

*/
