USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcMatchEventSearch]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcMatchEventSearch] 
@SearchText nvarchar(30),
@LangId int

AS
BEGIN
declare @TempTable Table(Ids bigint)
declare @TempTable2 Table(Ids bigint)
declare  @TempTablePre table(Code nvarchar(10),BetradarMatchId bigint,MatchId bigint,EventName nvarchar(200),Color int)
declare  @TempTableLive table(Code nvarchar(10),BetradarMatchId bigint,MatchId bigint,EventName nvarchar(200),Color int)
declare  @TempTableOutright table(Code nvarchar(10),BetradarMatchId bigint,MatchId bigint,EventName nvarchar(200),Color int)


declare  @TempTableList table(Code nvarchar(10),BetradarMatchId bigint,MatchId bigint,EventName nvarchar(200),Color int)

if(@SearchText<>'')
begin
insert @TempTable2 
select DISTINCT Language.ParameterCompetitor.CompetitorId 
FROM         
                      Language.ParameterCompetitor with (nolock) 
                       where Language.ParameterCompetitor.CompetitorName like '%'+@SearchText+'%' and Language.ParameterCompetitor.LanguageId=@LangId

					   insert @TempTable2 
select DISTINCT Language.[Parameter.Tournament].TournamentId
FROM          
                      Language.[Parameter.Tournament]  with (nolock) 
                       where  Language.[Parameter.Tournament].TournamentName like '%'+@SearchText+'%' and Language.[Parameter.Tournament].LanguageId=@LangId

insert @TempTable 
select Match.Code.MatchId
FROM         Match.Code with (nolock)
                       where (Match.Code.Code like '%'+@SearchText+'%') or (cast(Match.Code.MatchId as nvarchar(20))=@SearchText)
					   
--insert @TempTable 
--select Match.Code.MatchId
--FROM         Match.Code with (nolock)
--                       where  cast(Match.Code.MatchId as nvarchar(max))=@SearchText

--insert @TempTable 
--select Match.Match.MatchId
--FROM         Match.Match with (nolock)
--                       where   cast(Match.Match.MatchId as nvarchar(max))=@SearchText

--insert @TempTable 
--select  Live.[Event].EventId
--FROM         Live.[Event] with (nolock)
--                       where   cast( Live.[Event].EventId as nvarchar(max))=@SearchText




insert @TempTablePre
SELECT     Match.Code.Code
,Cache.Fixture.BetradarMatchId
,Cache.Fixture.MatchId,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetiTip_1.CompetitorName+' | '+ISNULL(Language.[Parameter.Tournament].TournamentName,'') AS EventName
                  ,0 as Color
			
FROM         Parameter.Competitor AS CompetiTip_1 with (nolock) INNER JOIN
                      Parameter.Competitor with (nolock) INNER JOIN
                      Language.ParameterCompetitor with (nolock) ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangId INNER JOIN
                      Cache.Fixture with (nolock) ON Parameter.Competitor.CompetitorId = Cache.Fixture.HomeTeam ON CompetiTip_1.CompetitorId = Cache.Fixture.AwayTeam INNER JOIN
                      Language.ParameterCompetitor AS ParameterCompetiTip_1 with (nolock) ON CompetiTip_1.CompetitorId = ParameterCompetiTip_1.CompetitorId and ParameterCompetiTip_1.LanguageId=@LangId 
					   --LEFT OUTER JOIN Match.Code with (nolock) ON Match.Code.MatchId=Cache.Fixture.MatchId 
					    INNER JOIN Match.Code with (nolock) ON Match.Code.MatchId=Cache.Fixture.MatchId and Match.Code.BetTypeId=0
					   INNER JOIN  Language.[Parameter.Tournament] with (nolock) ON Language.[Parameter.Tournament].TournamentId=Cache.Fixture.TournamentId and Language.[Parameter.Tournament].LanguageId=@LangId
Where  
		 ((CAST(Cache.Fixture.MatchDate AS Date)>=(CAST(getdate() AS Date))))
		and
		((CompetiTip_1.CompetitorId in (select Ids From @TempTable2)) 
                      or (Parameter.Competitor.CompetitorId  in (select Ids From @TempTable2)) or  Cache.Fixture.MatchId in (select Ids From @TempTable)  or  Cache.Fixture.TournamentId in (select Ids From @TempTable2))     
 


insert @TempTableLive
SELECT  
  Match.Code.Code
,Live.Event.BetradarMatchId
,Live.Event.EventId

						 , Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetiTip_1.CompetitorName+' | '+ISNULL(Language.[Parameter.Tournament].TournamentName,'') AS EventName
						,1 as Color
                        
