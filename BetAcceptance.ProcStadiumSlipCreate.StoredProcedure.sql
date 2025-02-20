USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [BetAcceptance].[ProcStadiumSlipCreate]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [BetAcceptance].[ProcStadiumSlipCreate] 
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

declare @SlipId bigint=-1
declare @CurrencyId int
declare @Balance money=0
declare @BonusAmount money
declare @BonusId int
declare @DepositAmount money
declare @IsBranchCustomer bit
declare @BranchId int
declare @IsTerminalCustomer bit

select @CurrencyId=Customer.Customer.CurrencyId,@Balance=Customer.Balance,@IsBranchCustomer=IsBranchCustomer,@BranchId=BranchId,@IsTerminalCustomer=IsTerminalCustomer from Customer.Customer with (nolock) where Customer.CustomerId=@CustomerId
 

if(@IsBranchCustomer=1 )
	select @Balance=Balance from Parameter.Branch with (nolock) where Parameter.Branch.BranchId=@BranchId

--Müşterinin aktif bonusu yoksa slip yaratılıyor.
 
				if((select Stadium.Stadium.ActivePlayerCount from Stadium.Stadium where StadiumId=@TicketId)>=(Select Count(*) from Stadium.Customers where StadiumId=@TicketId))
					begin
					insert Stadium.Slip(CustomerId,TotalOddValue,Amount,SlipStateId,CreateDate,SlipTypeId,SourceId,CurrencyId,SlipStatu,EventCount,IsLive,MTSTicketId)
					values(@CustomerId,@TotalOddValue,@Amount,@SlipStateId,GETDATE(),@SlipTypeId,@SourceId,@CurrencyId,@SlipStatu,@EventCount,0,@TicketId)
					set @SlipId=SCOPE_IDENTITY()

					insert Stadium.Customers([StadiumId],[CustomerId],[SlipId],[CreateDate],[CardChangeCount])
					values (@TicketId,@CustomerId,@SlipId,GETDATE(),3)

					update Stadium.Stadium set ActivePlayerCount=ActivePlayerCount+1 where StadiumId=@TicketId
					end
					--if @SlipTypeId<>3
					--begin
					--		insert Customer.[Transaction](CustomerId,Amount,CurrencyId,TransactionDate,TransactionTypeId,TransactionSourceId,TransactionComment,TransactionBalance)
					--		values(@CustomerId,@Amount,@CurrencyId,GETDATE(),4,1,CAST(@TotalOddValue as nvarchar(10))+'-'+CAST(@SlipId as nvarchar(20)),@Balance-@Amount)

					--		if(@IsBranchCustomer=0)
					--			update Customer.Customer set Balance=@Balance-@Amount where Customer.CustomerId=@CustomerId
					--		else
					--			update Parameter.Branch set Balance=@Balance-@Amount where Parameter.Branch.BranchId=@BranchId

					--end

					
 
  
	 
 

return @SlipId

GO
