USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Live.ProcEventOddCancelRoolBack]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Betradar].[Live.ProcEventOddCancelRoolBack]
@BetradarMatchId bigint,
@BetradarOddTypeId bigint,
@BetradarOddSubTypeId bigint,
@SpecialBetValue nvarchar(50),
@BettradarOddId bigint,
@IsActive bit,
@Combination bigint,
@ForTheRest nchar(30),
@Comment nchar(30),
@MostBalanced bit,
@Changed bit,
@IsCanceled bit,
@BetradarTimeStamp datetime
AS

BEGIN
 
				select 0
END


GO
