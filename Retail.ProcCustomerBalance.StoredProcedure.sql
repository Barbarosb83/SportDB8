USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcCustomerBalance]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Retail].[ProcCustomerBalance] 
@BranchId int,
@CustomerId bigint,
@LangId int
AS
BEGIN
SET NOCOUNT ON;



declare @CustomerCurrencyId int
declare @IsTerminal int=0
declare @Balance money=0
declare @Currency nvarchar(5)
declare @SystemCurrencyId int
--select top 1 @SystemCurrencyId=SystemCurrencyId from General.Setting 
select  @CustomerCurrencyId=Customer.Customer.CurrencyId,@BranchId=Customer.Customer.BranchId,@Balance=Balance
,@Currency=Parameter.Currency.Sybol
from Customer.Customer with (nolock) INNER JOIN Parameter.Currency with (nolock) ON Parameter.Currency.CurrencyId=Customer.CurrencyId where Customer.Customer.CustomerId=@CustomerId

 




if exists (select IsTerminalCustomer from Customer.Customer with (nolock) where CustomerId=@CustomerId and IsTerminalCustomer=1)
begin

select @Balance= Balance   from Parameter.Branch with (nolock) where BranchId=@BranchId
set @IsTerminal=1
 
end


select @Balance as Balance,@Currency as Currency,@IsTerminal as IsTerminal



END



GO
