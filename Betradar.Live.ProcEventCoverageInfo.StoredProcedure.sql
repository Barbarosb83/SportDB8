USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Live.ProcEventCoverageInfo]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Betradar].[Live.ProcEventCoverageInfo]
@EventId bigint,
@CoverageInfo nvarchar(max),
@BetradarId  bigint

AS
BEGIN

set @BetradarId=@EventId

--if not exists (select [Live].[EventCoverageInfo].BetradarCoverageInfoId from [Live].[EventCoverageInfo] where [EventId]=@EventId and [BetradarCoverageInfoId]=@BetradarId)
--			 begin
--				INSERT INTO [Live].[EventCoverageInfo]
--						   ([EventId]
--						   ,[CoverageInfo]
--						   ,[BetradarCoverageInfoId])
--					 VALUES
--						   (@EventId
--						   ,@CoverageInfo
--						   ,@BetradarId)
--				end

END


GO