FROM              Live.Event with (nolock) INNER JOIN
                         Live.EventDetail with (nolock) ON Live.Event.EventId = Live.EventDetail.EventId INNER JOIN  
						  Language.ParameterCompetitor with (nolock) ON Language.ParameterCompetitor.LanguageId=@LangId 
						 and   Language.ParameterCompetitor.CompetitorId=Live.[Event].HomeTeam   INNER JOIN
                         Language.ParameterCompetitor AS ParameterCompetiTip_1 ON ParameterCompetiTip_1.CompetitorId = Live.Event.AwayTeam   AND ParameterCompetiTip_1.LanguageId=@LangId  
						 --LEFT OUTER JOIN Match.Code with (nolock) ON Match.Code.MatchId=Live.Event.EventId 
						INNER JOIN Match.Code with (nolock) ON Match.Code.MatchId=Live.Event.EventId  and Match.Code.BetTypeId=1
						  INNER JOIN Language.[Parameter.Tournament] with (nolock) ON Language.[Parameter.Tournament].TournamentId=live.[Event].TournamentId 
						  and Language.[Parameter.Tournament].LanguageId=@LangId
Where  DATEADD(MINUTE,15,GETDATE())>=Live.Event.EventDate and ((Language.ParameterCompetitor.CompetitorId in (select Ids From @TempTable2)) 
                      or (ParameterCompetiTip_1.CompetitorId in (select Ids From @TempTable2)) or Live.Event.EventId in ((select Ids From @TempTable)  ))  

					  and cast(Live.Event.EventDate as date)=cast(GETDATE() as date)
					   and  ((EventDetail.IsActive=1 and --Match Active
EventDetail.TimeStatu not in (0,1,5,14,15,27,84,21,22,23,24,25,26,11,86,83)  ) OR (EventDetail.TimeStatu=5 and DATEDIFF(MINUTE, EventDetail.UpdatedDate,GETDATE())<2)  and 
Live.[Event].ConnectionStatu=2 OR (EventDetail.TimeStatu=1   and Live.[Event].ConnectionStatu=2   and EventDetail.IsActive=1 and EventDetail.BetStatus=2))




insert @TempTableOutright
select  distinct Match.Code.Code as MatchCode,Outrights.[Event].EventBetradarId, Outrights.[Event].EventId as MatchId, [Language].[Parameter.Category].CategoryName +' '+ Outrights.[EventName].EventName AS EventName,2 as Color

		from Outrights.[Event] with (nolock) inner join Outrights.[EventName] with (nolock) on Outrights.[Event].EventId = Outrights.[EventName].EventId 
				and Outrights.[EventName].LanguageId=2
		inner join Parameter.TournamentOutrights with (nolock) on Outrights.[Event].TournamentId=Parameter.TournamentOutrights.TournamentId
		inner join Parameter.[Category] with (nolock) on Parameter.[Category].CategoryId=Parameter.TournamentOutrights.CategoryId 
		inner join Parameter.Sport with (nolock) on Parameter.[Category].SportId=Parameter.Sport.SportId 
		inner join [Language].[Parameter.Category] with (nolock) on [Language].[Parameter.Category].CategoryId=Parameter.[Category].CategoryId 
			and [Language].[Parameter.Category].LanguageId=2
			 INNER JOIN Match.Code with (nolock) ON Match.Code.MatchId=Outrights.[Event].EventId and Match.Code.BetTypeId=2
Where  Outrights.[Event].EventEndDate>DATEADD(MINUTE,1, GETDATE()) and Outrights.[Event].IsActive=1 and Parameter.TournamentOutrights.IsActive=1 and ( [Language].[Parameter.Category].CategoryName like '%'+@SearchText+'%'  or  Outrights.[EventName].EventName like '%'+@SearchText+'%' or Outrights.[Event].EventId in (select Ids From @TempTable)  )

end
else
begin


insert @TempTablePre
SELECT DISTINCT  top 10   Match.Code.Code
,Cache.Fixture.BetradarMatchId
,Cache.Fixture.MatchId,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetiTip_1.CompetitorName+' | '+ISNULL(Language.[Parameter.Tournament].TournamentName,'') AS EventName
                  ,0 as Color
			
