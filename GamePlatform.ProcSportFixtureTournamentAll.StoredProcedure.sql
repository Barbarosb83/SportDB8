USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcSportFixtureTournamentAll]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [GamePlatform].[ProcSportFixtureTournamentAll] 
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
Where  Cache.Fixture.TournamentId in (select TournamentId from Parameter.Tournament where TerminalTournamentId=@TournamentId) and ((CAST(Cache.Fixture.MatchDate AS Date)=(CAST(@EventDate AS Date)))) and  Cache.Fixture.MatchDate>DATEADD(MINUTE,5,GETDATE())

	
 


SELECT  DISTINCT   Cache.Fixture.BetradarMatchId,Cache.Fixture.MatchId,Match.Odd.OddId,Match.Odd.OddsTypeId,Match.Odd.OutCome
					   ,Match.Odd.SpecialBetValue,Match.Odd.OddValue,Match.Odd.ParameterOddId
FROM         
                      Cache.Fixture with (nolock)   INNER JOIN
						 Match.Odd with (nolock)  On Match.Odd.MatchId=Cache.Fixture.MatchId
Where  Cache.Fixture.TournamentId in (select TournamentId from Parameter.Tournament with (nolock)  where TerminalTournamentId=@TournamentId)  and ((CAST(Cache.Fixture.MatchDate AS Date)=(CAST(@EventDate AS Date)))) 
and  Cache.Fixture.MatchDate>DATEADD(MINUTE,5,GETDATE())
	
 
 end
 else
	begin
	insert @tempMatch
	select Cache.Fixture.MatchId
	FROM         Parameter.Competitor AS Competitor_1 with (nolock)  INNER JOIN
                      Parameter.Competitor with (nolock) INNER JOIN
                      Language.ParameterCompetitor with (nolock) ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangComp INNER JOIN
                      Cache.Fixture with (nolock) ON Parameter.Competitor.CompetitorId = Cache.Fixture.HomeTeam ON Competitor_1.CompetitorId = Cache.Fixture.AwayTeam INNER JOIN
					  Parameter.Tournament with (nolock) ON Parameter.Tournament.TournamentId=Cache.Fixture.TournamentId INNER JOIN
                      Language.ParameterCompetitor AS ParameterCompetitor_1 with (nolock) ON Competitor_1.CompetitorId = ParameterCompetitor_1.CompetitorId and ParameterCompetitor_1.LanguageId=@LangComp 
Where  Cache.Fixture.TournamentId in (select TournamentId from Parameter.Tournament where TerminalTournamentId=@TournamentId)  and   Cache.Fixture.MatchDate>=DATEADD(MINUTE,5,GETDATE())
 
 
  
   

SELECT  DISTINCT   Cache.Fixture.BetradarMatchId,Cache.Fixture.MatchId,Match.Odd.OddId,Match.Odd.OddsTypeId,Match.Odd.OutCome
					   ,Match.Odd.SpecialBetValue,Match.Odd.OddValue,Match.Odd.ParameterOddId
FROM         
                      Cache.Fixture with (nolock)  
					  INNER JOIN
						 Match.Odd with (nolock)  On Match.Odd.MatchId=Cache.Fixture.MatchId
Where  Cache.Fixture.TournamentId in (select TournamentId from Parameter.Tournament with (nolock)  where TerminalTournamentId=@TournamentId)  and   Cache.Fixture.MatchDate>=DATEADD(MINUTE,5,GETDATE())
 

	 

	end
 end

 

END




GO
