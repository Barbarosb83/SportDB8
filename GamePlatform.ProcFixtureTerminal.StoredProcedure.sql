USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcFixtureTerminal]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
 
CREATE PROCEDURE [GamePlatform].[ProcFixtureTerminal] 
@SportId int,
@CategoryId int,
@TournamentId int,
@EventDate datetime,
@LangId int

AS
BEGIN
SET NOCOUNT ON;

	
	
	declare @TimeRandeId int

declare @StartDate date
declare @EndDate date
declare @TournamentIds nvarchar(max)
DECLARE @Delimeter char(1)
	SET @Delimeter = ','
	declare @sayac int=0
	DECLARE @tblOdd TABLE(oddId bigint)
	DECLARE @ak nvarchar(10)
	DECLARE @StartPos int, @Length int
	declare @LangComp int=@LangId


	
 --insert dbo.betslip values (@SportId,CAST(@CategoryId as nvarchar(20))+' Tour'+CAST(@TournamentId as nvarchar(20))+CAST(@EventDate as nvarchar(50)),GETDATE())


if(@LangComp not in (2,3,6))
	set @LangComp=2
 

if(cast(@EventDate as date)=cast(GETDATE() as date))
begin
if (@TournamentId>0)
	begin
	if (@SportId=-5) -- Time Range
	begin
		SELECT     Programme.BetradarMatchId,Programme.MatchId, Programme.MatchDate,Language.[Parameter.Tournament].TournamentName,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetitor_1.CompetitorName AS EventName, 
                    Language.[Parameter.Sport].SportName,Programme.TournamentId,Programme.SportId,Parameter.Category.CategoryId,Parameter.Sport.SportName as SportNameOrginal
				, (Select COUNT(DISTINCT Match.Odd.OddsTypeId) from Match.Odd with (nolock) INNER JOIN Parameter.OddsType PO with (nolock) ON Match.Odd.OddsTypeId=PO.OddsTypeId and PO.IsActive=1 where MatchId=CFF.MatchId and Match.Odd.StateId=2) as OddTypeCount , 
                     Programme.MatchDate as TournamentDate,case when (select COUNT(*) from Live.[EventDetail] with (nolock) where BetradarMatchIds=Programme.BetradarMatchId)>0 then cast(1 as bit) else cast(0 as bit) end as NeutralGround
					,null as HasStreaming,
					Language.[Parameter.Category].CategoryName
					,Parameter.Category.SequenceNumber,  SUBSTRING(LOWER(Parameter.Iso.IsoName2), 0, 3) AS IsoName
					,Parameter.Tournament.NewBetradarId as BetradarTournamentId
					   ,Parameter.Competitor.BetradarSuperId as HomeTeamId
							   ,Competitor_1.BetradarSuperId as AwayTeamId
FROM         Parameter.Competitor AS Competitor_1 with (nolock) INNER JOIN
                      Parameter.Competitor with (nolock) INNER JOIN
                      Language.ParameterCompetitor with (nolock) ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangComp INNER JOIN
                      Cache.Programme as Programme with (nolock) ON Parameter.Competitor.CompetitorId = Programme.[HomeTeam ] ON Competitor_1.CompetitorId = Programme.[AwayTeam ] INNER JOIN
					  Cache.Fixture as CFF with (nolock) ON CFF.MatchId=Programme.MatchId Inner JOIN
                      Language.ParameterCompetitor AS ParameterCompetitor_1 with (nolock) ON Competitor_1.CompetitorId = ParameterCompetitor_1.CompetitorId and ParameterCompetitor_1.LanguageId=@LangComp   INNER JOIN 
						 Language.[Parameter.Tournament] with (nolock) ON Language.[Parameter.Tournament].TournamentId=Programme.TournamentId and Language.[Parameter.Tournament].LanguageId=@LangId INNER JOIN
						 Parameter.Tournament with (nolock) On Parameter.Tournament.TournamentId=Programme.TournamentId INNER JOIN
						 Parameter.Category with (nolock) On Parameter.Category.CategoryId=Parameter.Tournament.CategoryId INNER JOIN
						 Parameter.Sport with (nolock) on Parameter.Sport.SportId=Programme.SportId INNER JOIN
						 Parameter.Iso ON Parameter.Iso.IsoId=Parameter.Category.IsoId INNER JOIN
						 Language.[Parameter.Category] with (nolock) On Language.[Parameter.Category].CategoryId=Parameter.Category.CategoryId and  Language.[Parameter.Category].LanguageId=@LangId  INNER JOIN
						 Language.[Parameter.Sport] with (nolock) ON  Language.[Parameter.Sport].SportId= Parameter.Sport.SportId and Language.[Parameter.Sport].LanguageId=@LangId
						 where   Programme.MatchDate<=@EventDate and CFF.TournamentId=@TournamentId
						 --and  DATEDIFF(MINUTE,GETDATE(),Programme.MatchDate)<=180 
						 AND DATEDIFF(MINUTE,GETDATE(),Programme.MatchDate)>=2 
						 and Parameter.Sport.IsActive=1
						  	order by Parameter.Category.SequenceNumber,Parameter.Tournament.TournamentId
	end
	else
	begin
	 	SELECT     Programme.BetradarMatchId,Programme.MatchId, Programme.MatchDate,Language.[Parameter.Tournament].TournamentName,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetitor_1.CompetitorName AS EventName, 
                    Language.[Parameter.Sport].SportName,Programme.TournamentId,Programme.SportId,Parameter.Category.CategoryId,Parameter.Sport.SportName as SportNameOrginal
					,    (Select COUNT(DISTINCT Match.Odd.OddsTypeId) from Match.Odd with (nolock) INNER JOIN Parameter.OddsType PO with (nolock) ON Match.Odd.OddsTypeId=PO.OddsTypeId and PO.IsActive=1 where MatchId=Programme.MatchId and Match.Odd.StateId=2) as OddTypeCount, 
                     Programme.MatchDate as TournamentDate
					,case when (select COUNT(*) from Live.[EventDetail] with (nolock) where BetradarMatchIds=Programme.BetradarMatchId)>0 then cast(1 as bit) else cast(0 as bit) end as NeutralGround
					,null AS HasStreaming,
					Language.[Parameter.Category].CategoryName
					,Parameter.Tournament.SequenceNumber,  SUBSTRING(LOWER(Parameter.Iso.IsoName2), 0, 3) AS IsoName
					,Parameter.Tournament.NewBetradarId as BetradarTournamentId
					  ,Parameter.Competitor.BetradarSuperId as HomeTeamId
							   ,Competitor_1.BetradarSuperId as AwayTeamId
FROM         Parameter.Competitor AS Competitor_1 with (nolock) INNER JOIN
                      Parameter.Competitor with (nolock) INNER JOIN
                      Language.ParameterCompetitor with (nolock) ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangComp INNER JOIN
                      Cache.Programme2 as Programme with (nolock) ON Parameter.Competitor.CompetitorId = Programme.[HomeTeam ] ON Competitor_1.CompetitorId = Programme.[AwayTeam ] INNER JOIN
                      Language.ParameterCompetitor AS ParameterCompetitor_1 with (nolock) ON Competitor_1.CompetitorId = ParameterCompetitor_1.CompetitorId and ParameterCompetitor_1.LanguageId=@LangComp LEFT OUTER JOIN
                         --Live.EventLiveStreaming with (nolock) ON Programme.BetradarMatchId = Live.EventLiveStreaming.BetradarMatchId INNER JOIN 
						 Language.[Parameter.Tournament] with (nolock)  ON Language.[Parameter.Tournament].TournamentId=Programme.TournamentId and Language.[Parameter.Tournament].LanguageId=@LangId INNER JOIN 
						 Parameter.Tournament with (nolock) On Parameter.Tournament.TournamentId=Programme.TournamentId INNER JOIN
						 Parameter.Category with (nolock) On Parameter.Category.CategoryId=Parameter.Tournament.CategoryId INNER JOIN
						 Parameter.Sport with (nolock) on Parameter.Sport.SportId=Programme.SportId INNER JOIN
						  Parameter.Iso ON Parameter.Iso.IsoId=Parameter.Category.IsoId INNER JOIN
						 Language.[Parameter.Category] with (nolock) On Language.[Parameter.Category].CategoryId=Parameter.Category.CategoryId and  Language.[Parameter.Category].LanguageId=@LangId INNER JOIN
						 Language.[Parameter.Sport]  with (nolock)ON  Language.[Parameter.Sport].SportId= Parameter.Sport.SportId and Language.[Parameter.Sport].LanguageId=@LangId  
						 where
						-- Programme.SportId=@SportId and 
						 Programme.TournamentId=@TournamentId and Programme.MatchDate>GETDATE() 
						-- and Programme.MatchDate<=case when @TournamentId not in (16,31204,28963,3793,80,2767,834) then @EventDate  else  cast('20220901' as date) end 
						 and Parameter.Sport.IsActive=1
			end
		end
else if (@CategoryId>0 )
	begin
		
		SELECT  top 50   Programme.BetradarMatchId,Programme.MatchId, Programme.MatchDate,Language.[Parameter.Tournament].TournamentName,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetitor_1.CompetitorName AS EventName, 
                    Language.[Parameter.Sport].SportName,Programme.TournamentId,Programme.SportId,Parameter.Category.CategoryId,Parameter.Sport.SportName as SportNameOrginal
					,(Select COUNT(DISTINCT Match.Odd.OddsTypeId) from Match.Odd with (nolock) INNER JOIN Parameter.OddsType PO with (nolock) ON Match.Odd.OddsTypeId=PO.OddsTypeId and PO.IsActive=1 where MatchId=CFF.MatchId and Match.Odd.StateId=2) as OddTypeCount , 
                     Programme.MatchDate as TournamentDate,case when (select COUNT(*) from Live.[EventDetail] with (nolock) where BetradarMatchIds=Programme.BetradarMatchId)>0 then cast(1 as bit) else cast(0 as bit) end as NeutralGround
					,null as HasStreaming,
					Language.[Parameter.Category].CategoryName
					,Parameter.Category.SequenceNumber,  SUBSTRING(LOWER(Parameter.Iso.IsoName2), 0, 3) AS IsoName
					,Parameter.Tournament.NewBetradarId as BetradarTournamentId
					  ,Parameter.Competitor.BetradarSuperId as HomeTeamId
							   ,Competitor_1.BetradarSuperId as AwayTeamId
FROM         Parameter.Competitor AS Competitor_1 with (nolock) INNER JOIN
                      Parameter.Competitor with (nolock)  INNER JOIN
                      Language.ParameterCompetitor with (nolock) ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangComp INNER JOIN
                      Cache.Programme2 as Programme with (nolock) ON Parameter.Competitor.CompetitorId = Programme.[HomeTeam ] ON Competitor_1.CompetitorId = Programme.[AwayTeam ] INNER JOIN
					  Cache.Fixture as CFF with (nolock) ON CFF.MatchId=Programme.MatchId Inner JOIN
                      Language.ParameterCompetitor AS ParameterCompetitor_1 with (nolock) ON Competitor_1.CompetitorId = ParameterCompetitor_1.CompetitorId and ParameterCompetitor_1.LanguageId=@LangComp  INNER JOIN 
						 Language.[Parameter.Tournament] with (nolock)  ON Language.[Parameter.Tournament].TournamentId=Programme.TournamentId and Language.[Parameter.Tournament].LanguageId=@LangId INNER JOIN 
						 Parameter.Tournament with (nolock)  On Parameter.Tournament.TournamentId=Programme.TournamentId INNER JOIN
						 Parameter.Category with (nolock)  On Parameter.Category.CategoryId=Parameter.Tournament.CategoryId INNER JOIN
						 Parameter.Sport  with (nolock) on Parameter.Sport.SportId=Programme.SportId INNER JOIN
						 Parameter.Iso ON Parameter.Iso.IsoId=Parameter.Category.IsoId INNER JOIN
						 Language.[Parameter.Category] with (nolock)  On Language.[Parameter.Category].CategoryId=Parameter.Category.CategoryId and  Language.[Parameter.Category].LanguageId=@LangId INNER JOIN
						 Language.[Parameter.Sport] with (nolock)  ON  Language.[Parameter.Sport].SportId= Parameter.Sport.SportId and Language.[Parameter.Sport].LanguageId=@LangId
						 where  Programme.MatchDate> GETDATE()
						 --case when (select COUNT(*) from Live.[Event] with (nolock) where BetradarMatchId=Programme.BetradarMatchId)>0 then DATEADD(MINUTE,12, GETDATE()) else  DATEADD(MINUTE,5, GETDATE()) end 
						-- and  cast(Programme.MatchDate as date)< case when Parameter.Tournament.IsPopularWeb=0 then cast(@EventDate as date) else  cast('20220901' as date) end
						 and Parameter.Category.CategoryId=@CategoryId  and Parameter.Sport.IsActive=1

	end
