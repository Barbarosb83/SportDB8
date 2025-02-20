USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcSportFixture]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 
CREATE PROCEDURE [GamePlatform].[ProcSportFixture] 
@SportId int,
@EventDate datetime,
@LangId int

AS
BEGIN
SET NOCOUNT ON;

declare @LangComp int=@LangId


if(@LangComp not in (2,3,6))
	set @LangComp=2
 

 if @SportId<>0
	 begin
		if(CAST(@EventDate AS Date)>=CAST (GETDATE() as Date))
			begin
	 
		SELECT  DISTINCT   Cache.Fixture.BetradarMatchId,Cache.Fixture.MatchId, Cache.Fixture.MatchDate,
		  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetitor_1.CompetitorName AS EventName, 
							  Language.[Parameter.Sport].SportName,  Cache.Fixture.OddTypeCount, 
							  Cache.Fixture.TournamentId,Cache.Fixture.MatchDate as TournamentDate,Cache.Fixture.NeutralGround
							   ,case when (select COUNT(BetradarMatchId) from Match.Code with (nolock) where BetradarMatchId=Cache.Fixture.BetradarMatchId and BetTypeId=1)>0 then 1 else 0 end AS IsLive
							
							   ,Parameter.Tournament.CategoryId
							   ,Parameter.Category.SequenceNumber
							   ,Parameter.Tournament.IsPopularTerminal
							   ,Language.[Parameter.Tournament].TournamentName,Language.[Parameter.Category].CategoryName
							   ,Cache.Fixture.SportName as SportNameOrginal
							   ,LOWER(Parameter.Iso.IsoName2) as IsoName
							   ,'' as Code
							    ,Parameter.Competitor.BetradarSuperId as HomeTeamId
							   ,Competitor_1.BetradarSuperId as AwayTeamId
							   ,Parameter.Tournament.NewBetradarId as BetradarTournamentId
		FROM         Parameter.Competitor AS Competitor_1 with (nolock) INNER JOIN
							  Parameter.Competitor with (nolock) INNER JOIN
							  Language.ParameterCompetitor with (nolock) ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangComp INNER JOIN
							  Cache.Fixture with (nolock) ON Parameter.Competitor.CompetitorId = Cache.Fixture.HomeTeam ON Competitor_1.CompetitorId = Cache.Fixture.AwayTeam INNER JOIN
							  Parameter.Tournament with (nolock) ON Parameter.Tournament.TournamentId=Cache.Fixture.TournamentId INNER JOIN
							  Language.ParameterCompetitor   AS ParameterCompetitor_1 with (nolock) ON Competitor_1.CompetitorId = ParameterCompetitor_1.CompetitorId and ParameterCompetitor_1.LanguageId=@LangComp INNER JOIN
							--	 Match.Code with (nolock) ON Cache.Fixture.BetradarMatchId = Match.Code.BetradarMatchId and Match.Code.BetTypeId=0 INNER JOIN
								  Parameter.Category with (nolock) On Parameter.Category.CategoryId=Parameter.Tournament.CategoryId INNER JOIN 
								  Parameter.Iso with (nolock) On Parameter.Iso.IsoId=Parameter.Category.IsoId INNER JOIN
								  Language.[Parameter.Tournament] with (nolock) ON Language.[Parameter.Tournament].TournamentId=Parameter.Tournament.TournamentId and Language.[Parameter.Tournament].LanguageId=@LangId INNER JOIN 
								  Language.[Parameter.Category] with (nolock) ON Language.[Parameter.Category].CategoryId=Parameter.Category.CategoryId and Language.[Parameter.Category].LanguageId=@LangId INNER JOIN
						 Language.[Parameter.Sport] with (nolock)  ON Language.[Parameter.Sport].SportId=Parameter.Category.SportId and Language.[Parameter.Sport].LanguageId=@LangId
		Where  Cache.Fixture.SportId=@SportId  and ((CAST(Cache.Fixture.MatchDate AS Date)<=(CAST(@EventDate AS Date)))) and  Cache.Fixture.MatchDate>DATEADD(MINUTE,2,GETDATE())
		 
				--ORDER BY Cache.Fixture.MatchDate
		 end
		else
			begin
		

		SELECT  DISTINCT   Cache.Fixture.BetradarMatchId,Cache.Fixture.MatchId, Cache.Fixture.MatchDate,
		  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetitor_1.CompetitorName AS EventName, 
							  Language.[Parameter.Sport].SportName,  Cache.Fixture.OddTypeCount, 
							  Cache.Fixture.TournamentId,Cache.Fixture.MatchDate as TournamentDate,Cache.Fixture.NeutralGround
							   ,case when (select COUNT(BetradarMatchId) from Match.Code with (nolock) where BetradarMatchId=Cache.Fixture.BetradarMatchId and BetTypeId=1)>0 then 1 else 0 end AS IsLive
							  
							   ,Parameter.Tournament.CategoryId
							   ,Parameter.Category.SequenceNumber
							   ,Parameter.Tournament.IsPopularTerminal
							   ,Language.[Parameter.Tournament].TournamentName,Language.[Parameter.Category].CategoryName
							    ,Cache.Fixture.SportName as SportNameOrginal
								 ,LOWER(Parameter.Iso.IsoName2) as IsoName
							   , '' as Code
							    ,Parameter.Competitor.BetradarSuperId as HomeTeamId
							   ,Competitor_1.BetradarSuperId as AwayTeamId
							   ,Parameter.Tournament.NewBetradarId as BetradarTournamentId
		FROM         Parameter.Competitor AS Competitor_1 with (nolock) INNER JOIN
							  Parameter.Competitor with (nolock) INNER JOIN
							  Language.ParameterCompetitor with (nolock) ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangComp INNER JOIN
							  Cache.Fixture with (nolock) ON Parameter.Competitor.CompetitorId = Cache.Fixture.HomeTeam ON Competitor_1.CompetitorId = Cache.Fixture.AwayTeam INNER JOIN
							  Parameter.Tournament with (nolock) ON Parameter.Tournament.TournamentId=Cache.Fixture.TournamentId INNER JOIN
							  Language.ParameterCompetitor AS ParameterCompetitor_1 with (nolock) ON Competitor_1.CompetitorId = ParameterCompetitor_1.CompetitorId and ParameterCompetitor_1.LanguageId=@LangComp INNER JOIN
								-- Match.Code with (nolock) ON Cache.Fixture.BetradarMatchId = Match.Code.BetradarMatchId and Match.Code.BetTypeId=0 INNER JOIN 
								Parameter.Category On Parameter.Category.CategoryId=Parameter.Tournament.CategoryId INNER JOIN 
								 Parameter.Iso with (nolock) On Parameter.Iso.IsoId=Parameter.Category.IsoId INNER JOIN
								 Language.[Parameter.Tournament]  with (nolock) ON
								 Language.[Parameter.Tournament].TournamentId=Parameter.Tournament.TournamentId and Language.[Parameter.Tournament].LanguageId=@LangId INNER JOIN Language.[Parameter.Category] with (nolock) ON
								 Language.[Parameter.Category].CategoryId=Parameter.Category.CategoryId and Language.[Parameter.Category].LanguageId=@LangId INNER JOIN
						 Language.[Parameter.Sport] with (nolock) ON Language.[Parameter.Sport].SportId=Parameter.Category.SportId and Language.[Parameter.Sport].LanguageId=@LangId
		Where  Cache.Fixture.SportId=@SportId  and   Cache.Fixture.MatchDate>=DATEADD(MINUTE,2,GETDATE()) and   cast(Cache.Fixture.MatchDate as date)<DATEADD(DAY,2,GETDATE())
		 
				--ORDER BY Cache.Fixture.MatchDate
			end
	 end

 else 
	begin
		if(CAST(@EventDate AS Date)>=CAST (GETDATE() as Date))
			begin
		

	SELECT  DISTINCT   Cache.Fixture.BetradarMatchId,Cache.Fixture.MatchId, Cache.Fixture.MatchDate,
	  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetitor_1.CompetitorName AS EventName, 
						  Cache.Fixture.SportName, Cache.Fixture.OddTypeCount, 
						  Cache.Fixture.TournamentId,Cache.Fixture.MatchDate as TournamentDate,Cache.Fixture.NeutralGround
						   ,case when (select COUNT(BetradarMatchId) from Match.Code with (nolock) where BetradarMatchId=Cache.Fixture.BetradarMatchId and BetTypeId=1)>0 then 1 else 0 end AS IsLive
						
						   ,Parameter.Tournament.CategoryId
						   ,Parameter.Category.SequenceNumber
						   ,Parameter.Tournament.IsPopularTerminal
						   ,Language.[Parameter.Tournament].TournamentName,Language.[Parameter.Category].CategoryName
						    ,Cache.Fixture.SportName as SportNameOrginal
							 ,LOWER(Parameter.Iso.IsoName2) as IsoName
							   ,Match.Code.Code
							    ,Parameter.Competitor.BetradarSuperId as HomeTeamId
							   ,Competitor_1.BetradarSuperId as AwayTeamId
							   ,Parameter.Tournament.NewBetradarId as BetradarTournamentId
	FROM         Parameter.Competitor AS Competitor_1 with (nolock) INNER JOIN
						  Parameter.Competitor with (nolock) INNER JOIN
						  Language.ParameterCompetitor with (nolock) ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangComp INNER JOIN
						  Cache.Fixture with (nolock) ON Parameter.Competitor.CompetitorId = Cache.Fixture.HomeTeam ON Competitor_1.CompetitorId = Cache.Fixture.AwayTeam INNER JOIN
						  Parameter.Tournament with (nolock) ON Parameter.Tournament.TournamentId=Cache.Fixture.TournamentId INNER JOIN
						  Language.ParameterCompetitor AS ParameterCompetitor_1 with (nolock) ON Competitor_1.CompetitorId = ParameterCompetitor_1.CompetitorId and ParameterCompetitor_1.LanguageId=@LangComp INNER JOIN
							 Match.Code with (nolock) ON Cache.Fixture.BetradarMatchId = Match.Code.BetradarMatchId and Match.Code.BetTypeId=0  INNER JOIN Parameter.Category On Parameter.Category.CategoryId=Parameter.Tournament.CategoryId INNER JOIN 
							 Parameter.Iso with (nolock) On Parameter.Iso.IsoId=Parameter.Category.IsoId INNER JOIN
							 Language.[Parameter.Tournament] with (nolock) ON
							 Language.[Parameter.Tournament].TournamentId=Parameter.Tournament.TournamentId and Language.[Parameter.Tournament].LanguageId=@LangId INNER JOIN Language.[Parameter.Category] with (nolock) ON
							 Language.[Parameter.Category].CategoryId=Parameter.Category.CategoryId and Language.[Parameter.Category].LanguageId=@LangId
	Where   ((CAST(Cache.Fixture.MatchDate AS Date)=(CAST(@EventDate AS Date)))) and  Cache.Fixture.MatchDate>DATEADD(MINUTE,2,GETDATE()) --and Cache.Fixture.SportId in (1,2,20,5,4,6,14,3,19,35)
 
			--ORDER BY Cache.Fixture.MatchDate
			end
		else
			begin
			

	SELECT  DISTINCT   Cache.Fixture.BetradarMatchId,Cache.Fixture.MatchId, Cache.Fixture.MatchDate,
	  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetitor_1.CompetitorName AS EventName, 
						  Cache.Fixture.SportName, Cache.Fixture.OddTypeCount, 
						  Cache.Fixture.TournamentId,Cache.Fixture.MatchDate as TournamentDate,Cache.Fixture.NeutralGround
						   ,case when (select COUNT(BetradarMatchId) from Match.Code with (nolock) where BetradarMatchId=Cache.Fixture.BetradarMatchId and BetTypeId=1)>0 then 1 else 0 end AS IsLive
						
						   ,Parameter.Tournament.CategoryId
						   ,Parameter.Category.SequenceNumber
						   ,Parameter.Tournament.IsPopularTerminal
						   ,Language.[Parameter.Tournament].TournamentName,Language.[Parameter.Category].CategoryName
						    ,Cache.Fixture.SportName as SportNameOrginal
							 ,LOWER(Parameter.Iso.IsoName2) as IsoName
							   ,Match.Code.Code
							    ,Parameter.Competitor.BetradarSuperId as HomeTeamId
							   ,Competitor_1.BetradarSuperId as AwayTeamId
							   ,Parameter.Tournament.NewBetradarId as BetradarTournamentId
	FROM         Parameter.Competitor AS Competitor_1 with (nolock) INNER JOIN
						  Parameter.Competitor with (nolock) INNER JOIN
						  Language.ParameterCompetitor ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangComp INNER JOIN
						  Cache.Fixture with (nolock) ON Parameter.Competitor.CompetitorId = Cache.Fixture.HomeTeam ON Competitor_1.CompetitorId = Cache.Fixture.AwayTeam INNER JOIN
						  Parameter.Tournament with (nolock) ON Parameter.Tournament.TournamentId=Cache.Fixture.TournamentId INNER JOIN
						  Language.ParameterCompetitor AS ParameterCompetitor_1 with (nolock) ON Competitor_1.CompetitorId = ParameterCompetitor_1.CompetitorId and ParameterCompetitor_1.LanguageId=@LangComp INNER JOIN
							 Match.Code with (nolock) ON Cache.Fixture.BetradarMatchId = Match.Code.BetradarMatchId and Match.Code.BetTypeId=0 INNER JOIN Parameter.Category On Parameter.Category.CategoryId=Parameter.Tournament.CategoryId INNER JOIN 
							 Parameter.Iso with (nolock) On Parameter.Iso.IsoId=Parameter.Category.IsoId INNER JOIN
							 Language.[Parameter.Tournament] with (nolock) ON
							 Language.[Parameter.Tournament].TournamentId=Parameter.Tournament.TournamentId and Language.[Parameter.Tournament].LanguageId=@LangId INNER JOIN Language.[Parameter.Category] with (nolock) ON
							 Language.[Parameter.Category].CategoryId=Parameter.Category.CategoryId and Language.[Parameter.Category].LanguageId=@LangId
	Where     Cache.Fixture.MatchDate>=DATEADD(MINUTE,2,GETDATE()) and cast(Cache.Fixture.MatchDate as date ) <cast(DATEADD(DAY,2,GETDATE()) as date) 
 
			--ORDER BY Cache.Fixture.MatchDate
			end
	end

END




GO
