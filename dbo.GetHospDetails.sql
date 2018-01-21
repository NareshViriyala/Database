DROP PROCEDURE dbo.GetHospDetails
GO
CREATE PROCEDURE dbo.GetHospDetails(
	   @Input NVARCHAR(64) --@Input could be DocId or DocGUID or HospID
	 , @InputType NVARCHAR(10) --If @InputType = 'Doc' Then @Input could be DocId or DocGUID 
							   --If @InputType = 'Hosp' Then @Input is HospId
)
AS
BEGIN

	IF @InputType = 'Doc'
		SELECT h.*
		  FROM dbo.Hospital h (NOLOCK)
		  JOIN dbo.Doctor d (NOLOCK)
			ON h.HospId = d.HospId
		 WHERE @Input = CASE WHEN ISNUMERIC(@Input) = 1 THEN CAST(d.DocId AS NVARCHAR(64)) ELSE d.DocGUID END
	ELSE
		SELECT * 
		  FROM dbo.Hospital (NOLOCK)
		 WHERE HospId = @Input
END

/*
EXEC dbo.GetHospDetails '1', 'Doc' 
*/