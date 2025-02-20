USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Virtual.ProcEventOddResult]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Betradar].[Virtual.ProcEventOddResult]
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
@VoidFactor float

AS

BEGIN
declare @OddsTypeId int
declare @oddId int
declare @PlayerId int=0
declare @TeamId int=0
declare @EventId bigint

declare @VirtualEventId int
select @VirtualEventId=[Virtual].[Event].EventId from [Virtual].[Event] where [Virtual].[Event].[BetradarMatchId]=@BetradarMatchId

if (@BetradarOddSubTypeId is not null)
	begin
		select  @OddsTypeId=OddTypeId from [Virtual].[Parameter.OddType] 
					where [Virtual].[Parameter.OddType].[BetradarOddsTypeId]=@BetradarOddTypeId
					and [Virtual].[Parameter.OddType].[BetradarOddsSubTypeId]=@BetradarOddSubTypeId
	end
else
	begin
		select top 1 @OddsTypeId=OddTypeId from [Virtual].[Parameter.OddType] 
					where [Virtual].[Parameter.OddType].[BetradarOddsTypeId]=@BetradarOddTypeId
	end

if(@BetRadarPlayerId<>0)
	select @PlayerId=Parameter.TeamPlayer.TeamPlayerId,@TeamId=CompetitorId from Parameter.TeamPlayer with (nolock) where Parameter.TeamPlayer.BetradarPlayerId=@BetRadarPlayerId 


if (@VirtualEventId is not null)
	begin
		
		declare @eventoddid bigint 
		declare @IsOddValueLock bit
		
		if(@SpecialBetValue is not null)
			begin
				select @eventoddid=Virtual.EventOdd.OddId,@IsOddValueLock=Virtual.EventOdd.IsOddValueLock from Virtual.EventOdd with (nolock) 
			where Virtual.EventOdd.OddsTypeId=@OddsTypeId and Virtual.EventOdd.MatchId=@VirtualEventId and Virtual.EventOdd.OutCome=@OutCome and Virtual.EventOdd.SpecialBetValue=@SpecialBetValue
		
			END
			ELSE
			begin
				select @eventoddid=Virtual.EventOdd.OddId,@IsOddValueLock=Virtual.EventOdd.IsOddValueLock from Virtual.EventOdd with (nolock) 
			where Virtual.EventOdd.OddsTypeId=@OddsTypeId and Virtual.EventOdd.MatchId=@VirtualEventId and Virtual.EventOdd.OutCome=@OutCome 
		
			END
		
		
		if(@eventoddid is not null)
				begin
				
				if (@IsOddValueLock=1)
					begin
						UPDATE [Virtual].[EventOdd]
						   SET 
							   [SpecialBetValue] = @SpecialBetValue
							  ,[Suggestion] = @OddValue
							  ,[IsChanged] = @Changed
							  ,[IsActive] = @IsActive
							  ,[Combination] = @Combination
							  ,[ForTheRest] = @ForTheRest
							  ,[Comment] = @Comment
							  ,[MostBalanced] = @MostBalanced
							  ,[OddResult]=@OddResult,
							  [VoidFactor]=@VoidFactor
							  ,IsEvaluated=0
						 WHERE Virtual.EventOdd.OddId=@eventoddid
					end
				else
					begin
						UPDATE [Virtual].[EventOdd]
						   SET 
							   [SpecialBetValue] = @SpecialBetValue
							  ,[OddValue] = @OddValue
							  ,[Suggestion] = @OddValue
							  ,[IsChanged] = @Changed
							  ,[IsActive] = @IsActive
							  ,[Combination] = @Combination
							  ,[ForTheRest] = @ForTheRest
							  ,[Comment] = @Comment
							  ,[MostBalanced] = @MostBalanced
							  ,[OddResult]=@OddResult
							  ,[VoidFactor]=@VoidFactor
							    ,IsEvaluated=0
						 WHERE Virtual.EventOdd.OddId=@eventoddid
					end

				end
	end



	
	
	

END


GO
