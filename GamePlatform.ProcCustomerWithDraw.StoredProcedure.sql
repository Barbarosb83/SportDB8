USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerWithDraw]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcCustomerWithDraw] 
@CustomerId bigint,
@Amount money,
@CurrenyId int
AS

BEGIN
SET NOCOUNT ON;
set @CurrenyId=3
declare @Balance money

select @Balance=ISNULL(Customer.Customer.Balance,0) from Customer.Customer where Customer.CustomerId=@CustomerId


insert Customer.[Transaction] (CustomerId,Amount,CurrencyId,TransactionDate,TransactionTypeId,TransactionSourceId,TransactionBalance)
values(@CustomerId,-1*@Amount,@CurrenyId,GETDATE(),2,1,@Balance-@Amount)




set @Balance=@Balance-@Amount

update Customer.Customer set Balance=@Balance where CustomerId=@CustomerId

select @Balance

END


GO
