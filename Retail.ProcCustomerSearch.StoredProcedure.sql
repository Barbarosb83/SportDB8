USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcCustomerSearch]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcCustomerSearch] 
@CustomerId bigint,
	@BranchId int
AS
BEGIN
SET NOCOUNT ON;

 
	if exists (Select Customer.Customer.CustomerId from Customer.Customer where CustomerId=@CustomerId and BranchId=@BranchId)
		begin
			select 100 as ResultCode,Username,Balance,Parameter.Currency.Currency,CustomerName,CustomerSurname,Customer.CurrencyId
			from Customer.Customer INNER JOIN Parameter.Currency ON Customer.CurrencyId=Parameter.Currency.CurrencyId where CustomerId=@CustomerId


		end
	else
		begin
			select -1 as ResultCode,'' as Username,cast(0 as money) as Balance,'' as Currency,'' as CustomerName,'' as CustomerSurname,cast(0 as int) as CurrencyId

		end


END




GO
