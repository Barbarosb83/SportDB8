USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcFixture]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [GamePlatform].[ProcFixture] 
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

	 	SELECT     Programme.BetradarMatchId,Programme.MatchId, Programme.MatchDate,Language.[Parameter.Tournament].TournamentName,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetitor_1.CompetitorName AS EventName, 
                    Language.[Parameter.Sport].SportName,Programme.TournamentId,Programme.SportId,Parameter.Category.CategoryId,Parameter.Sport.SportName as SportNameOrginal
					,    (SELECT     COUNT(DISTINCT Match.Odd.OddsTypeId)
                                        FROM          Match.Odd with (nolock)
                                                      WHERE      (MatchId = Programme.MatchId) AND (StateId = 2)) as OddTypeCount, 
                     Programme.MatchDate as TournamentDate
					,case when (select COUNT(*) from Live.[EventDetail] with (nolock) where BetradarMatchIds=Programme.BetradarMatchId)>0 then cast(1 as bit) else cast(0 as bit) end as NeutralGround
					,null AS HasStreaming,
					Language.[Parameter.Category].CategoryName
					,Parameter.Tournament.SequenceNumber,  SUBSTRING(LOWER(Parameter.Iso.IsoName2), 0, 3) AS IsoName
					,Parameter.Tournament.NewBetradarId as BetradarTournamentId
					,Programme.OddId1,Programme.OddValue1
					,Programme.OddId2,Programme.OddValue2
					,Programme.OddId3,Programme.OddValue3

					,  Programme.OddSpecialBetValueHadicap01_1  as OddSpecialBetValueHadicap01_1
					,Programme.OddIdHadicap01_1 as OddIdHadicap01_1
					,  Programme.OddValueHadicap01_1   as OddValueHadicap01_1
					, Programme.OddIdHadicap01_X  as OddIdHadicap01_X
					,  Programme.OddValueHadicap01_X  as OddValueHadicap01_X
					, Programme.OddIdHadicap01_2 as OddIdHadicap01_2 
					,  Programme.OddValueHadicap01_2 as OddValueHadicap01_2

					,Programme.OddSpecialBetValueHadicap02_1,Programme.OddIdHadicap02_1,Programme.OddValueHadicap02_1
					,Programme.OddIdHadicap02_X,Programme.OddValueHadicap02_X
					,Programme.OddIdHadicap02_2,Programme.OddValueHadicap02_2


					,Programme.OddSpecialBetValueHadicap10_1,Programme.OddIdHadicap10_1,Programme.OddValueHadicap10_1
					,Programme.OddIdHadicap10_X,Programme.OddValueHadicap10_X
					,Programme.OddIdHadicap10_2,Programme.OddValueHadicap10_2

					,Programme.OddSpecialBetValueHadicap20_1,Programme.OddIdHadicap20_1,Programme.OddValueHadicap20_1
					,Programme.OddIdHadicap20_X,Programme.OddValueHadicap20_X
					,Programme.OddIdHadicap20_2,Programme.OddValueHadicap20_2


					
					,case when Programme.SportId in (4,1) then Programme.OddSpecialBetValueTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddSpecialBetValueTotalSpread_O else Programme.OddSpecialBetValueTennisTotal_O end  end as OddSpecialBetValueTotals_O1_5
					,case when Programme.SportId in (4,1) then   Programme.OddIdTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddIdTotalSpread_O else  Programme.OddIdTennisTotal_O end end  as OddIdTotals_O1_5
					,case when Programme.SportId in (4,1) then   Programme.OddValueTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddValueTotalSpread_O else Programme.OddValueTennisTotal_O end end as OddValueTotals_O1_5
					,case when Programme.SportId in (4,1) then    Programme.OddIdTotals_U1_5 
					 else case when Programme.SportId not in (5,20) then  Programme.OddIdTotalSpread_U else Programme.OddIdTennisTotal_U end end as OddIdTotals_U1_5
					,case when Programme.SportId in (4,1) then  Programme.OddValueTotals_U1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddValueTotalSpread_U else Programme.OddValueTennisTotal_U end end as OddValueTotals_U1_5

					,case when Programme.SportId=2 then Programme.OddSpecialBetValueDartFirstSet_1 else OddSpecialBetValueTotals_O2_5 end   as OddSpecialBetValueTotals_O2_5  -- Basket Home OVer/Under
					,case when Programme.SportId=2 then Programme.OddIdDartFirstSet_1 else Programme.OddIdTotals_O2_5 end  as OddIdTotals_O2_5
					,case when Programme.SportId=2 then Programme.OddValueDartFirstSet_1 else Programme.OddValueTotals_O2_5  end as OddValueTotals_O2_5
					,case when Programme.SportId=2 then Programme.OddIdDartFirstSet_2  else Programme.OddIdTotals_U2_5 end as OddIdTotals_U2_5
					,case when Programme.SportId=2 then Programme.OddValueDartFirstSet_2 else Programme.OddValueTotals_U2_5  end as OddValueTotals_U2_5


						,case when Programme.SportId=2 then Programme.OddSpecialBetValueDrawNoBet_1 else OddSpecialBetValueTotals_O3_5 end   as  OddSpecialBetValueTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddIdDrawNoBet_1 else Programme.OddIdTotals_O3_5 end    as OddIdTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddValueDrawNoBet_1 else Programme.OddValueTotals_O3_5  end  as OddValueTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddIdDrawNoBet_2  else Programme.OddIdTotals_U3_5 end as OddIdTotals_U3_5
					,case when Programme.SportId=2 then Programme.OddValueDrawNoBet_2 else Programme.OddValueTotals_U3_5  end as OddValueTotals_U3_5

					,Programme.OddSpecialBetValueTotals_O4_5
					,Programme.OddIdTotals_O4_5,Programme.OddValueTotals_O4_5
					,Programme.OddIdTotals_U4_5,Programme.OddValueTotals_U4_5


					,Programme.OddIdDouble_1 as OddIdDouble_1X,Programme.OddValueDouble_1 as OddValueDouble_1X
					,Programme.OddIdDouble_X as OddIdDouble_X2,Programme.OddValueDouble_X as OddValueDouble_X2
					,Programme.OddIdDouble_2 as OddIdDouble_12,Programme.OddValueDouble_2 as OddValueDouble_12

					,Programme.OddIdBoth_Y ,Programme.OddValueBoth_Y
					,Programme.OddIdBoth_N ,Programme.OddValueBoth_N

					,  Programme.OddIdFirstScore_1 as OddIdFirstScore_1 
					,  Programme.OddValueFirstScore_1  as OddValueFirstScore_1 
					,  Programme.OddIdFirstScore_None  as OddIdFirstScore_None 
					, Programme.OddValueFirstScore_None  as OddValueFirstScore_None 
							, Programme.OddIdFirstScore_2  as OddIdFirstScore_2 
					,  Programme.OddValueFirstScore_2   as OddValueFirstScore_2 

					,Programme.OddIdFirstHalf_1 ,Programme.OddValueFirstHalf_1
					,Programme.OddIdFirstHalf_X ,Programme.OddValueFirstHalf_X
					,Programme.OddIdFirstHalf_2 ,Programme.OddValueFirstHalf_2
					
					,Programme.OddSpecialBetValueFirstHalfTotalsO_0_5
					,Programme.OddIdFirstHalfTotalsO_0_5,Programme.OddValueFirstHalfTotalsO_0_5  
					,Programme.OddIdFirstHalfTotalsU_0_5,Programme.OddValueFirstHalfTotalsU_0_5

					,Programme.OddSpecialBetValueFirstHalfTotalsO_1_5
					,Programme.OddIdFirstHalfTotalsO_1_5,Programme.OddValueFirstHalfTotalsO_1_5  
					,Programme.OddIdFirstHalfTotalsU_1_5,Programme.OddValueFirstHalfTotalsU_1_5

					 ,Programme.OutComeTennisScore_20 as OddSpecialBetValueTennisScore_20
					 ,Programme.OddIdTennisScore_20,Programme.OddValueTennisScore_20

					 ,Programme.OutComeTennisScore_02 as OddSpecialBetValueTennisScore_02
					 ,Programme.OddIdTennisScore_02,Programme.OddValueTennisScore_02

					  ,Programme.OutComeTennisScore_12 as OddSpecialBetValueTennisScore_12
					 ,Programme.OddIdTennisScore_12,Programme.OddValueTennisScore_12

					   ,Programme.OutComeTennisScore_21 as OddSpecialBetValueTennisScore_21
					 ,Programme.OddIdTennisScore_21,Programme.OddValueTennisScore_21

					    ,Programme.OddSpecialBetValueTennisTotal_O as OddSpecialBetValueTennisTotal
					 ,Programme.OddIdTennisTotal_O,Programme.OddValueTennisTotal_O
					 ,Programme.OddIdTennisTotal_U,Programme.OddValueTennisTotal_U

					    ,Programme.OddSpecialBetValueTotalSpread_O as OddSpecialBetValueBasketTotal
					 ,Programme.OddIdTotalSpread_O,Programme.OddValueTotalSpread_O
					 ,Programme.OddIdTotalSpread_U,Programme.OddValueTotalSpread_U

					 ,Programme.OddIdBasketFirstHalf_1 ,Programme.OddValueBasketFirstHalf_1
					,Programme.OddIdBasketFirstHalf_X ,Programme.OddValueBasketFirstHalf_x
					,Programme.OddIdBasketFirstHalf_2 ,Programme.OddValueBasketFirstHalf_2

						,Programme.OddIdTennisFirstSet_1,Programme.OddValueTennisFirstSet_1
					,Programme.OddIdTennisFirstSet_2,Programme.OddValueTennisFirstSet_2 
	 ,Parameter.Competitor.BetradarSuperId as HomeTeamId
	,Competitor_1.BetradarSuperId as Away
FROM         Parameter.Competitor AS Competitor_1 with (nolock) INNER JOIN
                      Parameter.Competitor with (nolock) INNER JOIN
                      Language.ParameterCompetitor with (nolock) ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangComp INNER JOIN
                      Cache.Programme as Programme with (nolock) ON Parameter.Competitor.CompetitorId = Programme.[HomeTeam ] ON Competitor_1.CompetitorId = Programme.[AwayTeam ] INNER JOIN
                      Language.ParameterCompetitor AS ParameterCompetitor_1 with (nolock) ON Competitor_1.CompetitorId = ParameterCompetitor_1.CompetitorId and ParameterCompetitor_1.LanguageId=@LangComp LEFT OUTER JOIN
                         --Live.EventLiveStreaming with (nolock) ON Programme.BetradarMatchId = Live.EventLiveStreaming.BetradarMatchId INNER JOIN 
						 Language.[Parameter.Tournament] with (nolock)  ON Language.[Parameter.Tournament].TournamentId=Programme.TournamentId and Language.[Parameter.Tournament].LanguageId=@LangId INNER JOIN 
						 Parameter.Tournament with (nolock) On Parameter.Tournament.TournamentId=Programme.TournamentId INNER JOIN
						 Parameter.Category with (nolock) On Parameter.Category.CategoryId=Parameter.Tournament.CategoryId INNER JOIN
						 Parameter.Sport with (nolock) on Parameter.Sport.SportId=Programme.SportId INNER JOIN
						  Parameter.Iso ON Parameter.Iso.IsoId=Parameter.Category.IsoId INNER JOIN
						 Language.[Parameter.Category] with (nolock) On Language.[Parameter.Category].CategoryId=Parameter.Category.CategoryId and  Language.[Parameter.Category].LanguageId=@LangId INNER JOIN
						 Language.[Parameter.Sport]  with (nolock)ON  Language.[Parameter.Sport].SportId= Parameter.Sport.SportId and Language.[Parameter.Sport].LanguageId=@LangId  
						 where Programme.SportId=@SportId and Programme.TournamentId=@TournamentId and Programme.MatchDate>GETDATE() 
						 and Programme.MatchDate<=case when @TournamentId not in (16,31204,28963,3793,80,2767,834) then @EventDate  else  cast('20220901' as date) end 
						 and Parameter.Sport.IsActive=1
		end
else if (@TournamentId<0)
	begin

	 	SELECT     Programme.BetradarMatchId,Programme.MatchId, Programme.MatchDate,Language.[Parameter.Tournament].TournamentName,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetitor_1.CompetitorName AS EventName, 
                    Language.[Parameter.Sport].SportName,Programme.TournamentId,Programme.SportId,Parameter.Category.CategoryId,Parameter.Sport.SportName as SportNameOrginal
					,    (SELECT     COUNT(DISTINCT Match.Odd.OddsTypeId)
                                        FROM          Match.Odd with (nolock)
                                                      WHERE      (MatchId = Programme.MatchId) AND (StateId = 2)) as OddTypeCount, 
                     Programme.MatchDate as TournamentDate
					,case when (select COUNT(*) from Live.[EventDetail] with (nolock) where BetradarMatchIds=Programme.BetradarMatchId)>0 then cast(1 as bit) else cast(0 as bit) end as NeutralGround
					,null AS HasStreaming,
					Language.[Parameter.Category].CategoryName
					,Parameter.Tournament.SequenceNumber,  SUBSTRING(LOWER(Parameter.Iso.IsoName2), 0, 3) AS IsoName
					,Parameter.Tournament.NewBetradarId as BetradarTournamentId
					,Programme.OddId1,Programme.OddValue1
					,Programme.OddId2,Programme.OddValue2
					,Programme.OddId3,Programme.OddValue3

					,  Programme.OddSpecialBetValueHadicap01_1  as OddSpecialBetValueHadicap01_1
					,Programme.OddIdHadicap01_1 as OddIdHadicap01_1
					,  Programme.OddValueHadicap01_1   as OddValueHadicap01_1
					, Programme.OddIdHadicap01_X  as OddIdHadicap01_X
					,  Programme.OddValueHadicap01_X  as OddValueHadicap01_X
					, Programme.OddIdHadicap01_2 as OddIdHadicap01_2 
					,  Programme.OddValueHadicap01_2 as OddValueHadicap01_2

					,Programme.OddSpecialBetValueHadicap02_1,Programme.OddIdHadicap02_1,Programme.OddValueHadicap02_1
					,Programme.OddIdHadicap02_X,Programme.OddValueHadicap02_X
					,Programme.OddIdHadicap02_2,Programme.OddValueHadicap02_2


					,Programme.OddSpecialBetValueHadicap10_1,Programme.OddIdHadicap10_1,Programme.OddValueHadicap10_1
					,Programme.OddIdHadicap10_X,Programme.OddValueHadicap10_X
					,Programme.OddIdHadicap10_2,Programme.OddValueHadicap10_2

					,Programme.OddSpecialBetValueHadicap20_1,Programme.OddIdHadicap20_1,Programme.OddValueHadicap20_1
					,Programme.OddIdHadicap20_X,Programme.OddValueHadicap20_X
					,Programme.OddIdHadicap20_2,Programme.OddValueHadicap20_2


					
					,case when Programme.SportId in (4,1) then Programme.OddSpecialBetValueTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddSpecialBetValueTotalSpread_O else Programme.OddSpecialBetValueTennisTotal_O end  end as OddSpecialBetValueTotals_O1_5
					,case when Programme.SportId in (4,1) then   Programme.OddIdTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddIdTotalSpread_O else  Programme.OddIdTennisTotal_O end end  as OddIdTotals_O1_5
					,case when Programme.SportId in (4,1) then   Programme.OddValueTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddValueTotalSpread_O else Programme.OddValueTennisTotal_O end end as OddValueTotals_O1_5
					,case when Programme.SportId in (4,1) then    Programme.OddIdTotals_U1_5 
					 else case when Programme.SportId not in (5,20) then  Programme.OddIdTotalSpread_U else Programme.OddIdTennisTotal_U end end as OddIdTotals_U1_5
					,case when Programme.SportId in (4,1) then  Programme.OddValueTotals_U1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddValueTotalSpread_U else Programme.OddValueTennisTotal_U end end as OddValueTotals_U1_5

					,case when Programme.SportId=2 then Programme.OddSpecialBetValueDartFirstSet_1 else OddSpecialBetValueTotals_O2_5 end   as OddSpecialBetValueTotals_O2_5  -- Basket Home OVer/Under
					,case when Programme.SportId=2 then Programme.OddIdDartFirstSet_1 else Programme.OddIdTotals_O2_5 end  as OddIdTotals_O2_5
					,case when Programme.SportId=2 then Programme.OddValueDartFirstSet_1 else Programme.OddValueTotals_O2_5  end as OddValueTotals_O2_5
					,case when Programme.SportId=2 then Programme.OddIdDartFirstSet_2  else Programme.OddIdTotals_U2_5 end as OddIdTotals_U2_5
					,case when Programme.SportId=2 then Programme.OddValueDartFirstSet_2 else Programme.OddValueTotals_U2_5  end as OddValueTotals_U2_5


						,case when Programme.SportId=2 then Programme.OddSpecialBetValueDrawNoBet_1 else OddSpecialBetValueTotals_O3_5 end   as  OddSpecialBetValueTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddIdDrawNoBet_1 else Programme.OddIdTotals_O3_5 end    as OddIdTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddValueDrawNoBet_1 else Programme.OddValueTotals_O3_5  end  as OddValueTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddIdDrawNoBet_2  else Programme.OddIdTotals_U3_5 end as OddIdTotals_U3_5
					,case when Programme.SportId=2 then Programme.OddValueDrawNoBet_2 else Programme.OddValueTotals_U3_5  end as OddValueTotals_U3_5

					,Programme.OddSpecialBetValueTotals_O4_5
					,Programme.OddIdTotals_O4_5,Programme.OddValueTotals_O4_5
					,Programme.OddIdTotals_U4_5,Programme.OddValueTotals_U4_5


					,Programme.OddIdDouble_1 as OddIdDouble_1X,Programme.OddValueDouble_1 as OddValueDouble_1X
					,Programme.OddIdDouble_X as OddIdDouble_X2,Programme.OddValueDouble_X as OddValueDouble_X2
					,Programme.OddIdDouble_2 as OddIdDouble_12,Programme.OddValueDouble_2 as OddValueDouble_12

					,Programme.OddIdBoth_Y ,Programme.OddValueBoth_Y
					,Programme.OddIdBoth_N ,Programme.OddValueBoth_N

					,  Programme.OddIdFirstScore_1 as OddIdFirstScore_1 
					,  Programme.OddValueFirstScore_1  as OddValueFirstScore_1 
					,  Programme.OddIdFirstScore_None  as OddIdFirstScore_None 
					, Programme.OddValueFirstScore_None  as OddValueFirstScore_None 
							, Programme.OddIdFirstScore_2  as OddIdFirstScore_2 
					,  Programme.OddValueFirstScore_2   as OddValueFirstScore_2 

					,Programme.OddIdFirstHalf_1 ,Programme.OddValueFirstHalf_1
					,Programme.OddIdFirstHalf_X ,Programme.OddValueFirstHalf_X
					,Programme.OddIdFirstHalf_2 ,Programme.OddValueFirstHalf_2
					
					,Programme.OddSpecialBetValueFirstHalfTotalsO_0_5
					,Programme.OddIdFirstHalfTotalsO_0_5,Programme.OddValueFirstHalfTotalsO_0_5  
					,Programme.OddIdFirstHalfTotalsU_0_5,Programme.OddValueFirstHalfTotalsU_0_5

					,Programme.OddSpecialBetValueFirstHalfTotalsO_1_5
					,Programme.OddIdFirstHalfTotalsO_1_5,Programme.OddValueFirstHalfTotalsO_1_5  
					,Programme.OddIdFirstHalfTotalsU_1_5,Programme.OddValueFirstHalfTotalsU_1_5

					 ,Programme.OutComeTennisScore_20 as OddSpecialBetValueTennisScore_20
					 ,Programme.OddIdTennisScore_20,Programme.OddValueTennisScore_20

					 ,Programme.OutComeTennisScore_02 as OddSpecialBetValueTennisScore_02
					 ,Programme.OddIdTennisScore_02,Programme.OddValueTennisScore_02

					  ,Programme.OutComeTennisScore_12 as OddSpecialBetValueTennisScore_12
					 ,Programme.OddIdTennisScore_12,Programme.OddValueTennisScore_12

					   ,Programme.OutComeTennisScore_21 as OddSpecialBetValueTennisScore_21
					 ,Programme.OddIdTennisScore_21,Programme.OddValueTennisScore_21

					    ,Programme.OddSpecialBetValueTennisTotal_O as OddSpecialBetValueTennisTotal
					 ,Programme.OddIdTennisTotal_O,Programme.OddValueTennisTotal_O
					 ,Programme.OddIdTennisTotal_U,Programme.OddValueTennisTotal_U

					    ,Programme.OddSpecialBetValueTotalSpread_O as OddSpecialBetValueBasketTotal
					 ,Programme.OddIdTotalSpread_O,Programme.OddValueTotalSpread_O
					 ,Programme.OddIdTotalSpread_U,Programme.OddValueTotalSpread_U

					 ,Programme.OddIdBasketFirstHalf_1 ,Programme.OddValueBasketFirstHalf_1
					,Programme.OddIdBasketFirstHalf_X ,Programme.OddValueBasketFirstHalf_x
					,Programme.OddIdBasketFirstHalf_2 ,Programme.OddValueBasketFirstHalf_2

						,Programme.OddIdTennisFirstSet_1,Programme.OddValueTennisFirstSet_1
					,Programme.OddIdTennisFirstSet_2,Programme.OddValueTennisFirstSet_2 
	,Parameter.Competitor.BetradarSuperId as HomeTeamId
	,Competitor_1.BetradarSuperId as Away
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
						 where Programme.MatchId=@SportId and Programme.MatchDate>GETDATE() 
						  
		end
else if (@CategoryId>0  and @SportId>=0)
	begin
		SELECT     Programme.BetradarMatchId,Programme.MatchId, Programme.MatchDate,Language.[Parameter.Tournament].TournamentName,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetitor_1.CompetitorName AS EventName, 
                    Language.[Parameter.Sport].SportName,Programme.TournamentId,Programme.SportId,Parameter.Category.CategoryId,Parameter.Sport.SportName as SportNameOrginal
					,(SELECT     COUNT(DISTINCT OddsTypeId)
                                        FROM          Match.Odd with (nolock)
                                                      WHERE      (Match.Odd.MatchId = Programme.MatchId) AND (Match.Odd.StateId = 2) and Match.Odd.OddValue>1) as OddTypeCount , 
                   Programme.MatchDate as TournamentDate,case when (select COUNT(*) from Live.[EventDetail] with (nolock) where BetradarMatchIds=Programme.BetradarMatchId)>0 then cast(1 as bit) else cast(0 as bit) end as NeutralGround
					,null as HasStreaming,
					Language.[Parameter.Category].CategoryName
					,Parameter.Tournament.SequenceNumber,  SUBSTRING(LOWER(Parameter.Iso.IsoName2), 0, 3) AS IsoName
					,Parameter.Tournament.NewBetradarId as BetradarTournamentId
					,Programme.OddId1,CFF.OddValue1
					,Programme.OddId2,CFF.OddValue2
					,Programme.OddId3,CFF.OddValue3


						,  Programme.OddSpecialBetValueHadicap01_1  as OddSpecialBetValueHadicap01_1
					,Programme.OddIdHadicap01_1 as OddIdHadicap01_1
					,  Programme.OddValueHadicap01_1   as OddValueHadicap01_1
					, Programme.OddIdHadicap01_X  as OddIdHadicap01_X
					,  Programme.OddValueHadicap01_X  as OddValueHadicap01_X
					, Programme.OddIdHadicap01_2 as OddIdHadicap01_2 
					,  Programme.OddValueHadicap01_2 as OddValueHadicap01_2

					,Programme.OddSpecialBetValueHadicap02_1,Programme.OddIdHadicap02_1,Programme.OddValueHadicap02_1
					,Programme.OddIdHadicap02_X,Programme.OddValueHadicap02_X
					,Programme.OddIdHadicap02_2,Programme.OddValueHadicap02_2


					,Programme.OddSpecialBetValueHadicap10_1,Programme.OddIdHadicap10_1,Programme.OddValueHadicap10_1
					,Programme.OddIdHadicap10_X,Programme.OddValueHadicap10_X
					,Programme.OddIdHadicap10_2,Programme.OddValueHadicap10_2

					,Programme.OddSpecialBetValueHadicap20_1,Programme.OddIdHadicap20_1,Programme.OddValueHadicap20_1
					,Programme.OddIdHadicap20_X,Programme.OddValueHadicap20_X
					,Programme.OddIdHadicap20_2,Programme.OddValueHadicap20_2


					
						,case when Programme.SportId in (4,1) then Programme.OddSpecialBetValueTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddSpecialBetValueTotalSpread_O else Programme.OddSpecialBetValueTennisTotal_O end  end as OddSpecialBetValueTotals_O1_5
					,case when Programme.SportId in (4,1) then   Programme.OddIdTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddIdTotalSpread_O else  Programme.OddIdTennisTotal_O end end  as OddIdTotals_O1_5
					,case when Programme.SportId in (4,1) then   Programme.OddValueTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddValueTotalSpread_O else Programme.OddValueTennisTotal_O end end as OddValueTotals_O1_5
					,case when Programme.SportId in (4,1) then    Programme.OddIdTotals_U1_5 
					 else case when Programme.SportId not in (5,20) then  Programme.OddIdTotalSpread_U else Programme.OddIdTennisTotal_U end end as OddIdTotals_U1_5
					,case when Programme.SportId in (4,1) then  Programme.OddValueTotals_U1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddValueTotalSpread_U else Programme.OddValueTennisTotal_U end end as OddValueTotals_U1_5

					,case when Programme.SportId=2 then Programme.OddSpecialBetValueDartFirstSet_1 else OddSpecialBetValueTotals_O2_5 end   as OddSpecialBetValueTotals_O2_5  -- Basket Home OVer/Under
					,case when Programme.SportId=2 then Programme.OddIdDartFirstSet_1 else Programme.OddIdTotals_O2_5 end  as OddIdTotals_O2_5
					,case when Programme.SportId=2 then Programme.OddValueDartFirstSet_1 else Programme.OddValueTotals_O2_5  end as OddValueTotals_O2_5
					,case when Programme.SportId=2 then Programme.OddIdDartFirstSet_2  else Programme.OddIdTotals_U2_5 end as OddIdTotals_U2_5
					,case when Programme.SportId=2 then Programme.OddValueDartFirstSet_2 else Programme.OddValueTotals_U2_5  end as OddValueTotals_U2_5


						,case when Programme.SportId=2 then Programme.OddSpecialBetValueDrawNoBet_1 else OddSpecialBetValueTotals_O3_5 end   as  OddSpecialBetValueTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddIdDrawNoBet_1 else Programme.OddIdTotals_O3_5 end    as OddIdTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddValueDrawNoBet_1 else Programme.OddValueTotals_O3_5  end  as OddValueTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddIdDrawNoBet_2  else Programme.OddIdTotals_U3_5 end as OddIdTotals_U3_5
					,case when Programme.SportId=2 then Programme.OddValueDrawNoBet_2 else Programme.OddValueTotals_U3_5  end as OddValueTotals_U3_5

					,Programme.OddSpecialBetValueTotals_O4_5
					,Programme.OddIdTotals_O4_5,Programme.OddValueTotals_O4_5
					,Programme.OddIdTotals_U4_5,Programme.OddValueTotals_U4_5



					,Programme.OddIdDouble_1 as OddIdDouble_1X,Programme.OddValueDouble_1 as OddValueDouble_1X
					,Programme.OddIdDouble_X as OddIdDouble_X2,Programme.OddValueDouble_X as OddValueDouble_X2
					,Programme.OddIdDouble_2 as OddIdDouble_12,Programme.OddValueDouble_2 as OddValueDouble_12

					,Programme.OddIdBoth_Y ,Programme.OddValueBoth_Y
					,Programme.OddIdBoth_N ,Programme.OddValueBoth_N

					,  Programme.OddIdFirstScore_1 as OddIdFirstScore_1 
					,  Programme.OddValueFirstScore_1  as OddValueFirstScore_1 
					,  Programme.OddIdFirstScore_None  as OddIdFirstScore_None 
					, Programme.OddValueFirstScore_None  as OddValueFirstScore_None 
							, Programme.OddIdFirstScore_2  as OddIdFirstScore_2 
					,  Programme.OddValueFirstScore_2   as OddValueFirstScore_2 

					,Programme.OddIdFirstHalf_1 ,Programme.OddValueFirstHalf_1
					,Programme.OddIdFirstHalf_X ,Programme.OddValueFirstHalf_X
					,Programme.OddIdFirstHalf_2 ,Programme.OddValueFirstHalf_2
					
					,Programme.OddSpecialBetValueFirstHalfTotalsO_0_5
					,Programme.OddIdFirstHalfTotalsO_0_5,Programme.OddValueFirstHalfTotalsO_0_5  
					,Programme.OddIdFirstHalfTotalsU_0_5,Programme.OddValueFirstHalfTotalsU_0_5

					,Programme.OddSpecialBetValueFirstHalfTotalsO_1_5
					,Programme.OddIdFirstHalfTotalsO_1_5,Programme.OddValueFirstHalfTotalsO_1_5  
					,Programme.OddIdFirstHalfTotalsU_1_5,Programme.OddValueFirstHalfTotalsU_1_5

					 ,Programme.OutComeTennisScore_20 as OddSpecialBetValueTennisScore_20
					 ,Programme.OddIdTennisScore_20,Programme.OddValueTennisScore_20

					 ,Programme.OutComeTennisScore_02 as OddSpecialBetValueTennisScore_02
					 ,Programme.OddIdTennisScore_02,Programme.OddValueTennisScore_02

					  ,Programme.OutComeTennisScore_12 as OddSpecialBetValueTennisScore_12
					 ,Programme.OddIdTennisScore_12,Programme.OddValueTennisScore_12

					   ,Programme.OutComeTennisScore_21 as OddSpecialBetValueTennisScore_21
					 ,Programme.OddIdTennisScore_21,Programme.OddValueTennisScore_21

					    ,Programme.OddSpecialBetValueTennisTotal_O as OddSpecialBetValueTennisTotal
					 ,Programme.OddIdTennisTotal_O,Programme.OddValueTennisTotal_O
					 ,Programme.OddIdTennisTotal_U,Programme.OddValueTennisTotal_U

					    ,Programme.OddSpecialBetValueTotalSpread_O as OddSpecialBetValueBasketTotal
					 ,Programme.OddIdTotalSpread_O,Programme.OddValueTotalSpread_O
					 ,Programme.OddIdTotalSpread_U,Programme.OddValueTotalSpread_U

					 ,Programme.OddIdBasketFirstHalf_1 ,Programme.OddValueBasketFirstHalf_1
					,Programme.OddIdBasketFirstHalf_X ,Programme.OddValueBasketFirstHalf_x
					,Programme.OddIdBasketFirstHalf_2 ,Programme.OddValueBasketFirstHalf_2

						,Programme.OddIdTennisFirstSet_1,Programme.OddValueTennisFirstSet_1
					,Programme.OddIdTennisFirstSet_2,Programme.OddValueTennisFirstSet_2
	 ,Parameter.Competitor.BetradarSuperId as HomeTeamId
	,Competitor_1.BetradarSuperId as Away
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
						 Language.[Parameter.Sport] with (nolock) ON  Language.[Parameter.Sport].SportId= Parameter.Sport.SportId and Language.[Parameter.Sport].LanguageId=@LangId
						 where Programme.SportId=@SportId and Parameter.Category.CategoryId=@CategoryId and Programme.MatchDate> GETDATE()
						 --case when (select COUNT(*) from Live.[Event] with (nolock) where BetradarMatchId=Programme.BetradarMatchId)>0 
						 --then DATEADD(MINUTE,12, GETDATE()) else  DATEADD(MINUTE,5, GETDATE()) end 
						 and Programme.MatchDate<=@EventDate
						  and Parameter.Sport.IsActive=1

	end
