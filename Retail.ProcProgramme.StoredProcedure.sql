USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcProgramme]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcProgramme] 
@SportId int,
@where nvarchar(1000),
@orderby nvarchar(1000),
@LangId int,
@UserId int
AS
BEGIN
SET NOCOUNT ON;
 

 
declare @sqlcommand nvarchar(max)
declare @sqlcommand2 nvarchar(max)


--declare @total int 

--select @total=COUNT( Cache.Programme.SportId) 
--FROM   Cache.Programme LEFT OUTER JOIN Match.Code ON Match.Code.BetradarMatchId=Cache.Programme.BetradarMatchId INNER JOIN
--Language.ParameterCompetitor AS CompHome ON CompHome.CompetitorId=Cache.Programme.[HomeTeam ] And CompHome.LanguageId=@LangId INNER JOIN
--Language.ParameterCompetitor AS CompAway ON CompAway.CompetitorId=Cache.Programme.[AwayTeam ] And CompAway.LanguageId=@LangId INNER JOIN
--Language.[Parameter.Tournament] ON Language.[Parameter.Tournament].TournamentId=Cache.Programme.TournamentId and Language.[Parameter.Tournament].LanguageId=@LangId INNER JOIN
--Parameter.Tournament ON Parameter.Tournament.TournamentId=Cache.Programme.TournamentId INNER JOIN
--Language.[Parameter.Category] On Language.[Parameter.Category].CategoryId=Parameter.Tournament.CategoryId AND Language.[Parameter.Category].LanguageId=@LangId  ; 
--WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY Cache.Programme.SportId) AS RowNum,
--Match.Code.Code
--,CompHome.CompetitorName as HomeTeamName
--,CompAway.CompetitorName as AwayTeamName
-- ,'https://wettarena.com/images/sports/colors/'+Cache.Programme.SportName+'.png' as Logo
 
-- ,SUBSTRING ( CONVERT(varchar, Cache.Programme.MatchDate, 108) ,1 ,LEN( CONVERT(varchar, Cache.Programme.MatchDate, 108))-3 )    as MatchTime
-- ,  (select [DayShort] from [Language].[Parameter.Day] where [DayId]=DATEPART(dw,Cache.Programme.MatchDate) and [LanguageId]=@LangId)  as MatchDay
-- ,Language.[Parameter.Tournament].TournamentName as TournamentName
-- ,Language.[Parameter.Category].CategoryName as CategoryName
-- ,'' as Live
--, Cache.Programme.*
--FROM   Cache.Programme LEFT OUTER JOIN Match.Code ON Match.Code.BetradarMatchId=Cache.Programme.BetradarMatchId INNER JOIN
--Language.ParameterCompetitor AS CompHome ON CompHome.CompetitorId=Cache.Programme.[HomeTeam ] And CompHome.LanguageId=@LangId INNER JOIN
--Language.ParameterCompetitor AS CompAway ON CompAway.CompetitorId=Cache.Programme.[AwayTeam ] And CompAway.LanguageId=@LangId INNER JOIN
--Language.[Parameter.Tournament] ON Language.[Parameter.Tournament].TournamentId=Cache.Programme.TournamentId and Language.[Parameter.Tournament].LanguageId=@LangId INNER JOIN
--Parameter.Tournament ON Parameter.Tournament.TournamentId=Cache.Programme.TournamentId INNER JOIN
--Language.[Parameter.Category] On Language.[Parameter.Category].CategoryId=Parameter.Tournament.CategoryId AND Language.[Parameter.Category].LanguageId=@LangId
--)  
--SELECT *,@total as totalrow 
--FROM OrdersRN 





set @sqlcommand='declare @total int '+
'select @total=COUNT( Cache.Programme.SportId) '+
'FROM   Cache.Programme INNER JOIN Match.Code ON Match.Code.BetradarMatchId=Cache.Programme.BetradarMatchId INNER JOIN
Language.ParameterCompetitor AS CompHome ON CompHome.CompetitorId=Cache.Programme.[HomeTeam ] And CompHome.LanguageId='+cast(@LangId as nvarchar(3))+' INNER JOIN
Language.ParameterCompetitor AS CompAway ON CompAway.CompetitorId=Cache.Programme.[AwayTeam ] And CompAway.LanguageId='+cast(@LangId as nvarchar(3))+' INNER JOIN
Language.[Parameter.Tournament] ON Language.[Parameter.Tournament].TournamentId=Cache.Programme.TournamentId and Language.[Parameter.Tournament].LanguageId='+cast(@LangId as nvarchar(3))+' INNER JOIN
Parameter.Tournament ON Parameter.Tournament.TournamentId=Cache.Programme.TournamentId INNER JOIN
Language.[Parameter.Category] On Language.[Parameter.Category].CategoryId=Parameter.Tournament.CategoryId AND Language.[Parameter.Category].LanguageId='+cast(@LangId as nvarchar(3)) +
' WHERE (1 = 1) and '+@where+ ' ; ' +
' WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY Cache.Programme.MatchDate) AS RowNum, '+
' Match.Code.Code
, CompHome.CompetitorName as HomeTeamName
, CompAway.CompetitorName as AwayTeamName
 ,''https://wettarena.com/images/sports/colors/''+Cache.Programme.SportName+''.png'' as Logo
 
 ,SUBSTRING ( CONVERT(varchar, Cache.Programme.MatchDate, 108) ,1 ,LEN( CONVERT(varchar, Cache.Programme.MatchDate, 108))-3 )    as MatchTime
 ,  (select [DayShort] from [Language].[Parameter.Day] where [DayId]=DATEPART(dw,Cache.Programme.MatchDate) and [LanguageId]='+cast(@LangId as nvarchar(3))+')  as MatchDay
 ,Language.[Parameter.Tournament].TournamentName as TournamentName
 ,Language.[Parameter.Category].CategoryName as CategoryName
 ,'''' as Live
, Cache.Programme.* '
set @sqlcommand2=' FROM Cache.Programme INNER JOIN Match.Code ON Match.Code.BetradarMatchId=Cache.Programme.BetradarMatchId INNER JOIN
Language.ParameterCompetitor AS CompHome ON CompHome.CompetitorId=Cache.Programme.[HomeTeam ] And CompHome.LanguageId='+cast(@LangId as nvarchar(3))+' INNER JOIN
Language.ParameterCompetitor AS CompAway ON CompAway.CompetitorId=Cache.Programme.[AwayTeam ] And CompAway.LanguageId='+cast(@LangId as nvarchar(3))+'INNER JOIN
Language.[Parameter.Tournament] ON Language.[Parameter.Tournament].TournamentId=Cache.Programme.TournamentId and Language.[Parameter.Tournament].LanguageId='+cast(@LangId as nvarchar(3))+' INNER JOIN
Parameter.Tournament ON Parameter.Tournament.TournamentId=Cache.Programme.TournamentId INNER JOIN
Language.[Parameter.Category] On Language.[Parameter.Category].CategoryId=Parameter.Tournament.CategoryId AND Language.[Parameter.Category].LanguageId='+cast(@LangId as nvarchar(3))+' '+
'WHERE (1= 1) and '+@where+ 
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '
 





execute (@sqlcommand+@sqlcommand2)









 
END




GO
