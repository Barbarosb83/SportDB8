USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcEventInformation]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcEventInformation] 
@MatchId bigint,
@LangId int
AS

BEGIN
SET NOCOUNT ON;



select 
Match.Information.InformationId,
Match.Information.Information,
Match.Information.MatchId
from Match.Information with (nolock)
where Match.Information.MatchId=@MatchId

END


GO
