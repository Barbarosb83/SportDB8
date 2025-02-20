USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Cache].[FillProgrammeUpdate]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Cache].[FillProgrammeUpdate]
	
AS

Begin
	SET NOCOUNT ON;

declare @LangId int=6
declare @TempTable table(MatchId bigint,CountBet int)

declare @LanguageId int
set @LanguageId = @LangId

  
 truncate table Cache.Programme
truncate table [Cache].[MatchOdd_Daily]

--44
--44
--47
--47
--52
--52
--229
--52
--55
--52
--52

insert into  [Cache].[MatchOdd_Daily]
select  Match.Odd.MatchId,Match.Odd.OddId,OutCome,SpecialBetValue,OddValue,BetradarOddTypeId,1 
from Match.Odd with (nolock) INNER JOIN 
[Cache].[FixtureProgramme] as TFixture with (nolock) ON Match.Odd.MatchId=TFixture.MatchId 
--INNER JOIN Match.OddSetting with (nolock) ON Match.OddSetting.OddId=Match.Odd.OddId
where Match.Odd.StateId=2 and Match.Odd.BetradarOddTypeId in  (332,41,42,43,44,46,47,55,56,202,204,206,208,226,231,233,284,324,327,328,383,52,229)
and TFixture.MatchDate  >= GETDATE() and TFixture.MatchDate  < DATEADD(DAY,1,GETDATE()) 


