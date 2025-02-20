USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Casino].[ProcSwissSoftCustomerBalanceBySession]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 

CREATE PROCEDURE [Casino].[ProcSwissSoftCustomerBalanceBySession]
@SessionId nvarchar(150)


AS


BEGIN
SET NOCOUNT ON;


declare @CustomerId bigint
declare @CurrencyParity money=1

select top 1 @CustomerId=Casino.[SwissSoft.Customer].CustomerId
from Casino.[SwissSoft.Customer]
where SesionId=@SessionId




select case when dbo.FuncCurrencyConverter(Customer.Customer.Balance,Customer.Customer.CurrencyId,3)<=0 then cast('-1' as money) 
else cast(dbo.FuncCurrencyConverter(Customer.Customer.Balance,Customer.Customer.CurrencyId,3) as decimal(18,2)) end as Balance,
Parameter.Currency.Symbol3 as currency
From Customer.Customer INNER JOIN 
Parameter.Currency ON Parameter.Currency.CurrencyId=Customer.CurrencyId
where Customer.Customer.CustomerId=@CustomerId



END





GO
