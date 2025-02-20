USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcSlipOddsEvaluateCancel]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcSlipOddsEvaluateCancel] 
@MatchId bigint
as 

begin    

declare @SlipId bigint
declare @Amount money
declare @CustomerId int
declare @SlipTypeId int
declare @SystemSlipId bigint



--set nocount on
--					declare cur111 cursor local for(
--					select Customer.Slip.SlipId,Customer.Slip.SlipTypeId 
--					FROM         Customer.SlipOdd INNER JOIN
--                      Customer.Slip ON Customer.SlipOdd.SlipId = Customer.Slip.SlipId
--					where Customer.SlipOdd.MatchId=@MatchId  and Customer.Slip.SlipStateId in (1,3) and  Customer.Slip.SlipStatu in (1,3)

--						)

--					open cur111
--					fetch next from cur111 into @SlipId,@SlipTypeId
--					while @@fetch_status=0
--						begin
--							begin



----insert Tempbooking values(@SlipId,@SlipOdId)
----Kazanan Oddtype'ın bütün oddları lost yapılıyor.
--declare @TotalOddValue float
----Void olmuş oddlar olabileceğinden Total Odd value tekrar hesaplanıyor.
--	select @TotalOddValue=EXP(SUM(LOG(OddValue))) from Customer.SlipOdd where SlipId=@SlipId
	
--if @SlipId is not null
--begin
--		if(select Count(Customer.SlipOdd.SlipOddId) from Customer.SlipOdd where SlipId=@SlipId and StateId=4)>0
--			begin
--				if(Select COUNT(Customer.Slip.SlipId) from Customer.Slip where SlipId=@SlipId and SlipStateId in (3,6))>0
--				begin
--					select @Amount=TotalOddValue*Amount,@CustomerId=Customer.Slip.CustomerId from Customer.Slip where SlipId=@SlipId
--					exec Job.FuncCustomerBooking @CustomerId,@Amount,0,@SlipId 
--				end
--			update Customer.Slip set SlipStateId=4,EvaluateDate=GETDATE() where SlipId=@SlipId
--			update Customer.Tax set TaxStatusId=3 where SlipId=@SlipId and SlipTypeId=2
--			if(@SlipTypeId=3) -- System Kupon kapatma
--					begin
--						select @SystemSlipId=Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SlipId=@SlipId
--						if(select Count(SlipId) from Customer.Slip where Customer.Slip.SlipStateId=1 and Customer.Slip.SlipId in  (select Customer.SlipSystemSlip.SlipId from Customer.SlipSystemSlip where SystemSlipId in (@SystemSlipId)))=0
--						begin
--							if(select Count(SlipId) from Archive.Slip where Archive.Slip.SlipStateId=3 and Archive.Slip.SlipId in  (select Customer.SlipSystemSlip.SlipId from Customer.SlipSystemSlip where SystemSlipId in (@SystemSlipId)))>0
--								begin
--									update Customer.SlipSystem set SlipStateId=3,EvaluateDate=GETDATE() where SystemSlipId=@SystemSlipId
--									update Customer.Tax set TaxStatusId=3 where SlipId =@SystemSlipId and SlipTypeId=3

--								end
--							else if(select Count(SlipId) from Customer.Slip where Customer.Slip.SlipStateId=3 and Customer.Slip.SlipId in  (select Customer.SlipSystemSlip.SlipId from Customer.SlipSystemSlip where SystemSlipId in (@SystemSlipId)))>0
--							begin
--								update Customer.SlipSystem set SlipStateId=3,EvaluateDate=GETDATE() where SystemSlipId=@SystemSlipId
--								update Customer.Tax set TaxStatusId=3 where SlipId =@SystemSlipId and SlipTypeId=3
--							end
--							else
--							begin
--								update Customer.SlipSystem set SlipStateId=4,EvaluateDate=GETDATE() where SystemSlipId=@SystemSlipId
--								update Customer.Tax set TaxStatusId=3 where SlipId =@SystemSlipId and SlipTypeId=3
--							end
--						end
--					end
			
