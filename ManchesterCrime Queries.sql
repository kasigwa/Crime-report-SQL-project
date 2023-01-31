SELECT TOP 5*FROM[dbo].[2017_Population]
SELECT TOP 5*FROM[dbo].[2018_Population]

SELECT *FROM[dbo].[Crimes_Coursework]

UPDATE [dbo].[Crimes_Coursework]
SET [GeoLocation] = geography ::Point([Longitude],[Latitude],4326)
	WHERE [Longitude]IS NOT NULL 
  AND [Latitude] IS NOT NULL
Go




CREATE VIEW Tbl2017 AS
SELECT[Crime type],count(*)AS ' YEAR 2017'
from [dbo].[Crimes_Coursework]
WHERE [Month]='2017'
GROUP BY [Crime type]


CREATE VIEW Tbl2018 AS
SELECT [Crime type],count(*)AS ' YEAR 2018'
from [dbo].[Crimes_Coursework]
WHERE [Month]='2018'
GROUP BY [Crime type]


------ GREATER MANCHESTER CRIMES TYPE/YEAR
CREATE VIEW vCrimes AS
SELECT T.*,P.[ YEAR 2018]
FROM[dbo].[Tbl2017] as T left join [dbo].[Tbl2018]as P on 
	T.[Crime type]=P.[Crime type]




---======= Let us modity the area name  columm and creating a tbl then store it ================================================
---======= for its easy access by strore procedure======
CREATE VIEW Region_Crimes
 AS

SELECT[LSOA name],[Crime type],
	CASE 
		WHEN [LSOA name] LIKE'%Man%' THEN 'Manchester' 
		WHEN [LSOA name] LIKE'%Bol%' THEN 'Bolton'
		WHEN [LSOA name] LIKE'%Wi%' THEN 'Wigan'
		WHEN [LSOA name] LIKE'%Bu%' THEN 'Bury'
		WHEN [LSOA name] LIKE'%Ol%' THEN 'Oldham' 
		WHEN [LSOA name] LIKE'%Salf%' THEN 'Salford' 
		WHEN [LSOA name] LIKE'%Stock%' THEN 'Stockport'
		WHEN [LSOA name] LIKE'%Tameside%' THEN 'Tameside'
		WHEN [LSOA name] LIKE'%Trafford%' THEN 'Trafford'
		WHEN [LSOA name] LIKE'Rochdale%' THEN 'Rochdale'
		WHEN [LSOA name] LIKE'%Warr%' THEN 'Warrington'
		WHEN [LSOA name] LIKE'%Che%' THEN 'Cheshire_East'
		ELSE 'Other'
	END as LSOA, COUNT(*)AS[Numbr of Crimes]
FROM[dbo].[Crimes_Coursework]
group by [LSOA name],[Crime type]


CREATE VIEW AREA 
AS
SELECT distinct[LSOA],[Crime type],SUM([Numbr of Crimes])as TotalCrimes
FROM[dbo].[Region_Crimes]
	GROUP BY[LSOA],[Crime type]
	ORDER by [LSOA],[Crime type]

----- AREA CRIME FREQUENCY---------
CREATE VIEW FrqCrime2017_2018 AS
	SELECT[Crime type],sum([TotalCrimes])AS FrqCrimes2017_2018
	FROM[dbo].[AREA]
	group by [Crime type]

--  
-----TYPE CRIME PER YEAR---
-- we will now create store procedures for all views---
SELECT* FROM[dbo].[vCrimes]


Create procedure 
		SELECT* FROM[dbo].[AREA]
			ORDER BY [LSOA]
--===========================================
create procedure dbo.spFrqCrime_Get
 as
 begin
SELECT* FROM[dbo].[FrqCrime2017_2018]
End


exec dbo.spFrqCrime_Get
--==========================================
SELECT DISTINCT[LSOA]FROM[dbo].[AREA]
 
SELECT * FROM[dbo].[Region_Crimes]

 CREATE VIEW Burglary
  AS
 SELECT*FROM[dbo].[Crimes_Coursework]
 WHERE [Crime type]= 'Burglary'
 AND [GeoLocation]IS NOT NULL

-----//////////////////////////////////////////////////
CREATE VIEW GrtMchstr2017
 AS
--==== let us make it easy to access by a store procedure=============///
Create Procedure dbo.spGrtMchstr2017pop_Get
as
Begin
SELECT *
FROM[dbo].[2017_population]
  WHERE ([Area Names]='Manchester'or[Area Names]='Bury'OR[Area Names]='Bolton')
	OR([Area Names]='Trafford'OR  [Area Names]='Wigan'OR[Area Names]='Salford')
	OR([Area Names]='Oldham'OR[Area Names]='Rochdale'OR[Area Names]='Stockport')
	OR([Area Names]='Warrington'OR [Area Names]='Tameside'OR [Area Names]='Cheshire_East')
End

CREATE VIEW GrtMchstr2018
 AS
--==== let us make it easy to access by a store procedure=============///

Create Procedure dbo.spGrtMchstr2018pop_Get
as
Begin
SELECT *	
FROM[dbo].[2018_Population]
WHERE ([Area Names]='Manchester'or[Area Names]='Bury'OR[Area Names]='Bolton')
	OR([Area Names]='Trafford'OR  [Area Names]='Wigan'OR[Area Names]='Salford')
	OR([Area Names]='Oldham'OR[Area Names]='Rochdale'OR[Area Names]='Stockport')
	OR([Area Names]='Warrington'OR [Area Names]='Tameside'OR [Area Names]='Cheshire_East')
End

SELECT[Area Names],
	[Age(11-20)],
	[Age(21-30)]
FROM GrtMchstr2017Pop 
order by [Area Names]