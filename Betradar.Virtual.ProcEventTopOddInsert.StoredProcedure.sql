USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Virtual.ProcEventTopOddInsert]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Betradar].[Virtual.ProcEventTopOddInsert]
@MatchId bigint
AS

BEGIN


INSERT INTO [Virtual].[EventTopOdd]
           ([EventId])
     VALUES
           (@MatchId)


END


GO
