USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcFixtureUpcoming]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcFixtureUpcoming] @SportId int,
                                                      @CategoryId int,
                                                      @TournamentId int,
                                                      @EventDate datetime,
                                                      @LangId int
AS

BEGIN
    SET NOCOUNT ON;

    DECLARE @Delimeter char(1)
    SET @Delimeter = ','
    declare @LangComp int=@LangId

    declare @Endatee nvarchar(50)

    set @Endatee = cast(Cast(DATEADD(DAY, 1, GETDATE()) as date) as nvarchar(10)) + ' 00:00:00.000'

    if (@LangComp not in (2, 3, 6))
        set @LangComp = 2
if (@SportId>0)
begin
    SELECT top 200 Programme.BetradarMatchId
         , Programme.MatchId
         , Programme.MatchDate
         , Language.[Parameter.Tournament].TournamentName
         , Language.ParameterCompetitor.CompetitorName + '-' + ParameterCompetitor_1.CompetitorName AS EventName
         , Language.[Parameter.Sport].SportName
         , Programme.TournamentId
         , Programme.SportId
         , Parameter.Category.CategoryId
         , Parameter.Sport.SportName                                                                as SportNameOrginal
         , (SELECT COUNT(DISTINCT OddsTypeId)
            FROM Match.Odd with (nolock)
            WHERE (Match.Odd.MatchId = Programme.MatchId)
              AND (Match.Odd.StateId = 2)
              and Match.Odd.OddValue > 1)                                                           as OddTypeCount
         , Programme.MatchDate                                                                      as TournamentDate
         , Language.[Parameter.Category].CategoryName
         , Parameter.Tournament.SequenceNumber
         , SUBSTRING(LOWER(Parameter.Iso.IsoName2), 0, 3)                                           AS IsoName
         , Parameter.Tournament.NewBetradarId                                                       as BetradarTournamentId


         , Parameter.Competitor.BetradarSuperId                                                     as HomeTeamId
         , Competitor_1.BetradarSuperId                                                             as AwayTeamId
    FROM Parameter.Competitor AS Competitor_1 with (nolock)
             INNER JOIN
         Parameter.Competitor with (nolock)
             INNER JOIN
         Language.ParameterCompetitor with (nolock)
         ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId and
            Language.ParameterCompetitor.LanguageId = @LangComp
             INNER JOIN
         Cache.Programme2 as Programme with (nolock) ON Parameter.Competitor.CompetitorId = Programme.[HomeTeam ]
         ON Competitor_1.CompetitorId = Programme.[AwayTeam ]
             INNER JOIN
         Cache.Fixture as CFF with (nolock) ON CFF.MatchId = Programme.MatchId
             Inner JOIN
       
         Language.ParameterCompetitor AS ParameterCompetitor_1 with (nolock)
         ON Competitor_1.CompetitorId = ParameterCompetitor_1.CompetitorId and
            ParameterCompetitor_1.LanguageId = @LangComp
             INNER JOIN
         Language.[Parameter.Tournament] with (nolock)
         ON Language.[Parameter.Tournament].TournamentId = Programme.TournamentId and
            Language.[Parameter.Tournament].LanguageId = @LangId
             INNER JOIN
         Parameter.Tournament with (nolock) On Parameter.Tournament.TournamentId = Programme.TournamentId
             INNER JOIN
         Parameter.Category with (nolock) On Parameter.Category.CategoryId = Parameter.Tournament.CategoryId
             INNER JOIN
         Parameter.Sport with (nolock) on Parameter.Sport.SportId = Programme.SportId
             INNER JOIN
         Parameter.Iso ON Parameter.Iso.IsoId = Parameter.Category.IsoId
             INNER JOIN
         Language.[Parameter.Category] with (nolock)
         On Language.[Parameter.Category].CategoryId = Parameter.Category.CategoryId and
            Language.[Parameter.Category].LanguageId = @LangId and Parameter.Sport.IsActive = 1
             INNER JOIN
         Language.[Parameter.Sport] with (nolock) ON Language.[Parameter.Sport].SportId = Parameter.Sport.SportId and
                                                     Language.[Parameter.Sport].LanguageId = @LangId
    where Programme.MatchDate > GETDATE()
      and Programme.MatchDate < DATEADD(HOUR, 9, @Endatee)
      ----case when (Select Count(*) from Live.Event with (nolock) where BetradarMatchId=Programme.BetradarMatchId)>0
      ----then DATEADD(MINUTE,10, GETDATE())
      ----else DATEADD(MINUTE,5, GETDATE()) end
      --and cast(Programme.MatchDate as date)=cast(GETDATE() as date) and
      and Parameter.Sport.SportId not in (21, 17, 31)
      and Parameter.Sport.SportId = @SportId order by SequenceNumber
    -- and Programme.MatchId=28158742
