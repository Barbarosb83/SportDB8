USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Live.ProcEventStreamingChannel]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Betradar].[Live.ProcEventStreamingChannel]
@EventId bigint,
@StreamingChannel nvarchar(max),
@BetradarId  bigint

AS
BEGIN

set @EventId=@BetradarId
--if not exists (select [Live].[EventStreamingChannel].BetradarStreamingChannelId from [Live].[EventStreamingChannel]  with (nolock)  where [EventId]=@EventId and [BetradarStreamingChannelId]=@BetradarId)
--			 begin
--					INSERT INTO [Live].[EventStreamingChannel]
--							   ([EventId]
--							   ,[StreamingChannel]
--							   ,[BetradarStreamingChannelId])
--						 VALUES
--							   (@EventId
--							   ,@StreamingChannel
--							   ,@BetradarId)
--end


END


GO
