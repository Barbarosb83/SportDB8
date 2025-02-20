USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcProgramme2_work]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcProgramme2_work] 
 @SportId int,
 @TournamentId int,
 @CategoryId int,
 @DatePeriod int
AS
BEGIN
SET NOCOUNT ON;
 

 
declare @sqlcommand nvarchar(max)
declare @sqlcommand2 nvarchar(max)
declare @Today datetime=GETDATE()
declare @LangId int=6
declare @where nvarchar(250)=' Cache.Programme.SportId='+ cast(@SportId as nvarchar(5))+ ' and Cache.Programme.TournamentId='+ cast(@TournamentId as nvarchar(5))+ ' and  Cache.Programme.MatchDate>='''+convert(varchar(19),GETDATE(),121)+''''
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





--set @sqlcommand='declare @total int '+
--'select @total=COUNT( Cache.Programme.SportId) '+
--'FROM   Cache.Programme LEFT OUTER JOIN Match.Code ON Match.Code.BetradarMatchId=Cache.Programme.BetradarMatchId INNER JOIN
--Language.ParameterCompetitor AS CompHome ON CompHome.CompetitorId=Cache.Programme.[HomeTeam ] And CompHome.LanguageId='+cast(@LangId as nvarchar(3))+' INNER JOIN
--Language.ParameterCompetitor AS CompAway ON CompAway.CompetitorId=Cache.Programme.[AwayTeam ] And CompAway.LanguageId='+cast(@LangId as nvarchar(3))+' INNER JOIN
--Language.[Parameter.Tournament] ON Language.[Parameter.Tournament].TournamentId=Cache.Programme.TournamentId and Language.[Parameter.Tournament].LanguageId='+cast(@LangId as nvarchar(3))+' INNER JOIN
--Parameter.Tournament ON Parameter.Tournament.TournamentId=Cache.Programme.TournamentId INNER JOIN
--Language.[Parameter.Category] On Language.[Parameter.Category].CategoryId=Parameter.Tournament.CategoryId AND Language.[Parameter.Category].LanguageId='+cast(@LangId as nvarchar(3)) +
--' WHERE (1 = 1) and '+@where+ ' ; ' +
--' WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY Cache.Programme.MatchDate) AS RowNum, '+
--' Match.Code.Code
--, CompHome.CompetitorName as HomeTeamName
--, CompAway.CompetitorName as AwayTeamName
-- ,''https://wettarena.com/images/sports/colors/''+Cache.Programme.SportName+''.png'' as Logo
 
-- ,SUBSTRING ( CONVERT(varchar, Cache.Programme.MatchDate, 108) ,1 ,LEN( CONVERT(varchar, Cache.Programme.MatchDate, 108))-3 )    as MatchTime
-- ,  (select [DayShort] from [Language].[Parameter.Day] where [DayId]=DATEPART(dw,Cache.Programme.MatchDate) and [LanguageId]='+cast(@LangId as nvarchar(3))+')  as MatchDay
-- ,Language.[Parameter.Tournament].TournamentName as TournamentName
-- ,Language.[Parameter.Category].CategoryName as CategoryName
-- ,'''' as Live
--, Cache.Programme.* '
--set @sqlcommand2=' FROM Cache.Programme LEFT OUTER JOIN Match.Code ON Match.Code.BetradarMatchId=Cache.Programme.BetradarMatchId INNER JOIN
--Language.ParameterCompetitor AS CompHome ON CompHome.CompetitorId=Cache.Programme.[HomeTeam ] And CompHome.LanguageId='+cast(@LangId as nvarchar(3))+' INNER JOIN
--Language.ParameterCompetitor AS CompAway ON CompAway.CompetitorId=Cache.Programme.[AwayTeam ] And CompAway.LanguageId='+cast(@LangId as nvarchar(3))+'INNER JOIN
--Language.[Parameter.Tournament] ON Language.[Parameter.Tournament].TournamentId=Cache.Programme.TournamentId and Language.[Parameter.Tournament].LanguageId='+cast(@LangId as nvarchar(3))+' INNER JOIN
--Parameter.Tournament ON Parameter.Tournament.TournamentId=Cache.Programme.TournamentId INNER JOIN
--Language.[Parameter.Category] On Language.[Parameter.Category].CategoryId=Parameter.Tournament.CategoryId AND Language.[Parameter.Category].LanguageId='+cast(@LangId as nvarchar(3))+' '+
--'WHERE (1= 1) and '+@where+ 
-- ') '+  
--'SELECT *,@total as totalrow '+
--  'FROM OrdersRN '
 

 if(@DatePeriod=0)
 begin
