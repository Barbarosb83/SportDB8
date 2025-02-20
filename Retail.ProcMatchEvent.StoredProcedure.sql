USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcMatchEvent]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 

CREATE PROCEDURE [Retail].[ProcMatchEvent] 

@LangId int

AS
BEGIN


declare  @TempTablePre table(Code nvarchar(10),BetradarMatchId bigint,MatchId bigint,EventName nvarchar(200),Color int)
declare  @TempTableLive table(Code nvarchar(10),BetradarMatchId bigint,MatchId bigint,EventName nvarchar(200),Color int)

insert @TempTablePre
SELECT    Match.Code.Code
,Cache.Fixture.BetradarMatchId
,Cache.Fixture.MatchId,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetiTip_1.CompetitorName AS EventName
                  ,0 as Color
			
FROM         Parameter.Competitor AS CompetiTip_1 with (nolock) INNER JOIN
                      Parameter.Competitor with (nolock) INNER JOIN
                      Language.ParameterCompetitor with (nolock) ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangId INNER JOIN
                      Cache.Fixture with (nolock) ON Parameter.Competitor.CompetitorId = Cache.Fixture.HomeTeam ON CompetiTip_1.CompetitorId = Cache.Fixture.AwayTeam INNER JOIN
                      Language.ParameterCompetitor AS ParameterCompetiTip_1 with (nolock) ON CompetiTip_1.CompetitorId = ParameterCompetiTip_1.CompetitorId and ParameterCompetiTip_1.LanguageId=@LangId 
					   LEFT OUTER JOIN Match.Code with (nolock)  ON Match.Code.MatchId=Cache.Fixture.MatchId
Where  
		 ((CAST(Cache.Fixture.MatchDate AS Date)>=(CAST(getdate() AS Date))))
		  
 


insert @TempTableLive
SELECT 
  Match.Code.Code
,Live.Event.BetradarMatchId
,Live.Event.EventId

						 , Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetiTip_1.CompetitorName AS EventName
						,1 as Color
                        
FROM              Live.Event with (nolock) INNER JOIN
                         Live.EventDetail with (nolock) ON Live.Event.EventId = Live.EventDetail.EventId INNER JOIN  
						  Language.ParameterCompetitor with (nolock) ON Language.ParameterCompetitor.LanguageId=@LangId 
						 and   Language.ParameterCompetitor.CompetitorId=Live.[Event].HomeTeam   INNER JOIN
                         Language.ParameterCompetitor AS ParameterCompetiTip_1 with (nolock) ON ParameterCompetiTip_1.CompetitorId = Live.Event.AwayTeam   AND ParameterCompetiTip_1.LanguageId=@LangId  
						 LEFT OUTER JOIN Match.Code with (nolock)  ON Match.Code.MatchId=Live.Event.EventId
Where ((Live.[EventDetail].IsActive=1 and --Match Active
Live.[EventDetail].TimeStatu not in (0,1,5,14,27,84,21,22,23,24,25,26,11,86,83)  ) OR 
((Live.[EventDetail].TimeStatu=5 and DATEDIFF(MINUTE,  Live.[EventDetail].UpdatedDate,GETDATE())<2)  and  Live.[EventDetail].IsActive=1 and Live.[EventDetail].BetStatus=2))


select Code,BetradarMatchId,MatchId,EventName,Color from @TempTableLive
UNION ALL
select Code,BetradarMatchId,MatchId,EventName,Color from @TempTablePre where BetradarMatchId not in (select BetradarMatchId from @TempTableLive)

END



GO
