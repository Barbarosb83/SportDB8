USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Live.ProcEventTopOddInsert]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Betradar].[Live.ProcEventTopOddInsert]
@MatchId bigint,
@BetradarMatchId bigint
AS

BEGIN


INSERT INTO [Live].[EventTopOdd]
           ([EventId],[BetradarMatchId])
     VALUES
           (@MatchId,@BetradarMatchId)


END


GO
