USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcEventScoreInfo]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcEventScoreInfo] 
@MatchId bigint,
@LangId int
AS

BEGIN
SET NOCOUNT ON;


if exists (select Match.ScoreInfo.ScoreInfoId from Match.ScoreInfo with (nolock) where Match.ScoreInfo.MatchId=@MatchId)
	begin
		select Match.ScoreInfo.ScoreInfoId
		,Match.ScoreInfo.Comment
		,Match.ScoreInfo.DecidedByFA
		,Match.ScoreInfo.MatchId
		,Match.ScoreInfo.MatchTimeTypeId
		,Match.ScoreInfo.Score
		,Parameter.MatchTimeType.MatchTimeType
		from Match.ScoreInfo with (nolock) INNER JOIN
		Parameter.MatchTimeType with (nolock) ON Parameter.MatchTimeType.MatchTimeTypeId=Match.ScoreInfo.MatchTimeTypeId
		where Match.ScoreInfo.MatchId=@MatchId 
	
	end
else
	begin
	select Archive.ScoreInfo.ScoreInfoId
		,Archive.ScoreInfo.Comment
		,Archive.ScoreInfo.DecidedByFA
		,Archive.ScoreInfo.MatchId
		,Archive.ScoreInfo.MatchTimeTypeId
		,Archive.ScoreInfo.Score
		,Parameter.MatchTimeType.MatchTimeType
		from Archive.ScoreInfo with (nolock) INNER JOIN
		Parameter.MatchTimeType with (nolock) ON Parameter.MatchTimeType.MatchTimeTypeId=Archive.ScoreInfo.MatchTimeTypeId
		where Archive.ScoreInfo.MatchId=@MatchId 
	
	end

END


GO
