USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Virtual.ProcEventOdd]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Betradar].[Virtual.ProcEventOdd]
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
@Changed bit

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
		
		declare @OddFactor float
		declare @eventoddid bigint 
		declare @IsOddValueLock bit
		declare @OldOddValue float
		declare @ChangeValue int=0
		declare @newoldvalue float
		set @newoldvalue=@OddValue
		
		if(@SpecialBetValue is not null)
			begin
				select @eventoddid=Virtual.EventOdd.OddId,@OddFactor=Virtual.EventOdd.OddFactor,@IsOddValueLock=Virtual.EventOdd.IsOddValueLock,@OldOddValue=Virtual.EventOdd.Suggestion from Virtual.EventOdd with (nolock) 
				where Virtual.EventOdd.OddsTypeId=@OddsTypeId and Virtual.EventOdd.MatchId=@VirtualEventId and Virtual.EventOdd.OutCome=@OutCome and Virtual.EventOdd.SpecialBetValue=@SpecialBetValue
			END
			ELSE
			begin
				select @eventoddid=Virtual.EventOdd.OddId,@OddFactor=Virtual.EventOdd.OddFactor,@IsOddValueLock=Virtual.EventOdd.IsOddValueLock,@OldOddValue=Virtual.EventOdd.Suggestion from Virtual.EventOdd with (nolock) 
				where Virtual.EventOdd.OddsTypeId=@OddsTypeId and Virtual.EventOdd.MatchId=@VirtualEventId and Virtual.EventOdd.OutCome=@OutCome 
			END
			
		if(@eventoddid is null)
			begin
			
					INSERT INTO [Virtual].[EventOdd]
				   ([OddsTypeId],[OutCome],[OutComeId],[SpecialBetValue]
				   ,[CompetitorId]
				   ,[OddValue]
				   ,[MatchId]
				   ,[PlayerId]
				   ,[BettradarOddId]
				   ,[Suggestion]
				   ,[ParameterOddId]
				   ,[IsOddValueLock]
				   ,[IsChanged]
				   ,[IsActive]
				   ,[Combination]
				   ,[ForTheRest]
				   ,[Comment]
				   ,[MostBalanced])
			 VALUES
				   (@OddsTypeId,@OutCome,@OutComeId,@SpecialBetValue
				   ,0
				   ,@OddValue
				   ,@VirtualEventId
				   ,@PlayerId
				   ,@BettradarOddId
				   ,@OddValue,0
				   ,0
				   ,0
				   ,@IsActive
				   ,@Combination
				   ,@ForTheRest
				   ,@Comment
				   ,@MostBalanced)
					
				set @eventoddid=SCOPE_IDENTITY()
					
				execute [Betradar].[Virtual.ProcOddSettingInsert] @OddsTypeId,@eventoddid,@VirtualEventId
				 
				exec [Betradar].[Virtual.ProcEventTopOdd] @VirtualEventId, @OutCome, @SpecialBetValue,@OddValue,@eventoddid,@IsActive,@ChangeValue,@OddsTypeId
			end
			else
				begin
				
				if (@OldOddValue is not null)
					begin
						if (@OldOddValue<@OddValue)
							begin
								set @ChangeValue=1
							end
						else if (@OldOddValue>@OddValue)
							begin
								set @ChangeValue=2
							end
					end
				
				if (@IsOddValueLock=1)
					begin
						UPDATE [Virtual].[EventOdd]
						   SET 
							   [SpecialBetValue] = @SpecialBetValue
							  ,[Suggestion] = @OddValue
							  ,[IsChanged] = @ChangeValue
							  ,[IsActive] = @IsActive
							  ,[Combination] = @Combination
							  ,[ForTheRest] = @ForTheRest
							  ,[Comment] = @Comment
							  ,[MostBalanced] = @MostBalanced
						 WHERE Virtual.EventOdd.OddId=@eventoddid
						 
						 -- lock olduğu için zaten değişmiyor exec [Betradar].[Virtual.ProcEventTopOdd] @VirtualEventId, @OutCome,  @SpecialBetValue, (@OddValue*@OddFactor)
					end
				else
					begin
						
						
						set @newoldvalue=@OddValue*@OddFactor
					
						UPDATE [Virtual].[EventOdd]
						   SET 
							   [SpecialBetValue] = @SpecialBetValue
							  ,[OddValue] = @newoldvalue
							  ,[Suggestion] = @OddValue
							  ,[IsChanged] = @ChangeValue
							  ,[IsActive] = @IsActive
							  ,[Combination] = @Combination
							  ,[ForTheRest] = @ForTheRest
							  ,[Comment] = @Comment
							  ,[MostBalanced] = @MostBalanced
						 WHERE Virtual.EventOdd.OddId=@eventoddid
						 
						 exec [Betradar].[Virtual.ProcEventTopOdd] @VirtualEventId, @OutCome,  @SpecialBetValue,@newoldvalue,@eventoddid,@IsActive,@ChangeValue,@OddsTypeId
					end

				end
				
		--INSERT INTO [Virtual].[EventOddHistory]
  --         ([OddId]
  --         ,[OutCome]
  --         ,[SpecialBetValue]
  --         ,[OddValue]
  --         ,[Suggestion]
  --         ,[IsActive]
  --         ,[OddFactor]
  --         ,[ChangeDate])
		-- VALUES
		--	   (@eventoddid
		--	   ,@OutCome
		--	   ,@SpecialBetValue
		--	   ,@newoldvalue
		--	   ,@OddValue
		--	   ,@IsActive
		--	   ,@OddFactor
		--	   ,GETDATE())
				
	end



	
	
	

END


GO
