USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Stadium].[ProcStadium]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 
CREATE PROCEDURE [Stadium].[ProcStadium] 
@BranchId bigint,
@LangId int
AS

BEGIN
SET NOCOUNT ON;

SELECT [StadiumId]
      ,[BranchId]
      ,[EntranceFee]
      ,Parameter.Currency.CurrencyId
	  ,Parameter.Currency.Sybol
      ,[MaxPlayer]
      ,[MinPlayer]
      ,[MinOddValue]
      ,[MaxOddValue]
      ,[ServiceFee]
      ,[CardChangeCount]
      ,[CardView]
      ,[CreateDate]
      ,[IsActive]
      ,[Comment]
      ,[StartDate]
      ,[EndDate]
	  ,ActivePlayerCount as CustomerCount
	  ,(ISNULL((select COUNT(*) from Stadium.Customers where Stadium.Customers.StadiumId=[Stadium].[Stadium].StadiumId),0)*[EntranceFee])-((ISNULL((select COUNT(*) from Stadium.Customers where Stadium.Customers.StadiumId=[Stadium].[Stadium].StadiumId),0)*[EntranceFee])*(ServiceFee/100)) as winamount
	  ,case when (Select Count(*) from Stadium.Sports where Stadium.Sports.StadiumId=[Stadium].[Stadium].StadiumId and SportId=-1)>0 then 'All Sport' else (Select Language.[Parameter.Sport].SportName from Stadium.Sports INNER JOIN Language.[Parameter.Sport] ON Stadium.Sports.SportId=Language.[Parameter.Sport].SportId where Stadium.Sports.StadiumId=[Stadium].[Stadium].StadiumId and LanguageId=@LangId) end SportName
	  ,case when (Select Count(*) from Stadium.Tournament where Stadium.Tournament.StadiumId=[Stadium].[Stadium].StadiumId and TournamentId=-1)>0 then 'All' else (Select Language.[Parameter.Tournament].TournamentName from Stadium.Tournament INNER JOIN Language.[Parameter.Tournament] ON Stadium.Tournament.TournamentId=[Parameter.Tournament].TournamentId where Stadium.Tournament.StadiumId=[Stadium].[Stadium].StadiumId and LanguageId=@LangId) end Tournament
	  ,'All' as EventName
  FROM [Stadium].[Stadium] with (nolock) INNER JOIN Parameter.Currency  with (nolock)
  On [Stadium].[Stadium].CurrencyId=Parameter.Currency.CurrencyId
  where BranchId=@BranchId and IsActive=1 and StartDate<=GETDATE() and EndDate>GETDATE()




END


GO
