USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Stadium].[ProcSlipOddsEvaluate]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Stadium].[ProcSlipOddsEvaluate] 
@MatchId bigint,
@OddTypeId int,
@BetTypeId int
as 


begin    

declare @SlipId bigint
declare @Amount money
declare @Gain money
declare @CustomerId bigint
declare @TotalOdd float
declare @tempSlip table (SlipId bigint,Gain money,CustomerId bigint,Amount money,SlipTyepId int)
declare @SlipTypeId int
declare @SystemSlipId bigint
declare @IsBranchCustomer bit
declare @StadiumId bigint


insert @tempSlip
	select Stadium.Slip.SlipId,Stadium.Slip.Amount*Stadium.Slip.TotalOddValue,Stadium.Slip.CustomerId,Stadium.Slip.Amount,Stadium.Slip.SlipTypeId
					FROM         Stadium.SlipOdd with (nolock)  INNER JOIN
                      Stadium.Slip with (nolock)  ON Stadium.SlipOdd.SlipId = Stadium.Slip.SlipId
					where Stadium.SlipOdd.MatchId=@MatchId and Stadium.SlipOdd.OddsTypeId=@OddTypeId and Stadium.Slip.SlipStateId in (1,4) and Stadium.Slip.SlipStatu in (1,3)
					and Stadium.SlipOdd.BetTypeId=@BetTypeId

set nocount on
					declare cur111 cursor local for(
					select SlipId,Gain,CustomerId,Amount,SlipTyepId From @tempSlip

						)

					open cur111
					fetch next from cur111 into @SlipId,@Gain,@CustomerId,@Amount, @SlipTypeId 
					while @@fetch_status=0
						begin
							begin
			
--insert Tempbooking values(@SlipId,@SlipOdId)
--Kazanan Oddtype'ın bütün oddları lost yapılıyor.
declare @TotalOddValue float

--Void olmuş oddlar olabileceğinden Total Odd value tekrar hesaplanıyor.
	select @TotalOddValue=EXP(SUM(LOG(OddValue))) from Stadium.SlipOdd with (nolock) where SlipId=@SlipId
	--if (@TotalOddValue>100)
	--		set @TotalOddValue=100
if @SlipId is not null
begin
	select @StadiumId=StadiumId from Stadium.Customers where SlipId=@SlipId				 

		if exists (select Stadium.SlipOdd.SlipOddId from Stadium.SlipOdd with (nolock) where SlipId=@SlipId and StateId=4)
			begin
			
				update Stadium.Slip set SlipStateId=4,EvaluateDate=GETDATE(),TotalOddValue=@TotalOddValue where SlipId=@SlipId
				--update Stadium.Customers set IsWon=0 where SlipId=@SlipId
				 
			
			end
		else if not exists (select Stadium.SlipOdd.SlipOddId from Stadium.SlipOdd with (nolock) where SlipId=@SlipId and StateId in (1,4))
			begin
				 ----------------------------------------------------------------------------------------------
					--Customer slipteki Total Odd value Void oddlar olabilir diye tekrar update ediliyor.
					update Stadium.Slip set SlipStateId=3,EvaluateDate=GETDATE(),TotalOddValue=@TotalOddValue
					  where SlipId=@SlipId

					--update Stadium.Customers set IsWon=1 where SlipId=@SlipId
					 

				end
			end
		else if not exists (select  Stadium.SlipOdd.SlipOddId from Stadium.SlipOdd with (nolock) where SlipId=@SlipId and StateId in (4))
			begin
				if exists (select Stadium.SlipOdd.SlipOddId from Stadium.SlipOdd with (nolock) where SlipId=@SlipId and StateId in (1))
					begin

						update Stadium.Slip set SlipStateId=1 where SlipId=@SlipId

						 

					end

			end
			if (Select COUNT(*) from Stadium.Customers where StadiumId=@StadiumId)>1
			begin
				if not exists (Select Stadium.Slip.SlipId from Stadium.Slip where SlipId in (select SlipId from Stadium.Customers where StadiumId=@StadiumId) and SlipStateId=1)
						begin
							declare @WinSlipId bigint

							select top 1 @WinSlipId=Stadium.Slip.SlipId from Stadium.Slip where SlipId in (select SlipId from Stadium.Customers where StadiumId=@StadiumId ) and SlipStateId=3 order by TotalOddValue desc
							update Stadium.Customers set StateId=4 where StadiumId=@StadiumId
							update Stadium.Customers set StateId=3 where SlipId=@WinSlipId
						end
			end
			else
				begin
				if not exists (Select Stadium.Slip.SlipId from Stadium.Slip where SlipId in (select SlipId from Stadium.Customers where StadiumId=@StadiumId) and SlipStateId=1)
						begin

							update Stadium.Customers set StateId=2 where StadiumId=@StadiumId
							 
						end
				end

end
							fetch next from cur111 into @SlipId,@Gain,@CustomerId,@Amount,@SlipTypeId
			
						end
					close cur111
					deallocate cur111

					delete @tempSlip
end


GO
