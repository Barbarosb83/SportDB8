USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcSportFixtureTerminalAll]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 
CREATE PROCEDURE [GamePlatform].[ProcSportFixtureTerminalAll] 
@TournamentId int, --BetradarTournamentId geliyor.
@EventDate datetime,
@LangId int

AS
BEGIN
SET NOCOUNT ON;


	declare @tempMatch table (MatchId bigint)
 
 declare @LangComp int=@LangId


if(@LangComp not in (2,3,6))
	set @LangComp=2
 

 if @TournamentId<>0
 begin
	if(CAST(@EventDate AS Date)>=CAST (GETDATE() as Date))
	begin
	insert @tempMatch
	select Cache.Fixture.MatchId
	FROM         Parameter.Competitor AS Competitor_1 with (nolock) INNER JOIN
                      Parameter.Competitor with (nolock) INNER JOIN
                      Language.ParameterCompetitor with (nolock) ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangComp INNER JOIN
                      Cache.Fixture with (nolock) ON Parameter.Competitor.CompetitorId = Cache.Fixture.HomeTeam ON Competitor_1.CompetitorId = Cache.Fixture.AwayTeam INNER JOIN
					  Parameter.Tournament with (nolock) ON Parameter.Tournament.TournamentId=Cache.Fixture.TournamentId INNER JOIN
                      Language.ParameterCompetitor AS ParameterCompetitor_1  with (nolock) ON Competitor_1.CompetitorId = ParameterCompetitor_1.CompetitorId and ParameterCompetitor_1.LanguageId=@LangComp  
Where  Cache.Fixture.TournamentId in (select TournamentId from Parameter.Tournament with (nolock)  where TerminalTournamentId=@TournamentId) and ((CAST(Cache.Fixture.MatchDate AS Date)=(CAST(@EventDate AS Date)))) and  Cache.Fixture.MatchDate>DATEADD(MINUTE,2,GETDATE())
 
	
 


SELECT  DISTINCT   Cache.Fixture.BetradarMatchId,Cache.Fixture.MatchId, Cache.Fixture.MatchDate,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetitor_1.CompetitorName AS EventName, 
                      Cache.Fixture.SportName, Cache.Fixture.OddId1, Cache.Fixture.OddValue1, Cache.Fixture.Odd1Visibility, Cache.Fixture.OddId2, Cache.Fixture.OddValue2, 
                      Cache.Fixture.Odd1Visibility2 as Odd2Visibility, Cache.Fixture.OddId3, Cache.Fixture.OddValue3, Cache.Fixture.Odd1Visibility3 as Odd3Visibility, Cache.Fixture.OddTypeCount, 
                      Cache.Fixture.TournamentId,Cache.Fixture.MatchDate as TournamentDate,Cache.Fixture.NeutralGround
					   ,case when Match.Code.BetradarMatchId is not null then 1 else 0 end AS IsLive
					  
					   ,Parameter.Tournament.CategoryId
					   ,ISNULL(Parameter.Category.SequenceNumber,999) as SequenceNumber
					   ,Parameter.Tournament.IsPopularTerminal
					   ,Language.[Parameter.Tournament].TournamentName,Language.[Parameter.Category].CategoryName,Match.Odd.OddId,Match.Odd.OddsTypeId,Match.Odd.OutCome
					   ,Match.Odd.SpecialBetValue,Match.Odd.OddValue,Match.Odd.ParameterOddId
FROM         Parameter.Competitor AS Competitor_1 with (nolock) INNER JOIN
                      Parameter.Competitor with (nolock) INNER JOIN
                      Language.ParameterCompetitor with (nolock) ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangComp INNER JOIN
                      Cache.Fixture with (nolock) ON Parameter.Competitor.CompetitorId = Cache.Fixture.HomeTeam ON Competitor_1.CompetitorId = Cache.Fixture.AwayTeam INNER JOIN
					  Parameter.Tournament with (nolock) ON Parameter.Tournament.TournamentId=Cache.Fixture.TournamentId INNER JOIN
                      Language.ParameterCompetitor AS ParameterCompetitor_1 with (nolock) ON Competitor_1.CompetitorId = ParameterCompetitor_1.CompetitorId and ParameterCompetitor_1.LanguageId=@LangComp INNER JOIN
                         Match.Code with (nolock) ON Cache.Fixture.BetradarMatchId = Match.Code.BetradarMatchId and Match.Code.BetTypeId=1 INNER JOIN Parameter.Category  with (nolock) On Parameter.Category.CategoryId=Parameter.Tournament.CategoryId INNER JOIN Language.[Parameter.Tournament]  with (nolock) ON
						 Language.[Parameter.Tournament].TournamentId=Parameter.Tournament.TournamentId and Language.[Parameter.Tournament].LanguageId=@LangId INNER JOIN Language.[Parameter.Category] with (nolock)  ON
						 Language.[Parameter.Category].CategoryId=Parameter.Category.CategoryId and Language.[Parameter.Category].LanguageId=@LangId INNER JOIN
						 Match.Odd On Match.Odd.MatchId=Cache.Fixture.MatchId