FROM        
                      Language.ParameterCompetitor with (nolock) INNER JOIN
                      Cache.Fixture with (nolock) ON  Language.ParameterCompetitor.LanguageId=@LangId and  Language.ParameterCompetitor.CompetitorId = Cache.Fixture.HomeTeam  INNER JOIN
                      Language.ParameterCompetitor AS ParameterCompetiTip_1 with (nolock) ON ParameterCompetiTip_1.CompetitorId = Cache.Fixture.AwayTeam and ParameterCompetiTip_1.LanguageId=@LangId
					   INNER JOIN Match.Code with (nolock) ON Match.Code.MatchId=Cache.Fixture.MatchId and Match.Code.BetTypeId=0 INNER JOIN 
					   Language.[Parameter.Tournament] with (nolock)  ON Language.[Parameter.Tournament].TournamentId=Cache.Fixture.TournamentId and Language.[Parameter.Tournament].LanguageId=@LangId
Where  
		 ((CAST(Cache.Fixture.MatchDate AS Date)>=(CAST(getdate() AS Date))))
		     
 


insert @TempTableLive
SELECT top 10 
  Match.Code.Code
,Live.EventDetail.BetradarMatchIds as BetradarMatchId
,Live.EventDetail.EventId

						 , Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetiTip_1.CompetitorName+' | '+ISNULL(Language.[Parameter.Tournament].TournamentName,'') AS EventName
						,1 as Color
                        
FROM              Live.Event with (nolock) INNER JOIN
                         Live.EventDetail with (nolock) ON Live.Event.EventId = Live.EventDetail.EventId INNER JOIN  
						  Language.ParameterCompetitor with (nolock) ON Language.ParameterCompetitor.LanguageId=@LangId 
						 and   Language.ParameterCompetitor.CompetitorId=Live.[Event].HomeTeam   INNER JOIN
                         Language.ParameterCompetitor AS ParameterCompetiTip_1 with (nolock) ON ParameterCompetiTip_1.CompetitorId = Live.Event.AwayTeam   AND ParameterCompetiTip_1.LanguageId=@LangId  
						 INNER JOIN Match.Code with (nolock) ON Match.Code.MatchId=Live.Event.EventId and Match.Code.BetTypeId=1  INNER JOIN 
					   Language.[Parameter.Tournament] with (nolock) ON Language.[Parameter.Tournament].TournamentId=live.[Event].TournamentId and Language.[Parameter.Tournament].LanguageId=@LangId
Where   ((Live.[EventDetail].IsActive=1 and --Match Active
Live.[EventDetail].TimeStatu not in (0,1,5,14,27,84,21,22,23,24,25,26,11,86,83)  ) OR 
((Live.[EventDetail].TimeStatu=5 and DATEDIFF(MINUTE,  Live.[EventDetail].UpdatedDate,GETDATE())<2)  and  Live.[EventDetail].IsActive=1 and Live.[EventDetail].BetStatus=2)) --ORDER BY Live.Event.EventId


insert @TempTableOutright
select  distinct top 10 Match.Code.Code as MatchCode,Outrights.[Event].EventBetradarId, Outrights.[Event].EventId as MatchId, [Language].[Parameter.Category].CategoryName +' '+ Outrights.[EventName].EventName AS EventName,2 as Color

		from Outrights.[Event] with (nolock) inner join Outrights.[EventName] with (nolock) on Outrights.[Event].EventId = Outrights.[EventName].EventId 
				and Outrights.[EventName].LanguageId=2
		inner join Parameter.TournamentOutrights with (nolock) on Outrights.[Event].TournamentId=Parameter.TournamentOutrights.TournamentId
		inner join Parameter.[Category] with (nolock) on Parameter.[Category].CategoryId=Parameter.TournamentOutrights.CategoryId 
		inner join Parameter.Sport with (nolock) on Parameter.[Category].SportId=Parameter.Sport.SportId 
		inner join [Language].[Parameter.Category] with (nolock) on [Language].[Parameter.Category].CategoryId=Parameter.[Category].CategoryId 
			and [Language].[Parameter.Category].LanguageId=2 
			 INNER JOIN Match.Code with (nolock) ON Match.Code.MatchId=Outrights.[Event].EventId and Match.Code.BetTypeId=2
Where   Outrights.[Event].EventDate>DATEADD(MINUTE,1, GETDATE()) and Outrights.[Event].IsActive=1 and Parameter.TournamentOutrights.IsActive=1 


end

insert @TempTableList
select Code,BetradarMatchId,MatchId,EventName,Color from @TempTableLive where Code is not null

insert @TempTableList
select Code,BetradarMatchId,MatchId,EventName,Color from @TempTablePre where BetradarMatchId not in (select BetradarMatchId from @TempTableLive where Code is not null)

insert @TempTableList
select Code,BetradarMatchId,MatchId,EventName,Color from @TempTableOutright


select Code,BetradarMatchId,MatchId,EventName,Color from @TempTableList order by  LEN(Code)





END



GO