end
else
	begin
	 SELECT top 200 Programme.BetradarMatchId
         , Programme.MatchId
         , Programme.MatchDate
         , Language.[Parameter.Tournament].TournamentName
         , Language.ParameterCompetitor.CompetitorName + '-' + ParameterCompetitor_1.CompetitorName AS EventName
         , Language.[Parameter.Sport].SportName
         , Programme.TournamentId
         , Programme.SportId
         , Parameter.Category.CategoryId
         , Parameter.Sport.SportName                                                                as SportNameOrginal
         , (SELECT COUNT(DISTINCT OddsTypeId)
            FROM Match.Odd with (nolock)
            WHERE (Match.Odd.MatchId = Programme.MatchId)
              AND (Match.Odd.StateId = 2)
              and Match.Odd.OddValue > 1)                                                           as OddTypeCount
         , Programme.MatchDate                                                                      as TournamentDate
         , Language.[Parameter.Category].CategoryName
         , Parameter.Tournament.SequenceNumber
         , SUBSTRING(LOWER(Parameter.Iso.IsoName2), 0, 3)                                           AS IsoName
         , Parameter.Tournament.NewBetradarId                                                       as BetradarTournamentId


         , Parameter.Competitor.BetradarSuperId                                                     as HomeTeamId
         , Competitor_1.BetradarSuperId                                                             as AwayTeamId
    FROM Parameter.Competitor AS Competitor_1 with (nolock)
             INNER JOIN
         Parameter.Competitor with (nolock)
             INNER JOIN
         Language.ParameterCompetitor with (nolock)
         ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId and
            Language.ParameterCompetitor.LanguageId = @LangComp
             INNER JOIN
         Cache.Programme2 as Programme with (nolock) ON Parameter.Competitor.CompetitorId = Programme.[HomeTeam ]
         ON Competitor_1.CompetitorId = Programme.[AwayTeam ]
             INNER JOIN
         Cache.Fixture as CFF with (nolock) ON CFF.MatchId = Programme.MatchId
             Inner JOIN
     
         Language.ParameterCompetitor AS ParameterCompetitor_1 with (nolock)
         ON Competitor_1.CompetitorId = ParameterCompetitor_1.CompetitorId and
            ParameterCompetitor_1.LanguageId = @LangComp
             INNER JOIN
         Language.[Parameter.Tournament] with (nolock)
         ON Language.[Parameter.Tournament].TournamentId = Programme.TournamentId and
            Language.[Parameter.Tournament].LanguageId = @LangId
             INNER JOIN
         Parameter.Tournament with (nolock) On Parameter.Tournament.TournamentId = Programme.TournamentId
             INNER JOIN
         Parameter.Category with (nolock) On Parameter.Category.CategoryId = Parameter.Tournament.CategoryId
             INNER JOIN
         Parameter.Sport with (nolock) on Parameter.Sport.SportId = Programme.SportId
             INNER JOIN
         Parameter.Iso ON Parameter.Iso.IsoId = Parameter.Category.IsoId
             INNER JOIN
         Language.[Parameter.Category] with (nolock)
         On Language.[Parameter.Category].CategoryId = Parameter.Category.CategoryId and
            Language.[Parameter.Category].LanguageId = @LangId and Parameter.Sport.IsActive = 1
             INNER JOIN
         Language.[Parameter.Sport] with (nolock) ON Language.[Parameter.Sport].SportId = Parameter.Sport.SportId and
                                                     Language.[Parameter.Sport].LanguageId = @LangId
    where Programme.MatchDate > GETDATE()
      and Programme.MatchDate < DATEADD(HOUR, 9, @Endatee)
      ----case when (Select Count(*) from Live.Event with (nolock) where BetradarMatchId=Programme.BetradarMatchId)>0
      ----then DATEADD(MINUTE,10, GETDATE())
      ----else DATEADD(MINUTE,5, GETDATE()) end
      --and cast(Programme.MatchDate as date)=cast(GETDATE() as date) and
      and Parameter.Sport.SportId not in (21, 17, 31)
       order by SequenceNumber

	end

