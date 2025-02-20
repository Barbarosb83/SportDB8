USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Virtual.ProcEventOddCancel]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Betradar].[Virtual.ProcEventOddCancel]
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
@IsCanceled bit
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


if (@VirtualEventId is not null)
	begin
		
		declare @eventoddid bigint  
		declare @IsOddValueLock bit
		
				update Customer.SlipOdd set OddValue=1,StateId=2 where OddsTypeId=@OddsTypeId and MatchId=@VirtualEventId and Customer.SlipOdd.BetTypeId=2
				set nocount on
					declare cur111 cursor local for(
					SELECT  Virtual.EventOdd.OddId  from  Virtual.EventOdd WHERE  Virtual.EventOdd.OddsTypeId=@OddsTypeId and Virtual.EventOdd.MatchId=@VirtualEventId

						)

					open cur111
					fetch next from cur111 into @eventoddid
					while @@fetch_status=0
						begin
							begin
								exec RiskManagement.ProcSlipOddsEvaluateRollBack  @eventoddid,1
							
							end
							fetch next from cur111 into @eventoddid
			
						end
					close cur111
					deallocate cur111	
				
			
				if (@IsOddValueLock=1)
					begin
						UPDATE [Virtual].[EventOdd]
						   SET 
							   [SpecialBetValue] = @SpecialBetValue
							  ,[IsChanged] = @Changed
							  ,[IsActive] = @IsActive
							  ,[Combination] = @Combination
							  ,[ForTheRest] = @ForTheRest
							  ,[Comment] = @Comment
							  ,[MostBalanced] = @MostBalanced
							  ,[IsCanceled]=@IsCanceled
						 WHERE  Virtual.EventOdd.OddsTypeId=@OddsTypeId and Virtual.EventOdd.MatchId=@VirtualEventId
					end
				else
					begin
						UPDATE [Virtual].[EventOdd]
						   SET 
							   [SpecialBetValue] = @SpecialBetValue
							  ,[IsChanged] = @Changed
							  ,[IsActive] = @IsActive
							  ,[Combination] = @Combination
							  ,[ForTheRest] = @ForTheRest
							  ,[Comment] = @Comment
							  ,[MostBalanced] = @MostBalanced
							  ,[IsCanceled]=@IsCanceled
						 WHERE   Virtual.EventOdd.OddsTypeId=@OddsTypeId and Virtual.EventOdd.MatchId=@VirtualEventId
					end

				end


select 0 
	
	
	

END


GO
