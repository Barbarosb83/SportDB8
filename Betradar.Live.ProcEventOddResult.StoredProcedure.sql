USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Live.ProcEventOddResult]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Betradar].[Live.ProcEventOddResult]
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
@ForTheRest nchar(250),
@Comment nchar(250),
@MostBalanced bit,
@Changed bit,
@OddResult bit,
@VoidFactor float,
@BetradarTimeStamp datetime

AS

BEGIN
 
declare @oddId int
declare @TeamId int=0
declare @EventId bigint
declare @LiveEventId int
 
END


GO
