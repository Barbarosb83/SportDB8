USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Virtual.ProcEventTvChannel]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Betradar].[Virtual.ProcEventTvChannel]
@EventId bigint,
@TvChannel nvarchar(max),
@BetradarId  bigint

AS
BEGIN

INSERT INTO [Virtual].[EventTvChannel]
           ([EventId]
           ,[TvChannel])
     VALUES
           (@EventId
           ,@TvChannel)



END


GO
