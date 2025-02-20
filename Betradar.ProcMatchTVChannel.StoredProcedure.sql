USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[ProcMatchTVChannel]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Betradar].[ProcMatchTVChannel]
@MatchId bigint,
@TVChannelId int,
@TVChannel nvarchar(250),
@StartDate datetime

AS

BEGIN


if not exists (select Match.TVChannel.TVChannelId from Match.TVChannel with (nolock) where Match.TVChannel.MatchId=@MatchId and Match.TVChannel.TVChannelId=@TVChannelId)
insert Match.TVChannel (MatchId,TVChannelId,TVChannel,StartDate) 
values (@MatchId,@TVChannelId,@TVChannel,@StartDate)

END


GO