--else  
--	begin

--	insert @temptableoverunder1 (MatchId,OverUnder)
--				select Match.Odd.MatchId,MIN(SpecialBetValue) from Match.Odd with (nolock)  INNER JOIN Cache.Programme2 as Programme ON Match.Odd.MatchId=Programme.MatchId 
--				where   Match.Odd.BetradarOddTypeId in (56,52,226) and Match.Odd.OutCome='Over' and   Match.Odd.OddValue<2.70 and Match.Odd.OddValue>1.45
--				and Programme.MatchDate>GETDATE()
--						 --case when (Select Count(*) from Live.Event with (nolock) where BetradarMatchId=Programme.BetradarMatchId)>0 
--						 --then DATEADD(MINUTE,10, GETDATE()) 
--						 --else DATEADD(MINUTE,5, GETDATE()) end  
--						 and cast(Programme.MatchDate as date)=cast(GETDATE() as date) and Programme.SportId not in (21,17,31)
--				 GROUP BY Match.Odd.MatchId

--							insert @temptableoverunder1 (MatchId,Overs,OverId)
--				select  Match.Odd.MatchId,Match.Odd.OddValue,Match.Odd.OddId from Match.Odd with (nolock) INNER JOIN @temptableoverunder1 as TP ON Match.Odd.MatchId=TP.MatchId and Match.Odd.SpecialBetValue=TP.OverUnder 
--				where   BetradarOddTypeId in (56,52,226) and OutCome='Over' 

--				insert @temptableoverunder1 (MatchId,Unders,UnderId)
--				select  Match.Odd.MatchId,Match.Odd.OddValue,Match.Odd.OddId from Match.Odd with (nolock) INNER JOIN @temptableoverunder1 as TP ON Match.Odd.MatchId=TP.MatchId and Match.Odd.SpecialBetValue=TP.OverUnder 
--				where   BetradarOddTypeId in (56,52,226) and OutCome='Under'

--					insert @temptableoverunder2
--				select MatchId,  MAX(OverUnder) ,SUM(Overs),SUM(OverId) ,SUM(Unders),SUM(UnderId)
--					from @temptableoverunder1  GROUP BY MatchId


--		SELECT DISTINCT  top 200  Programme.BetradarMatchId,Programme.MatchId, Programme.MatchDate,Language.[Parameter.Tournament].TournamentName,
--  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetitor_1.CompetitorName AS EventName, 
--                    Language.[Parameter.Sport].SportName,Programme.TournamentId,Programme.SportId,Parameter.Category.CategoryId,Parameter.Sport.SportName as SportNameOrginal
--					,(SELECT     COUNT(DISTINCT OddsTypeId)
--                                        FROM          Match.Odd with (nolock)
--                                                      WHERE      (Match.Odd.MatchId = Programme.MatchId) AND (Match.Odd.StateId = 2) and Match.Odd.OddValue>1) as OddTypeCount , 
--                     Programme.MatchDate as TournamentDate,cast(1 as bit)  as NeutralGround
--					,null as HasStreaming,
--					Language.[Parameter.Category].CategoryName
--					,Parameter.Category.SequenceNumber,  SUBSTRING(LOWER(Parameter.Iso.IsoName2), 0, 3) AS IsoName
--					,Parameter.Tournament.NewBetradarId as BetradarTournamentId
--					,Programme.OddId1,CFF.OddValue1
--					,Programme.OddId2,CFF.OddValue2
--					,Programme.OddId3,CFF.OddValue3


--					,Programme.OddSpecialBetValueHadicap01_1,Programme.OddIdHadicap01_1,Programme.OddValueHadicap01_1
--					,Programme.OddIdHadicap01_X,Programme.OddValueHadicap01_X
--					,Programme.OddIdHadicap01_2,Programme.OddValueHadicap01_2

