DROP PROCEDURE dbo.GetDocDetails
GO
CREATE PROCEDURE dbo.GetDocDetails(@Input NVARCHAR(64))
AS
BEGIN
	SELECT * 
	  FROM dbo.Doctor d (NOLOCK)	  
	 WHERE @Input = CASE WHEN ISNUMERIC(@Input) = 1 THEN CAST(DocId AS NVARCHAR(64)) ELSE DocGUID END
	   FOR JSON PATH, ROOT('Data')
END

/*
EXEC dbo.GetDocDetails '2' 
*/