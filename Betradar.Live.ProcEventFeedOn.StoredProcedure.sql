USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Live.ProcEventFeedOn]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Betradar].[Live.ProcEventFeedOn]


AS

BEGIN

	Select Live.Event.EventId from Live.Event with (nolock) where Live.Event.FeedStatu=1

END


GO