select distinct Match.Code.Code as Code
, CompHome.CompetitorName as HomeTeamName
, CompAway.CompetitorName as AwayTeamName
 ,case when (Select COUNT(MC.BetTypeId) from Match.Code as MC with (nolock) where MC.BetradarMatchId=Cache.Programme.BetradarMatchId and MC.BetTypeId=1)>0 then  'L' else '' end as Logo
 
 ,SUBSTRING ( CONVERT(varchar, Cache.Programme.MatchDate, 108) ,1 ,LEN( CONVERT(varchar, Cache.Programme.MatchDate, 108))-3 )    as MatchTime
 --,  (select [DayShort] from [Language].[Parameter.Day] where [DayId]=DATEPART(dw,Cache.Programme.MatchDate) and [LanguageId]=@LangId ) as MatchDay
  , case when DATEPART(dw,GETDATE())=DATEPART(dw,Cache.Programme.MatchDate)
 then '.\images\black'+ (select [DayShort] from [Language].[Parameter.Day] where [DayId]=DATEPART(dw,Cache.Programme.MatchDate) and [LanguageId]=6 )+'day.png'
 else '.\images\'+ (select [DayShort] from [Language].[Parameter.Day] where [DayId]=DATEPART(dw,Cache.Programme.MatchDate) and [LanguageId]=6 )+'day.png' end as MatchDay
 ,Language.[Parameter.Tournament].TournamentName as TournamentName
 ,Language.[Parameter.Category].CategoryName as CategoryName
 ,Language.[Parameter.Sport].SportName as LangSportName
 ,'ab '+cast(ISNULL((Select Match.Setting.MinCombiBranch from Match.Setting  with (nolock)  where Match.Setting.MatchId=Cache.Programme.MatchId),1) as nvarchar(5))+' fach spielbar' as Live
, Cache.Programme.* 
 FROM Cache.Programme with (nolock) INNER JOIN Match.Code with (nolock) ON Match.Code.BetradarMatchId=Cache.Programme.BetradarMatchId and Match.Code.BetTypeId=0 INNER JOIN
