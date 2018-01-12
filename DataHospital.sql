
SELECT * FROM dbo.Hospital


INSERT INTO dbo.Hospital([Name], Address1, Address2, City, [State], Zip, Country, Phone1, Phone2, Email, WebSite)
SELECT 'Apollo Health City Jubilee HIlls' --Name
     , 'Jubilee Hills' --Address1
     , '' --Address2
     , 'Hyderabad' --City
     , 'Telangana' --State
     , '500 033' --Zip
     , 'India' --Country
     , '040-60601066' --Phone1
     , '040-23607530' --Phone2
     , 'apollohealthcityhyd@apollohospitals.com' --Emails
     , 'https://www.apollohospitals.com' --WebSite     
 UNION
SELECT 'Apollo Hospital' --Name
     , 'Opp: Saibaba Temple, Bhagyanagar Colony' --Address1
     , 'Kukatpally' --Address2
     , 'Hyderabad' --City
     , 'Telangana' --State
     , '500072' --Zip
     , 'India' --Country
     , '040 2316 0039' --Phone1
     , '' --Phone2
     , 'hyderguda.apollo@gmail.com' --Emails
     , 'https://www.apollohospitals.com' --WebSite
 UNION
SELECT '' --Name
     , '' --Address1
     , '' --Address2
     , '' --City
     , '' --State
     , '' --Zip
     , '' --Country
     , '' --Phone1
     , '' --Phone2
     , '' --Emails
     , '' --WebSite
     
-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------

SELECT * FROM dbo.Doctor
INSERT INTO dbo.Doctor(FirstName, LastName, Email, Phone, Fee, Specialty, PracticeStartDate, HospId)
SELECT 'Alka' --FirstName
	 , 'Chengapa' --LastName
	 , 'Alka.Chengapa@gmail.com' --Email
	 , '9986587458' --Phone
	 , '500' --Fee
	 , 'Radiology & Pet-Ct' --Specialty
	 , '01/01/1994'
	 , 2 --HospId
 UNION
SELECT 'Ajit' --FirstName
	 , 'Vigg' --LastName
	 , 'Ajit.Vigg@gmail.com' --Email
	 , '9979859855' --Phone
	 , '300' --Fee
	 , 'Pulmonologist' --Specialty
	 , '01/01/1984'
	 , 1 --HospId
 UNION 
SELECT 'A G K' --FirstName
	 , 'Gokhale' --LastName
	 , 'Gokhale@gmail.com' --Email
	 , '9978569855' --Phone
	 , '200' --Fee
	 , 'Cardio Thoracic Surgeon' --Specialty
	 , '01/01/1981'
	 , 1 --HospId
	 