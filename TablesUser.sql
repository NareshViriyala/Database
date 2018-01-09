CREATE TABLE dbo.Users(
	   Id INT IDENTITY(1,1)
	 , FirstName NVARCHAR(100)
	 , LastName NVARCHAR(100)
	 , Email NVARCHAR(100)
	 , Phone NVARCHAR(15)
	 , PasswordHash VARBINARY(256)
	 , PasswordSalt VARBINARY(256))