USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCategoryFixture]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [GamePlatform].[ProcCategoryFixture] 
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

	declare @LangComp int=@LangId


if(@LangComp not in (2,3,6))
	set @LangComp=2
 

 if (@CategoryId>0)
 begin
	
	insert @tempMatch
	select Cache.Fixture.MatchId
	FROM         Parameter.Competitor AS Competitor_1 with (nolock) INNER JOIN
                      Parameter.Competitor with (nolock) INNER JOIN
                      Language.ParameterCompetitor with (nolock) ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangComp INNER JOIN
                      Cache.Fixture with (nolock) ON Parameter.Competitor.CompetitorId = Cache.Fixture.HomeTeam ON Competitor_1.CompetitorId = Cache.Fixture.AwayTeam INNER JOIN
					  Parameter.Tournament with (nolock) ON Parameter.Tournament.TournamentId=Cache.Fixture.TournamentId INNER JOIN
                      Language.ParameterCompetitor  AS ParameterCompetitor_1 with (nolock) ON Competitor_1.CompetitorId = ParameterCompetitor_1.CompetitorId and ParameterCompetitor_1.LanguageId=@LangComp LEFT OUTER JOIN
                         Live.EventLiveStreaming with (nolock) ON Cache.Fixture.BetradarMatchId = Live.EventLiveStreaming.BetradarMatchId
Where  Parameter.Tournament.CategoryId=@CategoryId and 
		((Cache.Fixture.MatchDate)<=(@EndDate)) and ((CAST(Cache.Fixture.MatchDate AS Date)>=(CAST(@StartDate AS Date)))) and  Cache.Fixture.MatchDate>GETDATE()
		and  Parameter.Competitor.CompetitorId not in (15068,15118,15119,15069,15417,15994,16637,16681,17599,17598,16680,16636,15993,15416)
		and ParameterCompetitor_1.CompetitorId not in (15068,15118,15119,15069,15417,15994,16637,16681,17599,17598,16680,16636,15993,15416)


	
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
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetitor_1.CompetitorName AS EventName, 
                      Cache.Fixture.SportName, Cache.Fixture.OddId1, Cache.Fixture.OddValue1, Cache.Fixture.Odd1Visibility, Cache.Fixture.OddId2, Cache.Fixture.OddValue2, 
                      Cache.Fixture.Odd1Visibility2 as Odd2Visibility, Cache.Fixture.OddId3, Cache.Fixture.OddValue3, Cache.Fixture.Odd1Visibility3 as Odd3Visibility, Cache.Fixture.OddTypeCount, 
                      Cache.Fixture.TournamentId,Cache.Fixture.MatchDate as TournamentDate,Cache.Fixture.NeutralGround
					   ,Live.EventLiveStreaming.Web AS HasStreaming
					   ,TP.OverUnder as Total
					   ,TP.Overs as TotalOver
					   ,TP.Unders as TotalUnder
					   ,TP.OverId as TotalOverId
					   ,TP.UnderId as TotalUnderId
FROM         Parameter.Competitor AS Competitor_1 with (nolock)   INNER JOIN
                      Parameter.Competitor with (nolock) INNER JOIN
                      Language.ParameterCompetitor with (nolock) ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangComp INNER JOIN
                      Cache.Fixture with (nolock) ON Parameter.Competitor.CompetitorId = Cache.Fixture.HomeTeam ON Competitor_1.CompetitorId = Cache.Fixture.AwayTeam INNER JOIN
					  Parameter.Tournament with (nolock) ON Parameter.Tournament.TournamentId=Cache.Fixture.TournamentId INNER JOIN
                      Language.ParameterCompetitor AS ParameterCompetitor_1 with (nolock) ON Competitor_1.CompetitorId = ParameterCompetitor_1.CompetitorId and ParameterCompetitor_1.LanguageId=@LangComp LEFT OUTER JOIN
                         Live.EventLiveStreaming with (nolock) ON Cache.Fixture.BetradarMatchId = Live.EventLiveStreaming.BetradarMatchId LEFT OUTER JOIN @temptable2 as TP ON
						 TP.MatchId= Cache.Fixture.MatchId
Where  Parameter.Tournament.CategoryId=@CategoryId and 
		((Cache.Fixture.MatchDate)<=(@EndDate)) and ((CAST(Cache.Fixture.MatchDate AS Date)>=(CAST(@StartDate AS Date)))) and  Cache.Fixture.MatchDate>GETDATE()
		and  Parameter.Competitor.CompetitorId not in (15068,15118,15119,15069,15417,15994,16637,16681,17599,17598,16680,16636,15993,15416)
		and ParameterCompetitor_1.CompetitorId not in (15068,15118,15119,15069,15417,15994,16637,16681,17599,17598,16680,16636,15993,15416)
	
