USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcMatchStanding]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [GamePlatform].[ProcMatchStanding] 
 @SportId int,
  @CategoryId int,
 @TournamentId int,
  @LangId int
AS
BEGIN
SET NOCOUNT ON;
  

  declare @LangComp int=@LangId


if(@LangComp not in (2,3,6))
	set @LangComp=2


		 SELECT     DISTINCT        Id, Name, SportId, CategoryId, Match.Standings.TournamentId,Language.[Parameter.Tournament].TournamentName,
 Language.ParameterCompetitor.CompetitorName   as CompetitorName,  TeamName  as TeamName, Rank, CurrentOutcome, Played, Win, Draw, Loss, cast(GoalFor as nvarchar(10))+':'+ cast(GoalAgainst as nvarchar(10)) as Tore,GoalFor,GoalAgainst, GoalDiff, Points,
(select top 1 MS1.Win from Match.Standings as MS1 where MS1.TeamId=Match.Standings.TeamId and MS1.TournamentId=Match.Standings.TournamentId and MS1.Name='home') as HWin
,(select top 1MS2.Draw from Match.Standings as MS2 where MS2.TeamId=Match.Standings.TeamId and MS2.TournamentId=Match.Standings.TournamentId and MS2.Name='home') as HDraw
,(select top 1 MS3.Loss from Match.Standings as MS3 where MS3.TeamId=Match.Standings.TeamId and MS3.TournamentId=Match.Standings.TournamentId and MS3.Name='home') as HLos
,(select top 1 MS4.Win from Match.Standings as MS4 where MS4.TeamId=Match.Standings.TeamId and MS4.TournamentId=Match.Standings.TournamentId and MS4.Name='away') as AWin
,(select top 1 MS5.Draw from Match.Standings as MS5 where MS5.TeamId=Match.Standings.TeamId and MS5.TournamentId=Match.Standings.TournamentId and MS5.Name='away') as ADraw
,(select top 1 MS6.Loss from Match.Standings as MS6 where MS6.TeamId=Match.Standings.TeamId and MS6.TournamentId=Match.Standings.TournamentId and MS6.Name='away') as ALos,ISNULL((select top 1 MS1.Win from Match.Standings as MS1 where MS1.TeamId=Match.Standings.TeamId and MS1.TournamentId=Match.Standings.TournamentId and MS1.Name='home'),0)*3+ISNULL((select top 1MS2.Draw from Match.Standings as MS2 where MS2.TeamId=Match.Standings.TeamId and MS2.TournamentId=Match.Standings.TournamentId and MS2.Name='home'),0) as HPoint
,ISNULL((select top 1 MS1.Win from Match.Standings as MS1 where MS1.TeamId=Match.Standings.TeamId and MS1.TournamentId=Match.Standings.TournamentId and MS1.Name='home'),0)+ISNULL((select top 1MS2.Draw from Match.Standings as MS2 where MS2.TeamId=Match.Standings.TeamId and MS2.TournamentId=Match.Standings.TournamentId and MS2.Name='home'),0)+ISNULL((select top 1 MS3.Loss from Match.Standings as MS3 where MS3.TeamId=Match.Standings.TeamId and MS3.TournamentId=Match.Standings.TournamentId and MS3.Name='home'),0) as HPlayed
,(select top 1 [Form] from [Match].[Form] as MF1 where MF1.TeamId=Match.Standings.TeamId  and MF1.[TournamentId]=Match.Standings.TournamentId ) as Form
,(select top 1 [Win] from [Match].[Form] as MF2 where MF2.TeamId=Match.Standings.TeamId  and MF2.[TournamentId]=Match.Standings.TournamentId ) as FormWin
,(select top 1 Draw from [Match].[Form] as MF3 where MF3.TeamId=Match.Standings.TeamId  and MF3.[TournamentId]=Match.Standings.TournamentId ) as FormDraw
,(select top 1 Lost from [Match].[Form] as MF4 where MF4.TeamId=Match.Standings.TeamId  and MF4.[TournamentId]=Match.Standings.TournamentId ) as FormLost
,(select top 1 Points from [Match].[Form] as MF5 where MF5.TeamId=Match.Standings.TeamId  and MF5.[TournamentId]=Match.Standings.TournamentId ) as FormPoints
,ISNULL((select top 1 MS1.Win from Match.Standings as MS1 where MS1.TeamId=Match.Standings.TeamId and MS1.TournamentId=Match.Standings.TournamentId and MS1.Name='away'),0)*3+ISNULL((select top 1MS2.Draw from Match.Standings as MS2 where MS2.TeamId=Match.Standings.TeamId and MS2.TournamentId=Match.Standings.TournamentId and MS2.Name='away'),0) as APoint
,ISNULL((select top 1 MS1.Win from Match.Standings as MS1 where MS1.TeamId=Match.Standings.TeamId and MS1.TournamentId=Match.Standings.TournamentId and MS1.Name='away'),0)+ISNULL((select top 1MS2.Draw from Match.Standings as MS2 where MS2.TeamId=Match.Standings.TeamId and MS2.TournamentId=Match.Standings.TournamentId and MS2.Name='away'),0)+ISNULL((select top 1 MS3.Loss from Match.Standings as MS3 where MS3.TeamId=Match.Standings.TeamId and MS3.TournamentId=Match.Standings.TournamentId and MS3.Name='away'),0) as APlayed

FROM            Match.Standings INNER JOIN Parameter.Competitor ON Parameter.Competitor.BetradarSuperId=Match.Standings.TeamId INNER JOIN
Language.ParameterCompetitor ON Language.ParameterCompetitor.CompetitorId=Parameter.Competitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangComp INNER JOIN
Language.[Parameter.Tournament] On Language.[Parameter.Tournament].TournamentId=Match.Standings.TournamentId and Language.[Parameter.Tournament].LanguageId=@LangId 
and Language.[Parameter.Tournament].TournamentId=@TournamentId and  Name='total' 
--and (TeamId in (select Parameter.Competitor.BetradarSuperId from Cache.Programme2 INNER JOIN Parameter.Competitor ON Parameter.Competitor.CompetitorId=Cache.Programme2.[HomeTeam ] where
-- Cache.Programme2.SportId=@SportId and
--  Cache.Programme2.MatchDate>=getdate() and Cache.Programme2.MatchDate<=DATEADD(DAY,30,getdate()) and Cache.Programme2.TournamentId=@TournamentId) or 
--TeamId in (select Parameter.Competitor.BetradarSuperId from Cache.Programme2 INNER JOIN Parameter.Competitor ON Parameter.Competitor.CompetitorId=Cache.Programme2.[AwayTeam ] 
--where 
----Cache.Programme2.SportId=@SportId and
-- Cache.Programme2.MatchDate>=getdate() and Cache.Programme2.MatchDate<=DATEADD(DAY,30,getdate()) and Cache.Programme2.TournamentId=@TournamentId))
ORDER BY [Rank]

 
 
END




GO