--			end
--		else if(select Count(Customer.SlipOdd.SlipOddId) from Customer.SlipOdd where SlipId=@SlipId and StateId in (1,4))=0
--			begin
--				if(select Count(Customer.Slip.SlipId) from Customer.Slip where SlipId=@SlipId and Customer.Slip.SlipStateId in (2,3,4,5,7))=0
--				begin
					
--					select @Amount=@TotalOddValue*Amount,@CustomerId=Customer.Slip.CustomerId from Customer.Slip where SlipId=@SlipId
--				--insert dbo.Tempbooking values(@CustomerId,@Amount)
--					exec Job.FuncCustomerBooking @CustomerId,@Amount,1,@SlipId

--					----------------------------------TAX----------------------------------------------------------
--					if (@SlipTypeId<>3)
--					begin
--						if(select COUNT(TaxAmount) from Customer.Tax where SlipId=@SlipId and SlipTypeId=2)>0
--						begin
--							if(@TotalOddValue=1) --Kupon Cancel olursa tax geri yükleniyor
--								begin
--									declare @TaxAmount money=0
--									declare @TaxId bigint=0
--									select @TaxAmount=TaxAmount,@TaxId=Customer.Tax.TaxId from Customer.Tax where SlipId=@SlipId and SlipTypeId=2
--									update Customer.Tax set TaxStatusId=2 where SlipId=@SlipId and SlipTypeId=2

--									exec  [Job].[FuncCustomerBooking2]  @CustomerId,@TaxAmount,1,54,@TaxId
--								end
--							else
--								begin
--									update Customer.Tax set TaxStatusId=3 where SlipId=@SlipId and SlipTypeId=2

--								end

--						end
--					end
				 


--					--Customer slipteki Total Odd value Void oddlar olabilir diye tekrar update ediliyor.
--					if(select COUNT(*) from Customer.SlipOdd where SlipId=@SlipId and StateId=3)>0
--					update Customer.Slip set SlipStateId=3,EvaluateDate=GETDATE(),TotalOddValue=@TotalOddValue where SlipId=@SlipId
--					else 
--					update Customer.Slip set SlipStateId=2,EvaluateDate=GETDATE() where SlipId=@SlipId

--					if(@SlipTypeId=3) -- System Kupon kapatma
--					begin
--						select @SystemSlipId=Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SlipId=@SlipId
--						if(select Count(SlipId) from Customer.Slip where Customer.Slip.SlipStateId=1 and Customer.Slip.SlipId in  (select Customer.SlipSystemSlip.SlipId from Customer.SlipSystemSlip where SystemSlipId in (@SystemSlipId)))=0
--						begin
--							if(select Count(SlipId) from Archive.Slip where Archive.Slip.SlipStateId=3 and Archive.Slip.SlipId in  (select Customer.SlipSystemSlip.SlipId from Customer.SlipSystemSlip where SystemSlipId in (@SystemSlipId)))>0
--								begin
--									update Customer.SlipSystem set SlipStateId=3,EvaluateDate=GETDATE() where SystemSlipId=@SystemSlipId
--									update Customer.Tax set TaxStatusId=3 where SlipId =@SystemSlipId and SlipTypeId=3

--								end
--							else if(select Count(SlipId) from Customer.Slip where Customer.Slip.SlipStateId=3 and Customer.Slip.SlipId in  (select Customer.SlipSystemSlip.SlipId from Customer.SlipSystemSlip where SystemSlipId in (@SystemSlipId)))>0
--								begin
--								update Customer.SlipSystem set SlipStateId=3,EvaluateDate=GETDATE() where SystemSlipId=@SystemSlipId
--								update Customer.Tax set TaxStatusId=3 where SlipId =@SystemSlipId and SlipTypeId=3
--								end
--							else
--							begin
--								update Customer.SlipSystem set SlipStateId=4,EvaluateDate=GETDATE() where SystemSlipId=@SystemSlipId
--								update Customer.Tax set TaxStatusId=3 where SlipId =@SystemSlipId and SlipTypeId=3
--								end
--						end
--					end


--				end
--			end
			
	
--end
--end
--							fetch next from cur111 into @SlipId,@SlipTypeId
			
--						end
--					close cur111
--					deallocate cur111	
end


GO
