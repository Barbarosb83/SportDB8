USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcSlipReportStats]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcSlipReportStats] 
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

declare @Balance money=0
declare @SlipCount int=0
declare @Amount money=0
declare @MacPayout money=0
declare @CustomerCount int=0


declare @temptable table (SlipCount int,Amount money,MacPayout money,CustomerCount int,Balance money)


if(@RoleId<>156)
begin

if(@UserBranchId=1)
	begin
	insert @temptable
SELECT     COUNT(Customer.Slip.SlipId) AS SlipCount, SUM(Customer.Slip.Amount)  AS Amount
, SUM(Customer.Slip.TotalOddValue *Customer.Slip.Amount) AS MacPayout, 
                      COUNT(DISTINCT Customer.Slip.CustomerId) AS CustomerCount
					  ,SUM(Customer.Slip.Amount) AS Balance
FROM         Customer.Slip with (nolock)  INNER JOIN
                      Customer.Customer ON Customer.Slip.CustomerId = Customer.Customer.CustomerId
WHERE     (Customer.Slip.SlipStateId = 1) and Customer.Slip.SlipStatu in (1,3) and Customer.Slip.SlipTypeId <3


	insert @temptable
SELECT     COUNT(Customer.SlipSystem.SystemSlipId) AS SlipCount, SUM(Customer.SlipSystem.Amount)  AS Amount
, SUM(Customer.SlipSystem.MaxGain) AS MacPayout, 
                      COUNT(DISTINCT Customer.SlipSystem.CustomerId) AS CustomerCount
					  ,SUM(Customer.SlipSystem.Amount)  AS Balance
FROM         Customer.SlipSystem with (nolock)  INNER JOIN
                      Customer.Customer ON Customer.SlipSystem.CustomerId = Customer.Customer.CustomerId
WHERE     (Customer.SlipSystem.SlipStateId = 1) 



select SUM(SlipCount) as SlipCount,SUM(Amount) as Amount,sum(MacPayout) as MacPayout,sum(CustomerCount) as CustomerCount,SUM(Balance) as Balance
FROM @temptable


	end
else
	begin

	select @Balance=Parameter.Branch.Balance from Parameter.Branch where Parameter.Branch.BranchId=@UserBranchId


	SELECT    @SlipCount=ISNULL(COUNT(Customer.Slip.SlipId),0) ,@Amount= ISNULL(SUM(Customer.Slip.Amount),0) ,
	@MacPayout=ISNULL( SUM(Customer.Slip.TotalOddValue *Customer.Slip.Amount),0), 
               @CustomerCount=ISNULL(COUNT(DISTINCT Customer.Slip.CustomerId),0) 
FROM         Customer.Slip with (nolock)  INNER JOIN
                      Customer.Customer ON Customer.Slip.CustomerId = Customer.Customer.CustomerId
WHERE     (Customer.Slip.SlipStateId = 1) and Customer.Slip.SlipStatu in (1,3) and Customer.BranchId=@UserBranchId


select @SlipCount as SlipCount,@Amount as Amount,@MacPayout as MacPayout,@CustomerCount as CustomerCount,@Balance as Balance


	end

end
else
begin

if(@UserBranchId=1)
	begin
SELECT     COUNT(Customer.Slip.SlipId)/5 AS SlipCount, SUM(Customer.Slip.Amount)/5  AS Amount, SUM(Customer.Slip.TotalOddValue *Customer.Slip.Amount)/5 AS MacPayout, 
                      COUNT(DISTINCT Customer.Slip.CustomerId)/5 AS CustomerCount
					  ,SUM(Customer.Slip.Amount )/5 AS Balance
FROM         Customer.Slip with (nolock)  INNER JOIN
                      Customer.Customer ON Customer.Slip.CustomerId = Customer.Customer.CustomerId
WHERE     (Customer.Slip.SlipStateId = 1) and Customer.Slip.SlipStatu in (1,3)

	end
else
	begin
	SELECT    ISNULL(COUNT(Customer.Slip.SlipId),0)/5 AS SlipCount, ISNULL(SUM(Customer.Slip.Amount),0)/5  AS Amount,
	ISNULL( SUM(Customer.Slip.TotalOddValue *Customer.Slip.Amount),0)/5 AS MacPayout, 
                     ISNULL(COUNT(DISTINCT Customer.Slip.CustomerId),0)/5 AS CustomerCount,ISNULL((select Parameter.Branch.Balance from Parameter.Branch where Parameter.Branch.BranchId=@UserBranchId),0)/5 AS Balance
FROM         Customer.Slip with (nolock)  INNER JOIN
                      Customer.Customer ON Customer.Slip.CustomerId = Customer.Customer.CustomerId
WHERE     (Customer.Slip.SlipStateId = 1) and Customer.Slip.SlipStatu in (1,3) and Customer.BranchId=@UserBranchId

	end

end
END



GO
