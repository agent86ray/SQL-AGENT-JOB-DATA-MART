
/*

USE [SQL_AGENT_DATA_MART];
GO

-- query SQL AGENT DIMENSIONS
SELECT * FROM [dbo].[ETL_DIMENSION_LOG];


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
FROM [staging].[sysjobs_UPDATE]

SELECT j.[name], u.*
FROM [staging].[sysjobs_UPDATE] u
JOIN [dbo].[sysjobs] j
ON j.[JOB_KEY] = u.[NEW_JOB_KEY]

EXEC [staging].[STAGE_sysjobs_UPDATE];


SELECT *
FROM [staging].[sysjobs_UPDATE]


*/