else if (@SportId>0 )
	begin
		SELECT     Programme.BetradarMatchId,Programme.MatchId, Programme.MatchDate,Language.[Parameter.Tournament].TournamentName,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetitor_1.CompetitorName AS EventName, 
                    Language.[Parameter.Sport].SportName,Programme.TournamentId,Programme.SportId,Parameter.Category.CategoryId,Parameter.Sport.SportName as SportNameOrginal
					,(Select COUNT(DISTINCT Match.Odd.OddsTypeId) from Match.Odd with (nolock) INNER JOIN Parameter.OddsType PO with (nolock) ON Match.Odd.OddsTypeId=PO.OddsTypeId and PO.IsActive=1 where MatchId=CFF.MatchId and Match.Odd.StateId=2) as OddTypeCount, 
                     Programme.MatchDate as TournamentDate,case when (select COUNT(*) from Live.[EventDetail] with (nolock) where BetradarMatchIds=Programme.BetradarMatchId)>0 then cast(1 as bit) else cast(0 as bit) end as NeutralGround
					,null as HasStreaming,
					Language.[Parameter.Category].CategoryName
					,Parameter.Tournament.SequenceNumber,  SUBSTRING(LOWER(Parameter.Iso.IsoName2), 0, 3) AS IsoName
					,Parameter.Tournament.NewBetradarId as BetradarTournamentId
					  ,Parameter.Competitor.BetradarSuperId as HomeTeamId
							   ,Competitor_1.BetradarSuperId as AwayTeamId
FROM         Parameter.Competitor AS Competitor_1 with (nolock) INNER JOIN
                      Parameter.Competitor with (nolock)  INNER JOIN
                      Language.ParameterCompetitor with (nolock) ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangComp INNER JOIN
                      Cache.Programme as Programme with (nolock) ON Parameter.Competitor.CompetitorId = Programme.[HomeTeam ] ON Competitor_1.CompetitorId = Programme.[AwayTeam ] INNER JOIN
                        Cache.Fixture as CFF with (nolock) ON CFF.MatchId=Programme.MatchId Inner JOIN
					  Language.ParameterCompetitor AS ParameterCompetitor_1 with (nolock) ON Competitor_1.CompetitorId = ParameterCompetitor_1.CompetitorId and ParameterCompetitor_1.LanguageId=@LangComp  INNER JOIN 
						 Language.[Parameter.Tournament] ON Language.[Parameter.Tournament].TournamentId=Programme.TournamentId and Language.[Parameter.Tournament].LanguageId=@LangId INNER JOIN
						 Parameter.Tournament with (nolock) On Parameter.Tournament.TournamentId=Programme.TournamentId INNER JOIN
						 Parameter.Category with (nolock) On Parameter.Category.CategoryId=Parameter.Tournament.CategoryId INNER JOIN
						 Parameter.Sport with (nolock) on Parameter.Sport.SportId=Programme.SportId INNER JOIN
						 Parameter.Iso ON Parameter.Iso.IsoId=Parameter.Category.IsoId INNER JOIN
						 Language.[Parameter.Category]  with (nolock) On Language.[Parameter.Category].CategoryId=Parameter.Category.CategoryId and  Language.[Parameter.Category].LanguageId=@LangId INNER JOIN
						 Language.[Parameter.Sport] with (nolock) ON  Language.[Parameter.Sport].SportId= Parameter.Sport.SportId and Language.[Parameter.Sport].LanguageId=@LangId
						 where Programme.SportId=@SportId and Programme.MatchDate> GETDATE()
						 --case when (select COUNT(*) from Live.[Event] with (nolock) where BetradarMatchId=Programme.BetradarMatchId)>0 
						 --then DATEADD(MINUTE,12, GETDATE()) else  DATEADD(MINUTE,5, GETDATE()) end 
						 and Programme.MatchDate<=@EventDate and Parameter.Sport.IsActive=1

	end
else if (@SportId=-1) -- Fixture Top Event
	begin
 
		SELECT     Programme.BetradarMatchId,Programme.MatchId, Programme.MatchDate,Language.[Parameter.Tournament].TournamentName,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetitor_1.CompetitorName AS EventName, 
                    Language.[Parameter.Sport].SportName,Programme.TournamentId,Programme.SportId,Parameter.Category.CategoryId,Parameter.Sport.SportName as SportNameOrginal
				,(Select COUNT(DISTINCT Match.Odd.OddsTypeId) from Match.Odd with (nolock) INNER JOIN Parameter.OddsType PO with (nolock) ON Match.Odd.OddsTypeId=PO.OddsTypeId and PO.IsActive=1 where MatchId=CFF.MatchId and Match.Odd.StateId=2) as OddTypeCount , 
                    Programme.MatchDate as TournamentDate,case when (select COUNT(*) from Live.[EventDetail] with (nolock) where BetradarMatchIds=Programme.BetradarMatchId)>0 then cast(1 as bit) else cast(0 as bit) end as NeutralGround
					,null as HasStreaming,
					Language.[Parameter.Category].CategoryName
					,Parameter.Tournament.SequenceNumber,  SUBSTRING(LOWER(Parameter.Iso.IsoName2), 0, 3) AS IsoName
					,Parameter.Tournament.NewBetradarId as BetradarTournamentId
					   ,Parameter.Competitor.BetradarSuperId as HomeTeamId
							   ,Competitor_1.BetradarSuperId as AwayTeamId
FROM         Parameter.Competitor AS Competitor_1 with (nolock) INNER JOIN
                      Parameter.Competitor with (nolock)  INNER JOIN
                      Language.ParameterCompetitor with (nolock) ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangComp INNER JOIN
                      Cache.Programme as Programme with (nolock) ON Parameter.Competitor.CompetitorId = Programme.[HomeTeam ] ON Competitor_1.CompetitorId = Programme.[AwayTeam ] INNER JOIN
					  Cache.Fixture as CFF with (nolock) ON CFF.MatchId=Programme.MatchId Inner JOIN
                      Language.ParameterCompetitor AS ParameterCompetitor_1 with (nolock) ON Competitor_1.CompetitorId = ParameterCompetitor_1.CompetitorId and ParameterCompetitor_1.LanguageId=@LangComp   INNER JOIN 
						 Language.[Parameter.Tournament] ON Language.[Parameter.Tournament].TournamentId=Programme.TournamentId and Language.[Parameter.Tournament].LanguageId=@LangId INNER JOIN
						 Parameter.Tournament with (nolock) On Parameter.Tournament.TournamentId=Programme.TournamentId INNER JOIN
						 Parameter.Category with (nolock) On Parameter.Category.CategoryId=Parameter.Tournament.CategoryId INNER JOIN
						 Parameter.Sport with (nolock) on Parameter.Sport.SportId=Programme.SportId INNER JOIN
						 Parameter.Iso ON Parameter.Iso.IsoId=Parameter.Category.IsoId INNER JOIN
						 Language.[Parameter.Category] with (nolock) On Language.[Parameter.Category].CategoryId=Parameter.Category.CategoryId and  Language.[Parameter.Category].LanguageId=@LangId INNER JOIN
						 Cache.Fixture with (nolock) ON Cache.Fixture.BetradarMatchId=Programme.BetradarMatchId and Cache.Fixture.IsPopular=1 INNER JOIN
						 Language.[Parameter.Sport] with (nolock) ON  Language.[Parameter.Sport].SportId= Parameter.Sport.SportId and Language.[Parameter.Sport].LanguageId=@LangId  
						 where  Programme.MatchDate> GETDATE()
						 --case when (select COUNT(*) from Live.[Event] with (nolock) where BetradarMatchId=Programme.BetradarMatchId)>0
						 -- then DATEADD(MINUTE,12, GETDATE()) else  DATEADD(MINUTE,5, GETDATE()) end 
						  and Programme.MatchDate<=@EventDate and Parameter.Sport.IsActive=1
						 	order by Parameter.Category.SequenceNumber,Parameter.Tournament.TournamentId

	end
else if (@SportId=-2) -- Tournament Full High
	begin
	declare @TempTable table(MatchId bigint)


insert @TempTable
SELECT  top 32   Customer.SlipOdd.MatchId 
FROM       Customer.SlipOdd with (nolock)	 			  
WHERE     (CAST(Customer.SlipOdd.EventDate AS date) >= CAST(GETDATE() AS date))
			  group by Customer.SlipOdd.MatchId 	ORDER BY 	COUNT(Customer.SlipOdd.MatchId ) desc


if ((select count(MatchId) from  @TempTable)<4)
begin
	insert @TempTable
	SELECT  top 32  Cache.Fixture.MatchId
		FROM       Cache.Fixture with (nolock)				  
		WHERE     Cache.Fixture.IsPopular=1  and MatchId not in (select MatchId from  @TempTable)
end

 
		SELECT      Programme.BetradarMatchId,Programme.MatchId, Programme.MatchDate,Language.[Parameter.Tournament].TournamentName,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetitor_1.CompetitorName AS EventName, 
                    Language.[Parameter.Sport].SportName,Programme.TournamentId,Programme.SportId,Parameter.Category.CategoryId,Parameter.Sport.SportName as SportNameOrginal
					,(Select COUNT(DISTINCT Match.Odd.OddsTypeId) from Match.Odd with (nolock) INNER JOIN Parameter.OddsType PO with (nolock) ON Match.Odd.OddsTypeId=PO.OddsTypeId and PO.IsActive=1 where MatchId=CFF.MatchId and Match.Odd.StateId=2) as OddTypeCount , 
                     Programme.MatchDate as TournamentDate,case when (select COUNT(*) from Live.[EventDetail] with (nolock) where BetradarMatchIds=Programme.BetradarMatchId)>0 then cast(1 as bit) else cast(0 as bit) end as NeutralGround
					, cast(0 as bit)  AS HasStreaming,
					Language.[Parameter.Category].CategoryName
					,Parameter.Category.SequenceNumber,  SUBSTRING(LOWER(Parameter.Iso.IsoName2), 0, 3) AS IsoName
					,Parameter.Tournament.NewBetradarId as BetradarTournamentId
					   ,Parameter.Competitor.BetradarSuperId as HomeTeamId
							   ,Competitor_1.BetradarSuperId as AwayTeamId
FROM         Parameter.Competitor AS Competitor_1 with (nolock) INNER JOIN
                      Parameter.Competitor with (nolock)  INNER JOIN
                      Language.ParameterCompetitor with (nolock) ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangComp INNER JOIN
                      Cache.Programme as Programme with (nolock) ON Parameter.Competitor.CompetitorId = Programme.[HomeTeam ] ON Competitor_1.CompetitorId = Programme.[AwayTeam ] INNER JOIN
					  Cache.Fixture as CFF with (nolock) ON CFF.MatchId=Programme.MatchId Inner JOIN
                      Language.ParameterCompetitor AS ParameterCompetitor_1 with (nolock) ON Competitor_1.CompetitorId = ParameterCompetitor_1.CompetitorId and ParameterCompetitor_1.LanguageId=@LangComp 
