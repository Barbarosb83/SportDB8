USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcEventTVChannel]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcEventTVChannel] 
@MatchId bigint,
@LangId int
AS

BEGIN
SET NOCOUNT ON;



select Match.TVChannel.TVChannel,Match.TVChannel.TVChannelId,Match.TVChannel.StartDate 
from Match.TVChannel
where Match.TVChannel.MatchId=@MatchId


END


GO
