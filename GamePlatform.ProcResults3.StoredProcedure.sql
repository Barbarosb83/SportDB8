USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcResults3]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [GamePlatform].[ProcResults3] 
@SportId int,
@CategoryId int,
@TournamentId int,
@PageNo int,
@LangId int
AS

BEGIN
SET NOCOUNT ON;

declare @PageSize bigint=50

declare @TempTable table (EventDate datetime,HomeTeam nvarchar(100),AwayTeam nvarchar(100),FTScore nvarchar(20),HTScore nvarchar(20),MatchId bigint,SportName nvarchar(50),RowNum bigint,TournamentName nvarchar(150))

declare @LangComp int=@LangId


if(@LangComp not in (2,3,6))
	set @LangComp=2



if (@CategoryId=0)
	begin
		insert @TempTable
		SELECT   DISTINCT  Match.Score.MatchDate as EventDate, HomeTeamLang.CompetitorName AS HomeTeam, AwayTeamLang.CompetitorName AS AwayTeam, Match.Score.FullTimeScore as FTScore, 
							  Match.Score.HalfTimeScore as HTScore, Match.Score.MatchId as MatchId, Parameter.Sport.SportName,
							  (ROW_NUMBER() OVER(ORDER BY Match.Score.MatchDate DESC)) as RowNum,Language.[Parameter.Tournament].TournamentName
		FROM       Match.Score  with (nolock) INNER JOIN
				Parameter.Competitor AS HomeTeam with (nolock) ON Match.Score.HomeTeamId = HomeTeam.BetradarSuperId INNER JOIN
							  Parameter.Competitor AS AwayTeam with (nolock) ON Match.Score.AwayTeamId = AwayTeam.BetradarSuperId INNER JOIN
							  Language.ParameterCompetitor AS HomeTeamLang with (nolock) ON HomeTeam.CompetitorId = HomeTeamLang.CompetitorId INNER JOIN
							  Language.ParameterCompetitor AS AwayTeamLang with (nolock) ON AwayTeam.CompetitorId = AwayTeamLang.CompetitorId INNER JOIN
							  Parameter.Sport ON Match.Score.SportId = Parameter.Sport.SportId INNER JOIN
							  Parameter.Tournament On Parameter.Tournament.NewBetradarId=Match.Score.TournamentId INNER JOIN
							  Language.[Parameter.Tournament] ON Language.[Parameter.Tournament].TournamentId=Parameter.Tournament.TournamentId and Language.[Parameter.Tournament].LanguageId=@LangId
		WHERE     (AwayTeamLang.LanguageId = @LangComp) AND (HomeTeamLang.LanguageId = @LangComp) and Match.Score.SportId=@SportId
			GROUP BY  Match.Score.MatchDate, HomeTeamLang.CompetitorName , AwayTeamLang.CompetitorName  , Match.Score.FullTimeScore, 
							  Match.Score.HalfTimeScore, Match.Score.MatchId, Parameter.Sport.SportName,
							   Language.[Parameter.Tournament].TournamentName
	order by EventDate desc
	end
