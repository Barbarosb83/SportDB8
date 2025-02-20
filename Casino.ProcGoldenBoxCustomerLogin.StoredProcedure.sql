USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Casino].[ProcGoldenBoxCustomerLogin]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Casino].[ProcGoldenBoxCustomerLogin]
@CustomerId bigint 


AS


BEGIN
SET NOCOUNT ON;

declare @token nvarchar(250)=''
declare @Balance money=0
declare @Currency nvarchar(10)='USD'
declare @CurrencyId int=1
if exists (Select [GoldenBoxCustomerId] from [Casino].[GoldenBox.Customer] where  [Casino].[GoldenBox.Customer].CustomerId=@CustomerId )
	begin
		
		Select @token=Token from [Casino].[GoldenBox.Customer] where  [Casino].[GoldenBox.Customer].CustomerId=@CustomerId

	end

	

	select @Balance=Customer.Balance,@Currency=Parameter.Currency.Symbol3,@CurrencyId=Customer.CurrencyId
	from Customer.Customer INNER JOIN Parameter.Currency ON Parameter.Currency.CurrencyId=Customer.Customer.CurrencyId
	 where CustomerId=@CustomerId


	 if(@CurrencyId<>1 and @CurrencyId<>3)
		begin
				
				select @Balance=dbo.FuncCurrencyConverter(@Balance,@CurrencyId,3)

				set @Currency='EUR'
		end


		select @Balance as Balance,@token as Token,@Currency as Currency


END
GO
