DROP PROCEDURE dbo.ConfigureAppointment
GO
CREATE PROCEDURE dbo.ConfigureAppointment(
	   @JsonInput NVARCHAR(2000) 
	   /*
	   {
			"ApptID":0, --0 = new appt, non 0 = edit
			"UserID":1,
		    "Name":"PatientName",
			"Age":"24",
			"Gender":"M",
			"DocId":2,
			"ApptTime":"",
			"StartTime":"",
			"EndTime":"",
			"IsCancelled":0, --0 = not cacelled, 1 = cancelled ny doc, 2 = cancelled by patient
			"IsServerMap":1 -- 1 = appt set by doc device, 0 = appt set by patient device
			"UType":"" --start =  start time, end = end time, cancel = cancel time, NULL = new appt, get = get existing appointment details
			"Remark":"" --remark = any information you want to pass
	   }
	   */
)
AS
BEGIN

	DECLARE @LastID INT;

	IF(JSON_VALUE(@JsonInput, '$.UType') = 'Get')
	BEGIN
		SELECT @JsonInput = JSON_MODIFY(@JsonInput,'$.ApptID',ApptID)
			 , @JsonInput = JSON_MODIFY(@JsonInput,'$.Name',Name)
			 , @JsonInput = JSON_MODIFY(@JsonInput,'$.Age',Age)
			 , @JsonInput = JSON_MODIFY(@JsonInput,'$.Gender',Gender)
			 , @JsonInput = JSON_MODIFY(@JsonInput,'$.ApptTime',CAST(ApptTime AS NVARCHAR))
			 , @JsonInput = JSON_MODIFY(@JsonInput,'$.StartTime',CAST(StartTime AS NVARCHAR))
			 , @JsonInput = JSON_MODIFY(@JsonInput,'$.EndTime',CAST(EndTime AS NVARCHAR))
			 , @JsonInput = JSON_MODIFY(@JsonInput,'$.IsCancelled',IsCancelled)
			 , @JsonInput = JSON_MODIFY(@JsonInput,'$.IsServerMap',IsServerMap)
		  FROM dbo.DocAppointment 
		 WHERE UserID = JSON_VALUE(@JsonInput, '$.UserID')
		   AND DocID = JSON_VALUE(@JsonInput, '$.DocId')
		   AND EndTime IS NULL
		
		SELECT JSON_VALUE(@JsonInput, '$.ApptID') as ApptID
			, JSON_VALUE(@JsonInput, '$.UserID') as UserID
			, JSON_VALUE(@JsonInput, '$.Name') as Name
			, JSON_VALUE(@JsonInput, '$.Age') as Age
			, JSON_VALUE(@JsonInput, '$.Gender') as Gender
			, JSON_VALUE(@JsonInput, '$.DocId') as DocId
			, JSON_VALUE(@JsonInput, '$.ApptTime') as ApptTime
			, JSON_VALUE(@JsonInput, '$.StartTime') as StartTime
			, JSON_VALUE(@JsonInput, '$.EndTime') as EndTime
			, JSON_VALUE(@JsonInput, '$.IsCancelled') as IsCancelled
			, JSON_VALUE(@JsonInput, '$.IsServerMap') as IsServerMap
			, JSON_VALUE(@JsonInput, '$.UType') as UType
			, JSON_VALUE(@JsonInput, '$.Remark') as Remark

		RETURN
	END

	MERGE dbo.DocAppointment s
	USING (SELECT JSON_VALUE(@JsonInput, '$.ApptID') as ApptID
				, JSON_VALUE(@JsonInput, '$.UserID') as UserID
				, JSON_VALUE(@JsonInput, '$.Name') as Name
				, JSON_VALUE(@JsonInput, '$.Age') as Age
				, JSON_VALUE(@JsonInput, '$.Gender') as Gender
				, JSON_VALUE(@JsonInput, '$.DocId') as DocId
				, JSON_VALUE(@JsonInput, '$.ApptTime') as ApptTime
				, JSON_VALUE(@JsonInput, '$.StartTime') as StartTime
				, JSON_VALUE(@JsonInput, '$.EndTime') as EndTime
				, JSON_VALUE(@JsonInput, '$.IsCancelled') as IsCancelled
				, JSON_VALUE(@JsonInput, '$.IsServerMap') as IsServerMap
				, JSON_VALUE(@JsonInput, '$.UType') as UType
				, JSON_VALUE(@JsonInput, '$.Remark') as Remark) AS d
	   ON s.ApptID = d.ApptID
	 WHEN MATCHED AND s.EndTime IS NULL THEN UPDATE --Update the records only when the appt is not already ended
	  SET s.Name = d.Name
		, s.Age = d.Age
		, s.Gender = d.Gender
		, s.StartTime = CASE WHEN d.UType IN ('Start', 'Cancel') THEN ISNULL(s.StartTime, GETUTCDATE()) ELSE s.StartTime END
		, s.EndTime = CASE WHEN d.UType IN ('End', 'Cancel') THEN GETUTCDATE() ELSE s.EndTime END
		, s.IsCancelled = d.IsCancelled
		, s.IsServerMap = d.IsServerMap
	 WHEN NOT MATCHED AND d.EndTime IS NOT NULL THEN --Update the records only when the appt is not already ended
   INSERT (UserID, Name, Age, Gender, DocId, ApptTime, StartTime, EndTime, IsCancelled, IsServerMap)
   VALUES (d.UserID, d.Name, d.Age, d.Gender, d.DocId, GETUTCDATE(), NULL, NULL, 0, d.IsServerMap);

   SELECT @LastID = ISNULL(NULLIF(JSON_VALUE(@JsonInput, '$.ApptID'), 0), SCOPE_IDENTITY())
   --SELECT @JsonInput = (SELECT *
			--				 , JSON_VALUE(@JsonInput, '$.UType') as UType 
			--				 , '' AS Remark
			--			  FROM dbo.DocAppointment 
			--			 WHERE ApptID = @LastID 
			--			   FOR JSON AUTO, INCLUDE_NULL_VALUES)
   SELECT *
		 , JSON_VALUE(@JsonInput, '$.UType') as UType 
		 , '' AS Remark
	  FROM dbo.DocAppointment 
	 WHERE ApptID = @LastID 
	   --FOR JSON AUTO, INCLUDE_NULL_VALUES
END

/*
	DECLARE @JsonInput NVARCHAR(2000) = '{"ApptID":0,"UserID":1,"Name":"","Age":"","Gender":"","DocId":1,"ApptTime":"","StartTime":"","EndTime":"","IsCancelled":0,"IsServerMap":false,"UType":"Get","Remark":""}'
	EXEC dbo.ConfigureAppointment @JsonInput 
	
	SELECT * FROM dbo.DocAppointment	
*/


