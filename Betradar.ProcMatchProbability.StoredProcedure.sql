USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[ProcMatchProbability]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Betradar].[ProcMatchProbability]
@MatchId bigint,
@BetradarOddTypeId bigint,
@OutCome nvarchar(50),
@OutComeId int,
@BetRadarPlayerId bigint,
@BetradarTeamId bigint,
@SpecialBetValue nvarchar(50),
@ProbabilityValue float,
@SportId int

AS

BEGIN
declare @OddsTypeId int

declare @PlayerId int=0
declare @TeamId int=0

--SELECT  top 1  @OddsTypeId= Parameter.Odds.OddTypeId
--FROM         Parameter.Odds INNER JOIN
--                      Parameter.OddsType ON Parameter.Odds.OddTypeId = Parameter.OddsType.OddsTypeId
--where Parameter.OddsType.BetradarOddsTypeId=@BetradarOddTypeId and  Parameter.OddsType.SportId=@SportId

--if(@OddsTypeId is null)
--begin
--SELECT  top 1  @OddsTypeId=Parameter.OddsType.OddsTypeId
--FROM        Parameter.OddsType
--where Parameter.OddsType.BetradarOddsTypeId=@BetradarOddTypeId and  Parameter.OddsType.SportId=30 --and IsActive=1
--end

if(@BetRadarPlayerId<>0)
	select @PlayerId=Parameter.TeamPlayer.TeamPlayerId,@TeamId=CompetitorId from Parameter.TeamPlayer with (nolock) where Parameter.TeamPlayer.BetradarPlayerId=@BetRadarPlayerId 

If EXISTS (select Match.Probability.ProbabilityId from Match.Probability with (nolock)  where Match.Probability.MatchId=@MatchId and Match.Probability.OddsTypeId=@BetradarOddTypeId and Match.Probability.OutCome=@OutCome and Match.Probability.SpecialBetValue=@SpecialBetValue)
	begin
		update Match.Probability set ProbabilityValue=@ProbabilityValue where Match.Probability.MatchId=@MatchId and Match.Probability.OddsTypeId=@BetradarOddTypeId and Match.Probability.OutCome=@OutCome and Match.Probability.SpecialBetValue=@SpecialBetValue
	end
	else
	begin
		insert Match.Probability (MatchId,OddsTypeId,Outcome,SpecialBetValue,OutcomeId,TeamPlayerId,CompetitorId,ProbabilityValue)
		values (@MatchId,@BetradarOddTypeId,@OutCome,@SpecialBetValue,@OutComeId,@PlayerId,@TeamId,@ProbabilityValue)
	end
	



	
	
	

END


GO
