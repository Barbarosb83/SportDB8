USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcEventOne]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [GamePlatform].[ProcEventOne] 
@MatchId bigint,
@LangId int

AS

BEGIN
SET NOCOUNT ON;

 declare @LangComp int=@LangId


if(@LangComp not in (2,3,6))
	set @LangComp=2

SELECT     Cache.Fixture.BetradarMatchId,Cache.Fixture.MatchId, Cache.Fixture.MatchDate,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetitor_1.CompetitorName AS EventName, 
                      Cache.Fixture.SportName,Cache.Fixture.OddTypeCount, 
                      Cache.Fixture.TournamentId,Cache.Fixture.MatchDate as TournamentDate,Cache.Fixture.NeutralGround,
					  '' as Code
					    ,PCH.BetradarSuperId as HomeTeamId
					  ,PCA.BetradarSuperId as AwayTeamId
					  ,Language.ParameterCompetitor.CompetitorName as HomeTeam
					  ,ParameterCompetitor_1.CompetitorName as AwayTeam
					  ,PC.CategoryId
					  ,PC.CategoryName
					  ,cast(0 as bit) as IsLive
					  ,Cache.Fixture.SportName as SportNameOrginal
					  ,PT.SequenceNumber
					  ,PT.TournamentName
					  ,PIS.IsoName2 as IsoName
					  ,'pre' as TypeOfList
FROM         
                    Cache.Fixture with (nolock) INNER JOIN 
                       Language.ParameterCompetitor with (nolock)  ON   Language.ParameterCompetitor.CompetitorId=Cache.Fixture.HomeTeam 
					   and Language.ParameterCompetitor.LanguageId=@LangComp     INNER JOIN
					   Parameter.Competitor PCH with (nolock) ON PCH.CompetitorId=Cache.Fixture.HomeTeam INNER JOIN
                      Language.ParameterCompetitor AS ParameterCompetitor_1 with (nolock) ON  ParameterCompetitor_1.CompetitorId=Cache.Fixture.AwayTeam and ParameterCompetitor_1.LanguageId=@LangComp INNER JOIN
					  Parameter.Competitor PCA with (nolock) ON PCA.CompetitorId=Cache.Fixture.AwayTeam 
					 -- Match.Code with (nolock) ON Match.Code.MatchId=Cache.Fixture.MatchId and Match.Code.BetTypeId=0
					  INNER JOIN Parameter.Tournament PT with (nolock) ON PT.TournamentId=Cache.Fixture.TournamentId
					  INNER JOIN Parameter.Category PC with (nolock) On PC.CategoryId=Pt.CategoryId
					  INNER JOIN Parameter.Iso PIS with (nolock) ON PIS.IsoId=PC.IsoId
Where  Cache.Fixture.MatchId=@MatchId  and Cache.Fixture.MatchDate>GETDATE()
--order by Cache.Fixture.MatchDate

END


GO