--					  LEFT OUTER JOIN                         Live.EventLiveStreaming with (nolock) ON Programme.BetradarMatchId = Live.EventLiveStreaming.BetradarMatchId
					   INNER JOIN 
						 Language.[Parameter.Tournament] with (nolock) ON Language.[Parameter.Tournament].TournamentId=Programme.TournamentId and Language.[Parameter.Tournament].LanguageId=@LangId INNER JOIN
						 Parameter.Tournament with (nolock) On Parameter.Tournament.TournamentId=Programme.TournamentId INNER JOIN
						 Parameter.Category with (nolock) On Parameter.Category.CategoryId=Parameter.Tournament.CategoryId INNER JOIN
						 Parameter.Sport with (nolock) on Parameter.Sport.SportId=Programme.SportId INNER JOIN
						 Parameter.Iso ON Parameter.Iso.IsoId=Parameter.Category.IsoId INNER JOIN
						 Language.[Parameter.Category]  with (nolock) On Language.[Parameter.Category].CategoryId=Parameter.Category.CategoryId and  Language.[Parameter.Category].LanguageId=@LangId INNER JOIN
						  @TempTable AS temp ON Programme.MatchId=temp.MatchId  INNER JOIN
						 Language.[Parameter.Sport] with (nolock) ON  Language.[Parameter.Sport].SportId= Parameter.Sport.SportId and Language.[Parameter.Sport].LanguageId=@LangId  
						 where  Programme.MatchDate> GETDATE()
						 --case when (select COUNT(*) from Live.[Event] with (nolock) where BetradarMatchId=Programme.BetradarMatchId)>0 
						 --then DATEADD(MINUTE,12, GETDATE()) else  DATEADD(MINUTE,5, GETDATE()) end 
						-- and Programme.MatchDate<=@EventDate
						 and Parameter.Sport.IsActive=1
						 	order by Parameter.Category.SequenceNumber,Parameter.Tournament.TournamentId 

	end
else if (@SportId=-3) -- Tournament Full Last Min.
	begin
		SELECT     Programme.BetradarMatchId,Programme.MatchId, Programme.MatchDate,Language.[Parameter.Tournament].TournamentName,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetitor_1.CompetitorName AS EventName, 
                    Language.[Parameter.Sport].SportName,Programme.TournamentId,Programme.SportId,Parameter.Category.CategoryId,Parameter.Sport.SportName as SportNameOrginal
				,(Select COUNT(DISTINCT Match.Odd.OddsTypeId) from Match.Odd with (nolock) INNER JOIN Parameter.OddsType PO with (nolock) ON Match.Odd.OddsTypeId=PO.OddsTypeId and PO.IsActive=1 where MatchId=CFF.MatchId and Match.Odd.StateId=2) as OddTypeCount , 
                     Programme.MatchDate as TournamentDate,case when (select COUNT(*) from Live.[EventDetail] with (nolock) where BetradarMatchIds=Programme.BetradarMatchId)>0 then cast(1 as bit) else cast(0 as bit) end as NeutralGround
					,null as HasStreaming,
					Language.[Parameter.Category].CategoryName
					,Parameter.Category.SequenceNumber,  SUBSTRING(LOWER(Parameter.Iso.IsoName2), 0, 3) AS IsoName
					,Parameter.Tournament.NewBetradarId as BetradarTournamentId
					   ,Parameter.Competitor.BetradarSuperId as HomeTeamId
							   ,Competitor_1.BetradarSuperId as AwayTeamId
FROM         Parameter.Competitor AS Competitor_1 with (nolock) INNER JOIN
                      Parameter.Competitor with (nolock) INNER JOIN
                      Language.ParameterCompetitor with (nolock) ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangComp INNER JOIN
                      Cache.Programme as Programme with (nolock) ON Parameter.Competitor.CompetitorId = Programme.[HomeTeam ] ON Competitor_1.CompetitorId = Programme.[AwayTeam ] INNER JOIN
					  Cache.Fixture as CFF with (nolock) ON CFF.MatchId=Programme.MatchId Inner JOIN
                      Language.ParameterCompetitor AS ParameterCompetitor_1 with (nolock) ON Competitor_1.CompetitorId = ParameterCompetitor_1.CompetitorId and ParameterCompetitor_1.LanguageId=@LangComp   INNER JOIN 
						 Language.[Parameter.Tournament] with (nolock) ON Language.[Parameter.Tournament].TournamentId=Programme.TournamentId and Language.[Parameter.Tournament].LanguageId=@LangId INNER JOIN
						 Parameter.Tournament with (nolock) On Parameter.Tournament.TournamentId=Programme.TournamentId INNER JOIN
						 Parameter.Category with (nolock) On Parameter.Category.CategoryId=Parameter.Tournament.CategoryId INNER JOIN
						 Parameter.Sport with (nolock) on Parameter.Sport.SportId=Programme.SportId INNER JOIN
						 Parameter.Iso ON Parameter.Iso.IsoId=Parameter.Category.IsoId INNER JOIN
						 Language.[Parameter.Category] with (nolock) On Language.[Parameter.Category].CategoryId=Parameter.Category.CategoryId and  Language.[Parameter.Category].LanguageId=@LangId  INNER JOIN
						 Language.[Parameter.Sport] with (nolock) ON  Language.[Parameter.Sport].SportId= Parameter.Sport.SportId and Language.[Parameter.Sport].LanguageId=@LangId
						 where   Programme.MatchDate<=@EventDate and  DATEDIFF(MINUTE,GETDATE(),Programme.MatchDate)<=180 AND DATEDIFF(MINUTE,GETDATE(),Programme.MatchDate)>=3 and Parameter.Sport.IsActive=1
						  	order by Parameter.Category.SequenceNumber,Parameter.Tournament.TournamentId
	end
else if (@SportId=-4) -- Mobile Fixture
	begin

 

select @SportId=SportId,@TournamentIds=TournamentId,@TimeRandeId=TimeRangeId from CMS.MobileHomeMenu 
where CMS.MobileHomeMenu.MobileHomeMenuId=@CategoryId --@MobileMenuId


set @StartDate=GetDate()

if (@TimeRandeId=1)--All
begin
	set @EndDate=DATEADD(MONTH,6,GetDate())
end
else if (@TimeRandeId=2)--Today
begin
	set @EndDate=DATEADD(DAY,1,GetDate())
end
else if (@TimeRandeId=3)--Weekend
begin
	set @StartDate=DATEADD(wk,DATEDIFF(wk,0,GETDATE()),5)
	set @EndDate=DATEADD(wk,DATEDIFF(wk,0,GETDATE()),7)
end


if (@TournamentIds is not null and @TournamentIds<>'')
begin

 
	WHILE LEN(@TournamentIds) > 0
	  BEGIN
		SET @StartPos = CHARINDEX(@Delimeter, @TournamentIds)
		IF @StartPos < 0 SET @StartPos = 0
		SET @Length = LEN(@TournamentIds) - @StartPos - 1
		IF @Length < 0 SET @Length = 0
		IF @StartPos > 0
		  BEGIN
			SET @ak = SUBSTRING(@TournamentIds, 1, @StartPos - 1)
			SET @TournamentIds = SUBSTRING(@TournamentIds, @StartPos + 1, LEN(@TournamentIds) - @StartPos)
			set @sayac=@sayac+1
		  END
		ELSE
		  BEGIN
			SET @ak = @TournamentIds
			SET @TournamentIds = ''
			set @sayac=@sayac+1
		  END
		INSERT @tblOdd (oddId) VALUES(@ak)
	ENd


		SELECT     Programme.BetradarMatchId,Programme.MatchId, Programme.MatchDate,Language.[Parameter.Tournament].TournamentName,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetitor_1.CompetitorName AS EventName, 
                    Language.[Parameter.Sport].SportName,Programme.TournamentId,Programme.SportId,Parameter.Category.CategoryId,Parameter.Sport.SportName as SportNameOrginal
					,(Select COUNT(DISTINCT Match.Odd.OddsTypeId) from Match.Odd with (nolock) INNER JOIN Parameter.OddsType PO with (nolock) ON Match.Odd.OddsTypeId=PO.OddsTypeId and PO.IsActive=1 where MatchId=CFF.MatchId and Match.Odd.StateId=2) as OddTypeCount , 
                     Programme.MatchDate as TournamentDate,case when (select COUNT(*) from Live.[EventDetail] with (nolock) where BetradarMatchIds=Programme.BetradarMatchId)>0 then cast(1 as bit) else cast(0 as bit) end as NeutralGround
					,null as HasStreaming,
					Language.[Parameter.Category].CategoryName
					,Parameter.Category.SequenceNumber,  SUBSTRING(LOWER(Parameter.Iso.IsoName2), 0, 3) AS IsoName
					,Parameter.Tournament.NewBetradarId as BetradarTournamentId
					   ,Parameter.Competitor.BetradarSuperId as HomeTeamId
							   ,Competitor_1.BetradarSuperId as AwayTeamId
FROM         Parameter.Competitor AS Competitor_1 with (nolock) INNER JOIN
                      Parameter.Competitor with (nolock) INNER JOIN
                      Language.ParameterCompetitor with (nolock) ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangComp INNER JOIN
                      Cache.Programme2 as Programme with (nolock) ON Parameter.Competitor.CompetitorId = Programme.[HomeTeam ] ON Competitor_1.CompetitorId = Programme.[AwayTeam ] INNER JOIN
					  Cache.Fixture as CFF with (nolock) ON CFF.MatchId=Programme.MatchId Inner JOIN
                      Language.ParameterCompetitor AS ParameterCompetitor_1 with (nolock) ON Competitor_1.CompetitorId = ParameterCompetitor_1.CompetitorId and ParameterCompetitor_1.LanguageId=@LangComp  INNER JOIN 
						 Language.[Parameter.Tournament] with (nolock) ON Language.[Parameter.Tournament].TournamentId=Programme.TournamentId and Language.[Parameter.Tournament].LanguageId=@LangId INNER JOIN
						 Parameter.Tournament with (nolock) On Parameter.Tournament.TournamentId=Programme.TournamentId INNER JOIN
						 Parameter.Category with (nolock) On Parameter.Category.CategoryId=Parameter.Tournament.CategoryId INNER JOIN
						 Parameter.Sport with (nolock) on Parameter.Sport.SportId=Programme.SportId INNER JOIN
						 Parameter.Iso ON Parameter.Iso.IsoId=Parameter.Category.IsoId INNER JOIN
						 Language.[Parameter.Category] with (nolock) On Language.[Parameter.Category].CategoryId=Parameter.Category.CategoryId and  Language.[Parameter.Category].LanguageId=@LangId  INNER JOIN
						 @tblOdd as Tblodd On Parameter.Tournament.TournamentId=Tblodd.oddId INNER JOIN
						 Language.[Parameter.Sport] with (nolock) ON  Language.[Parameter.Sport].SportId= Parameter.Sport.SportId and Language.[Parameter.Sport].LanguageId=@LangId
							 where    
			 cast(Programme.MatchDate as date)< case when (select Count(*) from @tblOdd where oddId=2682)=0 then cast(@EventDate as date) else  cast('20220901' as date) end
			and ((CAST(Programme.MatchDate AS Date)>=(CAST(@StartDate AS Date)))) and  Programme.MatchDate>GETDATE() and Parameter.Sport.IsActive=1 and cast(DATEADD(HOUR,2,Programme.MatchDate) as date)<@EndDate
			order by Parameter.Category.SequenceNumber,Parameter.Tournament.TournamentId
end

else if (@SportId is not null)
begin

SELECT     Programme.BetradarMatchId,Programme.MatchId, Programme.MatchDate,Language.[Parameter.Tournament].TournamentName,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetitor_1.CompetitorName AS EventName, 
                    Language.[Parameter.Sport].SportName,Programme.TournamentId,Programme.SportId,Parameter.Category.CategoryId,Parameter.Sport.SportName as SportNameOrginal
					,(Select COUNT(DISTINCT Match.Odd.OddsTypeId) from Match.Odd with (nolock) INNER JOIN Parameter.OddsType PO with (nolock) ON Match.Odd.OddsTypeId=PO.OddsTypeId and PO.IsActive=1 where MatchId=CFF.MatchId and Match.Odd.StateId=2) as OddTypeCount , 
                     Programme.MatchDate as TournamentDate
					,case when (select COUNT(*) from Live.[EventDetail] with (nolock) where BetradarMatchIds=Programme.BetradarMatchId)>0 then cast(1 as bit) else cast(0 as bit) end as NeutralGround
					,null as HasStreaming,
					Language.[Parameter.Category].CategoryName
					,Parameter.Category.SequenceNumber,  SUBSTRING(LOWER(Parameter.Iso.IsoName2), 0, 3) AS IsoName
					,Parameter.Tournament.NewBetradarId as BetradarTournamentId
					   ,Parameter.Competitor.BetradarSuperId as HomeTeamId
							   ,Competitor_1.BetradarSuperId as AwayTeamId
