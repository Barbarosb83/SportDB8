USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Virtual.ProcEventStreamingChannel]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Betradar].[Virtual.ProcEventStreamingChannel]
@EventId bigint,
@StreamingChannel nvarchar(max),
@BetradarId  bigint

AS
BEGIN

if ((select COUNT(*) from [Virtual].[EventStreamingChannel] where [EventId]=@EventId
			 and [BetradarStreamingChannelId]=@BetradarId)<1)
			 begin
INSERT INTO [Virtual].[EventStreamingChannel]
           ([EventId]
           ,[StreamingChannel]
           ,[BetradarStreamingChannelId])
     VALUES
           (@EventId
           ,@StreamingChannel
           ,@BetradarId)
end


END


GO
