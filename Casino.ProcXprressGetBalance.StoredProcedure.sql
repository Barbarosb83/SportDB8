USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Casino].[ProcXprressGetBalance]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Casino].[ProcXprressGetBalance]
@CustomerId bigint


AS


BEGIN
SET NOCOUNT ON;




select case when Customer.Customer.Balance<=0 then cast('-1' as money) else dbo.FuncCurrencyConverter(Customer.Customer.Balance ,Customer.Customer.CurrencyId,3) end as Balance,
'EUR' as currency,cast(0 as money) as Bonus
From Customer.Customer INNER JOIN 
Parameter.Currency ON Parameter.Currency.CurrencyId=Customer.CurrencyId
where Customer.Customer.CustomerId=@CustomerId



END





GO