FROM         Parameter.Competitor AS Competitor_1 with (nolock) INNER JOIN
                      Parameter.Competitor with (nolock)  INNER JOIN
                      Language.ParameterCompetitor with (nolock) ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangComp INNER JOIN
                      Cache.Programme2 as Programme with (nolock) ON Parameter.Competitor.CompetitorId = Programme.[HomeTeam ] ON Competitor_1.CompetitorId = Programme.[AwayTeam ] INNER JOIN
					  Cache.Fixture as CFF with (nolock) ON CFF.MatchId=Programme.MatchId Inner JOIN
                      Language.ParameterCompetitor AS ParameterCompetitor_1 with (nolock) ON Competitor_1.CompetitorId = ParameterCompetitor_1.CompetitorId and ParameterCompetitor_1.LanguageId=@LangComp  INNER JOIN 
						 Language.[Parameter.Tournament] ON Language.[Parameter.Tournament].TournamentId=Programme.TournamentId and Language.[Parameter.Tournament].LanguageId=@LangId INNER JOIN
						 Parameter.Tournament On Parameter.Tournament.TournamentId=Programme.TournamentId INNER JOIN
						 Parameter.Category On Parameter.Category.CategoryId=Parameter.Tournament.CategoryId INNER JOIN
						 Parameter.Sport on Parameter.Sport.SportId=Programme.SportId INNER JOIN
						 Parameter.Iso ON Parameter.Iso.IsoId=Parameter.Category.IsoId INNER JOIN
						 Language.[Parameter.Category] On Language.[Parameter.Category].CategoryId=Parameter.Category.CategoryId and  Language.[Parameter.Category].LanguageId=@LangId INNER JOIN
						 Language.[Parameter.Sport] ON  Language.[Parameter.Sport].SportId= Parameter.Sport.SportId and Language.[Parameter.Sport].LanguageId=@LangId
						Where  Programme.SportId=@SportId and 
			   cast(DATEADD(HOUR,2,Programme.MatchDate) as date)<@EndDate and ((CAST(Programme.MatchDate AS Date)>=(CAST(@StartDate AS Date)))) and  Programme.MatchDate>GETDATE() and Parameter.Sport.IsActive=1
			order by Parameter.Category.SequenceNumber,Parameter.Tournament.TournamentId
end



	end
 
else if (@CategoryId=-1) -- Upcoming fixture
begin
	SELECT     Programme.BetradarMatchId,Programme.MatchId, Programme.MatchDate,Language.[Parameter.Tournament].TournamentName,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetitor_1.CompetitorName AS EventName, 
                    Language.[Parameter.Sport].SportName,Programme.TournamentId,Programme.SportId,Parameter.Category.CategoryId,Parameter.Sport.SportName as SportNameOrginal
					,(Select COUNT(DISTINCT Match.Odd.OddsTypeId) from Match.Odd with (nolock) INNER JOIN Parameter.OddsType PO with (nolock) ON Match.Odd.OddsTypeId=PO.OddsTypeId and PO.IsActive=1 where MatchId=CFF.MatchId and Match.Odd.StateId=2) as OddTypeCount , 
                     Programme.MatchDate as TournamentDate,cast(1 as bit)  as NeutralGround
					,null as HasStreaming,
					Language.[Parameter.Category].CategoryName
					,Parameter.Category.SequenceNumber,  SUBSTRING(LOWER(Parameter.Iso.IsoName2), 0, 3) AS IsoName
					,Parameter.Tournament.NewBetradarId as BetradarTournamentId
					   ,Parameter.Competitor.BetradarSuperId as HomeTeamId
							   ,Competitor_1.BetradarSuperId as AwayTeamId
FROM         Parameter.Competitor AS Competitor_1 with (nolock) INNER JOIN
                      Parameter.Competitor with (nolock)  INNER JOIN
                      Language.ParameterCompetitor with (nolock) ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangComp INNER JOIN
                      Cache.Programme as Programme with (nolock) ON Parameter.Competitor.CompetitorId = Programme.[HomeTeam ] ON Competitor_1.CompetitorId = Programme.[AwayTeam ] INNER JOIN
					  Cache.Fixture as CFF with (nolock) ON CFF.MatchId=Programme.MatchId Inner JOIN
                      Language.ParameterCompetitor AS ParameterCompetitor_1 with (nolock) ON Competitor_1.CompetitorId = ParameterCompetitor_1.CompetitorId and ParameterCompetitor_1.LanguageId=@LangComp   INNER JOIN 
						 Language.[Parameter.Tournament] ON Language.[Parameter.Tournament].TournamentId=Programme.TournamentId and Language.[Parameter.Tournament].LanguageId=@LangId INNER JOIN
						 Parameter.Tournament On Parameter.Tournament.TournamentId=Programme.TournamentId INNER JOIN
						 Parameter.Category On Parameter.Category.CategoryId=Parameter.Tournament.CategoryId INNER JOIN
						 Parameter.Sport on Parameter.Sport.SportId=Programme.SportId INNER JOIN
						 Parameter.Iso ON Parameter.Iso.IsoId=Parameter.Category.IsoId INNER JOIN
						 Language.[Parameter.Category] On Language.[Parameter.Category].CategoryId=Parameter.Category.CategoryId and  Language.[Parameter.Category].LanguageId=@LangId INNER JOIN
						 Live.Event with (nolock) ON Live.Event.BetradarMatchId=Programme.BetradarMatchId and Parameter.Sport.IsActive=1 INNER JOIN
						 Language.[Parameter.Sport] ON  Language.[Parameter.Sport].SportId= Parameter.Sport.SportId and Language.[Parameter.Sport].LanguageId=@LangId
						 where  Programme.MatchDate> GETDATE()
						 --case when (Select Count(*) from Live.Event with (nolock) where BetradarMatchId=Programme.BetradarMatchId)>0 
						 --then DATEADD(MINUTE,15, GETDATE()) else DATEADD(MINUTE,5, GETDATE()) end  
						 and Programme.MatchDate<=@EventDate
end
else if (@SportId=-15) -- Fixture Top Event
	begin



		SELECT  top 300   Programme.BetradarMatchId,Programme.MatchId, Programme.MatchDate,Language.[Parameter.Tournament].TournamentName,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetitor_1.CompetitorName AS EventName, 
                    Language.[Parameter.Sport].SportName,Programme.TournamentId,Programme.SportId,Parameter.Category.CategoryId,Parameter.Sport.SportName as SportNameOrginal
				,(Select COUNT(DISTINCT Match.Odd.OddsTypeId) from Match.Odd with (nolock) INNER JOIN Parameter.OddsType PO with (nolock) ON Match.Odd.OddsTypeId=PO.OddsTypeId and PO.IsActive=1 where MatchId=CFF.MatchId and Match.Odd.StateId=2) as OddTypeCount , 
                    Programme.MatchDate as TournamentDate,case when (select COUNT(*) from Live.[EventDetail] with (nolock) where BetradarMatchIds=Programme.BetradarMatchId)>0 then cast(1 as bit) else cast(0 as bit) end as NeutralGround
					,null as HasStreaming,
					Language.[Parameter.Category].CategoryName
					,Parameter.Category.SequenceNumber,  SUBSTRING(LOWER(Parameter.Iso.IsoName2), 0, 3) AS IsoName
					,Parameter.Tournament.NewBetradarId as BetradarTournamentId
					   ,Parameter.Competitor.BetradarSuperId as HomeTeamId
							   ,Competitor_1.BetradarSuperId as AwayTeamId
FROM         Parameter.Competitor AS Competitor_1 with (nolock) INNER JOIN
                      Parameter.Competitor with (nolock)  INNER JOIN
                      Language.ParameterCompetitor with (nolock) ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangComp INNER JOIN
                      Cache.Programme as Programme with (nolock) ON Parameter.Competitor.CompetitorId = Programme.[HomeTeam ] ON Competitor_1.CompetitorId = Programme.[AwayTeam ] INNER JOIN
					  Cache.Fixture as CFF with (nolock) ON CFF.MatchId=Programme.MatchId Inner JOIN
                      Language.ParameterCompetitor AS ParameterCompetitor_1 with (nolock) ON Competitor_1.CompetitorId = ParameterCompetitor_1.CompetitorId and ParameterCompetitor_1.LanguageId=@LangComp   INNER JOIN 
						 Language.[Parameter.Tournament] ON Language.[Parameter.Tournament].TournamentId=Programme.TournamentId and Language.[Parameter.Tournament].LanguageId=@LangId INNER JOIN
						 Parameter.Tournament with (nolock) On Parameter.Tournament.TournamentId=Programme.TournamentId INNER JOIN
						 Parameter.Category with (nolock) On Parameter.Category.CategoryId=Parameter.Tournament.CategoryId INNER JOIN
						 Parameter.Sport with (nolock) on Parameter.Sport.SportId=Programme.SportId INNER JOIN
						 Parameter.Iso ON Parameter.Iso.IsoId=Parameter.Category.IsoId INNER JOIN
						 Language.[Parameter.Category] with (nolock) On Language.[Parameter.Category].CategoryId=Parameter.Category.CategoryId and  Language.[Parameter.Category].LanguageId=@LangId INNER JOIN
						 Cache.Fixture with (nolock) ON Cache.Fixture.BetradarMatchId=Programme.BetradarMatchId  INNER JOIN
						 Language.[Parameter.Sport] with (nolock) ON  Language.[Parameter.Sport].SportId= Parameter.Sport.SportId and Language.[Parameter.Sport].LanguageId=@LangId  
						 where  Programme.MatchDate> GETDATE()
						  and Programme.MatchDate<=@EventDate and Parameter.Sport.IsActive=1 and Parameter.Sport.SportId=@CategoryId
						 	order by Parameter.Category.SequenceNumber,Parameter.Tournament.TournamentId

	end
else 
	begin
		SELECT  top 20   Programme.BetradarMatchId,Programme.MatchId, Programme.MatchDate,Language.[Parameter.Tournament].TournamentName,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetitor_1.CompetitorName AS EventName, 
                    Language.[Parameter.Sport].SportName,Programme.TournamentId,Programme.SportId,Parameter.Category.CategoryId,Parameter.Sport.SportName as SportNameOrginal
					,(Select COUNT(DISTINCT Match.Odd.OddsTypeId) from Match.Odd with (nolock) INNER JOIN Parameter.OddsType PO with (nolock) ON Match.Odd.OddsTypeId=PO.OddsTypeId and PO.IsActive=1 where MatchId=CFF.MatchId and Match.Odd.StateId=2) as OddTypeCount, 
                    Programme.MatchDate as TournamentDate,case when (select COUNT(*) from Live.[EventDetail] with (nolock) where BetradarMatchIds=Programme.BetradarMatchId)>0 then cast(1 as bit) else cast(0 as bit) end as NeutralGround
					,null as HasStreaming,
					Language.[Parameter.Category].CategoryName
					,Parameter.Category.SequenceNumber,  SUBSTRING(LOWER(Parameter.Iso.IsoName2), 0, 3) AS IsoName
					,Parameter.Tournament.NewBetradarId as BetradarTournamentId
					   ,Parameter.Competitor.BetradarSuperId as HomeTeamId
							   ,Competitor_1.BetradarSuperId as AwayTeamId
