USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcEventTVChannel]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcEventTVChannel] 
@MatchId bigint,
@LangId int
AS

BEGIN
SET NOCOUNT ON;



select Match.TVChannel.TVChannel,Match.TVChannel.TVChannelId,Match.TVChannel.StartDate 
from Match.TVChannel with (nolock)
where Match.TVChannel.MatchId=@MatchId


END


GO
