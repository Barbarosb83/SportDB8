USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [BetAcceptance].[ProcSlipCreate]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [BetAcceptance].[ProcSlipCreate] 
@CustomerId bigint,
@TotalOddValue float,
@Amount money,
@SlipStateId int,
@SlipTypeId int,
@SourceId int,
@SlipStatu int,
@TicketId bigint,
@EventCount int


AS
begin
declare @SlipId bigint=0
declare @CurrencyId int
declare @Balance money=0
declare @BonusAmount money
declare @BonusId int
declare @DepositAmount money
declare @IsBranchCustomer bit
declare @BranchId int
declare @IsTerminalCustomer bit

select @CurrencyId=Customer.Customer.CurrencyId,@Balance=Customer.Balance,@IsBranchCustomer=IsBranchCustomer,@BranchId=BranchId,@IsTerminalCustomer=IsTerminalCustomer 
from Customer.Customer with (nolock) where Customer.CustomerId=@CustomerId
 

if(@IsBranchCustomer=1 )
	select @Balance=Balance from Parameter.Branch with (nolock) where Parameter.Branch.BranchId=@BranchId

----Müşterinin aktif bonusu yoksa slip yaratılıyor.
--if not exists (select  Customer.Bonus.CustomerBonusId from Customer.Bonus with (nolock) where Customer.Bonus.CustomerId=@CustomerId and IsActive=1 and IsUsed=0 )
--	begin
			if(@Balance+0.009>=@Amount or @SlipTypeId>=3) --System kuponun para işlemleri SlipSystemCreate sp sinde yapılıyor.
				begin
					insert Customer.Slip(CustomerId,TotalOddValue,Amount,SlipStateId,CreateDate,SlipTypeId,SourceId,CurrencyId,SlipStatu,EventCount,IsLive,MTSTicketId)
					values(@CustomerId,@TotalOddValue,@Amount,@SlipStateId,GETDATE(),@SlipTypeId,@SourceId,@CurrencyId,@SlipStatu,@EventCount,0,@TicketId)
					set @SlipId=SCOPE_IDENTITY()

					if @SlipTypeId<3
					begin
							insert Customer.[Transaction](CustomerId,Amount,CurrencyId,TransactionDate,TransactionTypeId,TransactionSourceId,TransactionComment,TransactionBalance)
							values(@CustomerId,@Amount,@CurrencyId,GETDATE(),4,1,CAST(@TotalOddValue as nvarchar(10))+'-'+CAST(@SlipId as nvarchar(20)),@Balance-@Amount)

							if(@IsBranchCustomer=0)
								update Customer.Customer set Balance=@Balance-@Amount where Customer.CustomerId=@CustomerId
							else
								update Parameter.Branch set Balance=@Balance-@Amount where Parameter.Branch.BranchId=@BranchId

					end

					

					--if(@SlipStatu=2)
					--	execute Users.Notification 1,0,1,90,''	


				end
	--end
--else
--	begin

--		select top 1 @BonusId=Customer.Bonus.BonusId,@BonusAmount=BonusAmount,@DepositAmount=DepositAmount from Customer.Bonus where Customer.Bonus.CustomerId=@CustomerId and IsActive=1 and IsUsed=0 order by CreateDate

--		--Oynanacak kupon müşteri bakiyesi ve bonus tutarından küçük mü diye kontrol ediliyor.
--		if (@Balance+@BonusAmount>=@Amount)
--			begin
--				if(@Balance>=@Amount)
--				begin
--						insert Customer.Slip(CustomerId,TotalOddValue,Amount,SlipStateId,CreateDate,SlipTypeId,SourceId,CurrencyId,SlipStatu,EventCount,IsLive,MTSTicketId)
--						values(@CustomerId,@TotalOddValue,@Amount,@SlipStateId,GETDATE(),@SlipTypeId,@SourceId,@CurrencyId,@SlipStatu,@EventCount,0,@TicketId)
--						set @SlipId=SCOPE_IDENTITY()

--						if @SlipTypeId<>3
--					begin
--						insert Customer.[Transaction](CustomerId,Amount,CurrencyId,TransactionDate,TransactionTypeId,TransactionSourceId,TransactionComment,TransactionBalance)
--						values(@CustomerId,@Amount,@CurrencyId,GETDATE(),4,1,CAST(@TotalOddValue as nvarchar(10))+'-'+CAST(@SlipId as nvarchar(20)),@Balance-@Amount)

--							update Customer.Customer set Balance=@Balance-@Amount where Customer.CustomerId=@CustomerId

--						end
				

--					--if(@SlipStatu=2)
--					--	execute Users.Notification 1,0,1,90,''	
--				end
--				else
--					begin
--						if(@Balance+@BonusAmount=@Amount)
--							begin
--							--Bonus şartları sağlanıyormu?
--							declare @BonusMinOddValue float
--							declare @BonusEventCount int

--							select @BonusMinOddValue=BonusMinOddValue,@BonusEventCount=MinCombineCount from Bonus.[Rule] where Bonus.[Rule].BonusRuleId=@BonusId

--							if(@BonusMinOddValue<=@TotalOddValue and @BonusEventCount<=@EventCount)
--								begin



--									insert Customer.Slip(CustomerId,TotalOddValue,Amount,SlipStateId,CreateDate,SlipTypeId,SourceId,CurrencyId,SlipStatu,EventCount,IsLive,MTSTicketId)
--									values(@CustomerId,@TotalOddValue,@Amount,@SlipStateId,GETDATE(),@SlipTypeId,@SourceId,@CurrencyId,@SlipStatu,@EventCount,0,@TicketId)
--									set @SlipId=SCOPE_IDENTITY()
								
--								if @SlipTypeId<>3
--									begin
--									insert Customer.[Transaction](CustomerId,Amount,CurrencyId,TransactionDate,TransactionTypeId,TransactionSourceId,TransactionComment,TransactionBalance)
--									values(@CustomerId,(@Amount-@BonusAmount),@CurrencyId,GETDATE(),4,1,CAST(@TotalOddValue as nvarchar(10))+'-'+CAST(@SlipId as nvarchar(20)),@Balance-(@Amount-@BonusAmount))

--									insert Customer.[Transaction](CustomerId,Amount,CurrencyId,TransactionDate,TransactionTypeId,TransactionSourceId,TransactionComment,TransactionBalance)
--									values(@CustomerId,(@Amount-@Balance),@CurrencyId,GETDATE(),48,1,CAST(@SlipId as nvarchar(20)),@Balance-(@Amount-@BonusAmount))

--									update Customer.Customer set Balance=@Balance-(@Amount-@BonusAmount) where Customer.CustomerId=@CustomerId
--									update Customer.Customer set Bonus=0 where Customer.CustomerId=@CustomerId

--									update Customer.Bonus set IsUsed=1,UsedDate=Getdate(),UsedSlipId=@SlipId,IsActive=0 where CustomerId=@CustomerId and BonusId=@BonusId

--									end
									
--								end
--							else
--								set @SlipId=-2
--							end
--						else
--							begin

--								set @SlipId=-1
--							end

--					end

--			end

				


--	end

return @SlipId

end
GO