else if (@SportId>0 )
	begin
		SELECT     Programme.BetradarMatchId,Programme.MatchId, Programme.MatchDate,Language.[Parameter.Tournament].TournamentName,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetitor_1.CompetitorName AS EventName, 
                    Language.[Parameter.Sport].SportName,Programme.TournamentId,Programme.SportId,Parameter.Category.CategoryId,Parameter.Sport.SportName as SportNameOrginal
					,(SELECT     COUNT(DISTINCT OddsTypeId)
                                        FROM          Match.Odd with (nolock)
                                                      WHERE      (Match.Odd.MatchId = Programme.MatchId) AND (Match.Odd.StateId = 2) and Match.Odd.OddValue>1) as OddTypeCount , 
                     Programme.MatchDate as TournamentDate,case when (select COUNT(*) from Live.[EventDetail] with (nolock) where BetradarMatchIds=Programme.BetradarMatchId)>0 then cast(1 as bit) else cast(0 as bit) end as NeutralGround
					,null as HasStreaming,
					Language.[Parameter.Category].CategoryName
					,Parameter.Tournament.SequenceNumber,  SUBSTRING(LOWER(Parameter.Iso.IsoName2), 0, 3) AS IsoName
					,Parameter.Tournament.NewBetradarId as BetradarTournamentId
					,Programme.OddId1,CFF.OddValue1
					,Programme.OddId2,CFF.OddValue2
					,Programme.OddId3,CFF.OddValue3


							,  Programme.OddSpecialBetValueHadicap01_1  as OddSpecialBetValueHadicap01_1
					,Programme.OddIdHadicap01_1 as OddIdHadicap01_1
					,  Programme.OddValueHadicap01_1   as OddValueHadicap01_1
					, Programme.OddIdHadicap01_X  as OddIdHadicap01_X
					,  Programme.OddValueHadicap01_X  as OddValueHadicap01_X
					, Programme.OddIdHadicap01_2 as OddIdHadicap01_2 
					,  Programme.OddValueHadicap01_2 as OddValueHadicap01_2

					,Programme.OddSpecialBetValueHadicap02_1,Programme.OddIdHadicap02_1,Programme.OddValueHadicap02_1
					,Programme.OddIdHadicap02_X,Programme.OddValueHadicap02_X
					,Programme.OddIdHadicap02_2,Programme.OddValueHadicap02_2


					,Programme.OddSpecialBetValueHadicap10_1,Programme.OddIdHadicap10_1,Programme.OddValueHadicap10_1
					,Programme.OddIdHadicap10_X,Programme.OddValueHadicap10_X
					,Programme.OddIdHadicap10_2,Programme.OddValueHadicap10_2

					,Programme.OddSpecialBetValueHadicap20_1,Programme.OddIdHadicap20_1,Programme.OddValueHadicap20_1
					,Programme.OddIdHadicap20_X,Programme.OddValueHadicap20_X
					,Programme.OddIdHadicap20_2,Programme.OddValueHadicap20_2


					
						,case when Programme.SportId in (4,1) then Programme.OddSpecialBetValueTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddSpecialBetValueTotalSpread_O else Programme.OddSpecialBetValueTennisTotal_O end  end as OddSpecialBetValueTotals_O1_5
					,case when Programme.SportId in (4,1) then   Programme.OddIdTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddIdTotalSpread_O else  Programme.OddIdTennisTotal_O end end  as OddIdTotals_O1_5
					,case when Programme.SportId in (4,1) then   Programme.OddValueTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddValueTotalSpread_O else Programme.OddValueTennisTotal_O end end as OddValueTotals_O1_5
					,case when Programme.SportId in (4,1) then    Programme.OddIdTotals_U1_5 
					 else case when Programme.SportId not in (5,20) then  Programme.OddIdTotalSpread_U else Programme.OddIdTennisTotal_U end end as OddIdTotals_U1_5
					,case when Programme.SportId in (4,1) then  Programme.OddValueTotals_U1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddValueTotalSpread_U else Programme.OddValueTennisTotal_U end end as OddValueTotals_U1_5

					,case when Programme.SportId=2 then Programme.OddSpecialBetValueDartFirstSet_1 else OddSpecialBetValueTotals_O2_5 end   as OddSpecialBetValueTotals_O2_5  -- Basket Home OVer/Under
					,case when Programme.SportId=2 then Programme.OddIdDartFirstSet_1 else Programme.OddIdTotals_O2_5 end  as OddIdTotals_O2_5
					,case when Programme.SportId=2 then Programme.OddValueDartFirstSet_1 else Programme.OddValueTotals_O2_5  end as OddValueTotals_O2_5
					,case when Programme.SportId=2 then Programme.OddIdDartFirstSet_2  else Programme.OddIdTotals_U2_5 end as OddIdTotals_U2_5
					,case when Programme.SportId=2 then Programme.OddValueDartFirstSet_2 else Programme.OddValueTotals_U2_5  end as OddValueTotals_U2_5


						,case when Programme.SportId=2 then Programme.OddSpecialBetValueDrawNoBet_1 else OddSpecialBetValueTotals_O3_5 end   as  OddSpecialBetValueTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddIdDrawNoBet_1 else Programme.OddIdTotals_O3_5 end    as OddIdTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddValueDrawNoBet_1 else Programme.OddValueTotals_O3_5  end  as OddValueTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddIdDrawNoBet_2  else Programme.OddIdTotals_U3_5 end as OddIdTotals_U3_5
					,case when Programme.SportId=2 then Programme.OddValueDrawNoBet_2 else Programme.OddValueTotals_U3_5  end as OddValueTotals_U3_5

					,Programme.OddSpecialBetValueTotals_O4_5
					,Programme.OddIdTotals_O4_5,Programme.OddValueTotals_O4_5
					,Programme.OddIdTotals_U4_5,Programme.OddValueTotals_U4_5



					,Programme.OddIdDouble_1 as OddIdDouble_1X,Programme.OddValueDouble_1 as OddValueDouble_1X
					,Programme.OddIdDouble_X as OddIdDouble_X2,Programme.OddValueDouble_X as OddValueDouble_X2
					,Programme.OddIdDouble_2 as OddIdDouble_12,Programme.OddValueDouble_2 as OddValueDouble_12

					,Programme.OddIdBoth_Y ,Programme.OddValueBoth_Y
					,Programme.OddIdBoth_N ,Programme.OddValueBoth_N

				,  Programme.OddIdFirstScore_1 as OddIdFirstScore_1 
					,  Programme.OddValueFirstScore_1  as OddValueFirstScore_1 
					,  Programme.OddIdFirstScore_None  as OddIdFirstScore_None 
					, Programme.OddValueFirstScore_None  as OddValueFirstScore_None 
							, Programme.OddIdFirstScore_2  as OddIdFirstScore_2 
					,  Programme.OddValueFirstScore_2   as OddValueFirstScore_2 

					,Programme.OddIdFirstHalf_1 ,Programme.OddValueFirstHalf_1
					,Programme.OddIdFirstHalf_X ,Programme.OddValueFirstHalf_X
					,Programme.OddIdFirstHalf_2 ,Programme.OddValueFirstHalf_2
					
					,Programme.OddSpecialBetValueFirstHalfTotalsO_0_5
					,Programme.OddIdFirstHalfTotalsO_0_5,Programme.OddValueFirstHalfTotalsO_0_5  
					,Programme.OddIdFirstHalfTotalsU_0_5,Programme.OddValueFirstHalfTotalsU_0_5

					,Programme.OddSpecialBetValueFirstHalfTotalsO_1_5
					,Programme.OddIdFirstHalfTotalsO_1_5,Programme.OddValueFirstHalfTotalsO_1_5  
					,Programme.OddIdFirstHalfTotalsU_1_5,Programme.OddValueFirstHalfTotalsU_1_5

					 ,Programme.OutComeTennisScore_20 as OddSpecialBetValueTennisScore_20
					 ,Programme.OddIdTennisScore_20,Programme.OddValueTennisScore_20

					 ,Programme.OutComeTennisScore_02 as OddSpecialBetValueTennisScore_02
					 ,Programme.OddIdTennisScore_02,Programme.OddValueTennisScore_02

					  ,Programme.OutComeTennisScore_12 as OddSpecialBetValueTennisScore_12
					 ,Programme.OddIdTennisScore_12,Programme.OddValueTennisScore_12

					   ,Programme.OutComeTennisScore_21 as OddSpecialBetValueTennisScore_21
					 ,Programme.OddIdTennisScore_21,Programme.OddValueTennisScore_21

					    ,Programme.OddSpecialBetValueTennisTotal_O as OddSpecialBetValueTennisTotal
					 ,Programme.OddIdTennisTotal_O,Programme.OddValueTennisTotal_O
					 ,Programme.OddIdTennisTotal_U,Programme.OddValueTennisTotal_U

					    ,Programme.OddSpecialBetValueTotalSpread_O as OddSpecialBetValueBasketTotal
					 ,Programme.OddIdTotalSpread_O,Programme.OddValueTotalSpread_O
					 ,Programme.OddIdTotalSpread_U,Programme.OddValueTotalSpread_U

					 ,Programme.OddIdBasketFirstHalf_1 ,Programme.OddValueBasketFirstHalf_1
					,Programme.OddIdBasketFirstHalf_X ,Programme.OddValueBasketFirstHalf_x
					,Programme.OddIdBasketFirstHalf_2 ,Programme.OddValueBasketFirstHalf_2

						,Programme.OddIdTennisFirstSet_1,Programme.OddValueTennisFirstSet_1
					,Programme.OddIdTennisFirstSet_2,Programme.OddValueTennisFirstSet_2
	 ,Parameter.Competitor.BetradarSuperId as HomeTeamId
	,Competitor_1.BetradarSuperId as Away
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
				,(SELECT     COUNT(DISTINCT OddsTypeId)
                                        FROM          Match.Odd with (nolock)
                                                      WHERE      (Match.Odd.MatchId = Programme.MatchId) AND (Match.Odd.StateId = 2) and Match.Odd.OddValue>1) as OddTypeCount , 
                    Programme.MatchDate as TournamentDate,case when (select COUNT(*) from Live.[EventDetail] with (nolock) where BetradarMatchIds=Programme.BetradarMatchId)>0 then cast(1 as bit) else cast(0 as bit) end as NeutralGround
					,null as HasStreaming,
					Language.[Parameter.Category].CategoryName
					,Parameter.Tournament.SequenceNumber,  SUBSTRING(LOWER(Parameter.Iso.IsoName2), 0, 3) AS IsoName
					,Parameter.Tournament.NewBetradarId as BetradarTournamentId
					,Programme.OddId1,CFF.OddValue1
					,Programme.OddId2,CFF.OddValue2
					,Programme.OddId3,CFF.OddValue3

							,  Programme.OddSpecialBetValueHadicap01_1  as OddSpecialBetValueHadicap01_1
					,Programme.OddIdHadicap01_1 as OddIdHadicap01_1
					,  Programme.OddValueHadicap01_1   as OddValueHadicap01_1
					, Programme.OddIdHadicap01_X  as OddIdHadicap01_X
					,  Programme.OddValueHadicap01_X  as OddValueHadicap01_X
					, Programme.OddIdHadicap01_2 as OddIdHadicap01_2 
					,  Programme.OddValueHadicap01_2 as OddValueHadicap01_2

					,Programme.OddSpecialBetValueHadicap02_1,Programme.OddIdHadicap02_1,Programme.OddValueHadicap02_1
					,Programme.OddIdHadicap02_X,Programme.OddValueHadicap02_X
					,Programme.OddIdHadicap02_2,Programme.OddValueHadicap02_2


					,Programme.OddSpecialBetValueHadicap10_1,Programme.OddIdHadicap10_1,Programme.OddValueHadicap10_1
					,Programme.OddIdHadicap10_X,Programme.OddValueHadicap10_X
					,Programme.OddIdHadicap10_2,Programme.OddValueHadicap10_2

					,Programme.OddSpecialBetValueHadicap20_1,Programme.OddIdHadicap20_1,Programme.OddValueHadicap20_1
					,Programme.OddIdHadicap20_X,Programme.OddValueHadicap20_X
					,Programme.OddIdHadicap20_2,Programme.OddValueHadicap20_2

					
						,case when Programme.SportId in (4,1) then Programme.OddSpecialBetValueTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddSpecialBetValueTotalSpread_O else Programme.OddSpecialBetValueTennisTotal_O end  end as OddSpecialBetValueTotals_O1_5
					,case when Programme.SportId in (4,1) then   Programme.OddIdTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddIdTotalSpread_O else  Programme.OddIdTennisTotal_O end end  as OddIdTotals_O1_5
					,case when Programme.SportId in (4,1) then   Programme.OddValueTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddValueTotalSpread_O else Programme.OddValueTennisTotal_O end end as OddValueTotals_O1_5
					,case when Programme.SportId in (4,1) then    Programme.OddIdTotals_U1_5 
					 else case when Programme.SportId not in (5,20) then  Programme.OddIdTotalSpread_U else Programme.OddIdTennisTotal_U end end as OddIdTotals_U1_5
					,case when Programme.SportId in (4,1) then  Programme.OddValueTotals_U1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddValueTotalSpread_U else Programme.OddValueTennisTotal_U end end as OddValueTotals_U1_5

					,case when Programme.SportId=2 then Programme.OddSpecialBetValueDartFirstSet_1 else OddSpecialBetValueTotals_O2_5 end   as OddSpecialBetValueTotals_O2_5  -- Basket Home OVer/Under
					,case when Programme.SportId=2 then Programme.OddIdDartFirstSet_1 else Programme.OddIdTotals_O2_5 end  as OddIdTotals_O2_5
					,case when Programme.SportId=2 then Programme.OddValueDartFirstSet_1 else Programme.OddValueTotals_O2_5  end as OddValueTotals_O2_5
					,case when Programme.SportId=2 then Programme.OddIdDartFirstSet_2  else Programme.OddIdTotals_U2_5 end as OddIdTotals_U2_5
					,case when Programme.SportId=2 then Programme.OddValueDartFirstSet_2 else Programme.OddValueTotals_U2_5  end as OddValueTotals_U2_5


						,case when Programme.SportId=2 then Programme.OddSpecialBetValueDrawNoBet_1 else OddSpecialBetValueTotals_O3_5 end   as  OddSpecialBetValueTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddIdDrawNoBet_1 else Programme.OddIdTotals_O3_5 end    as OddIdTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddValueDrawNoBet_1 else Programme.OddValueTotals_O3_5  end  as OddValueTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddIdDrawNoBet_2  else Programme.OddIdTotals_U3_5 end as OddIdTotals_U3_5
					,case when Programme.SportId=2 then Programme.OddValueDrawNoBet_2 else Programme.OddValueTotals_U3_5  end as OddValueTotals_U3_5

					,Programme.OddSpecialBetValueTotals_O4_5
					,Programme.OddIdTotals_O4_5,Programme.OddValueTotals_O4_5
					,Programme.OddIdTotals_U4_5,Programme.OddValueTotals_U4_5



					,Programme.OddIdDouble_1 as OddIdDouble_1X,Programme.OddValueDouble_1 as OddValueDouble_1X
					,Programme.OddIdDouble_X as OddIdDouble_X2,Programme.OddValueDouble_X as OddValueDouble_X2
					,Programme.OddIdDouble_2 as OddIdDouble_12,Programme.OddValueDouble_2 as OddValueDouble_12

					,Programme.OddIdBoth_Y ,Programme.OddValueBoth_Y
					,Programme.OddIdBoth_N ,Programme.OddValueBoth_N

				,  Programme.OddIdFirstScore_1 as OddIdFirstScore_1 
					,  Programme.OddValueFirstScore_1  as OddValueFirstScore_1 
					,  Programme.OddIdFirstScore_None  as OddIdFirstScore_None 
					, Programme.OddValueFirstScore_None  as OddValueFirstScore_None 
							, Programme.OddIdFirstScore_2  as OddIdFirstScore_2 
					,  Programme.OddValueFirstScore_2   as OddValueFirstScore_2 

					,Programme.OddIdFirstHalf_1 ,Programme.OddValueFirstHalf_1
					,Programme.OddIdFirstHalf_X ,Programme.OddValueFirstHalf_X
					,Programme.OddIdFirstHalf_2 ,Programme.OddValueFirstHalf_2
					
					,Programme.OddSpecialBetValueFirstHalfTotalsO_0_5
					,Programme.OddIdFirstHalfTotalsO_0_5,Programme.OddValueFirstHalfTotalsO_0_5  
					,Programme.OddIdFirstHalfTotalsU_0_5,Programme.OddValueFirstHalfTotalsU_0_5

					,Programme.OddSpecialBetValueFirstHalfTotalsO_1_5
					,Programme.OddIdFirstHalfTotalsO_1_5,Programme.OddValueFirstHalfTotalsO_1_5  
					,Programme.OddIdFirstHalfTotalsU_1_5,Programme.OddValueFirstHalfTotalsU_1_5

					 ,Programme.OutComeTennisScore_20 as OddSpecialBetValueTennisScore_20
					 ,Programme.OddIdTennisScore_20,Programme.OddValueTennisScore_20

					 ,Programme.OutComeTennisScore_02 as OddSpecialBetValueTennisScore_02
					 ,Programme.OddIdTennisScore_02,Programme.OddValueTennisScore_02

					  ,Programme.OutComeTennisScore_12 as OddSpecialBetValueTennisScore_12
					 ,Programme.OddIdTennisScore_12,Programme.OddValueTennisScore_12

					   ,Programme.OutComeTennisScore_21 as OddSpecialBetValueTennisScore_21
					 ,Programme.OddIdTennisScore_21,Programme.OddValueTennisScore_21

					    ,Programme.OddSpecialBetValueTennisTotal_O as OddSpecialBetValueTennisTotal
					 ,Programme.OddIdTennisTotal_O,Programme.OddValueTennisTotal_O
					 ,Programme.OddIdTennisTotal_U,Programme.OddValueTennisTotal_U

					    ,Programme.OddSpecialBetValueTotalSpread_O as OddSpecialBetValueBasketTotal
					 ,Programme.OddIdTotalSpread_O,Programme.OddValueTotalSpread_O
					 ,Programme.OddIdTotalSpread_U,Programme.OddValueTotalSpread_U

					 ,Programme.OddIdBasketFirstHalf_1 ,Programme.OddValueBasketFirstHalf_1
					,Programme.OddIdBasketFirstHalf_X ,Programme.OddValueBasketFirstHalf_x
					,Programme.OddIdBasketFirstHalf_2 ,Programme.OddValueBasketFirstHalf_2

						,Programme.OddIdTennisFirstSet_1,Programme.OddValueTennisFirstSet_1
					,Programme.OddIdTennisFirstSet_2,Programme.OddValueTennisFirstSet_2
	 ,Parameter.Competitor.BetradarSuperId as HomeTeamId
	,Competitor_1.BetradarSuperId as Away
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
					,(SELECT     COUNT(DISTINCT OddsTypeId)
                                        FROM          Match.Odd with (nolock)
                                                      WHERE      (Match.Odd.MatchId = Programme.MatchId) AND (Match.Odd.StateId = 2) and Match.Odd.OddValue>1) as OddTypeCount , 
                     Programme.MatchDate as TournamentDate,case when (select COUNT(*) from Live.[EventDetail] with (nolock) where BetradarMatchIds=Programme.BetradarMatchId)>0 then cast(1 as bit) else cast(0 as bit) end as NeutralGround
					, cast(0 as bit)  AS HasStreaming,
					Language.[Parameter.Category].CategoryName
					,Parameter.Category.SequenceNumber,  SUBSTRING(LOWER(Parameter.Iso.IsoName2), 0, 3) AS IsoName
					,Parameter.Tournament.NewBetradarId as BetradarTournamentId
					,Programme.OddId1,CFF.OddValue1
					,Programme.OddId2,CFF.OddValue2
					,Programme.OddId3,CFF.OddValue3

						,  Programme.OddSpecialBetValueHadicap01_1  as OddSpecialBetValueHadicap01_1
					,Programme.OddIdHadicap01_1 as OddIdHadicap01_1
					,  Programme.OddValueHadicap01_1   as OddValueHadicap01_1
					, Programme.OddIdHadicap01_X  as OddIdHadicap01_X
					,  Programme.OddValueHadicap01_X  as OddValueHadicap01_X
					, Programme.OddIdHadicap01_2 as OddIdHadicap01_2 
					,  Programme.OddValueHadicap01_2 as OddValueHadicap01_2

					,Programme.OddSpecialBetValueHadicap02_1,Programme.OddIdHadicap02_1,Programme.OddValueHadicap02_1
					,Programme.OddIdHadicap02_X,Programme.OddValueHadicap02_X
					,Programme.OddIdHadicap02_2,Programme.OddValueHadicap02_2


					,Programme.OddSpecialBetValueHadicap10_1,Programme.OddIdHadicap10_1,Programme.OddValueHadicap10_1
					,Programme.OddIdHadicap10_X,Programme.OddValueHadicap10_X
					,Programme.OddIdHadicap10_2,Programme.OddValueHadicap10_2

					,Programme.OddSpecialBetValueHadicap20_1,Programme.OddIdHadicap20_1,Programme.OddValueHadicap20_1
					,Programme.OddIdHadicap20_X,Programme.OddValueHadicap20_X
					,Programme.OddIdHadicap20_2,Programme.OddValueHadicap20_2


					
						,case when Programme.SportId in (4,1) then Programme.OddSpecialBetValueTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddSpecialBetValueTotalSpread_O else Programme.OddSpecialBetValueTennisTotal_O end  end as OddSpecialBetValueTotals_O1_5
					,case when Programme.SportId in (4,1) then   Programme.OddIdTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddIdTotalSpread_O else  Programme.OddIdTennisTotal_O end end  as OddIdTotals_O1_5
					,case when Programme.SportId in (4,1) then   Programme.OddValueTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddValueTotalSpread_O else Programme.OddValueTennisTotal_O end end as OddValueTotals_O1_5
					,case when Programme.SportId in (4,1) then    Programme.OddIdTotals_U1_5 
					 else case when Programme.SportId not in (5,20) then  Programme.OddIdTotalSpread_U else Programme.OddIdTennisTotal_U end end as OddIdTotals_U1_5
					,case when Programme.SportId in (4,1) then  Programme.OddValueTotals_U1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddValueTotalSpread_U else Programme.OddValueTennisTotal_U end end as OddValueTotals_U1_5

					,case when Programme.SportId=2 then Programme.OddSpecialBetValueDartFirstSet_1 else OddSpecialBetValueTotals_O2_5 end   as OddSpecialBetValueTotals_O2_5  -- Basket Home OVer/Under
					,case when Programme.SportId=2 then Programme.OddIdDartFirstSet_1 else Programme.OddIdTotals_O2_5 end  as OddIdTotals_O2_5
					,case when Programme.SportId=2 then Programme.OddValueDartFirstSet_1 else Programme.OddValueTotals_O2_5  end as OddValueTotals_O2_5
					,case when Programme.SportId=2 then Programme.OddIdDartFirstSet_2  else Programme.OddIdTotals_U2_5 end as OddIdTotals_U2_5
					,case when Programme.SportId=2 then Programme.OddValueDartFirstSet_2 else Programme.OddValueTotals_U2_5  end as OddValueTotals_U2_5


						,case when Programme.SportId=2 then Programme.OddSpecialBetValueDrawNoBet_1 else OddSpecialBetValueTotals_O3_5 end   as  OddSpecialBetValueTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddIdDrawNoBet_1 else Programme.OddIdTotals_O3_5 end    as OddIdTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddValueDrawNoBet_1 else Programme.OddValueTotals_O3_5  end  as OddValueTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddIdDrawNoBet_2  else Programme.OddIdTotals_U3_5 end as OddIdTotals_U3_5
					,case when Programme.SportId=2 then Programme.OddValueDrawNoBet_2 else Programme.OddValueTotals_U3_5  end as OddValueTotals_U3_5

					,Programme.OddSpecialBetValueTotals_O4_5
					,Programme.OddIdTotals_O4_5,Programme.OddValueTotals_O4_5
					,Programme.OddIdTotals_U4_5,Programme.OddValueTotals_U4_5


					,Programme.OddIdDouble_1 as OddIdDouble_1X,Programme.OddValueDouble_1 as OddValueDouble_1X
					,Programme.OddIdDouble_X as OddIdDouble_X2,Programme.OddValueDouble_X as OddValueDouble_X2
					,Programme.OddIdDouble_2 as OddIdDouble_12,Programme.OddValueDouble_2 as OddValueDouble_12

					,Programme.OddIdBoth_Y ,Programme.OddValueBoth_Y
					,Programme.OddIdBoth_N ,Programme.OddValueBoth_N

					,  Programme.OddIdFirstScore_1 as OddIdFirstScore_1 
					,  Programme.OddValueFirstScore_1  as OddValueFirstScore_1 
					,  Programme.OddIdFirstScore_None  as OddIdFirstScore_None 
					, Programme.OddValueFirstScore_None  as OddValueFirstScore_None 
							, Programme.OddIdFirstScore_2  as OddIdFirstScore_2 
					,  Programme.OddValueFirstScore_2   as OddValueFirstScore_2  

					,Programme.OddIdFirstHalf_1 ,Programme.OddValueFirstHalf_1
					,Programme.OddIdFirstHalf_X ,Programme.OddValueFirstHalf_X
					,Programme.OddIdFirstHalf_2 ,Programme.OddValueFirstHalf_2
					
					,Programme.OddSpecialBetValueFirstHalfTotalsO_0_5
					,Programme.OddIdFirstHalfTotalsO_0_5,Programme.OddValueFirstHalfTotalsO_0_5  
					,Programme.OddIdFirstHalfTotalsU_0_5,Programme.OddValueFirstHalfTotalsU_0_5

					,Programme.OddSpecialBetValueFirstHalfTotalsO_1_5
					,Programme.OddIdFirstHalfTotalsO_1_5,Programme.OddValueFirstHalfTotalsO_1_5  
					,Programme.OddIdFirstHalfTotalsU_1_5,Programme.OddValueFirstHalfTotalsU_1_5

					 ,Programme.OutComeTennisScore_20 as OddSpecialBetValueTennisScore_20
					 ,Programme.OddIdTennisScore_20,Programme.OddValueTennisScore_20

					 ,Programme.OutComeTennisScore_02 as OddSpecialBetValueTennisScore_02
					 ,Programme.OddIdTennisScore_02,Programme.OddValueTennisScore_02

					  ,Programme.OutComeTennisScore_12 as OddSpecialBetValueTennisScore_12
					 ,Programme.OddIdTennisScore_12,Programme.OddValueTennisScore_12

					   ,Programme.OutComeTennisScore_21 as OddSpecialBetValueTennisScore_21
					 ,Programme.OddIdTennisScore_21,Programme.OddValueTennisScore_21

					    ,Programme.OddSpecialBetValueTennisTotal_O as OddSpecialBetValueTennisTotal
					 ,Programme.OddIdTennisTotal_O,Programme.OddValueTennisTotal_O
					 ,Programme.OddIdTennisTotal_U,Programme.OddValueTennisTotal_U

					    ,Programme.OddSpecialBetValueTotalSpread_O as OddSpecialBetValueBasketTotal
					 ,Programme.OddIdTotalSpread_O,Programme.OddValueTotalSpread_O
					 ,Programme.OddIdTotalSpread_U,Programme.OddValueTotalSpread_U

					 ,Programme.OddIdBasketFirstHalf_1 ,Programme.OddValueBasketFirstHalf_1
					,Programme.OddIdBasketFirstHalf_X ,Programme.OddValueBasketFirstHalf_x
					,Programme.OddIdBasketFirstHalf_2 ,Programme.OddValueBasketFirstHalf_2

						,Programme.OddIdTennisFirstSet_1,Programme.OddValueTennisFirstSet_1
					,Programme.OddIdTennisFirstSet_2,Programme.OddValueTennisFirstSet_2
	 ,Parameter.Competitor.BetradarSuperId as HomeTeamId
	,Competitor_1.BetradarSuperId as Away
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
						 and Programme.MatchDate<=@EventDate and Parameter.Sport.IsActive=1
						 	order by Parameter.Category.SequenceNumber,Parameter.Tournament.TournamentId 

	end
