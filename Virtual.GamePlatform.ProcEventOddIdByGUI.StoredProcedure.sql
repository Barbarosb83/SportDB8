USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Virtual].[GamePlatform.ProcEventOddIdByGUI]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Virtual].[GamePlatform.ProcEventOddIdByGUI] 
@MatchId bigint,
@BetradarOddId bigint,
@OutCome nvarchar(max)

AS

BEGIN
SET NOCOUNT ON;

SELECT     OddId
FROM         Virtual.EventOdd
WHERE    (BettradarOddId = @BetradarOddId) AND (OutCome = @OutCome)





END


GO