INSERT INTO [Cache].[Programme]
           ([MatchId]
           ,[BetradarMatchId]
           ,[MatchDate]
           ,[HomeTeam ]
           ,[AwayTeam ]
           ,[TournamentId]
           ,[SportId]
           ,[SportName]
           ,[OddId1]
           ,[OddValue1]
           ,[Odd1Visibility]
           ,[OddId2]
           ,[OddValue2]
           ,[Odd1Visibility2]
           ,[OddId3]
           ,[OddValue3]
           ,[Odd1Visibility3]
           ,[OddIdBasketFirstHalf_1]
           ,[OddIdBasketFirstHalf_2]
           ,[OddIdBasketFirstHalf_x]
           ,[OddIdBoth_N]
           ,[OddIdBoth_Y]
           ,[OddIdCorrectScore_00]
           ,[OddIdCorrectScore_01]
           ,[OddIdCorrectScore_02]
           ,[OddIdCorrectScore_03]
           ,[OddIdCorrectScore_10]
           ,[OddIdCorrectScore_11]
           ,[OddIdCorrectScore_12]
           ,[OddIdCorrectScore_13]
           ,[OddIdCorrectScore_20]
           ,[OddIdCorrectScore_21]
           ,[OddIdCorrectScore_22]
           ,[OddIdCorrectScore_23]
           ,[OddIdCorrectScore_30]
           ,[OddIdCorrectScore_31]
           ,[OddIdCorrectScore_32]
           ,[OddIdCorrectScore_33]
           ,[OddIdDartFirstSet_1]
           ,[OddIdDartFirstSet_2]
           ,[OddIdDouble_1]
           ,[OddIdDouble_2]
           ,[OddIdDouble_X]
           ,[OddIdDrawNoBet_1]
           ,[OddIdDrawNoBet_2]
           ,[OddIdFirst10_3Way1]
           ,[OddIdFirst10_3Way2]
           ,[OddIdFirst10_3WayX]
           ,[OddIdFirstHalf_1]
           ,[OddIdFirstHalf_2]
           ,[OddIdFirstHalf_X]
           ,[OddIdFirstHalfBoth_N]
           ,[OddIdFirstHalfBoth_Y]
           ,[OddIdFirstHalfDrawNo_1]
           ,[OddIdFirstHalfDrawNo_2]
           ,[OddIdFirstHalfTotalsO_0_5]
           ,[OddIdFirstHalfTotalsO_1_5]
           ,[OddIdFirstHalfTotalsO_2_5]
           ,[OddIdFirstHalfTotalsU_0_5]
           ,[OddIdFirstHalfTotalsU_1_5]
           ,[OddIdFirstHalfTotalsU_2_5]
           ,[OddIdFirstScore_1]
           ,[OddIdFirstScore_2]
           ,[OddIdFirstScore_None]
           ,[OddIdFutsalTotal_6_5O]
           ,[OddIdFutsalTotal_6_5U]
           ,[OddIdHadicap01_1]
           ,[OddIdHadicap01_2]
           ,[OddIdHadicap01_X]
           ,[OddIdHadicap02_1]
           ,[OddIdHadicap02_2]
           ,[OddIdHadicap02_X]
           ,[OddIdHadicap10_1]
           ,[OddIdHadicap10_2]
           ,[OddIdHadicap10_X]
           ,[OddIdHadicap20_1]
           ,[OddIdHadicap20_2]
           ,[OddIdHadicap20_X]
           ,[OddIdHalfFull_11]
           ,[OddIdHalfFull_12]
           ,[OddIdHalfFull_1X]
           ,[OddIdHalfFull_21]
           ,[OddIdHalfFull_22]
           ,[OddIdHalfFull_2X]
           ,[OddIdHalfFull_X1]
           ,[OddIdHalfFull_X2]
           ,[OddIdHalfFull_XX]
           ,[OddIdMatchBetTotal_2_5_OA]
           ,[OddIdMatchBetTotal_2_5_OD]
           ,[OddIdMatchBetTotal_2_5_OH]
           ,[OddIdMatchBetTotal_2_5_UA]
           ,[OddIdMatchBetTotal_2_5_UD]
           ,[OddIdMatchBetTotal_2_5_UH]
           ,[OddIdMatchBetTotal_3_5_OA]
           ,[OddIdMatchBetTotal_3_5_OD]
           ,[OddIdMatchBetTotal_3_5_OH]
           ,[OddIdMatchBetTotal_3_5_UA]
           ,[OddIdMatchBetTotal_3_5_UD]
           ,[OddIdMatchBetTotal_3_5_UH]
           ,[OddIdTennisFirstSet_1]
           ,[OddIdTennisFirstSet_2]
           ,[OddIdTennisScore_02]
           ,[OddIdTennisScore_12]
           ,[OddIdTennisScore_20]
           ,[OddIdTennisScore_21]
           ,[OddIdTennisSecondSet_1]
           ,[OddIdTennisSecondSet_2]
           ,[OddIdTennisSetNumber_2]
           ,[OddIdTennisSetNumber_3]
           ,[OddIdTennisTotal_O]
           ,[OddIdTennisTotal_U]
           ,[OddIdTotalGoals_0_1]
           ,[OddIdTotalGoals_2_3]
           ,[OddIdTotalGoals_4_5]
           ,[OddIdTotalGoals_6]
           ,[OddIdTotals_O1_5]
           ,[OddIdTotals_O2_5]
           ,[OddIdTotals_O3_5]
           ,[OddIdTotals_O4_5]
           ,[OddIdTotals_U1_5]
           ,[OddIdTotals_U2_5]
           ,[OddIdTotals_U3_5]
           ,[OddIdTotals_U4_5]
           ,[OddIdTotalSpread_O]
           ,[OddIdTotalSpread_U]
           ,[OddSpecialBetValueBasketFirstHalf_1]
           ,[OddSpecialBetValueBasketFirstHalf_2]
           ,[OddSpecialBetValueBasketFirstHalf_x]
           ,[OddSpecialBetValueBoth_N]
           ,[OddSpecialBetValueBoth_Y]
           ,[OddSpecialBetValueCorrectScore_00]
           ,[OddSpecialBetValueCorrectScore_01]
           ,[OddSpecialBetValueCorrectScore_02]
           ,[OddSpecialBetValueCorrectScore_03]
           ,[OddSpecialBetValueCorrectScore_10]
           ,[OddSpecialBetValueCorrectScore_11]
           ,[OddSpecialBetValueCorrectScore_12]
           ,[OddSpecialBetValueCorrectScore_13]
           ,[OddSpecialBetValueCorrectScore_20]
           ,[OddSpecialBetValueCorrectScore_21]
           ,[OddSpecialBetValueCorrectScore_22]
           ,[OddSpecialBetValueCorrectScore_23]
           ,[OddSpecialBetValueCorrectScore_30]
           ,[OddSpecialBetValueCorrectScore_31]
           ,[OddSpecialBetValueCorrectScore_32]
           ,[OddSpecialBetValueCorrectScore_33]
           ,[OddSpecialBetValueDartFirstSet_1]
           ,[OddSpecialBetValueDartFirstSet_2]
           ,[OddSpecialBetValueDouble_1]
           ,[OddSpecialBetValueDouble_2]
           ,[OddSpecialBetValueDouble_X]
           ,[OddSpecialBetValueDrawNoBet_1]
           ,[OddSpecialBetValueDrawNoBet_2]
           ,[OddSpecialBetValueFirst10_3Way1]
           ,[OddSpecialBetValueFirst10_3Way2]
           ,[OddSpecialBetValueFirst10_3WayX]
           ,[OddSpecialBetValueFirstHalf_1]
           ,[OddSpecialBetValueFirstHalf_2]
           ,[OddSpecialBetValueFirstHalf_X]
           ,[OddSpecialBetValueFirstHalfBoth_N]
           ,[OddSpecialBetValueFirstHalfBoth_Y]
           ,[OddSpecialBetValueFirstHalfDrawNo_1]
           ,[OddSpecialBetValueFirstHalfDrawNo_2]
           ,[OddSpecialBetValueFirstHalfTotalsO_0_5]
           ,[OddSpecialBetValueFirstHalfTotalsO_1_5]
           ,[OddSpecialBetValueFirstHalfTotalsO_2_5]
           ,[OddSpecialBetValueFirstHalfTotalsU_0_5]
           ,[OddSpecialBetValueFirstHalfTotalsU_1_5]
           ,[OddSpecialBetValueFirstHalfTotalsU_2_5]
           ,[OddSpecialBetValueFirstScore_1]
           ,[OddSpecialBetValueFirstScore_2]
           ,[OddSpecialBetValueFirstScore_None]
           ,[OddSpecialBetValueFutsalTotal_6_5O]
           ,[OddSpecialBetValueFutsalTotal_6_5U]
           ,[OddSpecialBetValueHadicap01_1]
           ,[OddSpecialBetValueHadicap01_2]
           ,[OddSpecialBetValueHadicap01_X]
           ,[OddSpecialBetValueHadicap02_1]
           ,[OddSpecialBetValueHadicap02_2]
           ,[OddSpecialBetValueHadicap02_X]
           ,[OddSpecialBetValueHadicap10_1]
           ,[OddSpecialBetValueHadicap10_2]
           ,[OddSpecialBetValueHadicap10_X]
           ,[OddSpecialBetValueHadicap20_1]
           ,[OddSpecialBetValueHadicap20_2]
           ,[OddSpecialBetValueHadicap20_X]
           ,[OddSpecialBetValueHalfFull_11]
           ,[OddSpecialBetValueHalfFull_12]
           ,[OddSpecialBetValueHalfFull_1X]
           ,[OddSpecialBetValueHalfFull_21]
           ,[OddSpecialBetValueHalfFull_22]
           ,[OddSpecialBetValueHalfFull_2X]
           ,[OddSpecialBetValueHalfFull_X1]
           ,[OddSpecialBetValueHalfFull_X2]
           ,[OddSpecialBetValueHalfFull_XX]
           ,[OddSpecialBetValueMatchBetTotal_2_5_OA]
           ,[OddSpecialBetValueMatchBetTotal_2_5_OD]
           ,[OddSpecialBetValueMatchBetTotal_2_5_OH]
           ,[OddSpecialBetValueMatchBetTotal_2_5_UA]
           ,[OddSpecialBetValueMatchBetTotal_2_5_UD]
           ,[OddSpecialBetValueMatchBetTotal_2_5_UH]
           ,[OddSpecialBetValueMatchBetTotal_3_5_OA]
           ,[OddSpecialBetValueMatchBetTotal_3_5_OD]
           ,[OddSpecialBetValueMatchBetTotal_3_5_OH]
           ,[OddSpecialBetValueMatchBetTotal_3_5_UA]
           ,[OddSpecialBetValueMatchBetTotal_3_5_UD]
           ,[OddSpecialBetValueMatchBetTotal_3_5_UH]
           ,[OddSpecialBetValueTennisFirstSet_1]
           ,[OddSpecialBetValueTennisFirstSet_2]
           ,[OddSpecialBetValueTennisScore_02]
           ,[OddSpecialBetValueTennisScore_12]
           ,[OddSpecialBetValueTennisScore_20]
           ,[OddSpecialBetValueTennisScore_21]
           ,[OddSpecialBetValueTennisSecondSet_1]
           ,[OddSpecialBetValueTennisSecondSet_2]
           ,[OddSpecialBetValueTennisSetNumber_2]
           ,[OddSpecialBetValueTennisSetNumber_3]
           ,[OddSpecialBetValueTennisTotal_O]
           ,[OddSpecialBetValueTennisTotal_U]
           ,[OddSpecialBetValueTotalGoals_0_1]
           ,[OddSpecialBetValueTotalGoals_2_3]
           ,[OddSpecialBetValueTotalGoals_4_5]
           ,[OddSpecialBetValueTotalGoals_6]
           ,[OddSpecialBetValueTotals_O1_5]
           ,[OddSpecialBetValueTotals_O2_5]
           ,[OddSpecialBetValueTotals_O3_5]
           ,[OddSpecialBetValueTotals_O4_5]
           ,[OddSpecialBetValueTotals_U1_5]
           ,[OddSpecialBetValueTotals_U2_5]
           ,[OddSpecialBetValueTotals_U3_5]
           ,[OddSpecialBetValueTotals_U4_5]
           ,[OddSpecialBetValueTotalSpread_O]
           ,[OddSpecialBetValueTotalSpread_U]
           ,[OddValueBasketFirstHalf_1]
           ,[OddValueBasketFirstHalf_2]
           ,[OddValueBasketFirstHalf_x]
           ,[OddValueBoth_N]
           ,[OddValueBoth_Y]
           ,[OddValueCorrectScore_00]
           ,[OddValueCorrectScore_01]
           ,[OddValueCorrectScore_02]
           ,[OddValueCorrectScore_03]
           ,[OddValueCorrectScore_10]
           ,[OddValueCorrectScore_11]
           ,[OddValueCorrectScore_12]
           ,[OddValueCorrectScore_13]
           ,[OddValueCorrectScore_20]
           ,[OddValueCorrectScore_21]
           ,[OddValueCorrectScore_22]
           ,[OddValueCorrectScore_23]
           ,[OddValueCorrectScore_30]
           ,[OddValueCorrectScore_31]
           ,[OddValueCorrectScore_32]
           ,[OddValueCorrectScore_33]
           ,[OddValueDartFirstSet_1]
           ,[OddValueDartFirstSet_2]
           ,[OddValueDouble_1]
           ,[OddValueDouble_2]
           ,[OddValueDouble_X]
           ,[OddValueDrawNoBet_1]
           ,[OddValueDrawNoBet_2]
           ,[OddValueFirst10_3Way1]
           ,[OddValueFirst10_3Way2]
           ,[OddValueFirst10_3WayX]
           ,[OddValueFirstHalf_1]
           ,[OddValueFirstHalf_2]
           ,[OddValueFirstHalf_X]
           ,[OddValueFirstHalfBoth_N]
           ,[OddValueFirstHalfBoth_Y]
           ,[OddValueFirstHalfDrawNo_1]
           ,[OddValueFirstHalfDrawNo_2]
           ,[OddValueFirstHalfTotalsO_0_5]
           ,[OddValueFirstHalfTotalsO_1_5]
           ,[OddValueFirstHalfTotalsO_2_5]
           ,[OddValueFirstHalfTotalsU_0_5]
           ,[OddValueFirstHalfTotalsU_1_5]
           ,[OddValueFirstHalfTotalsU_2_5]
           ,[OddValueFirstScore_1]
           ,[OddValueFirstScore_2]
           ,[OddValueFirstScore_None]
           ,[OddValueFutsalTotal_6_5O]
           ,[OddValueFutsalTotal_6_5U]
           ,[OddValueHadicap01_1]
           ,[OddValueHadicap01_2]
           ,[OddValueHadicap01_X]
           ,[OddValueHadicap02_1]
           ,[OddValueHadicap02_2]
           ,[OddValueHadicap02_X]
           ,[OddValueHadicap10_1]
           ,[OddValueHadicap10_2]
           ,[OddValueHadicap10_X]
           ,[OddValueHadicap20_1]
           ,[OddValueHadicap20_2]
           ,[OddValueHadicap20_X]
           ,[OddValueHalfFull_11]
           ,[OddValueHalfFull_12]
           ,[OddValueHalfFull_1X]
           ,[OddValueHalfFull_21]
           ,[OddValueHalfFull_22]
           ,[OddValueHalfFull_2X]
           ,[OddValueHalfFull_X1]
           ,[OddValueHalfFull_X2]
           ,[OddValueHalfFull_XX]
           ,[OddValueMatchBetTotal_2_5_OA]
           ,[OddValueMatchBetTotal_2_5_OD]
           ,[OddValueMatchBetTotal_2_5_OH]
           ,[OddValueMatchBetTotal_2_5_UA]
           ,[OddValueMatchBetTotal_2_5_UD]
           ,[OddValueMatchBetTotal_2_5_UH]
           ,[OddValueMatchBetTotal_3_5_OA]
           ,[OddValueMatchBetTotal_3_5_OD]
           ,[OddValueMatchBetTotal_3_5_OH]
           ,[OddValueMatchBetTotal_3_5_UA]
           ,[OddValueMatchBetTotal_3_5_UD]
           ,[OddValueMatchBetTotal_3_5_UH]
           ,[OddValueTennisFirstSet_1]
           ,[OddValueTennisFirstSet_2]
           ,[OddValueTennisScore_02]
           ,[OddValueTennisScore_12]
           ,[OddValueTennisScore_20]
           ,[OddValueTennisScore_21]
           ,[OddValueTennisSecondSet_1]
           ,[OddValueTennisSecondSet_2]
           ,[OddValueTennisSetNumber_2]
           ,[OddValueTennisSetNumber_3]
           ,[OddValueTennisTotal_O]
           ,[OddValueTennisTotal_U]
           ,[OddValueTotalGoals_0_1]
           ,[OddValueTotalGoals_2_3]
           ,[OddValueTotalGoals_4_5]
           ,[OddValueTotalGoals_6]
           ,[OddValueTotals_O1_5]
           ,[OddValueTotals_O2_5]
           ,[OddValueTotals_O3_5]
           ,[OddValueTotals_O4_5]
           ,[OddValueTotals_U1_5]
           ,[OddValueTotals_U2_5]
           ,[OddValueTotals_U3_5]
           ,[OddValueTotals_U4_5]
           ,[OddValueTotalSpread_O]
           ,[OddValueTotalSpread_U]
           
           ,[OutComeBasketFirstHalf_1]
           ,[OutComeBasketFirstHalf_2]
           ,[OutComeBasketFirstHalf_x]
           ,[OutComeCorrectScore_00]
           ,[OutComeCorrectScore_01]
           ,[OutComeCorrectScore_02]
           ,[OutComeCorrectScore_03]
           ,[OutComeCorrectScore_10]
           ,[OutComeCorrectScore_11]
           ,[OutComeCorrectScore_12]
           ,[OutComeCorrectScore_13]
           ,[OutComeCorrectScore_20]
           ,[OutComeCorrectScore_21]
           ,[OutComeCorrectScore_22]
           ,[OutComeCorrectScore_23]
           ,[OutComeCorrectScore_30]
           ,[OutComeCorrectScore_31]
           ,[OutComeCorrectScore_32]
           ,[OutComeCorrectScore_33]
           ,[OutComeDartFirstSet_1]
           ,[OutComeDartFirstSet_2]
           ,[OutComeDrawNoBet_1]
           ,[OutComeDrawNoBet_2]
           ,[OutComeFirstHalf_1]
           ,[OutComeFirstHalf_2]
           ,[OutComeFirstHalf_X]
           ,[OutComeFirstHalfBoth_N]
           ,[OutComeFirstHalfDrawNo_1]
           ,[OutComeFirstHalfTotalsO_0_5]
           ,[OutComeFirstHalfTotalsO_1_5]
           ,[OutComeFirstHalfTotalsO_2_5]
           ,[OutComeFirstHalfTotalsU_0_5]
           ,[OutComeFirstHalfTotalsU_1_5]
           ,[OutComeFirstHalfTotalsU_2_5]
           ,[OutComeFirstScore_2]
           ,[OutComeFutsalTotal_6_5O]
           ,[OutComeFutsalTotal_6_5U]
           ,[OutComeHadicap10_1]
           ,[OutComeHadicap10_2]
           ,[OutComeHadicap10_X]
           ,[OutComeHadicap20_1]
           ,[OutComeHadicap20_2]
           ,[OutComeHadicap20_X]
           ,[OutComeHalfFull_11]
           ,[OutComeHalfFull_1X]
           ,[OutComeHalfFull_21]
           ,[OutComeHalfFull_2X]
           ,[OutComeHalfFull_X1]
           ,[OutComeHalfFull_XX]
           ,[OutComeMatchBetTotal_2_5_OA]
           ,[OutComeMatchBetTotal_2_5_OD]
           ,[OutComeMatchBetTotal_2_5_OH]
           ,[OutComeMatchBetTotal_2_5_UA]
           ,[OutComeMatchBetTotal_2_5_UD]
           ,[OutComeMatchBetTotal_2_5_UH]
           ,[OutComeMatchBetTotal_3_5_OA]
           ,[OutComeMatchBetTotal_3_5_OD]
           ,[OutComeMatchBetTotal_3_5_OH]
           ,[OutComeMatchBetTotal_3_5_UA]
           ,[OutComeMatchBetTotal_3_5_UD]
           ,[OutComeMatchBetTotal_3_5_UH]
           ,[OutComeTennisFirstSet_1]
           ,[OutComeTennisFirstSet_2]
           ,[OutComeTennisScore_02]
           ,[OutComeTennisScore_12]
           ,[OutComeTennisScore_20]
           ,[OutComeTennisScore_21]
           ,[OutComeTennisSecondSet_1]
           ,[OutComeTennisSecondSet_2]
           ,[OutComeTennisSetNumber_2]
           ,[OutComeTennisSetNumber_3]
           ,[OutComeTennisTotal_O]
           ,[OutComeTennisTotal_U]
           ,[OutComeTotalGoals_0_1]
           ,[OutComeTotalGoals_2_3]
           ,[OutComeTotalGoals_4_5]
           ,[OutComeTotalGoals_6]
           ,[OutComeTotalSpread_O]
           ,[OutComeTotalSpread_U])
   SELECT DISTINCT
