DROP PROCEDURE dbo.ConfigureAppointment
GO
CREATE PROCEDURE dbo.ConfigureAppointment(
	   @JsonInput NVARCHAR(2000) OUTPUT --this will act as both input and output
	   /*
	   {
			"ApptID":0, --0 = new appt, non 0 = edit, end, cancel appt
			"UserID":1,
		    "Name":"PatientName",
			"Age":"24",
			"Gender":"M",
			"DocId":2,
			"ApptTime":"",
			"StartTime":"",
			"EndTime":"",
			"IsCancelled":0,
			"IsServerMap":1 -- 1 = appt set by doc device, 0 = appt set by patient device
			"UType":"" --start =  start time, end = end time, cancel = cancel time, NULL = new appt
			"Remark":"" --remark = any information you want to pass
	   }
	   */
)
AS
BEGIN

	DECLARE @LastID INT;

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
	 WHEN MATCHED THEN UPDATE
	  SET s.Name = d.Name
		, s.Age = d.Age
		, s.Gender = d.Gender
		, s.StartTime = CASE WHEN d.UType IN ('Start', 'Cancel') THEN ISNULL(s.StartTime, GETUTCDATE()) ELSE s.StartTime END
		, s.EndTime = CASE WHEN d.UType IN ('End', 'Cancel') THEN GETUTCDATE() ELSE s.EndTime END
		, s.IsCancelled = d.IsCancelled
		, s.IsServerMap = d.IsServerMap
	 WHEN NOT MATCHED THEN
   INSERT (UserID, Name, Age, Gender, DocId, ApptTime, StartTime, EndTime, IsCancelled, IsServerMap)
   VALUES (d.UserID, d.Name, d.Age, d.Gender, d.DocId, GETUTCDATE(), NULL, NULL, NULL, d.IsServerMap);

   SELECT @LastID = ISNULL(NULLIF(JSON_VALUE(@JsonInput, '$.ApptID'), 0), SCOPE_IDENTITY())
   SELECT @JsonInput = (SELECT *
							 , JSON_VALUE(@JsonInput, '$.UType') as UType 
							 , '' AS Remark
						  FROM dbo.DocAppointment 
						 WHERE ApptID = @LastID 
						   FOR JSON AUTO, INCLUDE_NULL_VALUES)
END

/*
	DECLARE @JsonInput NVARCHAR(2000) = '{"ApptID":3, "UserID":1,"Name":"PatientName12","Age":"24","Gender":"M","DocId":2,"ApptTime":"","IsCancelled":1,"IsServerMap":true,"UType":"Cancel"}'
	EXEC dbo.ConfigureAppointment @JsonInput = @JsonInput OUTPUT
	SELECT @JsonInput
	SELECT * FROM dbo.DocAppointment
*/