order by Parameter.Tournament.SequenceNumber
end
else
begin
	insert @tempMatch
	select Cache.Fixture.MatchId
	FROM         Parameter.Competitor AS Competitor_1 with (nolock) INNER JOIN
                      Parameter.Competitor with (nolock) INNER JOIN
                      Language.ParameterCompetitor with (nolock) ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangComp INNER JOIN
                      Cache.Fixture with (nolock) ON Parameter.Competitor.CompetitorId = Cache.Fixture.HomeTeam ON Competitor_1.CompetitorId = Cache.Fixture.AwayTeam INNER JOIN
					  Parameter.Tournament with (nolock) ON Parameter.Tournament.TournamentId=Cache.Fixture.TournamentId INNER JOIN
                      Language.ParameterCompetitor  AS ParameterCompetitor_1 with (nolock) ON Competitor_1.CompetitorId = ParameterCompetitor_1.CompetitorId and ParameterCompetitor_1.LanguageId=@LangComp LEFT OUTER JOIN
                         Live.EventLiveStreaming with (nolock) ON Cache.Fixture.BetradarMatchId = Live.EventLiveStreaming.BetradarMatchId
Where 
		((Cache.Fixture.MatchDate)<=(@EndDate)) and ((CAST(Cache.Fixture.MatchDate AS Date)>=(CAST(@StartDate AS Date)))) and  Cache.Fixture.MatchDate>GETDATE()
		and  Parameter.Competitor.CompetitorId not in (15068,15118,15119,15069,15417,15994,16637,16681,17599,17598,16680,16636,15993,15416)
		and ParameterCompetitor_1.CompetitorId not in (15068,15118,15119,15069,15417,15994,16637,16681,17599,17598,16680,16636,15993,15416)


	
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
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetitor_1.CompetitorName AS EventName, 
                      Cache.Fixture.SportName, Cache.Fixture.OddId1, Cache.Fixture.OddValue1, Cache.Fixture.Odd1Visibility, Cache.Fixture.OddId2, Cache.Fixture.OddValue2, 
                      Cache.Fixture.Odd1Visibility2 as Odd2Visibility, Cache.Fixture.OddId3, Cache.Fixture.OddValue3, Cache.Fixture.Odd1Visibility3 as Odd3Visibility, Cache.Fixture.OddTypeCount, 
                      Cache.Fixture.TournamentId,Cache.Fixture.MatchDate as TournamentDate,Cache.Fixture.NeutralGround
					   ,Live.EventLiveStreaming.Web AS HasStreaming
					   ,TP.OverUnder as Total
					   ,TP.Overs as TotalOver
					   ,TP.Unders as TotalUnder
					   ,TP.OverId as TotalOverId
					   ,TP.UnderId as TotalUnderId
FROM         Parameter.Competitor AS Competitor_1 with (nolock)  INNER JOIN
                      Parameter.Competitor with (nolock) INNER JOIN
                      Language.ParameterCompetitor with (nolock) ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangComp INNER JOIN
                      Cache.Fixture with (nolock) ON Parameter.Competitor.CompetitorId = Cache.Fixture.HomeTeam ON Competitor_1.CompetitorId = Cache.Fixture.AwayTeam INNER JOIN
					  Parameter.Tournament with (nolock) ON Parameter.Tournament.TournamentId=Cache.Fixture.TournamentId INNER JOIN
                      Language.ParameterCompetitor AS ParameterCompetitor_1 with (nolock) ON Competitor_1.CompetitorId = ParameterCompetitor_1.CompetitorId and ParameterCompetitor_1.LanguageId=@LangComp LEFT OUTER JOIN
                         Live.EventLiveStreaming with (nolock) ON Cache.Fixture.BetradarMatchId = Live.EventLiveStreaming.BetradarMatchId LEFT OUTER JOIN @temptable2 as TP ON
						 TP.MatchId= Cache.Fixture.MatchId
Where  
		((Cache.Fixture.MatchDate)<=(@EndDate)) and ((CAST(Cache.Fixture.MatchDate AS Date)>=(CAST(@StartDate AS Date)))) and  Cache.Fixture.MatchDate>GETDATE()
		and  Parameter.Competitor.CompetitorId not in (15068,15118,15119,15069,15417,15994,16637,16681,17599,17598,16680,16636,15993,15416)
		and ParameterCompetitor_1.CompetitorId not in (15068,15118,15119,15069,15417,15994,16637,16681,17599,17598,16680,16636,15993,15416)
	
order by Parameter.Tournament.SequenceNumber

end


END




GO