else if (@SportId=-3) -- Tournament Full Last Min.
	begin
		SELECT     Programme.BetradarMatchId,Programme.MatchId, Programme.MatchDate,Language.[Parameter.Tournament].TournamentName,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetitor_1.CompetitorName AS EventName, 
                    Language.[Parameter.Sport].SportName,Programme.TournamentId,Programme.SportId,Parameter.Category.CategoryId,Parameter.Sport.SportName as SportNameOrginal
				,(SELECT     COUNT(DISTINCT OddsTypeId)
                                        FROM          Match.Odd with (nolock)
                                                      WHERE      (Match.Odd.MatchId = Programme.MatchId) AND (Match.Odd.StateId = 2) and Match.Odd.OddValue>1) as OddTypeCount , 
                     Programme.MatchDate as TournamentDate,case when (select COUNT(*) from Live.[EventDetail] with (nolock) where BetradarMatchIds=Programme.BetradarMatchId)>0 then cast(1 as bit) else cast(0 as bit) end as NeutralGround
					,null as HasStreaming,
					Language.[Parameter.Category].CategoryName
					,Parameter.Category.SequenceNumber,  SUBSTRING(LOWER(Parameter.Iso.IsoName2), 0, 3) AS IsoName
					,Parameter.Tournament.NewBetradarId as BetradarTournamentId
					,Programme.OddId1,CFF.OddValue1
					,Programme.OddId2,CFF.OddValue2
					,Programme.OddId3,CFF.OddValue3

								,  Programme.OddSpecialBetValueHadicap01_1  as OddSpecialBetValueHadicap01_1
					,Programme.OddIdHadicap01_1 as OddIdHadicap01_1
					,  Programme.OddValueHadicap01_1   as OddValueHadicap01_1
					, Programme.OddIdHadicap01_X  as OddIdHadicap01_X
					,  Programme.OddValueHadicap01_X  as OddValueHadicap01_X
					, Programme.OddIdHadicap01_2 as OddIdHadicap01_2 
					,  Programme.OddValueHadicap01_2 as OddValueHadicap01_2

					,Programme.OddSpecialBetValueHadicap02_1,Programme.OddIdHadicap02_1,Programme.OddValueHadicap02_1
					,Programme.OddIdHadicap02_X,Programme.OddValueHadicap02_X
					,Programme.OddIdHadicap02_2,Programme.OddValueHadicap02_2


					,Programme.OddSpecialBetValueHadicap10_1,Programme.OddIdHadicap10_1,Programme.OddValueHadicap10_1
					,Programme.OddIdHadicap10_X,Programme.OddValueHadicap10_X
					,Programme.OddIdHadicap10_2,Programme.OddValueHadicap10_2

					,Programme.OddSpecialBetValueHadicap20_1,Programme.OddIdHadicap20_1,Programme.OddValueHadicap20_1
					,Programme.OddIdHadicap20_X,Programme.OddValueHadicap20_X
					,Programme.OddIdHadicap20_2,Programme.OddValueHadicap20_2


					
						,case when Programme.SportId in (4,1) then Programme.OddSpecialBetValueTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddSpecialBetValueTotalSpread_O else Programme.OddSpecialBetValueTennisTotal_O end  end as OddSpecialBetValueTotals_O1_5
					,case when Programme.SportId in (4,1) then   Programme.OddIdTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddIdTotalSpread_O else  Programme.OddIdTennisTotal_O end end  as OddIdTotals_O1_5
					,case when Programme.SportId in (4,1) then   Programme.OddValueTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddValueTotalSpread_O else Programme.OddValueTennisTotal_O end end as OddValueTotals_O1_5
					,case when Programme.SportId in (4,1) then    Programme.OddIdTotals_U1_5 
					 else case when Programme.SportId not in (5,20) then  Programme.OddIdTotalSpread_U else Programme.OddIdTennisTotal_U end end as OddIdTotals_U1_5
					,case when Programme.SportId in (4,1) then  Programme.OddValueTotals_U1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddValueTotalSpread_U else Programme.OddValueTennisTotal_U end end as OddValueTotals_U1_5

					,case when Programme.SportId=2 then Programme.OddSpecialBetValueDartFirstSet_1 else OddSpecialBetValueTotals_O2_5 end   as OddSpecialBetValueTotals_O2_5  -- Basket Home OVer/Under
					,case when Programme.SportId=2 then Programme.OddIdDartFirstSet_1 else Programme.OddIdTotals_O2_5 end  as OddIdTotals_O2_5
					,case when Programme.SportId=2 then Programme.OddValueDartFirstSet_1 else Programme.OddValueTotals_O2_5  end as OddValueTotals_O2_5
					,case when Programme.SportId=2 then Programme.OddIdDartFirstSet_2  else Programme.OddIdTotals_U2_5 end as OddIdTotals_U2_5
					,case when Programme.SportId=2 then Programme.OddValueDartFirstSet_2 else Programme.OddValueTotals_U2_5  end as OddValueTotals_U2_5


						,case when Programme.SportId=2 then Programme.OddSpecialBetValueDrawNoBet_1 else OddSpecialBetValueTotals_O3_5 end   as  OddSpecialBetValueTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddIdDrawNoBet_1 else Programme.OddIdTotals_O3_5 end    as OddIdTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddValueDrawNoBet_1 else Programme.OddValueTotals_O3_5  end  as OddValueTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddIdDrawNoBet_2  else Programme.OddIdTotals_U3_5 end as OddIdTotals_U3_5
					,case when Programme.SportId=2 then Programme.OddValueDrawNoBet_2 else Programme.OddValueTotals_U3_5  end as OddValueTotals_U3_5

					,Programme.OddSpecialBetValueTotals_O4_5
					,Programme.OddIdTotals_O4_5,Programme.OddValueTotals_O4_5
					,Programme.OddIdTotals_U4_5,Programme.OddValueTotals_U4_5


				,Programme.OddIdDouble_1 as OddIdDouble_1X,Programme.OddValueDouble_1 as OddValueDouble_1X
					,Programme.OddIdDouble_X as OddIdDouble_X2,Programme.OddValueDouble_X as OddValueDouble_X2
					,Programme.OddIdDouble_2 as OddIdDouble_12,Programme.OddValueDouble_2 as OddValueDouble_12

					,Programme.OddIdBoth_Y ,Programme.OddValueBoth_Y
					,Programme.OddIdBoth_N ,Programme.OddValueBoth_N

					,  Programme.OddIdFirstScore_1 as OddIdFirstScore_1 
					,  Programme.OddValueFirstScore_1  as OddValueFirstScore_1 
					,  Programme.OddIdFirstScore_None  as OddIdFirstScore_None 
					, Programme.OddValueFirstScore_None  as OddValueFirstScore_None 
							, Programme.OddIdFirstScore_2  as OddIdFirstScore_2 
					,  Programme.OddValueFirstScore_2   as OddValueFirstScore_2 

					,Programme.OddIdFirstHalf_1 ,Programme.OddValueFirstHalf_1
					,Programme.OddIdFirstHalf_X ,Programme.OddValueFirstHalf_X
					,Programme.OddIdFirstHalf_2 ,Programme.OddValueFirstHalf_2
					
					,Programme.OddSpecialBetValueFirstHalfTotalsO_0_5
					,Programme.OddIdFirstHalfTotalsO_0_5,Programme.OddValueFirstHalfTotalsO_0_5  
					,Programme.OddIdFirstHalfTotalsU_0_5,Programme.OddValueFirstHalfTotalsU_0_5

					,Programme.OddSpecialBetValueFirstHalfTotalsO_1_5
					,Programme.OddIdFirstHalfTotalsO_1_5,Programme.OddValueFirstHalfTotalsO_1_5  
					,Programme.OddIdFirstHalfTotalsU_1_5,Programme.OddValueFirstHalfTotalsU_1_5

					 ,Programme.OutComeTennisScore_20 as OddSpecialBetValueTennisScore_20
					 ,Programme.OddIdTennisScore_20,Programme.OddValueTennisScore_20

					 ,Programme.OutComeTennisScore_02 as OddSpecialBetValueTennisScore_02
					 ,Programme.OddIdTennisScore_02,Programme.OddValueTennisScore_02

					  ,Programme.OutComeTennisScore_12 as OddSpecialBetValueTennisScore_12
					 ,Programme.OddIdTennisScore_12,Programme.OddValueTennisScore_12

					   ,Programme.OutComeTennisScore_21 as OddSpecialBetValueTennisScore_21
					 ,Programme.OddIdTennisScore_21,Programme.OddValueTennisScore_21

					    ,Programme.OddSpecialBetValueTennisTotal_O as OddSpecialBetValueTennisTotal
					 ,Programme.OddIdTennisTotal_O,Programme.OddValueTennisTotal_O
					 ,Programme.OddIdTennisTotal_U,Programme.OddValueTennisTotal_U

					    ,Programme.OddSpecialBetValueTotalSpread_O as OddSpecialBetValueBasketTotal
					 ,Programme.OddIdTotalSpread_O,Programme.OddValueTotalSpread_O
					 ,Programme.OddIdTotalSpread_U,Programme.OddValueTotalSpread_U

					 ,Programme.OddIdBasketFirstHalf_1 ,Programme.OddValueBasketFirstHalf_1
					,Programme.OddIdBasketFirstHalf_X ,Programme.OddValueBasketFirstHalf_x
					,Programme.OddIdBasketFirstHalf_2 ,Programme.OddValueBasketFirstHalf_2

						,Programme.OddIdTennisFirstSet_1,Programme.OddValueTennisFirstSet_1
					,Programme.OddIdTennisFirstSet_2,Programme.OddValueTennisFirstSet_2
	 ,Parameter.Competitor.BetradarSuperId as HomeTeamId
	,Competitor_1.BetradarSuperId as Away
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
					,(SELECT     COUNT(DISTINCT OddsTypeId)
                                        FROM          Match.Odd with (nolock)
                                                      WHERE      (Match.Odd.MatchId = Programme.MatchId) AND (Match.Odd.StateId = 2) and Match.Odd.OddValue>1) as OddTypeCount , 
                     Programme.MatchDate as TournamentDate,case when (select COUNT(*) from Live.[EventDetail] with (nolock) where BetradarMatchIds=Programme.BetradarMatchId)>0 then cast(1 as bit) else cast(0 as bit) end as NeutralGround
					,null as HasStreaming,
					Language.[Parameter.Category].CategoryName
					,Parameter.Category.SequenceNumber,  SUBSTRING(LOWER(Parameter.Iso.IsoName2), 0, 3) AS IsoName
					,Parameter.Tournament.NewBetradarId as BetradarTournamentId
					,Programme.OddId1,CFF.OddValue1
					,Programme.OddId2,CFF.OddValue2
					,Programme.OddId3,CFF.OddValue3


							,  Programme.OddSpecialBetValueHadicap01_1  as OddSpecialBetValueHadicap01_1
					,Programme.OddIdHadicap01_1 as OddIdHadicap01_1
					,  Programme.OddValueHadicap01_1   as OddValueHadicap01_1
					, Programme.OddIdHadicap01_X  as OddIdHadicap01_X
					,  Programme.OddValueHadicap01_X  as OddValueHadicap01_X
					, Programme.OddIdHadicap01_2 as OddIdHadicap01_2 
					,  Programme.OddValueHadicap01_2 as OddValueHadicap01_2

					,Programme.OddSpecialBetValueHadicap02_1,Programme.OddIdHadicap02_1,Programme.OddValueHadicap02_1
					,Programme.OddIdHadicap02_X,Programme.OddValueHadicap02_X
					,Programme.OddIdHadicap02_2,Programme.OddValueHadicap02_2


					,Programme.OddSpecialBetValueHadicap10_1,Programme.OddIdHadicap10_1,Programme.OddValueHadicap10_1
					,Programme.OddIdHadicap10_X,Programme.OddValueHadicap10_X
					,Programme.OddIdHadicap10_2,Programme.OddValueHadicap10_2

					,Programme.OddSpecialBetValueHadicap20_1,Programme.OddIdHadicap20_1,Programme.OddValueHadicap20_1
					,Programme.OddIdHadicap20_X,Programme.OddValueHadicap20_X
					,Programme.OddIdHadicap20_2,Programme.OddValueHadicap20_2


						,case when Programme.SportId in (4,1) then Programme.OddSpecialBetValueTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddSpecialBetValueTotalSpread_O else Programme.OddSpecialBetValueTennisTotal_O end  end as OddSpecialBetValueTotals_O1_5
					,case when Programme.SportId in (4,1) then   Programme.OddIdTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddIdTotalSpread_O else  Programme.OddIdTennisTotal_O end end  as OddIdTotals_O1_5
					,case when Programme.SportId in (4,1) then   Programme.OddValueTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddValueTotalSpread_O else Programme.OddValueTennisTotal_O end end as OddValueTotals_O1_5
					,case when Programme.SportId in (4,1) then    Programme.OddIdTotals_U1_5 
					 else case when Programme.SportId not in (5,20) then  Programme.OddIdTotalSpread_U else Programme.OddIdTennisTotal_U end end as OddIdTotals_U1_5
					,case when Programme.SportId in (4,1) then  Programme.OddValueTotals_U1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddValueTotalSpread_U else Programme.OddValueTennisTotal_U end end as OddValueTotals_U1_5

					,case when Programme.SportId=2 then Programme.OddSpecialBetValueDartFirstSet_1 else OddSpecialBetValueTotals_O2_5 end   as OddSpecialBetValueTotals_O2_5  -- Basket Home OVer/Under
					,case when Programme.SportId=2 then Programme.OddIdDartFirstSet_1 else Programme.OddIdTotals_O2_5 end  as OddIdTotals_O2_5
					,case when Programme.SportId=2 then Programme.OddValueDartFirstSet_1 else Programme.OddValueTotals_O2_5  end as OddValueTotals_O2_5
					,case when Programme.SportId=2 then Programme.OddIdDartFirstSet_2  else Programme.OddIdTotals_U2_5 end as OddIdTotals_U2_5
					,case when Programme.SportId=2 then Programme.OddValueDartFirstSet_2 else Programme.OddValueTotals_U2_5  end as OddValueTotals_U2_5


						,case when Programme.SportId=2 then Programme.OddSpecialBetValueDrawNoBet_1 else OddSpecialBetValueTotals_O3_5 end   as  OddSpecialBetValueTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddIdDrawNoBet_1 else Programme.OddIdTotals_O3_5 end    as OddIdTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddValueDrawNoBet_1 else Programme.OddValueTotals_O3_5  end  as OddValueTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddIdDrawNoBet_2  else Programme.OddIdTotals_U3_5 end as OddIdTotals_U3_5
					,case when Programme.SportId=2 then Programme.OddValueDrawNoBet_2 else Programme.OddValueTotals_U3_5  end as OddValueTotals_U3_5

					,Programme.OddSpecialBetValueTotals_O4_5
					,Programme.OddIdTotals_O4_5,Programme.OddValueTotals_O4_5
					,Programme.OddIdTotals_U4_5,Programme.OddValueTotals_U4_5


					,Programme.OddIdDouble_1 as OddIdDouble_1X,Programme.OddValueDouble_1 as OddValueDouble_1X
					,Programme.OddIdDouble_X as OddIdDouble_X2,Programme.OddValueDouble_X as OddValueDouble_X2
					,Programme.OddIdDouble_2 as OddIdDouble_12,Programme.OddValueDouble_2 as OddValueDouble_12

					,Programme.OddIdBoth_Y ,Programme.OddValueBoth_Y
					,Programme.OddIdBoth_N ,Programme.OddValueBoth_N

					,  Programme.OddIdFirstScore_1 as OddIdFirstScore_1 
					,  Programme.OddValueFirstScore_1  as OddValueFirstScore_1 
					,  Programme.OddIdFirstScore_None  as OddIdFirstScore_None 
					, Programme.OddValueFirstScore_None  as OddValueFirstScore_None 
							, Programme.OddIdFirstScore_2  as OddIdFirstScore_2 
					,  Programme.OddValueFirstScore_2   as OddValueFirstScore_2 

					,Programme.OddIdFirstHalf_1 ,Programme.OddValueFirstHalf_1
					,Programme.OddIdFirstHalf_X ,Programme.OddValueFirstHalf_X
					,Programme.OddIdFirstHalf_2 ,Programme.OddValueFirstHalf_2
					
					,Programme.OddSpecialBetValueFirstHalfTotalsO_0_5
					,Programme.OddIdFirstHalfTotalsO_0_5,Programme.OddValueFirstHalfTotalsO_0_5  
					,Programme.OddIdFirstHalfTotalsU_0_5,Programme.OddValueFirstHalfTotalsU_0_5

					,Programme.OddSpecialBetValueFirstHalfTotalsO_1_5
					,Programme.OddIdFirstHalfTotalsO_1_5,Programme.OddValueFirstHalfTotalsO_1_5  
					,Programme.OddIdFirstHalfTotalsU_1_5,Programme.OddValueFirstHalfTotalsU_1_5

					 ,Programme.OutComeTennisScore_20 as OddSpecialBetValueTennisScore_20
					 ,Programme.OddIdTennisScore_20,Programme.OddValueTennisScore_20

					 ,Programme.OutComeTennisScore_02 as OddSpecialBetValueTennisScore_02
					 ,Programme.OddIdTennisScore_02,Programme.OddValueTennisScore_02

					  ,Programme.OutComeTennisScore_12 as OddSpecialBetValueTennisScore_12
					 ,Programme.OddIdTennisScore_12,Programme.OddValueTennisScore_12

					   ,Programme.OutComeTennisScore_21 as OddSpecialBetValueTennisScore_21
					 ,Programme.OddIdTennisScore_21,Programme.OddValueTennisScore_21

					    ,Programme.OddSpecialBetValueTennisTotal_O as OddSpecialBetValueTennisTotal
					 ,Programme.OddIdTennisTotal_O,Programme.OddValueTennisTotal_O
					 ,Programme.OddIdTennisTotal_U,Programme.OddValueTennisTotal_U

					    ,Programme.OddSpecialBetValueTotalSpread_O as OddSpecialBetValueBasketTotal
					 ,Programme.OddIdTotalSpread_O,Programme.OddValueTotalSpread_O
					 ,Programme.OddIdTotalSpread_U,Programme.OddValueTotalSpread_U

					 ,Programme.OddIdBasketFirstHalf_1 ,Programme.OddValueBasketFirstHalf_1
					,Programme.OddIdBasketFirstHalf_X ,Programme.OddValueBasketFirstHalf_x
					,Programme.OddIdBasketFirstHalf_2 ,Programme.OddValueBasketFirstHalf_2

						,Programme.OddIdTennisFirstSet_1,Programme.OddValueTennisFirstSet_1
					,Programme.OddIdTennisFirstSet_2,Programme.OddValueTennisFirstSet_2
	 ,Parameter.Competitor.BetradarSuperId as HomeTeamId
	,Competitor_1.BetradarSuperId as Away
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
					,(SELECT     COUNT(DISTINCT OddsTypeId)
                                        FROM          Match.Odd with (nolock)
                                                      WHERE      (Match.Odd.MatchId = Programme.MatchId) AND (Match.Odd.StateId = 2) and Match.Odd.OddValue>1) as OddTypeCount , 
                     Programme.MatchDate as TournamentDate
					,case when (select COUNT(*) from Live.[EventDetail] with (nolock) where BetradarMatchIds=Programme.BetradarMatchId)>0 then cast(1 as bit) else cast(0 as bit) end as NeutralGround
					,null as HasStreaming,
					Language.[Parameter.Category].CategoryName
					,Parameter.Category.SequenceNumber,  SUBSTRING(LOWER(Parameter.Iso.IsoName2), 0, 3) AS IsoName
					,Parameter.Tournament.NewBetradarId as BetradarTournamentId
					,Programme.OddId1,CFF.OddValue1
					,Programme.OddId2,CFF.OddValue2
					,Programme.OddId3,CFF.OddValue3


							,case when Programme.OddValue1<Programme.OddValue2 then  Programme.OddSpecialBetValueHadicap01_1 else Programme.OddSpecialBetValueHadicap10_1 end  as OddSpecialBetValueHadicap01_1
					,case when Programme.OddValue1<Programme.OddValue2 then Programme.OddIdHadicap01_1 else Programme.OddIdHadicap10_1 end as OddIdHadicap01_1
					,case when Programme.OddValue1<Programme.OddValue2 then Programme.OddValueHadicap01_1 else Programme.OddValueHadicap10_1 end as OddValueHadicap01_1
					,case when Programme.OddValue1<Programme.OddValue2 then Programme.OddIdHadicap01_X else Programme.OddIdHadicap10_X end as OddIdHadicap01_X
					,case when Programme.OddValue1<Programme.OddValue2 then  Programme.OddValueHadicap01_X else Programme.OddValueHadicap10_X end as OddValueHadicap01_X
					,case when Programme.OddValue1<Programme.OddValue2 then Programme.OddIdHadicap01_2 else Programme.OddIdHadicap10_2 end as OddIdHadicap01_2 
					,case when Programme.OddValue1<Programme.OddValue2 then Programme.OddValueHadicap01_2 else Programme.OddValueHadicap10_2 end as OddValueHadicap01_2

					,Programme.OddSpecialBetValueHadicap02_1,Programme.OddIdHadicap02_1,Programme.OddValueHadicap02_1
					,Programme.OddIdHadicap02_X,Programme.OddValueHadicap02_X
					,Programme.OddIdHadicap02_2,Programme.OddValueHadicap02_2


					,Programme.OddSpecialBetValueHadicap10_1,Programme.OddIdHadicap10_1,Programme.OddValueHadicap10_1
					,Programme.OddIdHadicap10_X,Programme.OddValueHadicap10_X
					,Programme.OddIdHadicap10_2,Programme.OddValueHadicap10_2

					,Programme.OddSpecialBetValueHadicap20_1,Programme.OddIdHadicap20_1,Programme.OddValueHadicap20_1
					,Programme.OddIdHadicap20_X,Programme.OddValueHadicap20_X
					,Programme.OddIdHadicap20_2,Programme.OddValueHadicap20_2


						,case when Programme.SportId in (4,1) then Programme.OddSpecialBetValueTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddSpecialBetValueTotalSpread_O else Programme.OddSpecialBetValueTennisTotal_O end  end as OddSpecialBetValueTotals_O1_5
					,case when Programme.SportId in (4,1) then   Programme.OddIdTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddIdTotalSpread_O else  Programme.OddIdTennisTotal_O end end  as OddIdTotals_O1_5
					,case when Programme.SportId in (4,1) then   Programme.OddValueTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddValueTotalSpread_O else Programme.OddValueTennisTotal_O end end as OddValueTotals_O1_5
					,case when Programme.SportId in (4,1) then    Programme.OddIdTotals_U1_5 
					 else case when Programme.SportId not in (5,20) then  Programme.OddIdTotalSpread_U else Programme.OddIdTennisTotal_U end end as OddIdTotals_U1_5
					,case when Programme.SportId in (4,1) then  Programme.OddValueTotals_U1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddValueTotalSpread_U else Programme.OddValueTennisTotal_U end end as OddValueTotals_U1_5

					,case when Programme.SportId=2 then Programme.OddSpecialBetValueDartFirstSet_1 else OddSpecialBetValueTotals_O2_5 end   as OddSpecialBetValueTotals_O2_5  -- Basket Home OVer/Under
					,case when Programme.SportId=2 then Programme.OddIdDartFirstSet_1 else Programme.OddIdTotals_O2_5 end  as OddIdTotals_O2_5
					,case when Programme.SportId=2 then Programme.OddValueDartFirstSet_1 else Programme.OddValueTotals_O2_5  end as OddValueTotals_O2_5
					,case when Programme.SportId=2 then Programme.OddIdDartFirstSet_2  else Programme.OddIdTotals_U2_5 end as OddIdTotals_U2_5
					,case when Programme.SportId=2 then Programme.OddValueDartFirstSet_2 else Programme.OddValueTotals_U2_5  end as OddValueTotals_U2_5


						,case when Programme.SportId=2 then Programme.OddSpecialBetValueDrawNoBet_1 else OddSpecialBetValueTotals_O3_5 end   as  OddSpecialBetValueTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddIdDrawNoBet_1 else Programme.OddIdTotals_O3_5 end    as OddIdTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddValueDrawNoBet_1 else Programme.OddValueTotals_O3_5  end  as OddValueTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddIdDrawNoBet_2  else Programme.OddIdTotals_U3_5 end as OddIdTotals_U3_5
					,case when Programme.SportId=2 then Programme.OddValueDrawNoBet_2 else Programme.OddValueTotals_U3_5  end as OddValueTotals_U3_5

					,Programme.OddSpecialBetValueTotals_O4_5
					,Programme.OddIdTotals_O4_5,Programme.OddValueTotals_O4_5
					,Programme.OddIdTotals_U4_5,Programme.OddValueTotals_U4_5


					,Programme.OddIdDouble_1 as OddIdDouble_1X,Programme.OddValueDouble_1 as OddValueDouble_1X
					,Programme.OddIdDouble_X as OddIdDouble_X2,Programme.OddValueDouble_X as OddValueDouble_X2
					,Programme.OddIdDouble_2 as OddIdDouble_12,Programme.OddValueDouble_2 as OddValueDouble_12

					,Programme.OddIdBoth_Y ,Programme.OddValueBoth_Y
					,Programme.OddIdBoth_N ,Programme.OddValueBoth_N

		,  Programme.OddIdFirstScore_1 as OddIdFirstScore_1 
					,  Programme.OddValueFirstScore_1  as OddValueFirstScore_1 
					,  Programme.OddIdFirstScore_None  as OddIdFirstScore_None 
					, Programme.OddValueFirstScore_None  as OddValueFirstScore_None 
							, Programme.OddIdFirstScore_2  as OddIdFirstScore_2 
					,  Programme.OddValueFirstScore_2   as OddValueFirstScore_2 

					,Programme.OddIdFirstHalf_1 ,Programme.OddValueFirstHalf_1
					,Programme.OddIdFirstHalf_X ,Programme.OddValueFirstHalf_X
					,Programme.OddIdFirstHalf_2 ,Programme.OddValueFirstHalf_2
					
					,Programme.OddSpecialBetValueFirstHalfTotalsO_0_5
					,Programme.OddIdFirstHalfTotalsO_0_5,Programme.OddValueFirstHalfTotalsO_0_5  
					,Programme.OddIdFirstHalfTotalsU_0_5,Programme.OddValueFirstHalfTotalsU_0_5

					,Programme.OddSpecialBetValueFirstHalfTotalsO_1_5
					,Programme.OddIdFirstHalfTotalsO_1_5,Programme.OddValueFirstHalfTotalsO_1_5  
					,Programme.OddIdFirstHalfTotalsU_1_5,Programme.OddValueFirstHalfTotalsU_1_5

					 ,Programme.OutComeTennisScore_20 as OddSpecialBetValueTennisScore_20
					 ,Programme.OddIdTennisScore_20,Programme.OddValueTennisScore_20

					 ,Programme.OutComeTennisScore_02 as OddSpecialBetValueTennisScore_02
					 ,Programme.OddIdTennisScore_02,Programme.OddValueTennisScore_02

					  ,Programme.OutComeTennisScore_12 as OddSpecialBetValueTennisScore_12
					 ,Programme.OddIdTennisScore_12,Programme.OddValueTennisScore_12

					   ,Programme.OutComeTennisScore_21 as OddSpecialBetValueTennisScore_21
					 ,Programme.OddIdTennisScore_21,Programme.OddValueTennisScore_21

					    ,Programme.OddSpecialBetValueTennisTotal_O as OddSpecialBetValueTennisTotal
					 ,Programme.OddIdTennisTotal_O,Programme.OddValueTennisTotal_O
					 ,Programme.OddIdTennisTotal_U,Programme.OddValueTennisTotal_U

					    ,Programme.OddSpecialBetValueTotalSpread_O as OddSpecialBetValueBasketTotal
					 ,Programme.OddIdTotalSpread_O,Programme.OddValueTotalSpread_O
					 ,Programme.OddIdTotalSpread_U,Programme.OddValueTotalSpread_U

					 ,Programme.OddIdBasketFirstHalf_1 ,Programme.OddValueBasketFirstHalf_1
					,Programme.OddIdBasketFirstHalf_X ,Programme.OddValueBasketFirstHalf_x
					,Programme.OddIdBasketFirstHalf_2 ,Programme.OddValueBasketFirstHalf_2

						,Programme.OddIdTennisFirstSet_1,Programme.OddValueTennisFirstSet_1
					,Programme.OddIdTennisFirstSet_2,Programme.OddValueTennisFirstSet_2
	 ,Parameter.Competitor.BetradarSuperId as HomeTeamId
	,Competitor_1.BetradarSuperId as Away
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
					,(SELECT     COUNT(DISTINCT OddsTypeId)
                                        FROM          Match.Odd with (nolock)
                                                      WHERE      (Match.Odd.MatchId = Programme.MatchId) AND (Match.Odd.StateId = 2) and Match.Odd.OddValue>1) as OddTypeCount , 
                     Programme.MatchDate as TournamentDate,cast(1 as bit)  as NeutralGround
					,null as HasStreaming,
					Language.[Parameter.Category].CategoryName
					,Parameter.Category.SequenceNumber,  SUBSTRING(LOWER(Parameter.Iso.IsoName2), 0, 3) AS IsoName
					,Parameter.Tournament.NewBetradarId as BetradarTournamentId
					,Programme.OddId1,CFF.OddValue1
					,Programme.OddId2,CFF.OddValue2
					,Programme.OddId3,CFF.OddValue3


								,  Programme.OddSpecialBetValueHadicap01_1  as OddSpecialBetValueHadicap01_1
					,Programme.OddIdHadicap01_1 as OddIdHadicap01_1
					,  Programme.OddValueHadicap01_1   as OddValueHadicap01_1
					, Programme.OddIdHadicap01_X  as OddIdHadicap01_X
					,  Programme.OddValueHadicap01_X  as OddValueHadicap01_X
					, Programme.OddIdHadicap01_2 as OddIdHadicap01_2 
					,  Programme.OddValueHadicap01_2 as OddValueHadicap01_2

					,Programme.OddSpecialBetValueHadicap02_1,Programme.OddIdHadicap02_1,Programme.OddValueHadicap02_1
					,Programme.OddIdHadicap02_X,Programme.OddValueHadicap02_X
					,Programme.OddIdHadicap02_2,Programme.OddValueHadicap02_2


					,Programme.OddSpecialBetValueHadicap10_1,Programme.OddIdHadicap10_1,Programme.OddValueHadicap10_1
					,Programme.OddIdHadicap10_X,Programme.OddValueHadicap10_X
					,Programme.OddIdHadicap10_2,Programme.OddValueHadicap10_2

					,Programme.OddSpecialBetValueHadicap20_1,Programme.OddIdHadicap20_1,Programme.OddValueHadicap20_1
					,Programme.OddIdHadicap20_X,Programme.OddValueHadicap20_X
					,Programme.OddIdHadicap20_2,Programme.OddValueHadicap20_2


						,case when Programme.SportId in (4,1) then Programme.OddSpecialBetValueTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddSpecialBetValueTotalSpread_O else Programme.OddSpecialBetValueTennisTotal_O end  end as OddSpecialBetValueTotals_O1_5
					,case when Programme.SportId in (4,1) then   Programme.OddIdTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddIdTotalSpread_O else  Programme.OddIdTennisTotal_O end end  as OddIdTotals_O1_5
					,case when Programme.SportId in (4,1) then   Programme.OddValueTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddValueTotalSpread_O else Programme.OddValueTennisTotal_O end end as OddValueTotals_O1_5
					,case when Programme.SportId in (4,1) then    Programme.OddIdTotals_U1_5 
					 else case when Programme.SportId not in (5,20) then  Programme.OddIdTotalSpread_U else Programme.OddIdTennisTotal_U end end as OddIdTotals_U1_5
					,case when Programme.SportId in (4,1) then  Programme.OddValueTotals_U1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddValueTotalSpread_U else Programme.OddValueTennisTotal_U end end as OddValueTotals_U1_5

					,case when Programme.SportId=2 then Programme.OddSpecialBetValueDartFirstSet_1 else OddSpecialBetValueTotals_O2_5 end   as OddSpecialBetValueTotals_O2_5  -- Basket Home OVer/Under
					,case when Programme.SportId=2 then Programme.OddIdDartFirstSet_1 else Programme.OddIdTotals_O2_5 end  as OddIdTotals_O2_5
					,case when Programme.SportId=2 then Programme.OddValueDartFirstSet_1 else Programme.OddValueTotals_O2_5  end as OddValueTotals_O2_5
					,case when Programme.SportId=2 then Programme.OddIdDartFirstSet_2  else Programme.OddIdTotals_U2_5 end as OddIdTotals_U2_5
					,case when Programme.SportId=2 then Programme.OddValueDartFirstSet_2 else Programme.OddValueTotals_U2_5  end as OddValueTotals_U2_5


						,case when Programme.SportId=2 then Programme.OddSpecialBetValueDrawNoBet_1 else OddSpecialBetValueTotals_O3_5 end   as  OddSpecialBetValueTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddIdDrawNoBet_1 else Programme.OddIdTotals_O3_5 end    as OddIdTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddValueDrawNoBet_1 else Programme.OddValueTotals_O3_5  end  as OddValueTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddIdDrawNoBet_2  else Programme.OddIdTotals_U3_5 end as OddIdTotals_U3_5
					,case when Programme.SportId=2 then Programme.OddValueDrawNoBet_2 else Programme.OddValueTotals_U3_5  end as OddValueTotals_U3_5

					,Programme.OddSpecialBetValueTotals_O4_5
					,Programme.OddIdTotals_O4_5,Programme.OddValueTotals_O4_5
					,Programme.OddIdTotals_U4_5,Programme.OddValueTotals_U4_5


					,Programme.OddIdDouble_1 as OddIdDouble_1X,Programme.OddValueDouble_1 as OddValueDouble_1X
					,Programme.OddIdDouble_X as OddIdDouble_X2,Programme.OddValueDouble_X as OddValueDouble_X2
					,Programme.OddIdDouble_2 as OddIdDouble_12,Programme.OddValueDouble_2 as OddValueDouble_12

					,Programme.OddIdBoth_Y ,Programme.OddValueBoth_Y
					,Programme.OddIdBoth_N ,Programme.OddValueBoth_N

			,  Programme.OddIdFirstScore_1 as OddIdFirstScore_1 
					,  Programme.OddValueFirstScore_1  as OddValueFirstScore_1 
					,  Programme.OddIdFirstScore_None  as OddIdFirstScore_None 
					, Programme.OddValueFirstScore_None  as OddValueFirstScore_None 
							, Programme.OddIdFirstScore_2  as OddIdFirstScore_2 
					,  Programme.OddValueFirstScore_2   as OddValueFirstScore_2 

					,Programme.OddIdFirstHalf_1 ,Programme.OddValueFirstHalf_1
					,Programme.OddIdFirstHalf_X ,Programme.OddValueFirstHalf_X
					,Programme.OddIdFirstHalf_2 ,Programme.OddValueFirstHalf_2
					
					,Programme.OddSpecialBetValueFirstHalfTotalsO_0_5
					,Programme.OddIdFirstHalfTotalsO_0_5,Programme.OddValueFirstHalfTotalsO_0_5  
					,Programme.OddIdFirstHalfTotalsU_0_5,Programme.OddValueFirstHalfTotalsU_0_5

					,Programme.OddSpecialBetValueFirstHalfTotalsO_1_5
					,Programme.OddIdFirstHalfTotalsO_1_5,Programme.OddValueFirstHalfTotalsO_1_5  
					,Programme.OddIdFirstHalfTotalsU_1_5,Programme.OddValueFirstHalfTotalsU_1_5

					 ,Programme.OutComeTennisScore_20 as OddSpecialBetValueTennisScore_20
					 ,Programme.OddIdTennisScore_20,Programme.OddValueTennisScore_20

					 ,Programme.OutComeTennisScore_02 as OddSpecialBetValueTennisScore_02
					 ,Programme.OddIdTennisScore_02,Programme.OddValueTennisScore_02

					  ,Programme.OutComeTennisScore_12 as OddSpecialBetValueTennisScore_12
					 ,Programme.OddIdTennisScore_12,Programme.OddValueTennisScore_12

					   ,Programme.OutComeTennisScore_21 as OddSpecialBetValueTennisScore_21
					 ,Programme.OddIdTennisScore_21,Programme.OddValueTennisScore_21

					    ,Programme.OddSpecialBetValueTennisTotal_O as OddSpecialBetValueTennisTotal
					 ,Programme.OddIdTennisTotal_O,Programme.OddValueTennisTotal_O
					 ,Programme.OddIdTennisTotal_U,Programme.OddValueTennisTotal_U

					    ,Programme.OddSpecialBetValueTotalSpread_O as OddSpecialBetValueBasketTotal
					 ,Programme.OddIdTotalSpread_O,Programme.OddValueTotalSpread_O
					 ,Programme.OddIdTotalSpread_U,Programme.OddValueTotalSpread_U

					 ,Programme.OddIdBasketFirstHalf_1 ,Programme.OddValueBasketFirstHalf_1
					,Programme.OddIdBasketFirstHalf_X ,Programme.OddValueBasketFirstHalf_x
					,Programme.OddIdBasketFirstHalf_2 ,Programme.OddValueBasketFirstHalf_2

						,Programme.OddIdTennisFirstSet_1,Programme.OddValueTennisFirstSet_1
					,Programme.OddIdTennisFirstSet_2,Programme.OddValueTennisFirstSet_2
	 ,Parameter.Competitor.BetradarSuperId as HomeTeamId
	,Competitor_1.BetradarSuperId as Away
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
				,(SELECT     COUNT(DISTINCT OddsTypeId)
                                        FROM          Match.Odd with (nolock)
                                                      WHERE      (Match.Odd.MatchId = Programme.MatchId) AND (Match.Odd.StateId = 2) and Match.Odd.OddValue>1) as OddTypeCount , 
                    Programme.MatchDate as TournamentDate,case when (select COUNT(*) from Live.[EventDetail] with (nolock) where BetradarMatchIds=Programme.BetradarMatchId)>0 then cast(1 as bit) else cast(0 as bit) end as NeutralGround
					,null as HasStreaming,
					Language.[Parameter.Category].CategoryName
					,Parameter.Category.SequenceNumber,  SUBSTRING(LOWER(Parameter.Iso.IsoName2), 0, 3) AS IsoName
					,Parameter.Tournament.NewBetradarId as BetradarTournamentId
					,Programme.OddId1,CFF.OddValue1
					,Programme.OddId2,CFF.OddValue2
					,Programme.OddId3,CFF.OddValue3


								,  Programme.OddSpecialBetValueHadicap01_1  as OddSpecialBetValueHadicap01_1
					,Programme.OddIdHadicap01_1 as OddIdHadicap01_1
					,  Programme.OddValueHadicap01_1   as OddValueHadicap01_1
					, Programme.OddIdHadicap01_X  as OddIdHadicap01_X
					,  Programme.OddValueHadicap01_X  as OddValueHadicap01_X
					, Programme.OddIdHadicap01_2 as OddIdHadicap01_2 
					,  Programme.OddValueHadicap01_2 as OddValueHadicap01_2

					,Programme.OddSpecialBetValueHadicap02_1,Programme.OddIdHadicap02_1,Programme.OddValueHadicap02_1
					,Programme.OddIdHadicap02_X,Programme.OddValueHadicap02_X
					,Programme.OddIdHadicap02_2,Programme.OddValueHadicap02_2


					,Programme.OddSpecialBetValueHadicap10_1,Programme.OddIdHadicap10_1,Programme.OddValueHadicap10_1
					,Programme.OddIdHadicap10_X,Programme.OddValueHadicap10_X
					,Programme.OddIdHadicap10_2,Programme.OddValueHadicap10_2

					,Programme.OddSpecialBetValueHadicap20_1,Programme.OddIdHadicap20_1,Programme.OddValueHadicap20_1
					,Programme.OddIdHadicap20_X,Programme.OddValueHadicap20_X
					,Programme.OddIdHadicap20_2,Programme.OddValueHadicap20_2


						,case when Programme.SportId in (4,1) then Programme.OddSpecialBetValueTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddSpecialBetValueTotalSpread_O else Programme.OddSpecialBetValueTennisTotal_O end  end as OddSpecialBetValueTotals_O1_5
					,case when Programme.SportId in (4,1) then   Programme.OddIdTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddIdTotalSpread_O else  Programme.OddIdTennisTotal_O end end  as OddIdTotals_O1_5
					,case when Programme.SportId in (4,1) then   Programme.OddValueTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddValueTotalSpread_O else Programme.OddValueTennisTotal_O end end as OddValueTotals_O1_5
					,case when Programme.SportId in (4,1) then    Programme.OddIdTotals_U1_5 
					 else case when Programme.SportId not in (5,20) then  Programme.OddIdTotalSpread_U else Programme.OddIdTennisTotal_U end end as OddIdTotals_U1_5
					,case when Programme.SportId in (4,1) then  Programme.OddValueTotals_U1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddValueTotalSpread_U else Programme.OddValueTennisTotal_U end end as OddValueTotals_U1_5

					,case when Programme.SportId=2 then Programme.OddSpecialBetValueDartFirstSet_1 else OddSpecialBetValueTotals_O2_5 end   as OddSpecialBetValueTotals_O2_5  -- Basket Home OVer/Under
					,case when Programme.SportId=2 then Programme.OddIdDartFirstSet_1 else Programme.OddIdTotals_O2_5 end  as OddIdTotals_O2_5
					,case when Programme.SportId=2 then Programme.OddValueDartFirstSet_1 else Programme.OddValueTotals_O2_5  end as OddValueTotals_O2_5
					,case when Programme.SportId=2 then Programme.OddIdDartFirstSet_2  else Programme.OddIdTotals_U2_5 end as OddIdTotals_U2_5
					,case when Programme.SportId=2 then Programme.OddValueDartFirstSet_2 else Programme.OddValueTotals_U2_5  end as OddValueTotals_U2_5


						,case when Programme.SportId=2 then Programme.OddSpecialBetValueDrawNoBet_1 else OddSpecialBetValueTotals_O3_5 end   as  OddSpecialBetValueTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddIdDrawNoBet_1 else Programme.OddIdTotals_O3_5 end    as OddIdTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddValueDrawNoBet_1 else Programme.OddValueTotals_O3_5  end  as OddValueTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddIdDrawNoBet_2  else Programme.OddIdTotals_U3_5 end as OddIdTotals_U3_5
					,case when Programme.SportId=2 then Programme.OddValueDrawNoBet_2 else Programme.OddValueTotals_U3_5  end as OddValueTotals_U3_5

					,Programme.OddSpecialBetValueTotals_O4_5
					,Programme.OddIdTotals_O4_5,Programme.OddValueTotals_O4_5
					,Programme.OddIdTotals_U4_5,Programme.OddValueTotals_U4_5

					,Programme.OddIdDouble_1 as OddIdDouble_1X,Programme.OddValueDouble_1 as OddValueDouble_1X
					,Programme.OddIdDouble_X as OddIdDouble_X2,Programme.OddValueDouble_X as OddValueDouble_X2
					,Programme.OddIdDouble_2 as OddIdDouble_12,Programme.OddValueDouble_2 as OddValueDouble_12

					,Programme.OddIdBoth_Y ,Programme.OddValueBoth_Y
					,Programme.OddIdBoth_N ,Programme.OddValueBoth_N

					,  Programme.OddIdFirstScore_1 as OddIdFirstScore_1 
					,  Programme.OddValueFirstScore_1  as OddValueFirstScore_1 
					,  Programme.OddIdFirstScore_None  as OddIdFirstScore_None 
					, Programme.OddValueFirstScore_None  as OddValueFirstScore_None 
							, Programme.OddIdFirstScore_2  as OddIdFirstScore_2 
					,  Programme.OddValueFirstScore_2   as OddValueFirstScore_2 

					,Programme.OddIdFirstHalf_1 ,Programme.OddValueFirstHalf_1
					,Programme.OddIdFirstHalf_X ,Programme.OddValueFirstHalf_X
					,Programme.OddIdFirstHalf_2 ,Programme.OddValueFirstHalf_2
					
					,Programme.OddSpecialBetValueFirstHalfTotalsO_0_5
					,Programme.OddIdFirstHalfTotalsO_0_5,Programme.OddValueFirstHalfTotalsO_0_5  
					,Programme.OddIdFirstHalfTotalsU_0_5,Programme.OddValueFirstHalfTotalsU_0_5

					,Programme.OddSpecialBetValueFirstHalfTotalsO_1_5
					,Programme.OddIdFirstHalfTotalsO_1_5,Programme.OddValueFirstHalfTotalsO_1_5  
					,Programme.OddIdFirstHalfTotalsU_1_5,Programme.OddValueFirstHalfTotalsU_1_5

					 ,Programme.OutComeTennisScore_20 as OddSpecialBetValueTennisScore_20
					 ,Programme.OddIdTennisScore_20,Programme.OddValueTennisScore_20

					 ,Programme.OutComeTennisScore_02 as OddSpecialBetValueTennisScore_02
					 ,Programme.OddIdTennisScore_02,Programme.OddValueTennisScore_02

					  ,Programme.OutComeTennisScore_12 as OddSpecialBetValueTennisScore_12
					 ,Programme.OddIdTennisScore_12,Programme.OddValueTennisScore_12

					   ,Programme.OutComeTennisScore_21 as OddSpecialBetValueTennisScore_21
					 ,Programme.OddIdTennisScore_21,Programme.OddValueTennisScore_21

					    ,Programme.OddSpecialBetValueTennisTotal_O as OddSpecialBetValueTennisTotal
					 ,Programme.OddIdTennisTotal_O,Programme.OddValueTennisTotal_O
					 ,Programme.OddIdTennisTotal_U,Programme.OddValueTennisTotal_U

					    ,Programme.OddSpecialBetValueTotalSpread_O as OddSpecialBetValueBasketTotal
					 ,Programme.OddIdTotalSpread_O,Programme.OddValueTotalSpread_O
					 ,Programme.OddIdTotalSpread_U,Programme.OddValueTotalSpread_U

					 ,Programme.OddIdBasketFirstHalf_1 ,Programme.OddValueBasketFirstHalf_1
					,Programme.OddIdBasketFirstHalf_X ,Programme.OddValueBasketFirstHalf_x
					,Programme.OddIdBasketFirstHalf_2 ,Programme.OddValueBasketFirstHalf_2

						,Programme.OddIdTennisFirstSet_1,Programme.OddValueTennisFirstSet_1
					,Programme.OddIdTennisFirstSet_2,Programme.OddValueTennisFirstSet_2
	 ,Parameter.Competitor.BetradarSuperId as HomeTeamId
	,Competitor_1.BetradarSuperId as Away
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
					,(SELECT     COUNT(DISTINCT OddsTypeId)
                                        FROM          Match.Odd with (nolock)
                                                      WHERE      (Match.Odd.MatchId = Programme.MatchId) AND (Match.Odd.StateId = 2) and Match.Odd.OddValue>1) as OddTypeCount , 
                    Programme.MatchDate as TournamentDate,case when (select COUNT(*) from Live.[EventDetail] with (nolock) where BetradarMatchIds=Programme.BetradarMatchId)>0 then cast(1 as bit) else cast(0 as bit) end as NeutralGround
					,null as HasStreaming,
					Language.[Parameter.Category].CategoryName
					,Parameter.Category.SequenceNumber,  SUBSTRING(LOWER(Parameter.Iso.IsoName2), 0, 3) AS IsoName
					,Parameter.Tournament.NewBetradarId as BetradarTournamentId
					,Programme.OddId1,CFF.OddValue1
					,Programme.OddId2,CFF.OddValue2
					,Programme.OddId3,Programme.OddValue3


						,  Programme.OddSpecialBetValueHadicap01_1  as OddSpecialBetValueHadicap01_1
					,Programme.OddIdHadicap01_1 as OddIdHadicap01_1
					,  Programme.OddValueHadicap01_1   as OddValueHadicap01_1
					, Programme.OddIdHadicap01_X  as OddIdHadicap01_X
					,  Programme.OddValueHadicap01_X  as OddValueHadicap01_X
					, Programme.OddIdHadicap01_2 as OddIdHadicap01_2 
					,  Programme.OddValueHadicap01_2 as OddValueHadicap01_2

					,Programme.OddSpecialBetValueHadicap02_1,Programme.OddIdHadicap02_1,Programme.OddValueHadicap02_1
					,Programme.OddIdHadicap02_X,Programme.OddValueHadicap02_X
					,Programme.OddIdHadicap02_2,Programme.OddValueHadicap02_2


					,Programme.OddSpecialBetValueHadicap10_1,Programme.OddIdHadicap10_1,Programme.OddValueHadicap10_1
					,Programme.OddIdHadicap10_X,Programme.OddValueHadicap10_X
					,Programme.OddIdHadicap10_2,Programme.OddValueHadicap10_2

					,Programme.OddSpecialBetValueHadicap20_1,Programme.OddIdHadicap20_1,Programme.OddValueHadicap20_1
					,Programme.OddIdHadicap20_X,Programme.OddValueHadicap20_X
					,Programme.OddIdHadicap20_2,Programme.OddValueHadicap20_2


						,case when Programme.SportId in (4,1) then Programme.OddSpecialBetValueTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddSpecialBetValueTotalSpread_O else Programme.OddSpecialBetValueTennisTotal_O end  end as OddSpecialBetValueTotals_O1_5
					,case when Programme.SportId in (4,1) then   Programme.OddIdTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddIdTotalSpread_O else  Programme.OddIdTennisTotal_O end end  as OddIdTotals_O1_5
					,case when Programme.SportId in (4,1) then   Programme.OddValueTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddValueTotalSpread_O else Programme.OddValueTennisTotal_O end end as OddValueTotals_O1_5
					,case when Programme.SportId in (4,1) then    Programme.OddIdTotals_U1_5 
					 else case when Programme.SportId not in (5,20) then  Programme.OddIdTotalSpread_U else Programme.OddIdTennisTotal_U end end as OddIdTotals_U1_5
					,case when Programme.SportId in (4,1) then  Programme.OddValueTotals_U1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddValueTotalSpread_U else Programme.OddValueTennisTotal_U end end as OddValueTotals_U1_5

					,case when Programme.SportId=2 then Programme.OddSpecialBetValueDartFirstSet_1 else OddSpecialBetValueTotals_O2_5 end   as OddSpecialBetValueTotals_O2_5  -- Basket Home OVer/Under
					,case when Programme.SportId=2 then Programme.OddIdDartFirstSet_1 else Programme.OddIdTotals_O2_5 end  as OddIdTotals_O2_5
					,case when Programme.SportId=2 then Programme.OddValueDartFirstSet_1 else Programme.OddValueTotals_O2_5  end as OddValueTotals_O2_5
					,case when Programme.SportId=2 then Programme.OddIdDartFirstSet_2  else Programme.OddIdTotals_U2_5 end as OddIdTotals_U2_5
					,case when Programme.SportId=2 then Programme.OddValueDartFirstSet_2 else Programme.OddValueTotals_U2_5  end as OddValueTotals_U2_5


						,case when Programme.SportId=2 then Programme.OddSpecialBetValueDrawNoBet_1 else OddSpecialBetValueTotals_O3_5 end   as  OddSpecialBetValueTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddIdDrawNoBet_1 else Programme.OddIdTotals_O3_5 end    as OddIdTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddValueDrawNoBet_1 else Programme.OddValueTotals_O3_5  end  as OddValueTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddIdDrawNoBet_2  else Programme.OddIdTotals_U3_5 end as OddIdTotals_U3_5
					,case when Programme.SportId=2 then Programme.OddValueDrawNoBet_2 else Programme.OddValueTotals_U3_5  end as OddValueTotals_U3_5

					,Programme.OddSpecialBetValueTotals_O4_5
					,Programme.OddIdTotals_O4_5,Programme.OddValueTotals_O4_5
					,Programme.OddIdTotals_U4_5,Programme.OddValueTotals_U4_5



					,Programme.OddIdDouble_1 as OddIdDouble_1X,Programme.OddValueDouble_1 as OddValueDouble_1X
					,Programme.OddIdDouble_X as OddIdDouble_X2,Programme.OddValueDouble_X as OddValueDouble_X2
					,Programme.OddIdDouble_2 as OddIdDouble_12,Programme.OddValueDouble_2 as OddValueDouble_12

					,Programme.OddIdBoth_Y ,Programme.OddValueBoth_Y
					,Programme.OddIdBoth_N ,Programme.OddValueBoth_N

					,  Programme.OddIdFirstScore_1 as OddIdFirstScore_1 
					,  Programme.OddValueFirstScore_1  as OddValueFirstScore_1 
					,  Programme.OddIdFirstScore_None  as OddIdFirstScore_None 
					, Programme.OddValueFirstScore_None  as OddValueFirstScore_None 
							, Programme.OddIdFirstScore_2  as OddIdFirstScore_2 
					,  Programme.OddValueFirstScore_2   as OddValueFirstScore_2 

					,Programme.OddIdFirstHalf_1 ,Programme.OddValueFirstHalf_1
					,Programme.OddIdFirstHalf_X ,Programme.OddValueFirstHalf_X
					,Programme.OddIdFirstHalf_2 ,Programme.OddValueFirstHalf_2
					
					,Programme.OddSpecialBetValueFirstHalfTotalsO_0_5
					,Programme.OddIdFirstHalfTotalsO_0_5,Programme.OddValueFirstHalfTotalsO_0_5  
					,Programme.OddIdFirstHalfTotalsU_0_5,Programme.OddValueFirstHalfTotalsU_0_5

					,Programme.OddSpecialBetValueFirstHalfTotalsO_1_5
					,Programme.OddIdFirstHalfTotalsO_1_5,Programme.OddValueFirstHalfTotalsO_1_5  
					,Programme.OddIdFirstHalfTotalsU_1_5,Programme.OddValueFirstHalfTotalsU_1_5

					 ,Programme.OutComeTennisScore_20 as OddSpecialBetValueTennisScore_20
					 ,Programme.OddIdTennisScore_20,Programme.OddValueTennisScore_20

					 ,Programme.OutComeTennisScore_02 as OddSpecialBetValueTennisScore_02
					 ,Programme.OddIdTennisScore_02,Programme.OddValueTennisScore_02

					  ,Programme.OutComeTennisScore_12 as OddSpecialBetValueTennisScore_12
					 ,Programme.OddIdTennisScore_12,Programme.OddValueTennisScore_12

					   ,Programme.OutComeTennisScore_21 as OddSpecialBetValueTennisScore_21
					 ,Programme.OddIdTennisScore_21,Programme.OddValueTennisScore_21

					    ,Programme.OddSpecialBetValueTennisTotal_O as OddSpecialBetValueTennisTotal
					 ,Programme.OddIdTennisTotal_O,Programme.OddValueTennisTotal_O
					 ,Programme.OddIdTennisTotal_U,Programme.OddValueTennisTotal_U

					    ,Programme.OddSpecialBetValueTotalSpread_O as OddSpecialBetValueBasketTotal
					 ,Programme.OddIdTotalSpread_O,Programme.OddValueTotalSpread_O
					 ,Programme.OddIdTotalSpread_U,Programme.OddValueTotalSpread_U

					 ,Programme.OddIdBasketFirstHalf_1 ,Programme.OddValueBasketFirstHalf_1
					,Programme.OddIdBasketFirstHalf_X ,Programme.OddValueBasketFirstHalf_x
					,Programme.OddIdBasketFirstHalf_2 ,Programme.OddValueBasketFirstHalf_2

						,Programme.OddIdTennisFirstSet_1,Programme.OddValueTennisFirstSet_1
					,Programme.OddIdTennisFirstSet_2,Programme.OddValueTennisFirstSet_2
	 ,Parameter.Competitor.BetradarSuperId as HomeTeamId
	,Competitor_1.BetradarSuperId as Away
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
			set @EventDate=DATEADD(DAY,25,GETDATE())
 if (@CategoryId=-1) -- Takımın maçlarını getriyoruz. 
	begin
	 
			SELECT   top 50  Programme.BetradarMatchId,Programme.MatchId, Programme.MatchDate,Language.[Parameter.Tournament].TournamentName,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetitor_1.CompetitorName AS EventName, 
                    Language.[Parameter.Sport].SportName,Programme.TournamentId,Programme.SportId,Parameter.Category.CategoryId,Parameter.Sport.SportName as SportNameOrginal
					, (SELECT     COUNT(DISTINCT Match.Odd.OddsTypeId)
                                        FROM          Match.Odd with (nolock)
                                                      WHERE      (MatchId = Programme.MatchId) AND (StateId = 2)) as OddTypeCount, 
                     Programme.MatchDate as TournamentDate,case when (select COUNT(*) from Live.[EventDetail] with (nolock) where BetradarMatchIds=Programme.BetradarMatchId)>0 then cast(1 as bit) else cast(0 as bit) end as NeutralGround
					,null as HasStreaming,
					Language.[Parameter.Category].CategoryName
					,Parameter.Tournament.SequenceNumber,  SUBSTRING(LOWER(Parameter.Iso.IsoName2), 0, 3) AS IsoName
					,Parameter.Tournament.NewBetradarId as BetradarTournamentId
					,Programme.OddId1,CFF.OddValue1
					,Programme.OddId2,CFF.OddValue2
					,Programme.OddId3,CFF.OddValue3

						,  Programme.OddSpecialBetValueHadicap01_1  as OddSpecialBetValueHadicap01_1
					,Programme.OddIdHadicap01_1 as OddIdHadicap01_1
					,  Programme.OddValueHadicap01_1   as OddValueHadicap01_1
					, Programme.OddIdHadicap01_X  as OddIdHadicap01_X
					,  Programme.OddValueHadicap01_X  as OddValueHadicap01_X
					, Programme.OddIdHadicap01_2 as OddIdHadicap01_2 
					,  Programme.OddValueHadicap01_2 as OddValueHadicap01_2

					,Programme.OddSpecialBetValueHadicap02_1,Programme.OddIdHadicap02_1,Programme.OddValueHadicap02_1
					,Programme.OddIdHadicap02_X,Programme.OddValueHadicap02_X
					,Programme.OddIdHadicap02_2,Programme.OddValueHadicap02_2


					,Programme.OddSpecialBetValueHadicap10_1,Programme.OddIdHadicap10_1,Programme.OddValueHadicap10_1
					,Programme.OddIdHadicap10_X,Programme.OddValueHadicap10_X
					,Programme.OddIdHadicap10_2,Programme.OddValueHadicap10_2

					,Programme.OddSpecialBetValueHadicap20_1,Programme.OddIdHadicap20_1,Programme.OddValueHadicap20_1
					,Programme.OddIdHadicap20_X,Programme.OddValueHadicap20_X
					,Programme.OddIdHadicap20_2,Programme.OddValueHadicap20_2

					
						,case when Programme.SportId in (4,1) then Programme.OddSpecialBetValueTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddSpecialBetValueTotalSpread_O else Programme.OddSpecialBetValueTennisTotal_O end  end as OddSpecialBetValueTotals_O1_5
					,case when Programme.SportId in (4,1) then   Programme.OddIdTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddIdTotalSpread_O else  Programme.OddIdTennisTotal_O end end  as OddIdTotals_O1_5
					,case when Programme.SportId in (4,1) then   Programme.OddValueTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddValueTotalSpread_O else Programme.OddValueTennisTotal_O end end as OddValueTotals_O1_5
					,case when Programme.SportId in (4,1) then    Programme.OddIdTotals_U1_5 
					 else case when Programme.SportId not in (5,20) then  Programme.OddIdTotalSpread_U else Programme.OddIdTennisTotal_U end end as OddIdTotals_U1_5
					,case when Programme.SportId in (4,1) then  Programme.OddValueTotals_U1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddValueTotalSpread_U else Programme.OddValueTennisTotal_U end end as OddValueTotals_U1_5

					,case when Programme.SportId=2 then Programme.OddSpecialBetValueDartFirstSet_1 else OddSpecialBetValueTotals_O2_5 end   as OddSpecialBetValueTotals_O2_5  -- Basket Home OVer/Under
					,case when Programme.SportId=2 then Programme.OddIdDartFirstSet_1 else Programme.OddIdTotals_O2_5 end  as OddIdTotals_O2_5
					,case when Programme.SportId=2 then Programme.OddValueDartFirstSet_1 else Programme.OddValueTotals_O2_5  end as OddValueTotals_O2_5
					,case when Programme.SportId=2 then Programme.OddIdDartFirstSet_2  else Programme.OddIdTotals_U2_5 end as OddIdTotals_U2_5
					,case when Programme.SportId=2 then Programme.OddValueDartFirstSet_2 else Programme.OddValueTotals_U2_5  end as OddValueTotals_U2_5


						,case when Programme.SportId=2 then Programme.OddSpecialBetValueDrawNoBet_1 else OddSpecialBetValueTotals_O3_5 end   as  OddSpecialBetValueTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddIdDrawNoBet_1 else Programme.OddIdTotals_O3_5 end    as OddIdTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddValueDrawNoBet_1 else Programme.OddValueTotals_O3_5  end  as OddValueTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddIdDrawNoBet_2  else Programme.OddIdTotals_U3_5 end as OddIdTotals_U3_5
					,case when Programme.SportId=2 then Programme.OddValueDrawNoBet_2 else Programme.OddValueTotals_U3_5  end as OddValueTotals_U3_5

					,Programme.OddSpecialBetValueTotals_O4_5
					,Programme.OddIdTotals_O4_5,Programme.OddValueTotals_O4_5
					,Programme.OddIdTotals_U4_5,Programme.OddValueTotals_U4_5



					,Programme.OddIdDouble_1 as OddIdDouble_1X,Programme.OddValueDouble_1 as OddValueDouble_1X
					,Programme.OddIdDouble_X as OddIdDouble_X2,Programme.OddValueDouble_X as OddValueDouble_X2
					,Programme.OddIdDouble_2 as OddIdDouble_12,Programme.OddValueDouble_2 as OddValueDouble_12

					,Programme.OddIdBoth_Y ,Programme.OddValueBoth_Y
					,Programme.OddIdBoth_N ,Programme.OddValueBoth_N

					,  Programme.OddIdFirstScore_1 as OddIdFirstScore_1 
					,  Programme.OddValueFirstScore_1  as OddValueFirstScore_1 
					,  Programme.OddIdFirstScore_None  as OddIdFirstScore_None 
					, Programme.OddValueFirstScore_None  as OddValueFirstScore_None 
							, Programme.OddIdFirstScore_2  as OddIdFirstScore_2 
					,  Programme.OddValueFirstScore_2   as OddValueFirstScore_2 

					,Programme.OddIdFirstHalf_1 ,Programme.OddValueFirstHalf_1
					,Programme.OddIdFirstHalf_X ,Programme.OddValueFirstHalf_X
					,Programme.OddIdFirstHalf_2 ,Programme.OddValueFirstHalf_2
					
					,Programme.OddSpecialBetValueFirstHalfTotalsO_0_5
					,Programme.OddIdFirstHalfTotalsO_0_5,Programme.OddValueFirstHalfTotalsO_0_5  
					,Programme.OddIdFirstHalfTotalsU_0_5,Programme.OddValueFirstHalfTotalsU_0_5

					,Programme.OddSpecialBetValueFirstHalfTotalsO_1_5
					,Programme.OddIdFirstHalfTotalsO_1_5,Programme.OddValueFirstHalfTotalsO_1_5  
					,Programme.OddIdFirstHalfTotalsU_1_5,Programme.OddValueFirstHalfTotalsU_1_5

					 ,Programme.OutComeTennisScore_20 as OddSpecialBetValueTennisScore_20
					 ,Programme.OddIdTennisScore_20,Programme.OddValueTennisScore_20

					 ,Programme.OutComeTennisScore_02 as OddSpecialBetValueTennisScore_02
					 ,Programme.OddIdTennisScore_02,Programme.OddValueTennisScore_02

					  ,Programme.OutComeTennisScore_12 as OddSpecialBetValueTennisScore_12
					 ,Programme.OddIdTennisScore_12,Programme.OddValueTennisScore_12

					   ,Programme.OutComeTennisScore_21 as OddSpecialBetValueTennisScore_21
					 ,Programme.OddIdTennisScore_21,Programme.OddValueTennisScore_21

					    ,Programme.OddSpecialBetValueTennisTotal_O as OddSpecialBetValueTennisTotal
					 ,Programme.OddIdTennisTotal_O,Programme.OddValueTennisTotal_O
					 ,Programme.OddIdTennisTotal_U,Programme.OddValueTennisTotal_U

					    ,Programme.OddSpecialBetValueTotalSpread_O as OddSpecialBetValueBasketTotal
					 ,Programme.OddIdTotalSpread_O,Programme.OddValueTotalSpread_O
					 ,Programme.OddIdTotalSpread_U,Programme.OddValueTotalSpread_U

					 ,Programme.OddIdBasketFirstHalf_1 ,Programme.OddValueBasketFirstHalf_1
					,Programme.OddIdBasketFirstHalf_X ,Programme.OddValueBasketFirstHalf_x
					,Programme.OddIdBasketFirstHalf_2 ,Programme.OddValueBasketFirstHalf_2

						,Programme.OddIdTennisFirstSet_1,Programme.OddValueTennisFirstSet_1
					,Programme.OddIdTennisFirstSet_2,Programme.OddValueTennisFirstSet_2
	 ,Parameter.Competitor.BetradarSuperId as HomeTeamId
	,Competitor_1.BetradarSuperId as Away
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
						 where Programme.MatchDate> GETDATE()
						 and (Parameter.Competitor.BetradarSuperId=@TournamentId or Competitor_1.BetradarSuperId=@TournamentId)  and Parameter.Sport.IsActive=1
		end