CacheFixture.MatchId
,CacheFixture.BetradarMatchId
,CacheFixture.MatchDate
  ,CacheFixture.HomeTeam 
  ,CacheFixture.AwayTeam 
  ,CacheFixture.TournamentId
  ,CacheFixture.SportId
  ,CacheFixture.SportName
					  ,CacheFixture.OddId1
					  ,CacheFixture.OddValue1
					  ,CacheFixture.Odd1Visibility

					  ,CacheFixture.OddId2
					  ,CacheFixture.OddValue2
					  ,CacheFixture.Odd1Visibility2

					  ,CacheFixture.OddId3
					  ,CacheFixture.OddValue3
					  ,CacheFixture.Odd1Visibility3

					     ,TPBasketFirstHalf_1.OddId as OddIdBasketFirstHalf_1
  ,TPBasketFirstHalf_2.Id as OddIdBasketFirstHalf_2
  ,TPBasketFirstHalf_x.Id as OddIdBasketFirstHalf_x
,TPBothN.OddId as OddIdBoth_N
 ,TPBothY.OddId as OddIdBoth_Y
  ,0 as OddIdCorrectScore_00
  ,0 as OddIdCorrectScore_01
  ,0 as OddIdCorrectScore_02
  ,0 as OddIdCorrectScore_03
  ,0 as OddIdCorrectScore_10
  ,0 as OddIdCorrectScore_11
  ,0 as OddIdCorrectScore_12
  ,0 as OddIdCorrectScore_13
  ,0 as OddIdCorrectScore_20
  ,0 as OddIdCorrectScore_21
  ,0 as OddIdCorrectScore_22
  ,0 as OddIdCorrectScore_23
  ,0 as [OddIdCorrectScore_30]
  ,0 as [OddIdCorrectScore_31]
  ,0 as [OddIdCorrectScore_32]
  ,0 as [OddIdCorrectScore_33]
  ,0 as [OddIdDartFirstSet_1]
  ,0 as [OddIdDartFirstSet_2]
 ,TPDouble1.OddId as [OddIdDouble_1]
 ,TPDouble2.OddId as [OddIdDouble_2]
 ,TPDoublex.OddId as [OddIdDouble_X]
  ,0 as [OddIdDrawNoBet_1]
  ,0 as [OddIdDrawNoBet_2]
 ,0 as [OddIdFirst10_3Way1]
 ,0 as [OddIdFirst10_3Way2]
 ,0 as [OddIdFirst10_3WayX]
  ,TPFirstHalf1.OddId as [OddIdFirstHalf_1]
  ,TPFirstHalf2.OddId as [OddIdFirstHalf_2]
  ,TPFirstHalfx.OddId as [OddIdFirstHalf_X]
  ,0 as [OddIdFirstHalfBoth_N]
 ,0 as [OddIdFirstHalfBoth_Y]
,0 as [OddIdFirstHalfDrawNo_1]
 ,0 as [OddIdFirstHalfDrawNo_2]
  ,TPFirstHalfTotalsO05.OddId as [OddIdFirstHalfTotalsO_0_5]
  ,TPFirstHalfTotalsO15.OddId as [OddIdFirstHalfTotalsO_1_5]
  ,TPFirstHalfTotalsO25.OddId as [OddIdFirstHalfTotalsO_2_5]
  ,TPFirstHalfTotalsU05.OddId as [OddIdFirstHalfTotalsU_0_5]
  ,TPFirstHalfTotalsU15.OddId as [OddIdFirstHalfTotalsU_1_5]
  ,TPFirstHalfTotalsU25.OddId as [OddIdFirstHalfTotalsU_2_5]
 ,TPFirstScore1.OddId as [OddIdFirstScore_1]
  ,TPFirstScore2.OddId as [OddIdFirstScore_2]
 ,TPFirstScoreX.OddId as [OddIdFirstScore_None]
  ,0 as [OddIdFutsalTotal_6_5O]
  ,0 as [OddIdFutsalTotal_6_5U]
 ,TPO11.OddId as [OddIdHadicap01_1]
 ,TPO12.OddId as [OddIdHadicap01_2]
 ,TPO1x.OddId as [OddIdHadicap01_X]
 ,TPO21.OddId as [OddIdHadicap02_1]
 ,TPO22.OddId  as  [OddIdHadicap02_2]
 ,TPO2x.OddId  as [OddIdHadicap02_X]
 ,TP101.OddId  as [OddIdHadicap10_1]
  ,TP102.OddId as [OddIdHadicap10_2]
  ,TP10x.OddId as [OddIdHadicap10_X]
 ,TP201.OddId as [OddIdHadicap20_1]
  ,TP202.OddId as [OddIdHadicap20_2]
  ,TP20x.OddId as [OddIdHadicap20_X]
  ,0 as [OddIdHalfFull_11]
  ,0 as [OddIdHalfFull_12]
 ,0 as [OddIdHalfFull_1X]
,0 as [OddIdHalfFull_21]
,0 as [OddIdHalfFull_22]
 ,0 as [OddIdHalfFull_2X]
,0 as [OddIdHalfFull_X1]
,0 as [OddIdHalfFull_X2]
 ,0 as [OddIdHalfFull_XX]
,0 as [OddIdMatchBetTotal_2_5_OA]
   ,0 as [OddIdMatchBetTotal_2_5_OD]
   ,0 as [OddIdMatchBetTotal_2_5_OH]
,0 as [OddIdMatchBetTotal_2_5_UA]
   ,0 as [OddIdMatchBetTotal_2_5_UD]
  ,0 as [OddIdMatchBetTotal_2_5_UH]
 ,0 as [OddIdMatchBetTotal_3_5_OA]
   ,0 as [OddIdMatchBetTotal_3_5_OD]
   ,0 as [OddIdMatchBetTotal_3_5_OH]
   ,0 as [OddIdMatchBetTotal_3_5_UA]
   ,0 as [OddIdMatchBetTotal_3_5_UD]
   ,0 as [OddIdMatchBetTotal_3_5_UH]
  ,TPTennisFirstSet_1.OddId as [OddIdTennisFirstSet_1]
  ,TPTennisFirstSet_2.OddId as [OddIdTennisFirstSet_2]
  ,TPTennisScore_02.OddId as [OddIdTennisScore_02]
   ,TPTennisScore_12.OddId as [OddIdTennisScore_12]
   ,TPTennisScore_20.OddId as [OddIdTennisScore_20]
  ,TPTennisScore_21.OddId as [OddIdTennisScore_21]
   ,0 as [OddIdTennisSecondSet_1]
  ,0 as [OddIdTennisSecondSet_2]
  ,0 as [OddIdTennisSetNumber_2]
  ,0 as [OddIdTennisSetNumber_3]
  ,( select top 1 TPTennisTotal_O.OddId from [Cache].[MatchOdd_Daily] as TPTennisTotal_O with (nolock)  where TPTennisTotal_O.OddsTypeId=226 and TPTennisTotal_O.MatchId=CacheFixture.MatchId and TPTennisTotal_O.OutCome='Over' order by TPTennisTotal_O.SpecialBetValue desc) as [OddIdTennisTotal_O]
  ,( select top 1 TPTennisTotal_U.OddId from [Cache].[MatchOdd_Daily] as TPTennisTotal_U with (nolock)  where TPTennisTotal_U.OddsTypeId=226 and TPTennisTotal_U.MatchId=CacheFixture.MatchId and TPTennisTotal_U.OutCome='Under' order by TPTennisTotal_U.SpecialBetValue desc) as [OddIdTennisTotal_U]
  ,0 as [OddIdTotalGoals_0_1]
  ,0 as [OddIdTotalGoals_2_3]
  ,0 as [OddIdTotalGoals_4_5]
  ,0 as [OddIdTotalGoals_6]
  ,TPTotalsO15.OddId as [OddIdTotals_O1_5]
 ,TPTotalsO.OddId as [OddIdTotals_O2_5]
 ,TPTotalsO35.OddId as [OddIdTotals_O3_5]
 ,TPTotalsO45.OddId as [OddIdTotals_O4_5]
 ,TPTotalsU15.OddId as [OddIdTotals_U1_5]
 ,TPTotalsU.OddId as [OddIdTotals_U2_5]
 ,TPTotalsU35.OddId as [OddIdTotals_U3_5]
 ,TPTotalsU45.OddId as [OddIdTotals_U4_5]
