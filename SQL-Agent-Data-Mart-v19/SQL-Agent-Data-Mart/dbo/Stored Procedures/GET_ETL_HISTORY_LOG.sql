CREATE PROCEDURE [dbo].[GET_ETL_HISTORY_LOG]
	@P_ETL_KEY	INT OUTPUT
AS
BEGIN
	/*
		Get the row created by the last execution of [dbo].[CREATE_ETL_HISTORY_LOG] which
		should be the first step in the SQL Agent job. 

		Steps following the first step that need the @ETL_KEY should call this procedure.

		USAGE:

		DECLARE @ETL_KEY INT;

		EXEC [dbo].[GET_ETL_HISTORY_LOG]
			@P_ETL_KEY = @ETL_KEY OUTPUT;

		SELECT @ETL_KEY;

	*/
	SELECT 
		@P_ETL_KEY = MAX([ETL_KEY]) 
	FROM [dbo].[ETL_HISTORY_LOG];
END
