USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Live.ProcEventTvChannel]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Betradar].[Live.ProcEventTvChannel]
@EventId bigint,
@TvChannel nvarchar(max),
@BetradarId  bigint

AS
BEGIN
set @EventId=1

--INSERT INTO [Live].[EventTvChannel]
--           ([EventId]
--           ,[TvChannel])
--     VALUES
--           (@EventId
--           ,@TvChannel)



END


GO