else if (@CategoryId=-2) -- Takımın maçlarını getriyoruz. 
	begin
	 
			SELECT   top 50  Programme.BetradarMatchId,Programme.MatchId, Programme.MatchDate,Language.[Parameter.Tournament].TournamentName,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetitor_1.CompetitorName AS EventName, 
                    Language.[Parameter.Sport].SportName,Programme.TournamentId,Programme.SportId,Parameter.Category.CategoryId,Parameter.Sport.SportName as SportNameOrginal
					, (SELECT     COUNT(DISTINCT Match.Odd.OddsTypeId)
                                        FROM          Match.Odd with (nolock)
                                                      WHERE      (MatchId = Programme.MatchId) AND (StateId = 2)) as OddTypeCount, 
                     Programme.MatchDate as TournamentDate,case when (select COUNT(*) from Live.[EventDetail] with (nolock) where BetradarMatchIds=Programme.BetradarMatchId)>0 then cast(1 as bit) else cast(0 as bit) end as NeutralGround
					,null as HasStreaming,
					Language.[Parameter.Category].CategoryName
					,Parameter.Tournament.SequenceNumber,  SUBSTRING(LOWER(Parameter.Iso.IsoName2), 0, 3) AS IsoName
					,Parameter.Tournament.NewBetradarId as BetradarTournamentId
					,Programme.OddId1,CFF.OddValue1
					,Programme.OddId2,CFF.OddValue2
					,Programme.OddId3,CFF.OddValue3

						,  Programme.OddSpecialBetValueHadicap01_1  as OddSpecialBetValueHadicap01_1
					,Programme.OddIdHadicap01_1 as OddIdHadicap01_1
					,  Programme.OddValueHadicap01_1   as OddValueHadicap01_1
					, Programme.OddIdHadicap01_X  as OddIdHadicap01_X
					,  Programme.OddValueHadicap01_X  as OddValueHadicap01_X
					, Programme.OddIdHadicap01_2 as OddIdHadicap01_2 
					,  Programme.OddValueHadicap01_2 as OddValueHadicap01_2

					,Programme.OddSpecialBetValueHadicap02_1,Programme.OddIdHadicap02_1,Programme.OddValueHadicap02_1
					,Programme.OddIdHadicap02_X,Programme.OddValueHadicap02_X
					,Programme.OddIdHadicap02_2,Programme.OddValueHadicap02_2


					,Programme.OddSpecialBetValueHadicap10_1,Programme.OddIdHadicap10_1,Programme.OddValueHadicap10_1
					,Programme.OddIdHadicap10_X,Programme.OddValueHadicap10_X
					,Programme.OddIdHadicap10_2,Programme.OddValueHadicap10_2

					,Programme.OddSpecialBetValueHadicap20_1,Programme.OddIdHadicap20_1,Programme.OddValueHadicap20_1
					,Programme.OddIdHadicap20_X,Programme.OddValueHadicap20_X
					,Programme.OddIdHadicap20_2,Programme.OddValueHadicap20_2

					
						,case when Programme.SportId in (4,1) then Programme.OddSpecialBetValueTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddSpecialBetValueTotalSpread_O else Programme.OddSpecialBetValueTennisTotal_O end  end as OddSpecialBetValueTotals_O1_5
					,case when Programme.SportId in (4,1) then   Programme.OddIdTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddIdTotalSpread_O else  Programme.OddIdTennisTotal_O end end  as OddIdTotals_O1_5
					,case when Programme.SportId in (4,1) then   Programme.OddValueTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddValueTotalSpread_O else Programme.OddValueTennisTotal_O end end as OddValueTotals_O1_5
					,case when Programme.SportId in (4,1) then    Programme.OddIdTotals_U1_5 
					 else case when Programme.SportId not in (5,20) then  Programme.OddIdTotalSpread_U else Programme.OddIdTennisTotal_U end end as OddIdTotals_U1_5
					,case when Programme.SportId in (4,1) then  Programme.OddValueTotals_U1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddValueTotalSpread_U else Programme.OddValueTennisTotal_U end end as OddValueTotals_U1_5

					,case when Programme.SportId=2 then Programme.OddSpecialBetValueDartFirstSet_1 else OddSpecialBetValueTotals_O2_5 end   as OddSpecialBetValueTotals_O2_5  -- Basket Home OVer/Under
					,case when Programme.SportId=2 then Programme.OddIdDartFirstSet_1 else Programme.OddIdTotals_O2_5 end  as OddIdTotals_O2_5
					,case when Programme.SportId=2 then Programme.OddValueDartFirstSet_1 else Programme.OddValueTotals_O2_5  end as OddValueTotals_O2_5
					,case when Programme.SportId=2 then Programme.OddIdDartFirstSet_2  else Programme.OddIdTotals_U2_5 end as OddIdTotals_U2_5
					,case when Programme.SportId=2 then Programme.OddValueDartFirstSet_2 else Programme.OddValueTotals_U2_5  end as OddValueTotals_U2_5


						,case when Programme.SportId=2 then Programme.OddSpecialBetValueDrawNoBet_1 else OddSpecialBetValueTotals_O3_5 end   as  OddSpecialBetValueTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddIdDrawNoBet_1 else Programme.OddIdTotals_O3_5 end    as OddIdTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddValueDrawNoBet_1 else Programme.OddValueTotals_O3_5  end  as OddValueTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddIdDrawNoBet_2  else Programme.OddIdTotals_U3_5 end as OddIdTotals_U3_5
					,case when Programme.SportId=2 then Programme.OddValueDrawNoBet_2 else Programme.OddValueTotals_U3_5  end as OddValueTotals_U3_5

					,Programme.OddSpecialBetValueTotals_O4_5
					,Programme.OddIdTotals_O4_5,Programme.OddValueTotals_O4_5
					,Programme.OddIdTotals_U4_5,Programme.OddValueTotals_U4_5



					,Programme.OddIdDouble_1 as OddIdDouble_1X,Programme.OddValueDouble_1 as OddValueDouble_1X
					,Programme.OddIdDouble_X as OddIdDouble_X2,Programme.OddValueDouble_X as OddValueDouble_X2
					,Programme.OddIdDouble_2 as OddIdDouble_12,Programme.OddValueDouble_2 as OddValueDouble_12

					,Programme.OddIdBoth_Y ,Programme.OddValueBoth_Y
					,Programme.OddIdBoth_N ,Programme.OddValueBoth_N

					,  Programme.OddIdFirstScore_1 as OddIdFirstScore_1 
					,  Programme.OddValueFirstScore_1  as OddValueFirstScore_1 
					,  Programme.OddIdFirstScore_None  as OddIdFirstScore_None 
					, Programme.OddValueFirstScore_None  as OddValueFirstScore_None 
							, Programme.OddIdFirstScore_2  as OddIdFirstScore_2 
					,  Programme.OddValueFirstScore_2   as OddValueFirstScore_2 

					,Programme.OddIdFirstHalf_1 ,Programme.OddValueFirstHalf_1
					,Programme.OddIdFirstHalf_X ,Programme.OddValueFirstHalf_X
					,Programme.OddIdFirstHalf_2 ,Programme.OddValueFirstHalf_2
					
					,Programme.OddSpecialBetValueFirstHalfTotalsO_0_5
					,Programme.OddIdFirstHalfTotalsO_0_5,Programme.OddValueFirstHalfTotalsO_0_5  
					,Programme.OddIdFirstHalfTotalsU_0_5,Programme.OddValueFirstHalfTotalsU_0_5

					,Programme.OddSpecialBetValueFirstHalfTotalsO_1_5
					,Programme.OddIdFirstHalfTotalsO_1_5,Programme.OddValueFirstHalfTotalsO_1_5  
					,Programme.OddIdFirstHalfTotalsU_1_5,Programme.OddValueFirstHalfTotalsU_1_5

					 ,Programme.OutComeTennisScore_20 as OddSpecialBetValueTennisScore_20
					 ,Programme.OddIdTennisScore_20,Programme.OddValueTennisScore_20

					 ,Programme.OutComeTennisScore_02 as OddSpecialBetValueTennisScore_02
					 ,Programme.OddIdTennisScore_02,Programme.OddValueTennisScore_02

					  ,Programme.OutComeTennisScore_12 as OddSpecialBetValueTennisScore_12
					 ,Programme.OddIdTennisScore_12,Programme.OddValueTennisScore_12

					   ,Programme.OutComeTennisScore_21 as OddSpecialBetValueTennisScore_21
					 ,Programme.OddIdTennisScore_21,Programme.OddValueTennisScore_21

					    ,Programme.OddSpecialBetValueTennisTotal_O as OddSpecialBetValueTennisTotal
					 ,Programme.OddIdTennisTotal_O,Programme.OddValueTennisTotal_O
					 ,Programme.OddIdTennisTotal_U,Programme.OddValueTennisTotal_U

					    ,Programme.OddSpecialBetValueTotalSpread_O as OddSpecialBetValueBasketTotal
					 ,Programme.OddIdTotalSpread_O,Programme.OddValueTotalSpread_O
					 ,Programme.OddIdTotalSpread_U,Programme.OddValueTotalSpread_U

					 ,Programme.OddIdBasketFirstHalf_1 ,Programme.OddValueBasketFirstHalf_1
					,Programme.OddIdBasketFirstHalf_X ,Programme.OddValueBasketFirstHalf_x
					,Programme.OddIdBasketFirstHalf_2 ,Programme.OddValueBasketFirstHalf_2

						,Programme.OddIdTennisFirstSet_1,Programme.OddValueTennisFirstSet_1
					,Programme.OddIdTennisFirstSet_2,Programme.OddValueTennisFirstSet_2
	 ,Parameter.Competitor.BetradarSuperId as HomeTeamId
	,Competitor_1.BetradarSuperId as Away
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
						 where Programme.MatchDate> GETDATE()
						 --case when (select COUNT(*) from Live.[Event] with (nolock) where BetradarMatchId=Programme.BetradarMatchId)>0 then DATEADD(MINUTE,12, GETDATE()) else  DATEADD(MINUTE,5, GETDATE()) end 
						-- and  (cast(Programme.MatchDate as date)< case when Parameter.Tournament.IsPopularWeb=0 then   cast(@EventDate as date) else cast(DATEADD(MONTH,5,@EventDate) as date) end   )
						 and (Parameter.Competitor.BetradarSuperId in (Select TeamId from [Tip_CoreDB].Customer.Team where CustomerId=@TournamentId) 
						 or Competitor_1.BetradarSuperId in  (Select TeamId from [Tip_CoreDB].Customer.Team where CustomerId=@TournamentId))  and Parameter.Sport.IsActive=1
		end
