USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Report].[ProcCustomerReport]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Report].[ProcCustomerReport] 
 @PageSize  INT,
 @PageNum int,
@Username nvarchar(50),
@where nvarchar(200),
@orderby nvarchar(100)
AS

BEGIN
SET NOCOUNT ON;


declare @UserCurrencyId int



select @UserCurrencyId=Users.Users.CurrencyId from Users.Users where Users.Users.UserName=@Username




declare @sqlcommand nvarchar(max)
declare @sqlcommand1 nvarchar(max)
declare @sqlcommand2 nvarchar(max)
declare @sqlcommand3 nvarchar(max)
declare @sqlcommand4 nvarchar(max)
declare @sqlcommand5 nvarchar(max)
declare @sqlcommand6 nvarchar(max)
declare @sqlcommand7 nvarchar(max)
declare @sqlcommand8 nvarchar(max)
declare @sqlcommand9 nvarchar(max)
declare @sqlcommand10 nvarchar(max)
declare @sqlcommand11 nvarchar(max)
declare @sqlcommand12 nvarchar(max)
declare @sqlcommand13 nvarchar(max)

set @sqlcommand='
declare @TempSummaryBet table (
TotalDeposit money,
TotalWithdraw money,
Balance money,
TotalBetStake money,
TotalBetGain money,
TotalCasinoGain money,
TotalCasinoStake money,
TotalCasino money,
OpenSlipCount int,
WonSlipCount int,
LostSlipCount int,
AllSlipCount int,
CustomerId bigint
)'

set @sqlcommand1='
insert @TempSummaryBet (CustomerId,Balance)
select Top '+cast(@PageSize as nvarchar(10))+' Customer.Customer.CustomerId,ISNULL(SUM(Customer.Customer.Balance),0)
from Customer.Customer with (nolock)
GROUP BY Customer.Customer.CustomerId'

set @sqlcommand2='
insert @TempSummaryBet (CustomerId,TotalDeposit)
select Customer.[Transaction].CustomerId ,ISNULL(SUM(Customer.[Transaction].Amount),0)
from Customer.[Transaction] with (nolock) INNER JOIN @TempSummaryBet as tmp On tmp.CustomerId=Customer.[Transaction].CustomerId INNER JOIN
Parameter.TransactionType ON Customer.[Transaction].TransactionTypeId=Parameter.TransactionType.TransactionTypeId
and Parameter.TransactionType.TransactionTypeId in (1,7,9,11,13,15,17,19,21,23,25,27,29,30,32) and Parameter.TransactionType.TransactionTypeId<>4
GROUP BY Customer.[Transaction].CustomerId'

set @sqlcommand3='
insert @TempSummaryBet (CustomerId,TotalWithdraw)
select Customer.[Transaction].CustomerId ,ISNULL(SUM(Customer.[Transaction].Amount),0)
from Customer.[Transaction]  with (nolock) INNER JOIN @TempSummaryBet as tmp On tmp.CustomerId=Customer.[Transaction].CustomerId  
where  Customer.[Transaction].TransactionTypeId in (2,31)
GROUP BY Customer.[Transaction].CustomerId'

set @sqlcommand4='
insert @TempSummaryBet (CustomerId,TotalBetStake)
select Customer.[Transaction].CustomerId,ISNULL(SUM(Customer.[Transaction].Amount),0)
from Customer.[Transaction]  with (nolock) INNER JOIN @TempSummaryBet as tmp On tmp.CustomerId=Customer.[Transaction].CustomerId  
where Customer.[Transaction].TransactionTypeId in (4)
GROUP BY Customer.[Transaction].CustomerId'

set @sqlcommand5='
insert @TempSummaryBet (CustomerId,TotalBetGain)
select Customer.[Transaction].CustomerId,ISNULL(SUM(Customer.[Transaction].Amount),0)
from Customer.[Transaction]  with (nolock) INNER JOIN @TempSummaryBet as tmp On tmp.CustomerId=Customer.[Transaction].CustomerId  
where  Customer.[Transaction].TransactionTypeId in (3)
GROUP BY Customer.[Transaction].CustomerId'

set @sqlcommand6='
insert @TempSummaryBet (CustomerId,OpenSlipCount)
select Customer.Slip.CustomerId,COUNT(Customer.Slip.SlipId)
From Customer.Slip with (nolock) INNER JOIN @TempSummaryBet as tmp On tmp.CustomerId=Customer.[Slip].CustomerId  
Where  Customer.Slip.SlipStateId=1
GROUP BY Customer.Slip.CustomerId '