,( select top 1 TPTotalSpreddO.OddId from [Cache].[MatchOdd_Daily] as TPTotalSpreddO with (nolock)  where OddsTypeId =383 and MatchId=CacheFixture.MatchId and OutCome='Over' order by SpecialBetValue desc) as [OddIdTotalSpread_O]
 ,( select top 1 TPTotalSpreddO.OddId from [Cache].[MatchOdd_Daily] as TPTotalSpreddO with (nolock)  where OddsTypeId =383 and MatchId=CacheFixture.MatchId and OutCome='Under' order by SpecialBetValue desc) as [OddIdTotalSpread_U]


 ,TPBasketFirstHalf_1.SpecialBetValue as OddSpecialBetValueBasketFirstHalf_1
 ,TPBasketFirstHalf_2.SpecialBetValue as OddSpecialBetValueBasketFirstHalf_2
 ,TPBasketFirstHalf_x.SpecialBetValue as OddSpecialBetValueBasketFirstHalf_x
 ,TPBothN.SpecialBetValue as OddSpecialBetValueBoth_N
 ,TPBothY.SpecialBetValue as OddSpecialBetValueBoth_Y
 ,TPCorrectScore_00.SpecialBetValue as OddSpecialBetValueCorrectScore_00
 ,TPCorrectScore_01.SpecialBetValue as OddSpecialBetValueCorrectScore_01
 ,TPCorrectScore_02.SpecialBetValue as OddSpecialBetValueCorrectScore_02
 ,TPCorrectScore_03.SpecialBetValue as OddSpecialBetValueCorrectScore_03
 ,TPCorrectScore_10.SpecialBetValue as OddSpecialBetValueCorrectScore_10
 ,TPCorrectScore_11.SpecialBetValue as OddSpecialBetValueCorrectScore_11
 ,TPCorrectScore_12.SpecialBetValue as OddSpecialBetValueCorrectScore_12
 ,TPCorrectScore_13.SpecialBetValue as OddSpecialBetValueCorrectScore_13
 ,TPCorrectScore_20.SpecialBetValue as OddSpecialBetValueCorrectScore_20
 ,TPCorrectScore_21.SpecialBetValue as OddSpecialBetValueCorrectScore_21
 ,TPCorrectScore_22.SpecialBetValue as OddSpecialBetValueCorrectScore_22
 ,TPCorrectScore_23.SpecialBetValue as OddSpecialBetValueCorrectScore_23
 ,TPCorrectScore_30.SpecialBetValue as OddSpecialBetValueCorrectScore_30
 ,TPCorrectScore_31.SpecialBetValue as OddSpecialBetValueCorrectScore_31
 ,TPCorrectScore_32.SpecialBetValue as OddSpecialBetValueCorrectScore_32
 ,TPCorrectScore_33.SpecialBetValue as OddSpecialBetValueCorrectScore_33
 ,TPDartFirstSet_1.SpecialBetValue as OddSpecialBetValueDartFirstSet_1
 ,TPDartFirstSet_2.SpecialBetValue as OddSpecialBetValueDartFirstSet_2
 ,TPDouble1.SpecialBetValue as OddSpecialBetValueDouble_1
 ,TPDouble2.SpecialBetValue as OddSpecialBetValueDouble_2
 ,TPDoublex.SpecialBetValue as OddSpecialBetValueDouble_X
 ,TPDrawNoBet_1.SpecialBetValue as OddSpecialBetValueDrawNoBet_1
 ,TPDrawNoBet_2.SpecialBetValue as OddSpecialBetValueDrawNoBet_2
 ,TPFirst10_3Way1.SpecialBetValue as OddSpecialBetValueFirst10_3Way1
 ,TPFirst10_3Way2.SpecialBetValue as OddSpecialBetValueFirst10_3Way2
 ,TPFirst10_3WayX.SpecialBetValue as OddSpecialBetValueFirst10_3WayX
 ,TPFirstHalf1.SpecialBetValue as OddSpecialBetValueFirstHalf_1
 ,TPFirstHalf2.SpecialBetValue as OddSpecialBetValueFirstHalf_2
 ,TPFirstHalfx.SpecialBetValue as OddSpecialBetValueFirstHalf_X
 ,TPFirstHalfBothN.SpecialBetValue as OddSpecialBetValueFirstHalfBoth_N
 ,TPFirstHalfBothY.SpecialBetValue as OddSpecialBetValueFirstHalfBoth_Y
 ,TPFirstHalfDrawNo1.SpecialBetValue as OddSpecialBetValueFirstHalfDrawNo_1
 ,TPFirstHalfDrawNo2.SpecialBetValue as OddSpecialBetValueFirstHalfDrawNo_2
 ,TPFirstHalfTotalsO05.SpecialBetValue as OddSpecialBetValueFirstHalfTotalsO_0_5
 ,TPFirstHalfTotalsO15.SpecialBetValue as OddSpecialBetValueFirstHalfTotalsO_1_5
 ,TPFirstHalfTotalsO25.SpecialBetValue as OddSpecialBetValueFirstHalfTotalsO_2_5
 ,TPFirstHalfTotalsU05.SpecialBetValue as OddSpecialBetValueFirstHalfTotalsU_0_5
 ,TPFirstHalfTotalsU15.SpecialBetValue as OddSpecialBetValueFirstHalfTotalsU_1_5
 ,TPFirstHalfTotalsU25.SpecialBetValue as OddSpecialBetValueFirstHalfTotalsU_2_5
 ,TPFirstScore1.SpecialBetValue as OddSpecialBetValueFirstScore_1
 ,TPFirstScore2.SpecialBetValue as OddSpecialBetValueFirstScore_2
 ,TPFirstScoreX.SpecialBetValue as OddSpecialBetValueFirstScore_None
 ,TPFutsalTotal_6_5O.SpecialBetValue as OddSpecialBetValueFutsalTotal_6_5O
 ,TPFutsalTotal_6_5U.SpecialBetValue as OddSpecialBetValueFutsalTotal_6_5U
 ,TPO11.SpecialBetValue as OddSpecialBetValueHadicap01_1
 ,TPO12.SpecialBetValue as OddSpecialBetValueHadicap01_2
 ,TPO1x.SpecialBetValue as OddSpecialBetValueHadicap01_X
 ,TPO21.SpecialBetValue as OddSpecialBetValueHadicap02_1
 ,TPO22.SpecialBetValue as OddSpecialBetValueHadicap02_2
 ,TPO2x.SpecialBetValue as OddSpecialBetValueHadicap02_X
 ,TP101.SpecialBetValue as OddSpecialBetValueHadicap10_1
 ,TP102.SpecialBetValue as OddSpecialBetValueHadicap10_2
 ,TP10x.SpecialBetValue as OddSpecialBetValueHadicap10_X
 ,TP201.SpecialBetValue as OddSpecialBetValueHadicap20_1
 ,TP202.SpecialBetValue as OddSpecialBetValueHadicap20_2
 ,TP20x.SpecialBetValue as OddSpecialBetValueHadicap20_X
 ,TPHalfFull11.SpecialBetValue as OddSpecialBetValueHalfFull_11
 ,TPHalfFull12.SpecialBetValue as OddSpecialBetValueHalfFull_12
 ,TPHalfFull1X.SpecialBetValue as OddSpecialBetValueHalfFull_1X
 ,TPHalfFull21.SpecialBetValue as OddSpecialBetValueHalfFull_21
 ,TPHalfFull22.SpecialBetValue as OddSpecialBetValueHalfFull_22
 ,TPHalfFull2X.SpecialBetValue as OddSpecialBetValueHalfFull_2X
 ,TPHalfFullX1.SpecialBetValue as OddSpecialBetValueHalfFull_X1
 ,TPHalfFullX2.SpecialBetValue as OddSpecialBetValueHalfFull_X2
 ,TPHalfFullXX.SpecialBetValue as OddSpecialBetValueHalfFull_XX
 ,TPMatchBetTotal_2_5_OA.SpecialBetValue as OddSpecialBetValueMatchBetTotal_2_5_OA
 ,TPMatchBetTotal_2_5_OD.SpecialBetValue as OddSpecialBetValueMatchBetTotal_2_5_OD
 ,TPMatchBetTotal_2_5_OH.SpecialBetValue as OddSpecialBetValueMatchBetTotal_2_5_OH
 ,TPMatchBetTotal_2_5_UA.SpecialBetValue as OddSpecialBetValueMatchBetTotal_2_5_UA
 ,TPMatchBetTotal_2_5_UD.SpecialBetValue as OddSpecialBetValueMatchBetTotal_2_5_UD
 ,TPMatchBetTotal_2_5_UH.SpecialBetValue as OddSpecialBetValueMatchBetTotal_2_5_UH
 ,TPMatchBetTotal_3_5_OA.SpecialBetValue as OddSpecialBetValueMatchBetTotal_3_5_OA
 ,TPMatchBetTotal_3_5_OD.SpecialBetValue as OddSpecialBetValueMatchBetTotal_3_5_OD
 ,TPMatchBetTotal_3_5_OH.SpecialBetValue as OddSpecialBetValueMatchBetTotal_3_5_OH
 ,TPMatchBetTotal_3_5_UA.SpecialBetValue as OddSpecialBetValueMatchBetTotal_3_5_UA
 ,TPMatchBetTotal_3_5_UD.SpecialBetValue as OddSpecialBetValueMatchBetTotal_3_5_UD
 ,TPMatchBetTotal_3_5_UH.SpecialBetValue as OddSpecialBetValueMatchBetTotal_3_5_UH
 ,TPTennisFirstSet_1.SpecialBetValue as OddSpecialBetValueTennisFirstSet_1
 ,TPTennisFirstSet_2.SpecialBetValue as OddSpecialBetValueTennisFirstSet_2
 ,TPTennisScore_02.SpecialBetValue as OddSpecialBetValueTennisScore_02
 ,TPTennisScore_12.SpecialBetValue as OddSpecialBetValueTennisScore_12
 ,TPTennisScore_20.SpecialBetValue as OddSpecialBetValueTennisScore_20
 ,TPTennisScore_21.SpecialBetValue as OddSpecialBetValueTennisScore_21
 ,TPTennisSecondSet_1.SpecialBetValue as OddSpecialBetValueTennisSecondSet_1
 ,TPTennisSecondSet_2.SpecialBetValue as OddSpecialBetValueTennisSecondSet_2
 ,TPTennisSetNumber_2.SpecialBetValue as OddSpecialBetValueTennisSetNumber_2
 ,TPTennisSetNumber_3.SpecialBetValue as OddSpecialBetValueTennisSetNumber_3
 ,( select top 1 TPTennisTotal_O.SpecialBetValue from [Cache].[MatchOdd_Daily] as TPTennisTotal_O with (nolock)  where TPTennisTotal_O.OddsTypeId=226 and TPTennisTotal_O.MatchId=CacheFixture.MatchId and TPTennisTotal_O.OutCome='Over' order by TPTennisTotal_O.SpecialBetValue desc) as OddSpecialBetValueTennisTotal_O
 ,( select top 1 TPTennisTotal_U.SpecialBetValue from [Cache].[MatchOdd_Daily] as TPTennisTotal_U with (nolock)  where TPTennisTotal_U.OddsTypeId=226 and TPTennisTotal_U.MatchId=CacheFixture.MatchId and TPTennisTotal_U.OutCome='Under' order by TPTennisTotal_U.SpecialBetValue desc) as OddSpecialBetValueTennisTotal_U
 ,TPTotalGoals_0_1.SpecialBetValue as OddSpecialBetValueTotalGoals_0_1
 ,TPTotalGoals_2_3.SpecialBetValue as OddSpecialBetValueTotalGoals_2_3
 ,TPTotalGoals_4_5.SpecialBetValue as OddSpecialBetValueTotalGoals_4_5
 ,TPTotalGoals_6.SpecialBetValue as OddSpecialBetValueTotalGoals_6
 ,TPTotalsO15.SpecialBetValue as OddSpecialBetValueTotals_O1_5
 ,TPTotalsO.SpecialBetValue as OddSpecialBetValueTotals_O2_5
 ,TPTotalsO35.SpecialBetValue as OddSpecialBetValueTotals_O3_5
 ,TPTotalsO45.SpecialBetValue as OddSpecialBetValueTotals_O4_5
 ,TPTotalsU15.SpecialBetValue as OddSpecialBetValueTotals_U1_5
 ,TPTotalsU.SpecialBetValue as OddSpecialBetValueTotals_U2_5
 ,TPTotalsU35.SpecialBetValue as OddSpecialBetValueTotals_U3_5
 ,TPTotalsU45.SpecialBetValue as OddSpecialBetValueTotals_U4_5
 , case when SportId<>3 then ( select top 1 TPTotalSpreddO.SpecialBetValue from [Cache].[MatchOdd_Daily] as TPTotalSpreddO with (nolock)  where OddsTypeId =52 and MatchId=CacheFixture.MatchId and OutCome='Over' order by SpecialBetValue desc) else ( select top 1 TPTotalSpreddO.SpecialBetValue from [Cache].[MatchOdd_Daily] as TPTotalSpreddO with (nolock)  where OddsTypeId =229 and MatchId=CacheFixture.MatchId and OutCome='Over' order by SpecialBetValue desc) end  as OddSpecialBetValueTotalSpread_O
 , case when SportId<>3 then  ( select top 1 TPTotalSpreddO.SpecialBetValue from [Cache].[MatchOdd_Daily] as TPTotalSpreddO with (nolock)  where OddsTypeId =52 and MatchId=CacheFixture.MatchId and OutCome='Under' order by SpecialBetValue desc) else ( select top 1 TPTotalSpreddO.SpecialBetValue from [Cache].[MatchOdd_Daily] as TPTotalSpreddO with (nolock)  where OddsTypeId =229 and MatchId=CacheFixture.MatchId and OutCome='Under' order by SpecialBetValue desc) end as OddSpecialBetValueTotalSpread_U
 
 ,TPBasketFirstHalf_1.OddValue as OddValueBasketFirstHalf_1
 ,TPBasketFirstHalf_2.OddValue as OddValueBasketFirstHalf_2
 ,TPBasketFirstHalf_x.OddValue as OddValueBasketFirstHalf_x
 ,TPBothN.OddValue as OddValueBoth_N
 ,TPBothY.OddValue as OddValueBoth_Y
 ,TPCorrectScore_00.OddValue as OddValueCorrectScore_00
 ,TPCorrectScore_01.OddValue as OddValueCorrectScore_01
 ,TPCorrectScore_02.OddValue as OddValueCorrectScore_02
 ,TPCorrectScore_03.OddValue as OddValueCorrectScore_03
 ,TPCorrectScore_10.OddValue as OddValueCorrectScore_10
 ,TPCorrectScore_11.OddValue as OddValueCorrectScore_11
 ,TPCorrectScore_12.OddValue as OddValueCorrectScore_12
 ,TPCorrectScore_13.OddValue as OddValueCorrectScore_13
 ,TPCorrectScore_20.OddValue as OddValueCorrectScore_20
 ,TPCorrectScore_21.OddValue as OddValueCorrectScore_21
 ,TPCorrectScore_22.OddValue as OddValueCorrectScore_22
 ,TPCorrectScore_23.OddValue as OddValueCorrectScore_23
 ,TPCorrectScore_30.OddValue as OddValueCorrectScore_30
 ,TPCorrectScore_31.OddValue as OddValueCorrectScore_31
 ,TPCorrectScore_32.OddValue as OddValueCorrectScore_32
 ,TPCorrectScore_33.OddValue as OddValueCorrectScore_33
 ,TPDartFirstSet_1.OddValue as OddValueDartFirstSet_1
 ,TPDartFirstSet_2.OddValue as OddValueDartFirstSet_2
 ,TPDouble1.OddValue as OddValueDouble_1
 ,TPDouble2.OddValue as OddValueDouble_2
 ,TPDoublex.OddValue as OddValueDouble_X
 ,TPDrawNoBet_1.OddValue as OddValueDrawNoBet_1
 ,TPDrawNoBet_2.OddValue as OddValueDrawNoBet_2
 ,TPFirst10_3Way1.OddValue as OddValueFirst10_3Way1
 ,TPFirst10_3Way2.OddValue as OddValueFirst10_3Way2
 ,TPFirst10_3WayX.OddValue as OddValueFirst10_3WayX
 ,TPFirstHalf1.OddValue as OddValueFirstHalf_1
 ,TPFirstHalf2.OddValue as OddValueFirstHalf_2
 ,TPFirstHalfx.OddValue as OddValueFirstHalf_X
 ,TPFirstHalfBothN.OddValue as OddValueFirstHalfBoth_N
 ,TPFirstHalfBothY.OddValue as OddValueFirstHalfBoth_Y
 ,TPFirstHalfDrawNo1.OddValue as OddValueFirstHalfDrawNo_1
 ,TPFirstHalfDrawNo2.OddValue as OddValueFirstHalfDrawNo_2
 ,TPFirstHalfTotalsO05.OddValue as OddValueFirstHalfTotalsO_0_5
 ,TPFirstHalfTotalsO15.OddValue as OddValueFirstHalfTotalsO_1_5
 ,TPFirstHalfTotalsO25.OddValue as OddValueFirstHalfTotalsO_2_5
 ,TPFirstHalfTotalsU05.OddValue as OddValueFirstHalfTotalsU_0_5
 ,TPFirstHalfTotalsU15.OddValue as OddValueFirstHalfTotalsU_1_5
 ,TPFirstHalfTotalsU25.OddValue as OddValueFirstHalfTotalsU_2_5
 ,TPFirstScore1.OddValue as OddValueFirstScore_1
 ,TPFirstScore2.OddValue as OddValueFirstScore_2
 ,TPFirstScoreX.OddValue as OddValueFirstScore_None
 ,TPFutsalTotal_6_5O.OddValue as OddValueFutsalTotal_6_5O
 ,TPFutsalTotal_6_5U.OddValue as OddValueFutsalTotal_6_5U
 ,TPO11.OddValue as OddValueHadicap01_1
 ,TPO12.OddValue as OddValueHadicap01_2
 ,TPO1x.OddValue as OddValueHadicap01_X
 ,TPO21.OddValue as OddValueHadicap02_1
 ,TPO22.OddValue as OddValueHadicap02_2
 ,TPO2x.OddValue as OddValueHadicap02_X
 ,TP101.OddValue as OddValueHadicap10_1
 ,TP102.OddValue as OddValueHadicap10_2
 ,TP10x.OddValue as OddValueHadicap10_X
 ,TP201.OddValue as OddValueHadicap20_1
 ,TP202.OddValue as OddValueHadicap20_2
 ,TP20x.OddValue as OddValueHadicap20_X
 ,TPHalfFull11.OddValue as OddValueHalfFull_11
 ,TPHalfFull12.OddValue as OddValueHalfFull_12
 ,TPHalfFull1X.OddValue as OddValueHalfFull_1X
 ,TPHalfFull21.OddValue as OddValueHalfFull_21
 ,TPHalfFull22.OddValue as OddValueHalfFull_22
 ,TPHalfFull2X.OddValue as OddValueHalfFull_2X
 ,TPHalfFullX1.OddValue as OddValueHalfFull_X1
 ,TPHalfFullX2.OddValue as OddValueHalfFull_X2
 ,TPHalfFullXX.OddValue as OddValueHalfFull_XX
 ,TPMatchBetTotal_2_5_OA.OddValue as OddValueMatchBetTotal_2_5_OA
 ,TPMatchBetTotal_2_5_OD.OddValue as OddValueMatchBetTotal_2_5_OD
 ,TPMatchBetTotal_2_5_OH.OddValue as OddValueMatchBetTotal_2_5_OH
 ,TPMatchBetTotal_2_5_UA.OddValue as OddValueMatchBetTotal_2_5_UA
 ,TPMatchBetTotal_2_5_UD.OddValue as OddValueMatchBetTotal_2_5_UD
 ,TPMatchBetTotal_2_5_UH.OddValue as OddValueMatchBetTotal_2_5_UH
 ,TPMatchBetTotal_3_5_OA.OddValue as OddValueMatchBetTotal_3_5_OA
 ,TPMatchBetTotal_3_5_OD.OddValue as OddValueMatchBetTotal_3_5_OD
 ,TPMatchBetTotal_3_5_OH.OddValue as OddValueMatchBetTotal_3_5_OH
 ,TPMatchBetTotal_3_5_UA.OddValue as OddValueMatchBetTotal_3_5_UA
 ,TPMatchBetTotal_3_5_UD.OddValue as OddValueMatchBetTotal_3_5_UD
 ,TPMatchBetTotal_3_5_UH.OddValue as OddValueMatchBetTotal_3_5_UH
 ,TPTennisFirstSet_1.OddValue as OddValueTennisFirstSet_1
 ,TPTennisFirstSet_2.OddValue as OddValueTennisFirstSet_2
 ,TPTennisScore_02.OddValue as OddValueTennisScore_02
 ,TPTennisScore_12.OddValue as OddValueTennisScore_12
 ,TPTennisScore_20.OddValue as OddValueTennisScore_20
 ,TPTennisScore_21.OddValue as OddValueTennisScore_21
 ,TPTennisSecondSet_1.OddValue as OddValueTennisSecondSet_1
 ,TPTennisSecondSet_2.OddValue as OddValueTennisSecondSet_2
 ,TPTennisSetNumber_2.OddValue as OddValueTennisSetNumber_2
 ,TPTennisSetNumber_3.OddValue as OddValueTennisSetNumber_3
 ,( select top 1 TPTennisTotal_O.OddValue from [Cache].[MatchOdd_Daily] as TPTennisTotal_O with (nolock)  where TPTennisTotal_O.OddsTypeId=226 and TPTennisTotal_O.MatchId=CacheFixture.MatchId and TPTennisTotal_O.OutCome='Over' order by TPTennisTotal_O.SpecialBetValue desc) as OddValueTennisTotal_O
  ,( select top 1 TPTennisTotal_U.OddValue from [Cache].[MatchOdd_Daily] as TPTennisTotal_U with (nolock)  where TPTennisTotal_U.OddsTypeId=226 and TPTennisTotal_U.MatchId=CacheFixture.MatchId and TPTennisTotal_U.OutCome='Under' order by TPTennisTotal_U.SpecialBetValue desc) as OddValueTennisTotal_U
 ,TPTotalGoals_0_1.OddValue as OddValueTotalGoals_0_1
 ,TPTotalGoals_2_3.OddValue as OddValueTotalGoals_2_3
 ,TPTotalGoals_4_5.OddValue as OddValueTotalGoals_4_5
 ,TPTotalGoals_6.OddValue as OddValueTotalGoals_6
 ,TPTotalsO15.OddValue as OddValueTotals_O1_5
 ,TPTotalsO.OddValue as OddValueTotals_O2_5
 ,TPTotalsO35.OddValue as OddValueTotals_O3_5
 ,TPTotalsO45.OddValue as OddValueTotals_O4_5
 ,TPTotalsU15.OddValue as OddValueTotals_U1_5
 ,TPTotalsU.OddValue as OddValueTotals_U2_5
 ,TPTotalsU35.OddValue as OddValueTotals_U3_5
 ,TPTotalsU45.OddValue as OddValueTotals_U4_5
 ,case when SportId<>3 then ( select top 1 TPTotalSpreddO.OddValue from [Cache].[MatchOdd_Daily] as TPTotalSpreddO with (nolock)  where OddsTypeId =52 and MatchId=CacheFixture.MatchId and OutCome='Over' order by SpecialBetValue desc) else ( select top 1 TPTotalSpreddO.OddValue from [Cache].[MatchOdd_Daily] as TPTotalSpreddO with (nolock)  where OddsTypeId =229 and MatchId=CacheFixture.MatchId and OutCome='Over' order by SpecialBetValue desc) end as OddValueTotalSpread_O
 ,case when SportId<>3 then  ( select top 1 TPTotalSpredU.OddValue from [Cache].[MatchOdd_Daily] as TPTotalSpredU with (nolock)  where OddsTypeId =52 and MatchId=CacheFixture.MatchId and OutCome='Under' order by SpecialBetValue desc) else ( select top 1 TPTotalSpreddU.OddValue from [Cache].[MatchOdd_Daily] as TPTotalSpreddU with (nolock)  where OddsTypeId =229 and MatchId=CacheFixture.MatchId and OutCome='Under' order by SpecialBetValue desc) end as OddValueTotalSpread_U