else if (@TournamentId>0)
	begin
	 
			SELECT   top 50  Programme.BetradarMatchId,Programme.MatchId, Programme.MatchDate,Language.[Parameter.Tournament].TournamentName,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetitor_1.CompetitorName AS EventName, 
                    Language.[Parameter.Sport].SportName,Programme.TournamentId,Programme.SportId,Parameter.Category.CategoryId,Parameter.Sport.SportName as SportNameOrginal
					, (SELECT     COUNT(DISTINCT Match.Odd.OddsTypeId)
                                        FROM          Match.Odd with (nolock)
                                                      WHERE      (MatchId = Programme.MatchId) AND (StateId = 2)) as OddTypeCount, 
                     Programme.MatchDate as TournamentDate,case when (select COUNT(*) from Live.[EventDetail] with (nolock) where BetradarMatchIds=Programme.BetradarMatchId)>0 then cast(1 as bit) else cast(0 as bit) end as NeutralGround
					,null as HasStreaming,
					Language.[Parameter.Category].CategoryName
					,Parameter.Tournament.SequenceNumber,  SUBSTRING(LOWER(Parameter.Iso.IsoName2), 0, 3) AS IsoName
					,Parameter.Tournament.NewBetradarId as BetradarTournamentId
					,Programme.OddId1,CFF.OddValue1
					,Programme.OddId2,CFF.OddValue2
					,Programme.OddId3,CFF.OddValue3

						,  Programme.OddSpecialBetValueHadicap01_1  as OddSpecialBetValueHadicap01_1
					,Programme.OddIdHadicap01_1 as OddIdHadicap01_1
					,  Programme.OddValueHadicap01_1   as OddValueHadicap01_1
					, Programme.OddIdHadicap01_X  as OddIdHadicap01_X
					,  Programme.OddValueHadicap01_X  as OddValueHadicap01_X
					, Programme.OddIdHadicap01_2 as OddIdHadicap01_2 
					,  Programme.OddValueHadicap01_2 as OddValueHadicap01_2

					,Programme.OddSpecialBetValueHadicap02_1,Programme.OddIdHadicap02_1,Programme.OddValueHadicap02_1
					,Programme.OddIdHadicap02_X,Programme.OddValueHadicap02_X
					,Programme.OddIdHadicap02_2,Programme.OddValueHadicap02_2


					,Programme.OddSpecialBetValueHadicap10_1,Programme.OddIdHadicap10_1,Programme.OddValueHadicap10_1
					,Programme.OddIdHadicap10_X,Programme.OddValueHadicap10_X
					,Programme.OddIdHadicap10_2,Programme.OddValueHadicap10_2

					,Programme.OddSpecialBetValueHadicap20_1,Programme.OddIdHadicap20_1,Programme.OddValueHadicap20_1
					,Programme.OddIdHadicap20_X,Programme.OddValueHadicap20_X
					,Programme.OddIdHadicap20_2,Programme.OddValueHadicap20_2

					
						,case when Programme.SportId in (4,1) then Programme.OddSpecialBetValueTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddSpecialBetValueTotalSpread_O else Programme.OddSpecialBetValueTennisTotal_O end  end as OddSpecialBetValueTotals_O1_5
					,case when Programme.SportId in (4,1) then   Programme.OddIdTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddIdTotalSpread_O else  Programme.OddIdTennisTotal_O end end  as OddIdTotals_O1_5
					,case when Programme.SportId in (4,1) then   Programme.OddValueTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddValueTotalSpread_O else Programme.OddValueTennisTotal_O end end as OddValueTotals_O1_5
					,case when Programme.SportId in (4,1) then    Programme.OddIdTotals_U1_5 
					 else case when Programme.SportId not in (5,20) then  Programme.OddIdTotalSpread_U else Programme.OddIdTennisTotal_U end end as OddIdTotals_U1_5
					,case when Programme.SportId in (4,1) then  Programme.OddValueTotals_U1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddValueTotalSpread_U else Programme.OddValueTennisTotal_U end end as OddValueTotals_U1_5

					,case when Programme.SportId=2 then Programme.OddSpecialBetValueDartFirstSet_1 else OddSpecialBetValueTotals_O2_5 end   as OddSpecialBetValueTotals_O2_5  -- Basket Home OVer/Under
					,case when Programme.SportId=2 then Programme.OddIdDartFirstSet_1 else Programme.OddIdTotals_O2_5 end  as OddIdTotals_O2_5
					,case when Programme.SportId=2 then Programme.OddValueDartFirstSet_1 else Programme.OddValueTotals_O2_5  end as OddValueTotals_O2_5
					,case when Programme.SportId=2 then Programme.OddIdDartFirstSet_2  else Programme.OddIdTotals_U2_5 end as OddIdTotals_U2_5
					,case when Programme.SportId=2 then Programme.OddValueDartFirstSet_2 else Programme.OddValueTotals_U2_5  end as OddValueTotals_U2_5


						,case when Programme.SportId=2 then Programme.OddSpecialBetValueDrawNoBet_1 else OddSpecialBetValueTotals_O3_5 end   as  OddSpecialBetValueTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddIdDrawNoBet_1 else Programme.OddIdTotals_O3_5 end    as OddIdTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddValueDrawNoBet_1 else Programme.OddValueTotals_O3_5  end  as OddValueTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddIdDrawNoBet_2  else Programme.OddIdTotals_U3_5 end as OddIdTotals_U3_5
					,case when Programme.SportId=2 then Programme.OddValueDrawNoBet_2 else Programme.OddValueTotals_U3_5  end as OddValueTotals_U3_5

					,Programme.OddSpecialBetValueTotals_O4_5
					,Programme.OddIdTotals_O4_5,Programme.OddValueTotals_O4_5
					,Programme.OddIdTotals_U4_5,Programme.OddValueTotals_U4_5



					,Programme.OddIdDouble_1 as OddIdDouble_1X,Programme.OddValueDouble_1 as OddValueDouble_1X
					,Programme.OddIdDouble_X as OddIdDouble_X2,Programme.OddValueDouble_X as OddValueDouble_X2
					,Programme.OddIdDouble_2 as OddIdDouble_12,Programme.OddValueDouble_2 as OddValueDouble_12

					,Programme.OddIdBoth_Y ,Programme.OddValueBoth_Y
					,Programme.OddIdBoth_N ,Programme.OddValueBoth_N

					,  Programme.OddIdFirstScore_1 as OddIdFirstScore_1 
					,  Programme.OddValueFirstScore_1  as OddValueFirstScore_1 
					,  Programme.OddIdFirstScore_None  as OddIdFirstScore_None 
					, Programme.OddValueFirstScore_None  as OddValueFirstScore_None 
							, Programme.OddIdFirstScore_2  as OddIdFirstScore_2 
					,  Programme.OddValueFirstScore_2   as OddValueFirstScore_2 

					,Programme.OddIdFirstHalf_1 ,Programme.OddValueFirstHalf_1
					,Programme.OddIdFirstHalf_X ,Programme.OddValueFirstHalf_X
					,Programme.OddIdFirstHalf_2 ,Programme.OddValueFirstHalf_2
					
					,Programme.OddSpecialBetValueFirstHalfTotalsO_0_5
					,Programme.OddIdFirstHalfTotalsO_0_5,Programme.OddValueFirstHalfTotalsO_0_5  
					,Programme.OddIdFirstHalfTotalsU_0_5,Programme.OddValueFirstHalfTotalsU_0_5

					,Programme.OddSpecialBetValueFirstHalfTotalsO_1_5
					,Programme.OddIdFirstHalfTotalsO_1_5,Programme.OddValueFirstHalfTotalsO_1_5  
					,Programme.OddIdFirstHalfTotalsU_1_5,Programme.OddValueFirstHalfTotalsU_1_5

					 ,Programme.OutComeTennisScore_20 as OddSpecialBetValueTennisScore_20
					 ,Programme.OddIdTennisScore_20,Programme.OddValueTennisScore_20

					 ,Programme.OutComeTennisScore_02 as OddSpecialBetValueTennisScore_02
					 ,Programme.OddIdTennisScore_02,Programme.OddValueTennisScore_02

					  ,Programme.OutComeTennisScore_12 as OddSpecialBetValueTennisScore_12
					 ,Programme.OddIdTennisScore_12,Programme.OddValueTennisScore_12

					   ,Programme.OutComeTennisScore_21 as OddSpecialBetValueTennisScore_21
					 ,Programme.OddIdTennisScore_21,Programme.OddValueTennisScore_21

					    ,Programme.OddSpecialBetValueTennisTotal_O as OddSpecialBetValueTennisTotal
					 ,Programme.OddIdTennisTotal_O,Programme.OddValueTennisTotal_O
					 ,Programme.OddIdTennisTotal_U,Programme.OddValueTennisTotal_U

					    ,Programme.OddSpecialBetValueTotalSpread_O as OddSpecialBetValueBasketTotal
					 ,Programme.OddIdTotalSpread_O,Programme.OddValueTotalSpread_O
					 ,Programme.OddIdTotalSpread_U,Programme.OddValueTotalSpread_U

					 ,Programme.OddIdBasketFirstHalf_1 ,Programme.OddValueBasketFirstHalf_1
					,Programme.OddIdBasketFirstHalf_X ,Programme.OddValueBasketFirstHalf_x
					,Programme.OddIdBasketFirstHalf_2 ,Programme.OddValueBasketFirstHalf_2

						,Programme.OddIdTennisFirstSet_1,Programme.OddValueTennisFirstSet_1
					,Programme.OddIdTennisFirstSet_2,Programme.OddValueTennisFirstSet_2
	 ,Parameter.Competitor.BetradarSuperId as HomeTeamId
	,Competitor_1.BetradarSuperId as Away
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
						 		 where Programme.SportId=@SportId and Programme.MatchDate> GETDATE()
						 --case when (select COUNT(*) from Live.[Event] with (nolock) where BetradarMatchId=Programme.BetradarMatchId)>0 then DATEADD(MINUTE,12, GETDATE()) else  DATEADD(MINUTE,5, GETDATE()) end 
						-- and  (cast(Programme.MatchDate as date)< case when Parameter.Tournament.IsPopularWeb=0 then @EventDate else DATEADD(Month,7,getdate()) end)
						 and Programme.TournamentId=@TournamentId  and Parameter.Sport.IsActive=1
		end
else if (@TournamentId<0)
	begin

	 	SELECT     Programme.BetradarMatchId,Programme.MatchId, Programme.MatchDate,Language.[Parameter.Tournament].TournamentName,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetitor_1.CompetitorName AS EventName, 
                    Language.[Parameter.Sport].SportName,Programme.TournamentId,Programme.SportId,Parameter.Category.CategoryId,Parameter.Sport.SportName as SportNameOrginal
					,    (SELECT     COUNT(DISTINCT Match.Odd.OddsTypeId)
                                        FROM          Match.Odd with (nolock)
                                                      WHERE      (MatchId = Programme.MatchId) AND (StateId = 2)) as OddTypeCount, 
                     Programme.MatchDate as TournamentDate
					,case when (select COUNT(*) from Live.[EventDetail] with (nolock) where BetradarMatchIds=Programme.BetradarMatchId)>0 then cast(1 as bit) else cast(0 as bit) end as NeutralGround
					,null AS HasStreaming,
					Language.[Parameter.Category].CategoryName
					,Parameter.Tournament.SequenceNumber,  SUBSTRING(LOWER(Parameter.Iso.IsoName2), 0, 3) AS IsoName
					,Parameter.Tournament.NewBetradarId as BetradarTournamentId
					,Programme.OddId1,Programme.OddValue1
					,Programme.OddId2,Programme.OddValue2
					,Programme.OddId3,Programme.OddValue3

					,  Programme.OddSpecialBetValueHadicap01_1  as OddSpecialBetValueHadicap01_1
					,Programme.OddIdHadicap01_1 as OddIdHadicap01_1
					,  Programme.OddValueHadicap01_1   as OddValueHadicap01_1
					, Programme.OddIdHadicap01_X  as OddIdHadicap01_X
					,  Programme.OddValueHadicap01_X  as OddValueHadicap01_X
					, Programme.OddIdHadicap01_2 as OddIdHadicap01_2 
					,  Programme.OddValueHadicap01_2 as OddValueHadicap01_2

					,Programme.OddSpecialBetValueHadicap02_1,Programme.OddIdHadicap02_1,Programme.OddValueHadicap02_1
					,Programme.OddIdHadicap02_X,Programme.OddValueHadicap02_X
					,Programme.OddIdHadicap02_2,Programme.OddValueHadicap02_2


					,Programme.OddSpecialBetValueHadicap10_1,Programme.OddIdHadicap10_1,Programme.OddValueHadicap10_1
					,Programme.OddIdHadicap10_X,Programme.OddValueHadicap10_X
					,Programme.OddIdHadicap10_2,Programme.OddValueHadicap10_2

					,Programme.OddSpecialBetValueHadicap20_1,Programme.OddIdHadicap20_1,Programme.OddValueHadicap20_1
					,Programme.OddIdHadicap20_X,Programme.OddValueHadicap20_X
					,Programme.OddIdHadicap20_2,Programme.OddValueHadicap20_2


					
					,case when Programme.SportId in (4,1) then Programme.OddSpecialBetValueTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddSpecialBetValueTotalSpread_O else Programme.OddSpecialBetValueTennisTotal_O end  end as OddSpecialBetValueTotals_O1_5
					,case when Programme.SportId in (4,1) then   Programme.OddIdTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddIdTotalSpread_O else  Programme.OddIdTennisTotal_O end end  as OddIdTotals_O1_5
					,case when Programme.SportId in (4,1) then   Programme.OddValueTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddValueTotalSpread_O else Programme.OddValueTennisTotal_O end end as OddValueTotals_O1_5
					,case when Programme.SportId in (4,1) then    Programme.OddIdTotals_U1_5 
					 else case when Programme.SportId not in (5,20) then  Programme.OddIdTotalSpread_U else Programme.OddIdTennisTotal_U end end as OddIdTotals_U1_5
					,case when Programme.SportId in (4,1) then  Programme.OddValueTotals_U1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddValueTotalSpread_U else Programme.OddValueTennisTotal_U end end as OddValueTotals_U1_5

					,case when Programme.SportId=2 then Programme.OddSpecialBetValueDartFirstSet_1 else OddSpecialBetValueTotals_O2_5 end   as OddSpecialBetValueTotals_O2_5  -- Basket Home OVer/Under
					,case when Programme.SportId=2 then Programme.OddIdDartFirstSet_1 else Programme.OddIdTotals_O2_5 end  as OddIdTotals_O2_5
					,case when Programme.SportId=2 then Programme.OddValueDartFirstSet_1 else Programme.OddValueTotals_O2_5  end as OddValueTotals_O2_5
					,case when Programme.SportId=2 then Programme.OddIdDartFirstSet_2  else Programme.OddIdTotals_U2_5 end as OddIdTotals_U2_5
					,case when Programme.SportId=2 then Programme.OddValueDartFirstSet_2 else Programme.OddValueTotals_U2_5  end as OddValueTotals_U2_5


						,case when Programme.SportId=2 then Programme.OddSpecialBetValueDrawNoBet_1 else OddSpecialBetValueTotals_O3_5 end   as  OddSpecialBetValueTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddIdDrawNoBet_1 else Programme.OddIdTotals_O3_5 end    as OddIdTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddValueDrawNoBet_1 else Programme.OddValueTotals_O3_5  end  as OddValueTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddIdDrawNoBet_2  else Programme.OddIdTotals_U3_5 end as OddIdTotals_U3_5
					,case when Programme.SportId=2 then Programme.OddValueDrawNoBet_2 else Programme.OddValueTotals_U3_5  end as OddValueTotals_U3_5

					,Programme.OddSpecialBetValueTotals_O4_5
					,Programme.OddIdTotals_O4_5,Programme.OddValueTotals_O4_5
					,Programme.OddIdTotals_U4_5,Programme.OddValueTotals_U4_5


					,Programme.OddIdDouble_1 as OddIdDouble_1X,Programme.OddValueDouble_1 as OddValueDouble_1X
					,Programme.OddIdDouble_X as OddIdDouble_X2,Programme.OddValueDouble_X as OddValueDouble_X2
					,Programme.OddIdDouble_2 as OddIdDouble_12,Programme.OddValueDouble_2 as OddValueDouble_12

					,Programme.OddIdBoth_Y ,Programme.OddValueBoth_Y
					,Programme.OddIdBoth_N ,Programme.OddValueBoth_N

					,  Programme.OddIdFirstScore_1 as OddIdFirstScore_1 
					,  Programme.OddValueFirstScore_1  as OddValueFirstScore_1 
					,  Programme.OddIdFirstScore_None  as OddIdFirstScore_None 
					, Programme.OddValueFirstScore_None  as OddValueFirstScore_None 
							, Programme.OddIdFirstScore_2  as OddIdFirstScore_2 
					,  Programme.OddValueFirstScore_2   as OddValueFirstScore_2 

					,Programme.OddIdFirstHalf_1 ,Programme.OddValueFirstHalf_1
					,Programme.OddIdFirstHalf_X ,Programme.OddValueFirstHalf_X
					,Programme.OddIdFirstHalf_2 ,Programme.OddValueFirstHalf_2
					
					,Programme.OddSpecialBetValueFirstHalfTotalsO_0_5
					,Programme.OddIdFirstHalfTotalsO_0_5,Programme.OddValueFirstHalfTotalsO_0_5  
					,Programme.OddIdFirstHalfTotalsU_0_5,Programme.OddValueFirstHalfTotalsU_0_5

					,Programme.OddSpecialBetValueFirstHalfTotalsO_1_5
					,Programme.OddIdFirstHalfTotalsO_1_5,Programme.OddValueFirstHalfTotalsO_1_5  
					,Programme.OddIdFirstHalfTotalsU_1_5,Programme.OddValueFirstHalfTotalsU_1_5

					 ,Programme.OutComeTennisScore_20 as OddSpecialBetValueTennisScore_20
					 ,Programme.OddIdTennisScore_20,Programme.OddValueTennisScore_20

					 ,Programme.OutComeTennisScore_02 as OddSpecialBetValueTennisScore_02
					 ,Programme.OddIdTennisScore_02,Programme.OddValueTennisScore_02

					  ,Programme.OutComeTennisScore_12 as OddSpecialBetValueTennisScore_12
					 ,Programme.OddIdTennisScore_12,Programme.OddValueTennisScore_12

					   ,Programme.OutComeTennisScore_21 as OddSpecialBetValueTennisScore_21
					 ,Programme.OddIdTennisScore_21,Programme.OddValueTennisScore_21

					    ,Programme.OddSpecialBetValueTennisTotal_O as OddSpecialBetValueTennisTotal
					 ,Programme.OddIdTennisTotal_O,Programme.OddValueTennisTotal_O
					 ,Programme.OddIdTennisTotal_U,Programme.OddValueTennisTotal_U

					    ,Programme.OddSpecialBetValueTotalSpread_O as OddSpecialBetValueBasketTotal
					 ,Programme.OddIdTotalSpread_O,Programme.OddValueTotalSpread_O
					 ,Programme.OddIdTotalSpread_U,Programme.OddValueTotalSpread_U

					 ,Programme.OddIdBasketFirstHalf_1 ,Programme.OddValueBasketFirstHalf_1
					,Programme.OddIdBasketFirstHalf_X ,Programme.OddValueBasketFirstHalf_x
					,Programme.OddIdBasketFirstHalf_2 ,Programme.OddValueBasketFirstHalf_2

						,Programme.OddIdTennisFirstSet_1,Programme.OddValueTennisFirstSet_1
					,Programme.OddIdTennisFirstSet_2,Programme.OddValueTennisFirstSet_2 
	,Parameter.Competitor.BetradarSuperId as HomeTeamId
	,Competitor_1.BetradarSuperId as Away
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
						 where Programme.MatchId=@SportId and Programme.MatchDate>GETDATE() 
						  
		end