FROM         Parameter.Competitor AS Competitor_1 with (nolock) INNER JOIN
                      Parameter.Competitor with (nolock)  INNER JOIN
                      Language.ParameterCompetitor with (nolock) ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangComp INNER JOIN
                      Cache.Programme as Programme with (nolock) ON Parameter.Competitor.CompetitorId = Programme.[HomeTeam ] ON Competitor_1.CompetitorId = Programme.[AwayTeam ] INNER JOIN
					  Cache.Fixture as CFF with (nolock) ON CFF.MatchId=Programme.MatchId Inner JOIN
                      Language.ParameterCompetitor AS ParameterCompetitor_1 with (nolock) ON Competitor_1.CompetitorId = ParameterCompetitor_1.CompetitorId and ParameterCompetitor_1.LanguageId=@LangComp  INNER JOIN 
						 Language.[Parameter.Tournament] ON Language.[Parameter.Tournament].TournamentId=Programme.TournamentId and Language.[Parameter.Tournament].LanguageId=@LangId INNER JOIN
						 Parameter.Tournament with (nolock)  On Parameter.Tournament.TournamentId=Programme.TournamentId INNER JOIN
						 Parameter.Category with (nolock)  On Parameter.Category.CategoryId=Parameter.Tournament.CategoryId INNER JOIN
						 Parameter.Sport with (nolock)  on Parameter.Sport.SportId=Programme.SportId INNER JOIN
						 Parameter.Iso ON Parameter.Iso.IsoId=Parameter.Category.IsoId INNER JOIN
						 Language.[Parameter.Category] with (nolock)  On Language.[Parameter.Category].CategoryId=Parameter.Category.CategoryId and  Language.[Parameter.Category].LanguageId=@LangId and Parameter.Sport.IsActive=1 INNER JOIN
						 Language.[Parameter.Sport] with (nolock)  ON  Language.[Parameter.Sport].SportId= Parameter.Sport.SportId and Language.[Parameter.Sport].LanguageId=@LangId
						 where Programme.MatchDate> GETDATE()
						 --case when (select COUNT(*) from Live.[Event] with (nolock) where BetradarMatchId=Programme.BetradarMatchId)>0 then DATEADD(MINUTE,12, GETDATE()) else  DATEADD(MINUTE,5, GETDATE()) end

	end
end
else
begin 
	if(DATEDIFF(Day,GETDATE(), @EventDate)>10)
			set @EventDate=DATEADD(DAY,90,GETDATE())
if (@TournamentId>0)
	begin
	 if (@SportId=-5)  -- Time Range
	begin
		SELECT top 50    Programme.BetradarMatchId,Programme.MatchId, Programme.MatchDate,Language.[Parameter.Tournament].TournamentName,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetitor_1.CompetitorName AS EventName, 
                    Language.[Parameter.Sport].SportName,Programme.TournamentId,Programme.SportId,Parameter.Category.CategoryId,Parameter.Sport.SportName as SportNameOrginal
					,(Select COUNT(DISTINCT Match.Odd.OddsTypeId) from Match.Odd with (nolock) INNER JOIN Parameter.OddsType PO with (nolock) ON Match.Odd.OddsTypeId=PO.OddsTypeId and PO.IsActive=1 where MatchId=CFF.MatchId and Match.Odd.StateId=2) as OddTypeCount ,  
                    Programme.MatchDate as TournamentDate,case when (select COUNT(*) from Live.[EventDetail] with (nolock) where BetradarMatchIds=Programme.BetradarMatchId)>0 then cast(1 as bit) else cast(0 as bit) end as NeutralGround
					,null as HasStreaming,
					Language.[Parameter.Category].CategoryName
					,Parameter.Category.SequenceNumber,  SUBSTRING(LOWER(Parameter.Iso.IsoName2), 0, 3) AS IsoName
					,Parameter.Tournament.NewBetradarId as BetradarTournamentId
					  ,Parameter.Competitor.BetradarSuperId as HomeTeamId
							   ,Competitor_1.BetradarSuperId as AwayTeamId
FROM         Parameter.Competitor AS Competitor_1 with (nolock) INNER JOIN
                      Parameter.Competitor with (nolock)  INNER JOIN
                      Language.ParameterCompetitor with (nolock) ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangComp INNER JOIN
                      Cache.Programme2 as Programme with (nolock) ON Parameter.Competitor.CompetitorId = Programme.[HomeTeam ] ON Competitor_1.CompetitorId = Programme.[AwayTeam ] INNER JOIN
					  Cache.Fixture as CFF with (nolock) ON CFF.MatchId=Programme.MatchId Inner JOIN
                      Language.ParameterCompetitor AS ParameterCompetitor_1 with (nolock) ON Competitor_1.CompetitorId = ParameterCompetitor_1.CompetitorId and ParameterCompetitor_1.LanguageId=@LangComp   INNER JOIN 
						 Language.[Parameter.Tournament] ON Language.[Parameter.Tournament].TournamentId=Programme.TournamentId and Language.[Parameter.Tournament].LanguageId=@LangId INNER JOIN
						 Parameter.Tournament with (nolock)  On Parameter.Tournament.TournamentId=Programme.TournamentId INNER JOIN
						 Parameter.Category  with (nolock) On Parameter.Category.CategoryId=Parameter.Tournament.CategoryId INNER JOIN
						 Parameter.Sport  with (nolock) on Parameter.Sport.SportId=Programme.SportId INNER JOIN
						 Parameter.Iso ON Parameter.Iso.IsoId=Parameter.Category.IsoId INNER JOIN
						 Language.[Parameter.Category] with (nolock)  On Language.[Parameter.Category].CategoryId=Parameter.Category.CategoryId and  Language.[Parameter.Category].LanguageId=@LangId  INNER JOIN
						 Language.[Parameter.Sport] with (nolock)  ON  Language.[Parameter.Sport].SportId= Parameter.Sport.SportId and Language.[Parameter.Sport].LanguageId=@LangId
						 where    Programme.MatchDate <  @EventDate  
						 AND DATEDIFF(MINUTE,GETDATE(),Programme.MatchDate)>=3 
						 and Parameter.Sport.IsActive=1 and Programme.TournamentId=@TournamentId
							order by Parameter.Category.SequenceNumber,Parameter.Tournament.TournamentId
	end
	else
		begin
			SELECT   top 50  Programme.BetradarMatchId,Programme.MatchId, Programme.MatchDate,Language.[Parameter.Tournament].TournamentName,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetitor_1.CompetitorName AS EventName, 
                    Language.[Parameter.Sport].SportName,Programme.TournamentId,Programme.SportId,Parameter.Category.CategoryId,Parameter.Sport.SportName as SportNameOrginal
					, (Select COUNT(DISTINCT Match.Odd.OddsTypeId) from Match.Odd with (nolock) INNER JOIN Parameter.OddsType PO with (nolock) ON Match.Odd.OddsTypeId=PO.OddsTypeId and PO.IsActive=1 where MatchId=CFF.MatchId and Match.Odd.StateId=2) as OddTypeCount, 
                     Programme.MatchDate as TournamentDate,case when (select COUNT(*) from Live.[EventDetail] with (nolock) where BetradarMatchIds=Programme.BetradarMatchId)>0 then cast(1 as bit) else cast(0 as bit) end as NeutralGround
					,null as HasStreaming,
					Language.[Parameter.Category].CategoryName
					,Parameter.Tournament.SequenceNumber,  SUBSTRING(LOWER(Parameter.Iso.IsoName2), 0, 3) AS IsoName
					,Parameter.Tournament.NewBetradarId as BetradarTournamentId
					  ,Parameter.Competitor.BetradarSuperId as HomeTeamId
							   ,Competitor_1.BetradarSuperId as AwayTeamId
FROM         Parameter.Competitor AS Competitor_1 with (nolock) INNER JOIN
                      Parameter.Competitor with (nolock)  INNER JOIN
					 
                      Language.ParameterCompetitor with (nolock) ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangComp INNER JOIN
                      Cache.Programme2 as Programme with (nolock) ON Parameter.Competitor.CompetitorId = Programme.[HomeTeam ] ON Competitor_1.CompetitorId = Programme.[AwayTeam ] INNER JOIN
					  Cache.Fixture as CFF with (nolock) ON CFF.MatchId=Programme.MatchId Inner JOIN
                      Match.Setting with (nolock) ON Match.Setting.MatchId=CFF.MatchId and Match.Setting.StateId=2 INNER JOIN
					  Language.ParameterCompetitor AS ParameterCompetitor_1 with (nolock) ON Competitor_1.CompetitorId = ParameterCompetitor_1.CompetitorId and ParameterCompetitor_1.LanguageId=@LangComp   INNER JOIN 
						 Language.[Parameter.Tournament] with (nolock)  ON Language.[Parameter.Tournament].TournamentId=Programme.TournamentId and Language.[Parameter.Tournament].LanguageId=@LangId INNER JOIN 
						 Parameter.Tournament with (nolock)  On Parameter.Tournament.TournamentId=Programme.TournamentId INNER JOIN
						 Parameter.Category with (nolock)  On Parameter.Category.CategoryId=Parameter.Tournament.CategoryId INNER JOIN
						 Parameter.Sport with (nolock)  on Parameter.Sport.SportId=Programme.SportId INNER JOIN
						 Parameter.Iso ON Parameter.Iso.IsoId=Parameter.Category.IsoId INNER JOIN
						 Language.[Parameter.Category] with (nolock)  On Language.[Parameter.Category].CategoryId=Parameter.Category.CategoryId and  Language.[Parameter.Category].LanguageId=@LangId INNER JOIN
						 Language.[Parameter.Sport]  with (nolock) ON  Language.[Parameter.Sport].SportId= Parameter.Sport.SportId and Language.[Parameter.Sport].LanguageId=@LangId 
						 where --Programme.SportId=@SportId and
						 Programme.MatchDate> GETDATE()
						 --case when (select COUNT(*) from Live.[Event] with (nolock) where BetradarMatchId=Programme.BetradarMatchId)>0 then DATEADD(MINUTE,12, GETDATE()) else  DATEADD(MINUTE,5, GETDATE()) end 
						 --and  (cast(Programme.MatchDate as date)< case when Parameter.Tournament.IsPopularWeb=0 then   cast(@EventDate as date) else cast(DATEADD(MONTH,5,@EventDate) as date) end   )
						 and Programme.TournamentId=@TournamentId  and Parameter.Sport.IsActive=1
						end
		end
else if (@CategoryId>0 )
	begin
		set @TournamentId=2682

		SELECT  top 50   Programme.BetradarMatchId,Programme.MatchId, Programme.MatchDate,Language.[Parameter.Tournament].TournamentName,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetitor_1.CompetitorName AS EventName, 
                    Language.[Parameter.Sport].SportName,Programme.TournamentId,Programme.SportId,Parameter.Category.CategoryId,Parameter.Sport.SportName as SportNameOrginal
					,(Select COUNT(DISTINCT Match.Odd.OddsTypeId) from Match.Odd with (nolock) INNER JOIN Parameter.OddsType PO with (nolock) ON Match.Odd.OddsTypeId=PO.OddsTypeId and PO.IsActive=1 where MatchId=CFF.MatchId and Match.Odd.StateId=2) as OddTypeCount , 
                     Programme.MatchDate as TournamentDate,case when (select COUNT(*) from Live.[EventDetail] with (nolock) where BetradarMatchIds=Programme.BetradarMatchId)>0 then cast(1 as bit) else cast(0 as bit) end as NeutralGround
					,null as HasStreaming,
					Language.[Parameter.Category].CategoryName
					,Parameter.Category.SequenceNumber,  SUBSTRING(LOWER(Parameter.Iso.IsoName2), 0, 3) AS IsoName
					,Parameter.Tournament.NewBetradarId as BetradarTournamentId
					  ,Parameter.Competitor.BetradarSuperId as HomeTeamId
							   ,Competitor_1.BetradarSuperId as AwayTeamId
