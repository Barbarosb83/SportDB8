USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[ProcMatchScoreComment]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Betradar].[ProcMatchScoreComment]
@MatchId bigint,
@ScoreComment nvarchar(250),
@Language nvarchar(10)

AS

BEGIN
declare @lanId int=0


--select @lanId=Language.Language.LanguageId from Language.Language with (nolock) where Language.Language.Language=@Language

--insert Match.ScoreComment(MatchId,ScoreComment,LanguageId) values (@MatchId,@ScoreComment,@lanId)

END


GO