else if (@CategoryId>0  and @SportId>=0)
	begin
		set @TournamentId=2682

		SELECT  top 50   Programme.BetradarMatchId,Programme.MatchId, Programme.MatchDate,Language.[Parameter.Tournament].TournamentName,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetitor_1.CompetitorName AS EventName, 
                    Language.[Parameter.Sport].SportName,Programme.TournamentId,Programme.SportId,Parameter.Category.CategoryId,Parameter.Sport.SportName as SportNameOrginal
					,(SELECT     COUNT(DISTINCT OddsTypeId)
                                        FROM          Match.Odd with (nolock)
                                                      WHERE      (Match.Odd.MatchId = Programme.MatchId) AND (Match.Odd.StateId = 2) and Match.Odd.OddValue>1) as OddTypeCount , 
                     Programme.MatchDate as TournamentDate,case when (select COUNT(*) from Live.[EventDetail] with (nolock) where BetradarMatchIds=Programme.BetradarMatchId)>0 then cast(1 as bit) else cast(0 as bit) end as NeutralGround
					,null as HasStreaming,
					Language.[Parameter.Category].CategoryName
					,Parameter.Category.SequenceNumber,  SUBSTRING(LOWER(Parameter.Iso.IsoName2), 0, 3) AS IsoName
					,Parameter.Tournament.NewBetradarId as BetradarTournamentId
					,Programme.OddId1,CFF.OddValue1
					,Programme.OddId2,CFF.OddValue2
					,Programme.OddId3,CFF.OddValue3


						,  Programme.OddSpecialBetValueHadicap01_1  as OddSpecialBetValueHadicap01_1
					,Programme.OddIdHadicap01_1 as OddIdHadicap01_1
					,  Programme.OddValueHadicap01_1   as OddValueHadicap01_1
					, Programme.OddIdHadicap01_X  as OddIdHadicap01_X
					,  Programme.OddValueHadicap01_X  as OddValueHadicap01_X
					, Programme.OddIdHadicap01_2 as OddIdHadicap01_2 
					,  Programme.OddValueHadicap01_2 as OddValueHadicap01_2

					,Programme.OddSpecialBetValueHadicap02_1,Programme.OddIdHadicap02_1,Programme.OddValueHadicap02_1
					,Programme.OddIdHadicap02_X,Programme.OddValueHadicap02_X
					,Programme.OddIdHadicap02_2,Programme.OddValueHadicap02_2


					,Programme.OddSpecialBetValueHadicap10_1,Programme.OddIdHadicap10_1,Programme.OddValueHadicap10_1
					,Programme.OddIdHadicap10_X,Programme.OddValueHadicap10_X
					,Programme.OddIdHadicap10_2,Programme.OddValueHadicap10_2

					,Programme.OddSpecialBetValueHadicap20_1,Programme.OddIdHadicap20_1,Programme.OddValueHadicap20_1
					,Programme.OddIdHadicap20_X,Programme.OddValueHadicap20_X
					,Programme.OddIdHadicap20_2,Programme.OddValueHadicap20_2


						,case when Programme.SportId in (4,1) then Programme.OddSpecialBetValueTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddSpecialBetValueTotalSpread_O else Programme.OddSpecialBetValueTennisTotal_O end  end as OddSpecialBetValueTotals_O1_5
					,case when Programme.SportId in (4,1) then   Programme.OddIdTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddIdTotalSpread_O else  Programme.OddIdTennisTotal_O end end  as OddIdTotals_O1_5
					,case when Programme.SportId in (4,1) then   Programme.OddValueTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddValueTotalSpread_O else Programme.OddValueTennisTotal_O end end as OddValueTotals_O1_5
					,case when Programme.SportId in (4,1) then    Programme.OddIdTotals_U1_5 
					 else case when Programme.SportId not in (5,20) then  Programme.OddIdTotalSpread_U else Programme.OddIdTennisTotal_U end end as OddIdTotals_U1_5
					,case when Programme.SportId in (4,1) then  Programme.OddValueTotals_U1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddValueTotalSpread_U else Programme.OddValueTennisTotal_U end end as OddValueTotals_U1_5

					,case when Programme.SportId=2 then Programme.OddSpecialBetValueDartFirstSet_1 else OddSpecialBetValueTotals_O2_5 end   as OddSpecialBetValueTotals_O2_5  -- Basket Home OVer/Under
					,case when Programme.SportId=2 then Programme.OddIdDartFirstSet_1 else Programme.OddIdTotals_O2_5 end  as OddIdTotals_O2_5
					,case when Programme.SportId=2 then Programme.OddValueDartFirstSet_1 else Programme.OddValueTotals_O2_5  end as OddValueTotals_O2_5
					,case when Programme.SportId=2 then Programme.OddIdDartFirstSet_2  else Programme.OddIdTotals_U2_5 end as OddIdTotals_U2_5
					,case when Programme.SportId=2 then Programme.OddValueDartFirstSet_2 else Programme.OddValueTotals_U2_5  end as OddValueTotals_U2_5


						,case when Programme.SportId=2 then Programme.OddSpecialBetValueDrawNoBet_1 else OddSpecialBetValueTotals_O3_5 end   as  OddSpecialBetValueTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddIdDrawNoBet_1 else Programme.OddIdTotals_O3_5 end    as OddIdTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddValueDrawNoBet_1 else Programme.OddValueTotals_O3_5  end  as OddValueTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddIdDrawNoBet_2  else Programme.OddIdTotals_U3_5 end as OddIdTotals_U3_5
					,case when Programme.SportId=2 then Programme.OddValueDrawNoBet_2 else Programme.OddValueTotals_U3_5  end as OddValueTotals_U3_5

					,Programme.OddSpecialBetValueTotals_O4_5
					,Programme.OddIdTotals_O4_5,Programme.OddValueTotals_O4_5
					,Programme.OddIdTotals_U4_5,Programme.OddValueTotals_U4_5



					,Programme.OddIdDouble_1 as OddIdDouble_1X,Programme.OddValueDouble_1 as OddValueDouble_1X
					,Programme.OddIdDouble_X as OddIdDouble_X2,Programme.OddValueDouble_X as OddValueDouble_X2
					,Programme.OddIdDouble_2 as OddIdDouble_12,Programme.OddValueDouble_2 as OddValueDouble_12

					,Programme.OddIdBoth_Y ,Programme.OddValueBoth_Y
					,Programme.OddIdBoth_N ,Programme.OddValueBoth_N

					,  Programme.OddIdFirstScore_1 as OddIdFirstScore_1 
					,  Programme.OddValueFirstScore_1  as OddValueFirstScore_1 
					,  Programme.OddIdFirstScore_None  as OddIdFirstScore_None 
					, Programme.OddValueFirstScore_None  as OddValueFirstScore_None 
							, Programme.OddIdFirstScore_2  as OddIdFirstScore_2 
					,  Programme.OddValueFirstScore_2   as OddValueFirstScore_2 

					,Programme.OddIdFirstHalf_1 ,Programme.OddValueFirstHalf_1
					,Programme.OddIdFirstHalf_X ,Programme.OddValueFirstHalf_X
					,Programme.OddIdFirstHalf_2 ,Programme.OddValueFirstHalf_2
					
					,Programme.OddSpecialBetValueFirstHalfTotalsO_0_5
					,Programme.OddIdFirstHalfTotalsO_0_5,Programme.OddValueFirstHalfTotalsO_0_5  
					,Programme.OddIdFirstHalfTotalsU_0_5,Programme.OddValueFirstHalfTotalsU_0_5

					,Programme.OddSpecialBetValueFirstHalfTotalsO_1_5
					,Programme.OddIdFirstHalfTotalsO_1_5,Programme.OddValueFirstHalfTotalsO_1_5  
					,Programme.OddIdFirstHalfTotalsU_1_5,Programme.OddValueFirstHalfTotalsU_1_5

					 ,Programme.OutComeTennisScore_20 as OddSpecialBetValueTennisScore_20
					 ,Programme.OddIdTennisScore_20,Programme.OddValueTennisScore_20

					 ,Programme.OutComeTennisScore_02 as OddSpecialBetValueTennisScore_02
					 ,Programme.OddIdTennisScore_02,Programme.OddValueTennisScore_02

					  ,Programme.OutComeTennisScore_12 as OddSpecialBetValueTennisScore_12
					 ,Programme.OddIdTennisScore_12,Programme.OddValueTennisScore_12

					   ,Programme.OutComeTennisScore_21 as OddSpecialBetValueTennisScore_21
					 ,Programme.OddIdTennisScore_21,Programme.OddValueTennisScore_21

					    ,Programme.OddSpecialBetValueTennisTotal_O as OddSpecialBetValueTennisTotal
					 ,Programme.OddIdTennisTotal_O,Programme.OddValueTennisTotal_O
					 ,Programme.OddIdTennisTotal_U,Programme.OddValueTennisTotal_U

					    ,Programme.OddSpecialBetValueTotalSpread_O as OddSpecialBetValueBasketTotal
					 ,Programme.OddIdTotalSpread_O,Programme.OddValueTotalSpread_O
					 ,Programme.OddIdTotalSpread_U,Programme.OddValueTotalSpread_U

					 ,Programme.OddIdBasketFirstHalf_1 ,Programme.OddValueBasketFirstHalf_1
					,Programme.OddIdBasketFirstHalf_X ,Programme.OddValueBasketFirstHalf_x
					,Programme.OddIdBasketFirstHalf_2 ,Programme.OddValueBasketFirstHalf_2

						,Programme.OddIdTennisFirstSet_1,Programme.OddValueTennisFirstSet_1
					,Programme.OddIdTennisFirstSet_2,Programme.OddValueTennisFirstSet_2
	 ,Parameter.Competitor.BetradarSuperId as HomeTeamId
	,Competitor_1.BetradarSuperId as Away
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
						 where Programme.SportId=@SportId and Programme.MatchDate> GETDATE()
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
				,(SELECT     COUNT(DISTINCT OddsTypeId)
                                        FROM          Match.Odd with (nolock)
                                                      WHERE      (Match.Odd.MatchId = Programme.MatchId) AND (Match.Odd.StateId = 2) and Match.Odd.OddValue>1) as OddTypeCount , 
                     Programme.MatchDate as TournamentDate,case when (select COUNT(*) from Live.[EventDetail] with (nolock) where BetradarMatchIds=Programme.BetradarMatchId)>0 then cast(1 as bit) else cast(0 as bit) end as NeutralGround
					,null as HasStreaming,
					Language.[Parameter.Category].CategoryName
					,Parameter.Category.SequenceNumber,  SUBSTRING(LOWER(Parameter.Iso.IsoName2), 0, 3) AS IsoName
					,Parameter.Tournament.NewBetradarId as BetradarTournamentId
					,Programme.OddId1,CFF.OddValue1
					,Programme.OddId2,CFF.OddValue2
					,Programme.OddId3,CFF.OddValue3


						,  Programme.OddSpecialBetValueHadicap01_1  as OddSpecialBetValueHadicap01_1
					,Programme.OddIdHadicap01_1 as OddIdHadicap01_1
					,  Programme.OddValueHadicap01_1   as OddValueHadicap01_1
					, Programme.OddIdHadicap01_X  as OddIdHadicap01_X
					,  Programme.OddValueHadicap01_X  as OddValueHadicap01_X
					, Programme.OddIdHadicap01_2 as OddIdHadicap01_2 
					,  Programme.OddValueHadicap01_2 as OddValueHadicap01_2

					,Programme.OddSpecialBetValueHadicap02_1,Programme.OddIdHadicap02_1,Programme.OddValueHadicap02_1
					,Programme.OddIdHadicap02_X,Programme.OddValueHadicap02_X
					,Programme.OddIdHadicap02_2,Programme.OddValueHadicap02_2


					,Programme.OddSpecialBetValueHadicap10_1,Programme.OddIdHadicap10_1,Programme.OddValueHadicap10_1
					,Programme.OddIdHadicap10_X,Programme.OddValueHadicap10_X
					,Programme.OddIdHadicap10_2,Programme.OddValueHadicap10_2

					,Programme.OddSpecialBetValueHadicap20_1,Programme.OddIdHadicap20_1,Programme.OddValueHadicap20_1
					,Programme.OddIdHadicap20_X,Programme.OddValueHadicap20_X
					,Programme.OddIdHadicap20_2,Programme.OddValueHadicap20_2


						,case when Programme.SportId in (4,1) then Programme.OddSpecialBetValueTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddSpecialBetValueTotalSpread_O else Programme.OddSpecialBetValueTennisTotal_O end  end as OddSpecialBetValueTotals_O1_5
					,case when Programme.SportId in (4,1) then   Programme.OddIdTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddIdTotalSpread_O else  Programme.OddIdTennisTotal_O end end  as OddIdTotals_O1_5
					,case when Programme.SportId in (4,1) then   Programme.OddValueTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddValueTotalSpread_O else Programme.OddValueTennisTotal_O end end as OddValueTotals_O1_5
					,case when Programme.SportId in (4,1) then    Programme.OddIdTotals_U1_5 
					 else case when Programme.SportId not in (5,20) then  Programme.OddIdTotalSpread_U else Programme.OddIdTennisTotal_U end end as OddIdTotals_U1_5
					,case when Programme.SportId in (4,1) then  Programme.OddValueTotals_U1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddValueTotalSpread_U else Programme.OddValueTennisTotal_U end end as OddValueTotals_U1_5

					,case when Programme.SportId=2 then Programme.OddSpecialBetValueDartFirstSet_1 else OddSpecialBetValueTotals_O2_5 end   as OddSpecialBetValueTotals_O2_5  -- Basket Home OVer/Under
					,case when Programme.SportId=2 then Programme.OddIdDartFirstSet_1 else Programme.OddIdTotals_O2_5 end  as OddIdTotals_O2_5
					,case when Programme.SportId=2 then Programme.OddValueDartFirstSet_1 else Programme.OddValueTotals_O2_5  end as OddValueTotals_O2_5
					,case when Programme.SportId=2 then Programme.OddIdDartFirstSet_2  else Programme.OddIdTotals_U2_5 end as OddIdTotals_U2_5
					,case when Programme.SportId=2 then Programme.OddValueDartFirstSet_2 else Programme.OddValueTotals_U2_5  end as OddValueTotals_U2_5


						,case when Programme.SportId=2 then Programme.OddSpecialBetValueDrawNoBet_1 else OddSpecialBetValueTotals_O3_5 end   as  OddSpecialBetValueTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddIdDrawNoBet_1 else Programme.OddIdTotals_O3_5 end    as OddIdTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddValueDrawNoBet_1 else Programme.OddValueTotals_O3_5  end  as OddValueTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddIdDrawNoBet_2  else Programme.OddIdTotals_U3_5 end as OddIdTotals_U3_5
					,case when Programme.SportId=2 then Programme.OddValueDrawNoBet_2 else Programme.OddValueTotals_U3_5  end as OddValueTotals_U3_5

					,Programme.OddSpecialBetValueTotals_O4_5
					,Programme.OddIdTotals_O4_5,Programme.OddValueTotals_O4_5
					,Programme.OddIdTotals_U4_5,Programme.OddValueTotals_U4_5


					,Programme.OddIdDouble_1 as OddIdDouble_1X,Programme.OddValueDouble_1 as OddValueDouble_1X
					,Programme.OddIdDouble_X as OddIdDouble_X2,Programme.OddValueDouble_X as OddValueDouble_X2
					,Programme.OddIdDouble_2 as OddIdDouble_12,Programme.OddValueDouble_2 as OddValueDouble_12

					,Programme.OddIdBoth_Y ,Programme.OddValueBoth_Y
					,Programme.OddIdBoth_N ,Programme.OddValueBoth_N

				,  Programme.OddIdFirstScore_1 as OddIdFirstScore_1 
					,  Programme.OddValueFirstScore_1  as OddValueFirstScore_1 
					,  Programme.OddIdFirstScore_None  as OddIdFirstScore_None 
					, Programme.OddValueFirstScore_None  as OddValueFirstScore_None 
							, Programme.OddIdFirstScore_2  as OddIdFirstScore_2 
					,  Programme.OddValueFirstScore_2   as OddValueFirstScore_2 

					,Programme.OddIdFirstHalf_1 ,Programme.OddValueFirstHalf_1
					,Programme.OddIdFirstHalf_X ,Programme.OddValueFirstHalf_X
					,Programme.OddIdFirstHalf_2 ,Programme.OddValueFirstHalf_2
					
					,Programme.OddSpecialBetValueFirstHalfTotalsO_0_5
					,Programme.OddIdFirstHalfTotalsO_0_5,Programme.OddValueFirstHalfTotalsO_0_5  
					,Programme.OddIdFirstHalfTotalsU_0_5,Programme.OddValueFirstHalfTotalsU_0_5

					,Programme.OddSpecialBetValueFirstHalfTotalsO_1_5
					,Programme.OddIdFirstHalfTotalsO_1_5,Programme.OddValueFirstHalfTotalsO_1_5  
					,Programme.OddIdFirstHalfTotalsU_1_5,Programme.OddValueFirstHalfTotalsU_1_5

					 ,Programme.OutComeTennisScore_20 as OddSpecialBetValueTennisScore_20
					 ,Programme.OddIdTennisScore_20,Programme.OddValueTennisScore_20

					 ,Programme.OutComeTennisScore_02 as OddSpecialBetValueTennisScore_02
					 ,Programme.OddIdTennisScore_02,Programme.OddValueTennisScore_02

					  ,Programme.OutComeTennisScore_12 as OddSpecialBetValueTennisScore_12
					 ,Programme.OddIdTennisScore_12,Programme.OddValueTennisScore_12

					   ,Programme.OutComeTennisScore_21 as OddSpecialBetValueTennisScore_21
					 ,Programme.OddIdTennisScore_21,Programme.OddValueTennisScore_21

					    ,Programme.OddSpecialBetValueTennisTotal_O as OddSpecialBetValueTennisTotal
					 ,Programme.OddIdTennisTotal_O,Programme.OddValueTennisTotal_O
					 ,Programme.OddIdTennisTotal_U,Programme.OddValueTennisTotal_U

					    ,Programme.OddSpecialBetValueTotalSpread_O as OddSpecialBetValueBasketTotal
					 ,Programme.OddIdTotalSpread_O,Programme.OddValueTotalSpread_O
					 ,Programme.OddIdTotalSpread_U,Programme.OddValueTotalSpread_U

					 ,Programme.OddIdBasketFirstHalf_1 ,Programme.OddValueBasketFirstHalf_1
					,Programme.OddIdBasketFirstHalf_X ,Programme.OddValueBasketFirstHalf_x
					,Programme.OddIdBasketFirstHalf_2 ,Programme.OddValueBasketFirstHalf_2

						,Programme.OddIdTennisFirstSet_1,Programme.OddValueTennisFirstSet_1
					,Programme.OddIdTennisFirstSet_2,Programme.OddValueTennisFirstSet_2
	 ,Parameter.Competitor.BetradarSuperId as HomeTeamId
	,Competitor_1.BetradarSuperId as Away
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
						 --and  cast(Programme.MatchDate as date)< case when Parameter.Tournament.IsPopularWeb=0 then cast(@EventDate as date) else  cast('20240901' as date) end 
						 and Parameter.Sport.IsActive=1

	end
