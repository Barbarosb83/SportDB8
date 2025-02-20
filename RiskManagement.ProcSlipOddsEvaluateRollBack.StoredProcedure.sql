USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcSlipOddsEvaluateRollBack]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [RiskManagement].[ProcSlipOddsEvaluateRollBack] 
@OddId bigint,
@IsLive int
as 

begin    

declare @SlipId bigint
declare @Amount money
declare @CustomerId int
declare @SlipTypeId int

set nocount on
					declare cur111 cursor local for(
					select Customer.Slip.SlipId,Customer.Slip.SlipTypeId
				FROM         Customer.SlipOdd INNER JOIN
                      Customer.Slip ON Customer.SlipOdd.SlipId = Customer.Slip.SlipId
					where Customer.SlipOdd.OddId=136123416 and Customer.SlipOdd.BetTypeId=1 and SlipTypeId<3 and Customer.Slip.SlipStateId in (1,3,4,5,6)

						)

					open cur111
					fetch next from cur111 into @SlipId,@SlipTypeId
					while @@fetch_status=0
						begin
							begin




	
if @SlipId is not null
begin


declare @TotalOddValue float
--Void olmuş oddlar olabileceğinden Total Odd value tekrar hesaplanıyor.
	select @TotalOddValue=EXP(SUM(LOG(OddValue))) from Customer.SlipOdd where SlipId=@SlipId
	update Customer.Slip set TotalOddValue=@TotalOddValue where SlipId=@SlipId  and SlipTypeId<3
	
		if(select Count(Customer.Slip.SlipId) from Customer.Slip where SlipId=@SlipId and Customer.Slip.SlipStateId in (3,5,6)  and SlipTypeId<3)>1
			begin
				
					select @Amount=@TotalOddValue*Amount,@CustomerId=Customer.Slip.CustomerId from Customer.Slip where SlipId=@SlipId and SlipTypeId<3
					exec Job.FuncCustomerBooking @CustomerId,@Amount,0,@SlipId
				
			update Customer.Slip set SlipStateId=1,EvaluateDate=NULL,TotalOddValue=@TotalOddValue where SlipId=@SlipId
			

			
			end
		else if(select Count(Customer.Slip.SlipId) from Customer.Slip where SlipId=@SlipId and Customer.Slip.SlipStateId in (4)  and SlipTypeId<3)>1
			begin
				
			update Customer.Slip set SlipStateId=1,EvaluateDate=NULL,TotalOddValue=@TotalOddValue where SlipId=@SlipId  and SlipTypeId<3
			
			end
		else if (select COUNT(Customer.SlipOdd.SlipOddId) from Customer.SlipOdd where SlipId=@SlipId and Customer.SlipOdd.StateId in (1,4) )=0
			begin
			if(select Count(Customer.Slip.SlipId) from Customer.Slip where SlipId=@SlipId and Customer.Slip.SlipStateId in (3,5,6)  and SlipTypeId<3)=0
				begin
				select @Amount=@TotalOddValue*Amount,@CustomerId=Customer.Slip.CustomerId from Customer.Slip where SlipId=@SlipId  and SlipTypeId<3
				--insert dbo.Tempbooking values(@CustomerId,@Amount)
					exec Job.FuncCustomerBooking @CustomerId,@Amount,1,@SlipId 
					--Customer slipteki Total Odd value Void oddlar olabilir diye tekrar update ediliyor.
					update Customer.Slip set SlipStateId=3,EvaluateDate=GETDATE(),TotalOddValue=@TotalOddValue where SlipId=@SlipId  and SlipTypeId<3
				end
			
			end
			
			end
			

end
							fetch next from cur111 into @SlipId,@SlipTypeId
			
						end
					close cur111
					deallocate cur111	
end


GO
