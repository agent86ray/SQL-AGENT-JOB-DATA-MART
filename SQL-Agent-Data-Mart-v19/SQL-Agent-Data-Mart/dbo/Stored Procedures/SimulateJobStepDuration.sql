﻿CREATE PROCEDURE [dbo].[SimulateJobStepDuration]
	@MINIMUM_MINUTES	INT = 1
,	@MAXIMUM_MINUTES	INT = 10
,	@RAISE_ERROR		BIT = 0
,	@DEBUG				BIT = 0
AS
BEGIN
	IF @RAISE_ERROR = 1
	BEGIN
		RAISERROR(N'ERROR OCCURRED IN SimulateJobStepDuration', 11, 1);
		RETURN;
	END

	-- convert to range of seconds
	DECLARE
	 	@MINIMUM_SECONDS		INT = @MINIMUM_MINUTES * 60
	,	@MAXIMUM_SECONDS		INT = @MAXIMUM_MINUTES * 60
	,	@STEP_DURATION_SECONDS	INT = 0
	,	@NOW					SMALLDATETIME = GETDATE()
	,	@WAIT_FOR				VARCHAR(10);

	WHILE @STEP_DURATION_SECONDS < @MINIMUM_SECONDS
	BEGIN
		SET @STEP_DURATION_SECONDS = FLOOR(RAND() * @MAXIMUM_SECONDS);
	END

	-- hh, mi, ss
	DECLARE
		@WAIT_UNTIL	SMALLDATETIME = DATEADD(second, @STEP_DURATION_SECONDS, @NOW);
	DECLARE
		@HOURS		SMALLINT = DATEPART(hh, @WAIT_UNTIL)
	,	@MINUTES 	SMALLINT = DATEPART(mi, @WAIT_UNTIL)
	,	@SECONDS	SMALLINT = DATEPART(ss, @WAIT_UNTIL);

	DECLARE
		@WAITFOR_STRING		CHAR(58) = 
			RIGHT('00' + CONVERT(VARCHAR(2), @HOURS), 2) +
			':' +
			RIGHT('00' + CONVERT(VARCHAR(2), @MINUTES), 2) +
			':' +
			RIGHT('00' + CONVERT(VARCHAR(2), @SECONDS), 2);

	IF @DEBUG = 1
	BEGIN
		SELECT 
			@MINIMUM_MINUTES		AS [MINIMUM_MINUTES]
		,	@MINIMUM_SECONDS		AS [MINIMUM_SECONDS]
		,	@MAXIMUM_MINUTES		AS [MAXIMUM_MINUTES]
		,	@MAXIMUM_SECONDS		AS [MAXIMUM_SECONDS]
		,	@STEP_DURATION_SECONDS	AS [STEP_DURATION_SECONDS]
		,	@WAITFOR_STRING			AS [WAITFOR_STRING];
	END

	IF @DEBUG = 0
	BEGIN
		WAITFOR TIME @WAITFOR_STRING;
	END
END