else  if (@SportId=-1) -- Fixture Top Event
	begin
		set @TournamentId=2682
 
		SELECT  top 50   Programme.BetradarMatchId,Programme.MatchId, Programme.MatchDate,Language.[Parameter.Tournament].TournamentName,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetitor_1.CompetitorName AS EventName, 
                    Language.[Parameter.Sport].SportName,Programme.TournamentId,Programme.SportId,Parameter.Category.CategoryId,Parameter.Sport.SportName as SportNameOrginal
					,(SELECT     COUNT(DISTINCT OddsTypeId)
                                        FROM          Match.Odd with (nolock)
                                                      WHERE      (Match.Odd.MatchId = Programme.MatchId) AND (Match.Odd.StateId = 2) and Match.Odd.OddValue>1) as OddTypeCount , 
                     Programme.MatchDate as TournamentDate,case when (select COUNT(*) from Live.[EventDetail] with (nolock) where BetradarMatchIds=Programme.BetradarMatchId)>0 then cast(1 as bit) else cast(0 as bit) end as NeutralGround
					,null as HasStreaming,
					Language.[Parameter.Category].CategoryName
					,Parameter.Category.SequenceNumber,  SUBSTRING(LOWER(Parameter.Iso.IsoName2), 0, 3) AS IsoName
					,Parameter.Tournament.NewBetradarId as BetradarTournamentId
					,Programme.OddId1,CFF.OddValue1
					,Programme.OddId2,CFF.OddValue2
					,Programme.OddId3,CFF.OddValue3


				 		,  Programme.OddSpecialBetValueHadicap01_1  as OddSpecialBetValueHadicap01_1
					,Programme.OddIdHadicap01_1 as OddIdHadicap01_1
					,  Programme.OddValueHadicap01_1   as OddValueHadicap01_1
					, Programme.OddIdHadicap01_X  as OddIdHadicap01_X
					,  Programme.OddValueHadicap01_X  as OddValueHadicap01_X
					, Programme.OddIdHadicap01_2 as OddIdHadicap01_2 
					,  Programme.OddValueHadicap01_2 as OddValueHadicap01_2

					,Programme.OddSpecialBetValueHadicap02_1,Programme.OddIdHadicap02_1,Programme.OddValueHadicap02_1
					,Programme.OddIdHadicap02_X,Programme.OddValueHadicap02_X
					,Programme.OddIdHadicap02_2,Programme.OddValueHadicap02_2


					,Programme.OddSpecialBetValueHadicap10_1,Programme.OddIdHadicap10_1,Programme.OddValueHadicap10_1
					,Programme.OddIdHadicap10_X,Programme.OddValueHadicap10_X
					,Programme.OddIdHadicap10_2,Programme.OddValueHadicap10_2

					,Programme.OddSpecialBetValueHadicap20_1,Programme.OddIdHadicap20_1,Programme.OddValueHadicap20_1
					,Programme.OddIdHadicap20_X,Programme.OddValueHadicap20_X
					,Programme.OddIdHadicap20_2,Programme.OddValueHadicap20_2

					
						,case when Programme.SportId in (4,1) then Programme.OddSpecialBetValueTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddSpecialBetValueTotalSpread_O else Programme.OddSpecialBetValueTennisTotal_O end  end as OddSpecialBetValueTotals_O1_5
					,case when Programme.SportId in (4,1) then   Programme.OddIdTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddIdTotalSpread_O else  Programme.OddIdTennisTotal_O end end  as OddIdTotals_O1_5
					,case when Programme.SportId in (4,1) then   Programme.OddValueTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddValueTotalSpread_O else Programme.OddValueTennisTotal_O end end as OddValueTotals_O1_5
					,case when Programme.SportId in (4,1) then    Programme.OddIdTotals_U1_5 
					 else case when Programme.SportId not in (5,20) then  Programme.OddIdTotalSpread_U else Programme.OddIdTennisTotal_U end end as OddIdTotals_U1_5
					,case when Programme.SportId in (4,1) then  Programme.OddValueTotals_U1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddValueTotalSpread_U else Programme.OddValueTennisTotal_U end end as OddValueTotals_U1_5

					,case when Programme.SportId=2 then Programme.OddSpecialBetValueDartFirstSet_1 else OddSpecialBetValueTotals_O2_5 end   as OddSpecialBetValueTotals_O2_5  -- Basket Home OVer/Under
					,case when Programme.SportId=2 then Programme.OddIdDartFirstSet_1 else Programme.OddIdTotals_O2_5 end  as OddIdTotals_O2_5
					,case when Programme.SportId=2 then Programme.OddValueDartFirstSet_1 else Programme.OddValueTotals_O2_5  end as OddValueTotals_O2_5
					,case when Programme.SportId=2 then Programme.OddIdDartFirstSet_2  else Programme.OddIdTotals_U2_5 end as OddIdTotals_U2_5
					,case when Programme.SportId=2 then Programme.OddValueDartFirstSet_2 else Programme.OddValueTotals_U2_5  end as OddValueTotals_U2_5


						,case when Programme.SportId=2 then Programme.OddSpecialBetValueDrawNoBet_1 else OddSpecialBetValueTotals_O3_5 end   as  OddSpecialBetValueTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddIdDrawNoBet_1 else Programme.OddIdTotals_O3_5 end    as OddIdTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddValueDrawNoBet_1 else Programme.OddValueTotals_O3_5  end  as OddValueTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddIdDrawNoBet_2  else Programme.OddIdTotals_U3_5 end as OddIdTotals_U3_5
					,case when Programme.SportId=2 then Programme.OddValueDrawNoBet_2 else Programme.OddValueTotals_U3_5  end as OddValueTotals_U3_5

					,Programme.OddSpecialBetValueTotals_O4_5
					,Programme.OddIdTotals_O4_5,Programme.OddValueTotals_O4_5
					,Programme.OddIdTotals_U4_5,Programme.OddValueTotals_U4_5


					,Programme.OddIdDouble_1 as OddIdDouble_1X,Programme.OddValueDouble_1 as OddValueDouble_1X
					,Programme.OddIdDouble_X as OddIdDouble_X2,Programme.OddValueDouble_X as OddValueDouble_X2
					,Programme.OddIdDouble_2 as OddIdDouble_12,Programme.OddValueDouble_2 as OddValueDouble_12

					,Programme.OddIdBoth_Y ,Programme.OddValueBoth_Y
					,Programme.OddIdBoth_N ,Programme.OddValueBoth_N

			,  Programme.OddIdFirstScore_1 as OddIdFirstScore_1 
					,  Programme.OddValueFirstScore_1  as OddValueFirstScore_1 
					,  Programme.OddIdFirstScore_None  as OddIdFirstScore_None 
					, Programme.OddValueFirstScore_None  as OddValueFirstScore_None 
							, Programme.OddIdFirstScore_2  as OddIdFirstScore_2 
					,  Programme.OddValueFirstScore_2   as OddValueFirstScore_2 

					,Programme.OddIdFirstHalf_1 ,Programme.OddValueFirstHalf_1
					,Programme.OddIdFirstHalf_X ,Programme.OddValueFirstHalf_X
					,Programme.OddIdFirstHalf_2 ,Programme.OddValueFirstHalf_2
					
					,Programme.OddSpecialBetValueFirstHalfTotalsO_0_5
					,Programme.OddIdFirstHalfTotalsO_0_5,Programme.OddValueFirstHalfTotalsO_0_5  
					,Programme.OddIdFirstHalfTotalsU_0_5,Programme.OddValueFirstHalfTotalsU_0_5

					,Programme.OddSpecialBetValueFirstHalfTotalsO_1_5
					,Programme.OddIdFirstHalfTotalsO_1_5,Programme.OddValueFirstHalfTotalsO_1_5  
					,Programme.OddIdFirstHalfTotalsU_1_5,Programme.OddValueFirstHalfTotalsU_1_5

					 ,Programme.OutComeTennisScore_20 as OddSpecialBetValueTennisScore_20
					 ,Programme.OddIdTennisScore_20,Programme.OddValueTennisScore_20

					 ,Programme.OutComeTennisScore_02 as OddSpecialBetValueTennisScore_02
					 ,Programme.OddIdTennisScore_02,Programme.OddValueTennisScore_02

					  ,Programme.OutComeTennisScore_12 as OddSpecialBetValueTennisScore_12
					 ,Programme.OddIdTennisScore_12,Programme.OddValueTennisScore_12

					   ,Programme.OutComeTennisScore_21 as OddSpecialBetValueTennisScore_21
					 ,Programme.OddIdTennisScore_21,Programme.OddValueTennisScore_21

					    ,Programme.OddSpecialBetValueTennisTotal_O as OddSpecialBetValueTennisTotal
					 ,Programme.OddIdTennisTotal_O,Programme.OddValueTennisTotal_O
					 ,Programme.OddIdTennisTotal_U,Programme.OddValueTennisTotal_U

					    ,Programme.OddSpecialBetValueTotalSpread_O as OddSpecialBetValueBasketTotal
					 ,Programme.OddIdTotalSpread_O,Programme.OddValueTotalSpread_O
					 ,Programme.OddIdTotalSpread_U,Programme.OddValueTotalSpread_U

					 ,Programme.OddIdBasketFirstHalf_1 ,Programme.OddValueBasketFirstHalf_1
					,Programme.OddIdBasketFirstHalf_X ,Programme.OddValueBasketFirstHalf_x
					,Programme.OddIdBasketFirstHalf_2 ,Programme.OddValueBasketFirstHalf_2

						,Programme.OddIdTennisFirstSet_1,Programme.OddValueTennisFirstSet_1
					,Programme.OddIdTennisFirstSet_2,Programme.OddValueTennisFirstSet_2
	 ,Parameter.Competitor.BetradarSuperId as HomeTeamId
	,Competitor_1.BetradarSuperId as Away
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

		declare @TempTable2 table(MatchId bigint)
		 
		SELECT  top 150   Programme.BetradarMatchId,Programme.MatchId, Programme.MatchDate,Language.[Parameter.Tournament].TournamentName,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetitor_1.CompetitorName AS EventName, 
                    Language.[Parameter.Sport].SportName,Programme.TournamentId,Programme.SportId,Parameter.Category.CategoryId,Parameter.Sport.SportName as SportNameOrginal
					,(SELECT     COUNT(DISTINCT OddsTypeId)
                                        FROM          Match.Odd with (nolock)
                                                      WHERE      (Match.Odd.MatchId = Programme.MatchId) AND (Match.Odd.StateId = 2) and Match.Odd.OddValue>1) as OddTypeCount , 
                     Programme.MatchDate as TournamentDate,case when (select COUNT(*) from Live.[EventDetail] with (nolock) where BetradarMatchIds=Programme.BetradarMatchId)>0 then cast(1 as bit) else cast(0 as bit) end as NeutralGround
					,null as HasStreaming,
					Language.[Parameter.Category].CategoryName
					,Parameter.Category.SequenceNumber,  SUBSTRING(LOWER(Parameter.Iso.IsoName2), 0, 3) AS IsoName
					,Parameter.Tournament.NewBetradarId as BetradarTournamentId
					,Programme.OddId1,CFF.OddValue1
					,Programme.OddId2,CFF.OddValue2
					,Programme.OddId3,CFF.OddValue3


						,  Programme.OddSpecialBetValueHadicap01_1  as OddSpecialBetValueHadicap01_1
					,Programme.OddIdHadicap01_1 as OddIdHadicap01_1
					,  Programme.OddValueHadicap01_1   as OddValueHadicap01_1
					, Programme.OddIdHadicap01_X  as OddIdHadicap01_X
					,  Programme.OddValueHadicap01_X  as OddValueHadicap01_X
					, Programme.OddIdHadicap01_2 as OddIdHadicap01_2 
					,  Programme.OddValueHadicap01_2 as OddValueHadicap01_2

					,Programme.OddSpecialBetValueHadicap02_1,Programme.OddIdHadicap02_1,Programme.OddValueHadicap02_1
					,Programme.OddIdHadicap02_X,Programme.OddValueHadicap02_X
					,Programme.OddIdHadicap02_2,Programme.OddValueHadicap02_2


					,Programme.OddSpecialBetValueHadicap10_1,Programme.OddIdHadicap10_1,Programme.OddValueHadicap10_1
					,Programme.OddIdHadicap10_X,Programme.OddValueHadicap10_X
					,Programme.OddIdHadicap10_2,Programme.OddValueHadicap10_2

					,Programme.OddSpecialBetValueHadicap20_1,Programme.OddIdHadicap20_1,Programme.OddValueHadicap20_1
					,Programme.OddIdHadicap20_X,Programme.OddValueHadicap20_X
					,Programme.OddIdHadicap20_2,Programme.OddValueHadicap20_2


						,case when Programme.SportId in (4,1) then Programme.OddSpecialBetValueTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddSpecialBetValueTotalSpread_O else Programme.OddSpecialBetValueTennisTotal_O end  end as OddSpecialBetValueTotals_O1_5
					,case when Programme.SportId in (4,1) then   Programme.OddIdTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddIdTotalSpread_O else  Programme.OddIdTennisTotal_O end end  as OddIdTotals_O1_5
					,case when Programme.SportId in (4,1) then   Programme.OddValueTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddValueTotalSpread_O else Programme.OddValueTennisTotal_O end end as OddValueTotals_O1_5
					,case when Programme.SportId in (4,1) then    Programme.OddIdTotals_U1_5 
					 else case when Programme.SportId not in (5,20) then  Programme.OddIdTotalSpread_U else Programme.OddIdTennisTotal_U end end as OddIdTotals_U1_5
					,case when Programme.SportId in (4,1) then  Programme.OddValueTotals_U1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddValueTotalSpread_U else Programme.OddValueTennisTotal_U end end as OddValueTotals_U1_5

					,case when Programme.SportId=2 then Programme.OddSpecialBetValueDartFirstSet_1 else OddSpecialBetValueTotals_O2_5 end   as OddSpecialBetValueTotals_O2_5  -- Basket Home OVer/Under
					,case when Programme.SportId=2 then Programme.OddIdDartFirstSet_1 else Programme.OddIdTotals_O2_5 end  as OddIdTotals_O2_5
					,case when Programme.SportId=2 then Programme.OddValueDartFirstSet_1 else Programme.OddValueTotals_O2_5  end as OddValueTotals_O2_5
					,case when Programme.SportId=2 then Programme.OddIdDartFirstSet_2  else Programme.OddIdTotals_U2_5 end as OddIdTotals_U2_5
					,case when Programme.SportId=2 then Programme.OddValueDartFirstSet_2 else Programme.OddValueTotals_U2_5  end as OddValueTotals_U2_5


						,case when Programme.SportId=2 then Programme.OddSpecialBetValueDrawNoBet_1 else OddSpecialBetValueTotals_O3_5 end   as  OddSpecialBetValueTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddIdDrawNoBet_1 else Programme.OddIdTotals_O3_5 end    as OddIdTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddValueDrawNoBet_1 else Programme.OddValueTotals_O3_5  end  as OddValueTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddIdDrawNoBet_2  else Programme.OddIdTotals_U3_5 end as OddIdTotals_U3_5
					,case when Programme.SportId=2 then Programme.OddValueDrawNoBet_2 else Programme.OddValueTotals_U3_5  end as OddValueTotals_U3_5

					,Programme.OddSpecialBetValueTotals_O4_5
					,Programme.OddIdTotals_O4_5,Programme.OddValueTotals_O4_5
					,Programme.OddIdTotals_U4_5,Programme.OddValueTotals_U4_5


					,Programme.OddIdDouble_1 as OddIdDouble_1X,Programme.OddValueDouble_1 as OddValueDouble_1X
					,Programme.OddIdDouble_X as OddIdDouble_X2,Programme.OddValueDouble_X as OddValueDouble_X2
					,Programme.OddIdDouble_2 as OddIdDouble_12,Programme.OddValueDouble_2 as OddValueDouble_12

					,Programme.OddIdBoth_Y ,Programme.OddValueBoth_Y
					,Programme.OddIdBoth_N ,Programme.OddValueBoth_N

					,  Programme.OddIdFirstScore_1 as OddIdFirstScore_1 
					,  Programme.OddValueFirstScore_1  as OddValueFirstScore_1 
					,  Programme.OddIdFirstScore_None  as OddIdFirstScore_None 
					, Programme.OddValueFirstScore_None  as OddValueFirstScore_None 
							, Programme.OddIdFirstScore_2  as OddIdFirstScore_2 
					,  Programme.OddValueFirstScore_2   as OddValueFirstScore_2 

					,Programme.OddIdFirstHalf_1 ,Programme.OddValueFirstHalf_1
					,Programme.OddIdFirstHalf_X ,Programme.OddValueFirstHalf_X
					,Programme.OddIdFirstHalf_2 ,Programme.OddValueFirstHalf_2
					
					,Programme.OddSpecialBetValueFirstHalfTotalsO_0_5
					,Programme.OddIdFirstHalfTotalsO_0_5,Programme.OddValueFirstHalfTotalsO_0_5  
					,Programme.OddIdFirstHalfTotalsU_0_5,Programme.OddValueFirstHalfTotalsU_0_5

					,Programme.OddSpecialBetValueFirstHalfTotalsO_1_5
					,Programme.OddIdFirstHalfTotalsO_1_5,Programme.OddValueFirstHalfTotalsO_1_5  
					,Programme.OddIdFirstHalfTotalsU_1_5,Programme.OddValueFirstHalfTotalsU_1_5

					 ,Programme.OutComeTennisScore_20 as OddSpecialBetValueTennisScore_20
					 ,Programme.OddIdTennisScore_20,Programme.OddValueTennisScore_20

					 ,Programme.OutComeTennisScore_02 as OddSpecialBetValueTennisScore_02
					 ,Programme.OddIdTennisScore_02,Programme.OddValueTennisScore_02

					  ,Programme.OutComeTennisScore_12 as OddSpecialBetValueTennisScore_12
					 ,Programme.OddIdTennisScore_12,Programme.OddValueTennisScore_12

					   ,Programme.OutComeTennisScore_21 as OddSpecialBetValueTennisScore_21
					 ,Programme.OddIdTennisScore_21,Programme.OddValueTennisScore_21

					    ,Programme.OddSpecialBetValueTennisTotal_O as OddSpecialBetValueTennisTotal
					 ,Programme.OddIdTennisTotal_O,Programme.OddValueTennisTotal_O
					 ,Programme.OddIdTennisTotal_U,Programme.OddValueTennisTotal_U

					    ,Programme.OddSpecialBetValueTotalSpread_O as OddSpecialBetValueBasketTotal
					 ,Programme.OddIdTotalSpread_O,Programme.OddValueTotalSpread_O
					 ,Programme.OddIdTotalSpread_U,Programme.OddValueTotalSpread_U

					 ,Programme.OddIdBasketFirstHalf_1 ,Programme.OddValueBasketFirstHalf_1
					,Programme.OddIdBasketFirstHalf_X ,Programme.OddValueBasketFirstHalf_x
					,Programme.OddIdBasketFirstHalf_2 ,Programme.OddValueBasketFirstHalf_2

						,Programme.OddIdTennisFirstSet_1,Programme.OddValueTennisFirstSet_1
					,Programme.OddIdTennisFirstSet_2,Programme.OddValueTennisFirstSet_2
	 ,Parameter.Competitor.BetradarSuperId as HomeTeamId
	,Competitor_1.BetradarSuperId as Away
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
					,(SELECT     COUNT(DISTINCT OddsTypeId)
                                        FROM          Match.Odd with (nolock)
                                                      WHERE      (Match.Odd.MatchId = Programme.MatchId) AND (Match.Odd.StateId = 2) and Match.Odd.OddValue>1) as OddTypeCount ,  
                    Programme.MatchDate as TournamentDate,case when (select COUNT(*) from Live.[EventDetail] with (nolock) where BetradarMatchIds=Programme.BetradarMatchId)>0 then cast(1 as bit) else cast(0 as bit) end as NeutralGround
					,null as HasStreaming,
					Language.[Parameter.Category].CategoryName
					,Parameter.Category.SequenceNumber,  SUBSTRING(LOWER(Parameter.Iso.IsoName2), 0, 3) AS IsoName
					,Parameter.Tournament.NewBetradarId as BetradarTournamentId
					,Programme.OddId1,CFF.OddValue1
					,Programme.OddId2,CFF.OddValue2
					,Programme.OddId3,CFF.OddValue3


						,  Programme.OddSpecialBetValueHadicap01_1  as OddSpecialBetValueHadicap01_1
					,Programme.OddIdHadicap01_1 as OddIdHadicap01_1
					,  Programme.OddValueHadicap01_1   as OddValueHadicap01_1
					, Programme.OddIdHadicap01_X  as OddIdHadicap01_X
					,  Programme.OddValueHadicap01_X  as OddValueHadicap01_X
					, Programme.OddIdHadicap01_2 as OddIdHadicap01_2 
					,  Programme.OddValueHadicap01_2 as OddValueHadicap01_2

					,Programme.OddSpecialBetValueHadicap02_1,Programme.OddIdHadicap02_1,Programme.OddValueHadicap02_1
					,Programme.OddIdHadicap02_X,Programme.OddValueHadicap02_X
					,Programme.OddIdHadicap02_2,Programme.OddValueHadicap02_2


					,Programme.OddSpecialBetValueHadicap10_1,Programme.OddIdHadicap10_1,Programme.OddValueHadicap10_1
					,Programme.OddIdHadicap10_X,Programme.OddValueHadicap10_X
					,Programme.OddIdHadicap10_2,Programme.OddValueHadicap10_2

					,Programme.OddSpecialBetValueHadicap20_1,Programme.OddIdHadicap20_1,Programme.OddValueHadicap20_1
					,Programme.OddIdHadicap20_X,Programme.OddValueHadicap20_X
					,Programme.OddIdHadicap20_2,Programme.OddValueHadicap20_2


						,case when Programme.SportId in (4,1) then Programme.OddSpecialBetValueTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddSpecialBetValueTotalSpread_O else Programme.OddSpecialBetValueTennisTotal_O end  end as OddSpecialBetValueTotals_O1_5
					,case when Programme.SportId in (4,1) then   Programme.OddIdTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddIdTotalSpread_O else  Programme.OddIdTennisTotal_O end end  as OddIdTotals_O1_5
					,case when Programme.SportId in (4,1) then   Programme.OddValueTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddValueTotalSpread_O else Programme.OddValueTennisTotal_O end end as OddValueTotals_O1_5
					,case when Programme.SportId in (4,1) then    Programme.OddIdTotals_U1_5 
					 else case when Programme.SportId not in (5,20) then  Programme.OddIdTotalSpread_U else Programme.OddIdTennisTotal_U end end as OddIdTotals_U1_5
					,case when Programme.SportId in (4,1) then  Programme.OddValueTotals_U1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddValueTotalSpread_U else Programme.OddValueTennisTotal_U end end as OddValueTotals_U1_5

					,case when Programme.SportId=2 then Programme.OddSpecialBetValueDartFirstSet_1 else OddSpecialBetValueTotals_O2_5 end   as OddSpecialBetValueTotals_O2_5  -- Basket Home OVer/Under
					,case when Programme.SportId=2 then Programme.OddIdDartFirstSet_1 else Programme.OddIdTotals_O2_5 end  as OddIdTotals_O2_5
					,case when Programme.SportId=2 then Programme.OddValueDartFirstSet_1 else Programme.OddValueTotals_O2_5  end as OddValueTotals_O2_5
					,case when Programme.SportId=2 then Programme.OddIdDartFirstSet_2  else Programme.OddIdTotals_U2_5 end as OddIdTotals_U2_5
					,case when Programme.SportId=2 then Programme.OddValueDartFirstSet_2 else Programme.OddValueTotals_U2_5  end as OddValueTotals_U2_5


						,case when Programme.SportId=2 then Programme.OddSpecialBetValueDrawNoBet_1 else OddSpecialBetValueTotals_O3_5 end   as  OddSpecialBetValueTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddIdDrawNoBet_1 else Programme.OddIdTotals_O3_5 end    as OddIdTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddValueDrawNoBet_1 else Programme.OddValueTotals_O3_5  end  as OddValueTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddIdDrawNoBet_2  else Programme.OddIdTotals_U3_5 end as OddIdTotals_U3_5
					,case when Programme.SportId=2 then Programme.OddValueDrawNoBet_2 else Programme.OddValueTotals_U3_5  end as OddValueTotals_U3_5

					,Programme.OddSpecialBetValueTotals_O4_5
					,Programme.OddIdTotals_O4_5,Programme.OddValueTotals_O4_5
					,Programme.OddIdTotals_U4_5,Programme.OddValueTotals_U4_5


					,Programme.OddIdDouble_1 as OddIdDouble_1X,Programme.OddValueDouble_1 as OddValueDouble_1X
					,Programme.OddIdDouble_X as OddIdDouble_X2,Programme.OddValueDouble_X as OddValueDouble_X2
					,Programme.OddIdDouble_2 as OddIdDouble_12,Programme.OddValueDouble_2 as OddValueDouble_12

					,Programme.OddIdBoth_Y ,Programme.OddValueBoth_Y
					,Programme.OddIdBoth_N ,Programme.OddValueBoth_N

				,  Programme.OddIdFirstScore_1 as OddIdFirstScore_1 
					,  Programme.OddValueFirstScore_1  as OddValueFirstScore_1 
					,  Programme.OddIdFirstScore_None  as OddIdFirstScore_None 
					, Programme.OddValueFirstScore_None  as OddValueFirstScore_None 
							, Programme.OddIdFirstScore_2  as OddIdFirstScore_2 
					,  Programme.OddValueFirstScore_2   as OddValueFirstScore_2 

					,Programme.OddIdFirstHalf_1 ,Programme.OddValueFirstHalf_1
					,Programme.OddIdFirstHalf_X ,Programme.OddValueFirstHalf_X
					,Programme.OddIdFirstHalf_2 ,Programme.OddValueFirstHalf_2
					
					,Programme.OddSpecialBetValueFirstHalfTotalsO_0_5
					,Programme.OddIdFirstHalfTotalsO_0_5,Programme.OddValueFirstHalfTotalsO_0_5  
					,Programme.OddIdFirstHalfTotalsU_0_5,Programme.OddValueFirstHalfTotalsU_0_5

					,Programme.OddSpecialBetValueFirstHalfTotalsO_1_5
					,Programme.OddIdFirstHalfTotalsO_1_5,Programme.OddValueFirstHalfTotalsO_1_5  
					,Programme.OddIdFirstHalfTotalsU_1_5,Programme.OddValueFirstHalfTotalsU_1_5

					 ,Programme.OutComeTennisScore_20 as OddSpecialBetValueTennisScore_20
					 ,Programme.OddIdTennisScore_20,Programme.OddValueTennisScore_20

					 ,Programme.OutComeTennisScore_02 as OddSpecialBetValueTennisScore_02
					 ,Programme.OddIdTennisScore_02,Programme.OddValueTennisScore_02

					  ,Programme.OutComeTennisScore_12 as OddSpecialBetValueTennisScore_12
					 ,Programme.OddIdTennisScore_12,Programme.OddValueTennisScore_12

					   ,Programme.OutComeTennisScore_21 as OddSpecialBetValueTennisScore_21
					 ,Programme.OddIdTennisScore_21,Programme.OddValueTennisScore_21

					    ,Programme.OddSpecialBetValueTennisTotal_O as OddSpecialBetValueTennisTotal
					 ,Programme.OddIdTennisTotal_O,Programme.OddValueTennisTotal_O
					 ,Programme.OddIdTennisTotal_U,Programme.OddValueTennisTotal_U

					    ,Programme.OddSpecialBetValueTotalSpread_O as OddSpecialBetValueBasketTotal
					 ,Programme.OddIdTotalSpread_O,Programme.OddValueTotalSpread_O
					 ,Programme.OddIdTotalSpread_U,Programme.OddValueTotalSpread_U

					 ,Programme.OddIdBasketFirstHalf_1 ,Programme.OddValueBasketFirstHalf_1
					,Programme.OddIdBasketFirstHalf_X ,Programme.OddValueBasketFirstHalf_x
					,Programme.OddIdBasketFirstHalf_2 ,Programme.OddValueBasketFirstHalf_2

						,Programme.OddIdTennisFirstSet_1,Programme.OddValueTennisFirstSet_1
					,Programme.OddIdTennisFirstSet_2,Programme.OddValueTennisFirstSet_2
	 ,Parameter.Competitor.BetradarSuperId as HomeTeamId
	,Competitor_1.BetradarSuperId as Away
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
						  Parameter.Sport.IsActive=1
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
					,(SELECT     COUNT(DISTINCT OddsTypeId)
                                        FROM          Match.Odd with (nolock)
                                                      WHERE      (Match.Odd.MatchId = Programme.MatchId) AND (Match.Odd.StateId = 2) and Match.Odd.OddValue>1) as OddTypeCount , 
                     Programme.MatchDate as TournamentDate,case when (select COUNT(*) from Live.[EventDetail] with (nolock) where BetradarMatchIds=Programme.BetradarMatchId)>0 then cast(1 as bit) else cast(0 as bit) end as NeutralGround
					,null as HasStreaming,
					Language.[Parameter.Category].CategoryName
					,Parameter.Category.SequenceNumber,  SUBSTRING(LOWER(Parameter.Iso.IsoName2), 0, 3) AS IsoName
					,Parameter.Tournament.NewBetradarId as BetradarTournamentId
					,Programme.OddId1,CFF.OddValue1
					,Programme.OddId2,CFF.OddValue2
					,Programme.OddId3,CFF.OddValue3


						,  Programme.OddSpecialBetValueHadicap01_1  as OddSpecialBetValueHadicap01_1
					,Programme.OddIdHadicap01_1 as OddIdHadicap01_1
					,  Programme.OddValueHadicap01_1   as OddValueHadicap01_1
					, Programme.OddIdHadicap01_X  as OddIdHadicap01_X
					,  Programme.OddValueHadicap01_X  as OddValueHadicap01_X
					, Programme.OddIdHadicap01_2 as OddIdHadicap01_2 
					,  Programme.OddValueHadicap01_2 as OddValueHadicap01_2

					,Programme.OddSpecialBetValueHadicap02_1,Programme.OddIdHadicap02_1,Programme.OddValueHadicap02_1
					,Programme.OddIdHadicap02_X,Programme.OddValueHadicap02_X
					,Programme.OddIdHadicap02_2,Programme.OddValueHadicap02_2


					,Programme.OddSpecialBetValueHadicap10_1,Programme.OddIdHadicap10_1,Programme.OddValueHadicap10_1
					,Programme.OddIdHadicap10_X,Programme.OddValueHadicap10_X
					,Programme.OddIdHadicap10_2,Programme.OddValueHadicap10_2

					,Programme.OddSpecialBetValueHadicap20_1,Programme.OddIdHadicap20_1,Programme.OddValueHadicap20_1
					,Programme.OddIdHadicap20_X,Programme.OddValueHadicap20_X
					,Programme.OddIdHadicap20_2,Programme.OddValueHadicap20_2


						,case when Programme.SportId in (4,1) then Programme.OddSpecialBetValueTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddSpecialBetValueTotalSpread_O else Programme.OddSpecialBetValueTennisTotal_O end  end as OddSpecialBetValueTotals_O1_5
					,case when Programme.SportId in (4,1) then   Programme.OddIdTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddIdTotalSpread_O else  Programme.OddIdTennisTotal_O end end  as OddIdTotals_O1_5
					,case when Programme.SportId in (4,1) then   Programme.OddValueTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddValueTotalSpread_O else Programme.OddValueTennisTotal_O end end as OddValueTotals_O1_5
					,case when Programme.SportId in (4,1) then    Programme.OddIdTotals_U1_5 
					 else case when Programme.SportId not in (5,20) then  Programme.OddIdTotalSpread_U else Programme.OddIdTennisTotal_U end end as OddIdTotals_U1_5
					,case when Programme.SportId in (4,1) then  Programme.OddValueTotals_U1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddValueTotalSpread_U else Programme.OddValueTennisTotal_U end end as OddValueTotals_U1_5

					,case when Programme.SportId=2 then Programme.OddSpecialBetValueDartFirstSet_1 else OddSpecialBetValueTotals_O2_5 end   as OddSpecialBetValueTotals_O2_5  -- Basket Home OVer/Under
					,case when Programme.SportId=2 then Programme.OddIdDartFirstSet_1 else Programme.OddIdTotals_O2_5 end  as OddIdTotals_O2_5
					,case when Programme.SportId=2 then Programme.OddValueDartFirstSet_1 else Programme.OddValueTotals_O2_5  end as OddValueTotals_O2_5
					,case when Programme.SportId=2 then Programme.OddIdDartFirstSet_2  else Programme.OddIdTotals_U2_5 end as OddIdTotals_U2_5
					,case when Programme.SportId=2 then Programme.OddValueDartFirstSet_2 else Programme.OddValueTotals_U2_5  end as OddValueTotals_U2_5


						,case when Programme.SportId=2 then Programme.OddSpecialBetValueDrawNoBet_1 else OddSpecialBetValueTotals_O3_5 end   as  OddSpecialBetValueTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddIdDrawNoBet_1 else Programme.OddIdTotals_O3_5 end    as OddIdTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddValueDrawNoBet_1 else Programme.OddValueTotals_O3_5  end  as OddValueTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddIdDrawNoBet_2  else Programme.OddIdTotals_U3_5 end as OddIdTotals_U3_5
					,case when Programme.SportId=2 then Programme.OddValueDrawNoBet_2 else Programme.OddValueTotals_U3_5  end as OddValueTotals_U3_5

					,Programme.OddSpecialBetValueTotals_O4_5
					,Programme.OddIdTotals_O4_5,Programme.OddValueTotals_O4_5
					,Programme.OddIdTotals_U4_5,Programme.OddValueTotals_U4_5


					,Programme.OddIdDouble_1 as OddIdDouble_1X,Programme.OddValueDouble_1 as OddValueDouble_1X
					,Programme.OddIdDouble_X as OddIdDouble_X2,Programme.OddValueDouble_X as OddValueDouble_X2
					,Programme.OddIdDouble_2 as OddIdDouble_12,Programme.OddValueDouble_2 as OddValueDouble_12

					,Programme.OddIdBoth_Y ,Programme.OddValueBoth_Y
					,Programme.OddIdBoth_N ,Programme.OddValueBoth_N

				,  Programme.OddIdFirstScore_1 as OddIdFirstScore_1 
					,  Programme.OddValueFirstScore_1  as OddValueFirstScore_1 
					,  Programme.OddIdFirstScore_None  as OddIdFirstScore_None 
					, Programme.OddValueFirstScore_None  as OddValueFirstScore_None 
							, Programme.OddIdFirstScore_2  as OddIdFirstScore_2 
					,  Programme.OddValueFirstScore_2   as OddValueFirstScore_2 

					,Programme.OddIdFirstHalf_1 ,Programme.OddValueFirstHalf_1
					,Programme.OddIdFirstHalf_X ,Programme.OddValueFirstHalf_X
					,Programme.OddIdFirstHalf_2 ,Programme.OddValueFirstHalf_2
					
					,Programme.OddSpecialBetValueFirstHalfTotalsO_0_5
					,Programme.OddIdFirstHalfTotalsO_0_5,Programme.OddValueFirstHalfTotalsO_0_5  
					,Programme.OddIdFirstHalfTotalsU_0_5,Programme.OddValueFirstHalfTotalsU_0_5

					,Programme.OddSpecialBetValueFirstHalfTotalsO_1_5
					,Programme.OddIdFirstHalfTotalsO_1_5,Programme.OddValueFirstHalfTotalsO_1_5  
					,Programme.OddIdFirstHalfTotalsU_1_5,Programme.OddValueFirstHalfTotalsU_1_5

					 ,Programme.OutComeTennisScore_20 as OddSpecialBetValueTennisScore_20
					 ,Programme.OddIdTennisScore_20,Programme.OddValueTennisScore_20

					 ,Programme.OutComeTennisScore_02 as OddSpecialBetValueTennisScore_02
					 ,Programme.OddIdTennisScore_02,Programme.OddValueTennisScore_02

					  ,Programme.OutComeTennisScore_12 as OddSpecialBetValueTennisScore_12
					 ,Programme.OddIdTennisScore_12,Programme.OddValueTennisScore_12

					   ,Programme.OutComeTennisScore_21 as OddSpecialBetValueTennisScore_21
					 ,Programme.OddIdTennisScore_21,Programme.OddValueTennisScore_21

					    ,Programme.OddSpecialBetValueTennisTotal_O as OddSpecialBetValueTennisTotal
					 ,Programme.OddIdTennisTotal_O,Programme.OddValueTennisTotal_O
					 ,Programme.OddIdTennisTotal_U,Programme.OddValueTennisTotal_U

					    ,Programme.OddSpecialBetValueTotalSpread_O as OddSpecialBetValueBasketTotal
					 ,Programme.OddIdTotalSpread_O,Programme.OddValueTotalSpread_O
					 ,Programme.OddIdTotalSpread_U,Programme.OddValueTotalSpread_U

					 ,Programme.OddIdBasketFirstHalf_1 ,Programme.OddValueBasketFirstHalf_1
					,Programme.OddIdBasketFirstHalf_X ,Programme.OddValueBasketFirstHalf_x
					,Programme.OddIdBasketFirstHalf_2 ,Programme.OddValueBasketFirstHalf_2

						,Programme.OddIdTennisFirstSet_1,Programme.OddValueTennisFirstSet_1
					,Programme.OddIdTennisFirstSet_2,Programme.OddValueTennisFirstSet_2
	 ,Parameter.Competitor.BetradarSuperId as HomeTeamId
	,Competitor_1.BetradarSuperId as Away
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
			-- cast(Programme.MatchDate as date)< case when (select Count(*) from @tblOdd where oddId=2682)=0 then cast(@EventDate as date) else  cast('20220901' as date) end
			--and 
			((CAST(Programme.MatchDate AS Date)>=(CAST(@StartDate AS Date)))) and  Programme.MatchDate>GETDATE() and   cast(DATEADD(HOUR,2,Programme.MatchDate) as date)<@EndDate and Parameter.Sport.IsActive=1
			order by Parameter.Tournament.SequenceNumber,Parameter.Tournament.TournamentId
end

else if (@SportId is not null)
begin

