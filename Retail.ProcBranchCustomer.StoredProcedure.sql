USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcBranchCustomer]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcBranchCustomer] 
@BranchId bigint,
@UserBranchId int
AS

BEGIN
SET NOCOUNT ON;




if(@BranchId!=0)
begin
 
select CustomerId,UserName as Customer,Balance,CustomerName+' '+CustomerSurname as CustomerName,IsActive as  IsActive
from Customer.Customer with (nolock) where IsBranchCustomer<>1 and BranchId in (select BranchId From Parameter.Branch with (nolock) where (BranchId=@BranchId))  
end
else
begin
 
select CustomerId,UserName as Customer,Balance,CustomerName+' '+CustomerSurname as CustomerName,IsActive as IsActive
from Customer.Customer with (nolock) where IsBranchCustomer<>1 and BranchId in (select BranchId from Parameter.Branch with (nolock) where (BranchId=@UserBranchId or ParentBranchId=@UserBranchId or ParentBranchId in (select BranchId from Parameter.Branch with (nolock)  where (BranchId=@UserBranchId or ParentBranchId=@UserBranchId) )))

end



END





GO