set @sqlcommand7='
insert @TempSummaryBet (CustomerId,WonSlipCount)
select Customer.Slip.CustomerId,COUNT(Customer.Slip.SlipId)
From Customer.Slip with (nolock) INNER JOIN @TempSummaryBet as tmp On tmp.CustomerId=Customer.[Slip].CustomerId 
Where  Customer.Slip.SlipStateId=3
GROUP BY Customer.Slip.CustomerId 
UNION ALL
select Archive.Slip.CustomerId,COUNT(Archive.Slip.SlipId)
From Archive.Slip with (nolock) INNER JOIN @TempSummaryBet as tmp On tmp.CustomerId=Archive.[Slip].CustomerId  
Where  Archive.Slip.SlipStateId=3
GROUP BY Archive.Slip.CustomerId '

set @sqlcommand8='
insert @TempSummaryBet (CustomerId,LostSlipCount)
select  Customer.Slip.CustomerId,COUNT(Customer.Slip.SlipId)
From Customer.Slip with (nolock) INNER JOIN @TempSummaryBet as tmp On tmp.CustomerId=Customer.[Slip].CustomerId  
Where  Customer.Slip.SlipStateId=4
GROUP BY Customer.Slip.CustomerId 
UNION ALL
select Archive.Slip.CustomerId,COUNT(Archive.Slip.SlipId)
From Archive.Slip with (nolock) INNER JOIN @TempSummaryBet as tmp On tmp.CustomerId=Archive.[Slip].CustomerId  
Where  Archive.Slip.SlipStateId=4
GROUP BY Archive.Slip.CustomerId '

set @sqlcommand9='
insert @TempSummaryBet (CustomerId,AllSlipCount)
select Customer.Slip.CustomerId,COUNT(Customer.Slip.SlipId)
From Customer.Slip with (nolock) INNER JOIN @TempSummaryBet as tmp On tmp.CustomerId=Customer.[Slip].CustomerId  
GROUP BY Customer.Slip.CustomerId 
UNION ALL
select Archive.Slip.CustomerId,COUNT(Archive.Slip.SlipId)
From Archive.Slip INNER JOIN @TempSummaryBet as tmp On tmp.CustomerId=Archive.[Slip].CustomerId  
GROUP BY Archive.Slip.CustomerId '


set @sqlcommand10='insert @TempSummaryBet (CustomerId,TotalCasinoStake)
select Customer.Customer.CustomerId,ISNULL(SUM(Customer.[Transaction].Amount) ,0)
From Customer.[Transaction] with (nolock) INNER JOIN Customer.Customer with (nolock) ON Customer.[Transaction].CustomerId=Customer.Customer.CustomerId INNER JOIN @TempSummaryBet as tmp On tmp.CustomerId=Customer.[Transaction].CustomerId 
Where Customer.[Transaction].TransactionTypeId  in (39,43) 
GROUP BY Customer.Customer.CustomerId'



set @sqlcommand11='insert @TempSummaryBet (CustomerId,TotalCasinoGain)
select Customer.Customer.CustomerId,ISNULL(SUM(Customer.[Transaction].Amount),0)
From Customer.[Transaction] with (nolock) INNER JOIN Customer.Customer with (nolock) ON Customer.[Transaction].CustomerId=Customer.Customer.CustomerId INNER JOIN @TempSummaryBet as tmp On tmp.CustomerId=Customer.[Transaction].CustomerId 
Where Customer.[Transaction].TransactionTypeId  in (38,42) 
GROUP BY Customer.Customer.CustomerId '

set @sqlcommand12='insert @TempSummaryBet (CustomerId,TotalCasino)
select CustomerId, SUM(TotalCasinoGain)-SUM(ISNULL(TotalCasinoStake,0))
From @TempSummaryBet  
GROUP BY  CustomerId '





