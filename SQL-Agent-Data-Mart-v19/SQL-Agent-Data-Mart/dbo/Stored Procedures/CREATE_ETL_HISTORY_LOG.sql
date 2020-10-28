CREATE PROCEDURE [dbo].[CREATE_ETL_HISTORY_LOG]
	@P_ETL_KEY	INT	OUTPUT
AS
BEGIN
	/*

		Extract the rows from the msdb.dbo.sysjobhistory table beginning
		with the first row added after the last time the ETL was run
		and the current last row in the msdb.dbo.sysjobhistory table.

		USAGE:

		DECLARE @ETL_KEY	INT;

		EXEC [dbo].[CREATE_ETL_HISTORY_LOG]
			@P_ETL_KEY =  @ETL_KEY OUTPUT;

		SELECT @ETL_KEY;

	*/
	DECLARE
		@BEGIN_INSTANCE_ID	INT
	,	@END_INSTANCE_ID	INT;

	-- Get the starting instance_id for the msdb.dbo.sysjobhistory table
	-- It's the MAX([INSTANCE_ID]) from the JOB_INSTANCE table incremented
	-- by 1.
	SELECT
		@BEGIN_INSTANCE_ID = MAX([INSTANCE_ID]) + 1
	FROM [dbo].[JOB_INSTANCE];

	IF @BEGIN_INSTANCE_ID IS NULL
		SET @BEGIN_INSTANCE_ID = 0;

	-- Get the ending instance_id for the msdb.dbo.sysjobhistory table
	SELECT 
		@END_INSTANCE_ID = MAX([instance_id])
	FROM msdb.dbo.sysjobhistory
	WHERE [run_status] = 1;

	IF @END_INSTANCE_ID IS NULL
		SET @END_INSTANCE_ID = 0;

	INSERT [dbo].[ETL_HISTORY_LOG] (
		[BEGIN_INSTANCE_ID]
	,	[END_INSTANCE_ID]	
	)
	VALUES (
		COALESCE(@BEGIN_INSTANCE_ID, 0)
	,	COALESCE(@END_INSTANCE_ID, 0)
	);

	SET @P_ETL_KEY = SCOPE_IDENTITY();
END
