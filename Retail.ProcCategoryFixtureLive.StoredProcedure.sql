USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcCategoryFixtureLive]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcCategoryFixtureLive] 
@CategoryId int,
@StartDate datetime,
@EndDate datetime,
@LangId int

AS

BEGIN
SET NOCOUNT ON;


	declare @tempMatch table (MatchId bigint)
	declare @temptable table (MatchId bigint,OverUnder nvarchar(20),Overs float,Unders float,OverId bigint,UnderId bigint)

	
	declare @temptable2 table (MatchId bigint,OverUnder nvarchar(20),Overs float,Unders float,OverId bigint,UnderId bigint)
	 



	if (@CategoryId>0)
	begin

	insert @tempMatch
	select Cache.Fixture.MatchId
	FROM         
                      Cache.Fixture with (nolock)  INNER JOIN
					  Parameter.Tournament with (nolock) ON Parameter.Tournament.TournamentId=Cache.Fixture.TournamentId INNER JOIN
                         Match.Code with (nolock) ON Cache.Fixture.BetradarMatchId = Match.Code.BetradarMatchId and Match.Code.BetTypeId=1
Where  Parameter.Tournament.CategoryId=@CategoryId and 
		((Cache.Fixture.MatchDate)<=(@EndDate)) and ((CAST(Cache.Fixture.MatchDate AS Date)>=(CAST(@StartDate AS Date)))) and  Cache.Fixture.MatchDate>GETDATE()
		 



	
		insert @temptable (MatchId,OverUnder)
				select Match.Odd.MatchId,MAX(SpecialBetValue) from Match.Odd with (nolock)  INNER JOIN @tempMatch as TM ON Match.Odd.MatchId=TM.MatchId where   BetradarOddTypeId=56 and OutCome='Over' and OddValue<2.7 GROUP BY Match.Odd.MatchId

		insert @temptable (MatchId,Overs,OverId)
			select  Match.Odd.MatchId,OddValue,OddId from Match.Odd with (nolock) INNER JOIN @temptable as TP ON Match.Odd.MatchId=TP.MatchId and Match.Odd.SpecialBetValue=TP.OverUnder 
			where   BetradarOddTypeId=56 and OutCome='Over' 

	insert @temptable (MatchId,Unders,UnderId)
select  Match.Odd.MatchId,OddValue,OddId from Match.Odd with (nolock) INNER JOIN @temptable as TP ON Match.Odd.MatchId=TP.MatchId and Match.Odd.SpecialBetValue=TP.OverUnder 
where   BetradarOddTypeId=56 and OutCome='Under'

-- ,EventDetail.TournamentName   , EventDetail.CategoryName

		insert @temptable2
		select MatchId ,MAX(OverUnder) ,SUM(Overs) ,SUM(Unders),MAX(OverId),MAX(UnderId)
	
		     from @temptable  GROUP BY MatchId

SELECT     Cache.Fixture.BetradarMatchId,Cache.Fixture.MatchId, Cache.Fixture.MatchDate,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetiTip_1.CompetitorName AS EventName, 
                      Cache.Fixture.SportName, Cache.Fixture.OddId1, Cache.Fixture.OddValue1, Cache.Fixture.Odd1Visibility, Cache.Fixture.OddId2, Cache.Fixture.OddValue2, 
                      Cache.Fixture.Odd1Visibility2 as Odd2Visibility, Cache.Fixture.OddId3, Cache.Fixture.OddValue3, Cache.Fixture.Odd1Visibility3 as Odd3Visibility, Cache.Fixture.OddTypeCount, 
                      Cache.Fixture.TournamentId,Cache.Fixture.MatchDate as TournamentDate,Cache.Fixture.NeutralGround
					   ,cast(1 as bit) AS HasStreaming
					   ,TP.OverUnder as Total
					   ,TP.Overs as TotalOver
					   ,TP.Unders as TotalUnder
					   ,TP.OverId as TotalOverId
					   ,TP.UnderId as TotalUnderId
					   			   ,Cache.Programme.OddIdFirstScore_1,Cache.Programme.OddValueFirstScore_1,Cache.Programme.OddVisibilityFirstScore_1
					   ,Cache.Programme.OddIdFirstScore_None,Cache.Programme.OddValueFirstScore_None,Cache.Programme.OddVisibilityFirstScore_None
					   ,Cache.Programme.OddIdFirstScore_2,Cache.Programme.OddValueFirstScore_2,Cache.Programme.OddVisibilityFirstScore_2
					   ,Language.[Parameter.Category].CategoryName,Language.[Parameter.Tournament].TournamentName
					   ,Match.Code.Code
