/*

	SQL AGENT DATA MART JOB DEMO

*/



EXEC [msdb].[dbo].[sp_start_job] 
	@job_name = 'PROCESS SQL AGENT DATA MART DIMENSIONS'


EXEC [msdb].[dbo].[sp_start_job] 
	@job_name = 'PROCESS SQL AGENT DATA MART HISTORY';


EXEC [msdb].[dbo].[sp_start_job] 
	@job_name = 'PROCESS SQL AGENT DATA MART ACTIVITY';


SELECT TOP 1 *
FROM [dbo].[ACTIVE_JOBS_REFRESH]
ORDER BY [REFRESH_KEY] DESC;


SELECT *
FROM [dbo].[vACTIVE_JOBS];
