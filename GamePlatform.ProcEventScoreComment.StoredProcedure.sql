USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcEventScoreComment]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcEventScoreComment] 
@MatchId bigint,
@LangId int
AS

BEGIN
SET NOCOUNT ON;


if exists (select Match.ScoreComment.ScoreCommentId from Match.ScoreComment with (nolock) where Match.ScoreComment.MatchId=@MatchId)
	begin
		select Match.ScoreComment.ScoreCommentId,Match.ScoreComment.ScoreComment,Match.ScoreComment.MatchId,Match.ScoreComment.LanguageId
		from Match.ScoreComment with (nolock)
		where Match.ScoreComment.MatchId=@MatchId and Match.ScoreComment.LanguageId=1
	
	end
else
	begin
	select Archive.ScoreComment.ScoreCommentId,Archive.ScoreComment.ScoreComment
	,Archive.ScoreComment.MatchId,Archive.ScoreComment.LanguageId
		from Archive.ScoreComment with (nolock)
		where Archive.ScoreComment.MatchId=@MatchId and Archive.ScoreComment.LanguageId=1
	
	end

END


GO