FROM         Parameter.Competitor AS Competitor_1 with (nolock) INNER JOIN
                      Parameter.Competitor with (nolock)  INNER JOIN
                      Language.ParameterCompetitor with (nolock) ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangComp INNER JOIN
                      Cache.Programme2 as Programme with (nolock) ON Parameter.Competitor.CompetitorId = Programme.[HomeTeam ] ON Competitor_1.CompetitorId = Programme.[AwayTeam ] INNER JOIN
					  Cache.Fixture as CFF with (nolock) ON CFF.MatchId=Programme.MatchId Inner JOIN
                      Language.ParameterCompetitor AS ParameterCompetitor_1 with (nolock) ON Competitor_1.CompetitorId = ParameterCompetitor_1.CompetitorId and ParameterCompetitor_1.LanguageId=@LangComp  INNER JOIN 
						 Language.[Parameter.Tournament] with (nolock)  ON Language.[Parameter.Tournament].TournamentId=Programme.TournamentId and Language.[Parameter.Tournament].LanguageId=@LangId INNER JOIN 
						 Parameter.Tournament with (nolock)  On Parameter.Tournament.TournamentId=Programme.TournamentId INNER JOIN
						 Parameter.Category with (nolock)  On Parameter.Category.CategoryId=Parameter.Tournament.CategoryId INNER JOIN
						 Parameter.Sport  with (nolock) on Parameter.Sport.SportId=Programme.SportId INNER JOIN
						 Parameter.Iso ON Parameter.Iso.IsoId=Parameter.Category.IsoId INNER JOIN
						 Language.[Parameter.Category] with (nolock)  On Language.[Parameter.Category].CategoryId=Parameter.Category.CategoryId and  Language.[Parameter.Category].LanguageId=@LangId INNER JOIN
						 Language.[Parameter.Sport] with (nolock)  ON  Language.[Parameter.Sport].SportId= Parameter.Sport.SportId and Language.[Parameter.Sport].LanguageId=@LangId
						 where  Programme.MatchDate> GETDATE()
						 --case when (select COUNT(*) from Live.[Event] with (nolock) where BetradarMatchId=Programme.BetradarMatchId)>0 then DATEADD(MINUTE,12, GETDATE()) else  DATEADD(MINUTE,5, GETDATE()) end 
						-- and  cast(Programme.MatchDate as date)< case when Parameter.Tournament.IsPopularWeb=0 then cast(@EventDate as date) else  cast('20220901' as date) end
						 and Parameter.Category.CategoryId=@CategoryId  and Parameter.Sport.IsActive=1

	end
else  if (@SportId>0)
	begin
	set @TournamentId=2682

		SELECT  top 50   Programme.BetradarMatchId,Programme.MatchId, Programme.MatchDate,Language.[Parameter.Tournament].TournamentName,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetitor_1.CompetitorName AS EventName, 
                    Language.[Parameter.Sport].SportName,Programme.TournamentId,Programme.SportId,Parameter.Category.CategoryId,Parameter.Sport.SportName as SportNameOrginal
				,(Select COUNT(DISTINCT Match.Odd.OddsTypeId) from Match.Odd with (nolock) INNER JOIN Parameter.OddsType PO with (nolock) ON Match.Odd.OddsTypeId=PO.OddsTypeId and PO.IsActive=1 where MatchId=CFF.MatchId and Match.Odd.StateId=2) as OddTypeCount, 
                     Programme.MatchDate as TournamentDate,case when (select COUNT(*) from Live.[EventDetail] with (nolock) where BetradarMatchIds=Programme.BetradarMatchId)>0 then cast(1 as bit) else cast(0 as bit) end as NeutralGround
					,null as HasStreaming,
					Language.[Parameter.Category].CategoryName
					,Parameter.Category.SequenceNumber,  SUBSTRING(LOWER(Parameter.Iso.IsoName2), 0, 3) AS IsoName
					,Parameter.Tournament.NewBetradarId as BetradarTournamentId
					  ,Parameter.Competitor.BetradarSuperId as HomeTeamId
							   ,Competitor_1.BetradarSuperId as AwayTeamId
FROM         Parameter.Competitor AS Competitor_1 with (nolock) INNER JOIN
                      Parameter.Competitor with (nolock)  INNER JOIN
                      Language.ParameterCompetitor with (nolock) ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangComp INNER JOIN
                      Cache.Programme2 as Programme with (nolock) ON Parameter.Competitor.CompetitorId = Programme.[HomeTeam ] ON Competitor_1.CompetitorId = Programme.[AwayTeam ] INNER JOIN
					  Cache.Fixture as CFF with (nolock) ON CFF.MatchId=Programme.MatchId Inner JOIN
                      Language.ParameterCompetitor AS ParameterCompetitor_1 with (nolock) ON Competitor_1.CompetitorId = ParameterCompetitor_1.CompetitorId and ParameterCompetitor_1.LanguageId=@LangComp   INNER JOIN 
						 Language.[Parameter.Tournament] with (nolock)  ON Language.[Parameter.Tournament].TournamentId=Programme.TournamentId and Language.[Parameter.Tournament].LanguageId=@LangId INNER JOIN
						 Parameter.Tournament with (nolock)  On Parameter.Tournament.TournamentId=Programme.TournamentId INNER JOIN
						 Parameter.Category with (nolock)  On Parameter.Category.CategoryId=Parameter.Tournament.CategoryId INNER JOIN
						 Parameter.Sport with (nolock)  on Parameter.Sport.SportId=Programme.SportId INNER JOIN
						 Parameter.Iso ON Parameter.Iso.IsoId=Parameter.Category.IsoId INNER JOIN
						 Language.[Parameter.Category] with (nolock)  On Language.[Parameter.Category].CategoryId=Parameter.Category.CategoryId and  Language.[Parameter.Category].LanguageId=@LangId INNER JOIN
						 Language.[Parameter.Sport] with (nolock)  ON  Language.[Parameter.Sport].SportId= Parameter.Sport.SportId and Language.[Parameter.Sport].LanguageId=@LangId
						 where Programme.SportId=@SportId and Programme.MatchDate> GETDATE()
						 --case when (select COUNT(*) from Live.[Event] with (nolock) where BetradarMatchId=Programme.BetradarMatchId)>0 then DATEADD(MINUTE,12, GETDATE()) else  DATEADD(MINUTE,5, GETDATE()) end 
						-- and  cast(Programme.MatchDate as date)< case when Parameter.Tournament.IsPopularWeb=0 then cast(@EventDate as date) else  cast('20240901' as date) end 
						 and Parameter.Sport.IsActive=1

	end
else  if (@SportId=-1) -- Fixture Top Event
	begin
		set @TournamentId=2682
 
		SELECT  top 500   Programme.BetradarMatchId,Programme.MatchId, Programme.MatchDate,Language.[Parameter.Tournament].TournamentName,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetitor_1.CompetitorName AS EventName, 
                    Language.[Parameter.Sport].SportName,Programme.TournamentId,Programme.SportId,Parameter.Category.CategoryId,Parameter.Sport.SportName as SportNameOrginal
					,(Select COUNT(DISTINCT Match.Odd.OddsTypeId) from Match.Odd with (nolock) INNER JOIN Parameter.OddsType PO with (nolock) ON Match.Odd.OddsTypeId=PO.OddsTypeId and PO.IsActive=1 where MatchId=CFF.MatchId and Match.Odd.StateId=2) as OddTypeCount, 
                     Programme.MatchDate as TournamentDate,case when (select COUNT(*) from Live.[EventDetail] with (nolock) where BetradarMatchIds=Programme.BetradarMatchId)>0 then cast(1 as bit) else cast(0 as bit) end as NeutralGround
					,null as HasStreaming,
					Language.[Parameter.Category].CategoryName
					,Parameter.Category.SequenceNumber,  SUBSTRING(LOWER(Parameter.Iso.IsoName2), 0, 3) AS IsoName
					,Parameter.Tournament.NewBetradarId as BetradarTournamentId
					  ,Parameter.Competitor.BetradarSuperId as HomeTeamId
							   ,Competitor_1.BetradarSuperId as AwayTeamId
FROM         Parameter.Competitor AS Competitor_1 with (nolock) INNER JOIN
                      Parameter.Competitor with (nolock)  INNER JOIN
                      Language.ParameterCompetitor with (nolock) ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangComp INNER JOIN
                      Cache.Programme2 as Programme with (nolock) ON Parameter.Competitor.CompetitorId = Programme.[HomeTeam ] ON Competitor_1.CompetitorId = Programme.[AwayTeam ] INNER JOIN
					  Cache.Fixture as CFF with (nolock) ON CFF.MatchId=Programme.MatchId Inner JOIN
                      Language.ParameterCompetitor AS ParameterCompetitor_1 with (nolock) ON Competitor_1.CompetitorId = ParameterCompetitor_1.CompetitorId and ParameterCompetitor_1.LanguageId=@LangComp INNER JOIN 
						 Language.[Parameter.Tournament] with (nolock)  ON Language.[Parameter.Tournament].TournamentId=Programme.TournamentId and Language.[Parameter.Tournament].LanguageId=@LangId INNER JOIN
						 Parameter.Tournament with (nolock)  On Parameter.Tournament.TournamentId=Programme.TournamentId INNER JOIN
						 Parameter.Category with (nolock)  On Parameter.Category.CategoryId=Parameter.Tournament.CategoryId INNER JOIN
						 Parameter.Sport  with (nolock) on Parameter.Sport.SportId=Programme.SportId INNER JOIN
						 Parameter.Iso ON Parameter.Iso.IsoId=Parameter.Category.IsoId INNER JOIN
						 Language.[Parameter.Category] with (nolock)  On Language.[Parameter.Category].CategoryId=Parameter.Category.CategoryId and  Language.[Parameter.Category].LanguageId=@LangId INNER JOIN
						 Cache.Fixture with (nolock)  ON Cache.Fixture.BetradarMatchId=Programme.BetradarMatchId and Cache.Fixture.IsPopular=1 INNER JOIN
						 Language.[Parameter.Sport] with (nolock)  ON  Language.[Parameter.Sport].SportId= Parameter.Sport.SportId and Language.[Parameter.Sport].LanguageId=@LangId 
						 where  Programme.MatchDate> GETDATE()
						 --case when (select COUNT(*) from Live.[Event] with (nolock) where BetradarMatchId=Programme.BetradarMatchId)>0 then DATEADD(MINUTE,12, GETDATE()) else  DATEADD(MINUTE,5, GETDATE()) end 
						-- and  cast(Programme.MatchDate as date)< case when Parameter.Tournament.IsPopularWeb=0 then cast(@EventDate as date) else  cast('20240901' as date) end
						 and Parameter.Sport.IsActive=1
						 	order by Parameter.Tournament.SequenceNumber,Parameter.Tournament.TournamentId
	end
else  if (@SportId=-2)  -- Tournament Full High
	begin

		insert @TempTable
SELECT  top 32   Customer.SlipOdd.MatchId 
FROM       Customer.SlipOdd with (nolock)	 			  
WHERE     (CAST(Customer.SlipOdd.EventDate AS date) >= CAST(GETDATE() AS date))
			  group by Customer.SlipOdd.MatchId 	ORDER BY 	COUNT(Customer.SlipOdd.MatchId ) desc


if ((select count(MatchId) from  @TempTable)<4)
begin
	insert @TempTable
	SELECT  top 50  Cache.Fixture.MatchId
		FROM       Cache.Fixture with (nolock)				  
		WHERE     Cache.Fixture.IsPopular=1  and MatchId not in (select MatchId from  @TempTable)
end
		 
		SELECT  top 50   Programme.BetradarMatchId,Programme.MatchId, Programme.MatchDate,Language.[Parameter.Tournament].TournamentName,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetitor_1.CompetitorName AS EventName, 
                    Language.[Parameter.Sport].SportName,Programme.TournamentId,Programme.SportId,Parameter.Category.CategoryId,Parameter.Sport.SportName as SportNameOrginal
					,(Select COUNT(DISTINCT Match.Odd.OddsTypeId) from Match.Odd with (nolock) INNER JOIN Parameter.OddsType PO with (nolock) ON Match.Odd.OddsTypeId=PO.OddsTypeId and PO.IsActive=1 where MatchId=CFF.MatchId and Match.Odd.StateId=2) as OddTypeCount, 
                     Programme.MatchDate as TournamentDate,case when (select COUNT(*) from Live.[EventDetail] with (nolock) where BetradarMatchIds=Programme.BetradarMatchId)>0 then cast(1 as bit) else cast(0 as bit) end as NeutralGround
					,null as HasStreaming,
					Language.[Parameter.Category].CategoryName
					,Parameter.Category.SequenceNumber,  SUBSTRING(LOWER(Parameter.Iso.IsoName2), 0, 3) AS IsoName
					,Parameter.Tournament.NewBetradarId as BetradarTournamentId
					  ,Parameter.Competitor.BetradarSuperId as HomeTeamId
							   ,Competitor_1.BetradarSuperId as AwayTeamId
