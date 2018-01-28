DROP PROCEDURE dbo.GetAppointmentDetails
GO
CREATE PROCEDURE dbo.GetAppointmentDetails(
	   @UserID INT)
AS
BEGIN
	--WAITFOR DELAY '00:00:04'
	SELECT m.*
		 , 'Dr.'+ d.FirstName + ISNULL(', '+ d.LastName, '') AS DocName
		 , CASE WHEN m.StartTime IS NOT NULL THEN 0
				ELSE ISNULL((SELECT SUM(CASE WHEN s.StartTime IS NULL THEN 1 ELSE 0 END) +1 
							   FROM dbo.DocAppointment s (NOLOCK) 
							  WHERE s.UserID = m.UserID 
							    AND s.ApptID < m.ApptID
							    AND s.DocID = m.DocID
							    AND s.EndTime IS NULL 
							  GROUP BY s.DocID),1) END AS QueueCnt
		 , '00:32:14' AS WaitTime
	  FROM dbo.DocAppointment m (NOLOCK)	
	  LEFT JOIN dbo.Doctor d (NOLOCK)
	    ON m.DocID = d.DocID  
	 WHERE UserID = @UserID
	   AND EndTime IS NULL
END


/*
	EXEC dbo.GetAppointmentDetails 1

	update dbo.DocAppointment set starttime = NULL where apptID = 4
	update dbo.DocAppointment set endtime = getdate() where apptID = 19

	SELECT s.DocID, COUNT(*) 
	  FROM dbo.DocAppointment s (NOLOCK) 
	 WHERE s.UserID = 1 
	   AND s.ApptID < 35
	   AND s.DocID = 1
	   AND s.EndTime IS NULL 
	 GROUP BY s.DocID

	SELECT * FROM dbo.DocAppointment
*/