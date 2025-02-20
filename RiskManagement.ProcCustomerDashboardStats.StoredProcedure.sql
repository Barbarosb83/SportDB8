USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCustomerDashboardStats]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [RiskManagement].[ProcCustomerDashboardStats] 
@CustomerId bigint,
@Username nvarchar(50),
@StartDate datetime,
@EndDate datetime
AS

BEGIN
SET NOCOUNT ON;

declare @TotalDeposit money
declare @TotalWithdraw money
declare @Balance money
declare @TotalBetStake money
declare @TotalCasinoGain money
declare @TotalCasinoStake money
declare @TotalCasino money
declare @TotalBetGain money
declare @CustomerCurrencyId int
declare @UserCurrencyId int
declare @OpenSlipCount int
declare @WonSlipCount int
declare @LostSlipCount int
declare @AllSlipCount int
declare @BonusBalance money
  declare @AddHour int=2
SELECT @AddHour=[AddHour]  FROM [Parameter].[AddHour]
--select @UserCurrencyId=Users.Users.CurrencyId from Users.Users where Users.Users.UserName=@Username

select @CustomerCurrencyId=Customer.Customer.CurrencyId,@Balance=ISNULL(SUM(Customer.Customer.Balance) ,0)
--,@BonusBalance=ISNULL(dbo.FuncCurrencyConverter(SUM(Customer.Customer.Bonus),Customer.Customer.CurrencyId,@UserCurrencyId) ,0)
from Customer.Customer with (nolock)
where Customer.Customer.CustomerId=@CustomerId
GROUP BY Customer.Customer.CurrencyId
 

 select @BonusBalance=ISNULL(SUM(Customer.[Transaction].Amount) ,0)
from Customer.[Transaction] with (nolock) INNER JOIN 
Parameter.TransactionType with (nolock) ON Customer.[Transaction].TransactionTypeId=Parameter.TransactionType.TransactionTypeId
where Customer.[Transaction].CustomerId=@CustomerId 
and Parameter.TransactionType.TransactionTypeId in (35,75) and Parameter.TransactionType.TransactionTypeId<>4
and DATEADD(HOUR,@AddHour,TransactionDate)>=@StartDate and DATEADD(HOUR,@AddHour,TransactionDate)<@EndDate


select @TotalDeposit=ISNULL(SUM(Customer.[Transaction].Amount) ,0)
from Customer.[Transaction] with (nolock) INNER JOIN 
Parameter.TransactionType with (nolock) ON Customer.[Transaction].TransactionTypeId=Parameter.TransactionType.TransactionTypeId
where Customer.[Transaction].CustomerId=@CustomerId 
and Parameter.TransactionType.Direction=1 and Parameter.TransactionType.TransactionTypeId  not in (3,5,42,40,38,8,35,44,51,52,54,63,75) and Parameter.TransactionType.TransactionTypeId<>4
and DATEADD(HOUR,@AddHour,TransactionDate)>=@StartDate and DATEADD(HOUR,@AddHour,TransactionDate)<@EndDate

select @TotalWithdraw=ISNULL(SUM(Customer.[Transaction].Amount)  ,0)
from Customer.[Transaction] with (nolock) 
where Customer.[Transaction].CustomerId=@CustomerId 
and Customer.[Transaction].TransactionTypeId in (2,31,60,65,66,62) and DATEADD(HOUR,@AddHour,TransactionDate)>=@StartDate and DATEADD(HOUR,@AddHour,TransactionDate)<@EndDate

select @TotalBetStake= ISNULL(SUM(Customer.[Transaction].Amount),0)
from Customer.[Transaction]  with (nolock)
where Customer.[Transaction].CustomerId=@CustomerId 
and Customer.[Transaction].TransactionTypeId in (4) and DATEADD(HOUR,@AddHour,TransactionDate)>=@StartDate and DATEADD(HOUR,@AddHour,TransactionDate)<@EndDate



select @TotalBetGain=ISNULL(SUM(Customer.[Transaction].Amount),0)
from Customer.[Transaction]  with (nolock)
where Customer.[Transaction].CustomerId=@CustomerId 
and Customer.[Transaction].TransactionTypeId in (3,63) and DATEADD(HOUR,@AddHour,TransactionDate)>=@StartDate and DATEADD(HOUR,@AddHour,TransactionDate)<@EndDate


select  @TotalCasinoGain=ISNULL(SUM(Customer.[Transaction].Amount),0)
From Customer.[Transaction] with (nolock) INNER JOIN Customer.Customer with (nolock) ON Customer.[Transaction].CustomerId=Customer.Customer.CustomerId
Where Customer.[Transaction].TransactionTypeId  in (38,42,51) and Customer.[Transaction].CustomerId=@CustomerId 
and DATEADD(HOUR,@AddHour,TransactionDate)>=@StartDate and DATEADD(HOUR,@AddHour,TransactionDate)<@EndDate

