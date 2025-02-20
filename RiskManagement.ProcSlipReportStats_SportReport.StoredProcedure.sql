USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcSlipReportStats_SportReport]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [RiskManagement].[ProcSlipReportStats_SportReport] 
@Username nvarchar(50),
@where nvarchar(max)
AS

BEGIN
SET NOCOUNT ON;

declare @sqlcommand1 nvarchar(max)=''
declare @sqlcommand11 nvarchar(max)=''
declare @sqlcommand0 nvarchar(max)
declare @sqlcommand nvarchar(max)
declare @UserCurrencyId int
declare @UserBranchId int
declare @RoleId int


select top 1  @RoleId=Users.UserRoles.RoleId, @UserCurrencyId=Users.Users.CurrencyId,
@UserBranchId=Users.Users.UnitCode
from Users.Users INNER JOIN Users.UserRoles ON Users.UserRoles.UserId=Users.Users.UserId 
where Users.Users.UserName=@Username


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
	MTSTicketId bigint NULL,MaxPayout money)'

	declare @sqlcommand000 nvarchar(max)='insert @tempSlip select [SlipId],[CustomerId],[TotalOddValue],[Amount],[SlipStateId],[CreateDate],[GroupId],[SlipTypeId],[SourceId],[SlipStatu],[CurrencyId],[EvaluateDate],[EventCount],[IsLive],[MTSTicketId],TotalOddValue*Amount from Customer.Slip WHERE  Customer.Slip.SlipTypeId<3 and   (Customer.Slip.SlipStateId = 1) and Customer.Slip.SlipStatu in (1,3) and '+@where

	set @sqlcommand000 +='insert @tempSlip select [SystemSlipId],[CustomerId],[TotalOddValue],[Amount],[SlipStateId],[CreateDate],[GroupId],[SlipTypeId],[SourceId],1,[CurrencyId],[EvaluateDate],[EventCount],[IsLive],null,MaxGain from Customer.SlipSystem WHERE    (Customer.SlipSystem.SlipStateId = 1)   and '+REPLACE(@where,'Customer.Slip','Customer.SlipSystem')

	set @sqlcommand1='declare @tempSlip2 table (	SlipCount int  NULL,	Amount money  NULL,	MacPayout money NULL,	CustomerCount int NULL,	Balance  Money NULL)'

	

if(@RoleId<>156)
begin
if(@UserBranchId=1)
	begin
set @sqlcommand= 'insert @tempSlip2  SELECT     COUNT(CustomerSlip.SlipId) AS SlipCount,SUM( CustomerSlip.Amount) AS Amount,
 SUM(MaxPayout) AS MacPayout, 
                      COUNT(DISTINCT CustomerSlip.CustomerId) AS CustomerCount,SUM(CustomerSlip.Amount) AS Balance
FROM      @tempSlip as   CustomerSlip INNER JOIN
                      Customer.Customer ON CustomerSlip.CustomerId = Customer.Customer.CustomerId '

SET @sqlcommand11=' select SUM(SlipCount) as SlipCount,SUM(Amount) as Amount,Sum(MacPayout) as MacPayout,SUM(CustomerCount) as CustomerCount,SUM(Balance) as Balance  from @tempSlip2 '
	end
else
	begin
set @sqlcommand ='insert @tempSlip2  	SELECT     COUNT(CustomerSlip.SlipId) AS SlipCount, SUM(CustomerSlip.Amount) AS Amount, SUM(CustomerSlip.TotalOddValue *CustomerSlip.Amount) AS MacPayout, 
                     COUNT(DISTINCT CustomerSlip.CustomerId) AS CustomerCount,(select Parameter.Branch.Balance from Parameter.Branch where Parameter.Branch.BranchId='+cast(@UserBranchId as nvarchar(5))+' ) AS Balance
FROM         @tempSlip as   CustomerSlip INNER JOIN
                      Customer.Customer ON CustomerSlip.CustomerId = Customer.Customer.CustomerId where Customer.Customer.BranchId='+cast(@UserBranchId as nvarchar(20)) 

					  SET @sqlcommand11=' select SUM(SlipCount) as SlipCount,SUM(Amount) as Amount,Sum(MacPayout) as MacPayout,SUM(CustomerCount) as CustomerCount,SUM(Balance) as Balance  from @tempSlip2 '
	end
end
else
begin
if(@UserBranchId=1)
	begin
set @sqlcommand= 'SELECT     COUNT(Customer.Slip.SlipId)/5 AS SlipCount, SUM(Customer.Slip.Amount)/5 AS Amount, SUM(Customer.Slip.TotalOddValue *Customer.Slip.Amount)/5 AS MacPayout, 
                      COUNT(DISTINCT Customer.Slip.CustomerId)/5 AS CustomerCount,SUM(Customer.Slip.Amount)/5 AS Balance
FROM         Customer.Slip with (nolock) INNER JOIN
                      Customer.Customer ON Customer.Slip.CustomerId = Customer.Customer.CustomerId
WHERE     (Customer.Slip.SlipStateId = 1) and Customer.Slip.SlipStatu in (1,3) and '+@where
	end
else
	begin
set @sqlcommand ='	SELECT     COUNT(Customer.Slip.SlipId)/5 AS SlipCount, SUM(Customer.Slip.Amount )/5 AS Amount, SUM(Customer.Slip.TotalOddValue *Customer.Slip.Amount)/5 AS MacPayout, 
                     COUNT(DISTINCT Customer.Slip.CustomerId)/5 AS CustomerCount,(select Parameter.Branch.Balance from Parameter.Branch where Parameter.Branch.BranchId='+cast(@UserBranchId as nvarchar(5))+' )/5 AS Balance
FROM         Customer.Slip with (nolock) INNER JOIN
                      Customer.Customer ON Customer.Slip.CustomerId = Customer.Customer.CustomerId
WHERE     (Customer.Slip.SlipStateId = 1) and Customer.Slip.SlipStatu in (1,3) and Customer.BranchId='+cast(@UserBranchId as nvarchar(5))+' and '+@where
	end
end
	
	
exec (@sqlcommand0+@sqlcommand000+@sqlcommand1+@sqlcommand+@sqlcommand11)

END



GO
