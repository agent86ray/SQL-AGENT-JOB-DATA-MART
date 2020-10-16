
/*

USE [SQL_AGENT_DATA_MART];
GO

--
-- queries for the the PROCESS SQL AGENT DATA MART DIMENSIONS job
--

-- query LOG; records each time the job ran
-- ETL_KEY value stored in the various tables
SELECT TOP 5
	[ETL_KEY]
,	[START_DATE]
,	[END_DATE]
FROM [dbo].[ETL_DIMENSION_LOG]
ORDER BY [START_DATE] DESC;


-- Show the "current" jobs
SELECT * FROM [dbo].[vJOB_CURRENT]
ORDER BY [JOB_KEY];


SELECT *
FROM [staging].[sysjobs];


SELECT *
FROM msdb.dbo.sysjobactivity
WHERE ;


SELECT * FROM [dbo].[sysjobs];

SELECT * FROM [dbo].[sysjobsteps];

SELECT TOP 1 *
FROM [dbo].[sysjobs];

SELECT *
FROM [dbo].[vJOB_CURRENT];


SELECT *
FROM [staging].[sysjobs_UPDATE]

SELECT j.[name], u.*
FROM [staging].[sysjobs_UPDATE] u
JOIN [dbo].[sysjobs] j
ON j.[JOB_KEY] = u.[NEW_JOB_KEY]

EXEC [staging].[STAGE_sysjobs_UPDATE];




*/