select  @TotalCasinoStake=ISNULL(SUM(Customer.[Transaction].Amount),0)
From Customer.[Transaction] with (nolock) INNER JOIN Customer.Customer with (nolock) ON Customer.[Transaction].CustomerId=Customer.Customer.CustomerId
Where Customer.[Transaction].TransactionTypeId  in (39,43,50) and Customer.[Transaction].CustomerId=@CustomerId 
and DATEADD(HOUR,@AddHour,TransactionDate)>=@StartDate and DATEADD(HOUR,@AddHour,TransactionDate)<@EndDate

set @TotalCasino=ISNULL(@TotalCasinoStake,0)-ISNULL(@TotalCasinoGain,0)

	set @TotalCasino= @TotalCasino*-1
	set @TotalBetStake=@TotalBetStake*-1
	set @TotalWithdraw=@TotalWithdraw*-1


select @OpenSlipCount=COUNT(Customer.Slip.SlipId)
From Customer.Slip  with (nolock)
Where Customer.Slip.CustomerId=@CustomerId and Customer.Slip.SlipStateId=1
--and DATEADD(HOUR,@AddHour,EvaluateDate)>=@StartDate and DATEADD(HOUR,@AddHour,EvaluateDate)<@EndDate


--select @OpenSlipCount=@OpenSlipCount+ISNULL(COUNT(Archive.Slip.SlipId),0)
--From Archive.Slip with (nolock)
--Where Archive.Slip.CustomerId=@CustomerId and Archive.Slip.SlipStateId=1

select @WonSlipCount=COUNT(Customer.Slip.SlipId)
From Customer.Slip with (nolock)
Where Customer.Slip.CustomerId=@CustomerId and Customer.Slip.SlipStateId in (3,7)
and DATEADD(HOUR,@AddHour,EvaluateDate)>=@StartDate and DATEADD(HOUR,@AddHour,EvaluateDate)<@EndDate

select @WonSlipCount=@WonSlipCount+ISNULL(COUNT(Archive.Slip.SlipId),0)
From Archive.Slip with (nolock)
Where Archive.Slip.CustomerId=@CustomerId and Archive.Slip.SlipStateId in (3,7)
and DATEADD(HOUR,@AddHour,EvaluateDate)>=@StartDate and DATEADD(HOUR,@AddHour,EvaluateDate)<@EndDate

select @WonSlipCount=@WonSlipCount+ISNULL(COUNT(Archive.SlipOld.SlipId),0)
From Archive.SlipOld with (nolock)
Where Archive.SlipOld.CustomerId=@CustomerId and Archive.SlipOld.SlipStateId in (3,7)
and DATEADD(HOUR,@AddHour,EvaluateDate)>=@StartDate and DATEADD(HOUR,@AddHour,EvaluateDate)<@EndDate

select @LostSlipCount=COUNT(Customer.Slip.SlipId)
From Customer.Slip with (nolock)
Where Customer.Slip.CustomerId=@CustomerId and Customer.Slip.SlipStateId=4
and DATEADD(HOUR,@AddHour,EvaluateDate)>=@StartDate and DATEADD(HOUR,@AddHour,EvaluateDate)<@EndDate

select @LostSlipCount=@LostSlipCount+ISNULL(COUNT(Archive.Slip.SlipId),0)
From Archive.Slip with (nolock)
Where Archive.Slip.CustomerId=@CustomerId and Archive.Slip.SlipStateId=4
and DATEADD(HOUR,@AddHour,EvaluateDate)>=@StartDate and DATEADD(HOUR,@AddHour,EvaluateDate)<@EndDate

select @LostSlipCount=@LostSlipCount+ISNULL(COUNT(Archive.SlipOld.SlipId),0)
From Archive.SlipOld with (nolock)
Where Archive.SlipOld.CustomerId=@CustomerId and Archive.SlipOld.SlipStateId=4
and DATEADD(HOUR,@AddHour,EvaluateDate)>=@StartDate and DATEADD(HOUR,@AddHour,EvaluateDate)<@EndDate

select @AllSlipCount=COUNT(Customer.Slip.SlipId)
From Customer.Slip with (nolock)
Where Customer.Slip.CustomerId=@CustomerId 

select @AllSlipCount=@AllSlipCount+ISNULL(COUNT(Archive.Slip.SlipId),0)
From Archive.Slip with (nolock)
Where Archive.Slip.CustomerId=@CustomerId 

select @AllSlipCount=@AllSlipCount+ISNULL(COUNT(Archive.SlipOld.SlipId),0)
From Archive.SlipOld with (nolock)
Where Archive.SlipOld.CustomerId=@CustomerId 


select @TotalDeposit as TotalDeposit,
@TotalWithdraw as TotalWithdraw,
@Balance as Balance,
@TotalBetStake as TotalBetStake,
@TotalBetGain as TotalBetGain,
@OpenSlipCount as OpenSlipCount,
@WonSlipCount as WonSlipCount,
@LostSlipCount as LostSlipCount,
@AllSlipCount as AllSlipCount,
@TotalCasino as TotalCasino,
@BonusBalance as Bonus


END



GO