,TPBasketFirstHalf_1.OutCome as OutComeBasketFirstHalf_1
,TPBasketFirstHalf_2.OutCome as OutComeBasketFirstHalf_2
,TPBasketFirstHalf_x.OutCome as OutComeBasketFirstHalf_x
,TPCorrectScore_00.OutCome as OutComeCorrectScore_00
,TPCorrectScore_01.OutCome as OutComeCorrectScore_01
,TPCorrectScore_02.OutCome as OutComeCorrectScore_02
,TPCorrectScore_03.OutCome as OutComeCorrectScore_03
,TPCorrectScore_10.OutCome as OutComeCorrectScore_10
,TPCorrectScore_11.OutCome as OutComeCorrectScore_11
,TPCorrectScore_12.OutCome as OutComeCorrectScore_12
,TPCorrectScore_13.OutCome as OutComeCorrectScore_13
,TPCorrectScore_20.OutCome as OutComeCorrectScore_20
,TPCorrectScore_21.OutCome as OutComeCorrectScore_21
,TPCorrectScore_22.OutCome as OutComeCorrectScore_22
,TPCorrectScore_23.OutCome as OutComeCorrectScore_23
,TPCorrectScore_30.OutCome as OutComeCorrectScore_30
,TPCorrectScore_31.OutCome as OutComeCorrectScore_31
,TPCorrectScore_32.OutCome as OutComeCorrectScore_32
,TPCorrectScore_33.OutCome as OutComeCorrectScore_33
,TPDartFirstSet_1.OutCome as OutComeDartFirstSet_1
,TPDartFirstSet_2.OutCome as OutComeDartFirstSet_2
,TPDrawNoBet_1.OutCome as OutComeDrawNoBet_1
,TPDrawNoBet_2.OutCome as OutComeDrawNoBet_2
,TPFirstHalf1.OutCome as OutComeFirstHalf_1
,TPFirstHalf2.OutCome as OutComeFirstHalf_2
,TPFirstHalfx.OutCome as OutComeFirstHalf_X
,TPFirstHalfBothN.OutCome as OutComeFirstHalfBoth_N
,TPFirstHalfDrawNo1.OutCome as OutComeFirstHalfDrawNo_1
,TPFirstHalfTotalsO05.OutCome as OutComeFirstHalfTotalsO_0_5
,TPFirstHalfTotalsO15.OutCome as OutComeFirstHalfTotalsO_1_5
,TPFirstHalfTotalsO25.OutCome as OutComeFirstHalfTotalsO_2_5
,TPFirstHalfTotalsU05.OutCome as OutComeFirstHalfTotalsU_0_5
,TPFirstHalfTotalsU15.OutCome as OutComeFirstHalfTotalsU_1_5
,TPFirstHalfTotalsU25.OutCome as OutComeFirstHalfTotalsU_2_5
,TPFirstScore2.OutCome as OutComeFirstScore_2
,TPFutsalTotal_6_5O.OutCome as OutComeFutsalTotal_6_5O
,TPFutsalTotal_6_5U.OutCome as OutComeFutsalTotal_6_5U
,TP101.OutCome as OutComeHadicap10_1
,TP102.OutCome as OutComeHadicap10_2
,TP10x.OutCome as OutComeHadicap10_X
,TP201.OutCome as OutComeHadicap20_1
,TP202.OutCome as OutComeHadicap20_2
,TP20x.OutCome as OutComeHadicap20_X
,TPHalfFull11.OutCome as OutComeHalfFull_11
,TPHalfFull1X.OutCome as OutComeHalfFull_1X
,TPHalfFull21.OutCome as OutComeHalfFull_21
,TPHalfFull2X.OutCome as OutComeHalfFull_2X
,TPHalfFullX1.OutCome as OutComeHalfFull_X1
,TPHalfFullXX.OutCome as OutComeHalfFull_XX
,TPMatchBetTotal_2_5_OA.OutCome as OutComeMatchBetTotal_2_5_OA
,TPMatchBetTotal_2_5_OD.OutCome as OutComeMatchBetTotal_2_5_OD
,TPMatchBetTotal_2_5_OH.OutCome as OutComeMatchBetTotal_2_5_OH
,TPMatchBetTotal_2_5_UA.OutCome as OutComeMatchBetTotal_2_5_UA
,TPMatchBetTotal_2_5_UD.OutCome as OutComeMatchBetTotal_2_5_UD
,TPMatchBetTotal_2_5_UH.OutCome as OutComeMatchBetTotal_2_5_UH
,TPMatchBetTotal_3_5_OA.OutCome as OutComeMatchBetTotal_3_5_OA
,TPMatchBetTotal_3_5_OD.OutCome as OutComeMatchBetTotal_3_5_OD
,TPMatchBetTotal_3_5_OH.OutCome as OutComeMatchBetTotal_3_5_OH
,TPMatchBetTotal_3_5_UA.OutCome as OutComeMatchBetTotal_3_5_UA
,TPMatchBetTotal_3_5_UD.OutCome as OutComeMatchBetTotal_3_5_UD
,TPMatchBetTotal_3_5_UH.OutCome as OutComeMatchBetTotal_3_5_UH
,TPTennisFirstSet_1.OutCome as OutComeTennisFirstSet_1
,TPTennisFirstSet_2.OutCome as OutComeTennisFirstSet_2
,TPTennisScore_02.OutCome as OutComeTennisScore_02
,TPTennisScore_12.OutCome as OutComeTennisScore_12
,TPTennisScore_20.OutCome as OutComeTennisScore_20
,TPTennisScore_21.OutCome as OutComeTennisScore_21
,TPTennisSecondSet_1.OutCome as OutComeTennisSecondSet_1
,TPTennisSecondSet_2.OutCome as OutComeTennisSecondSet_2
,TPTennisSetNumber_2.OutCome as OutComeTennisSetNumber_2
,TPTennisSetNumber_3.OutCome as OutComeTennisSetNumber_3
,( select top 1 TPTennisTotal_O.OutCome from [Cache].[MatchOdd_Daily] as TPTennisTotal_O  with (nolock) where TPTennisTotal_O.OddsTypeId=226 and TPTennisTotal_O.MatchId=CacheFixture.MatchId and TPTennisTotal_O.OutCome='Over' order by TPTennisTotal_O.SpecialBetValue desc) as OutComeTennisTotal_O
  ,( select top 1 TPTennisTotal_U.OutCome from [Cache].[MatchOdd_Daily] as TPTennisTotal_U with (nolock)  where TPTennisTotal_U.OddsTypeId=226 and TPTennisTotal_U.MatchId=CacheFixture.MatchId and TPTennisTotal_U.OutCome='Under' order by TPTennisTotal_U.SpecialBetValue desc) as OutComeTennisTotal_U
