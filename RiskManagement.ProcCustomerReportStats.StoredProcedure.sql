USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCustomerReportStats]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [RiskManagement].[ProcCustomerReportStats] 
@Username nvarchar(50)
AS

BEGIN
SET NOCOUNT ON;



declare @UserCurrencyId int
declare @UserBranchId int
select @UserCurrencyId=Users.Users.CurrencyId,
@UserBranchId=Users.Users.UnitCode
from Users.Users 
 where Users.Users.UserName=@Username



 declare @temptable table (CustomerCount int,Balance money)

if(@UserBranchId=1)
	begin

	insert @temptable
	SELECT     COUNT(Customer.Customer.CustomerId) ,SUM(Balance)
                FROM      Customer.Customer with (nolock) where   (IsBranchCustomer=0 or IsBranchCustomer is null)  and (IsTerminalCustomer=0 or IsTerminalCustomer is null) and BranchId not in (31620,31673,31632,
31634,31656,31660,31661,31665,31666,31667,31668,31669,31670,31671,31674,31675,31677,31678,31679,31680,31702,31703,31704,31705,31706,31746,31747,31748,31749,31766,32248,32297,32331,32338,32374,32375,32438,32515,32534,32549,
32550,32551,32561,32562,32638,32639,32640,32641,32687,32779,32780,32787,32813,32814)
				GROUP BY Customer.Customer.CustomerId 

SELECT    COUNT( CustomerCount) as CustomerCount, SUM(Balance)  AS Balance, 0 AS TotalDeposit, 
                      0  AS TotalWithdraw
                FROM      @temptable 
	end
else
	begin

	insert @temptable
		SELECT     COUNT(Customer.Customer.CustomerId) ,SUM(Balance)
                FROM      Customer.Customer with (nolock)
				
				WHERE     Customer.BranchId=@UserBranchId and (IsBranchCustomer=0 or IsBranchCustomer is null)  and (IsTerminalCustomer=0 or IsTerminalCustomer is null)
				GROUP BY Customer.Customer.CustomerId

	
SELECT    COUNT( CustomerCount) as CustomerCount, SUM(Balance)  AS Balance, 0 AS TotalDeposit, 
                      0  AS TotalWithdraw
                FROM      @temptable 
	end

END



GO
