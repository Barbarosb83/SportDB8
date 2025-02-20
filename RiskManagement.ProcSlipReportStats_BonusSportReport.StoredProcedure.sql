USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcSlipReportStats_BonusSportReport]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcSlipReportStats_BonusSportReport] 
@Username nvarchar(50),
@where nvarchar(max)
AS

BEGIN
SET NOCOUNT ON;
declare @sqlcommand00 nvarchar(max)
declare @sqlcommand01 nvarchar(max)
declare @sqlcommand99 nvarchar(max)
declare @sqlcommand98 nvarchar(max)
declare @sqlcommand0 nvarchar(max)
declare @sqlcommand nvarchar(max)
declare @UserCurrencyId int
declare @UserBranchId int
declare @RoleId int
declare @Multip float=0
declare @MultipDate nvarchar(20) 

select top 1  @RoleId=Users.UserRoles.RoleId, @UserCurrencyId=Users.Users.CurrencyId,
@UserBranchId=Users.Users.UnitCode,@Multip=Multiplier,@MultipDate=MultipDate
from Users.Users INNER JOIN Users.UserRoles ON Users.UserRoles.UserId=Users.Users.UserId 
where Users.Users.UserName=@Username

set @sqlcommand00='declare @tempTransaction table (SlipId bigint,Amount money) '


set @sqlcommand01=' insert @tempTransaction select TransactionComment,Amount from Customer.[Transaction] where Customer.[Transaction].TransactionId=48 '

set @sqlcommand0='declare @tempSlip table (
	SlipId bigint  NOT NULL,
	CustomerId bigint NOT NULL,
	TotalOddValue float NULL,
	Amount money NULL,
	SlipStateId int NULL,
	CreateDate datetime NULL,
	GroupId bigint NULL,
	SlipTypeId int NULL,
	SourceId int NULL,
	SlipStatu int NULL,
	CurrencyId int NULL,
	EvaluateDate datetime NULL,
	EventCount int NULL,
	IsLive bit NULL,
	MTSTicketId bigint NULL)'

	declare @sqlcommand000 nvarchar(max)='insert @tempSlip select * from Customer.Slip WHERE     (Customer.Slip.SlipStateId = 1) and Customer.Slip.SlipStatu in (1,3) and '+@where

	set @sqlcommand99='declare @temptable table (SlipCount int,Amount money,MacPayout money,CustomerCount int,Balance money) '

	

if(@RoleId<>156)
begin
if(@UserBranchId=1)
	begin
