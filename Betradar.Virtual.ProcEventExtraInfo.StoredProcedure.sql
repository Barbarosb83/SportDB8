USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Virtual.ProcEventExtraInfo]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Betradar].[Virtual.ProcEventExtraInfo]
@EventId bigint,
@ExtraInfoType nvarchar(max),
@ExtraInfoValue  nvarchar(max)
AS
BEGIN

INSERT INTO [Virtual].[EventExtraInfo]
           ([EventId]
           ,[ExtraInfoType]
           ,[ExtraInfoValue])
     VALUES
           (@EventId
           ,@ExtraInfoType
           ,@ExtraInfoValue)






END


GO
