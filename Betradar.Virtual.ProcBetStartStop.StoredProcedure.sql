USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Virtual.ProcBetStartStop]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Betradar].[Virtual.ProcBetStartStop]
           @BetradarMatchId bigint,
           @BetStatus int

AS
BEGIN
	
	
	declare @VirtualEventId int=-1
	select @VirtualEventId=[Virtual].[Event].EventId from [Virtual].[Event] where [Virtual].[Event].[BetradarMatchId]=@BetradarMatchId
		

			UPDATE [Virtual].[EventDetail]
				SET [BetStatus] = @BetStatus
					Where [Virtual].[EventDetail].EventDetailId=@VirtualEventId

	
END


GO