,TPTotalGoals_0_1.OutCome as OutComeTotalGoals_0_1
,TPTotalGoals_2_3.OutCome as OutComeTotalGoals_2_3
,TPTotalGoals_4_5.OutCome as OutComeTotalGoals_4_5
,TPTotalGoals_6.OutCome as OutComeTotalGoals_6
,case when SportId<>3 then ( select top 1 TPTotalSpreddO.OutCome from [Cache].[MatchOdd_Daily] as TPTotalSpreddO with (nolock)  where OddsTypeId =52 and MatchId=CacheFixture.MatchId and OutCome='Over' order by SpecialBetValue desc) else ( select top 1 TPTotalSpreddO.OutCome from [Cache].[MatchOdd_Daily] as TPTotalSpreddO with (nolock)  where OddsTypeId =229 and MatchId=CacheFixture.MatchId and OutCome='Over' order by SpecialBetValue desc) end as OutComeTotalSpread_O
 , case when SportId<>3 then ( select top 1 TPTotalSpredU.OutCome from [Cache].[MatchOdd_Daily] as TPTotalSpredU with (nolock)  where OddsTypeId =52 and MatchId=CacheFixture.MatchId and OutCome='Under' order by SpecialBetValue desc) else ( select top 1 TPTotalSpredU.OutCome from [Cache].[MatchOdd_Daily] as TPTotalSpredU with (nolock)  where OddsTypeId =229 and MatchId=CacheFixture.MatchId and OutCome='Under' order by SpecialBetValue desc) end as OutComeTotalSpread_U