FROM         Parameter.Competitor AS Competitor_1 with (nolock) INNER JOIN
                      Parameter.Competitor with (nolock)  INNER JOIN
                      Language.ParameterCompetitor with (nolock) ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangComp INNER JOIN
                      Cache.Programme2 as Programme with (nolock) ON Parameter.Competitor.CompetitorId = Programme.[HomeTeam ] ON Competitor_1.CompetitorId = Programme.[AwayTeam ] INNER JOIN
					  Cache.Fixture as CFF with (nolock) ON CFF.MatchId=Programme.MatchId Inner JOIN
                      Language.ParameterCompetitor AS ParameterCompetitor_1 with (nolock) ON Competitor_1.CompetitorId = ParameterCompetitor_1.CompetitorId and ParameterCompetitor_1.LanguageId=@LangComp INNER JOIN 
						 Language.[Parameter.Tournament]  with (nolock) ON Language.[Parameter.Tournament].TournamentId=Programme.TournamentId and Language.[Parameter.Tournament].LanguageId=@LangId INNER JOIN
						 Parameter.Tournament with (nolock)  On Parameter.Tournament.TournamentId=Programme.TournamentId INNER JOIN
						 Parameter.Category with (nolock)  On Parameter.Category.CategoryId=Parameter.Tournament.CategoryId INNER JOIN
						 Parameter.Sport with (nolock)  on Parameter.Sport.SportId=Programme.SportId INNER JOIN
						 Parameter.Iso ON Parameter.Iso.IsoId=Parameter.Category.IsoId INNER JOIN
						 Language.[Parameter.Category] with (nolock)  On Language.[Parameter.Category].CategoryId=Parameter.Category.CategoryId and  Language.[Parameter.Category].LanguageId=@LangId INNER JOIN
						--   @TempTable2 AS temp ON Programme.MatchId=temp.MatchId INNER JOIN
					 
						  @TempTable AS temp ON CFF.MatchId=temp.MatchId  INNER JOIN
						 Language.[Parameter.Sport] with (nolock)  ON  Language.[Parameter.Sport].SportId= Parameter.Sport.SportId and Language.[Parameter.Sport].LanguageId=@LangId 
						 where  Programme.MatchDate> GETDATE()
						 --case when (select COUNT(*) from Live.[Event] with (nolock) where BetradarMatchId=Programme.BetradarMatchId)>0 then DATEADD(MINUTE,12, GETDATE()) else  DATEADD(MINUTE,5, GETDATE()) end 
						 and  cast(Programme.MatchDate as date)<cast(DATEADD(WEEK,3,GETDATE()) as date)
						 and Parameter.Sport.IsActive=1 and CFF.IsPopular=1
						 	order by Parameter.Tournament.SequenceNumber

	end
else if (@SportId=-3)  -- Tournament Full Last Min.
	begin
		SELECT top 50    Programme.BetradarMatchId,Programme.MatchId, Programme.MatchDate,Language.[Parameter.Tournament].TournamentName,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetitor_1.CompetitorName AS EventName, 
                    Language.[Parameter.Sport].SportName,Programme.TournamentId,Programme.SportId,Parameter.Category.CategoryId,Parameter.Sport.SportName as SportNameOrginal
					,(Select COUNT(DISTINCT Match.Odd.OddsTypeId) from Match.Odd with (nolock) INNER JOIN Parameter.OddsType PO with (nolock) ON Match.Odd.OddsTypeId=PO.OddsTypeId and PO.IsActive=1 where MatchId=CFF.MatchId and Match.Odd.StateId=2) as OddTypeCount ,  
                    Programme.MatchDate as TournamentDate,case when (select COUNT(*) from Live.[EventDetail] with (nolock) where BetradarMatchIds=Programme.BetradarMatchId)>0 then cast(1 as bit) else cast(0 as bit) end as NeutralGround
					,null as HasStreaming,
					Language.[Parameter.Category].CategoryName
					,Parameter.Category.SequenceNumber,  SUBSTRING(LOWER(Parameter.Iso.IsoName2), 0, 3) AS IsoName
					,Parameter.Tournament.NewBetradarId as BetradarTournamentId
					  ,Parameter.Competitor.BetradarSuperId as HomeTeamId
							   ,Competitor_1.BetradarSuperId as AwayTeamId
FROM         Parameter.Competitor AS Competitor_1 with (nolock) INNER JOIN
                      Parameter.Competitor with (nolock)  INNER JOIN
                      Language.ParameterCompetitor with (nolock) ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangComp INNER JOIN
                      Cache.Programme2 as Programme with (nolock) ON Parameter.Competitor.CompetitorId = Programme.[HomeTeam ] ON Competitor_1.CompetitorId = Programme.[AwayTeam ] INNER JOIN
					  Cache.Fixture as CFF with (nolock) ON CFF.MatchId=Programme.MatchId Inner JOIN
                      Language.ParameterCompetitor AS ParameterCompetitor_1 with (nolock) ON Competitor_1.CompetitorId = ParameterCompetitor_1.CompetitorId and ParameterCompetitor_1.LanguageId=@LangComp   INNER JOIN 
						 Language.[Parameter.Tournament] ON Language.[Parameter.Tournament].TournamentId=Programme.TournamentId and Language.[Parameter.Tournament].LanguageId=@LangId INNER JOIN
						 Parameter.Tournament with (nolock)  On Parameter.Tournament.TournamentId=Programme.TournamentId INNER JOIN
						 Parameter.Category  with (nolock) On Parameter.Category.CategoryId=Parameter.Tournament.CategoryId INNER JOIN
						 Parameter.Sport  with (nolock) on Parameter.Sport.SportId=Programme.SportId INNER JOIN
						 Parameter.Iso ON Parameter.Iso.IsoId=Parameter.Category.IsoId INNER JOIN
						 Language.[Parameter.Category] with (nolock)  On Language.[Parameter.Category].CategoryId=Parameter.Category.CategoryId and  Language.[Parameter.Category].LanguageId=@LangId  INNER JOIN
						 Language.[Parameter.Sport] with (nolock)  ON  Language.[Parameter.Sport].SportId= Parameter.Sport.SportId and Language.[Parameter.Sport].LanguageId=@LangId
						 where   
						 --cast(Programme.MatchDate as date)< case when Parameter.Tournament.IsPopularWeb=0 then cast(@EventDate as date) else  cast('20240901' as date) end and  DATEDIFF(MINUTE,GETDATE(),Programme.MatchDate)<=300 
						 --AND
						 DATEDIFF(MINUTE,GETDATE(),Programme.MatchDate)>=3 
						 and Parameter.Sport.IsActive=1
							order by Parameter.Category.SequenceNumber,Parameter.Tournament.TournamentId
	end
else if (@SportId=-4) -- Mobile Fixture
	begin

 

select @SportId=SportId,@TournamentIds=TournamentId,@TimeRandeId=TimeRangeId from CMS.MobileHomeMenu 
where CMS.MobileHomeMenu.MobileHomeMenuId=@CategoryId --@MobileMenuId


set @StartDate=GetDate()

if (@TimeRandeId=1)--All
begin
	set @EndDate=DATEADD(MONTH,6,GetDate())
end
else if (@TimeRandeId=2)--Today
begin
	set @EndDate=DATEADD(DAY,1,GetDate())
end
else if (@TimeRandeId=3)--Weekend
begin
	set @StartDate=DATEADD(wk,DATEDIFF(wk,0,GETDATE()),5)
	set @EndDate=DATEADD(wk,DATEDIFF(wk,0,GETDATE()),7)
end


if (@TournamentIds is not null and @TournamentIds<>'')
begin

 
	WHILE LEN(@TournamentIds) > 0
	  BEGIN
		SET @StartPos = CHARINDEX(@Delimeter, @TournamentIds)
		IF @StartPos < 0 SET @StartPos = 0
		SET @Length = LEN(@TournamentIds) - @StartPos - 1
		IF @Length < 0 SET @Length = 0
		IF @StartPos > 0
		  BEGIN
			SET @ak = SUBSTRING(@TournamentIds, 1, @StartPos - 1)
			SET @TournamentIds = SUBSTRING(@TournamentIds, @StartPos + 1, LEN(@TournamentIds) - @StartPos)
			set @sayac=@sayac+1
		  END
		ELSE
		  BEGIN
			SET @ak = @TournamentIds
			SET @TournamentIds = ''
			set @sayac=@sayac+1
		  END
		INSERT @tblOdd (oddId) VALUES(@ak)
	ENd


		SELECT   top 50  Programme.BetradarMatchId,Programme.MatchId, Programme.MatchDate,Language.[Parameter.Tournament].TournamentName,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetitor_1.CompetitorName AS EventName, 
                    Language.[Parameter.Sport].SportName,Programme.TournamentId,Programme.SportId,Parameter.Category.CategoryId,Parameter.Sport.SportName as SportNameOrginal
					,(Select COUNT(DISTINCT Match.Odd.OddsTypeId) from Match.Odd with (nolock) INNER JOIN Parameter.OddsType PO with (nolock) ON Match.Odd.OddsTypeId=PO.OddsTypeId and PO.IsActive=1 where MatchId=CFF.MatchId and Match.Odd.StateId=2) as OddTypeCount , 
                     Programme.MatchDate as TournamentDate,case when (select COUNT(*) from Live.[EventDetail] with (nolock) where BetradarMatchIds=Programme.BetradarMatchId)>0 then cast(1 as bit) else cast(0 as bit) end as NeutralGround
					,null as HasStreaming,
					Language.[Parameter.Category].CategoryName
					,Parameter.Category.SequenceNumber,  SUBSTRING(LOWER(Parameter.Iso.IsoName2), 0, 3) AS IsoName
					,Parameter.Tournament.NewBetradarId as BetradarTournamentId
					  ,Parameter.Competitor.BetradarSuperId as HomeTeamId
							   ,Competitor_1.BetradarSuperId as AwayTeamId
FROM         Parameter.Competitor AS Competitor_1 with (nolock) INNER JOIN
                      Parameter.Competitor  with (nolock) INNER JOIN
                      Language.ParameterCompetitor with (nolock) ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangComp INNER JOIN
                      Cache.Programme2 as Programme with (nolock) ON Parameter.Competitor.CompetitorId = Programme.[HomeTeam ] ON Competitor_1.CompetitorId = Programme.[AwayTeam ] INNER JOIN
					  Cache.Fixture as CFF with (nolock) ON CFF.MatchId=Programme.MatchId Inner JOIN
                      Language.ParameterCompetitor AS ParameterCompetitor_1 with (nolock) ON Competitor_1.CompetitorId = ParameterCompetitor_1.CompetitorId and ParameterCompetitor_1.LanguageId=@LangComp   INNER JOIN 
						 Language.[Parameter.Tournament] with (nolock)  ON Language.[Parameter.Tournament].TournamentId=Programme.TournamentId and Language.[Parameter.Tournament].LanguageId=@LangId INNER JOIN
						 Parameter.Tournament  with (nolock) On Parameter.Tournament.TournamentId=Programme.TournamentId INNER JOIN
						 Parameter.Category  with (nolock) On Parameter.Category.CategoryId=Parameter.Tournament.CategoryId INNER JOIN
						 Parameter.Sport  with (nolock) on Parameter.Sport.SportId=Programme.SportId INNER JOIN
						 Parameter.Iso ON Parameter.Iso.IsoId=Parameter.Category.IsoId INNER JOIN
						 Language.[Parameter.Category] with (nolock)  On Language.[Parameter.Category].CategoryId=Parameter.Category.CategoryId and  Language.[Parameter.Category].LanguageId=@LangId INNER JOIN
						 			 @tblOdd as Tblodd On Parameter.Tournament.TournamentId=Tblodd.oddId INNER JOIN
						 Language.[Parameter.Sport]  with (nolock) ON  Language.[Parameter.Sport].SportId= Parameter.Sport.SportId and Language.[Parameter.Sport].LanguageId=@LangId
						 where    
			 cast(Programme.MatchDate as date)< case when (select Count(*) from @tblOdd where oddId=2682)=0 then cast(@EventDate as date) else  cast('20220901' as date) end
			and ((CAST(Programme.MatchDate AS Date)>=(CAST(@StartDate AS Date)))) and  Programme.MatchDate>GETDATE() 
			and   cast(DATEADD(HOUR,2,Programme.MatchDate) as date)<@EndDate and Parameter.Sport.IsActive=1
			order by Parameter.Tournament.SequenceNumber,Parameter.Tournament.TournamentId