SELECT  top 100   Programme.BetradarMatchId,Programme.MatchId, Programme.MatchDate,Language.[Parameter.Tournament].TournamentName,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetitor_1.CompetitorName AS EventName, 
                    Language.[Parameter.Sport].SportName,Programme.TournamentId,Programme.SportId,Parameter.Category.CategoryId,Parameter.Sport.SportName as SportNameOrginal
					,(SELECT     COUNT(DISTINCT OddsTypeId)
                                        FROM          Match.Odd with (nolock)
                                                      WHERE      (Match.Odd.MatchId = Programme.MatchId) AND (Match.Odd.StateId = 2) and Match.Odd.OddValue>1) as OddTypeCount , 
                     Programme.MatchDate as TournamentDate,case when (select COUNT(*) from Live.[EventDetail] with (nolock) where BetradarMatchIds=Programme.BetradarMatchId)>0 then cast(1 as bit) else cast(0 as bit) end as NeutralGround
					,null  AS HasStreaming,
					Language.[Parameter.Category].CategoryName
					,Parameter.Tournament.SequenceNumber,  SUBSTRING(LOWER(Parameter.Iso.IsoName2), 0, 3) AS IsoName
					,Parameter.Tournament.NewBetradarId as BetradarTournamentId
					,Programme.OddId1,CFF.OddValue1
					,Programme.OddId2,CFF.OddValue2
					,Programme.OddId3,CFF.OddValue3


							,case when Programme.OddValue1<Programme.OddValue2 then  Programme.OddSpecialBetValueHadicap01_1 else Programme.OddSpecialBetValueHadicap10_1 end  as OddSpecialBetValueHadicap01_1
					,case when Programme.OddValue1<Programme.OddValue2 then Programme.OddIdHadicap01_1 else Programme.OddIdHadicap10_1 end as OddIdHadicap01_1
					,case when Programme.OddValue1<Programme.OddValue2 then Programme.OddValueHadicap01_1 else Programme.OddValueHadicap10_1 end as OddValueHadicap01_1
					,case when Programme.OddValue1<Programme.OddValue2 then Programme.OddIdHadicap01_X else Programme.OddIdHadicap10_X end as OddIdHadicap01_X
					,case when Programme.OddValue1<Programme.OddValue2 then  Programme.OddValueHadicap01_X else Programme.OddValueHadicap10_X end as OddValueHadicap01_X
					,case when Programme.OddValue1<Programme.OddValue2 then Programme.OddIdHadicap01_2 else Programme.OddIdHadicap10_2 end as OddIdHadicap01_2 
					,case when Programme.OddValue1<Programme.OddValue2 then Programme.OddValueHadicap01_2 else Programme.OddValueHadicap10_2 end as OddValueHadicap01_2

					,Programme.OddSpecialBetValueHadicap02_1,Programme.OddIdHadicap02_1,Programme.OddValueHadicap02_1
					,Programme.OddIdHadicap02_X,Programme.OddValueHadicap02_X
					,Programme.OddIdHadicap02_2,Programme.OddValueHadicap02_2


					,Programme.OddSpecialBetValueHadicap10_1,Programme.OddIdHadicap10_1,Programme.OddValueHadicap10_1
					,Programme.OddIdHadicap10_X,Programme.OddValueHadicap10_X
					,Programme.OddIdHadicap10_2,Programme.OddValueHadicap10_2

					,Programme.OddSpecialBetValueHadicap20_1,Programme.OddIdHadicap20_1,Programme.OddValueHadicap20_1
					,Programme.OddIdHadicap20_X,Programme.OddValueHadicap20_X
					,Programme.OddIdHadicap20_2,Programme.OddValueHadicap20_2

					
						,case when Programme.SportId in (4,1) then Programme.OddSpecialBetValueTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddSpecialBetValueTotalSpread_O else Programme.OddSpecialBetValueTennisTotal_O end  end as OddSpecialBetValueTotals_O1_5
					,case when Programme.SportId in (4,1) then   Programme.OddIdTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddIdTotalSpread_O else  Programme.OddIdTennisTotal_O end end  as OddIdTotals_O1_5
					,case when Programme.SportId in (4,1) then   Programme.OddValueTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddValueTotalSpread_O else Programme.OddValueTennisTotal_O end end as OddValueTotals_O1_5
					,case when Programme.SportId in (4,1) then    Programme.OddIdTotals_U1_5 
					 else case when Programme.SportId not in (5,20) then  Programme.OddIdTotalSpread_U else Programme.OddIdTennisTotal_U end end as OddIdTotals_U1_5
					,case when Programme.SportId in (4,1) then  Programme.OddValueTotals_U1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddValueTotalSpread_U else Programme.OddValueTennisTotal_U end end as OddValueTotals_U1_5

					,case when Programme.SportId=2 then Programme.OddSpecialBetValueDartFirstSet_1 else OddSpecialBetValueTotals_O2_5 end   as OddSpecialBetValueTotals_O2_5  -- Basket Home OVer/Under
					,case when Programme.SportId=2 then Programme.OddIdDartFirstSet_1 else Programme.OddIdTotals_O2_5 end  as OddIdTotals_O2_5
					,case when Programme.SportId=2 then Programme.OddValueDartFirstSet_1 else Programme.OddValueTotals_O2_5  end as OddValueTotals_O2_5
					,case when Programme.SportId=2 then Programme.OddIdDartFirstSet_2  else Programme.OddIdTotals_U2_5 end as OddIdTotals_U2_5
					,case when Programme.SportId=2 then Programme.OddValueDartFirstSet_2 else Programme.OddValueTotals_U2_5  end as OddValueTotals_U2_5


						,case when Programme.SportId=2 then Programme.OddSpecialBetValueDrawNoBet_1 else OddSpecialBetValueTotals_O3_5 end   as  OddSpecialBetValueTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddIdDrawNoBet_1 else Programme.OddIdTotals_O3_5 end    as OddIdTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddValueDrawNoBet_1 else Programme.OddValueTotals_O3_5  end  as OddValueTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddIdDrawNoBet_2  else Programme.OddIdTotals_U3_5 end as OddIdTotals_U3_5
					,case when Programme.SportId=2 then Programme.OddValueDrawNoBet_2 else Programme.OddValueTotals_U3_5  end as OddValueTotals_U3_5

					,Programme.OddSpecialBetValueTotals_O4_5
					,Programme.OddIdTotals_O4_5,Programme.OddValueTotals_O4_5
					,Programme.OddIdTotals_U4_5,Programme.OddValueTotals_U4_5


					,Programme.OddIdDouble_1 as OddIdDouble_1X,Programme.OddValueDouble_1 as OddValueDouble_1X
					,Programme.OddIdDouble_X as OddIdDouble_X2,Programme.OddValueDouble_X as OddValueDouble_X2
					,Programme.OddIdDouble_2 as OddIdDouble_12,Programme.OddValueDouble_2 as OddValueDouble_12

					,Programme.OddIdBoth_Y ,Programme.OddValueBoth_Y
					,Programme.OddIdBoth_N ,Programme.OddValueBoth_N

					,  Programme.OddIdFirstScore_1 as OddIdFirstScore_1 
					,  Programme.OddValueFirstScore_1  as OddValueFirstScore_1 
					,  Programme.OddIdFirstScore_None  as OddIdFirstScore_None 
					, Programme.OddValueFirstScore_None  as OddValueFirstScore_None 
							, Programme.OddIdFirstScore_2  as OddIdFirstScore_2 
					,  Programme.OddValueFirstScore_2   as OddValueFirstScore_2 

					,Programme.OddIdFirstHalf_1 ,Programme.OddValueFirstHalf_1
					,Programme.OddIdFirstHalf_X ,Programme.OddValueFirstHalf_X
					,Programme.OddIdFirstHalf_2 ,Programme.OddValueFirstHalf_2
					
					,Programme.OddSpecialBetValueFirstHalfTotalsO_0_5
					,Programme.OddIdFirstHalfTotalsO_0_5,Programme.OddValueFirstHalfTotalsO_0_5  
					,Programme.OddIdFirstHalfTotalsU_0_5,Programme.OddValueFirstHalfTotalsU_0_5

					,Programme.OddSpecialBetValueFirstHalfTotalsO_1_5
					,Programme.OddIdFirstHalfTotalsO_1_5,Programme.OddValueFirstHalfTotalsO_1_5  
					,Programme.OddIdFirstHalfTotalsU_1_5,Programme.OddValueFirstHalfTotalsU_1_5

					 ,Programme.OutComeTennisScore_20 as OddSpecialBetValueTennisScore_20
					 ,Programme.OddIdTennisScore_20,Programme.OddValueTennisScore_20

					 ,Programme.OutComeTennisScore_02 as OddSpecialBetValueTennisScore_02
					 ,Programme.OddIdTennisScore_02,Programme.OddValueTennisScore_02

					  ,Programme.OutComeTennisScore_12 as OddSpecialBetValueTennisScore_12
					 ,Programme.OddIdTennisScore_12,Programme.OddValueTennisScore_12

					   ,Programme.OutComeTennisScore_21 as OddSpecialBetValueTennisScore_21
					 ,Programme.OddIdTennisScore_21,Programme.OddValueTennisScore_21

					    ,Programme.OddSpecialBetValueTennisTotal_O as OddSpecialBetValueTennisTotal
					 ,Programme.OddIdTennisTotal_O,Programme.OddValueTennisTotal_O
					 ,Programme.OddIdTennisTotal_U,Programme.OddValueTennisTotal_U

					    ,Programme.OddSpecialBetValueTotalSpread_O as OddSpecialBetValueBasketTotal
					 ,Programme.OddIdTotalSpread_O,Programme.OddValueTotalSpread_O
					 ,Programme.OddIdTotalSpread_U,Programme.OddValueTotalSpread_U

					 ,Programme.OddIdBasketFirstHalf_1 ,Programme.OddValueBasketFirstHalf_1
					,Programme.OddIdBasketFirstHalf_X ,Programme.OddValueBasketFirstHalf_x
					,Programme.OddIdBasketFirstHalf_2 ,Programme.OddValueBasketFirstHalf_2

						,Programme.OddIdTennisFirstSet_1,Programme.OddValueTennisFirstSet_1
					,Programme.OddIdTennisFirstSet_2,Programme.OddValueTennisFirstSet_2
	 ,Parameter.Competitor.BetradarSuperId as HomeTeamId
	,Competitor_1.BetradarSuperId as Away
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
				--		and 
			 --cast(Programme.MatchDate as date)< case when Parameter.Tournament.IsPopularWeb=0 then cast(@EventDate as date) else  cast('20240901' as date) end 
			 and ((CAST(Programme.MatchDate AS Date)>=(CAST(@StartDate AS Date))))
			  and  Programme.MatchDate>GETDATE() and Parameter.Sport.IsActive=1 and   cast(DATEADD(HOUR,2,Programme.MatchDate) as date)<@EndDate
			order by Parameter.Tournament.SequenceNumber,Parameter.Tournament.TournamentId
end



	end

else  if (@SportId=-15) -- Fixture Top Event
	begin
  
		SELECT  top 200   Programme.BetradarMatchId,Programme.MatchId, Programme.MatchDate,Language.[Parameter.Tournament].TournamentName,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetitor_1.CompetitorName AS EventName, 
                    Language.[Parameter.Sport].SportName,Programme.TournamentId,Programme.SportId,Parameter.Category.CategoryId,Parameter.Sport.SportName as SportNameOrginal
					,(SELECT     COUNT(DISTINCT OddsTypeId)
                                        FROM          Match.Odd with (nolock)
                                                      WHERE      (Match.Odd.MatchId = Programme.MatchId) AND (Match.Odd.StateId = 2) and Match.Odd.OddValue>1) as OddTypeCount , 
                     Programme.MatchDate as TournamentDate,case when (select COUNT(*) from Live.[EventDetail] with (nolock) where BetradarMatchIds=Programme.BetradarMatchId)>0 then cast(1 as bit) else cast(0 as bit) end as NeutralGround
					,null as HasStreaming,
					Language.[Parameter.Category].CategoryName
					, ISNULL(Parameter.Tournament.SequenceNumber,999) as SequenceNumber,  SUBSTRING(LOWER(Parameter.Iso.IsoName2), 0, 3) AS IsoName
					,Parameter.Tournament.NewBetradarId as BetradarTournamentId
					,Programme.OddId1,CFF.OddValue1
					,Programme.OddId2,CFF.OddValue2
					,Programme.OddId3,CFF.OddValue3


						,  Programme.OddSpecialBetValueHadicap01_1  as OddSpecialBetValueHadicap01_1
					,Programme.OddIdHadicap01_1 as OddIdHadicap01_1
					,  Programme.OddValueHadicap01_1   as OddValueHadicap01_1
					, Programme.OddIdHadicap01_X  as OddIdHadicap01_X
					,  Programme.OddValueHadicap01_X  as OddValueHadicap01_X
					, Programme.OddIdHadicap01_2 as OddIdHadicap01_2 
					,  Programme.OddValueHadicap01_2 as OddValueHadicap01_2

					,Programme.OddSpecialBetValueHadicap02_1,Programme.OddIdHadicap02_1,Programme.OddValueHadicap02_1
					,Programme.OddIdHadicap02_X,Programme.OddValueHadicap02_X
					,Programme.OddIdHadicap02_2,Programme.OddValueHadicap02_2


					,Programme.OddSpecialBetValueHadicap10_1,Programme.OddIdHadicap10_1,Programme.OddValueHadicap10_1
					,Programme.OddIdHadicap10_X,Programme.OddValueHadicap10_X
					,Programme.OddIdHadicap10_2,Programme.OddValueHadicap10_2

					,Programme.OddSpecialBetValueHadicap20_1,Programme.OddIdHadicap20_1,Programme.OddValueHadicap20_1
					,Programme.OddIdHadicap20_X,Programme.OddValueHadicap20_X
					,Programme.OddIdHadicap20_2,Programme.OddValueHadicap20_2


						,case when Programme.SportId in (4,1) then Programme.OddSpecialBetValueTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddSpecialBetValueTotalSpread_O else Programme.OddSpecialBetValueTennisTotal_O end  end as OddSpecialBetValueTotals_O1_5
					,case when Programme.SportId in (4,1) then   Programme.OddIdTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddIdTotalSpread_O else  Programme.OddIdTennisTotal_O end end  as OddIdTotals_O1_5
					,case when Programme.SportId in (4,1) then   Programme.OddValueTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddValueTotalSpread_O else Programme.OddValueTennisTotal_O end end as OddValueTotals_O1_5
					,case when Programme.SportId in (4,1) then    Programme.OddIdTotals_U1_5 
					 else case when Programme.SportId not in (5,20) then  Programme.OddIdTotalSpread_U else Programme.OddIdTennisTotal_U end end as OddIdTotals_U1_5
					,case when Programme.SportId in (4,1) then  Programme.OddValueTotals_U1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddValueTotalSpread_U else Programme.OddValueTennisTotal_U end end as OddValueTotals_U1_5

					,case when Programme.SportId=2 then Programme.OddSpecialBetValueDartFirstSet_1 else OddSpecialBetValueTotals_O2_5 end   as OddSpecialBetValueTotals_O2_5  -- Basket Home OVer/Under
					,case when Programme.SportId=2 then Programme.OddIdDartFirstSet_1 else Programme.OddIdTotals_O2_5 end  as OddIdTotals_O2_5
					,case when Programme.SportId=2 then Programme.OddValueDartFirstSet_1 else Programme.OddValueTotals_O2_5  end as OddValueTotals_O2_5
					,case when Programme.SportId=2 then Programme.OddIdDartFirstSet_2  else Programme.OddIdTotals_U2_5 end as OddIdTotals_U2_5
					,case when Programme.SportId=2 then Programme.OddValueDartFirstSet_2 else Programme.OddValueTotals_U2_5  end as OddValueTotals_U2_5


						,case when Programme.SportId=2 then Programme.OddSpecialBetValueDrawNoBet_1 else OddSpecialBetValueTotals_O3_5 end   as  OddSpecialBetValueTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddIdDrawNoBet_1 else Programme.OddIdTotals_O3_5 end    as OddIdTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddValueDrawNoBet_1 else Programme.OddValueTotals_O3_5  end  as OddValueTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddIdDrawNoBet_2  else Programme.OddIdTotals_U3_5 end as OddIdTotals_U3_5
					,case when Programme.SportId=2 then Programme.OddValueDrawNoBet_2 else Programme.OddValueTotals_U3_5  end as OddValueTotals_U3_5

					,Programme.OddSpecialBetValueTotals_O4_5
					,Programme.OddIdTotals_O4_5,Programme.OddValueTotals_O4_5
					,Programme.OddIdTotals_U4_5,Programme.OddValueTotals_U4_5


					,Programme.OddIdDouble_1 as OddIdDouble_1X,Programme.OddValueDouble_1 as OddValueDouble_1X
					,Programme.OddIdDouble_X as OddIdDouble_X2,Programme.OddValueDouble_X as OddValueDouble_X2
					,Programme.OddIdDouble_2 as OddIdDouble_12,Programme.OddValueDouble_2 as OddValueDouble_12

					,Programme.OddIdBoth_Y ,Programme.OddValueBoth_Y
					,Programme.OddIdBoth_N ,Programme.OddValueBoth_N

					,  Programme.OddIdFirstScore_1 as OddIdFirstScore_1 
					,  Programme.OddValueFirstScore_1  as OddValueFirstScore_1 
					,  Programme.OddIdFirstScore_None  as OddIdFirstScore_None 
					, Programme.OddValueFirstScore_None  as OddValueFirstScore_None 
							, Programme.OddIdFirstScore_2  as OddIdFirstScore_2 
					,  Programme.OddValueFirstScore_2   as OddValueFirstScore_2 

					,Programme.OddIdFirstHalf_1 ,Programme.OddValueFirstHalf_1
					,Programme.OddIdFirstHalf_X ,Programme.OddValueFirstHalf_X
					,Programme.OddIdFirstHalf_2 ,Programme.OddValueFirstHalf_2
					
					,Programme.OddSpecialBetValueFirstHalfTotalsO_0_5
					,Programme.OddIdFirstHalfTotalsO_0_5,Programme.OddValueFirstHalfTotalsO_0_5  
					,Programme.OddIdFirstHalfTotalsU_0_5,Programme.OddValueFirstHalfTotalsU_0_5

					,Programme.OddSpecialBetValueFirstHalfTotalsO_1_5
					,Programme.OddIdFirstHalfTotalsO_1_5,Programme.OddValueFirstHalfTotalsO_1_5  
					,Programme.OddIdFirstHalfTotalsU_1_5,Programme.OddValueFirstHalfTotalsU_1_5

					 ,Programme.OutComeTennisScore_20 as OddSpecialBetValueTennisScore_20
					 ,Programme.OddIdTennisScore_20,Programme.OddValueTennisScore_20

					 ,Programme.OutComeTennisScore_02 as OddSpecialBetValueTennisScore_02
					 ,Programme.OddIdTennisScore_02,Programme.OddValueTennisScore_02

					  ,Programme.OutComeTennisScore_12 as OddSpecialBetValueTennisScore_12
					 ,Programme.OddIdTennisScore_12,Programme.OddValueTennisScore_12

					   ,Programme.OutComeTennisScore_21 as OddSpecialBetValueTennisScore_21
					 ,Programme.OddIdTennisScore_21,Programme.OddValueTennisScore_21

					    ,Programme.OddSpecialBetValueTennisTotal_O as OddSpecialBetValueTennisTotal
					 ,Programme.OddIdTennisTotal_O,Programme.OddValueTennisTotal_O
					 ,Programme.OddIdTennisTotal_U,Programme.OddValueTennisTotal_U

					    ,Programme.OddSpecialBetValueTotalSpread_O as OddSpecialBetValueBasketTotal
					 ,Programme.OddIdTotalSpread_O,Programme.OddValueTotalSpread_O
					 ,Programme.OddIdTotalSpread_U,Programme.OddValueTotalSpread_U

					 ,Programme.OddIdBasketFirstHalf_1 ,Programme.OddValueBasketFirstHalf_1
					,Programme.OddIdBasketFirstHalf_X ,Programme.OddValueBasketFirstHalf_x
					,Programme.OddIdBasketFirstHalf_2 ,Programme.OddValueBasketFirstHalf_2

						,Programme.OddIdTennisFirstSet_1,Programme.OddValueTennisFirstSet_1
					,Programme.OddIdTennisFirstSet_2,Programme.OddValueTennisFirstSet_2
	 ,Parameter.Competitor.BetradarSuperId as HomeTeamId
	,Competitor_1.BetradarSuperId as Away
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
						 --and  cast(Programme.MatchDate as date)< case when Parameter.Tournament.IsPopularWeb=0 then cast(@EventDate as date) else  cast('20240901' as date) end
						--  and  Programme.MatchDate< @EventDate 
						 and Parameter.Sport.IsActive=1 and Parameter.Sport.SportId=@CategoryId
						 	order by Parameter.Tournament.SequenceNumber--,Parameter.Tournament.TournamentId
	end
else  
	begin



	declare @Endatee nvarchar(50) 
if(cast(@EventDate as date)=cast(DATEADD(DAY,1,GETDATE()) as date))
	set @Endatee=cast(Cast(DATEADD(DAY,0,GETDATE()) as date) as nvarchar(10))+' 22:00:00.000'
else
	set @Endatee=@EventDate


		SELECT DISTINCT  top 150     Programme.BetradarMatchId,Programme.MatchId, Programme.MatchDate,Language.[Parameter.Tournament].TournamentName,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetitor_1.CompetitorName AS EventName, 
                    Language.[Parameter.Sport].SportName,Programme.TournamentId,Programme.SportId,Parameter.Category.CategoryId,Parameter.Sport.SportName as SportNameOrginal
					,(SELECT     COUNT(DISTINCT OddsTypeId)
                                        FROM          Match.Odd with (nolock)
                                                      WHERE      (Match.Odd.MatchId = Programme.MatchId) AND (Match.Odd.StateId = 2) and Match.Odd.OddValue>1) as OddTypeCount , 
                     Programme.MatchDate as TournamentDate,cast(1 as bit)  as NeutralGround
					,null as HasStreaming,
					Language.[Parameter.Category].CategoryName
					,Parameter.Tournament.SequenceNumber,  SUBSTRING(LOWER(Parameter.Iso.IsoName2), 0, 3) AS IsoName
					,Parameter.Tournament.NewBetradarId as BetradarTournamentId
					,Programme.OddId1,CFF.OddValue1
					,Programme.OddId2,CFF.OddValue2
					,Programme.OddId3,CFF.OddValue3


						,  Programme.OddSpecialBetValueHadicap01_1  as OddSpecialBetValueHadicap01_1
					,Programme.OddIdHadicap01_1 as OddIdHadicap01_1
					,  Programme.OddValueHadicap01_1   as OddValueHadicap01_1
					, Programme.OddIdHadicap01_X  as OddIdHadicap01_X
					,  Programme.OddValueHadicap01_X  as OddValueHadicap01_X
					, Programme.OddIdHadicap01_2 as OddIdHadicap01_2 
					,  Programme.OddValueHadicap01_2 as OddValueHadicap01_2

					,Programme.OddSpecialBetValueHadicap02_1,Programme.OddIdHadicap02_1,Programme.OddValueHadicap02_1
					,Programme.OddIdHadicap02_X,Programme.OddValueHadicap02_X
					,Programme.OddIdHadicap02_2,Programme.OddValueHadicap02_2


					,Programme.OddSpecialBetValueHadicap10_1,Programme.OddIdHadicap10_1,Programme.OddValueHadicap10_1
					,Programme.OddIdHadicap10_X,Programme.OddValueHadicap10_X
					,Programme.OddIdHadicap10_2,Programme.OddValueHadicap10_2

					,Programme.OddSpecialBetValueHadicap20_1,Programme.OddIdHadicap20_1,Programme.OddValueHadicap20_1
					,Programme.OddIdHadicap20_X,Programme.OddValueHadicap20_X
					,Programme.OddIdHadicap20_2,Programme.OddValueHadicap20_2


						,case when Programme.SportId in (4,1) then Programme.OddSpecialBetValueTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddSpecialBetValueTotalSpread_O else Programme.OddSpecialBetValueTennisTotal_O end  end as OddSpecialBetValueTotals_O1_5
					,case when Programme.SportId in (4,1) then   Programme.OddIdTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddIdTotalSpread_O else  Programme.OddIdTennisTotal_O end end  as OddIdTotals_O1_5
					,case when Programme.SportId in (4,1) then   Programme.OddValueTotals_O1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddValueTotalSpread_O else Programme.OddValueTennisTotal_O end end as OddValueTotals_O1_5
					,case when Programme.SportId in (4,1) then    Programme.OddIdTotals_U1_5 
					 else case when Programme.SportId not in (5,20) then  Programme.OddIdTotalSpread_U else Programme.OddIdTennisTotal_U end end as OddIdTotals_U1_5
					,case when Programme.SportId in (4,1) then  Programme.OddValueTotals_U1_5 
					 else case when Programme.SportId not in (5,20) then Programme.OddValueTotalSpread_U else Programme.OddValueTennisTotal_U end end as OddValueTotals_U1_5

					,case when Programme.SportId=2 then Programme.OddSpecialBetValueDartFirstSet_1 else OddSpecialBetValueTotals_O2_5 end   as OddSpecialBetValueTotals_O2_5  -- Basket Home OVer/Under
					,case when Programme.SportId=2 then Programme.OddIdDartFirstSet_1 else Programme.OddIdTotals_O2_5 end  as OddIdTotals_O2_5
					,case when Programme.SportId=2 then Programme.OddValueDartFirstSet_1 else Programme.OddValueTotals_O2_5  end as OddValueTotals_O2_5
					,case when Programme.SportId=2 then Programme.OddIdDartFirstSet_2  else Programme.OddIdTotals_U2_5 end as OddIdTotals_U2_5
					,case when Programme.SportId=2 then Programme.OddValueDartFirstSet_2 else Programme.OddValueTotals_U2_5  end as OddValueTotals_U2_5


						,case when Programme.SportId=2 then Programme.OddSpecialBetValueDrawNoBet_1 else OddSpecialBetValueTotals_O3_5 end   as  OddSpecialBetValueTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddIdDrawNoBet_1 else Programme.OddIdTotals_O3_5 end    as OddIdTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddValueDrawNoBet_1 else Programme.OddValueTotals_O3_5  end  as OddValueTotals_O3_5
					,case when Programme.SportId=2 then Programme.OddIdDrawNoBet_2  else Programme.OddIdTotals_U3_5 end as OddIdTotals_U3_5
					,case when Programme.SportId=2 then Programme.OddValueDrawNoBet_2 else Programme.OddValueTotals_U3_5  end as OddValueTotals_U3_5

					,Programme.OddSpecialBetValueTotals_O4_5
					,Programme.OddIdTotals_O4_5,Programme.OddValueTotals_O4_5
					,Programme.OddIdTotals_U4_5,Programme.OddValueTotals_U4_5


				,Programme.OddIdDouble_1 as OddIdDouble_1X,Programme.OddValueDouble_1 as OddValueDouble_1X
					,Programme.OddIdDouble_X as OddIdDouble_X2,Programme.OddValueDouble_X as OddValueDouble_X2
					,Programme.OddIdDouble_2 as OddIdDouble_12,Programme.OddValueDouble_2 as OddValueDouble_12

					,Programme.OddIdBoth_Y ,Programme.OddValueBoth_Y
					,Programme.OddIdBoth_N ,Programme.OddValueBoth_N

				,  Programme.OddIdFirstScore_1 as OddIdFirstScore_1 
					,  Programme.OddValueFirstScore_1  as OddValueFirstScore_1 
					,  Programme.OddIdFirstScore_None  as OddIdFirstScore_None 
					, Programme.OddValueFirstScore_None  as OddValueFirstScore_None 
							, Programme.OddIdFirstScore_2  as OddIdFirstScore_2 
					,  Programme.OddValueFirstScore_2   as OddValueFirstScore_2 


					,Programme.OddIdFirstHalf_1 ,Programme.OddValueFirstHalf_1
					,Programme.OddIdFirstHalf_X ,Programme.OddValueFirstHalf_X
					,Programme.OddIdFirstHalf_2 ,Programme.OddValueFirstHalf_2
					
					,Programme.OddSpecialBetValueFirstHalfTotalsO_0_5
					,Programme.OddIdFirstHalfTotalsO_0_5,Programme.OddValueFirstHalfTotalsO_0_5  
					,Programme.OddIdFirstHalfTotalsU_0_5,Programme.OddValueFirstHalfTotalsU_0_5

					,Programme.OddSpecialBetValueFirstHalfTotalsO_1_5
					,Programme.OddIdFirstHalfTotalsO_1_5,Programme.OddValueFirstHalfTotalsO_1_5  
					,Programme.OddIdFirstHalfTotalsU_1_5,Programme.OddValueFirstHalfTotalsU_1_5

					 ,Programme.OutComeTennisScore_20 as OddSpecialBetValueTennisScore_20
					 ,Programme.OddIdTennisScore_20,Programme.OddValueTennisScore_20

					 ,Programme.OutComeTennisScore_02 as OddSpecialBetValueTennisScore_02
					 ,Programme.OddIdTennisScore_02,Programme.OddValueTennisScore_02

					  ,Programme.OutComeTennisScore_12 as OddSpecialBetValueTennisScore_12
					 ,Programme.OddIdTennisScore_12,Programme.OddValueTennisScore_12

					   ,Programme.OutComeTennisScore_21 as OddSpecialBetValueTennisScore_21
					 ,Programme.OddIdTennisScore_21,Programme.OddValueTennisScore_21

					    ,Programme.OddSpecialBetValueTennisTotal_O as OddSpecialBetValueTennisTotal
					 ,Programme.OddIdTennisTotal_O,Programme.OddValueTennisTotal_O
					 ,Programme.OddIdTennisTotal_U,Programme.OddValueTennisTotal_U

					    ,Programme.OddSpecialBetValueTotalSpread_O as OddSpecialBetValueBasketTotal
					 ,Programme.OddIdTotalSpread_O,Programme.OddValueTotalSpread_O
					 ,Programme.OddIdTotalSpread_U,Programme.OddValueTotalSpread_U

					 ,Programme.OddIdBasketFirstHalf_1 ,Programme.OddValueBasketFirstHalf_1
					,Programme.OddIdBasketFirstHalf_X ,Programme.OddValueBasketFirstHalf_x
					,Programme.OddIdBasketFirstHalf_2 ,Programme.OddValueBasketFirstHalf_2

						,Programme.OddIdTennisFirstSet_1,Programme.OddValueTennisFirstSet_1
					,Programme.OddIdTennisFirstSet_2,Programme.OddValueTennisFirstSet_2
	 ,Parameter.Competitor.BetradarSuperId as HomeTeamId
	,Competitor_1.BetradarSuperId as Away
FROM         Parameter.Competitor AS Competitor_1 with (nolock) INNER JOIN
                      Parameter.Competitor with (nolock)  INNER JOIN
                      Language.ParameterCompetitor with (nolock) ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangComp INNER JOIN
                      Cache.Programme2 as Programme with (nolock) ON Parameter.Competitor.CompetitorId = Programme.[HomeTeam ] ON Competitor_1.CompetitorId = Programme.[AwayTeam ] INNER JOIN
					  Cache.Fixture as CFF with (nolock) ON CFF.MatchId=Programme.MatchId Inner JOIN
					  Match.Code with (nolock) On Match.Code.BetradarMatchId=Programme.BetradarMatchId and Match.Code.BetTypeId=1 INNER JOIN
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
						 and Programme.MatchDate< @Endatee and Parameter.Sport.SportId not in (21,17,31)
					 order by Parameter.Tournament.SequenceNumber

	end

end

END




GO
