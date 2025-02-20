USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Casino].[ProcSwissSoftCustomerBalanceControl]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Casino].[ProcSwissSoftCustomerBalanceControl]
@CustomerId bigint,
@Amount money

AS


BEGIN
SET NOCOUNT ON;


declare @CurrencyParity money=1
declare @CustomerCurrencyId int

select @CustomerCurrencyId=CurrencyId from Customer.Customer where CustomerId=@CustomerId



if(select dbo.FuncCurrencyConverter(Customer.Customer.Balance,@CustomerCurrencyId,3)-@Amount
From Customer.Customer
where Customer.Customer.CustomerId=@CustomerId)>=0
	select cast(dbo.FuncCurrencyConverter(Customer.Customer.Balance,@CustomerCurrencyId,3) as decimal(18,2)) as Balance,
Parameter.Currency.Symbol3 as currency,0 as TransactionId
From Customer.Customer INNER JOIN 
Parameter.Currency ON Parameter.Currency.CurrencyId=Customer.CurrencyId
where Customer.Customer.CustomerId=@CustomerId
else
	select cast('-1' as money) as Balance,
Parameter.Currency.Symbol3 as currency,0 as TransactionId
From Customer.Customer INNER JOIN 
Parameter.Currency ON Parameter.Currency.CurrencyId=Customer.CurrencyId
where Customer.Customer.CustomerId=@CustomerId



END
GO