set @sqlcommand= 'insert @temptable SELECT     COUNT(CustomerSlip.SlipId) AS SlipCount,SUM(CST.Amount)* case when cast(CustomerSlip.CreateDate as date )>='''+@MultipDate+''' then '+cast(@Multip as nvarchar(4))+' else 1 end AS Amount,
 SUM(CustomerSlip.TotalOddValue *CST.Amount)* case when cast(CustomerSlip.CreateDate as date )>='''+@MultipDate+''' then '+cast(@Multip as nvarchar(4))+' else 1 end AS MacPayout, 
                      COUNT(DISTINCT CustomerSlip.CustomerId) AS CustomerCount,SUM(CST.Amount)* case when cast(CustomerSlip.CreateDate as date )>='''+@MultipDate+''' then '+cast(@Multip as nvarchar(4))+' else 1 end AS Balance
FROM      @tempSlip as   CustomerSlip INNER JOIN
                      Customer.Customer ON CustomerSlip.CustomerId = Customer.Customer.CustomerId INNER JOIN @tempTransaction as CST ON CST.SlipId=CustomerSlip.SlipId   GROUP BY Customer.Customer.CurrencyId,CustomerSlip.CreateDate'
	end
else
	begin
set @sqlcommand= 'insert @temptable SELECT     COUNT(CustomerSlip.SlipId) AS SlipCount,SUM(CustomerSlip.Amount)* case when cast(CustomerSlip.CreateDate as date )>='''+@MultipDate+''' then '+cast(@Multip as nvarchar(4))+' else 1 end AS Amount,
 SUM(CustomerSlip.TotalOddValue *CustomerSlip.Amount)* case when cast(CustomerSlip.CreateDate as date )>='''+@MultipDate+''' then '+cast(@Multip as nvarchar(4))+' else 1 end AS MacPayout, 
                      COUNT(DISTINCT CustomerSlip.CustomerId) AS CustomerCount,SUM(CustomerSlip.Amount)* case when cast(CustomerSlip.CreateDate as date )>='''+@MultipDate+''' then '+cast(@Multip as nvarchar(4))+' else 1 end AS Balance
FROM      @tempSlip as   CustomerSlip INNER JOIN
                      Customer.Customer ON CustomerSlip.CustomerId = Customer.Customer.CustomerId  GROUP BY Customer.Customer.CurrencyId'
	end
end
else
begin
if(@UserBranchId=1)
	begin
set @sqlcommand= 'SELECT     COUNT(Customer.Slip.SlipId)/5 AS SlipCount, SUM(dbo.FuncCurrencyConverter(Customer.Slip.Amount,Customer.Customer.CurrencyId,'+cast(@UserCurrencyId as nvarchar(5))+') )/5 AS Amount, SUM(dbo.FuncCurrencyConverter(Customer.Slip.TotalOddValue *Customer.Slip.Amount,Customer.Customer.CurrencyId,'+cast(@UserCurrencyId as nvarchar(5))+'))/5 AS MacPayout, 
                      COUNT(DISTINCT Customer.Slip.CustomerId)/5 AS CustomerCount,SUM(dbo.FuncCurrencyConverter(Customer.Slip.Amount,Customer.Customer.CurrencyId,'+cast(@UserCurrencyId as nvarchar(5))+') )/5 AS Balance
FROM         Customer.Slip with (nolock) INNER JOIN
                      Customer.Customer ON Customer.Slip.CustomerId = Customer.Customer.CustomerId
WHERE     (Customer.Slip.SlipStateId = 1) and Customer.Slip.SlipStatu in (1,3) and '+@where
	end
else
	begin
set @sqlcommand ='	SELECT     COUNT(Customer.Slip.SlipId)/5 AS SlipCount, SUM(dbo.FuncCurrencyConverter(Customer.Slip.Amount,Customer.Customer.CurrencyId,'+cast(@UserCurrencyId as nvarchar(5))+') )/5 AS Amount, SUM(dbo.FuncCurrencyConverter(Customer.Slip.TotalOddValue *Customer.Slip.Amount,Customer.Customer.CurrencyId,'+cast(@UserCurrencyId as nvarchar(5))+'))/5 AS MacPayout, 
                     COUNT(DISTINCT Customer.Slip.CustomerId)/5 AS CustomerCount,(select Parameter.Branch.Balance from Parameter.Branch where Parameter.Branch.BranchId='+cast(@UserBranchId as nvarchar(5))+' )/5 AS Balance
FROM         Customer.Slip with (nolock) INNER JOIN
                      Customer.Customer ON Customer.Slip.CustomerId = Customer.Customer.CustomerId
WHERE     (Customer.Slip.SlipStateId = 1) and Customer.Slip.SlipStatu in (1,3) and Customer.BranchId='+cast(@UserBranchId as nvarchar(5))+' and '+@where
	end
end
	

	set @sqlcommand98=' select ISNULL(SUM(SlipCount),0) as SlipCount,ISNULL(dbo.FuncCurrencyConverter(SUM(Amount),71,'+cast(@UserCurrencyId as nvarchar(5))+'),0) as Amount,ISNULL(dbo.FuncCurrencyConverter(SUM(MacPayout),71,'+cast(@UserCurrencyId as nvarchar(5))+'),0) as MacPayout ,ISNULL(sum(CustomerCount),0) as CustomerCount ,ISNULL(dbo.FuncCurrencyConverter(SUM(Balance),71,'+cast(@UserCurrencyId as nvarchar(5))+'),0)  as Balance from @temptable '
	
exec (@sqlcommand00+@sqlcommand01+@sqlcommand0+@sqlcommand99+@sqlcommand000+@sqlcommand+@sqlcommand98)

END



GO
