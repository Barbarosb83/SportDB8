USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Live.ProcEventExtraInfo]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Betradar].[Live.ProcEventExtraInfo]
@EventId bigint,
@ExtraInfoType nvarchar(max),
@ExtraInfoValue  nvarchar(max)
AS
BEGIN


set @EventId=1
--if (@EventId is not null)
--begin
--INSERT INTO [Live].[EventExtraInfo]
--           ([EventId]
--           ,[ExtraInfoType]
--           ,[ExtraInfoValue])
--     VALUES
--           (@EventId
--           ,@ExtraInfoType
--           ,@ExtraInfoValue)

--end




END


GO
