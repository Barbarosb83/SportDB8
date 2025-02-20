USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcMatchEventSearch]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 

CREATE PROCEDURE [GamePlatform].[ProcMatchEventSearch] 
@SearchText nvarchar(10),
@LangId int

AS



BEGIN
SET NOCOUNT ON;


--declare @TempTable Table(Ids bigint)

declare @LangComp int=@LangId


if(@LangComp not in (2,3,6))
	set @LangComp=2

--insert @TempTable 
--select DISTINCT Language.ParameterCompetitor.CompetitorId
--FROM         
--                      Language.ParameterCompetitor with (nolock)  
--                       where Language.ParameterCompetitor.CompetitorName like '%'+@SearchText+'%' and Language.ParameterCompetitor.LanguageId=@LangComp



	SELECT     Programme.BetradarMatchId,Programme.MatchId, Programme.MatchDate,Language.[Parameter.Tournament].TournamentName,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetitor_1.CompetitorName AS EventName, 
                    Programme.SportName,Programme.TournamentId,Programme.SportId,Parameter.Category.CategoryId,Parameter.Sport.SportName as SportNameOrginal
					,(select COUNT(DISTINCT Match.Odd.OddsTypeId) from Match.Odd with (nolock) where Match.Odd.MatchId=Programme.MatchId) as OddTypeCount, 
                    Programme.TournamentId,Programme.MatchDate as TournamentDate,cast(0 as bit) NeutralGround
					,null AS HasStreaming,
					Language.[Parameter.Category].CategoryName
					,Parameter.Category.SequenceNumber
					,Programme.OddId1,Programme.OddValue1
					,Programme.OddId2,Programme.OddValue2
					,Programme.OddId3,Programme.OddValue3

					,Programme.OddSpecialBetValueHadicap01_1,Programme.OddIdHadicap01_1,Programme.OddValueHadicap01_1
					,Programme.OddIdHadicap01_X,Programme.OddValueHadicap01_X
					,Programme.OddIdHadicap01_2,Programme.OddValueHadicap01_2

					,Programme.OddSpecialBetValueHadicap02_1,Programme.OddIdHadicap02_1,Programme.OddValueHadicap02_1
					,Programme.OddIdHadicap02_X,Programme.OddValueHadicap02_X
					,Programme.OddIdHadicap02_2,Programme.OddValueHadicap02_2

					,Programme.OddSpecialBetValueHadicap10_1,Programme.OddIdHadicap10_1,Programme.OddValueHadicap10_1
					,Programme.OddIdHadicap10_X,Programme.OddValueHadicap10_X
					,Programme.OddIdHadicap10_2,Programme.OddValueHadicap10_2

					,Programme.OddSpecialBetValueHadicap20_1,Programme.OddIdHadicap20_1,Programme.OddValueHadicap20_1
					,Programme.OddIdHadicap20_X,Programme.OddValueHadicap20_X
					,Programme.OddIdHadicap20_2,Programme.OddValueHadicap20_2

					,Programme.OddSpecialBetValueTotals_O1_5,Programme.OddIdTotals_O1_5,Programme.OddValueTotals_O1_5
					,Programme.OddIdTotals_U1_5,Programme.OddValueTotals_U1_5

					,Programme.OddSpecialBetValueTotals_O2_5,Programme.OddIdTotals_O2_5,Programme.OddValueTotals_O2_5
					,Programme.OddIdTotals_U2_5,Programme.OddValueTotals_U2_5

					,Programme.OddSpecialBetValueTotals_O3_5,Programme.OddIdTotals_O3_5,Programme.OddValueTotals_O3_5
					,Programme.OddIdTotals_U3_5,Programme.OddValueTotals_U3_5

					,Programme.OddSpecialBetValueTotals_O4_5
					,Programme.OddIdTotals_O4_5,Programme.OddValueTotals_O4_5
					,Programme.OddIdTotals_U4_5,Programme.OddValueTotals_U4_5

					,Programme.OddIdDouble_1 as OddIdDouble_1X,Programme.OddValueDouble_1 as OddValueDouble_1X
					,Programme.OddIdDouble_X as OddIdDouble_X2,Programme.OddValueDouble_X as OddValueDouble_X2
					,Programme.OddIdDouble_2 as OddIdDouble_12,Programme.OddValueDouble_2 as OddValueDouble_12

					,Programme.OddIdBoth_Y ,Programme.OddValueBoth_Y
					,Programme.OddIdBoth_N ,Programme.OddValueBoth_N

					,Programme.OddIdFirstScore_1 ,Programme.OddValueFirstScore_1
					,Programme.OddIdFirstScore_None ,Programme.OddValueFirstScore_None
					,Programme.OddIdFirstScore_2 ,Programme.OddValueFirstScore_2

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
	
FROM        
                      Cache.Programme2 as Programme with (nolock) INNER JOIN
					  Language.ParameterCompetitor with (nolock) ON  Language.ParameterCompetitor.CompetitorId=Programme.[HomeTeam ] and Language.ParameterCompetitor.LanguageId=@LangComp INNER JOIN
                      Language.ParameterCompetitor AS ParameterCompetitor_1 with (nolock) ON  ParameterCompetitor_1.CompetitorId= Programme.[AwayTeam ] and ParameterCompetitor_1.LanguageId=@LangComp INNER JOIN 
						 Language.[Parameter.Tournament] with (nolock)  ON Language.[Parameter.Tournament].TournamentId=Programme.TournamentId and Language.[Parameter.Tournament].LanguageId=@LangId INNER JOIN 
						 Parameter.Tournament with (nolock) On Parameter.Tournament.TournamentId=Programme.TournamentId INNER JOIN
						 Parameter.Category with (nolock) On Parameter.Category.CategoryId=Parameter.Tournament.CategoryId INNER JOIN
						 Parameter.Sport with (nolock) on Parameter.Sport.SportId=Programme.SportId INNER JOIN
						 Language.[Parameter.Category] with (nolock) On Language.[Parameter.Category].CategoryId=Parameter.Category.CategoryId and  Language.[Parameter.Category].LanguageId=@LangId
						 where  Programme.MatchDate>DATEADD(MINUTE,5, GETDATE())  
						 and (ParameterCompetitor_1.CompetitorName like '%'+@SearchText+'%' or Language.ParameterCompetitor.CompetitorName like '%'+@SearchText+'%' )


END


GO
