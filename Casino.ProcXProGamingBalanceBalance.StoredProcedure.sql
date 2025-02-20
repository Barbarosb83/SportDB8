USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Casino].[ProcXProGamingBalanceBalance]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Casino].[ProcXProGamingBalanceBalance]
@Username nvarchar(150),
@Session nvarchar(150)


AS


BEGIN
SET NOCOUNT ON;



if exists (select Customer.Customer.CustomerId from Customer.Customer with (nolock) where Customer.Customer.Username=@Username)
begin
select case when Customer.Customer.Balance<=0 then cast('-10' as money) else dbo.FuncCurrencyConverter(Customer.Customer.Balance ,Customer.Customer.CurrencyId,3) end as Balance,
'EUR' as currency,cast(0 as money) as Bonus
From Customer.Customer INNER JOIN 
Parameter.Currency ON Parameter.Currency.CurrencyId=Customer.CurrencyId
where Customer.Customer.Username=@Username
end
else
select cast(-10 as money) as Balance,'EUR' as currency,cast(0 as money) as Bonus


END





GO
