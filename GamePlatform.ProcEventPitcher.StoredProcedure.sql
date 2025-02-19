USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcEventPitcher]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcEventPitcher] 
@MatchId bigint,
@LangId int
AS

BEGIN
SET NOCOUNT ON;



select 
Match.Pitcher.Team1Name
,Match.Pitcher.Team1Hand
,Match.Pitcher.Team2Name
,Match.Pitcher.Team2Hand
from Match.Pitcher  with (nolock)
where Match.Pitcher.MatchId=@MatchId


END


GO
