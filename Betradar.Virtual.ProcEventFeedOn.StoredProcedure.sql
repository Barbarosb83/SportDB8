USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Virtual.ProcEventFeedOn]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Betradar].[Virtual.ProcEventFeedOn]


AS

BEGIN

	Select Virtual.Event.EventId from Virtual.Event where Virtual.Event.FeedStatu=1

END


GO
