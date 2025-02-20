USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcResultMatchScoreOne]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcResultMatchScoreOne]
@ScoreInfoId int,
@LangId int,
@username nvarchar(max)


AS


BEGIN
SET NOCOUNT ON;

select  Match.ScoreInfo.ScoreInfoId,Match.ScoreInfo.MatchId, Match.ScoreInfo.MatchTimeTypeId, Parameter.MatchTimeType.MatchTimeType, Match.ScoreInfo.Score, Match.ScoreInfo.DecidedByFA,Match.ScoreInfo.Comment
FROM         Match.ScoreInfo INNER JOIN
                      Parameter.MatchTimeType ON Match.ScoreInfo.MatchTimeTypeId = Parameter.MatchTimeType.MatchTimeTypeId
                      WHERE     Match.ScoreInfo.ScoreInfoId= @ScoreInfoId
UNION ALL
select  [Archive].ScoreInfo.ScoreInfoId,[Archive].ScoreInfo.MatchId, [Archive].ScoreInfo.MatchTimeTypeId, Parameter.MatchTimeType.MatchTimeType, [Archive].ScoreInfo.Score, [Archive].ScoreInfo.DecidedByFA,[Archive].ScoreInfo.Comment
FROM         [Archive].ScoreInfo INNER JOIN
                      Parameter.MatchTimeType ON [Archive].ScoreInfo.MatchTimeTypeId = Parameter.MatchTimeType.MatchTimeTypeId
                      WHERE     [Archive].ScoreInfo.ScoreInfoId= @ScoreInfoId
                      
                      
                      
END


GO
