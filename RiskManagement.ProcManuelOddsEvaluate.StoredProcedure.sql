USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcManuelOddsEvaluate]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [RiskManagement].[ProcManuelOddsEvaluate]   
@OddId bigint,
@StateId int,
@UserName nvarchar(50),
@VoidFactor nvarchar(10),
@BetType int
as 

BEGIN TRAN
declare @Gain money
declare @IsBranchCustomer bit
declare @CustomerId bigint
declare @SystemSlipId bigint
declare @SlipTypeId int
--declare @TotalOddValue float
declare @Amount money
declare @SlipStateId int
declare @OddStateId int
declare @MatchId bigint
declare @OddTypeId int
declare @SlipId int
declare @OddValue float
declare @SlipOddId bigint
declare @UserId int
if (@StateId=5)
	set @StateId=3
else if (@StateId=6)
	set @StateId=4
else if (@StateId=4)
	set @StateId=2
else if (@StateId=7)
	set @StateId=5
else if (@StateId=2)
	set @StateId=1

declare @SystemSay int=0
declare @MultiSay int=0
	select @UserId=Users.Users.UserId from Users.Users where UserName=@UserName

set nocount on
					declare cur111 cursor local for(
					SELECT     Customer.Slip.CustomerId,  Customer.Slip.Amount, Customer.Slip.SlipStateId, Customer.SlipOdd.StateId, Customer.SlipOdd.MatchId, 
						Customer.SlipOdd.OddsTypeId, Customer.Slip.SlipId,Customer.SlipOdd.SlipOddId,Customer.Slip.SlipTypeId
						FROM Customer.Slip with (nolock) INNER JOIN
                      Customer.SlipOdd with (nolock) ON Customer.Slip.SlipId = Customer.SlipOdd.SlipId
						WHERE     (Customer.SlipOdd.OddId = @OddId) and Customer.SlipOdd.BetTypeId=@BetType

						)

					open cur111
					fetch next from cur111 into @CustomerId,@Amount ,@SlipStateId,@OddStateId,@MatchId,@OddTypeId,@SlipId,@SlipOddId,@SlipTypeId
					while @@fetch_status=0
						begin
							begin

if (@MatchId is not null) and (@OddTypeId is not null) and (Select COUNT(Customer.Slip.SlipId) from Customer.Slip with (nolock) where SlipId=@SlipId and SlipStateId in (7))=0
begin


	--if (@TotalOddValue>100)
	--		set @TotalOddValue=100
if @SlipId is not null and @SlipTypeId<=3
begin

INSERT INTO [RiskManagement].[SlipManuelEvo] ([SlipOddId],[StateId],[CreateDate]) VALUES(@SlipOddId,@StateId,GETDATE())

if(@StateId<>2)
update Customer.SlipOdd set StateId=@StateId where SlipOddId=@SlipOddId
else
	update Customer.SlipOdd set StateId=@StateId,OddValue=1 where SlipOddId=@SlipOddId

select @IsBranchCustomer=IsBranchCustomer from Customer.Customer with (nolock) where CustomerId=@CustomerId
--insert Tempbooking values(@SlipId,@SlipOdId)
--Kazanan Oddtype'ın bütün oddları lost yapılıyor.
declare @TotalOddValue float

