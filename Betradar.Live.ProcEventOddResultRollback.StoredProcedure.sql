USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Live.ProcEventOddResultRollback]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Betradar].[Live.ProcEventOddResultRollback]
@BetradarMatchId bigint,
@BetradarOddTypeId bigint,
@BetradarOddSubTypeId bigint,
@OutCome nvarchar(50),
@OutComeId int,
@BetRadarPlayerId bigint,
@BetradarTeamId bigint,
@OddValue float,
@SpecialBetValue nvarchar(50),
@BettradarOddId bigint,
@IsActive bit,
@Combination bigint,
@ForTheRest nchar(30),
@Comment nchar(30),
@MostBalanced bit,
@Changed bit,
@OddResult bit,
@VoidFactor float,
@BetradarTimeStamp datetime

AS

BEGIN
 
select 0
	
	
	

END



GO
