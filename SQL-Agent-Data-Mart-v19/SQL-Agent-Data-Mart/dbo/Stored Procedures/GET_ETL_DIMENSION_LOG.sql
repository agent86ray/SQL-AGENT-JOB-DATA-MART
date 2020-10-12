﻿CREATE PROCEDURE [dbo].[GET_ETL_DIMENSION_LOG]
	@P_ETL_KEY	INT	OUTPUT
AS
BEGIN
	DECLARE @ETL_KEY	INT;

	SELECT TOP 1
		@ETL_KEY = [ETL_KEY]
	FROM [dbo].[ETL_DIMENSION_LOG]
	ORDER BY [ETL_KEY] DESC;

	IF @ETL_KEY IS NULL
	BEGIN
		EXEC [dbo].[CREATE_ETL_DIMENSION_LOG]
			@P_ETL_KEY = @ETL_KEY OUTPUT;	
	END

	SET @P_ETL_KEY = @ETL_KEY;
END