--Void olmuş oddlar olabileceğinden Total Odd value tekrar hesaplanıyor.
	select @TotalOddValue=EXP(SUM(LOG(OddValue))) from Customer.SlipOdd with (nolock) where SlipId=@SlipId

		if exists (select Customer.SlipOdd.SlipOddId from Customer.SlipOdd with (nolock) where SlipId=@SlipId and StateId=4)
			begin
				if exists (Select Customer.Slip.SlipId from Customer.Slip with (nolock) where SlipId=@SlipId and SlipStateId in (3,6))
				begin
					select @Gain=@TotalOddValue*@Amount
					exec Job.FuncCustomerBooking @CustomerId,@Gain,0,@SlipId
				end
			if not exists (select Customer.Slip.SlipId from Customer.Slip with (nolock) where SlipId=@SlipId and SlipStateId=7 ) --Slip CashOut yapılmadıysa 
				update Customer.Slip set SlipStateId=4,EvaluateDate=GETDATE(),TotalOddValue=@TotalOddValue where SlipId=@SlipId
			update Customer.Tax set TaxStatusId=3 where SlipId=@SlipId and SlipTypeId=2
					if(@SlipTypeId=3) -- System Kupon kapatma
					begin
						select @SystemSlipId=Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SlipId=@SlipId
						if not exists (select SlipId from Customer.Slip with (nolock) where Customer.Slip.SlipStateId=1 and Customer.Slip.SlipId in  (select Customer.SlipSystemSlip.SlipId from Customer.SlipSystemSlip with (nolock) where SystemSlipId =@SystemSlipId))
						begin
							if exists (select SlipId from Archive.Slip with (nolock) where Archive.Slip.SlipStateId=3 and Archive.Slip.SlipId in  (select Customer.SlipSystemSlip.SlipId from Customer.SlipSystemSlip with (nolock) where SystemSlipId =@SystemSlipId))
								begin
									update Customer.SlipSystem set SlipStateId=3,EvaluateDate=GETDATE() where SystemSlipId=@SystemSlipId

									update Customer.Tax set TaxStatusId=3 where SlipId =@SystemSlipId and SlipTypeId=3

								end
							else if exists (select SlipId from Customer.Slip with (nolock) where Customer.Slip.SlipStateId=3 and Customer.Slip.SlipId in  (select Customer.SlipSystemSlip.SlipId from Customer.SlipSystemSlip with (nolock) where SystemSlipId =@SystemSlipId))
								begin
								update Customer.SlipSystem set SlipStateId=3,EvaluateDate=GETDATE() where SystemSlipId=@SystemSlipId
								update Customer.Tax set TaxStatusId=3 where  SlipId =@SystemSlipId and SlipTypeId=3
								end
							else
								begin

								update Customer.SlipSystem set SlipStateId=4,EvaluateDate=GETDATE() where SystemSlipId=@SystemSlipId
								update Customer.Tax set TaxStatusId=3 where  SlipId =@SystemSlipId and SlipTypeId=3
								end
						end
					end
			
			end
		else if not exists (select Customer.SlipOdd.SlipOddId from Customer.SlipOdd with (nolock) where SlipId=@SlipId and StateId in (1,4))
			begin
				if not exists (select Customer.Slip.SlipId from Customer.Slip with (nolock) where SlipId=@SlipId and Customer.Slip.SlipStateId in (2,3,5,6,7))
				begin
					
					--select @Amount=@TotalOddValue*Amount,@CustomerId=Customer.Slip.CustomerId from Customer.Slip where SlipId=@SlipId
						set @Gain=@TotalOddValue*@Amount
				--insert dbo.Tempbooking values(@CustomerId,@Amount)
					exec Job.FuncCustomerBooking @CustomerId,@Gain,1,@SlipId

					----------------------------------TAX----------------------------------------------------------
					if exists (select TaxAmount from Customer.Tax with (nolock) where SlipId=@SlipId)
					begin
						if(@TotalOddValue=1) --Kupon Cancel olursa tax geri yükleniyor
							begin
								declare @TaxAmount money=0
								declare @TaxId bigint=0
								select @TaxAmount=TaxAmount,@TaxId=Customer.Tax.TaxId from Customer.Tax  with (nolock) where SlipId=@SlipId
								update Customer.Tax set TaxStatusId=2 where SlipId=@SlipId

								exec  [Job].[FuncCustomerBooking2]  @CustomerId,@TaxAmount,1,54,@TaxId
							end
						else
							begin
								update Customer.Tax set TaxStatusId=3 where SlipId=@SlipId

							end

					end
					----------------------------------------------------------------------------------------------------
					--Customer slipteki Total Odd value Void oddlar olabilir diye tekrar update ediliyor.
					update Customer.Slip set SlipStateId=3,EvaluateDate=GETDATE(),TotalOddValue=@TotalOddValue,IsPayOut= Case when @IsBranchCustomer=1 then 0 else 1 end where SlipId=@SlipId
						if(@SlipTypeId=3) -- System Kupon kapatma
					begin
						select @SystemSlipId=Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SlipId=@SlipId
						if not exists (select SlipId from Customer.Slip with (nolock) where Customer.Slip.SlipStateId=1 and Customer.Slip.SlipId in  (select Customer.SlipSystemSlip.SlipId from Customer.SlipSystemSlip with (nolock) where SystemSlipId =@SystemSlipId))
						begin
							if exists (select SlipId from Archive.Slip with (nolock) where Archive.Slip.SlipStateId=3 and Archive.Slip.SlipId in  (select Customer.SlipSystemSlip.SlipId from Customer.SlipSystemSlip with (nolock) where SystemSlipId=@SystemSlipId))
								begin
									update Customer.SlipSystem set SlipStateId=3,EvaluateDate=GETDATE() where SystemSlipId=@SystemSlipId
									update Customer.Tax set TaxStatusId=3 where  SlipId =@SystemSlipId and SlipTypeId=3

								end
							else if exists (select SlipId from Customer.Slip with (nolock) where Customer.Slip.SlipStateId=3 and Customer.Slip.SlipId in  (select Customer.SlipSystemSlip.SlipId from Customer.SlipSystemSlip with (nolock) where SystemSlipId=@SystemSlipId))
								begin
								update Customer.SlipSystem set SlipStateId=3,EvaluateDate=GETDATE() where SystemSlipId=@SystemSlipId
								update Customer.Tax set TaxStatusId=3 where  SlipId =@SystemSlipId and SlipTypeId=3
								end
							else
								begin
								update Customer.SlipSystem set SlipStateId=4,EvaluateDate=GETDATE() where SystemSlipId=@SystemSlipId
								update Customer.Tax set TaxStatusId=3 where  SlipId =@SystemSlipId and SlipTypeId=3
								end
						end
					end


				end
			end
		else if not exists (select  Customer.SlipOdd.SlipOddId from Customer.SlipOdd with (nolock) where SlipId=@SlipId and StateId in (4))
			begin
				if exists (select Customer.SlipOdd.SlipOddId from Customer.SlipOdd with (nolock) where SlipId=@SlipId and StateId in (1))
					begin

						update Customer.Slip set SlipStateId=1 where SlipId=@SlipId
					end

			end
			
	
