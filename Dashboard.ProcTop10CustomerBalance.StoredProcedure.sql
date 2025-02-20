USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Dashboard].[ProcTop10CustomerBalance]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Dashboard].[ProcTop10CustomerBalance] 
@Username nvarchar(50)
AS

BEGIN
SET NOCOUNT ON;


declare @UserCurrencyId int
declare @UserBranchId int
declare @RoleId int


select top 1  @RoleId=Users.UserRoles.RoleId, @UserCurrencyId=Users.Users.CurrencyId,
@UserBranchId=Users.Users.UnitCode
from Users.Users INNER JOIN Users.UserRoles ON Users.UserRoles.UserId=Users.Users.UserId 
where Users.Users.UserName=@Username



if(@RoleId<>156)
begin
if(@UserBranchId=1)
	begin
		SELECT top 10  Customer.CustomerId,Customer.CustomerName+' '+Customer.CustomerSurname+' ('+Customer.Username+')' as Customer
		, Customer.Customer.Balance  as Balance  
		FROM         Customer.Customer with (nolock) where  IsBranchCustomer=0
		ORDER BY  Customer.Customer.Balance  desc
	end
else
	begin
		SELECT top 10  Customer.CustomerId,Customer.CustomerName+' '+Customer.CustomerSurname+' ('+Customer.Username+')' as Customer
		, Customer.Customer.Balance  as Balance  
		FROM         Customer.Customer with (nolock)
		where Customer.BranchId=@UserBranchId and IsBranchCustomer=0
		ORDER BY  Customer.Customer.Balance  desc
	end
end
else
begin
if(@UserBranchId=1)
	begin
		SELECT top 10  Customer.CustomerId,Customer.CustomerName+' '+Customer.CustomerSurname+' ('+Customer.Username+')' as Customer
		,Customer.Customer.Balance/5 as Balance  
		FROM         Customer.Customer with (nolock)
		ORDER BY Customer.Customer.Balance desc
	end
else
	begin
		SELECT top 10  Customer.CustomerId,Customer.CustomerName+' '+Customer.CustomerSurname+' ('+Customer.Username+')' as Customer
		,Customer.Customer.Balance/5 as Balance  
		FROM         Customer.Customer with (nolock)
		where Customer.BranchId=@UserBranchId
		ORDER BY Customer.Customer.Balance desc
	end
end

END


GO
