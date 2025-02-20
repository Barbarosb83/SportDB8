USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcEventOddMatch]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 
 
 
CREATE PROCEDURE [GamePlatform].[ProcEventOddMatch] 
@MatchId bigint, 
@LangId int
AS

BEGIN
SET NOCOUNT ON;

	  SELECT    ROW_NUMBER() over(PARTITION BY Match.Odd.OddsTypeId order by Match.Odd.SpecialBetValue,Parameter.Odds.SeqNumber) as RowNumber,
             Match.Odd.OddId,
			  case when Language.[Parameter.Odds].OutComes is not null Then Language.[Parameter.Odds].OutComes 
			 else Match.Odd.OutCome end  as OutCome, 
             Match.Odd.OddValue,
              Fixture.TournamentId,
               case when Parameter.Odds.OddsId IN (1648,1646,1644,1642,2247,2321,2325,2465,2915,2973,2993,3010,3052,3079,3350,3371,3393,2320) 
			   then CAST( cast(Match.Odd.SpecialBetValue AS float)*-1 AS nvarchar(10)) 
			   else case when Match.Odd.OddsTypeId in (1497,1911,1493,1632,1633,1506,1620,1490) 
			   then case when cast(Match.Odd.SpecialBetValue AS float)<0 then  '0:'+CAST( cast(Match.Odd.SpecialBetValue AS float)*-1 AS nvarchar(10))
			   else  ISNULL(Match.Odd.SpecialBetValue, '')+':0' end else ISNULL(Match.Odd.SpecialBetValue, '')   end end AS SpecialBetValue,
              Language.[Parameter.OddsType].OddsType,
                      '' as OutcomesDescription, 
                      Match.Setting.IsPopular,
                       Match.Odd.OddsTypeId as OddTypeId,
                       Match.Setting.MatchId,ISNULL((Select MIN(PODD.SeqNumber) from Parameter.OddTypeGroupOddType PODD with (nolock) where PODD.OddTypeId=Match.Odd.OddsTypeId and PODD.OddTypeGroupId not in (2,12)),2) as SeqNumber,Language.[Parameter.OddsType].ShortOddType
					   ,Match.Odd.ParameterOddId
					   ,ISNULL((Select MIN(PODD.OddTypeGroupId) from Parameter.OddTypeGroupOddType PODD with (nolock) where PODD.OddTypeId=Match.Odd.OddsTypeId and PODD.OddTypeGroupId not in (2,12)),2) as OddTypeGroupId
FROM         Match.Odd with (nolock) INNER JOIN
                      Parameter.Odds with (nolock) ON Match.Odd.ParameterOddId = Parameter.Odds.OddsId INNER JOIN
                      Cache.Programme2 Fixture with (nolock) ON Match.Odd.MatchId = Fixture.MatchId Inner JOIN
					    Cache.Fixture as CFF with (nolock) ON CFF.MatchId=Fixture.MatchId Inner JOIN
					--  Match.Code with (nolock) On Match.Code.BetradarMatchId=Fixture.BetradarMatchId and Match.Code.BetTypeId=1   INNER JOIN
                      Parameter.OddsType with (nolock) ON Parameter.OddsType.OddsTypeId = Parameter.Odds.OddTypeId INNER JOIN
                      Language.[Parameter.OddsType] with (nolock) ON Parameter.OddsType.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId INNER JOIN
                      Match.Setting with (nolock) ON Language.[Parameter.OddsType].OddsTypeId = Match.Odd.OddsTypeId AND 
                      Match.Setting.MatchId = Fixture.MatchId  INNER JOIN
                      Language.[Parameter.Odds] with (nolock) ON Parameter.Odds.OddsId = Language.[Parameter.Odds].OddsId AND 
                      Language.[Parameter.OddsType].LanguageId = @LangId and  Language.[Parameter.Odds].LanguageId=@LangId --INNER JOIN
				--	  Parameter.OddTypeGroupOddType with (nolock) ON Parameter.OddTypeGroupOddType.OddTypeId=Parameter.OddsType.OddsTypeId and  Parameter.OddTypeGroupOddType.OddTypeGroupId=12
WHERE   Fixture.MatchId=@MatchId and (Match.Odd.StateId = 2) and Match.Odd.OddValue>1 AND  (Parameter.OddsType.IsActive=1 or Parameter.OddsType.OddsTypeId=1834 )
					   -- and Fixture.SportId in (1,2,3,4,5,6,19,20,35)   
					    


END


GO