--set @sqlcommand10='  select Customer.Customer.CustomerId 
--,Customer.Customer.CustomerName+'' ''+Customer.Customer.CustomerSurname as Customer
--,Customer.Customer.Username
--,Parameter.Branch.BrancName
--,SUM(ISNULL(TotalDeposit,0)) as TotalDeposit
--,SUM(ISNULL(TotalWithdraw,0)) as TotalWithdraw
--,SUM(ISNULL(tmp.Balance,0)) as Balance
--,SUM(ISNULL(TotalBetStake,0)) as TotalBetStake
--,SUM(ISNULL(TotalBetGain,0)) as TotalBetGain
--,SUM(ISNULL(OpenSlipCount,0)) as OpenSlipCount
--,SUM(ISNULL(WonSlipCount,0)) as WonSlipCount
--,SUM(ISNULL(LostSlipCount,0)) as LostSlipCount
--,SUM(ISNULL(AllSlipCount,0)) as AllSlipCount
--,case when SUM(ISNULL(WonSlipCount,0))>0 then cast((SUM(ISNULL(WonSlipCount,0)*100)/SUM(ISNULL(AllSlipCount,0))) as decimal(10,2)) else 0 end as SuccessRatio
--from @TempSummaryBet as tmp INNER JOIN
--Customer.Customer ON Customer.Customer.CustomerId=tmp.CustomerId INNER JOIN
--Parameter.Branch ON Parameter.Branch.BranchId=Customer.Customer.BranchId
--GROUP BY Customer.Customer.CustomerId ,Customer.Customer.CustomerName+'' ''+Customer.Customer.CustomerSurname
--,Customer.Customer.Username
--,Parameter.Branch.BrancName '+
--'Order by '+CAST(@order as nvarchar(100))+''



set @sqlcommand13=   'declare @total int '+
' select @total=COUNT(DISTINCT Customer.Customer.CustomerId ) '+
'from @TempSummaryBet as tmp INNER JOIN
Customer.Customer ON Customer.Customer.CustomerId=tmp.CustomerId INNER JOIN
Parameter.Branch ON Parameter.Branch.BranchId=Customer.Customer.BranchId '+
' where 1=1 and '+ @where + ';'+
' WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY  '+@orderby+ ') AS RowNum,  '+
'  Customer.Customer.CustomerId 
,Customer.Customer.CustomerName+'' ''+Customer.Customer.CustomerSurname as Customer
,Customer.Customer.Username
,Parameter.Branch.BrancName
,SUM(ISNULL(TotalDeposit,0)) as TotalDeposit
,SUM(ISNULL(TotalWithdraw,0)) as TotalWithdraw
,SUM(ISNULL(tmp.Balance,0)) as Balance
,SUM(ISNULL(TotalBetStake,0)) as TotalBetStake
,SUM(ISNULL(TotalBetGain,0)) as TotalBetGain
,SUM(ISNULL(OpenSlipCount,0)) as OpenSlipCount
,SUM(ISNULL(WonSlipCount,0)) as WonSlipCount
,SUM(ISNULL(LostSlipCount,0)) as LostSlipCount
,SUM(ISNULL(AllSlipCount,0)) as AllSlipCount
,case when SUM(ISNULL(WonSlipCount,0))>0 then cast((SUM(ISNULL(WonSlipCount,0)*100)/SUM(ISNULL(AllSlipCount,0))) as decimal(10,2)) else 0 end as SuccessRatio '+
',SUM(ISNULL(TotalCasino,0)) as TotalCasino '+
'from @TempSummaryBet as tmp INNER JOIN
Customer.Customer ON Customer.Customer.CustomerId=tmp.CustomerId INNER JOIN
Parameter.Branch ON Parameter.Branch.BranchId=Customer.Customer.BranchId '+
'where 1=1 and '+ @where +
' GROUP BY Customer.Customer.CustomerId ,Customer.Customer.CustomerName+'' ''+Customer.Customer.CustomerSurname
,Customer.Customer.Username
,Parameter.Branch.BrancName '+
'  )  '+
'			 SELECT *,@total as totalrow '+
'  FROM OrdersRN'+
' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(20))+')*('+cast(@PageSize  as nvarchar(10))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '





execute (@sqlcommand+' '+@sqlcommand1+' '+@sqlcommand2+' '+@sqlcommand3+' '+@sqlcommand4+' '+@sqlcommand5+' '+@sqlcommand6+' '+@sqlcommand7+' '+@sqlcommand8+' '+@sqlcommand9+' '+@sqlcommand10+' '+@sqlcommand11+' '+@sqlcommand12+' '+@sqlcommand13)




END





GO