else if (@TournamentId=0)
	begin
		insert @TempTable
		SELECT   DISTINCT  Match.Score.MatchDate as EventDate, HomeTeamLang.CompetitorName AS HomeTeam, AwayTeamLang.CompetitorName AS AwayTeam, Match.Score.FullTimeScore as FTScore, 
							  Match.Score.HalfTimeScore as HTScore, Match.Score.MatchId as MatchId, Parameter.Sport.SportName,
							  (ROW_NUMBER() OVER(ORDER BY Match.Score.MatchDate DESC)) as RowNum,Language.[Parameter.Tournament].TournamentName
		FROM       Match.Score  with (nolock) INNER JOIN
				Parameter.Competitor AS HomeTeam with (nolock) ON Match.Score.HomeTeamId = HomeTeam.BetradarSuperId INNER JOIN
							  Parameter.Competitor AS AwayTeam with (nolock) ON Match.Score.AwayTeamId = AwayTeam.BetradarSuperId INNER JOIN
							  Language.ParameterCompetitor AS HomeTeamLang with (nolock) ON HomeTeam.CompetitorId = HomeTeamLang.CompetitorId INNER JOIN
							  Language.ParameterCompetitor AS AwayTeamLang with (nolock) ON AwayTeam.CompetitorId = AwayTeamLang.CompetitorId INNER JOIN
							  Parameter.Sport ON Match.Score.SportId = Parameter.Sport.SportId INNER JOIN
							  Parameter.Tournament On Parameter.Tournament.NewBetradarId=Match.Score.TournamentId INNER JOIN
							  Language.[Parameter.Tournament] ON Language.[Parameter.Tournament].TournamentId=Parameter.Tournament.TournamentId and Language.[Parameter.Tournament].LanguageId=@LangId
		WHERE     (AwayTeamLang.LanguageId = @LangComp) AND (HomeTeamLang.LanguageId = @LangComp) and Match.Score.SportId=@SportId and Parameter.Tournament.CategoryId=@CategoryId
			GROUP BY  Match.Score.MatchDate, HomeTeamLang.CompetitorName , AwayTeamLang.CompetitorName  , Match.Score.FullTimeScore, 
							  Match.Score.HalfTimeScore, Match.Score.MatchId, Parameter.Sport.SportName,
							   Language.[Parameter.Tournament].TournamentName
		order by EventDate desc
	
	end
else 
	begin
		insert @TempTable
		SELECT   DISTINCT  Match.Score.MatchDate as EventDate, HomeTeamLang.CompetitorName AS HomeTeam, AwayTeamLang.CompetitorName AS AwayTeam, Match.Score.FullTimeScore as FTScore, 
							  Match.Score.HalfTimeScore as HTScore, Match.Score.MatchId as MatchId, Parameter.Sport.SportName,
							  (ROW_NUMBER() OVER(ORDER BY Match.Score.MatchDate DESC)) as RowNum,Language.[Parameter.Tournament].TournamentName
		FROM       Match.Score  with (nolock) INNER JOIN
				Parameter.Competitor AS HomeTeam with (nolock) ON Match.Score.HomeTeamId = HomeTeam.BetradarSuperId INNER JOIN
							  Parameter.Competitor AS AwayTeam with (nolock) ON Match.Score.AwayTeamId = AwayTeam.BetradarSuperId INNER JOIN
							  Language.ParameterCompetitor AS HomeTeamLang with (nolock) ON HomeTeam.CompetitorId = HomeTeamLang.CompetitorId INNER JOIN
							  Language.ParameterCompetitor AS AwayTeamLang with (nolock) ON AwayTeam.CompetitorId = AwayTeamLang.CompetitorId INNER JOIN
							  Parameter.Sport ON Match.Score.SportId = Parameter.Sport.SportId INNER JOIN
							  Parameter.Tournament On Parameter.Tournament.NewBetradarId=Match.Score.TournamentId INNER JOIN
							  Language.[Parameter.Tournament] ON Language.[Parameter.Tournament].TournamentId=Parameter.Tournament.TournamentId and Language.[Parameter.Tournament].LanguageId=@LangId
		WHERE     (AwayTeamLang.LanguageId = @LangComp) AND (HomeTeamLang.LanguageId = @LangComp) and Match.Score.SportId=@SportId and Parameter.Tournament.TournamentId=@TournamentId
			GROUP BY  Match.Score.MatchDate, HomeTeamLang.CompetitorName , AwayTeamLang.CompetitorName  , Match.Score.FullTimeScore, 
							  Match.Score.HalfTimeScore, Match.Score.MatchId, Parameter.Sport.SportName,
							   Language.[Parameter.Tournament].TournamentName
		order by EventDate desc
	end

	

		SELECT     EventDate,  HomeTeam,AwayTeam, FTScore, HTScore, MatchId, SportName, RowNum, (select MAX(RowNum) from @TempTable) as TotalRecord,TournamentName
		from @Temptable 
		WHERE RowNum BETWEEN ((@PageNo-1 )*(@PageSize))+1 AND (@PageNo * @PageSize ) 
		order by EventDate desc
	 

END



GO
