USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Job].[FuncCustomerBooking]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Job].[FuncCustomerBooking]
@CustomerId bigint,
	@Amount money,
	@Type int,
	@Comment bigint
AS

BEGIN

declare @CurrencyId int
declare @Balance money	
	 
	select @CurrencyId=CurrencyId,@Balance=Customer.Customer.Balance  from Customer.Customer where CustomerId=@CustomerId
	
	if(@Type=0)
	begin
		update Customer.Customer set Customer.Customer.Balance=Balance-@Amount where Customer.Customer.CustomerId=@CustomerId
	
		insert Customer.[Transaction](CustomerId,Amount,CurrencyId,TransactionDate,TransactionTypeId,TransactionSourceId,TransactionComment,TransactionBalance)
		values(@CustomerId,@Amount,@CurrencyId,GETDATE(),8,3,cast(@Comment as nvarchar(50)),@Balance-@Amount)
	end
	else if(@Type=1)
	begin
		if not exists(Select TransactionId from Customer.[Transaction] where CustomerId=@CustomerId and TransactionTypeId=3 and TransactionSourceId=3 and TransactionComment=cast(@Comment as nvarchar(50)))
		begin
			update Customer.Customer set Customer.Customer.Balance=Balance+@Amount where Customer.Customer.CustomerId=@CustomerId
			insert Customer.[Transaction](CustomerId,Amount,CurrencyId,TransactionDate,TransactionTypeId,TransactionSourceId,TransactionComment,TransactionBalance)
			values(@CustomerId,@Amount,@CurrencyId,GETDATE(),3,3,cast(@Comment as nvarchar(50)),@Balance+@Amount)
		end
	end
		else if(@Type=2)
	begin
		update Customer.Customer set Customer.Customer.Balance=Balance+@Amount where Customer.Customer.CustomerId=@CustomerId
		insert Customer.[Transaction](CustomerId,Amount,CurrencyId,TransactionDate,TransactionTypeId,TransactionSourceId,TransactionComment,TransactionBalance)
		values(@CustomerId,@Amount,@CurrencyId,GETDATE(),8,3,cast(@Comment as nvarchar(50)),@Balance+@Amount)
	end
	else if(@Type=3)
	begin
	 
			update Customer.Customer set Customer.Customer.Balance=Balance+@Amount where Customer.Customer.CustomerId=@CustomerId
			insert Customer.[Transaction](CustomerId,Amount,CurrencyId,TransactionDate,TransactionTypeId,TransactionSourceId,TransactionComment,TransactionBalance)
			values(@CustomerId,@Amount,@CurrencyId,GETDATE(),3,3,cast(@Comment as nvarchar(50)),@Balance+@Amount)
	 
	end

END


GO
