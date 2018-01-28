DROP PROCEDURE dbo.GetDocQueueCount
GO
CREATE PROCEDURE dbo.GetDocQueueCount(
	   @Input NVARCHAR(64) --number or guid of doctor
	 , @UserID INT = 0) --if userid present then response q number w.r.t user else respond current q of doctor
AS
BEGIN
	--WAITFOR DELAY '00:00:04'
	IF(ISNULL(@UserID,0) <> 0)
		SELECT CASE WHEN m.StartTime IS NOT NULL THEN 0
					ELSE ISNULL((SELECT SUM(CASE WHEN s.StartTime IS NULL THEN 1 ELSE 0 END) +1 
								   FROM dbo.DocAppointment s (NOLOCK) 
								  WHERE s.UserID = m.UserID 
									AND s.ApptID < m.ApptID
									AND s.DocID = m.DocID
									AND s.EndTime IS NULL 
								  GROUP BY s.DocID),1) END AS QCnt
			 , '00:32:14' AS WaitTime
		  FROM dbo.DocAppointment m (NOLOCK)	
		  JOIN dbo.Doctor d (NOLOCK)
			ON m.DocID = d.DocID  
		 WHERE UserID = @UserID
		   AND @Input = CASE WHEN ISNUMERIC(@Input) = 1 THEN CAST(d.DocId AS NVARCHAR(64)) ELSE d.DocGUID END
		   AND EndTime IS NULL
	ELSE
		SELECT ISNULL(COUNT(*),0) AS QCnt, ('00:28:52') AS WaitTime
		  FROM dbo.DocAppointment m (NOLOCK)
		  JOIN dbo.Doctor d (NOLOCK)
			ON m.DocId = d.DocId	
		 WHERE @Input = CASE WHEN ISNUMERIC(@Input) = 1 THEN CAST(d.DocId AS NVARCHAR(64)) ELSE d.DocGUID END
		   AND StartTime IS NULL
END


/*
	EXEC dbo.GetDocQueueCount '1',1
	
	SELECT * FROM dbo.DocAppointment

	SELECT * FROM Doctor
*/