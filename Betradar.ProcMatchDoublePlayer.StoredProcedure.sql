USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[ProcMatchDoublePlayer]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Betradar].[ProcMatchDoublePlayer]
@MatchId bigint,
@PlayerId bigint,
@PlayerName nvarchar(150),
@Language nvarchar(10),
@Orders nvarchar(50),
@SuperId bigint,
@BetradarTeamId bigint,
@TeamId bigint

AS

BEGIN

declare @lanId int=0

--select @lanId=Language.Language.LanguageId from Language.Language   with (nolock)  where Language.Language.Language=@Language

--if exists (select Match.DoublePlayer.[MatchDoublePlayerId] from Match.DoublePlayer with (nolock) where MatchId=@MatchId and SuperId=@SuperId and LangId=@lanId)
--		update Match.DoublePlayer set PlayerName=@PlayerName where  MatchId=@MatchId and SuperId=@SuperId and LangId=@lanId
--else
--	insert Match.DoublePlayer(MatchId,PlayerId,PlayerName,LangId,Orders,SuperId,TeamId)
--	values (@MatchId,@PlayerId,@PlayerName,@lanId,@Orders,@SuperId,@TeamId)

	
	
	

END


GO