end

else if (@SportId is not null)
begin

SELECT  top 100   Programme.BetradarMatchId,Programme.MatchId, Programme.MatchDate,Language.[Parameter.Tournament].TournamentName,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetitor_1.CompetitorName AS EventName, 
                    Language.[Parameter.Sport].SportName,Programme.TournamentId,Programme.SportId,Parameter.Category.CategoryId,Parameter.Sport.SportName as SportNameOrginal
					,(Select COUNT(DISTINCT Match.Odd.OddsTypeId) from Match.Odd with (nolock) INNER JOIN Parameter.OddsType PO with (nolock) ON Match.Odd.OddsTypeId=PO.OddsTypeId and PO.IsActive=1 where MatchId=CFF.MatchId and Match.Odd.StateId=2) as OddTypeCount , 
                     Programme.MatchDate as TournamentDate,case when (select COUNT(*) from Live.[EventDetail] with (nolock) where BetradarMatchIds=Programme.BetradarMatchId)>0 then cast(1 as bit) else cast(0 as bit) end as NeutralGround
					,null  AS HasStreaming,
					Language.[Parameter.Category].CategoryName
					,Parameter.Tournament.SequenceNumber,  SUBSTRING(LOWER(Parameter.Iso.IsoName2), 0, 3) AS IsoName
					,Parameter.Tournament.NewBetradarId as BetradarTournamentId
					  ,Parameter.Competitor.BetradarSuperId as HomeTeamId
							   ,Competitor_1.BetradarSuperId as AwayTeamId
FROM         Parameter.Competitor AS Competitor_1 with (nolock) INNER JOIN
                      Parameter.Competitor with (nolock)  INNER JOIN
                      Language.ParameterCompetitor with (nolock) ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangComp INNER JOIN
                      Cache.Programme2 as Programme with (nolock) ON Parameter.Competitor.CompetitorId = Programme.[HomeTeam ] ON Competitor_1.CompetitorId = Programme.[AwayTeam ] INNER JOIN
					  Cache.Fixture as CFF with (nolock) ON CFF.MatchId=Programme.MatchId Inner JOIN
                      Language.ParameterCompetitor AS ParameterCompetitor_1 with (nolock) ON Competitor_1.CompetitorId = ParameterCompetitor_1.CompetitorId and ParameterCompetitor_1.LanguageId=@LangComp 
                         INNER JOIN 
						 Language.[Parameter.Tournament] with (nolock)  ON Language.[Parameter.Tournament].TournamentId=Programme.TournamentId and Language.[Parameter.Tournament].LanguageId=@LangId INNER JOIN
						 Parameter.Tournament with (nolock)  On Parameter.Tournament.TournamentId=Programme.TournamentId INNER JOIN
						 Parameter.Category with (nolock)  On Parameter.Category.CategoryId=Parameter.Tournament.CategoryId INNER JOIN
						 Parameter.Sport with (nolock)  on Parameter.Sport.SportId=Programme.SportId INNER JOIN
						 Parameter.Iso ON Parameter.Iso.IsoId=Parameter.Category.IsoId INNER JOIN
						 Language.[Parameter.Category] with (nolock)  On Language.[Parameter.Category].CategoryId=Parameter.Category.CategoryId and  Language.[Parameter.Category].LanguageId=@LangId  INNER JOIN
						 Language.[Parameter.Sport] with (nolock)  ON  Language.[Parameter.Sport].SportId= Parameter.Sport.SportId and Language.[Parameter.Sport].LanguageId=@LangId
						Where  Programme.SportId=@SportId
						-- and 		 cast(Programme.MatchDate as date)< case when Parameter.Tournament.IsPopularWeb=0 then cast(@EventDate as date) else  cast('20240901' as date) end and ((CAST(Programme.MatchDate AS Date)>=(CAST(@StartDate AS Date))))
			  and  Programme.MatchDate>GETDATE() and Parameter.Sport.IsActive=1 and   cast(DATEADD(HOUR,2,Programme.MatchDate) as date)<@EndDate
			order by Parameter.Tournament.SequenceNumber,Parameter.Tournament.TournamentId
end



	end
 
else  if (@SportId=-15) -- Fixture Top Event
	begin
  
		SELECT  top 200   Programme.BetradarMatchId,Programme.MatchId, Programme.MatchDate,Language.[Parameter.Tournament].TournamentName,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetitor_1.CompetitorName AS EventName, 
                    Language.[Parameter.Sport].SportName,Programme.TournamentId,Programme.SportId,Parameter.Category.CategoryId,Parameter.Sport.SportName as SportNameOrginal
					,(Select COUNT(DISTINCT Match.Odd.OddsTypeId) from Match.Odd with (nolock) INNER JOIN Parameter.OddsType PO with (nolock) ON Match.Odd.OddsTypeId=PO.OddsTypeId and PO.IsActive=1 where MatchId=CFF.MatchId and Match.Odd.StateId=2) as OddTypeCount , 
                     Programme.MatchDate as TournamentDate,case when (select COUNT(*) from Live.[EventDetail] with (nolock) where BetradarMatchIds=Programme.BetradarMatchId)>0 then cast(1 as bit) else cast(0 as bit) end as NeutralGround
					,null as HasStreaming,
					Language.[Parameter.Category].CategoryName
					, ISNULL(Parameter.Tournament.SequenceNumber,999) as SequenceNumber,  SUBSTRING(LOWER(Parameter.Iso.IsoName2), 0, 3) AS IsoName
					,Parameter.Tournament.NewBetradarId as BetradarTournamentId
					  ,Parameter.Competitor.BetradarSuperId as HomeTeamId
							   ,Competitor_1.BetradarSuperId as AwayTeamId
FROM         Parameter.Competitor AS Competitor_1 with (nolock) INNER JOIN
                      Parameter.Competitor with (nolock)  INNER JOIN
                      Language.ParameterCompetitor with (nolock) ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangComp INNER JOIN
                      Cache.Programme2 as Programme with (nolock) ON Parameter.Competitor.CompetitorId = Programme.[HomeTeam ] ON Competitor_1.CompetitorId = Programme.[AwayTeam ] INNER JOIN
					  Cache.Fixture as CFF with (nolock) ON CFF.MatchId=Programme.MatchId Inner JOIN
                      Language.ParameterCompetitor AS ParameterCompetitor_1 with (nolock) ON Competitor_1.CompetitorId = ParameterCompetitor_1.CompetitorId and ParameterCompetitor_1.LanguageId=@LangComp INNER JOIN 
						 Language.[Parameter.Tournament] with (nolock)  ON Language.[Parameter.Tournament].TournamentId=Programme.TournamentId and Language.[Parameter.Tournament].LanguageId=@LangId INNER JOIN
						 Parameter.Tournament with (nolock)  On Parameter.Tournament.TournamentId=Programme.TournamentId INNER JOIN
						 Parameter.Category with (nolock)  On Parameter.Category.CategoryId=Parameter.Tournament.CategoryId INNER JOIN
						 Parameter.Sport  with (nolock) on Parameter.Sport.SportId=Programme.SportId INNER JOIN
						 Parameter.Iso ON Parameter.Iso.IsoId=Parameter.Category.IsoId INNER JOIN
						 Language.[Parameter.Category] with (nolock)  On Language.[Parameter.Category].CategoryId=Parameter.Category.CategoryId and  Language.[Parameter.Category].LanguageId=@LangId INNER JOIN
						 Cache.Fixture with (nolock)  ON Cache.Fixture.BetradarMatchId=Programme.BetradarMatchId INNER JOIN
						 Language.[Parameter.Sport] with (nolock)  ON  Language.[Parameter.Sport].SportId= Parameter.Sport.SportId and Language.[Parameter.Sport].LanguageId=@LangId  
						 where  Programme.MatchDate> GETDATE()
						-- and  cast(Programme.MatchDate as date)< case when Parameter.Tournament.IsPopularWeb=0 then cast(@EventDate as date) else  cast('20240901' as date) end
						 and Parameter.Sport.IsActive=1 and Parameter.Sport.SportId=@CategoryId
						 	order by Parameter.Tournament.SequenceNumber--,Parameter.Tournament.TournamentId
	end
else  
	begin



	declare @Endatee nvarchar(50) 

set @Endatee=cast(Cast(DATEADD(DAY,1,GETDATE()) as date) as nvarchar(10))+' 00:00:00.000'


		SELECT   Programme.BetradarMatchId,Programme.MatchId, Programme.MatchDate,Language.[Parameter.Tournament].TournamentName,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetitor_1.CompetitorName AS EventName, 
                    Language.[Parameter.Sport].SportName,Programme.TournamentId,Programme.SportId,Parameter.Category.CategoryId,Parameter.Sport.SportName as SportNameOrginal
					,(Select COUNT(DISTINCT Match.Odd.OddsTypeId) from Match.Odd with (nolock) INNER JOIN Parameter.OddsType PO with (nolock) ON Match.Odd.OddsTypeId=PO.OddsTypeId and PO.IsActive=1 where MatchId=CFF.MatchId and Match.Odd.StateId=2) as OddTypeCount, 
                     Programme.MatchDate as TournamentDate,cast(1 as bit)  as NeutralGround
					,null as HasStreaming,
					Language.[Parameter.Category].CategoryName
					,Parameter.Tournament.SequenceNumber,  SUBSTRING(LOWER(Parameter.Iso.IsoName2), 0, 3) AS IsoName
					,Parameter.Tournament.NewBetradarId as BetradarTournamentId
					  ,Parameter.Competitor.BetradarSuperId as HomeTeamId
							   ,Competitor_1.BetradarSuperId as AwayTeamId
FROM         Parameter.Competitor AS Competitor_1 with (nolock) INNER JOIN
                      Parameter.Competitor with (nolock)  INNER JOIN
                      Language.ParameterCompetitor with (nolock) ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangComp INNER JOIN
                      Cache.Programme2 as Programme with (nolock) ON Parameter.Competitor.CompetitorId = Programme.[HomeTeam ] ON Competitor_1.CompetitorId = Programme.[AwayTeam ] INNER JOIN
					  Cache.Fixture as CFF with (nolock) ON CFF.MatchId=Programme.MatchId Inner JOIN
					    Language.ParameterCompetitor AS ParameterCompetitor_1 with (nolock) ON Competitor_1.CompetitorId = ParameterCompetitor_1.CompetitorId and ParameterCompetitor_1.LanguageId=@LangComp  INNER JOIN 
						 Language.[Parameter.Tournament]  with (nolock) ON Language.[Parameter.Tournament].TournamentId=Programme.TournamentId and Language.[Parameter.Tournament].LanguageId=@LangId INNER JOIN
						 Parameter.Tournament with (nolock)  On Parameter.Tournament.TournamentId=Programme.TournamentId INNER JOIN
						 Parameter.Category  with (nolock) On Parameter.Category.CategoryId=Parameter.Tournament.CategoryId INNER JOIN
						 Parameter.Sport with (nolock)  on Parameter.Sport.SportId=Programme.SportId INNER JOIN
						 Parameter.Iso ON Parameter.Iso.IsoId=Parameter.Category.IsoId INNER JOIN
						 Language.[Parameter.Category] with (nolock)  On Language.[Parameter.Category].CategoryId=Parameter.Category.CategoryId and  Language.[Parameter.Category].LanguageId=@LangId and Parameter.Sport.IsActive=1 INNER JOIN
						 Language.[Parameter.Sport]  with (nolock) ON  Language.[Parameter.Sport].SportId= Parameter.Sport.SportId and Language.[Parameter.Sport].LanguageId=@LangId  
						 where  Programme.MatchDate>GETDATE()
						 --case when (Select Count(*) from Live.Event with (nolock) where BetradarMatchId=Programme.BetradarMatchId)>0 
						 --then DATEADD(MINUTE,10, GETDATE()) 
						 --else DATEADD(MINUTE,5, GETDATE()) end  
						 and Programme.MatchDate<DATEADD(HOUR,9,@Endatee) --and Parameter.Sport.SportId not in (21,17,31)
					 order by Parameter.Tournament.SequenceNumber

	end

end

END




GO
