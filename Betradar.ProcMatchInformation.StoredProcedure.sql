USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[ProcMatchInformation]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Betradar].[ProcMatchInformation]
@MatchId bigint,
@Information nvarchar(max),
@Language nvarchar(10)
AS




BEGIN
declare @LanId int=0

	--select @LanId= [Language].[Language].LanguageId from [Language].[Language] where [Language].[Language]=@Language

END


GO
