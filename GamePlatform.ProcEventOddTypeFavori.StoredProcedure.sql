USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcEventOddTypeFavori]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcEventOddTypeFavori] 
@MatchId bigint,
@LangId int
AS

BEGIN
SET NOCOUNT ON;

SELECT DISTINCT 
                        case when (Select COUNT(Parameter.Odds.OddsId) from Parameter.Odds with (nolock) where Parameter.Odds.OddTypeId=Parameter.OddsType.OddsTypeId and LiveOddId is null)> 0 
					  then 'C' 
					  else '' end as OutcomesDescription
					  , Match.OddTypeSetting.IsPopular, Match.OddTypeSetting.OddTypeId, Match.OddTypeSetting.MatchId, 
                      Match.Match.TournamentId, Language.[Parameter.OddsType].OddsType
FROM         Parameter.OddsType with (nolock) INNER JOIN
                      Language.[Parameter.OddsType] with (nolock) ON Parameter.OddsType.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId AND 
                      Parameter.OddsType.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId INNER JOIN
                      Match.OddTypeSetting with (nolock) ON Language.[Parameter.OddsType].OddsTypeId = Match.OddTypeSetting.OddTypeId INNER JOIN
                      Match.Match with (nolock) ON Match.OddTypeSetting.MatchId = Match.Match.MatchId
WHERE     (Parameter.OddsType.IsPopular = 1) AND (Match.OddTypeSetting.StateId = 2) AND (Match.OddTypeSetting.MatchId = @MatchId) and Language.[Parameter.OddsType].LanguageId=@LangId
and Parameter.OddsType.IsActive=1
END


GO