FROM          
                      Language.ParameterCompetitor with (nolock) INNER JOIN
                      Cache.Fixture with (nolock) ON  Language.ParameterCompetitor.LanguageId=@LangId and Language.ParameterCompetitor.CompetitorId = Cache.Fixture.HomeTeam  INNER JOIN
					  Parameter.Tournament with (nolock) ON Parameter.Tournament.TournamentId=Cache.Fixture.TournamentId INNER JOIN
					    Cache.Programme with (nolock) ON Cache.Programme.MatchId=Cache.Fixture.MatchId INNER JOIN
						Language.[Parameter.Tournament] with (nolock) On Language.[Parameter.Tournament].TournamentId=Cache.Fixture.TournamentId and Language.[Parameter.Tournament].LanguageId=@LangId INNER JOIN
						Language.[Parameter.Category] with (nolock) ON Language.[Parameter.Category].CategoryId=Parameter.Tournament.CategoryId and Language.[Parameter.Category].LanguageId=@LangId INNER JOIN
                      Language.ParameterCompetitor AS ParameterCompetiTip_1 with (nolock) ON ParameterCompetiTip_1.CompetitorId = Cache.Fixture.AwayTeam and ParameterCompetiTip_1.LanguageId=@LangId INNER JOIN
                         Match.Code with (nolock) ON Cache.Fixture.BetradarMatchId = Match.Code.BetradarMatchId and Match.Code.BetTypeId=1 INNER JOIN @temptable2 as TP ON
						 TP.MatchId= Cache.Fixture.MatchId 
Where  Parameter.Tournament.CategoryId=@CategoryId and 
		((Cache.Fixture.MatchDate)<=(@EndDate)) and ((CAST(Cache.Fixture.MatchDate AS Date)>=(CAST(@StartDate AS Date)))) and  Cache.Fixture.MatchDate>GETDATE()
		and  Language.ParameterCompetitor.CompetitorId not in (15068,15118,15119,15069,15417,15994,16637,16681,17599,17598,16680,16636,15993,15416)
		and ParameterCompetiTip_1.CompetitorId not in (15068,15118,15119,15069,15417,15994,16637,16681,17599,17598,16680,16636,15993,15416)
	
order by Cache.Fixture.MatchDate
 end
 else
 begin
 insert @tempMatch
	select Cache.Fixture.MatchId
	FROM       Cache.Fixture with (nolock) INNER JOIN
                         Match.Code with (nolock) ON Cache.Fixture.BetradarMatchId = Match.Code.BetradarMatchId and Match.Code.BetTypeId=1
		where ((Cache.Fixture.MatchDate)<=(@EndDate)) and ((CAST(Cache.Fixture.MatchDate AS Date)>=(CAST(@StartDate AS Date)))) and  Cache.Fixture.MatchDate>GETDATE()
	



	
		insert @temptable (MatchId,OverUnder)
				select Match.Odd.MatchId,MAX(SpecialBetValue) from Match.Odd with (nolock)  INNER JOIN @tempMatch as TM ON Match.Odd.MatchId=TM.MatchId where   BetradarOddTypeId=56 and OutCome='Over' and OddValue<2.7 GROUP BY Match.Odd.MatchId

		insert @temptable (MatchId,Overs,OverId)
			select  Match.Odd.MatchId,OddValue,OddId from Match.Odd with (nolock) INNER JOIN @temptable as TP ON Match.Odd.MatchId=TP.MatchId and Match.Odd.SpecialBetValue=TP.OverUnder 
			where   BetradarOddTypeId=56 and OutCome='Over' 

	insert @temptable (MatchId,Unders,UnderId)