FROM                  [Cache].[FixtureProgramme] as  CacheFixture with (nolock)  LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPO11 with (nolock) ON TPO11.MatchId=CacheFixture.MatchId and TPO11.OddsTypeId=55 and TPO11.SpecialBetValue='0:1' and TPO11.OutCome='1' LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPO1x with (nolock) ON TPO1x.MatchId=CacheFixture.MatchId and TPO1x.OddsTypeId=55 and TPO1x.SpecialBetValue='0:1' and TPO1x.OutCome='X' LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPO12 with (nolock) ON TPO12.MatchId=CacheFixture.MatchId and TPO12.OddsTypeId=55 and TPO12.SpecialBetValue='0:1' and TPO12.OutCome='2' LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TP101 with (nolock) ON TP101.MatchId=CacheFixture.MatchId and TP101.OddsTypeId=55 and TP101.SpecialBetValue='1:0' and TP101.OutCome='1' LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TP10x with (nolock) ON TP10x.MatchId=CacheFixture.MatchId and TP10x.OddsTypeId=55 and TP10x.SpecialBetValue='1:0' and TP10x.OutCome='X'  LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TP102 with (nolock) ON TP102.MatchId=CacheFixture.MatchId and TP102.OddsTypeId=55 and TP102.SpecialBetValue='1:0' and TP102.OutCome='2'  LEFT OUTER JOIN
					  
					  [Cache].[MatchOdd_Daily] as TPDouble1 with (nolock) ON TPDouble1.MatchId=CacheFixture.MatchId and TPDouble1.OddsTypeId=46 and  TPDouble1.OutCome='1X'  LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPDoublex with (nolock) ON TPDoublex.MatchId=CacheFixture.MatchId and TPDoublex.OddsTypeId=46 and  TPDoublex.OutCome='X2'  LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPDouble2 with (nolock) ON TPDouble2.MatchId=CacheFixture.MatchId and TPDouble2.OddsTypeId=46 and  TPDouble2.OutCome='12'  LEFT OUTER JOIN
					 
					  [Cache].[MatchOdd_Daily] as TPBothY with (nolock) ON TPBothY.MatchId=CacheFixture.MatchId and TPBothY.OddsTypeId=43 and  TPBothY.OutCome='Yes'  LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPBothN with (nolock) ON TPBothN.MatchId=CacheFixture.MatchId and TPBothN.OddsTypeId=43 and  TPBothN.OutCome='No'   LEFT OUTER JOIN
					  
					  [Cache].[MatchOdd_Daily] as TPTotalsO with (nolock) ON TPTotalsO.MatchId=CacheFixture.MatchId and TPTotalsO.OddsTypeId=56 and  TPTotalsO.OutCome='Over' and TPTotalsO.SpecialBetValue='2.5'   LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPTotalsU with (nolock) ON TPTotalsU.MatchId=CacheFixture.MatchId and TPTotalsU.OddsTypeId=56 and  TPTotalsU.OutCome='Under' and TPTotalsU.SpecialBetValue='2.5'   LEFT OUTER JOIN
					 
					  [Cache].[MatchOdd_Daily] as TPTotalsO15 with (nolock) ON TPTotalsO15.MatchId=CacheFixture.MatchId and TPTotalsO15.OddsTypeId=56 and  TPTotalsO15.OutCome='Over' and TPTotalsO15.SpecialBetValue='1.5'   LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPTotalsU15 with (nolock) ON TPTotalsU15.MatchId=CacheFixture.MatchId and TPTotalsU15.OddsTypeId=56 and  TPTotalsU15.OutCome='Under' and TPTotalsU15.SpecialBetValue='1.5'   LEFT OUTER JOIN
					 
					  [Cache].[MatchOdd_Daily] as TPTotalsO35 with (nolock) ON TPTotalsO35.MatchId=CacheFixture.MatchId and TPTotalsO35.OddsTypeId=56 and  TPTotalsO35.OutCome='Over' and TPTotalsO35.SpecialBetValue='3.5'   LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPTotalsU35 with (nolock) ON TPTotalsU35.MatchId=CacheFixture.MatchId and TPTotalsU35.OddsTypeId=56 and  TPTotalsU35.OutCome='Under' and TPTotalsU35.SpecialBetValue='3.5'   LEFT OUTER JOIN
					 
					  [Cache].[MatchOdd_Daily] as TPTotalsO45 with (nolock) ON TPTotalsO45.MatchId=CacheFixture.MatchId and TPTotalsO45.OddsTypeId=56 and  TPTotalsO45.OutCome='Over' and TPTotalsO45.SpecialBetValue='4.5'   LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPTotalsU45 with (nolock) ON TPTotalsU45.MatchId=CacheFixture.MatchId and TPTotalsU45.OddsTypeId=56 and  TPTotalsU45.OutCome='Under' and TPTotalsU45.SpecialBetValue='4.5'   LEFT OUTER JOIN
					 
					  [Cache].[MatchOdd_Daily] as TPO21 with (nolock) ON TPO21.MatchId=CacheFixture.MatchId and TPO21.OddsTypeId=55 and TPO21.SpecialBetValue='0:2' and TPO21.OutCome='1' LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPO2x with (nolock) ON TPO2x.MatchId=CacheFixture.MatchId and TPO2x.OddsTypeId=55 and TPO2x.SpecialBetValue='0:2' and TPO2x.OutCome='X' LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPO22 with (nolock) ON TPO22.MatchId=CacheFixture.MatchId and TPO22.OddsTypeId=55 and TPO22.SpecialBetValue='0:2' and TPO22.OutCome='2' LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TP201 with (nolock) ON TP201.MatchId=CacheFixture.MatchId and TP201.OddsTypeId=55 and TP201.SpecialBetValue='2:0' and TP201.OutCome='1' LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TP20x with (nolock) ON TP20x.MatchId=CacheFixture.MatchId and TP20x.OddsTypeId=55 and TP20x.SpecialBetValue='2:0' and TP20x.OutCome='X'  LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TP202 with (nolock) ON TP202.MatchId=CacheFixture.MatchId and TP202.OddsTypeId=55 and TP202.SpecialBetValue='2:0' and TP202.OutCome='2'  LEFT OUTER JOIN
					  
					  [Cache].[MatchOdd_Daily] as TPFirstHalf1 with (nolock) ON TPFirstHalf1.MatchId=CacheFixture.MatchId and TPFirstHalf1.OddsTypeId=42 and TPFirstHalf1.OutCome='1' LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPFirstHalfx with (nolock) ON TPFirstHalfx.MatchId=CacheFixture.MatchId and TPFirstHalfx.OddsTypeId=42 and TPFirstHalfx.OutCome='X' LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPFirstHalf2 with (nolock) ON TPFirstHalf2.MatchId=CacheFixture.MatchId and TPFirstHalf2.OddsTypeId=42 and TPFirstHalf2.OutCome='2' LEFT OUTER JOIN
					 
					  [Cache].[MatchOdd_Daily] as TPFirstHalfBothY with (nolock) ON TPFirstHalfBothY.MatchId=CacheFixture.MatchId and TPFirstHalfBothY.OddsTypeId=328 and  TPFirstHalfBothY.OutCome='Yes'  LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPFirstHalfBothN with (nolock) ON TPFirstHalfBothN.MatchId=CacheFixture.MatchId and TPFirstHalfBothN.OddsTypeId=328 and  TPFirstHalfBothN.OutCome='No'  LEFT OUTER JOIN
					  
					  [Cache].[MatchOdd_Daily] as TPFirstHalfTotalsO05 with (nolock) ON TPFirstHalfTotalsO05.MatchId=CacheFixture.MatchId and TPFirstHalfTotalsO05.OddsTypeId=284 and  TPFirstHalfTotalsO05.OutCome='Over' and TPFirstHalfTotalsO05.SpecialBetValue='0.5'   LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPFirstHalfTotalsU05 with (nolock) ON TPFirstHalfTotalsU05.MatchId=CacheFixture.MatchId and TPFirstHalfTotalsU05.OddsTypeId=284 and  TPFirstHalfTotalsU05.OutCome='Under' and TPFirstHalfTotalsU05.SpecialBetValue='0.5'   LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPFirstHalfTotalsO15 with (nolock) ON TPFirstHalfTotalsO15.MatchId=CacheFixture.MatchId and TPFirstHalfTotalsO15.OddsTypeId=284 and  TPFirstHalfTotalsO15.OutCome='Over' and TPFirstHalfTotalsO15.SpecialBetValue='1.5'   LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPFirstHalfTotalsU15 with (nolock) ON TPFirstHalfTotalsU15.MatchId=CacheFixture.MatchId and TPFirstHalfTotalsU15.OddsTypeId=284 and  TPFirstHalfTotalsU15.OutCome='Under' and TPFirstHalfTotalsU15.SpecialBetValue='1.5'   LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPFirstHalfTotalsO25 with (nolock) ON TPFirstHalfTotalsO25.MatchId=CacheFixture.MatchId and TPFirstHalfTotalsO25.OddsTypeId=284 and  TPFirstHalfTotalsO25.OutCome='Over' and TPFirstHalfTotalsO25.SpecialBetValue='2.5'   LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPFirstHalfTotalsU25 with (nolock) ON TPFirstHalfTotalsU25.MatchId=CacheFixture.MatchId and TPFirstHalfTotalsU25.OddsTypeId=284 and  TPFirstHalfTotalsU25.OutCome='Under' and TPFirstHalfTotalsU25.SpecialBetValue='2.5'   LEFT OUTER JOIN
					 
					  [Cache].[MatchOdd_Daily] as TPFirstHalfDrawNo1 with (nolock) ON TPFirstHalfDrawNo1.MatchId=CacheFixture.MatchId and TPFirstHalfDrawNo1.OddsTypeId=324 and  TPFirstHalfDrawNo1.OutCome='1'    LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPFirstHalfDrawNo2 with (nolock) ON TPFirstHalfDrawNo2.MatchId=CacheFixture.MatchId and TPFirstHalfDrawNo2.OddsTypeId=324 and  TPFirstHalfDrawNo2.OutCome='2'    LEFT OUTER JOIN
					  
					  [Cache].[MatchOdd_Daily] as TPFirstScore1 with (nolock) ON TPFirstScore1.MatchId=CacheFixture.MatchId and TPFirstScore1.OddsTypeId=41 and  TPFirstScore1.OutCome='1'    LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPFirstScoreX with (nolock) ON TPFirstScoreX.MatchId=CacheFixture.MatchId and TPFirstScoreX.OddsTypeId=41 and  TPFirstScoreX.OutCome='None'    LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPFirstScore2 with (nolock) ON TPFirstScore2.MatchId=CacheFixture.MatchId and TPFirstScore2.OddsTypeId=41 and  TPFirstScore2.OutCome='2'    LEFT OUTER JOIN
					 
					  [Cache].[MatchOdd_Daily] as TPHalfFull11 with (nolock) ON TPHalfFull11.MatchId=CacheFixture.MatchId and TPHalfFull11.OddsTypeId=44 and  TPHalfFull11.OutCome='1/1'    LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPHalfFullX1 with (nolock) ON TPHalfFullX1.MatchId=CacheFixture.MatchId and TPHalfFullX1.OddsTypeId=44 and  TPHalfFullX1.OutCome='X/1'    LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPHalfFull21 with (nolock) ON TPHalfFull21.MatchId=CacheFixture.MatchId and TPHalfFull21.OddsTypeId=44 and  TPHalfFull21.OutCome='2/1'    LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPHalfFull1X with (nolock) ON TPHalfFull1X.MatchId=CacheFixture.MatchId and TPHalfFull1X.OddsTypeId=44 and  TPHalfFull1X.OutCome='1/X'    LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPHalfFullXX with (nolock) ON TPHalfFullXX.MatchId=CacheFixture.MatchId and TPHalfFullXX.OddsTypeId=44 and  TPHalfFullXX.OutCome='X/X'    LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPHalfFull2X with (nolock) ON TPHalfFull2X.MatchId=CacheFixture.MatchId and TPHalfFull2X.OddsTypeId=44 and  TPHalfFull2X.OutCome='2/X'    LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPHalfFull12 with (nolock) ON TPHalfFull12.MatchId=CacheFixture.MatchId and TPHalfFull12.OddsTypeId=44 and  TPHalfFull12.OutCome='1/2'    LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPHalfFullX2 with (nolock) ON TPHalfFullX2.MatchId=CacheFixture.MatchId and TPHalfFullX2.OddsTypeId=44 and  TPHalfFullX2.OutCome='X/2'    LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPHalfFull22 with (nolock) ON TPHalfFull22.MatchId=CacheFixture.MatchId and TPHalfFull22.OddsTypeId=44 and  TPHalfFull22.OutCome='2/2'    LEFT OUTER JOIN
					  
					  [Cache].[MatchOdd_Daily] as TPFirst10_3Way1 with (nolock) ON TPFirst10_3Way1.MatchId=CacheFixture.MatchId and TPFirst10_3Way1.OddsTypeId=327 and  TPFirst10_3Way1.OutCome='1'    LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPFirst10_3WayX with (nolock) ON TPFirst10_3WayX.MatchId=CacheFixture.MatchId and TPFirst10_3WayX.OddsTypeId=327 and  TPFirst10_3WayX.OutCome='X'    LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPFirst10_3Way2 with (nolock) ON TPFirst10_3Way2.MatchId=CacheFixture.MatchId and TPFirst10_3Way2.OddsTypeId=327 and  TPFirst10_3Way2.OutCome='2'    LEFT OUTER JOIN
					  
					  [Cache].[MatchOdd_Daily] as TPTotalGoals_0_1 with (nolock) ON TPTotalGoals_0_1.MatchId=CacheFixture.MatchId and TPTotalGoals_0_1.OddsTypeId=202 and  TPTotalGoals_0_1.OutCome='0-1 goals'    LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPTotalGoals_2_3 with (nolock) ON TPTotalGoals_2_3.MatchId=CacheFixture.MatchId and TPTotalGoals_2_3.OddsTypeId=202 and  TPTotalGoals_2_3.OutCome='2-3 goals'    LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPTotalGoals_4_5 with (nolock) ON TPTotalGoals_4_5.MatchId=CacheFixture.MatchId and TPTotalGoals_4_5.OddsTypeId=202 and  TPTotalGoals_4_5.OutCome='4-5 goals'    LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPTotalGoals_6 with (nolock) ON TPTotalGoals_6.MatchId=CacheFixture.MatchId and TPTotalGoals_6.OddsTypeId=202 and  TPTotalGoals_6.OutCome='6+'    LEFT OUTER JOIN
					 
					  [Cache].[MatchOdd_Daily] as TPMatchBetTotal_2_5_OA with (nolock) ON TPMatchBetTotal_2_5_OA.MatchId=CacheFixture.MatchId and TPMatchBetTotal_2_5_OA.OddsTypeId=208 and  TPMatchBetTotal_2_5_OA.OutCome='Over and away' and TPMatchBetTotal_2_5_OA.SpecialBetValue='2.5'    LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPMatchBetTotal_2_5_OD with (nolock) ON TPMatchBetTotal_2_5_OD.MatchId=CacheFixture.MatchId and TPMatchBetTotal_2_5_OD.OddsTypeId=208 and  TPMatchBetTotal_2_5_OD.OutCome='Over and draw' and TPMatchBetTotal_2_5_OD.SpecialBetValue='2.5'    LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPMatchBetTotal_2_5_OH with (nolock) ON TPMatchBetTotal_2_5_OH.MatchId=CacheFixture.MatchId and TPMatchBetTotal_2_5_OH.OddsTypeId=208 and  TPMatchBetTotal_2_5_OH.OutCome='Over and home' and TPMatchBetTotal_2_5_OH.SpecialBetValue='2.5'    LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPMatchBetTotal_2_5_UA with (nolock) ON TPMatchBetTotal_2_5_UA.MatchId=CacheFixture.MatchId and TPMatchBetTotal_2_5_UA.OddsTypeId=208 and  TPMatchBetTotal_2_5_UA.OutCome='Under and away' and TPMatchBetTotal_2_5_UA.SpecialBetValue='2.5'    LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPMatchBetTotal_2_5_UD with (nolock) ON TPMatchBetTotal_2_5_UD.MatchId=CacheFixture.MatchId and TPMatchBetTotal_2_5_UD.OddsTypeId=208 and  TPMatchBetTotal_2_5_UD.OutCome='Under and draw' and TPMatchBetTotal_2_5_UD.SpecialBetValue='2.5'    LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPMatchBetTotal_2_5_UH with (nolock) ON TPMatchBetTotal_2_5_UH.MatchId=CacheFixture.MatchId and TPMatchBetTotal_2_5_UH.OddsTypeId=208 and  TPMatchBetTotal_2_5_UH.OutCome='Under and home' and TPMatchBetTotal_2_5_UH.SpecialBetValue='2.5'    LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPMatchBetTotal_3_5_OA with (nolock) ON TPMatchBetTotal_3_5_OA.MatchId=CacheFixture.MatchId and TPMatchBetTotal_3_5_OA.OddsTypeId=208 and  TPMatchBetTotal_3_5_OA.OutCome='Over and away' and TPMatchBetTotal_3_5_OA.SpecialBetValue='3.5'    LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPMatchBetTotal_3_5_OD with (nolock) ON TPMatchBetTotal_3_5_OD.MatchId=CacheFixture.MatchId and TPMatchBetTotal_3_5_OD.OddsTypeId=208 and  TPMatchBetTotal_3_5_OD.OutCome='Over and draw' and TPMatchBetTotal_3_5_OD.SpecialBetValue='3.5'    LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPMatchBetTotal_3_5_OH with (nolock) ON TPMatchBetTotal_3_5_OH.MatchId=CacheFixture.MatchId and TPMatchBetTotal_3_5_OH.OddsTypeId=208 and  TPMatchBetTotal_3_5_OH.OutCome='Over and home' and TPMatchBetTotal_3_5_OH.SpecialBetValue='3.5'    LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPMatchBetTotal_3_5_UA with (nolock) ON TPMatchBetTotal_3_5_UA.MatchId=CacheFixture.MatchId and TPMatchBetTotal_3_5_UA.OddsTypeId=208 and  TPMatchBetTotal_3_5_UA.OutCome='Under and away' and TPMatchBetTotal_3_5_UA.SpecialBetValue='3.5'    LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPMatchBetTotal_3_5_UD with (nolock) ON TPMatchBetTotal_3_5_UD.MatchId=CacheFixture.MatchId and TPMatchBetTotal_3_5_UD.OddsTypeId=208 and  TPMatchBetTotal_3_5_UD.OutCome='Under and draw' and TPMatchBetTotal_3_5_UD.SpecialBetValue='3.5'    LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPMatchBetTotal_3_5_UH with (nolock) ON TPMatchBetTotal_3_5_UH.MatchId=CacheFixture.MatchId and TPMatchBetTotal_3_5_UH.OddsTypeId=208 and  TPMatchBetTotal_3_5_UH.OutCome='Under and home' and TPMatchBetTotal_3_5_UH.SpecialBetValue='3.5'    LEFT OUTER JOIN
					 
					  [Cache].[MatchOdd_Daily] as TPDrawNoBet_1 with (nolock) ON TPDrawNoBet_1.MatchId=CacheFixture.MatchId and TPDrawNoBet_1.OddsTypeId=47 and  TPDrawNoBet_1.OutCome='1'   LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPDrawNoBet_2 with (nolock) ON TPDrawNoBet_2.MatchId=CacheFixture.MatchId and TPDrawNoBet_2.OddsTypeId=47 and  TPDrawNoBet_2.OutCome='2'   LEFT OUTER JOIN
					  
					  [Cache].[MatchOdd_Daily] as TPCorrectScore_00 with (nolock) ON TPCorrectScore_00.MatchId=CacheFixture.MatchId and TPCorrectScore_00.OddsTypeId=332 and  TPCorrectScore_00.OutCome='0:0'   LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPCorrectScore_10 with (nolock) ON TPCorrectScore_10.MatchId=CacheFixture.MatchId and TPCorrectScore_10.OddsTypeId=332 and  TPCorrectScore_10.OutCome='1:0'   LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPCorrectScore_20 with (nolock) ON TPCorrectScore_20.MatchId=CacheFixture.MatchId and TPCorrectScore_20.OddsTypeId=332 and  TPCorrectScore_20.OutCome='2:0'   LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPCorrectScore_30 with (nolock) ON TPCorrectScore_30.MatchId=CacheFixture.MatchId and TPCorrectScore_30.OddsTypeId=332 and  TPCorrectScore_30.OutCome='3:0'   LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPCorrectScore_21 with (nolock) ON TPCorrectScore_21.MatchId=CacheFixture.MatchId and TPCorrectScore_21.OddsTypeId=332 and  TPCorrectScore_21.OutCome='2:1'   LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPCorrectScore_31 with (nolock) ON TPCorrectScore_31.MatchId=CacheFixture.MatchId and TPCorrectScore_31.OddsTypeId=332 and  TPCorrectScore_31.OutCome='3:1'   LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPCorrectScore_32 with (nolock) ON TPCorrectScore_32.MatchId=CacheFixture.MatchId and TPCorrectScore_32.OddsTypeId=332 and  TPCorrectScore_32.OutCome='3:2'   LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPCorrectScore_11 with (nolock) ON TPCorrectScore_11.MatchId=CacheFixture.MatchId and TPCorrectScore_11.OddsTypeId=332 and  TPCorrectScore_11.OutCome='1:1'   LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPCorrectScore_22 with (nolock) ON TPCorrectScore_22.MatchId=CacheFixture.MatchId and TPCorrectScore_22.OddsTypeId=332 and  TPCorrectScore_22.OutCome='2:2'   LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPCorrectScore_33 with (nolock) ON TPCorrectScore_33.MatchId=CacheFixture.MatchId and TPCorrectScore_33.OddsTypeId=332 and  TPCorrectScore_33.OutCome='3:3'   LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPCorrectScore_01 with (nolock) ON TPCorrectScore_01.MatchId=CacheFixture.MatchId and TPCorrectScore_01.OddsTypeId=332 and  TPCorrectScore_01.OutCome='0:1'   LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPCorrectScore_02 with (nolock) ON TPCorrectScore_02.MatchId=CacheFixture.MatchId and TPCorrectScore_02.OddsTypeId=332 and  TPCorrectScore_02.OutCome='0:2'   LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPCorrectScore_03 with (nolock) ON TPCorrectScore_03.MatchId=CacheFixture.MatchId and TPCorrectScore_03.OddsTypeId=332 and  TPCorrectScore_03.OutCome='0:3'   LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPCorrectScore_12 with (nolock) ON TPCorrectScore_12.MatchId=CacheFixture.MatchId and TPCorrectScore_12.OddsTypeId=332 and  TPCorrectScore_12.OutCome='1:2'   LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPCorrectScore_13 with (nolock) ON TPCorrectScore_13.MatchId=CacheFixture.MatchId and TPCorrectScore_13.OddsTypeId=332 and  TPCorrectScore_13.OutCome='1:3'   LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPCorrectScore_23 with (nolock) ON TPCorrectScore_23.MatchId=CacheFixture.MatchId and TPCorrectScore_23.OddsTypeId=332 and  TPCorrectScore_23.OutCome='2:3'   LEFT OUTER JOIN

					  [Cache].[MatchOdd_Daily] as TPFutsalTotal_6_5O with (nolock) ON TPFutsalTotal_6_5O.MatchId=CacheFixture.MatchId and TPFutsalTotal_6_5O.OddsTypeId=383 and  TPFutsalTotal_6_5O.OutCome='Over' and  TPFutsalTotal_6_5O.SpecialBetValue='6.5'   LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPFutsalTotal_6_5U with (nolock) ON TPFutsalTotal_6_5U.MatchId=CacheFixture.MatchId and TPFutsalTotal_6_5U.OddsTypeId=383 and  TPFutsalTotal_6_5U.OutCome='Under' and  TPFutsalTotal_6_5U.SpecialBetValue='6.5'   LEFT OUTER JOIN

					  [Cache].[MatchOdd_Daily] as TPBasketFirstHalf_1 with (nolock) ON TPBasketFirstHalf_1.MatchId=CacheFixture.MatchId and TPBasketFirstHalf_1.OddsTypeId=42 and TPBasketFirstHalf_1.OutCome='1' LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPBasketFirstHalf_x with (nolock) ON TPBasketFirstHalf_x.MatchId=CacheFixture.MatchId and TPBasketFirstHalf_x.OddsTypeId=42 and TPBasketFirstHalf_x.OutCome='X' LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPBasketFirstHalf_2 with (nolock) ON TPBasketFirstHalf_2.MatchId=CacheFixture.MatchId and TPBasketFirstHalf_2.OddsTypeId=42 and TPBasketFirstHalf_2.OutCome='2' LEFT OUTER JOIN

					  [Cache].[MatchOdd_Daily] as TPTennisFirstSet_1 with (nolock) ON TPTennisFirstSet_1.MatchId=CacheFixture.MatchId and TPTennisFirstSet_1.OddsTypeId=204 and TPTennisFirstSet_1.OutCome='1' LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPTennisFirstSet_2 with (nolock) ON TPTennisFirstSet_2.MatchId=CacheFixture.MatchId and TPTennisFirstSet_2.OddsTypeId=204 and TPTennisFirstSet_2.OutCome='2' LEFT OUTER JOIN

					  [Cache].[MatchOdd_Daily] as TPTennisSecondSet_1 with (nolock) ON TPTennisSecondSet_1.MatchId=CacheFixture.MatchId and TPTennisSecondSet_1.OddsTypeId=231 and TPTennisSecondSet_1.OutCome='1' LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPTennisSecondSet_2 with (nolock) ON TPTennisSecondSet_2.MatchId=CacheFixture.MatchId and TPTennisSecondSet_2.OddsTypeId=231 and TPTennisSecondSet_2.OutCome='2' LEFT OUTER JOIN

					  [Cache].[MatchOdd_Daily] as TPTennisSetNumber_2 with (nolock) ON TPTennisSetNumber_2.MatchId=CacheFixture.MatchId and TPTennisSetNumber_2.OddsTypeId=206 and TPTennisSetNumber_2.OutCome='2 sets' LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPTennisSetNumber_3 with (nolock) ON TPTennisSetNumber_3.MatchId=CacheFixture.MatchId and TPTennisSetNumber_3.OddsTypeId=206 and TPTennisSetNumber_3.OutCome='3 sets' LEFT OUTER JOIN

					  [Cache].[MatchOdd_Daily] as TPTennisScore_20 with (nolock) ON TPTennisScore_20.MatchId=CacheFixture.MatchId and TPTennisScore_20.OddsTypeId=233 and TPTennisScore_20.OutCome='2:0' LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPTennisScore_21 with (nolock) ON TPTennisScore_21.MatchId=CacheFixture.MatchId and TPTennisScore_21.OddsTypeId=233 and TPTennisScore_21.OutCome='2:1' LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPTennisScore_02 with (nolock) ON TPTennisScore_02.MatchId=CacheFixture.MatchId and TPTennisScore_02.OddsTypeId=233 and TPTennisScore_02.OutCome='0:2' LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPTennisScore_12 with (nolock) ON TPTennisScore_12.MatchId=CacheFixture.MatchId and TPTennisScore_12.OddsTypeId=233 and TPTennisScore_12.OutCome='1:2' LEFT OUTER JOIN

					  [Cache].[MatchOdd_Daily] as TPDartFirstSet_1 with (nolock) ON TPDartFirstSet_1.MatchId=CacheFixture.MatchId and TPDartFirstSet_1.OddsTypeId=204 and TPDartFirstSet_1.OutCome='Player 1' LEFT OUTER JOIN
					  [Cache].[MatchOdd_Daily] as TPDartFirstSet_2 with (nolock) ON TPDartFirstSet_2.MatchId=CacheFixture.MatchId and TPDartFirstSet_2.OddsTypeId=204 and TPDartFirstSet_2.OutCome='Player 2' 
					 



 end
GO
