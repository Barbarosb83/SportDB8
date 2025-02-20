USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcEventOddType]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcEventOddType] 
@MatchId bigint,
@LangId int
AS

BEGIN
SET NOCOUNT ON;

SELECT DISTINCT
                      Language.[Parameter.OddsType].OddsType
					  ,case when (Select COUNT(Parameter.Odds.OddsId) from Parameter.Odds with (nolock) where Parameter.Odds.OddTypeId=Parameter.OddsType.OddsTypeId and LiveOddId is null)> 0 
					  then 'C' 
					  else '' end as OutcomesDescription
					  , Match.Setting.IsPopular, Parameter.OddsType.OddsTypeId, 
                      Match.Setting.MatchId, Match.Match.TournamentId
FROM         Parameter.OddsType with (nolock) INNER JOIN
                      Language.[Parameter.OddsType] with (nolock) ON Parameter.OddsType.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId AND 
                      Parameter.OddsType.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId INNER JOIN
                     
					  Match.Odd with (nolock) ON Match.Odd.OddsTypeId=Parameter.OddsType.OddsTypeId INNER JOIN
                      Match.Match with (nolock) ON  Match.Odd.MatchId=Match.Match.MatchId INNER JOIN
					   Match.Setting with (nolock) ON Language.[Parameter.OddsType].OddsTypeId = Match.Odd.OddsTypeId  AND Match.Setting.MatchId=Match.MatchId
WHERE     (Match.Setting.IsPopular=0) AND (Match.Odd.StateId = 2) AND (Match.Match.MatchId = @MatchId) AND 
                      (Language.[Parameter.OddsType].LanguageId = @LangId) and Parameter.OddsType.IsActive=1
--Order By Parameter.OddsType.SeqNumber



END


GO