end
else if @SlipId is not null and @SlipTypeId=4 and @SystemSay=0
begin
if(@StateId<>2)
update Customer.SlipOdd set StateId=@StateId where OddId=@OddId and SlipId in (Select SlipId from Customer.Slip with (nolock) where SlipTypeId=@SlipTypeId)
else
	update Customer.SlipOdd set StateId=@StateId,OddValue=1 where OddId=@OddId and SlipId in (Select SlipId from Customer.Slip with (nolock) where SlipTypeId=@SlipTypeId)
		set @SystemSay=@SystemSay+1
		exec  [RiskManagement].[ProcSlipOddsEvaluateSystem]  @MatchId,@OddTypeId,@BetType
end
else if @SlipId is not null and @SlipTypeId=5 and @MultiSay=0
begin
if(@StateId<>2)
update Customer.SlipOdd set StateId=@StateId where OddId=@OddId and SlipId in (Select SlipId from Customer.Slip with (nolock) where SlipTypeId=@SlipTypeId)
else
	update Customer.SlipOdd set StateId=@StateId,OddValue=1 where OddId=@OddId and SlipId in (Select SlipId from Customer.Slip with (nolock) where SlipTypeId=@SlipTypeId)
		set @MultiSay=@MultiSay+1
		exec  [RiskManagement].[ProcSlipOddsEvaluateMulti]  @MatchId,@OddTypeId,@BetType
end
end
	insert Customer.SlipHistory(SlipOddId,[ActionType],[ActionDate],[UserId])
	values(@SlipOddId,@StateId,GETDATE(),@UserId)



end
							fetch next from cur111 into @CustomerId,@Amount ,@SlipStateId,@OddStateId,@MatchId,@OddTypeId,@SlipId,@SlipOddId,@SlipTypeId
			
						end
					close cur111
					deallocate cur111	

				 




COMMIT TRAN


GO
