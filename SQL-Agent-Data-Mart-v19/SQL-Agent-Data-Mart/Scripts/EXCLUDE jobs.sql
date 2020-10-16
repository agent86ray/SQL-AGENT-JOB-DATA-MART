SELECT
	j.[job_id]
,	j.[name]
,	c.[name]
FROM msdb.dbo.sysjobs j
JOIN msdb.dbo.syscategories c
ON c.[category_id] = j.[category_id]
ORDER BY j.[name];

INSERT [dbo].[JOB_EXCLUDE] (
	[job_id]	
,	[name]		
)
VALUES
	(	'150ABE77-D7CE-421A-8B68-972489C12846', 'PROCESS SQL AGENT DATA MART DIMENSIONS' )
,	(	'D78D06A4-CAD5-4191-BE1A-E14A639FF299', 'PROCESS SQL AGENT DATA MART HISTORY' )
,	(	'47101CF6-B170-440C-9397-D8BDA4D856F5', 'PROCESS SQL AGENT DATA MART ACTIVITY' )
,	(	'9A6F66E9-B510-4FBE-854D-6F1AEDF6EB18', 'SSIS Server Maintenance Job' )
,	(	'402DCE00-0B43-4B0F-A2EE-BCEC022CC0F7', 'syspolicy_purge_history' )
