DROP TABLE dbo.Doctor 
GO
CREATE TABLE dbo.Doctor(
	   DocId INT IDENTITY(1,1)
	 , DocGUID UNIQUEIDENTIFIER DEFAULT NEWID()
	 , FirstName NVARCHAR(100)
	 , LastName NVARCHAR(100)
	 , Email NVARCHAR(100)
	 , Phone NVARCHAR(100)
	 , Fee NVARCHAR(100)
	 , Specialty NVARCHAR(50)
	 , PracticeStartDate DATE 
	 , HospId INT
	 , RegisterDate DATETIME DEFAULT(GETDATE())
)

DROP TABLE dbo.DoctorServiceInfo
GO
CREATE TABLE dbo.DoctorServiceInfo(
	   Id INT IDENTITY(1,1)
	 , DocId INT
	 , [Day] NVARCHAR(20)
	 , TimeFrom TIME
	 , TimeTo TIME
	 , Fee NVARCHAR(100)
	 , Phone NVARCHAR(100)
	 , LastUpdate DATETIME DEFAULT(GETDATE())
)

DROP TABLE dbo.Hospital
GO
CREATE TABLE dbo.Hospital(
	   HospId INT IDENTITY(1,1)
	 , [Name] NVARCHAR(200)
	 , Address1 NVARCHAR(100)
	 , Address2 NVARCHAR(100)
	 , City NVARCHAR(50)
	 , [State] NVARCHAR(50)
	 , Zip NVARCHAR(20)
	 , Country NVARCHAR(100)
	 , Phone1 NVARCHAR(20)
	 , Phone2 NVARCHAR(20)
	 , Email NVARCHAR(50)
	 , WebSite NVARCHAR(200)
)