--					,Programme.OddSpecialBetValueHadicap02_1,Programme.OddIdHadicap02_1,Programme.OddValueHadicap02_1
--					,Programme.OddIdHadicap02_X,Programme.OddValueHadicap02_X
--					,Programme.OddIdHadicap02_2,Programme.OddValueHadicap02_2


--					,Programme.OddSpecialBetValueHadicap10_1,Programme.OddIdHadicap10_1,Programme.OddValueHadicap10_1
--					,Programme.OddIdHadicap10_X,Programme.OddValueHadicap10_X
--					,Programme.OddIdHadicap10_2,Programme.OddValueHadicap10_2

--					,Programme.OddSpecialBetValueHadicap20_1,Programme.OddIdHadicap20_1,Programme.OddValueHadicap20_1
--					,Programme.OddIdHadicap20_X,Programme.OddValueHadicap20_X
--					,Programme.OddIdHadicap20_2,Programme.OddValueHadicap20_2


--					,TP.OverUnder as OddSpecialBetValueTotals_O1_5
--					,TP.OverId as OddIdTotals_O1_5,TP.Overs as OddValueTotals_O1_5
--					,TP.UnderId as OddIdTotals_U1_5,TP.Unders as OddValueTotals_U1_5

--					,Programme.OddSpecialBetValueTotals_O2_5,Programme.OddIdTotals_O2_5,Programme.OddValueTotals_O2_5
--					,Programme.OddIdTotals_U2_5,Programme.OddValueTotals_U2_5

--					,Programme.OddSpecialBetValueTotals_O3_5,Programme.OddIdTotals_O3_5,Programme.OddValueTotals_O3_5
--					,Programme.OddIdTotals_U3_5,Programme.OddValueTotals_U3_5

--					,Programme.OddSpecialBetValueTotals_O4_5
--					,Programme.OddIdTotals_O4_5,Programme.OddValueTotals_O4_5
--					,Programme.OddIdTotals_U4_5,Programme.OddValueTotals_U4_5

--					,Programme.OddIdDouble_1 as OddIdDouble_1X,Programme.OddValueDouble_1 as OddValueDouble_1X
--					,Programme.OddIdDouble_X as OddIdDouble_X2,Programme.OddValueDouble_X as OddValueDouble_X2
--					,Programme.OddIdDouble_2 as OddIdDouble_12,Programme.OddValueDouble_2 as OddValueDouble_12

--					,Programme.OddIdBoth_Y ,Programme.OddValueBoth_Y
--					,Programme.OddIdBoth_N ,Programme.OddValueBoth_N

--					,Programme.OddIdFirstScore_1 ,Programme.OddValueFirstScore_1
--					,Programme.OddIdFirstScore_None ,Programme.OddValueFirstScore_None
--					,Programme.OddIdFirstScore_2 ,Programme.OddValueFirstScore_2

--					,Programme.OddIdFirstHalf_1 ,Programme.OddValueFirstHalf_1
--					,Programme.OddIdFirstHalf_X ,Programme.OddValueFirstHalf_X
--					,Programme.OddIdFirstHalf_2 ,Programme.OddValueFirstHalf_2

--					,Programme.OddSpecialBetValueFirstHalfTotalsO_0_5
--					,Programme.OddIdFirstHalfTotalsO_0_5,Programme.OddValueFirstHalfTotalsO_0_5  
--					,Programme.OddIdFirstHalfTotalsU_0_5,Programme.OddValueFirstHalfTotalsU_0_5

--					,Programme.OddSpecialBetValueFirstHalfTotalsO_1_5
--					,Programme.OddIdFirstHalfTotalsO_1_5,Programme.OddValueFirstHalfTotalsO_1_5  
--					,Programme.OddIdFirstHalfTotalsU_1_5,Programme.OddValueFirstHalfTotalsU_1_5

--					 ,Programme.OutComeTennisScore_20 as OddSpecialBetValueTennisScore_20
--					 ,Programme.OddIdTennisScore_20,Programme.OddValueTennisScore_20

--					 ,Programme.OutComeTennisScore_02 as OddSpecialBetValueTennisScore_02
--					 ,Programme.OddIdTennisScore_02,Programme.OddValueTennisScore_02

--					  ,Programme.OutComeTennisScore_12 as OddSpecialBetValueTennisScore_12
--					 ,Programme.OddIdTennisScore_12,Programme.OddValueTennisScore_12

