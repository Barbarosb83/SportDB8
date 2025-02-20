USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Virtual.ProcEventCoverageInfo]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Betradar].[Virtual.ProcEventCoverageInfo]
@EventId bigint,
@CoverageInfo nvarchar(max),
@BetradarId  bigint

AS
BEGIN

if ((select COUNT(*) from [Virtual].[EventCoverageInfo] where [EventId]=@EventId
			 and [BetradarCoverageInfoId]=@BetradarId)<1)
			 begin
				INSERT INTO [Virtual].[EventCoverageInfo]
						   ([EventId]
						   ,[CoverageInfo]
						   ,[BetradarCoverageInfoId])
					 VALUES
						   (@EventId
						   ,@CoverageInfo
						   ,@BetradarId)
				end

END


GO
