DROP PROCEDURE dbo.GetDocDetails
GO
CREATE PROCEDURE dbo.GetDocDetails(@Input NVARCHAR(64))
AS
BEGIN
	SELECT d.DocId
		 , d.DocGUID
		 , d.FirstName
		 , d.LastName
		 , d.Email
		 , d.Phone
		 , d.Specialty
		 , d.Fee
		 , CAST(DATEDIFF(MONTH,d.PracticeStartDate,GETDATE())/12 AS NVARCHAR) + ' Years ' + CAST(DATEDIFF(MONTH,d.PracticeStartDate,GETDATE())%12 AS NVARCHAR) + ' Months' AS Experience
		 , d.HospId
		 , d.RegisterDate 
	  FROM dbo.Doctor d (NOLOCK)	  
	 WHERE @Input = CASE WHEN ISNUMERIC(@Input) = 1 THEN CAST(DocId AS NVARCHAR(64)) ELSE DocGUID END
	   --FOR JSON PATH, ROOT('Data')
END

/*
EXEC dbo.GetDocDetails '1' 
*/