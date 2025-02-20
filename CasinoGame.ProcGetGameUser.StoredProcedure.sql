USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [CasinoGame].[ProcGetGameUser]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [CasinoGame].[ProcGetGameUser]
@Token nvarchar(250)

AS


BEGIN
SET NOCOUNT ON;

declare @result bigint=1

 declare @CustomerId bigint

if exists (Select CasinoGameCustomerId  FROM [CasinoGame].[Customer] with (nolock) where Token=@Token)
	begin
		Select @CustomerId=CustomerId  FROM [CasinoGame].[Customer] with (nolock) where Token=@Token

		select  CustomerId,Username, case when Customer.Customer.Balance<=0 then cast('-10' as money) else dbo.FuncCurrencyConverter(Customer.Customer.Balance ,Customer.Customer.CurrencyId,3) end as Balance,
'EUR' as currency
From Customer.Customer INNER JOIN 
Parameter.Currency ON Parameter.Currency.CurrencyId=Customer.CurrencyId
where Customer.Customer.Username=@CustomerId

	end
else 
	begin
	select cast(0 as bigint),'' as Username, cast(-100 as money) as Balance,'EUR' as currency 
		 

	end

 
	
END

GO