Where  Cache.Fixture.TournamentId in (select TournamentId from Parameter.Tournament with (nolock)  where TerminalTournamentId=@TournamentId)  and ((CAST(Cache.Fixture.MatchDate AS Date)=(CAST(@EventDate AS Date)))) and  Cache.Fixture.MatchDate>DATEADD(MINUTE,2,GETDATE())
 
	
 ORDER BY Cache.Fixture.MatchDate 
 end
 else
	begin
	insert @tempMatch
	select Cache.Fixture.MatchId
	FROM         Parameter.Competitor AS Competitor_1  with (nolock) INNER JOIN
                      Parameter.Competitor with (nolock) INNER JOIN
                      Language.ParameterCompetitor with (nolock) ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangComp INNER JOIN
                      Cache.Fixture with (nolock) ON Parameter.Competitor.CompetitorId = Cache.Fixture.HomeTeam ON Competitor_1.CompetitorId = Cache.Fixture.AwayTeam INNER JOIN
					  Parameter.Tournament with (nolock) ON Parameter.Tournament.TournamentId=Cache.Fixture.TournamentId INNER JOIN
                      Language.ParameterCompetitor AS ParameterCompetitor_1 with (nolock) ON Competitor_1.CompetitorId = ParameterCompetitor_1.CompetitorId and ParameterCompetitor_1.LanguageId=@LangComp   
Where  Cache.Fixture.TournamentId in (select TournamentId from Parameter.Tournament where TerminalTournamentId=@TournamentId)  and   Cache.Fixture.MatchDate>=DATEADD(MINUTE,2,GETDATE())
 
 
  
   

SELECT  DISTINCT   Cache.Fixture.BetradarMatchId,Cache.Fixture.MatchId, Cache.Fixture.MatchDate,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetitor_1.CompetitorName AS EventName, 
                      Cache.Fixture.SportName, Cache.Fixture.OddId1, Cache.Fixture.OddValue1, Cache.Fixture.Odd1Visibility, Cache.Fixture.OddId2, Cache.Fixture.OddValue2, 
                      Cache.Fixture.Odd1Visibility2 as Odd2Visibility, Cache.Fixture.OddId3, Cache.Fixture.OddValue3, Cache.Fixture.Odd1Visibility3 as Odd3Visibility, Cache.Fixture.OddTypeCount, 
                      Cache.Fixture.TournamentId,Cache.Fixture.MatchDate as TournamentDate,Cache.Fixture.NeutralGround
					   ,case when Match.Code.BetradarMatchId is not null then 1 else 0 end AS IsLive
					   ,Parameter.Tournament.CategoryId
					    ,ISNULL(Parameter.Category.SequenceNumber,999) as SequenceNumber
					   ,Parameter.Tournament.IsPopularTerminal
					   ,Language.[Parameter.Tournament].TournamentName,Language.[Parameter.Category].CategoryName,Match.Odd.OddId,Match.Odd.OddsTypeId,Match.Odd.OutCome
					   ,Match.Odd.SpecialBetValue,Match.Odd.OddValue,Match.Odd.ParameterOddId
FROM         Parameter.Competitor AS Competitor_1 with (nolock) INNER JOIN
                      Parameter.Competitor with (nolock) INNER JOIN
                      Language.ParameterCompetitor with (nolock) ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangComp INNER JOIN
                      Cache.Fixture with (nolock) ON Parameter.Competitor.CompetitorId = Cache.Fixture.HomeTeam ON Competitor_1.CompetitorId = Cache.Fixture.AwayTeam INNER JOIN
					  Parameter.Tournament with (nolock) ON Parameter.Tournament.TournamentId=Cache.Fixture.TournamentId INNER JOIN
                      Language.ParameterCompetitor AS ParameterCompetitor_1 with (nolock) ON Competitor_1.CompetitorId = ParameterCompetitor_1.CompetitorId and ParameterCompetitor_1.LanguageId=@LangComp INNER JOIN
                         Match.Code with (nolock) ON Cache.Fixture.BetradarMatchId = Match.Code.BetradarMatchId and Match.Code.BetTypeId=1  INNER JOIN Parameter.Category with (nolock)  On Parameter.Category.CategoryId=Parameter.Tournament.CategoryId INNER JOIN Language.[Parameter.Tournament] with (nolock)  ON
						 Language.[Parameter.Tournament].TournamentId=Parameter.Tournament.TournamentId and Language.[Parameter.Tournament].LanguageId=@LangId INNER JOIN Language.[Parameter.Category] with (nolock)  ON
						 Language.[Parameter.Category].CategoryId=Parameter.Category.CategoryId and Language.[Parameter.Category].LanguageId=@LangId INNER JOIN
						 Match.Odd with (nolock)  On Match.Odd.MatchId=Cache.Fixture.MatchId
Where  Cache.Fixture.TournamentId in (select TournamentId from Parameter.Tournament  with (nolock) where TerminalTournamentId=@TournamentId)  and   Cache.Fixture.MatchDate>=DATEADD(MINUTE,2,GETDATE())
 

		ORDER BY Cache.Fixture.MatchDate

	end
 end

 

END




GO
