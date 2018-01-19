DROP PROCEDURE dbo.GetSearchType
GO
CREATE PROCEDURE dbo.GetSearchType(
	   @Input NVARCHAR(64)
	 , @Output NVARCHAR(64) OUTPUT)
AS
BEGIN
	SELECT @Output = '{"Type": "Hospital"}'
END

/*
DECLARE @Output NVARCHAR(64)
EXEC dbo.GetSearchType '2', @Output = @Output OUTPUT
SELECT @Output 
*/