select  Match.Odd.MatchId,OddValue,OddId from Match.Odd with (nolock) INNER JOIN @temptable as TP ON Match.Odd.MatchId=TP.MatchId and Match.Odd.SpecialBetValue=TP.OverUnder 
where   BetradarOddTypeId=56 and OutCome='Under'



		insert @temptable2
		select MatchId ,MAX(OverUnder) ,SUM(Overs) ,SUM(Unders),MAX(OverId),MAX(UnderId)
	
		     from @temptable  GROUP BY MatchId

SELECT     Cache.Fixture.BetradarMatchId,Cache.Fixture.MatchId, Cache.Fixture.MatchDate,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetiTip_1.CompetitorName AS EventName, 
                      Cache.Fixture.SportName, Cache.Fixture.OddId1, Cache.Fixture.OddValue1, Cache.Fixture.Odd1Visibility, Cache.Fixture.OddId2, Cache.Fixture.OddValue2, 
                      Cache.Fixture.Odd1Visibility2 as Odd2Visibility, Cache.Fixture.OddId3, Cache.Fixture.OddValue3, Cache.Fixture.Odd1Visibility3 as Odd3Visibility, Cache.Fixture.OddTypeCount, 
                      Cache.Fixture.TournamentId,Cache.Fixture.MatchDate as TournamentDate,Cache.Fixture.NeutralGround
					   ,cast(1 as bit) AS HasStreaming
					   ,TP.OverUnder as Total
					   ,TP.Overs as TotalOver
					   ,TP.Unders as TotalUnder
					   ,TP.OverId as TotalOverId
					   ,TP.UnderId as TotalUnderId
					   ,Cache.Programme.OddIdFirstScore_1,Cache.Programme.OddValueFirstScore_1,Cache.Programme.OddVisibilityFirstScore_1
					   ,Cache.Programme.OddIdFirstScore_None,Cache.Programme.OddValueFirstScore_None,Cache.Programme.OddVisibilityFirstScore_None
					   ,Cache.Programme.OddIdFirstScore_2,Cache.Programme.OddValueFirstScore_2,Cache.Programme.OddVisibilityFirstScore_2
					   ,Language.[Parameter.Category].CategoryName,Language.[Parameter.Tournament].TournamentName
					   ,Match.Code.Code
FROM           Language.ParameterCompetitor with (nolock) INNER JOIN
                      Cache.Fixture with (nolock) ON  Language.ParameterCompetitor.LanguageId=@LangId and Language.ParameterCompetitor.CompetitorId = Cache.Fixture.HomeTeam  INNER JOIN
					  Parameter.Tournament with (nolock) ON Parameter.Tournament.TournamentId=Cache.Fixture.TournamentId INNER JOIN
					    Cache.Programme with (nolock) ON Cache.Programme.MatchId=Cache.Fixture.MatchId INNER JOIN
						Language.[Parameter.Tournament] with (nolock) On Language.[Parameter.Tournament].TournamentId=Cache.Fixture.TournamentId and Language.[Parameter.Tournament].LanguageId=@LangId INNER JOIN
						Language.[Parameter.Category] with (nolock) ON Language.[Parameter.Category].CategoryId=Parameter.Tournament.CategoryId and Language.[Parameter.Category].LanguageId=@LangId INNER JOIN
                      Language.ParameterCompetitor AS ParameterCompetiTip_1 with (nolock) ON ParameterCompetiTip_1.CompetitorId = Cache.Fixture.AwayTeam and ParameterCompetiTip_1.LanguageId=@LangId INNER JOIN
                         Match.Code with (nolock) ON Cache.Fixture.BetradarMatchId = Match.Code.BetradarMatchId and Match.Code.BetTypeId=1 INNER JOIN @temptable2 as TP ON
						 TP.MatchId= Cache.Fixture.MatchId 
Where  
		((Cache.Fixture.MatchDate)<=(@EndDate)) and ((CAST(Cache.Fixture.MatchDate AS Date)>=(CAST(@StartDate AS Date)))) and  Cache.Fixture.MatchDate>GETDATE()
		and  Language.ParameterCompetitor.CompetitorId not in (15068,15118,15119,15069,15417,15994,16637,16681,17599,17598,16680,16636,15993,15416)
		and ParameterCompetiTip_1.CompetitorId not in (15068,15118,15119,15069,15417,15994,16637,16681,17599,17598,16680,16636,15993,15416)
	
order by Cache.Fixture.MatchDate

 end
END




GO
