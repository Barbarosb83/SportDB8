USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [BetAcceptance].[ProcSlipCreateTemp]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [BetAcceptance].[ProcSlipCreateTemp] 
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
 
					insert Customer.SlipTemp(CustomerId,TotalOddValue,Amount,SlipStateId,CreateDate,SlipTypeId,SourceId,CurrencyId,SlipStatu,EventCount,IsLive,MTSTicketId)
					values(@CustomerId,@TotalOddValue,@Amount,@SlipStateId,GETDATE(),@SlipTypeId,@SourceId,@CurrencyId,@SlipStatu,@EventCount,0,@TicketId)
					set @SlipId=SCOPE_IDENTITY()

					 

					
 

return @SlipId

end
GO
