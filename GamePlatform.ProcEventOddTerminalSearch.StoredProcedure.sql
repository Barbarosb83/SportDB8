USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcEventOddTerminalSearch]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [GamePlatform].[ProcEventOddTerminalSearch] 
@SearchText nvarchar(150),
@LangId int,
@OddTypeGroupId int

AS
BEGIN
SET NOCOUNT ON;
 

 --declare @TempTableComp Table(Ids bigint not null)

 declare @LangComp int=@LangId


if(@LangComp not in (2,3,6))
	set @LangComp=2


--	insert @TempTableComp 
--select DISTINCT Language.ParameterCompetitor.CompetitorId
--FROM         
--                      Language.ParameterCompetitor with (nolock)  
--                       where Language.ParameterCompetitor.CompetitorName like '%'+@SearchText+'%' and Language.ParameterCompetitor.LanguageId=@LangComp



  SELECT   ROW_NUMBER() over(PARTITION BY Match.ODd.OddsTypeId order by Match.Odd.SpecialBetValue,Parameter.Odds.SeqNumber) as RowNumber,
             Match.Odd.OddId,
			  case when Language.[Parameter.Odds].OutComes is not null Then Language.[Parameter.Odds].OutComes 
			 else Match.Odd.OutCome end  as OutCome, 
             Match.Odd.OddValue,
              Cache.Fixture.TournamentId,
               case when Parameter.Odds.OddsId IN (1578,1544,1648,1646,1644,1642,2247,2321,2325,2465,2541,2543,2915,2973,2993,2997,3010,3052,3079,3350,3371,3393) 
			   then CAST( cast(Match.Odd.SpecialBetValue AS float)*-1 AS nvarchar(10)) 
			   else case when Match.Odd.OddsTypeId in (1497,1911,1493) then case when cast(Match.Odd.SpecialBetValue AS float)<0 then  '0:'+CAST( cast(Match.Odd.SpecialBetValue AS float)*-1 AS nvarchar(10)) else  ISNULL(Match.Odd.SpecialBetValue, '')+':0' end else ISNULL(Match.Odd.SpecialBetValue, '')   end end AS SpecialBetValue,
              Language.[Parameter.OddsType].OddsType,
                       Parameter.OddsType.OutcomesDescription, 
                      Match.Setting.IsPopular,
                       Match.Odd.OddsTypeId as OddTypeId,
                       Match.Setting.MatchId,ISNULL(Parameter.OddTypeGroupOddType.SeqNumber,999) as SeqNumber,Language.[Parameter.OddsType].ShortOddType
					   ,Match.Odd.ParameterOddId
					   ,ISNULL((Select MIN(PODD.OddTypeGroupId) from Parameter.OddTypeGroupOddType PODD with (nolock) where PODD.OddTypeId=Match.Odd.OddsTypeId and PODD.OddTypeGroupId not in (2,12)),2) as OddTypeGroupId
FROM         Match.Odd with (nolock) INNER JOIN
                      Parameter.Odds with (nolock) ON  Parameter.Odds.OddsId=Match.Odd.ParameterOddId INNER JOIN
                      Cache.Fixture with (nolock) ON Cache.Fixture.MatchId=Match.Odd.MatchId   INNER JOIN
                      Parameter.OddsType with (nolock) ON Parameter.OddsType.OddsTypeId = Match.Odd.OddsTypeId INNER JOIN
                      Language.[Parameter.OddsType] with (nolock) ON Parameter.OddsType.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId and  Language.[Parameter.OddsType].LanguageId =@LangId  INNER JOIN
                      Language.[Parameter.Odds] with (nolock) ON   Language.[Parameter.Odds].OddsId=Match.Odd.ParameterOddId AND 
                      Language.[Parameter.Odds].LanguageId=@LangId INNER JOIN
					  Parameter.OddTypeGroupOddType with (nolock) ON Parameter.OddTypeGroupOddType.OddTypeId=Parameter.OddsType.OddsTypeId and Parameter.OddTypeGroupOddType.OddTypeGroupId=@OddTypeGroupId INNER JOIN
                      Match.Setting with (nolock) ON   Match.ODd.OddsTypeId=Parameter.OddTypeGroupOddType.OddTypeId AND Match.Odd.OddsTypeId=Parameter.OddTypeGroupOddType.OddTypeId and
                      Match.Setting.MatchId = Match.Odd.MatchId INNER JOIN
					  Language.ParameterCompetitor On Language.ParameterCompetitor.LanguageId=@LangComp and (Language.ParameterCompetitor.CompetitorId=Cache.Fixture.AwayTeam or Language.ParameterCompetitor.CompetitorId=Cache.Fixture.HomeTeam )
					  and Language.ParameterCompetitor.CompetitorName like '%'+@SearchText+'%'
WHERE        Match.Odd.StateId=2 and  Match.Setting.StateId=2 and Match.Odd.OddValue>1  AND  (Parameter.OddsType.IsActive=1 or Parameter.OddsType.OddsTypeId=1834 ) 
                   --and ( exists (select Ids from @TempTableComp where Ids=Cache.Fixture.AwayTeam or Ids=Cache.Fixture.HomeTeam ))
					    and  Cache.Fixture.MatchDate>DATEADD(MINUTE,5,GETDATE()) 


 
		 

END



GO