Language.ParameterCompetitor AS CompHome with (nolock) ON CompHome.CompetitorId=Cache.Programme.[HomeTeam ] And CompHome.LanguageId=@LangId INNER JOIN
Language.ParameterCompetitor AS CompAway with (nolock) ON CompAway.CompetitorId=Cache.Programme.[AwayTeam ] And CompAway.LanguageId=@LangId INNER JOIN
Language.[Parameter.Tournament] with (nolock) ON Language.[Parameter.Tournament].TournamentId=Cache.Programme.TournamentId and Language.[Parameter.Tournament].LanguageId=@LangId INNER JOIN
Parameter.Tournament with (nolock) ON Parameter.Tournament.TournamentId=Cache.Programme.TournamentId INNER JOIN
Language.[Parameter.Category] with (nolock) On Language.[Parameter.Category].CategoryId=Parameter.Tournament.CategoryId AND Language.[Parameter.Category].LanguageId=@LangId INNER Join 
Language.[Parameter.Sport] with (nolock) ON Language.[Parameter.Sport].SportId=Cache.Programme.SportId and Language.[Parameter.Sport].LanguageId=@LangId
WHERE (1= 1) and Cache.Programme.SportId=@SportId and Cache.Programme.MatchDate>=getdate() and Cache.Programme.MatchDate<DATEADD(DAY,1,getdate()) and Cache.Programme.TournamentId=@TournamentId
end
else
begin
select distinct Match.Code.Code as Code
, CompHome.CompetitorName as HomeTeamName
, CompAway.CompetitorName as AwayTeamName
,case when (Select COUNT(MC.BetTypeId) from Match.Code as MC with (nolock) where MC.BetradarMatchId=Cache.Programme2.BetradarMatchId and MC.BetTypeId=1)>0 then  'L' else '' end as Logo
 ,SUBSTRING ( CONVERT(varchar, Cache.Programme2.MatchDate, 108) ,1 ,LEN( CONVERT(varchar, Cache.Programme2.MatchDate, 108))-3 )    as MatchTime
 --,  (select [DayShort] from [Language].[Parameter.Day] where [DayId]=DATEPART(dw,Cache.Programme2.MatchDate) and [LanguageId]=@LangId ) as MatchDay
 , case when DATEPART(dw,GETDATE())=DATEPART(dw,Cache.Programme2.MatchDate) and cast(GETDATE() as date)=cast(Cache.Programme2.MatchDate as Date)
 then '.\images\black'+ (select [DayShort] from [Language].[Parameter.Day] where [DayId]=DATEPART(dw,Cache.Programme2.MatchDate) and [LanguageId]=6 )+'day.png'
 else case when DATEDIFF(DAY,GETDATE(),Cache.Programme2.MatchDate)>8 then '.\images\'+cast(DAY(Getdate()) as nvarchar(5))+cast(MONTH(GETDATE()) as nvarchar(5))+'.png' else '.\images\'+ (select [DayShort] from [Language].[Parameter.Day] where [DayId]=DATEPART(dw,Cache.Programme2.MatchDate) and [LanguageId]=6 )+'day.png' end end as MatchDay
 ,Language.[Parameter.Tournament].TournamentName as TournamentName
 ,Language.[Parameter.Category].CategoryName as CategoryName
 ,Language.[Parameter.Sport].SportName as LangSportName
 ,'ab '+cast(ISNULL((Select Match.Setting.MinCombiBranch from Match.Setting  with (nolock)  where Match.Setting.MatchId=Cache.Programme2.MatchId),1) as nvarchar(5))+' fach spielbar' as Live
, Cache.Programme2.* 
 FROM Cache.Programme2 with (nolock) INNER JOIN Match.Code  with (nolock)  ON Match.Code.BetradarMatchId=Cache.Programme2.BetradarMatchId and Match.Code.BetTypeId=0 INNER JOIN
Language.ParameterCompetitor AS CompHome with (nolock) ON CompHome.CompetitorId=Cache.Programme2.[HomeTeam ] And CompHome.LanguageId=@LangId INNER JOIN
Language.ParameterCompetitor AS CompAway with (nolock) ON CompAway.CompetitorId=Cache.Programme2.[AwayTeam ] And CompAway.LanguageId=@LangId INNER JOIN
Language.[Parameter.Tournament] with (nolock) ON Language.[Parameter.Tournament].TournamentId=Cache.Programme2.TournamentId and Language.[Parameter.Tournament].LanguageId=@LangId INNER JOIN
Parameter.Tournament with (nolock) ON Parameter.Tournament.TournamentId=Cache.Programme2.TournamentId INNER JOIN
Language.[Parameter.Category] with (nolock) On Language.[Parameter.Category].CategoryId=Parameter.Tournament.CategoryId AND Language.[Parameter.Category].LanguageId=@LangId INNER Join 
Language.[Parameter.Sport] with (nolock) ON Language.[Parameter.Sport].SportId=Cache.Programme2.SportId and Language.[Parameter.Sport].LanguageId=@LangId
WHERE (1= 1) and Cache.Programme2.SportId=@SportId and Cache.Programme2.MatchDate>=getdate() and (Cache.Programme2.MatchDate<  DATEADD(DAY,6,GETDATE())  ) and Cache.Programme2.TournamentId=@TournamentId
Order By Cache.Programme2.MatchDate

end
 









 
END




GO
