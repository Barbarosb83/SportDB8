USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcComboTimeZone]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcComboTimeZone] 

AS

BEGIN
SET NOCOUNT ON;


select Parameter.TimeZone.TimeZoneId,Parameter.TimeZone.TimeZone
 from Parameter.TimeZone


END


GO
