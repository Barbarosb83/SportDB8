USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcBranchCustomerCombo]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcBranchCustomerCombo] 
@BranchId bigint,
@UserBranchId int
AS

BEGIN
SET NOCOUNT ON;




if(@BranchId!=0)
begin
select 0 as CustomerId,' Alle' as Customer,cast(0 as decimal) as Balance,'' as CustomerName,cast(0 as bit) as  IsActive
UNION ALL
select CustomerId,UserName as Customer,Balance,CustomerName+' '+CustomerSurname as CustomerName,IsActive
from Customer.Customer with (nolock) where IsBranchCustomer<>1 and BranchId in (select BranchId From Parameter.Branch with (nolock) where (BranchId=@BranchId))
end
else
begin
select 0 as CustomerId,' Alle' as Customer,cast(0 as decimal) as Balance,'' as CustomerName,cast(0 as bit) as  IsActive
UNION ALL
select CustomerId,UserName as Customer,Balance,CustomerName+' '+CustomerSurname as CustomerName,IsActive
from Customer.Customer with (nolock) where IsBranchCustomer<>1 and BranchId in (select BranchId from Parameter.Branch with (nolock) where (BranchId=@UserBranchId or ParentBranchId=@UserBranchId or ParentBranchId in (select BranchId from Parameter.Branch with (nolock)  where (BranchId=@UserBranchId or ParentBranchId=@UserBranchId) )))
end



END





GO
