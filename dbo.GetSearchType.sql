DROP PROCEDURE dbo.GetSearchType
GO
CREATE PROCEDURE dbo.GetSearchType(
	   @Input NVARCHAR(64)
	 , @Output NVARCHAR(64) OUTPUT)
AS
BEGIN
	IF(@Input = '1253')
		SELECT @Output = '{"Type": "Hospital"}'
	ELSE 
		SELECT @Output = '{"Type": "None"}'
END

/*
DECLARE @Output NVARCHAR(64)
EXEC dbo.GetSearchType '2', @Output = @Output OUTPUT
SELECT @Output 
*/