--					   ,Programme.OutComeTennisScore_21 as OddSpecialBetValueTennisScore_21
--					 ,Programme.OddIdTennisScore_21,Programme.OddValueTennisScore_21

--					    ,Programme.OddSpecialBetValueTennisTotal_O as OddSpecialBetValueTennisTotal
--					 ,Programme.OddIdTennisTotal_O,Programme.OddValueTennisTotal_O
--					 ,Programme.OddIdTennisTotal_U,Programme.OddValueTennisTotal_U

--					    ,Programme.OddSpecialBetValueTotalSpread_O as OddSpecialBetValueBasketTotal
--					 ,Programme.OddIdTotalSpread_O,Programme.OddValueTotalSpread_O
--					 ,Programme.OddIdTotalSpread_U,Programme.OddValueTotalSpread_U

--					 ,Programme.OddIdBasketFirstHalf_1 ,Programme.OddValueBasketFirstHalf_1
--					,Programme.OddIdBasketFirstHalf_X ,Programme.OddValueBasketFirstHalf_x
--					,Programme.OddIdBasketFirstHalf_2 ,Programme.OddValueBasketFirstHalf_2

--						,Programme.OddIdTennisFirstSet_1,Programme.OddValueTennisFirstSet_1
--					,Programme.OddIdTennisFirstSet_2,Programme.OddValueTennisFirstSet_2

--FROM         Parameter.Competitor AS Competitor_1 with (nolock) INNER JOIN
--                      Parameter.Competitor with (nolock)  INNER JOIN
--                      Language.ParameterCompetitor with (nolock) ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangComp INNER JOIN
--                      Cache.Programme as Programme with (nolock) ON Parameter.Competitor.CompetitorId = Programme.[HomeTeam ] ON Competitor_1.CompetitorId = Programme.[AwayTeam ] INNER JOIN
--					  Cache.Fixture as CFF with (nolock) ON CFF.MatchId=Programme.MatchId Inner JOIN
--					  Match.Code with (nolock) On Match.Code.BetradarMatchId=Programme.BetradarMatchId and Match.Code.BetTypeId=1 INNER JOIN
--                      Language.ParameterCompetitor AS ParameterCompetitor_1 with (nolock) ON Competitor_1.CompetitorId = ParameterCompetitor_1.CompetitorId and ParameterCompetitor_1.LanguageId=@LangComp  INNER JOIN 
--						 Language.[Parameter.Tournament]  with (nolock) ON Language.[Parameter.Tournament].TournamentId=Programme.TournamentId and Language.[Parameter.Tournament].LanguageId=@LangId INNER JOIN
--						 Parameter.Tournament with (nolock)  On Parameter.Tournament.TournamentId=Programme.TournamentId INNER JOIN
--						 Parameter.Category  with (nolock) On Parameter.Category.CategoryId=Parameter.Tournament.CategoryId INNER JOIN
--						 Parameter.Sport with (nolock)  on Parameter.Sport.SportId=Programme.SportId INNER JOIN
--						 Parameter.Iso ON Parameter.Iso.IsoId=Parameter.Category.IsoId INNER JOIN
--						 Language.[Parameter.Category] with (nolock)  On Language.[Parameter.Category].CategoryId=Parameter.Category.CategoryId and  Language.[Parameter.Category].LanguageId=@LangId and Parameter.Sport.IsActive=1 INNER JOIN
--						 Language.[Parameter.Sport]  with (nolock) ON  Language.[Parameter.Sport].SportId= Parameter.Sport.SportId and Language.[Parameter.Sport].LanguageId=@LangId LEFT OUTER JOIN
--						 @temptableoverunder2 as TP ON TP.MatchId=Programme.MatchId
--						 where  Programme.MatchDate>GETDATE()
--						 --case when (Select Count(*) from Live.Event with (nolock) where BetradarMatchId=Programme.BetradarMatchId)>0 
--						 --then DATEADD(MINUTE,10, GETDATE()) 
--						 --else DATEADD(MINUTE,5, GETDATE()) end  
--						 and cast(Programme.MatchDate as date)=cast(GETDATE() as date) and Parameter.Sport.SportId not in (21,17,31)
--					 order by Parameter.Category.SequenceNumber

--	end


END
GO
