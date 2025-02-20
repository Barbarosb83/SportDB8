USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcSummaryBranchBettingMobil]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcSummaryBranchBettingMobil] 
 @SourceId int,
 @PageSize  INT,
 @PageNum int,
@Username nvarchar(50),
@where nvarchar(1000),
@orderby nvarchar(100),
@StartDate nvarchar(20),
@EndDate nvarchar(20)
AS
BEGIN
SET NOCOUNT ON;

 
declare @sqlcommandCustomer nvarchar(max)='' 
declare @sqlcommandBranch nvarchar(max)=''
declare @sqlcommand nvarchar(max)=''
declare @sqlcommand1 nvarchar(max)=''
declare @sqlcommand2 nvarchar(max)=''	
declare @sqlcommand2T nvarchar(max)=''
declare @sqlcommand22 nvarchar(max)=''
declare @sqlcommand22T nvarchar(max)=''
declare @sqlcommand221 nvarchar(max)=''
declare @sqlcommand221T nvarchar(max)=''
declare @sqlcommand222 nvarchar(max)=''
declare @sqlcommand222T nvarchar(max)=''
declare @sqlcommand2222 nvarchar(max)=''
declare @sqlcommand2222T nvarchar(max)=''
declare @sqlcommand22222 nvarchar(max)=''
declare @sqlcommand22222T nvarchar(max)=''
declare @sqlcommand3 nvarchar(max)=''
declare @sqlcommand4 nvarchar(max)=''
declare @sqlcommand5 nvarchar(max)=''
declare @sqlcommand6 nvarchar(max)=''
declare @sqlcommand7 nvarchar(max)=''
declare @sqlcommand8 nvarchar(max)=''
declare @sqlcommand88 nvarchar(max)=''
declare @sqlcommand9 nvarchar(max)=''
declare @sqlcommand10 nvarchar(max)=''




declare @UserCurrencyId int
declare @BranchId int
declare @where2 nvarchar(max)=' 1=1'
declare @SystemCurrencyId int
select top 1 @SystemCurrencyId=SystemCurrencyId from General.Setting 
select @BranchId=Users.Users.UnitCode, @UserCurrencyId=Users.Users.CurrencyId from Users.Users where Users.Users.UserName=@Username
declare @whereTerminal  nvarchar(max)=' 1=1'
	declare @where3 nvarchar(250)=''

if(@orderby='ReportId desc')
	set @orderby=REPLACE(@orderby,'ReportId','ReportDate')
else if(@orderby='SlipId asc')
	set @orderby=REPLACE(@orderby,'ReportId','ReportDate')

		set @orderby='BranchName desc'

if(@BranchId<>1)
	begin

	set @where2=' [Parameter].[Branch].BranchId='+cast(@BranchId as nvarchar(7))

	end



 
 if(@SourceId=0) -- Total Sportbook
 begin
 exec Report.ProcSummarySportBettingFill1





	
  if(@BranchId<>1)
	begin
	if (@BranchId<>31970)
		begin
			set @where2=' PB.BranchId in (select BranchId from Parameter.Branch with (nolock)  where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId in (select BranchId from Parameter.Branch with (nolock) where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ') ))) or PB.ParentBranchId in (select BranchId from Parameter.Branch with (nolock)  where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId in (select BranchId from Parameter.Branch with (nolock) where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ') )))'  
			set @whereTerminal='  Customer.BranchId in (select BranchId from Parameter.Branch with (nolock) where IsTerminal=1 and (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId in (select BranchId from Parameter.Branch with (nolock)   where IsTerminal=0 and (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ') )))'  
		end
	else
		begin
			set @where2=' (PB.BranchId in (select BranchId from Parameter.Branch with (nolock)  where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId in (select BranchId from Parameter.Branch with (nolock) where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ') ))) or PB.ParentBranchId in (select BranchId from Parameter.Branch with (nolock)  where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId in (select BranchId from Parameter.Branch with (nolock) where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ') ))))'  
			set @whereTerminal='  Customer.BranchId in (select BranchId from Parameter.Branch with (nolock) where IsTerminal=1 and (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId in (select BranchId from Parameter.Branch with (nolock)   where IsTerminal=0 and (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ') )))'  
		end
	end
else
	set @whereTerminal='  Customer.BranchId in (select BranchId from Parameter.Branch with (nolock) where IsTerminal=1) '


	if(@SourceId=3)
		set @SourceId=4

	 if(@SourceId=0)
	set @where3=@where3+' and SourceId in (select SourceId from Parameter.Source) '
else if(@SourceId=1)
	set @where3=@where3+' and SourceId in (1,2) '
else
	set @where3=@where3+' and SourceId='+cast(@SourceId as nvarchar(7)) 


if(@BranchId<>1)
begin
	
	set @sqlcommandBranch=' declare @TempBranchtable table (BranchId bigint) '+
' insert @TempBranchtable select BranchId from Parameter.Branch with (nolock) where ( BranchId in (select BranchId from Parameter.Branch with (nolock)  where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId in (select BranchId from Parameter.Branch with (nolock) where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ') ))) or ParentBranchId in (select BranchId from Parameter.Branch with (nolock)  where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId in (select BranchId from Parameter.Branch with (nolock) where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ') ))) ) '




set @where2= ' ( PB.BranchId in (select BranchId from @TempBranchtable) or PB.ParentBranchId in (select BranchId from @TempBranchtable)) '
 


 set @sqlcommand2=' declare @TempSummaryBet table (ParentBranch nvarchar(50),SlipCount int,SlipAmount money,OpenSlipCount int,OpenSlipAmount money,OpenSlipPayOut money,WonSlipCount int,WonSlipAmount money,WonSlipPayOut money,LostSlipCount int,LostSlipAmount money,CancelSlipCount int,CancelSlipAmount money,TurnOver money,PartnerTurnOver money,BranchName nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS,TaxCount int,TaxAmount money,BranchTaxAmount money,PayOutCount int,PayOutAmount money,SourceId int,Cashout money,Bonus money ,OnlineDeposit money,OnlineWithDraw money) '+
  'insert @TempSummaryBet (ParentBranch,SlipCount,SlipAmount,BranchName,SourceId) '+
  'select (select P.BrancName from Parameter.Branch  as P  where P.BranchId=PB.ParentBranchId), COUNT(CustomerSlip.SlipCount)
,SUM( CustomerSlip.[OrgSlipAmount])
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,CustomerSlip.SourceId
From Report.SummarySportBetting as CustomerSlip  inner join Customer.Customer with (nolock)  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch  as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where CustomerSlip.Isview=1 and
 cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,CustomerSlip.SourceId,PB.IsTerminal '

  
 

  SET @sqlcommand2 +=   ' insert @TempSummaryBet (ParentBranch,OpenSlipCount,OpenSlipAmount,BranchName,SourceId) '+
        'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId), COUNT(Customer.Slip.SlipId)
,SUM( Customer.Slip.Amount)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,Customer.Slip.SourceId
From Customer.Slip with (nolock) inner join Customer.Customer with (nolock) on Customer.Slip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where Customer.Slip.SlipStatu not in (2,4)  and Customer.Slip.SlipStateId=1  and Customer.Slip.SlipTypeId<3
and cast( DATEADD(HOUR,1,Customer.Slip.CreateDate) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( DATEADD(HOUR,1,Customer.Slip.CreateDate) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.Slip.SourceId,PB.IsTerminal '

  SET @sqlcommand2 +=   ' insert @TempSummaryBet (ParentBranch,OpenSlipCount,OpenSlipAmount,BranchName,SourceId) '+
        'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId), COUNT(Customer.SlipSystem.SystemSlipId)
,SUM( Customer.SlipSystem.Amount)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,Customer.SlipSystem.SourceId
From Customer.SlipSystem with (nolock) inner join Customer.Customer with (nolock) on Customer.SlipSystem.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where   Customer.SlipSystem.SlipStateId=1  and Customer.SlipSystem.NewSlipTypeId in (4,5)
and cast( DATEADD(HOUR,1,Customer.SlipSystem.CreateDate) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( DATEADD(HOUR,1,Customer.SlipSystem.CreateDate) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.SlipSystem.SourceId,PB.IsTerminal '

  
   SET @sqlcommand22 +=   ' insert @TempSummaryBet (ParentBranch,WonSlipCount ,WonSlipAmount ,WonSlipPayOut,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch as P  where P.BranchId=PB.ParentBranchId), SUM(CustomerSlip.WonSlipCount)
,SUM(CustomerSlip.[OrgWonSlipAmount])
,SUM([OrgWonSlipPayOut])
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,CustomerSlip.SourceId
From Report.SummarySportBetting as CustomerSlip with (nolock)  inner join Customer.Customer with (nolock)  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
   Parameter.Branch  as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where   CustomerSlip.Isview=1 and  cast( CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,CustomerSlip.SourceId,PB.IsTerminal '

    SET @sqlcommand22 +=   ' insert @TempSummaryBet (ParentBranch,Bonus,BranchName,SourceId ) '+
    'select (select P.BrancName from Parameter.Branch as P  where P.BranchId=PB.ParentBranchId), SUM(CustomerSlip.Amount)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end,1
From Customer.[Transaction] as CustomerSlip with (nolock)  inner join Customer.Customer with (nolock)  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
   Parameter.Branch  as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where Customer.Customer.IsTerminalCustomer=0 and Customer.Customer.IsBranchCustomer=0 and CustomerSlip.TransactionTypeId=35 and  cast( CustomerSlip.TransactionDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( CustomerSlip.TransactionDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal '

 

    SET @sqlcommand221 +=   ' insert @TempSummaryBet (ParentBranch,Cashout,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch  as P  where P.BranchId=PB.ParentBranchId)
,SUM(CustomerSlip.[OrgCashoutSlipAmount])
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,CustomerSlip.SourceId
From Report.SummarySportBetting as CustomerSlip  inner join Customer.Customer  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,CustomerSlip.SourceId,PB.IsTerminal '

 
  SET @sqlcommand222 +=   ' insert @TempSummaryBet (ParentBranch,LostSlipCount ,LostSlipAmount,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch  as P  where P.BranchId=PB.ParentBranchId), SUM(CustomerSlip.LostSlipCount)
,SUM(CustomerSlip.[OrgLostSlipAmount])
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,CustomerSlip.SourceId
From Report.SummarySportBetting as CustomerSlip  inner join Customer.Customer  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch  as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,CustomerSlip.SourceId,PB.IsTerminal '

 

 SET @sqlcommand222 +=   ' insert @TempSummaryBet (ParentBranch,CancelSlipCount ,CancelSlipAmount,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch  as P  where P.BranchId=PB.ParentBranchId), COUNT(CustomerSlip.CancelSlipCount)
,SUM(CustomerSlip.OrgCancelSlipAmount)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,CustomerSlip.SourceId
From Report.SummarySportBetting as CustomerSlip  inner join Customer.Customer  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch  as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,CustomerSlip.SourceId,PB.IsTerminal '

 
 

  SET @sqlcommand2222 +=   ' insert @TempSummaryBet (ParentBranch,TaxCount ,TaxAmount,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch  as P  where P.BranchId=PB.ParentBranchId), COUNT(CustomerSlip.SlipCount)
,(SUM( CustomerSlip.[OrgSlipAmount])*5)/100
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,CustomerSlip.SourceId
From Report.SummarySportBetting as CustomerSlip  inner join Customer.Customer with (nolock)  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch  as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where   CustomerSlip.Isview=1 and
 cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,CustomerSlip.SourceId,PB.IsTerminal '
 
   

   SET @sqlcommand2222 +=   ' insert @TempSummaryBet (ParentBranch, BranchTaxAmount,BranchName,SourceId) '+
    '	select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId)
	,case when Customer.Slip.SlipStateId in (3,5,6) and Customer.slip.TotalOddValue>1 then   SUM(Customer.Slip.TotalOddValue * Customer.Slip.Amount) else case when (Customer.Slip.SlipStateId in (2) or (Customer.Slip.SlipStateId=3 and Customer.slip.TotalOddValue=1) ) 	then   SUM(Customer.Slip.Amount) +ISNULL((Select SUM(Customer.Tax.TaxAmount) from Customer.Tax with (nolock)  where SlipId=Customer.Slip.SlipId),0) else 0 end end As Total
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,Customer.Slip.SourceId 
from Customer.Slip with (nolock) INNER JOIN Customer.Customer
ON Customer.Customer.CustomerId=Customer.Slip.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
where (IsPayOut=0 or IsPayOut is null) and SlipStateId in (2,3,5,6)  
 and ( IsBranchCustomer=1) and Customer.Slip.SlipTypeId<3 and cast( DATEADD(HOUR,1,Customer.Slip.EvaluateDate ) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( DATEADD(HOUR,1,Customer.Slip.EvaluateDate ) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.Slip.SourceId,Customer.Slip.SlipStateId,Customer.Slip.SlipId,Customer.slip.TotalOddValue,PB.IsTerminal '

  SET @sqlcommand2222 +=' insert @TempSummaryBet (ParentBranch, BranchTaxAmount,BranchName,SourceId) '+
    '	select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId)
	,case when Archive.Slip.SlipStateId in (3,5,6) and Archive.slip.TotalOddValue>1 	then   SUM(Archive.Slip.TotalOddValue * Archive.Slip.Amount) else case when (Archive.Slip.SlipStateId in (2) or (Archive.Slip.SlipStateId=3 and Archive.slip.TotalOddValue=1) ) 	then   SUM(Archive.Slip.Amount) +ISNULL((Select SUM(Customer.Tax.TaxAmount) from Customer.Tax with (nolock)  where SlipId=Archive.Slip.SlipId),0) else 0 end end As Total
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,Archive.Slip.SourceId 
from Archive.Slip with (nolock) INNER JOIN Customer.Customer
ON Customer.Customer.CustomerId=Archive.Slip.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
where (IsPayOut=0 or IsPayOut is null) and SlipStateId in (2,3,5,6)  
 and ( IsBranchCustomer=1) and Archive.Slip.SlipTypeId<3 and cast( DATEADD(HOUR,1,Archive.Slip.EvaluateDate) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( DATEADD(HOUR,1,Archive.Slip.EvaluateDate) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Archive.Slip.SourceId,Archive.Slip.SlipStateId,Archive.Slip.SlipId,Archive.slip.TotalOddValue,PB.IsTerminal '


  SET @sqlcommand2222 +=   ' insert @TempSummaryBet (ParentBranch, BranchTaxAmount,BranchName,SourceId) '+
    '	select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId)
	,cast(ISNULL((Select SUM(Customer.Slip.TotalOddValue * Customer.Slip.Amount)
 from Customer.Slip where Customer.Slip.SlipStateId in (3,6) and Customer.Slip.SlipTypeId=3
  and Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) ),0) as money) 
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,Customer.SlipSystem.SourceId 
from Customer.SlipSystem INNER JOIN Customer.Customer
ON Customer.Customer.CustomerId=Customer.SlipSystem.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
where (IsPayOut=0 or IsPayOut is null) and SlipStateId in (2,3,5,6)  
 and ( IsBranchCustomer=1)  and cast( DATEADD(HOUR,1,Customer.SlipSystem.EvaluateDate) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( DATEADD(HOUR,1,Customer.SlipSystem.EvaluateDate) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.SlipSystem.SourceId,Customer.SlipSystem.SystemSlipId,PB.IsTerminal '

   SET @sqlcommand2222 +=   ' insert @TempSummaryBet (ParentBranch, BranchTaxAmount,BranchName,SourceId) '+
    '	select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId)
	,cast(ISNULL((Select SUM(Archive.Slip.TotalOddValue * Archive.Slip.Amount)
 from Archive.Slip where Archive.Slip.SlipStateId in (3,6) and Archive.Slip.SlipTypeId=3
  and Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) ),0) as money) 
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,Customer.SlipSystem.SourceId 
from Customer.SlipSystem INNER JOIN Customer.Customer
ON Customer.Customer.CustomerId=Customer.SlipSystem.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
where (IsPayOut=0 or IsPayOut is null) and SlipStateId in (2,3,5,6)  
 and ( IsBranchCustomer=1)  and cast( DATEADD(HOUR,1,Customer.SlipSystem.EvaluateDate) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( DATEADD(HOUR,1,Customer.SlipSystem.EvaluateDate) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.SlipSystem.SourceId,Customer.SlipSystem.SystemSlipId,PB.IsTerminal '



 


  SET @sqlcommand22222 +=   ' insert @TempSummaryBet (ParentBranch,PayOutCount ,PayOutAmount,BranchName,SourceId) '+
  'select (select P.BrancName from Parameter.Branch  as P  where P.BranchId=PB.ParentBranchId), COUNT(CustomerSlip.PayOutCount)
,SUM(CustomerSlip.[OrgPayOutAmount])
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,CustomerSlip.SourceId
From Report.SummarySportBetting as CustomerSlip  inner join Customer.Customer  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch  as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,CustomerSlip.SourceId,PB.IsTerminal '

 SET @sqlcommand22222 +=   ' insert @TempSummaryBet (ParentBranch,OnlineDeposit ,OnlineWithDraw,BranchName,SourceId) '+
  'select (select P.BrancName from Parameter.Branch  as P  where P.BranchId=PB.ParentBranchId) 
,SUM(CustomerSlip.OnlineDeposit)
,SUM(CustomerSlip.OnlineWithDraw)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,1
From Report.SummarySportBetting as CustomerSlip  inner join Customer.Customer  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch  as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal '
 
 --set @sqlcommand9 +=' insert @TempSummaryBet (ParentBranch,BranchName ,SlipAmount,WonSlipPayOut,CancelSlipAmount,PayOutAmount,Turnover,PartnerTurnOver,OpenSlipAmount,TaxAmount,BranchTaxAmount,SourceId,Cashout)
 -- SELECT ''Total''
 -- ,''''
 -- ,SUM(SlipAmount) AS TurnOver
 --,ISNULL(sum(WonSlipPayOut),0) as CustomerWining
 --,ISNULL(SUM(CancelSlipAmount),0) as CancelBet
 --,ISNULL(SUM(PayOutAmount),0) 
 -- ,ISNULL(SUM(SlipAmount),0)-ISNULL(sum(WonSlipPayOut),0)-ISNULL(sum(Cashout),0)-ISNULL(SUM(CancelSlipAmount),0) as Profit
 -- ,0 as PartnerProfit
  
 --,ISNULL(SUM(OpenSlipAmount),0) as Unsettled
 --,ISNULL(SUM(TaxAmount),0) as Tax
 --,0 as BranchTaxAmount
 --,SourceId
 --,ISNULL(SUM(Cashout),0)
 --  FROM @TempSummaryBet GROUP BY SourceId    HAVING SUM(SlipAmount) is not null '




	set @sqlcommand9+=' declare @TempSummaryBet3 table (ParentBranch nvarchar(50),SlipCount int,SlipAmount money,OpenSlipCount int,OpenSlipAmount money,OpenSlipPayOut money,WonSlipCount int,WonSlipAmount money,WonSlipPayOut money,LostSlipCount int,LostSlipAmount money,CancelSlipCount int,CancelSlipAmount money,TurnOver money,PartnerTurnOver money,BranchName nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS,TaxCount int,TaxAmount money,BranchTaxAmount money,PayOutCount int,PayOutAmount money,Cashout money,Bonus money,OnlineDeposit money,OnlineWithDraw money) '+
  ' insert @TempSummaryBet3 '+
  '   SELECT tp2.ParentBranch,SUM(ISNULL(SlipCount,0))
,SUM(ISNULL(SlipAmount,0)),SUM(ISNULL(OpenSlipCount,0)),SUM(ISNULL(OpenSlipAmount,0)),SUM(ISNULL(OpenSlipPayOut,0)),SUM(ISNULL(WonSlipCount,0)) ,SUM(ISNULL(WonSlipAmount,0))
,SUM(ISNULL(WonSlipPayOut,0)),SUM(ISNULL(LostSlipCount,0)),SUM(ISNULL(LostSlipAmount,0)),SUM(ISNULL(CancelSlipCount,0)),SUM(ISNULL(CancelSlipAmount,0)),SUM(ISNULL(SlipAmount,0))-(SUM(ISNULL(WonSlipPayOut,0))+SUM(ISNULL(Cashout,0))+ISNULL(SUM(CancelSlipAmount),0)) as TurnOver
,(SUM(ISNULL(WonSlipPayOut,0))+SUM(ISNULL(Cashout,0))+ISNULL(SUM(CancelSlipAmount),0))
,tp2.BranchName,SUM(ISNULL(TaxCount,0)),SUM(ISNULL(TaxAmount,0)),SUM(ISNULL(BranchTaxAmount,0)),SUM(ISNULL(PayOutCount,0)),SUM(ISNULL(WonSlipPayOut,0)),SUM(ISNULL(Cashout,0)),SUM(ISNULL(Bonus,0))
,SUM(ISNULL(OnlineDeposit,0)),SUM(ISNULL(OnlineWithDraw,0))
     FROM @TempSummaryBet as tp2 where 1=1  '+@where3 +
	' GROUP BY BranchName,ParentBranch  '

	set @sqlcommand9+=
  ' insert @TempSummaryBet3 '+
  '   SELECT ''Total'',SUM(ISNULL(SlipCount,0))
,SUM(ISNULL(SlipAmount,0)),SUM(ISNULL(OpenSlipCount,0)),SUM(ISNULL(OpenSlipAmount,0)),SUM(ISNULL(OpenSlipPayOut,0)),SUM(ISNULL(WonSlipCount,0)) ,SUM(ISNULL(WonSlipAmount,0))
,SUM(ISNULL(WonSlipPayOut,0)),SUM(ISNULL(LostSlipCount,0)),SUM(ISNULL(LostSlipAmount,0)),SUM(ISNULL(CancelSlipCount,0)),SUM(ISNULL(CancelSlipAmount,0)),SUM(ISNULL(SlipAmount,0))-(SUM(ISNULL(WonSlipPayOut,0))+SUM(ISNULL(Cashout,0))+ISNULL(SUM(CancelSlipAmount),0)) as TurnOver
,(SUM(ISNULL(WonSlipPayOut,0))+SUM(ISNULL(Cashout,0))+ISNULL(SUM(CancelSlipAmount),0))
,''Total'',SUM(ISNULL(TaxCount,0)),SUM(ISNULL(TaxAmount,0)),SUM(ISNULL(BranchTaxAmount,0)),SUM(ISNULL(PayOutCount,0)),SUM(ISNULL(WonSlipPayOut,0)),SUM(ISNULL(Cashout,0)),SUM(ISNULL(Bonus,0))
,SUM(ISNULL(OnlineDeposit,0)),SUM(ISNULL(OnlineWithDraw,0))
     FROM @TempSummaryBet as tp2 where 1=1  '+@where3  

	
  set @sqlcommand=' declare @total int '+
'select @total=COUNT(SlipCount)  '+
'FROM        @TempSummaryBet3 as tmp LEFT OUTER JOIN Parameter.Branch as PB On tmp.BranchName=PB.BrancName
WHERE    1=1 ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
'	 ParentBranch ,ISNULL([SlipCount],0)  as [SlipCount]
       ,ISNULL(SlipAmount,0) as [SlipAmount]
      ,ISNULL([OpenSlipCount],0)  as [OpenSlipCount]
      ,ISNULL([OpenSlipAmount],0)  as [OpenSlipAmount]
      ,ISNULL([OpenSlipPayOut],0)  as [OpenSlipPayOut]
      ,ISNULL([WonSlipCount],0)  as [WonSlipCount]
      ,ISNULL([WonSlipAmount],0) as [WonSlipAmount]
      ,ISNULL([WonSlipPayOut],0)  as [WonSlipPayOut]
      ,ISNULL([LostSlipCount],0)  as [LostSlipCount]
      ,ISNULL([LostSlipAmount],0)  as [LostSlipAmount]
      ,ISNULL([CancelSlipCount],0)  as [CancelSlipCount]
      ,ISNULL([CancelSlipAmount],0) as [CancelSlipAmount]
      ,cast(0 as money) as SumTurnOver
	  ,BranchName
	  ,(ISNULL(PartnerTurnOver,0)) as BranchTurnOver
	  ,ISNULL(TurnOver,0) as TurnOver
	  ,ISNULL([TaxCount],0)  as [TaxCount]
      ,ISNULL(ISNULL([TaxAmount],0),0)  as [TaxAmount]
	  ,ISNULL(ISNULL([BranchTaxAmount],0),0)  as [BranchTaxAmount]
	  ,ISNULL(ISNULL([TaxAmount],0),0)+ISNULL(ISNULL([BranchTaxAmount],0),0) as SumTaxAmount
	  ,ISNULL([PayOutCount],0)  as [PayOutCount]
      ,ISNULL(ISNULL([PayOutAmount],0),0)  as PayOutAmount,ISNULL(ISNULL([Cashout],0),0)  as Cashout,ISNULL(ISNULL([Bonus],0),0)  as Bonus,ISNULL(ISNULL([OnlineDeposit],0),0)  as OnlineDeposit,ISNULL(ISNULL([OnlineWithDraw],0),0)  as OnlineWithDraw '+
'FROM         @TempSummaryBet3 as tmp LEFT OUTER JOIN Parameter.Branch as PB   On tmp.BranchName=PB.BrancName
WHERE  1=1 '+
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '

 end
 else
	begin
		
	
 set @sqlcommand2=' declare @TempSummaryBet table (ParentBranch nvarchar(50),SlipCount int,SlipAmount money,OpenSlipCount int,OpenSlipAmount money,OpenSlipPayOut money,WonSlipCount int,WonSlipAmount money,WonSlipPayOut money,LostSlipCount int,LostSlipAmount money,CancelSlipCount int,CancelSlipAmount money,TurnOver money,PartnerTurnOver money,BranchName nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS,TaxCount int,TaxAmount money,BranchTaxAmount money,PayOutCount int,PayOutAmount money,SourceId int,Cashout money,Bonus money,OnlineDeposit money,OnlineWithDraw money) '+
  'insert @TempSummaryBet (ParentBranch,SlipCount,SlipAmount,BranchName,SourceId) '+
  'select (select P.BrancName from Parameter.Branch  as P  where P.BranchId=PB.ParentBranchId), COUNT(CustomerSlip.SlipCount)
,SUM( CustomerSlip.SlipAmount )
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,CustomerSlip.SourceId
From Report.SummarySportBetting as CustomerSlip  inner join Customer.Customer  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch  as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where   CustomerSlip.Isview=1 and
 cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,CustomerSlip.SourceId,PB.IsTerminal '

  
 

  SET @sqlcommand2 +=   ' insert @TempSummaryBet (ParentBranch,OpenSlipCount,OpenSlipAmount,BranchName,SourceId) '+
        'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId), COUNT(Customer.Slip.SlipId)
,SUM(dbo.FuncCurrencyConverter(Customer.Slip.Amount,Customer.Slip.CurrencyId,'+cast(@UserCurrencyId as nvarchar(10))+'))
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,Customer.Slip.SourceId
From Customer.Slip with (nolock) inner join Customer.Customer with (nolock) on Customer.Slip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where Customer.Slip.SlipStatu not in (2,4)  and Customer.Slip.SlipStateId=1 and Customer.Slip.SlipTypeId<3
and cast( DATEADD(HOUR,1,Customer.Slip.CreateDate) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( DATEADD(HOUR,1,Customer.Slip.CreateDate) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.Slip.SourceId,PB.IsTerminal '


   SET @sqlcommand2 +=   ' insert @TempSummaryBet (ParentBranch,OpenSlipCount,OpenSlipAmount,BranchName,SourceId) '+
        'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId), COUNT(Customer.SlipSystem.SystemSlipId)
,SUM( Customer.SlipSystem.Amount)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,Customer.SlipSystem.SourceId
From Customer.SlipSystem with (nolock) inner join Customer.Customer with (nolock) on Customer.SlipSystem.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where   Customer.SlipSystem.SlipStateId=1  and Customer.SlipSystem.NewSlipTypeId in (4,5)
and cast( DATEADD(HOUR,1,Customer.SlipSystem.CreateDate) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( DATEADD(HOUR,1,Customer.SlipSystem.CreateDate) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.SlipSystem.SourceId,PB.IsTerminal '
  
   SET @sqlcommand22 +=   ' insert @TempSummaryBet (ParentBranch,WonSlipCount ,WonSlipAmount ,WonSlipPayOut,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch as P  where P.BranchId=PB.ParentBranchId), SUM(CustomerSlip.WonSlipCount)
,SUM( CustomerSlip.WonSlipAmount)
,SUM(WonSlipPayOut)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,CustomerSlip.SourceId
From Report.SummarySportBetting as CustomerSlip  inner join Customer.Customer  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
   Parameter.Branch  as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and  cast( CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,CustomerSlip.SourceId,PB.IsTerminal '

 

     SET @sqlcommand22 +=   ' insert @TempSummaryBet (ParentBranch,Bonus,BranchName,SourceId ) '+
    'select (select P.BrancName from Parameter.Branch as P  where P.BranchId=PB.ParentBranchId), SUM(CustomerSlip.Amount)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end,1
From Customer.[Transaction] as CustomerSlip with (nolock)  inner join Customer.Customer with (nolock)  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
   Parameter.Branch  as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where Customer.Customer.IsTerminalCustomer=0 and Customer.Customer.IsBranchCustomer=0 and CustomerSlip.TransactionTypeId=35 and  cast( CustomerSlip.TransactionDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( CustomerSlip.TransactionDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal '

    SET @sqlcommand221 +=   ' insert @TempSummaryBet (ParentBranch,Cashout,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch  as P  where P.BranchId=PB.ParentBranchId)
,SUM(CustomerSlip.CashoutSlipAmount)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,CustomerSlip.SourceId
From Report.SummarySportBetting as CustomerSlip  inner join Customer.Customer  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,CustomerSlip.SourceId,PB.IsTerminal '

 
  SET @sqlcommand222 +=   ' insert @TempSummaryBet (ParentBranch,LostSlipCount ,LostSlipAmount,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch  as P  where P.BranchId=PB.ParentBranchId), SUM(CustomerSlip.LostSlipCount)
,SUM(CustomerSlip.LostSlipAmount)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,CustomerSlip.SourceId
From Report.SummarySportBetting as CustomerSlip  inner join Customer.Customer  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch  as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,CustomerSlip.SourceId,PB.IsTerminal '

 

 SET @sqlcommand222 +=   ' insert @TempSummaryBet (ParentBranch,CancelSlipCount ,CancelSlipAmount,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch  as P  where P.BranchId=PB.ParentBranchId), COUNT(CustomerSlip.CancelSlipCount)
,SUM(CustomerSlip.CancelSlipAmount)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,CustomerSlip.SourceId
From Report.SummarySportBetting as CustomerSlip  inner join Customer.Customer  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch  as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,CustomerSlip.SourceId,PB.IsTerminal '

 
 

  SET @sqlcommand2222 +=   ' insert @TempSummaryBet (ParentBranch,TaxCount ,TaxAmount,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch  as P  where P.BranchId=PB.ParentBranchId), COUNT(CustomerSlip.TaxCount)
,SUM(CustomerSlip.Tax)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,CustomerSlip.SourceId
From Report.SummarySportBetting as CustomerSlip  inner join Customer.Customer  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch  as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,CustomerSlip.SourceId,PB.IsTerminal '
 
 SET @sqlcommand2222 +=   ' insert @TempSummaryBet (ParentBranch, BranchTaxAmount,BranchName,SourceId) '+
    '	select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId)
	
	,case when Customer.Slip.SlipStateId in (3,5,6) and Customer.slip.TotalOddValue>1 then   SUM(dbo.FuncCurrencyConverter(ISNULL(Amount,0)*TotalOddValue,Customer.Slip.CurrencyId,'+cast(@UserCurrencyId as nvarchar(10))+')) else case when (Customer.Slip.SlipStateId in (2) or (Customer.Slip.SlipStateId=3 and Customer.slip.TotalOddValue=1) ) 	then   dbo.FuncCurrencyConverter(SUM(Customer.Slip.Amount) +ISNULL((Select SUM(Customer.Tax.TaxAmount) from Customer.Tax with (nolock)  where SlipId=Customer.Slip.SlipId),0),Customer.Slip.CurrencyId,'+cast(@UserCurrencyId as nvarchar(10))+') else 0 end end As Total
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,Customer.Slip.SourceId 
from Customer.Slip with (nolock) INNER JOIN Customer.Customer
ON Customer.Customer.CustomerId=Customer.Slip.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
where (IsPayOut=0 or IsPayOut is null) and SlipStateId in (2,3,5,6)  
 and  Customer.Slip.SlipTypeId<3 and cast( DATEADD(HOUR,1,Customer.Slip.EvaluateDate ) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( DATEADD(HOUR,1,Customer.Slip.EvaluateDate ) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.Slip.SourceId,Customer.Slip.SlipStateId,Customer.Slip.SlipId,Customer.slip.TotalOddValue,Customer.Slip.CurrencyId,PB.IsTerminal '

  SET @sqlcommand2222 +=' insert @TempSummaryBet (ParentBranch, BranchTaxAmount,BranchName,SourceId) '+
    '	select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId)
	,case when Archive.Slip.SlipStateId in (3,5,6) and Archive.slip.TotalOddValue>1 then   SUM(dbo.FuncCurrencyConverter(ISNULL(Amount,0)*TotalOddValue,Archive.Slip.CurrencyId,'+cast(@UserCurrencyId as nvarchar(10))+')) else case when (Archive.Slip.SlipStateId in (2) or (Archive.Slip.SlipStateId=3 and Archive.slip.TotalOddValue=1) ) 	then   dbo.FuncCurrencyConverter(SUM(Archive.Slip.Amount) +ISNULL((Select SUM(Customer.Tax.TaxAmount) from Customer.Tax with (nolock)  where SlipId=Archive.Slip.SlipId),0),Archive.Slip.CurrencyId,'+cast(@UserCurrencyId as nvarchar(10))+') else 0 end end As Total
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,Archive.Slip.SourceId 
from Archive.Slip with (nolock) INNER JOIN Customer.Customer
ON Customer.Customer.CustomerId=Archive.Slip.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
where (IsPayOut=0 or IsPayOut is null) and SlipStateId in (2,3,5,6)  
 and ( IsBranchCustomer=1) and Archive.Slip.SlipTypeId<3 and cast( DATEADD(HOUR,1,Archive.Slip.EvaluateDate) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( DATEADD(HOUR,1,Archive.Slip.EvaluateDate) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Archive.Slip.SourceId,Archive.Slip.SlipStateId,Archive.Slip.SlipId,Archive.slip.TotalOddValue,Archive.Slip.CurrencyId,PB.IsTerminal '


  SET @sqlcommand2222 +=   ' insert @TempSummaryBet (ParentBranch, BranchTaxAmount,BranchName,SourceId) '+
    '	select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId)
	,cast(ISNULL((Select SUM(dbo.FuncCurrencyConverter(ISNULL(Amount,0)*TotalOddValue,Customer.Slip.CurrencyId,'+cast(@UserCurrencyId as nvarchar(10))+'))
 from Customer.Slip where Customer.Slip.SlipStateId in (3,6) and Customer.Slip.SlipTypeId=3
  and Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) ),0) as money) 
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,Customer.SlipSystem.SourceId 
from Customer.SlipSystem INNER JOIN Customer.Customer
ON Customer.Customer.CustomerId=Customer.SlipSystem.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
where (IsPayOut=0 or IsPayOut is null) and SlipStateId in (2,3,5,6)  
 and ( IsBranchCustomer=1)  and cast( DATEADD(HOUR,1,Customer.SlipSystem.EvaluateDate) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( DATEADD(HOUR,1,Customer.SlipSystem.EvaluateDate) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.SlipSystem.SourceId,Customer.SlipSystem.SystemSlipId,PB.IsTerminal '

   SET @sqlcommand2222 +=   ' insert @TempSummaryBet (ParentBranch, BranchTaxAmount,BranchName,SourceId) '+
    '	select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId)
	,cast(ISNULL((Select SUM(dbo.FuncCurrencyConverter(ISNULL(Amount,0)*TotalOddValue,Archive.Slip.CurrencyId,'+cast(@UserCurrencyId as nvarchar(10))+'))
 from Archive.Slip where Archive.Slip.SlipStateId in (3,6) and Archive.Slip.SlipTypeId=3
  and Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) ),0) as money) 
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,Customer.SlipSystem.SourceId 
from Customer.SlipSystem INNER JOIN Customer.Customer
ON Customer.Customer.CustomerId=Customer.SlipSystem.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
where (IsPayOut=0 or IsPayOut is null) and SlipStateId in (2,3,5,6)  
 and ( IsBranchCustomer=1)  and cast( DATEADD(HOUR,1,Customer.SlipSystem.EvaluateDate) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( DATEADD(HOUR,1,Customer.SlipSystem.EvaluateDate) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.SlipSystem.SourceId,Customer.SlipSystem.SystemSlipId,PB.IsTerminal '   

--   SET @sqlcommand2222 +=   ' insert @TempSummaryBet (ParentBranch,PartnerTurnOver ,BranchTaxAmount,BranchName,SourceId) '+
--    '	 SELECT (select ppp.BrancName COLLATE SQL_Latin1_General_CP1_CI_AS from Parameter.Branch  as ppp  where ppp.BranchId in (select pp.ParentBranchId from Parameter.Branch  as pp  where pp.BrancName COLLATE SQL_Latin1_General_CP1_CI_AS=tp.ParentBranch))
--, SUM(SlipAmount)-(sum(WonSlipPayOut)+ISNULL(sum(Cashout),0)+ISNULL(sum(CancelSlipAmount),0)) as Profit
-- ,SUM(TaxAmount) as TaxAmount
-- ,TP.ParentBranch COLLATE SQL_Latin1_General_CP1_CI_AS
-- ,TP.SourceId
-- FROM @TempSummaryBet as TP 
-- where (TP.ParentBranch in (select ppp.BrancName COLLATE SQL_Latin1_General_CP1_CI_AS from Parameter.Branch  as ppp  where ppp.BranchId in (select pp.ParentBranchId from Parameter.Branch  as pp  where pp.BrancName COLLATE SQL_Latin1_General_CP1_CI_AS=tp.BranchName))) 
-- GROUP BY  TP.[BranchName],TP.ParentBranch ,TP.SourceId   HAVING SUM(SlipAmount) is not null'

  SET @sqlcommand22222 +=   ' insert @TempSummaryBet (ParentBranch,PayOutCount ,PayOutAmount,BranchName,SourceId) '+
  'select (select P.BrancName from Parameter.Branch  as P  where P.BranchId=PB.ParentBranchId), COUNT(CustomerSlip.PayOutCount)
,SUM(CustomerSlip.PayOutAmount)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,CustomerSlip.SourceId
From Report.SummarySportBetting as CustomerSlip  inner join Customer.Customer  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch  as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,CustomerSlip.SourceId,PB.IsTerminal '

 SET @sqlcommand22222 +=   ' insert @TempSummaryBet (ParentBranch,OnlineDeposit ,OnlineWithDraw,BranchName,SourceId) '+
  'select (select P.BrancName from Parameter.Branch  as P  where P.BranchId=PB.ParentBranchId) 
,SUM(CustomerSlip.OnlineDeposit)
,SUM(CustomerSlip.OnlineWithDraw)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,1
From Report.SummarySportBetting as CustomerSlip  inner join Customer.Customer  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch  as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal '
 
 --set @sqlcommand9 +=' insert @TempSummaryBet (ParentBranch,BranchName ,SlipAmount,WonSlipPayOut,CancelSlipAmount,PayOutAmount,Turnover,PartnerTurnOver,OpenSlipAmount,TaxAmount,BranchTaxAmount,SourceId,Cashout)
 -- SELECT ''Total''
 -- ,''''
 -- ,SUM(SlipAmount) AS TurnOver
 --,ISNULL(sum(WonSlipPayOut),0) as CustomerWining
 --,ISNULL(SUM(CancelSlipAmount),0) as CancelBet
 --,ISNULL(SUM(PayOutAmount),0) 
 -- ,ISNULL(SUM(SlipAmount),0)-ISNULL(sum(WonSlipPayOut),0)-ISNULL(sum(Cashout),0)-ISNULL(SUM(CancelSlipAmount),0) as Profit
 -- ,0 as PartnerProfit
  
 --,ISNULL(SUM(OpenSlipAmount),0) as Unsettled
 --,ISNULL(SUM(TaxAmount),0) as Tax
 --,0 as BranchTaxAmount
 --,SourceId
 --,ISNULL(SUM(Cashout),0)
 --  FROM @TempSummaryBet GROUP BY SourceId    HAVING SUM(SlipAmount) is not null '




	set @sqlcommand9+=' declare @TempSummaryBet3 table (ParentBranch nvarchar(50),SlipCount int,SlipAmount money,OpenSlipCount int,OpenSlipAmount money,OpenSlipPayOut money,WonSlipCount int,WonSlipAmount money,WonSlipPayOut money,LostSlipCount int,LostSlipAmount money,CancelSlipCount int,CancelSlipAmount money,TurnOver money,PartnerTurnOver money,BranchName nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS,TaxCount int,TaxAmount money,BranchTaxAmount money,PayOutCount int,PayOutAmount money,Cashout money,Bonus money ,OnlineDeposit money,OnlineWithDraw money) '+
  ' insert @TempSummaryBet3 '+
  '   SELECT tp2.ParentBranch,SUM(ISNULL(SlipCount,0))
,SUM(ISNULL(SlipAmount,0)),SUM(ISNULL(OpenSlipCount,0)),SUM(ISNULL(OpenSlipAmount,0)),SUM(ISNULL(OpenSlipPayOut,0)),SUM(ISNULL(WonSlipCount,0)) ,SUM(ISNULL(WonSlipAmount,0))
,SUM(ISNULL(WonSlipPayOut,0)),SUM(ISNULL(LostSlipCount,0)),SUM(ISNULL(LostSlipAmount,0)),SUM(ISNULL(CancelSlipCount,0)),SUM(ISNULL(CancelSlipAmount,0)),SUM(ISNULL(SlipAmount,0))-(SUM(ISNULL(WonSlipPayOut,0))+SUM(ISNULL(Cashout,0))+ISNULL(SUM(CancelSlipAmount),0)) as TurnOver
,(SUM(ISNULL(WonSlipPayOut,0))+SUM(ISNULL(Cashout,0))+ISNULL(SUM(CancelSlipAmount),0))
,tp2.BranchName,SUM(ISNULL(TaxCount,0)),SUM(ISNULL(TaxAmount,0)),SUM(ISNULL(BranchTaxAmount,0)),SUM(ISNULL(PayOutCount,0)),SUM(ISNULL(WonSlipPayOut,0)),SUM(ISNULL(Cashout,0)),SUM(ISNULL(Bonus,0))
 ,SUM(ISNULL(OnlineDeposit,0)),SUM(ISNULL(OnlineWithDraw,0))
     FROM @TempSummaryBet as tp2 where 1=1  '+@where3 +
	' GROUP BY BranchName,ParentBranch  '


		set @sqlcommand9+=
  ' insert @TempSummaryBet3 '+
  '   SELECT ''Total'',SUM(ISNULL(SlipCount,0))
,SUM(ISNULL(SlipAmount,0)),SUM(ISNULL(OpenSlipCount,0)),SUM(ISNULL(OpenSlipAmount,0)),SUM(ISNULL(OpenSlipPayOut,0)),SUM(ISNULL(WonSlipCount,0)) ,SUM(ISNULL(WonSlipAmount,0))
,SUM(ISNULL(WonSlipPayOut,0)),SUM(ISNULL(LostSlipCount,0)),SUM(ISNULL(LostSlipAmount,0)),SUM(ISNULL(CancelSlipCount,0)),SUM(ISNULL(CancelSlipAmount,0)),SUM(ISNULL(SlipAmount,0))-(SUM(ISNULL(WonSlipPayOut,0))+SUM(ISNULL(Cashout,0))+ISNULL(SUM(CancelSlipAmount),0)) as TurnOver
,(SUM(ISNULL(WonSlipPayOut,0))+SUM(ISNULL(Cashout,0))+ISNULL(SUM(CancelSlipAmount),0))
,''Total'',SUM(ISNULL(TaxCount,0)),SUM(ISNULL(TaxAmount,0)),SUM(ISNULL(BranchTaxAmount,0)),SUM(ISNULL(PayOutCount,0)),SUM(ISNULL(WonSlipPayOut,0)),SUM(ISNULL(Cashout,0)),SUM(ISNULL(Bonus,0))
,SUM(ISNULL(OnlineDeposit,0)),SUM(ISNULL(OnlineWithDraw,0))
     FROM @TempSummaryBet as tp2 where 1=1  '+@where3  

	

  set @sqlcommand=' declare @total int '+
'select @total=COUNT(SlipCount)  '+
'FROM        @TempSummaryBet3 as tmp LEFT OUTER JOIN Parameter.Branch as PB On tmp.BranchName=PB.BrancName
WHERE    1=1 ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
'	 ParentBranch ,ISNULL([SlipCount],0)  as [SlipCount]
       ,ISNULL(SlipAmount,0) as [SlipAmount]
      ,ISNULL([OpenSlipCount],0)  as [OpenSlipCount]
      ,ISNULL([OpenSlipAmount],0)  as [OpenSlipAmount]
      ,ISNULL([OpenSlipPayOut],0)  as [OpenSlipPayOut]
      ,ISNULL([WonSlipCount],0)  as [WonSlipCount]
      ,ISNULL([WonSlipAmount],0) as [WonSlipAmount]
      ,ISNULL([WonSlipPayOut],0)  as [WonSlipPayOut]
      ,ISNULL([LostSlipCount],0)  as [LostSlipCount]
      ,ISNULL([LostSlipAmount],0)  as [LostSlipAmount]
      ,ISNULL([CancelSlipCount],0)  as [CancelSlipCount]
      ,ISNULL([CancelSlipAmount],0) as [CancelSlipAmount]
      ,cast(0 as money) as SumTurnOver
	  ,BranchName
	  ,(ISNULL(PartnerTurnOver,0)) as BranchTurnOver
	  ,ISNULL(TurnOver,0) as TurnOver
	  ,ISNULL([TaxCount],0)  as [TaxCount]
      ,ISNULL(ISNULL([TaxAmount],0),0)  as [TaxAmount]
	  ,ISNULL(ISNULL([BranchTaxAmount],0),0)  as [BranchTaxAmount]
	  ,ISNULL(ISNULL([TaxAmount],0),0)+ISNULL(ISNULL([BranchTaxAmount],0),0) as SumTaxAmount
	  ,ISNULL([PayOutCount],0)  as [PayOutCount]
      ,ISNULL(ISNULL([PayOutAmount],0),0)  as PayOutAmount,ISNULL(ISNULL([Cashout],0),0)  as Cashout,ISNULL(ISNULL([Bonus],0),0)  as Bonus ,ISNULL(ISNULL([OnlineDeposit],0),0)  as OnlineDeposit,ISNULL(ISNULL([OnlineWithDraw],0),0)  as OnlineWithDraw '+
'FROM         @TempSummaryBet3 as tmp LEFT OUTER JOIN Parameter.Branch as PB   On tmp.BranchName=PB.BrancName
WHERE  1=1 '+
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '



	end
 
 exec (@sqlcommandBranch+@sqlcommand2+@sqlcommand22+@sqlcommand221+@sqlcommand222+@sqlcommand2222+@sqlcommand22222+@sqlcommand2T+@sqlcommand22T+@sqlcommand221T+@sqlcommand222T+@sqlcommand2222T+@sqlcommand22222T+@sqlcommand9+@sqlcommand)

 end
  else  if(@SourceId=1) -- Online
 begin
 exec Report.ProcSummarySportBettingFill1





	
  if(@BranchId<>1)
	begin
	if (@BranchId<>31970)
		begin
			set @where2=' PB.BranchId in (select BranchId from Parameter.Branch with (nolock)  where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId in (select BranchId from Parameter.Branch with (nolock) where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ') )))'  
			set @whereTerminal='  Customer.BranchId in (select BranchId from Parameter.Branch with (nolock) where IsTerminal=1 and (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId in (select BranchId from Parameter.Branch with (nolock)   where IsTerminal=0 and (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ') )))'  
		end
	else
		begin
			set @where2=' (PB.BranchId in (select BranchId from Parameter.Branch with (nolock)  where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId in (select BranchId from Parameter.Branch with (nolock) where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ') ))) or PB.ParentBranchId in (select BranchId from Parameter.Branch with (nolock)  where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId in (select BranchId from Parameter.Branch with (nolock) where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ') ))))'  
			set @whereTerminal='  Customer.BranchId in (select BranchId from Parameter.Branch with (nolock) where IsTerminal=1 and (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId in (select BranchId from Parameter.Branch with (nolock)   where IsTerminal=0 and (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ') )))'  
		end
	end



	if(@SourceId=3)
		set @SourceId=4

	 if(@SourceId=0)
	set @where3=@where3+' and SourceId in (select SourceId from Parameter.Source with (nolock)) '
else if(@SourceId=1)
	set @where3=@where3+' and SourceId in (1,2) '
else
	set @where3=@where3+' and SourceId='+cast(@SourceId as nvarchar(7)) 


	set @where3=' and SourceId in (select SourceId from Parameter.Source) '
	

if(@BranchId<>1)
begin

	set @sqlcommandBranch=' declare @TempBranchtable table (BranchId bigint) '+
' insert @TempBranchtable select BranchId from Parameter.Branch with (nolock) where ( BranchId in (select BranchId from Parameter.Branch with (nolock)  where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId in (select BranchId from Parameter.Branch with (nolock) where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ') ))) or ParentBranchId in (select BranchId from Parameter.Branch with (nolock)  where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId in (select BranchId from Parameter.Branch with (nolock) where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ') ))) ) '




set @where2= ' ( PB.BranchId in (select BranchId from @TempBranchtable) or PB.ParentBranchId in (select BranchId from @TempBranchtable)) '
 



 set @sqlcommand2=' declare @TempSummaryBet table (ParentBranch nvarchar(50),SlipCount int,SlipAmount money,OpenSlipCount int,OpenSlipAmount money,OpenSlipPayOut money,WonSlipCount int,WonSlipAmount money,WonSlipPayOut money,LostSlipCount int,LostSlipAmount money,CancelSlipCount int,CancelSlipAmount money,TurnOver money,PartnerTurnOver money,BranchName nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS,TaxCount int,TaxAmount money,BranchTaxAmount money,PayOutCount int,PayOutAmount money,SourceId int,Cashout money,Bonus money ,OnlineDeposit money,OnlineWithDraw money) '+
  'insert @TempSummaryBet (ParentBranch,SlipCount,SlipAmount,BranchName,SourceId) '+
  'select (select P.BrancName from Parameter.Branch  as P  where P.BranchId=PB.ParentBranchId), COUNT(CustomerSlip.SlipCount)
,SUM(CustomerSlip.[OrgSlipAmount])
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,CustomerSlip.SourceId
From Report.SummarySportBetting as CustomerSlip with (nolock) inner join Customer.Customer with (nolock) on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and Customer.Customer.IsBranchCustomer=0 and  cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,CustomerSlip.SourceId,PB.IsTerminal '
  
 

  SET @sqlcommand2 +=   ' insert @TempSummaryBet (ParentBranch,OpenSlipCount,OpenSlipAmount,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId), COUNT(Customer.Slip.SlipId)
,SUM(dbo.FuncCurrencyConverter(Customer.Slip.Amount,Customer.Slip.CurrencyId,'+cast(@UserCurrencyId as nvarchar(10))+'))
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,Customer.Slip.SourceId
From Customer.Slip with (nolock) inner join Customer.Customer with (nolock) on Customer.Slip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where Customer.Customer.IsBranchCustomer=0 and Customer.Slip.SlipStatu not in (2,4)  and Customer.Slip.SlipStateId=1 and Customer.slip.SlipTypeId<3 
and cast(DATEADD(HOUR,1,Customer.Slip.CreateDate) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(DATEADD(HOUR,1,Customer.Slip.CreateDate) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.Slip.SourceId,PB.IsTerminal '

    SET @sqlcommand2 +=   ' insert @TempSummaryBet (ParentBranch,OpenSlipCount,OpenSlipAmount,BranchName,SourceId) '+
        'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId), COUNT(Customer.SlipSystem.SystemSlipId)
,SUM( Customer.SlipSystem.Amount)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,Customer.SlipSystem.SourceId
From Customer.SlipSystem with (nolock) inner join Customer.Customer with (nolock) on Customer.SlipSystem.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  Customer.Customer.IsBranchCustomer=0 and  Customer.SlipSystem.SlipStateId=1  and Customer.SlipSystem.NewSlipTypeId in (4,5)
and cast( DATEADD(HOUR,1,Customer.SlipSystem.CreateDate) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( DATEADD(HOUR,1,Customer.SlipSystem.CreateDate) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.SlipSystem.SourceId,PB.IsTerminal '
  
 
   SET @sqlcommand22 +=   ' insert @TempSummaryBet (ParentBranch,WonSlipCount ,WonSlipAmount ,WonSlipPayOut,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch as P  where P.BranchId=PB.ParentBranchId), SUM(CustomerSlip.WonSlipCount)
,SUM(CustomerSlip.[OrgWonSlipAmount])
,SUM([OrgWonSlipPayOut])
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,CustomerSlip.SourceId
From Report.SummarySportBetting as CustomerSlip  inner join Customer.Customer  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and Customer.Customer.IsBranchCustomer=0  
and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,CustomerSlip.SourceId,PB.IsTerminal '
 
 
     SET @sqlcommand22 +=   ' insert @TempSummaryBet (ParentBranch,Bonus,BranchName,SourceId ) '+
    'select (select P.BrancName from Parameter.Branch as P  where P.BranchId=PB.ParentBranchId), SUM(CustomerSlip.Amount)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end,1
From Customer.[Transaction] as CustomerSlip with (nolock)  inner join Customer.Customer with (nolock)  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
   Parameter.Branch  as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where Customer.Customer.IsTerminalCustomer=0 and Customer.Customer.IsBranchCustomer=0 and CustomerSlip.TransactionTypeId=35 and  cast( CustomerSlip.TransactionDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( CustomerSlip.TransactionDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal '

    SET @sqlcommand221 +=   ' insert @TempSummaryBet (ParentBranch,Cashout,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch  as P  where P.BranchId=PB.ParentBranchId)
,SUM(CustomerSlip.[OrgCashoutSlipAmount])
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,CustomerSlip.SourceId
From Report.SummarySportBetting as CustomerSlip  inner join Customer.Customer  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and Customer.Customer.IsBranchCustomer=0  
and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,CustomerSlip.SourceId,PB.IsTerminal '
  
  SET @sqlcommand222 +=   ' insert @TempSummaryBet (ParentBranch,LostSlipCount ,LostSlipAmount,BranchName,SourceId) '+
   'select (select P.BrancName from Parameter.Branch  as P  where P.BranchId=PB.ParentBranchId), SUM(CustomerSlip.LostSlipCount)
,SUM(CustomerSlip.[OrgLostSlipAmount])
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,CustomerSlip.SourceId
From Report.SummarySportBetting as CustomerSlip  inner join Customer.Customer  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch  as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and Customer.Customer.IsBranchCustomer=0 
and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,CustomerSlip.SourceId,PB.IsTerminal '

 declare @reeee nvarchar(max)=''

 SET @sqlcommand222 +=   ' insert @TempSummaryBet (ParentBranch,CancelSlipCount ,CancelSlipAmount,BranchName,SourceId) '+
     'select (select P.BrancName from Parameter.Branch  as P  where P.BranchId=PB.ParentBranchId), COUNT(CustomerSlip.CancelSlipCount)
,SUM(CustomerSlip.[OrgCancelSlipAmount])
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,CustomerSlip.SourceId
From Report.SummarySportBetting as CustomerSlip  inner join Customer.Customer  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch  as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and Customer.Customer.IsBranchCustomer=0  
and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,CustomerSlip.SourceId,PB.IsTerminal '
 

 --select @reeee

  SET @sqlcommand2222 +=   ' insert @TempSummaryBet (ParentBranch,TaxCount ,TaxAmount,BranchName,SourceId) '+
       'select (select P.BrancName from Parameter.Branch  as P  where P.BranchId=PB.ParentBranchId), COUNT(CustomerSlip.SlipCount)
,(SUM(CustomerSlip.[OrgSlipAmount])*5)/100
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,CustomerSlip.SourceId
From Report.SummarySportBetting as CustomerSlip with (nolock) inner join Customer.Customer with (nolock) on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and Customer.Customer.IsBranchCustomer=0 and  cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,CustomerSlip.SourceId,PB.IsTerminal '

   



--   SET @sqlcommand2222 +=   ' insert @TempSummaryBet (ParentBranch,PartnerTurnOver ,BranchTaxAmount,BranchName,SourceId) '+
--    '	 SELECT (select ppp.BrancName COLLATE SQL_Latin1_General_CP1_CI_AS from Parameter.Branch as ppp with (nolock) where ppp.BranchId in (select pp.ParentBranchId from Parameter.Branch as pp with (nolock) where pp.BrancName COLLATE SQL_Latin1_General_CP1_CI_AS=tp.ParentBranch))
--, SUM(SlipAmount)-(sum(WonSlipPayOut)+ISNULL(sum(Cashout),0)+ISNULL(sum(CancelSlipAmount),0)) as Profit
-- ,SUM(TaxAmount) as TaxAmount
-- ,TP.ParentBranch COLLATE SQL_Latin1_General_CP1_CI_AS
-- ,TP.SourceId
-- FROM @TempSummaryBet as TP 
-- where (TP.ParentBranch in (select ppp.BrancName COLLATE SQL_Latin1_General_CP1_CI_AS from Parameter.Branch as ppp with (nolock) where ppp.BranchId in (select pp.ParentBranchId from Parameter.Branch as pp with (nolock) where pp.BrancName COLLATE SQL_Latin1_General_CP1_CI_AS=tp.BranchName))) 
-- GROUP BY  TP.[BranchName],TP.ParentBranch ,TP.SourceId   HAVING SUM(SlipAmount) is not null'

  SET @sqlcommand22222 +=   ' insert @TempSummaryBet (ParentBranch,PayOutCount ,PayOutAmount,BranchName,SourceId) '+
  'select (select P.BrancName from Parameter.Branch  as P  where P.BranchId=PB.ParentBranchId), COUNT(CustomerSlip.PayOutCount)
,SUM(CustomerSlip.[OrgPayOutAmount])
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,CustomerSlip.SourceId
From Report.SummarySportBetting as CustomerSlip  inner join Customer.Customer  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch  as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and Customer.Customer.IsBranchCustomer=0  
and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,CustomerSlip.SourceId,PB.IsTerminal '

 SET @sqlcommand22222 +=   ' insert @TempSummaryBet (ParentBranch,OnlineDeposit ,OnlineWithDraw,BranchName,SourceId) '+
  'select (select P.BrancName from Parameter.Branch  as P  where P.BranchId=PB.ParentBranchId) 
,SUM(CustomerSlip.OnlineDeposit)
,SUM(CustomerSlip.OnlineWithDraw)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,1
From Report.SummarySportBetting as CustomerSlip  inner join Customer.Customer  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch  as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal '

 --set @sqlcommand9 +=' insert @TempSummaryBet (ParentBranch,BranchName ,SlipAmount,WonSlipPayOut,CancelSlipAmount,PayOutAmount,Turnover,PartnerTurnOver,OpenSlipAmount,TaxAmount,BranchTaxAmount,SourceId,Cashout)
 -- SELECT ''Total''
 -- ,''''
 -- ,SUM(SlipAmount) AS TurnOver
 --,ISNULL(sum(WonSlipPayOut),0) as CustomerWining
 --,ISNULL(SUM(CancelSlipAmount),0) as CancelBet
 --,ISNULL(SUM(PayOutAmount),0) 
 -- ,ISNULL(SUM(SlipAmount),0)-ISNULL(sum(WonSlipPayOut),0)-ISNULL(sum(Cashout),0)-ISNULL(SUM(CancelSlipAmount),0) as Profit
 -- ,0 as PartnerProfit
  
 --,ISNULL(SUM(OpenSlipAmount),0) as Unsettled
 --,ISNULL(SUM(TaxAmount),0) as Tax
 --,0 as BranchTaxAmount
 --,SourceId
 --,ISNULL(SUM(Cashout),0)
 --  FROM @TempSummaryBet GROUP BY SourceId    HAVING SUM(SlipAmount) is not null '




	set @sqlcommand9+=' declare @TempSummaryBet3 table (ParentBranch nvarchar(50),SlipCount int,SlipAmount money,OpenSlipCount int,OpenSlipAmount money,OpenSlipPayOut money,WonSlipCount int,WonSlipAmount money,WonSlipPayOut money,LostSlipCount int,LostSlipAmount money,CancelSlipCount int,CancelSlipAmount money,TurnOver money,PartnerTurnOver money,BranchName nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS,TaxCount int,TaxAmount money,BranchTaxAmount money,PayOutCount int,PayOutAmount money,Cashout money,Bonus money ,OnlineDeposit money,OnlineWithDraw money) '+
  ' insert @TempSummaryBet3 '+
  '   SELECT tp2.ParentBranch,SUM(ISNULL(SlipCount,0))
,SUM(ISNULL(SlipAmount,0)),SUM(ISNULL(OpenSlipCount,0)),SUM(ISNULL(OpenSlipAmount,0)),SUM(ISNULL(OpenSlipPayOut,0)),SUM(ISNULL(WonSlipCount,0)) ,SUM(ISNULL(WonSlipAmount,0))
,SUM(ISNULL(WonSlipPayOut,0)),SUM(ISNULL(LostSlipCount,0)),SUM(ISNULL(LostSlipAmount,0)),SUM(ISNULL(CancelSlipCount,0)),SUM(ISNULL(CancelSlipAmount,0)),SUM(ISNULL(SlipAmount,0))-(SUM(ISNULL(WonSlipPayOut,0))+SUM(ISNULL(Cashout,0))+ISNULL(SUM(CancelSlipAmount),0)) as TurnOver
,(SUM(ISNULL(WonSlipPayOut,0))+SUM(ISNULL(Cashout,0))+ISNULL(SUM(CancelSlipAmount),0))
,tp2.BranchName,SUM(ISNULL(TaxCount,0)),SUM(ISNULL(TaxAmount,0)),SUM(ISNULL(BranchTaxAmount,0)),SUM(ISNULL(PayOutCount,0)),SUM(ISNULL(PayOutAmount,0)),SUM(ISNULL(Cashout,0)),SUM(ISNULL(Bonus,0))
 ,SUM(ISNULL(OnlineDeposit,0)),SUM(ISNULL(OnlineWithDraw,0))
     FROM @TempSummaryBet as tp2 where 1=1  '+@where3 +
	' GROUP BY BranchName,ParentBranch  HAVING SUM(SlipAmount) is not null'


		set @sqlcommand9+=
  ' insert @TempSummaryBet3 '+
  '   SELECT ''Total'',SUM(ISNULL(SlipCount,0))
,SUM(ISNULL(SlipAmount,0)),SUM(ISNULL(OpenSlipCount,0)),SUM(ISNULL(OpenSlipAmount,0)),SUM(ISNULL(OpenSlipPayOut,0)),SUM(ISNULL(WonSlipCount,0)) ,SUM(ISNULL(WonSlipAmount,0))
,SUM(ISNULL(WonSlipPayOut,0)),SUM(ISNULL(LostSlipCount,0)),SUM(ISNULL(LostSlipAmount,0)),SUM(ISNULL(CancelSlipCount,0)),SUM(ISNULL(CancelSlipAmount,0)),SUM(ISNULL(SlipAmount,0))-(SUM(ISNULL(WonSlipPayOut,0))+SUM(ISNULL(Cashout,0))+ISNULL(SUM(CancelSlipAmount),0)) as TurnOver
,(SUM(ISNULL(WonSlipPayOut,0))+SUM(ISNULL(Cashout,0))+ISNULL(SUM(CancelSlipAmount),0))
,''Total'',SUM(ISNULL(TaxCount,0)),SUM(ISNULL(TaxAmount,0)),SUM(ISNULL(BranchTaxAmount,0)),SUM(ISNULL(PayOutCount,0)),SUM(ISNULL(WonSlipPayOut,0)),SUM(ISNULL(Cashout,0)),SUM(ISNULL(Bonus,0))
,SUM(ISNULL(OnlineDeposit,0)),SUM(ISNULL(OnlineWithDraw,0))
     FROM @TempSummaryBet as tp2 where 1=1  '+@where3  


	
  set @sqlcommand=' declare @total int '+
'select @total=COUNT(SlipCount)  '+
'FROM        @TempSummaryBet3 as tmp LEFT OUTER JOIN Parameter.Branch On tmp.BranchName=Parameter.Branch.BrancName
WHERE    1=1 ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
'	 ParentBranch ,ISNULL([SlipCount],0)  as [SlipCount]
       ,ISNULL(SlipAmount,0) as [SlipAmount]
      ,ISNULL([OpenSlipCount],0)  as [OpenSlipCount]
      ,ISNULL([OpenSlipAmount],0)  as [OpenSlipAmount]
      ,ISNULL([OpenSlipPayOut],0)  as [OpenSlipPayOut]
      ,ISNULL([WonSlipCount],0)  as [WonSlipCount]
      ,ISNULL([WonSlipAmount],0) as [WonSlipAmount]
      ,ISNULL([WonSlipPayOut],0)  as [WonSlipPayOut]
      ,ISNULL([LostSlipCount],0)  as [LostSlipCount]
      ,ISNULL([LostSlipAmount],0)  as [LostSlipAmount]
      ,ISNULL([CancelSlipCount],0)  as [CancelSlipCount]
      ,ISNULL([CancelSlipAmount],0) as [CancelSlipAmount]
      ,cast(0 as money) as SumTurnOver
	  ,BranchName
	  ,(ISNULL(PartnerTurnOver,0)) as BranchTurnOver
	  ,ISNULL(TurnOver,0) as TurnOver
	  ,ISNULL([TaxCount],0)  as [TaxCount]
      ,ISNULL(ISNULL([TaxAmount],0),0)  as [TaxAmount]
	  ,ISNULL(ISNULL([BranchTaxAmount],0),0)  as [BranchTaxAmount]
	  ,ISNULL(ISNULL([TaxAmount],0),0)+ISNULL(ISNULL([BranchTaxAmount],0),0) as SumTaxAmount
	  ,ISNULL([PayOutCount],0)  as [PayOutCount]
      ,ISNULL(ISNULL([PayOutAmount],0),0)  as PayOutAmount,ISNULL(ISNULL([Cashout],0),0)  as Cashout,ISNULL(ISNULL([Bonus],0),0)  as Bonus ,ISNULL(ISNULL([OnlineDeposit],0),0)  as OnlineDeposit,ISNULL(ISNULL([OnlineWithDraw],0),0)  as OnlineWithDraw  '+
'FROM         @TempSummaryBet3 as tmp LEFT OUTER JOIN Parameter.Branch with (nolock) On tmp.BranchName=Parameter.Branch.BrancName
WHERE  1=1 '+
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '

 end
 else
 begin
		
 set @sqlcommand2=' declare @TempSummaryBet table (ParentBranch nvarchar(50),SlipCount int,SlipAmount money,OpenSlipCount int,OpenSlipAmount money,OpenSlipPayOut money,WonSlipCount int,WonSlipAmount money,WonSlipPayOut money,LostSlipCount int,LostSlipAmount money,CancelSlipCount int,CancelSlipAmount money,TurnOver money,PartnerTurnOver money,BranchName nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS,TaxCount int,TaxAmount money,BranchTaxAmount money,PayOutCount int,PayOutAmount money,SourceId int,Cashout money,Bonus money,OnlineDeposit money,OnlineWithDraw money) '+
  'insert @TempSummaryBet (ParentBranch,SlipCount,SlipAmount,BranchName,SourceId) '+
  'select (select P.BrancName from Parameter.Branch  as P  where P.BranchId=PB.ParentBranchId), COUNT(CustomerSlip.SlipCount)
,SUM( CustomerSlip.SlipAmount)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,CustomerSlip.SourceId
From Report.SummarySportBetting as CustomerSlip with (nolock) inner join Customer.Customer with (nolock) on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and Customer.Customer.IsBranchCustomer=0 and  cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,CustomerSlip.SourceId,PB.IsTerminal '
  
 

  SET @sqlcommand2 +=   ' insert @TempSummaryBet (ParentBranch,OpenSlipCount,OpenSlipAmount,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId), COUNT(Customer.Slip.SlipId)
,SUM(dbo.FuncCurrencyConverter(Customer.Slip.Amount,Customer.Slip.CurrencyId,'+cast(@UserCurrencyId as nvarchar(10))+'))
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,Customer.Slip.SourceId
From Customer.Slip with (nolock) inner join Customer.Customer with (nolock) on Customer.Slip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where Customer.Customer.IsBranchCustomer=0 and Customer.Slip.SlipStatu not in (2,4)  and Customer.Slip.SlipStateId=1  and Customer.Slip.SlipTypeId<3
and cast(DATEADD(HOUR,1,Customer.Slip.CreateDate) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(DATEADD(HOUR,1,Customer.Slip.CreateDate) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.Slip.SourceId,PB.IsTerminal '

    SET @sqlcommand2 +=   ' insert @TempSummaryBet (ParentBranch,OpenSlipCount,OpenSlipAmount,BranchName,SourceId) '+
        'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId), COUNT(Customer.SlipSystem.SystemSlipId)
,SUM( Customer.SlipSystem.Amount)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,Customer.SlipSystem.SourceId
From Customer.SlipSystem with (nolock) inner join Customer.Customer with (nolock) on Customer.SlipSystem.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  Customer.Customer.IsBranchCustomer=0 and  Customer.SlipSystem.SlipStateId=1  and Customer.SlipSystem.NewSlipTypeId in (4,5)
and cast( DATEADD(HOUR,1,Customer.SlipSystem.CreateDate) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( DATEADD(HOUR,1,Customer.SlipSystem.CreateDate) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.SlipSystem.SourceId,PB.IsTerminal '
 
   SET @sqlcommand22 +=   ' insert @TempSummaryBet (ParentBranch,WonSlipCount ,WonSlipAmount ,WonSlipPayOut,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch as P  where P.BranchId=PB.ParentBranchId), SUM(CustomerSlip.WonSlipCount)
,SUM(CustomerSlip.WonSlipAmount)
,SUM(WonSlipPayOut)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,CustomerSlip.SourceId
From Report.SummarySportBetting as CustomerSlip  inner join Customer.Customer  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and Customer.Customer.IsBranchCustomer=0  
and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,CustomerSlip.SourceId,PB.IsTerminal '
 
      SET @sqlcommand22 +=   ' insert @TempSummaryBet (ParentBranch,Bonus,BranchName,SourceId ) '+
    'select (select P.BrancName from Parameter.Branch as P  where P.BranchId=PB.ParentBranchId), SUM(CustomerSlip.Amount)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end,1
From Customer.[Transaction] as CustomerSlip with (nolock)  inner join Customer.Customer with (nolock)  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
   Parameter.Branch  as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where Customer.Customer.IsTerminalCustomer=0 and Customer.Customer.IsBranchCustomer=0 and CustomerSlip.TransactionTypeId=35 and  cast( CustomerSlip.TransactionDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( CustomerSlip.TransactionDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal '

    SET @sqlcommand221 +=   ' insert @TempSummaryBet (ParentBranch,Cashout,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch  as P  where P.BranchId=PB.ParentBranchId)
,SUM(CustomerSlip.CashoutSlipAmount)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,CustomerSlip.SourceId
From Report.SummarySportBetting as CustomerSlip  inner join Customer.Customer  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and Customer.Customer.IsBranchCustomer=0  
and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,CustomerSlip.SourceId,PB.IsTerminal '
  
  SET @sqlcommand222 +=   ' insert @TempSummaryBet (ParentBranch,LostSlipCount ,LostSlipAmount,BranchName,SourceId) '+
   'select (select P.BrancName from Parameter.Branch  as P  where P.BranchId=PB.ParentBranchId), SUM(CustomerSlip.LostSlipCount)
,SUM(CustomerSlip.LostSlipAmount)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,CustomerSlip.SourceId
From Report.SummarySportBetting as CustomerSlip  inner join Customer.Customer  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch  as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and Customer.Customer.IsBranchCustomer=0 
and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,CustomerSlip.SourceId,PB.IsTerminal '

 

 SET @sqlcommand222 +=   ' insert @TempSummaryBet (ParentBranch,CancelSlipCount ,CancelSlipAmount,BranchName,SourceId) '+
     'select (select P.BrancName from Parameter.Branch  as P  where P.BranchId=PB.ParentBranchId), COUNT(CustomerSlip.CancelSlipCount)
,SUM(CustomerSlip.CancelSlipAmount)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,CustomerSlip.SourceId
From Report.SummarySportBetting as CustomerSlip  inner join Customer.Customer  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch  as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and Customer.Customer.IsBranchCustomer=0  
and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,CustomerSlip.SourceId,PB.IsTerminal '
 
  SET @sqlcommand2222 +=   ' insert @TempSummaryBet (ParentBranch,TaxCount ,TaxAmount,BranchName,SourceId) '+
      'select (select P.BrancName from Parameter.Branch  as P  where P.BranchId=PB.ParentBranchId), COUNT(CustomerSlip.TaxCount)
,SUM(CustomerSlip.Tax)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,CustomerSlip.SourceId
From Report.SummarySportBetting as CustomerSlip  inner join Customer.Customer  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch  as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,CustomerSlip.SourceId,PB.IsTerminal '

   

--   SET @sqlcommand2222 +=   ' insert @TempSummaryBet (ParentBranch,PartnerTurnOver ,BranchTaxAmount,BranchName,SourceId) '+
--    '	 SELECT (select ppp.BrancName COLLATE SQL_Latin1_General_CP1_CI_AS from Parameter.Branch as ppp with (nolock) where ppp.BranchId in (select pp.ParentBranchId from Parameter.Branch as pp with (nolock) where pp.BrancName COLLATE SQL_Latin1_General_CP1_CI_AS=tp.ParentBranch))
--, SUM(SlipAmount)-(sum(WonSlipPayOut)+ISNULL(sum(Cashout),0)+ISNULL(sum(CancelSlipAmount),0)) as Profit
-- ,SUM(TaxAmount) as TaxAmount
-- ,TP.ParentBranch COLLATE SQL_Latin1_General_CP1_CI_AS
-- ,TP.SourceId
-- FROM @TempSummaryBet as TP 
-- where (TP.ParentBranch in (select ppp.BrancName COLLATE SQL_Latin1_General_CP1_CI_AS from Parameter.Branch as ppp with (nolock) where ppp.BranchId in (select pp.ParentBranchId from Parameter.Branch as pp with (nolock) where pp.BrancName COLLATE SQL_Latin1_General_CP1_CI_AS=tp.BranchName))) 
-- GROUP BY  TP.[BranchName],TP.ParentBranch ,TP.SourceId   HAVING SUM(SlipAmount) is not null'

  SET @sqlcommand22222 +=   ' insert @TempSummaryBet (ParentBranch,PayOutCount ,PayOutAmount,BranchName,SourceId) '+
  'select (select P.BrancName from Parameter.Branch  as P  where P.BranchId=PB.ParentBranchId), COUNT(CustomerSlip.PayOutCount)
,SUM(CustomerSlip.PayOutAmount)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,CustomerSlip.SourceId
From Report.SummarySportBetting as CustomerSlip  inner join Customer.Customer  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch  as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and Customer.Customer.IsBranchCustomer=0  
and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,CustomerSlip.SourceId,PB.IsTerminal '

 SET @sqlcommand22222 +=   ' insert @TempSummaryBet (ParentBranch,OnlineDeposit ,OnlineWithDraw,BranchName,SourceId) '+
  'select (select P.BrancName from Parameter.Branch  as P  where P.BranchId=PB.ParentBranchId) 
,SUM(CustomerSlip.OnlineDeposit)
,SUM(CustomerSlip.OnlineWithDraw)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,1
From Report.SummarySportBetting as CustomerSlip  inner join Customer.Customer  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch  as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal '

 --set @sqlcommand9 +=' insert @TempSummaryBet (ParentBranch,BranchName ,SlipAmount,WonSlipPayOut,CancelSlipAmount,PayOutAmount,Turnover,PartnerTurnOver,OpenSlipAmount,TaxAmount,BranchTaxAmount,SourceId,Cashout)
 -- SELECT ''Total''
 -- ,''''
 -- ,SUM(SlipAmount) AS TurnOver
 --,ISNULL(sum(WonSlipPayOut),0) as CustomerWining
 --,ISNULL(SUM(CancelSlipAmount),0) as CancelBet
 --,ISNULL(SUM(PayOutAmount),0) 
 -- ,ISNULL(SUM(SlipAmount),0)-ISNULL(sum(WonSlipPayOut),0)-ISNULL(sum(Cashout),0)-ISNULL(SUM(CancelSlipAmount),0) as Profit
 -- ,0 as PartnerProfit
  
 --,ISNULL(SUM(OpenSlipAmount),0) as Unsettled
 --,ISNULL(SUM(TaxAmount),0) as Tax
 --,0 as BranchTaxAmount
 --,SourceId
 --,ISNULL(SUM(Cashout),0)
 --  FROM @TempSummaryBet GROUP BY SourceId    HAVING SUM(SlipAmount) is not null '




	set @sqlcommand9+=' declare @TempSummaryBet3 table (ParentBranch nvarchar(50),SlipCount int,SlipAmount money,OpenSlipCount int,OpenSlipAmount money,OpenSlipPayOut money,WonSlipCount int,WonSlipAmount money,WonSlipPayOut money,LostSlipCount int,LostSlipAmount money,CancelSlipCount int,CancelSlipAmount money,TurnOver money,PartnerTurnOver money,BranchName nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS,TaxCount int,TaxAmount money,BranchTaxAmount money,PayOutCount int,PayOutAmount money,Cashout money,Bonus money ,OnlineDeposit money,OnlineWithDraw money) '+
  ' insert @TempSummaryBet3 '+
  '   SELECT tp2.ParentBranch,SUM(ISNULL(SlipCount,0))
,SUM(ISNULL(SlipAmount,0)),SUM(ISNULL(OpenSlipCount,0)),SUM(ISNULL(OpenSlipAmount,0)),SUM(ISNULL(OpenSlipPayOut,0)),SUM(ISNULL(WonSlipCount,0)) ,SUM(ISNULL(WonSlipAmount,0))
,SUM(ISNULL(WonSlipPayOut,0)),SUM(ISNULL(LostSlipCount,0)),SUM(ISNULL(LostSlipAmount,0)),SUM(ISNULL(CancelSlipCount,0)),SUM(ISNULL(CancelSlipAmount,0)),SUM(ISNULL(SlipAmount,0))-(SUM(ISNULL(WonSlipPayOut,0))+SUM(ISNULL(Cashout,0))+ISNULL(SUM(CancelSlipAmount),0)) as TurnOver
,(SUM(ISNULL(WonSlipPayOut,0))+SUM(ISNULL(Cashout,0))+ISNULL(SUM(CancelSlipAmount),0))
,tp2.BranchName,SUM(ISNULL(TaxCount,0)),SUM(ISNULL(TaxAmount,0)),SUM(ISNULL(BranchTaxAmount,0)),SUM(ISNULL(PayOutCount,0)),SUM(ISNULL(PayOutAmount,0)),SUM(ISNULL(Cashout,0)),SUM(ISNULL(Bonus,0))
 ,SUM(ISNULL(OnlineDeposit,0)),SUM(ISNULL(OnlineWithDraw,0))
     FROM @TempSummaryBet as tp2 where 1=1  '+@where3 +
	' GROUP BY BranchName,ParentBranch  HAVING SUM(SlipAmount) is not null'

		set @sqlcommand9+=
  ' insert @TempSummaryBet3 '+
  '   SELECT ''Total'',SUM(ISNULL(SlipCount,0))
,SUM(ISNULL(SlipAmount,0)),SUM(ISNULL(OpenSlipCount,0)),SUM(ISNULL(OpenSlipAmount,0)),SUM(ISNULL(OpenSlipPayOut,0)),SUM(ISNULL(WonSlipCount,0)) ,SUM(ISNULL(WonSlipAmount,0))
,SUM(ISNULL(WonSlipPayOut,0)),SUM(ISNULL(LostSlipCount,0)),SUM(ISNULL(LostSlipAmount,0)),SUM(ISNULL(CancelSlipCount,0)),SUM(ISNULL(CancelSlipAmount,0)),SUM(ISNULL(SlipAmount,0))-(SUM(ISNULL(WonSlipPayOut,0))+SUM(ISNULL(Cashout,0))+ISNULL(SUM(CancelSlipAmount),0)) as TurnOver
,(SUM(ISNULL(WonSlipPayOut,0))+SUM(ISNULL(Cashout,0))+ISNULL(SUM(CancelSlipAmount),0))
,''Total'',SUM(ISNULL(TaxCount,0)),SUM(ISNULL(TaxAmount,0)),SUM(ISNULL(BranchTaxAmount,0)),SUM(ISNULL(PayOutCount,0)),SUM(ISNULL(WonSlipPayOut,0)),SUM(ISNULL(Cashout,0)),SUM(ISNULL(Bonus,0))
,SUM(ISNULL(OnlineDeposit,0)),SUM(ISNULL(OnlineWithDraw,0))
     FROM @TempSummaryBet as tp2 where 1=1  '+@where3  

	
  set @sqlcommand=' declare @total int '+
'select @total=COUNT(SlipCount)  '+
'FROM        @TempSummaryBet3 as tmp LEFT OUTER JOIN Parameter.Branch On tmp.BranchName=Parameter.Branch.BrancName
WHERE    1=1 ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
'	 ParentBranch ,ISNULL([SlipCount],0)  as [SlipCount]
       ,ISNULL(dbo.FuncCurrencyConverter(SlipAmount,3,'+cast(@UserCurrencyId as nvarchar(10))+'),0) as [SlipAmount]
      ,ISNULL([OpenSlipCount],0)  as [OpenSlipCount]
      ,ISNULL([OpenSlipAmount],0)  as [OpenSlipAmount]
      ,ISNULL([OpenSlipPayOut],0)  as [OpenSlipPayOut]
      ,ISNULL([WonSlipCount],0)  as [WonSlipCount]
      ,ISNULL(dbo.FuncCurrencyConverter([WonSlipAmount],3,'+cast(@UserCurrencyId as nvarchar(10))+'),0) as [WonSlipAmount]
      ,ISNULL(dbo.FuncCurrencyConverter([WonSlipPayOut],3,'+cast(@UserCurrencyId as nvarchar(10))+'),0)  as [WonSlipPayOut]
      ,ISNULL([LostSlipCount],0)  as [LostSlipCount]
      ,ISNULL(dbo.FuncCurrencyConverter(LostSlipAmount,3,'+cast(@UserCurrencyId as nvarchar(10))+'),0)  as [LostSlipAmount]
      ,ISNULL([CancelSlipCount],0)  as [CancelSlipCount]
      ,ISNULL(dbo.FuncCurrencyConverter(CancelSlipAmount,3,'+cast(@UserCurrencyId as nvarchar(10))+'),0) as [CancelSlipAmount]
      ,cast(0 as money) as SumTurnOver
	  ,BranchName
	  ,ISNULL(dbo.FuncCurrencyConverter(PartnerTurnOver,3,'+cast(@UserCurrencyId as nvarchar(10))+'),0) as BranchTurnOver
	  ,ISNULL(dbo.FuncCurrencyConverter(TurnOver,3,'+cast(@UserCurrencyId as nvarchar(10))+'),0) as TurnOver
	  ,ISNULL([TaxCount],0)  as [TaxCount]
      ,ISNULL(ISNULL(dbo.FuncCurrencyConverter(TaxAmount,3,'+cast(@UserCurrencyId as nvarchar(10))+'),0),0)  as [TaxAmount]
	  ,cast(0 as money) as [BranchTaxAmount]
	  ,cast(0 as money) as SumTaxAmount
	  ,ISNULL([PayOutCount],0)  as [PayOutCount]
      ,ISNULL(ISNULL(dbo.FuncCurrencyConverter(PayOutAmount,3,'+cast(@UserCurrencyId as nvarchar(10))+'),0),0)  as PayOutAmount
	  ,ISNULL(ISNULL(dbo.FuncCurrencyConverter(Cashout,3,'+cast(@UserCurrencyId as nvarchar(10))+'),0),0)  as Cashout,ISNULL(ISNULL(dbo.FuncCurrencyConverter(Bonus,3,'+cast(@UserCurrencyId as nvarchar(10))+'),0),0)  as Bonus ,ISNULL(ISNULL([OnlineDeposit],0),0)  as OnlineDeposit,ISNULL(ISNULL([OnlineWithDraw],0),0)  as OnlineWithDraw '+
'FROM         @TempSummaryBet3 as tmp LEFT OUTER JOIN Parameter.Branch with (nolock) On tmp.BranchName=Parameter.Branch.BrancName
WHERE  1=1 '+
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '

 end
 

 exec (@sqlcommandBranch+@sqlcommand2+@sqlcommand22+@sqlcommand221+@sqlcommand222+@sqlcommand2222+@sqlcommand22222+@sqlcommand2T+@sqlcommand22T+@sqlcommand221T+@sqlcommand222T+@sqlcommand2222T+@sqlcommand22222T+@sqlcommand9+@sqlcommand)

 end
 else  if(@SourceId=3) -- WEB POS
 begin
 exec Report.ProcSummarySportBettingFill1





	
  if(@BranchId<>1)
	begin
	if (@BranchId<>31970)
		begin
			set @where2=' PB.BranchId in (select BranchId from Parameter.Branch with (nolock)  where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId in (select BranchId from Parameter.Branch with (nolock) where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ') )))'  
			set @whereTerminal='  Customer.BranchId in (select BranchId from Parameter.Branch with (nolock) where IsTerminal=1 and (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId in (select BranchId from Parameter.Branch with (nolock)   where IsTerminal=0 and (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ') )))'  
		end
	else
		begin
			set @where2=' (PB.BranchId in (select BranchId from Parameter.Branch with (nolock)  where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId in (select BranchId from Parameter.Branch with (nolock) where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ') ))) or PB.ParentBranchId in (select BranchId from Parameter.Branch with (nolock)  where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId in (select BranchId from Parameter.Branch with (nolock) where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ') ))))'  
			set @whereTerminal='  Customer.BranchId in (select BranchId from Parameter.Branch with (nolock) where IsTerminal=1 and (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId in (select BranchId from Parameter.Branch with (nolock)   where IsTerminal=0 and (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ') )))'  
		end
	end
	else
		set @whereTerminal='  Customer.BranchId in (select BranchId from Parameter.Branch with (nolock) where IsTerminal=1 )' 



	if(@SourceId=3)
		set @SourceId=4

	 if(@SourceId=0)
	set @where3=@where3+' and SourceId in (select SourceId from Parameter.Source with (nolock)) '
else if(@SourceId=1)
	set @where3=@where3+' and SourceId in (1,2) '
else
	set @where3=@where3+' and SourceId='+cast(@SourceId as nvarchar(7)) 



if (@BranchId<>1)
begin
	set @sqlcommandBranch=' declare @TempBranchtable table (BranchId bigint) '+
' insert @TempBranchtable select BranchId from Parameter.Branch with (nolock) where ( BranchId in (select BranchId from Parameter.Branch with (nolock)  where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId in (select BranchId from Parameter.Branch with (nolock) where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ') ))) or ParentBranchId in (select BranchId from Parameter.Branch with (nolock)  where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId in (select BranchId from Parameter.Branch with (nolock) where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ') ))) ) '




set @where2= ' ( PB.BranchId in (select BranchId from @TempBranchtable) or PB.ParentBranchId in (select BranchId from @TempBranchtable)) '
 


 set @sqlcommand2=' declare @TempSummaryBet table (ParentBranch nvarchar(50),SlipCount int,SlipAmount money,OpenSlipCount int,OpenSlipAmount money,OpenSlipPayOut money,WonSlipCount int,WonSlipAmount money,WonSlipPayOut money,LostSlipCount int,LostSlipAmount money,CancelSlipCount int,CancelSlipAmount money,TurnOver money,PartnerTurnOver money,BranchName nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS,TaxCount int,TaxAmount money,BranchTaxAmount money,PayOutCount int,PayOutAmount money,SourceId int,Cashout money,Bonus money) '+
  'insert @TempSummaryBet (ParentBranch,SlipCount,SlipAmount,BranchName,SourceId) '+
  'select (select P.BrancName from Parameter.Branch  as P  where P.BranchId=PB.ParentBranchId), COUNT(CustomerSlip.SlipCount)
,SUM(CustomerSlip.[OrgSlipAmount])
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,CustomerSlip.SourceId
From Report.SummarySportBetting as CustomerSlip with (nolock) inner join Customer.Customer with (nolock) on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and Customer.Customer.IsBranchCustomer=1  
and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,CustomerSlip.SourceId,PB.IsTerminal '

 
  SET @sqlcommand2 +=   ' insert @TempSummaryBet (ParentBranch,OpenSlipCount,OpenSlipAmount,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId), COUNT(Customer.Slip.SlipId)
,SUM(dbo.FuncCurrencyConverter(Customer.Slip.Amount,Customer.Slip.CurrencyId,'+cast(@UserCurrencyId as nvarchar(10))+'))
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,Customer.Slip.SourceId
From Customer.Slip with (nolock) inner join Customer.Customer with (nolock) on Customer.Slip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where Customer.Customer.IsBranchCustomer=1 and Customer.Slip.SlipStatu not in (2,4)  and Customer.Slip.SlipStateId=1 and Customer.slip.SlipTypeId<3
and cast(DATEADD(HOUR,1,Customer.Slip.CreateDate) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(DATEADD(HOUR,1,Customer.Slip.CreateDate) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.Slip.SourceId,PB.IsTerminal '

   SET @sqlcommand2 +=   ' insert @TempSummaryBet (ParentBranch,OpenSlipCount,OpenSlipAmount,BranchName,SourceId) '+
        'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId), COUNT(Customer.SlipSystem.SystemSlipId)
,SUM( Customer.SlipSystem.Amount)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,Customer.SlipSystem.SourceId
From Customer.SlipSystem with (nolock) inner join Customer.Customer with (nolock) on Customer.SlipSystem.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  Customer.Customer.IsBranchCustomer=1 and  Customer.SlipSystem.SlipStateId=1  and Customer.SlipSystem.NewSlipTypeId in (4,5)
and cast( DATEADD(HOUR,1,Customer.SlipSystem.CreateDate) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( DATEADD(HOUR,1,Customer.SlipSystem.CreateDate) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.SlipSystem.SourceId,PB.IsTerminal '
 
   SET @sqlcommand22 +=   ' insert @TempSummaryBet (ParentBranch,WonSlipCount ,WonSlipAmount ,WonSlipPayOut,BranchName,SourceId) '+
     'select (select P.BrancName from Parameter.Branch as P  where P.BranchId=PB.ParentBranchId), SUM(CustomerSlip.WonSlipCount)
,SUM(CustomerSlip.[OrgWonSlipAmount])
,SUM([OrgWonSlipPayOut])
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,CustomerSlip.SourceId
From Report.SummarySportBetting as CustomerSlip  inner join Customer.Customer  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and Customer.Customer.IsBranchCustomer=1  
and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,CustomerSlip.SourceId,PB.IsTerminal '


      SET @sqlcommand22 +=   ' insert @TempSummaryBet (ParentBranch,Bonus,BranchName,SourceId ) '+
    'select (select P.BrancName from Parameter.Branch as P  where P.BranchId=PB.ParentBranchId), SUM(CustomerSlip.Amount)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end,1
From Customer.[Transaction] as CustomerSlip with (nolock)  inner join Customer.Customer with (nolock)  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
   Parameter.Branch  as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where Customer.Customer.IsTerminalCustomer=0 and Customer.Customer.IsBranchCustomer=0 and CustomerSlip.TransactionTypeId=35 and  cast( CustomerSlip.TransactionDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( CustomerSlip.TransactionDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal '
  

--    SET @sqlcommand22 +=   ' insert @TempSummaryBet (ParentBranch,WonSlipCount ,WonSlipAmount ,WonSlipPayOut,BranchName,SourceId) '+
--    'select (select P.BrancName from Parameter.Branch as P where P.BranchId=PB.ParentBranchId), COUNT(Archive.Slip.SlipId)
--,SUM(Archive.Slip.Amount)
--,SUM(Archive.Slip.Amount*Archive.Slip.TotalOddValue)
--,PB.[BranchId]
--,Archive.Slip.SourceId
--From Archive.Slip inner join Customer.Customer on Archive.Slip.CustomerId=Customer.Customer.CustomerId INNER JOIN
--  [Parameter].[Branch] as PB ON  PB.[BranchId]=Customer.Customer.BranchId 
--Where Archive.Slip.SlipStatu not in (2,4)  and Archive.Slip.SlipStateId in (3,5) and Archive.Slip.SlipTypeId<>3
--and cast(DATEADD(HOUR,1,Archive.Slip.EvaluateDate)) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
--and cast(DATEADD(HOUR,1,Archive.Slip.EvaluateDate)) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
-- GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Archive.Slip.SourceId '

--    SET @sqlcommand22 +=   ' insert @TempSummaryBet (ParentBranch,WonSlipCount ,WonSlipAmount ,WonSlipPayOut,BranchName,SourceId) '+
--    'select (select P.BrancName from Parameter.Branch as P where P.BranchId=PB.ParentBranchId), COUNT(Customer.SlipSystem.SystemSlipId)
--,ISNULL((Select SUM(Customer.Slip.Amount) from Customer.Slip where  Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip as CS where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)
--,ISNULL((Select SUM(Customer.Slip.TotalOddValue*Customer.Slip.Amount) from Customer.Slip where Customer.Slip.SlipStateId in (3,6) and Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip as CS where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)
--,PB.[BranchId]
--,Customer.SlipSystem.SourceId
--From Customer.SlipSystem inner join Customer.Customer on Customer.SlipSystem.CustomerId=Customer.Customer.CustomerId INNER JOIN
--  [Parameter].[Branch] as PB ON  PB.[BranchId]=Customer.Customer.BranchId 
--Where Customer.SlipSystem.SlipStatuId not in (2,4)  and Customer.SlipSystem.SlipStateId in (3,5)  
--and cast(DATEADD(HOUR,1,Customer.SlipSystem.EvaluateDate)) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
--and cast(DATEADD(HOUR,1,Customer.SlipSystem.EvaluateDate)) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
-- GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.SlipSystem.SystemSlipId,Customer.SlipSystem.SourceId '

--     SET @sqlcommand22 +=   ' insert @TempSummaryBet (ParentBranch,WonSlipCount ,WonSlipAmount ,WonSlipPayOut,BranchName,SourceId) '+
--    'select (select P.BrancName from Parameter.Branch as P where P.BranchId=PB.ParentBranchId), COUNT(Customer.SlipSystem.SystemSlipId)
--,ISNULL((Select SUM(Archive.Slip.Amount) from Archive.Slip where  Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip as CS where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)
--,ISNULL((Select SUM(Archive.Slip.TotalOddValue*Archive.Slip.Amount) from Archive.Slip where Archive.Slip.SlipStateId in (3,6) and Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip as CS where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)
--,PB.[BranchId]
--,Customer.SlipSystem.SourceId
--From Customer.SlipSystem inner join Customer.Customer on Customer.SlipSystem.CustomerId=Customer.Customer.CustomerId INNER JOIN
--  [Parameter].[Branch] as PB ON  PB.[BranchId]=Customer.Customer.BranchId 
--Where Customer.SlipSystem.SlipStatuId not in (2,4)  and Customer.SlipSystem.SlipStateId in (3,5)  
--and cast(DATEADD(HOUR,1,Customer.SlipSystem.EvaluateDate)) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
--and cast(DATEADD(HOUR,1,Customer.SlipSystem.EvaluateDate)) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
-- GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.SlipSystem.SystemSlipId,Customer.SlipSystem.SourceId '


    SET @sqlcommand221 +=   ' insert @TempSummaryBet (ParentBranch,Cashout,BranchName,SourceId) '+
  'select (select P.BrancName from Parameter.Branch  as P  where P.BranchId=PB.ParentBranchId)
,SUM(CustomerSlip.[CashoutSlipAmount])
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,CustomerSlip.SourceId
From Report.SummarySportBetting as CustomerSlip  inner join Customer.Customer  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and Customer.Customer.IsBranchCustomer=1  
and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,CustomerSlip.SourceId,PB.IsTerminal '

 

  SET @sqlcommand222 +=   ' insert @TempSummaryBet (ParentBranch,LostSlipCount ,LostSlipAmount,BranchName,SourceId) '+
   'select (select P.BrancName from Parameter.Branch  as P  where P.BranchId=PB.ParentBranchId), SUM(CustomerSlip.LostSlipCount)
,SUM(CustomerSlip.[OrgLostSlipAmount])
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,CustomerSlip.SourceId
From Report.SummarySportBetting as CustomerSlip  inner join Customer.Customer  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch  as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,CustomerSlip.SourceId,PB.IsTerminal '
  

 SET @sqlcommand222 +=   ' insert @TempSummaryBet (ParentBranch,CancelSlipCount ,CancelSlipAmount,BranchName,SourceId) '+
  'select (select P.BrancName from Parameter.Branch  as P  where P.BranchId=PB.ParentBranchId), COUNT(CustomerSlip.CancelSlipCount)
,SUM(CustomerSlip.[OrgCancelSlipAmount])
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,CustomerSlip.SourceId
From Report.SummarySportBetting as CustomerSlip  inner join Customer.Customer  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch  as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,CustomerSlip.SourceId,PB.IsTerminal '
 

  SET @sqlcommand2222 +=   ' insert @TempSummaryBet (ParentBranch,TaxCount ,TaxAmount,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch  as P  where P.BranchId=PB.ParentBranchId), COUNT(CustomerSlip.SlipCount)
,(SUM(CustomerSlip.[OrgSlipAmount])*5)/100
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,CustomerSlip.SourceId
From Report.SummarySportBetting as CustomerSlip with (nolock) inner join Customer.Customer with (nolock) on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and Customer.Customer.IsBranchCustomer=1  
and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,CustomerSlip.SourceId,PB.IsTerminal '

  
   

  SET @sqlcommand22222 +=   ' insert @TempSummaryBet (ParentBranch,PayOutCount ,PayOutAmount,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch  as P  where P.BranchId=PB.ParentBranchId), COUNT(CustomerSlip.PayOutCount)
,SUM(CustomerSlip.[OrgPayOutAmount])
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,CustomerSlip.SourceId
From Report.SummarySportBetting as CustomerSlip  inner join Customer.Customer  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch  as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,CustomerSlip.SourceId,PB.IsTerminal '
  
SET @sqlcommand2222 +=   ' insert @TempSummaryBet (ParentBranch, BranchTaxAmount,BranchName,SourceId) '+
    '	select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId)
	,SUM(dbo.FuncCurrencyConverter(ISNULL(Amount,0)*TotalOddValue,Customer.Slip.CurrencyId,'+cast(@UserCurrencyId as nvarchar(10))+')) As Total
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,Customer.Slip.SourceId 
from Customer.Slip with (nolock) INNER JOIN Customer.Customer
ON Customer.Customer.CustomerId=Customer.Slip.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
where (IsPayOut=0 or IsPayOut is null) and SlipStateId in (2,3,5,6)  
 and ( IsBranchCustomer=1) and Customer.Slip.SlipTypeId<3 and cast( DATEADD(HOUR,1,Customer.Slip.EvaluateDate ) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( DATEADD(HOUR,1,Customer.Slip.EvaluateDate ) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.Slip.SourceId,PB.IsTerminal '

  SET @sqlcommand2222 +=' insert @TempSummaryBet (ParentBranch, BranchTaxAmount,BranchName,SourceId) '+
    '	select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId)
	, SUM(dbo.FuncCurrencyConverter(ISNULL(Amount,0)*TotalOddValue,Archive.Slip.CurrencyId,'+cast(@UserCurrencyId as nvarchar(10))+')) As Total
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,Archive.Slip.SourceId 
from Archive.Slip with (nolock) INNER JOIN Customer.Customer
ON Customer.Customer.CustomerId=Archive.Slip.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
where (IsPayOut=0 or IsPayOut is null) and SlipStateId in (2,3,5,6)  
 and ( IsBranchCustomer=1) and Archive.Slip.SlipTypeId<3 and cast( DATEADD(HOUR,1,Archive.Slip.EvaluateDate) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( DATEADD(HOUR,1,Archive.Slip.EvaluateDate) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Archive.Slip.SourceId,PB.IsTerminal '


  SET @sqlcommand2222 +=   ' insert @TempSummaryBet (ParentBranch, BranchTaxAmount,BranchName,SourceId) '+
    '	select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId)
	,cast(ISNULL((Select SUM(dbo.FuncCurrencyConverter(ISNULL(Amount,0)*TotalOddValue,Customer.Slip.CurrencyId,'+cast(@UserCurrencyId as nvarchar(10))+'))
 from Customer.Slip where Customer.Slip.SlipStateId in (3,6) and Customer.Slip.SlipTypeId=3
  and Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) ),0) as money) 
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,Customer.SlipSystem.SourceId 
from Customer.SlipSystem INNER JOIN Customer.Customer
ON Customer.Customer.CustomerId=Customer.SlipSystem.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
where (IsPayOut=0 or IsPayOut is null) and SlipStateId in (2,3,5,6)  
 and ( IsBranchCustomer=1)  and cast( DATEADD(HOUR,1,Customer.SlipSystem.EvaluateDate) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( DATEADD(HOUR,1,Customer.SlipSystem.EvaluateDate) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.SlipSystem.SourceId,Customer.SlipSystem.SystemSlipId,PB.IsTerminal '

   SET @sqlcommand2222 +=   ' insert @TempSummaryBet (ParentBranch, BranchTaxAmount,BranchName,SourceId) '+
    '	select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId)
	,cast(ISNULL((Select SUM(dbo.FuncCurrencyConverter(ISNULL(Amount,0)*TotalOddValue,Archive.Slip.CurrencyId,'+cast(@UserCurrencyId as nvarchar(10))+'))
 from Archive.Slip where Archive.Slip.SlipStateId in (3,6) and Archive.Slip.SlipTypeId=3
  and Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) ),0) as money) 
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,Customer.SlipSystem.SourceId 
from Customer.SlipSystem INNER JOIN Customer.Customer
ON Customer.Customer.CustomerId=Customer.SlipSystem.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
where (IsPayOut=0 or IsPayOut is null) and SlipStateId in (2,3,5,6)  
 and ( IsBranchCustomer=1)  and cast( DATEADD(HOUR,1,Customer.SlipSystem.EvaluateDate) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( DATEADD(HOUR,1,Customer.SlipSystem.EvaluateDate) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.SlipSystem.SourceId,Customer.SlipSystem.SystemSlipId,PB.IsTerminal '   
-- SET @sqlcommand22222 +=   ' insert @TempSummaryBet (ParentBranch,PartnerTurnOver ,BranchTaxAmount,BranchName,SourceId) '+
--    '	 SELECT (select ppp.BrancName COLLATE SQL_Latin1_General_CP1_CI_AS from Parameter.Branch as ppp with (nolock) where ppp.BranchId in (select pp.ParentBranchId from Parameter.Branch as pp with (nolock) where pp.BrancName COLLATE SQL_Latin1_General_CP1_CI_AS=tp.ParentBranch))
--, SUM(SlipAmount)-(sum(WonSlipPayOut)+ISNULL(sum(Cashout),0)+ISNULL(sum(PayOutAmount),0)+ISNULL(sum(CancelSlipAmount),0)) as Profit
-- ,SUM(TaxAmount) as TaxAmount
-- ,TP.ParentBranch COLLATE SQL_Latin1_General_CP1_CI_AS
-- ,TP.SourceId
-- FROM @TempSummaryBet as TP 
-- where (TP.ParentBranch in (select ppp.BrancName COLLATE SQL_Latin1_General_CP1_CI_AS from Parameter.Branch as ppp with (nolock) where ppp.BranchId in (select pp.ParentBranchId from Parameter.Branch as pp with (nolock) where pp.BrancName COLLATE SQL_Latin1_General_CP1_CI_AS=tp.BranchName))) 
-- GROUP BY  TP.[BranchName],TP.ParentBranch ,TP.SourceId   HAVING SUM(SlipAmount) is not null'

 --set @sqlcommand9 +=' insert @TempSummaryBet (ParentBranch,BranchName ,SlipAmount,WonSlipPayOut,CancelSlipAmount,PayOutAmount,Turnover,PartnerTurnOver,OpenSlipAmount,TaxAmount,BranchTaxAmount,SourceId,Cashout)
 -- SELECT ''Total''
 -- ,''''
 -- ,SUM(SlipAmount) AS TurnOver
 --,ISNULL(sum(WonSlipPayOut),0) as CustomerWining
 --,ISNULL(SUM(CancelSlipAmount),0) as CancelBet
 --,ISNULL(SUM(PayOutAmount),0) 
 -- ,ISNULL(SUM(SlipAmount),0)-(ISNULL(sum(WonSlipPayOut),0)+ISNULL(sum(Cashout),0)+ISNULL(SUM(CancelSlipAmount),0)+ISNULL(SUM(PayOutAmount),0)) as Profit
 -- ,0 as PartnerProfit
  
 --,ISNULL(SUM(OpenSlipAmount),0) as Unsettled
 --,ISNULL(SUM(TaxAmount),0) as Tax
 --,0 as BranchTaxAmount
 --,SourceId
 --,ISNULL(SUM(Cashout),0)
 --  FROM @TempSummaryBet GROUP BY SourceId    HAVING SUM(SlipAmount) is not null '




	set @sqlcommand9+=' declare @TempSummaryBet3 table (ParentBranch nvarchar(50),SlipCount int,SlipAmount money,OpenSlipCount int,OpenSlipAmount money,OpenSlipPayOut money,WonSlipCount int,WonSlipAmount money,WonSlipPayOut money,LostSlipCount int,LostSlipAmount money,CancelSlipCount int,CancelSlipAmount money,TurnOver money,PartnerTurnOver money,BranchName nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS,TaxCount int,TaxAmount money,BranchTaxAmount money,PayOutCount int,PayOutAmount money,Cashout money,Bonus money) '+
  ' insert @TempSummaryBet3 '+
  '   SELECT tp2.ParentBranch,SUM(ISNULL(SlipCount,0))
,SUM(ISNULL(SlipAmount,0)),SUM(ISNULL(OpenSlipCount,0)),SUM(ISNULL(OpenSlipAmount,0)),SUM(ISNULL(OpenSlipPayOut,0)),SUM(ISNULL(WonSlipCount,0)) ,SUM(ISNULL(WonSlipAmount,0))
,SUM(ISNULL(WonSlipPayOut,0)),SUM(ISNULL(LostSlipCount,0)),SUM(ISNULL(LostSlipAmount,0)),SUM(ISNULL(CancelSlipCount,0)),SUM(ISNULL(CancelSlipAmount,0)),SUM(ISNULL(SlipAmount,0))-(SUM(ISNULL(WonSlipPayOut,0))+SUM(ISNULL(Cashout,0))+ISNULL(SUM(CancelSlipAmount),0)) as TurnOver
,(SUM(ISNULL(WonSlipPayOut,0))+SUM(ISNULL(Cashout,0))+ISNULL(SUM(CancelSlipAmount),0))
,tp2.BranchName,SUM(ISNULL(TaxCount,0)),SUM(ISNULL(TaxAmount,0)),SUM(ISNULL(BranchTaxAmount,0)),SUM(ISNULL(PayOutCount,0)),SUM(ISNULL(PayOutAmount,0)),SUM(ISNULL(Cashout,0)),SUM(ISNULL(Bonus,0))
     FROM @TempSummaryBet as tp2 where 1=1  '+@where3 +
	' GROUP BY BranchName,ParentBranch  HAVING SUM(SlipAmount) is not null'


		set @sqlcommand9+=  ' insert @TempSummaryBet3 '+
  '   SELECT ''Total'',SUM(ISNULL(SlipCount,0))
,SUM(ISNULL(SlipAmount,0)),SUM(ISNULL(OpenSlipCount,0)),SUM(ISNULL(OpenSlipAmount,0)),SUM(ISNULL(OpenSlipPayOut,0)),SUM(ISNULL(WonSlipCount,0)) ,SUM(ISNULL(WonSlipAmount,0))
,SUM(ISNULL(WonSlipPayOut,0)),SUM(ISNULL(LostSlipCount,0)),SUM(ISNULL(LostSlipAmount,0)),SUM(ISNULL(CancelSlipCount,0)),SUM(ISNULL(CancelSlipAmount,0)),SUM(ISNULL(SlipAmount,0))-(SUM(ISNULL(WonSlipPayOut,0))+SUM(ISNULL(Cashout,0))+ISNULL(SUM(CancelSlipAmount),0)) as TurnOver
,(SUM(ISNULL(WonSlipPayOut,0))+SUM(ISNULL(Cashout,0))+ISNULL(SUM(CancelSlipAmount),0))
,''Total'',SUM(ISNULL(TaxCount,0)),SUM(ISNULL(TaxAmount,0)),SUM(ISNULL(BranchTaxAmount,0)),SUM(ISNULL(PayOutCount,0)),SUM(ISNULL(PayOutAmount,0)),SUM(ISNULL(Cashout,0)),SUM(ISNULL(Bonus,0))
     FROM @TempSummaryBet as tp2 where 1=1  '+@where3 


	
  set @sqlcommand=' declare @total int '+
'select @total=COUNT(SlipCount)  '+
'FROM        @TempSummaryBet3 as tmp LEFT OUTER JOIN Parameter.Branch On tmp.BranchName=Parameter.Branch.BrancName
WHERE    1=1 ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
'	 ParentBranch ,ISNULL([SlipCount],0)  as [SlipCount]
       ,ISNULL(SlipAmount,0) as [SlipAmount]
      ,ISNULL([OpenSlipCount],0)  as [OpenSlipCount]
      ,ISNULL([OpenSlipAmount],0)  as [OpenSlipAmount]
      ,ISNULL([OpenSlipPayOut],0)  as [OpenSlipPayOut]
      ,ISNULL([WonSlipCount],0)  as [WonSlipCount]
      ,ISNULL([WonSlipAmount],0) as [WonSlipAmount]
      ,ISNULL([WonSlipPayOut],0)  as [WonSlipPayOut]
      ,ISNULL([LostSlipCount],0)  as [LostSlipCount]
      ,ISNULL([LostSlipAmount],0)  as [LostSlipAmount]
      ,ISNULL([CancelSlipCount],0)  as [CancelSlipCount]
      ,ISNULL([CancelSlipAmount],0) as [CancelSlipAmount]
      ,cast(0 as money) as SumTurnOver
	  ,BranchName
	  ,(ISNULL(PartnerTurnOver,0)) as BranchTurnOver
	  ,ISNULL(TurnOver,0) as TurnOver
	  ,ISNULL([TaxCount],0)  as [TaxCount]
      ,ISNULL(ISNULL([TaxAmount],0),0)  as [TaxAmount]
	  ,ISNULL(ISNULL([BranchTaxAmount],0),0)  as [BranchTaxAmount]
	  ,ISNULL(ISNULL([TaxAmount],0),0)+ISNULL(ISNULL([BranchTaxAmount],0),0) as SumTaxAmount
	  ,ISNULL([PayOutCount],0)  as [PayOutCount]
      ,ISNULL(ISNULL([PayOutAmount],0),0)  as PayOutAmount,ISNULL(ISNULL([Cashout],0),0)  as Cashout,ISNULL(ISNULL([Bonus],0),0)  as Bonus ,cast(0 as money)  as OnlineDeposit,cast(0 as money)  as OnlineWithDraw '+
'FROM         @TempSummaryBet3 as tmp LEFT OUTER JOIN Parameter.Branch On tmp.BranchName=Parameter.Branch.BrancName
WHERE  1=1 '+
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '

end
else 
begin

 set @sqlcommand2=' declare @TempSummaryBet table (ParentBranch nvarchar(50),SlipCount int,SlipAmount money,OpenSlipCount int,OpenSlipAmount money,OpenSlipPayOut money,WonSlipCount int,WonSlipAmount money,WonSlipPayOut money,LostSlipCount int,LostSlipAmount money,CancelSlipCount int,CancelSlipAmount money,TurnOver money,PartnerTurnOver money,BranchName nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS,TaxCount int,TaxAmount money,BranchTaxAmount money,PayOutCount int,PayOutAmount money,SourceId int,Cashout money,Bonus money) '+
  'insert @TempSummaryBet (ParentBranch,SlipCount,SlipAmount,BranchName,SourceId) '+
  'select (select P.BrancName from Parameter.Branch  as P  where P.BranchId=PB.ParentBranchId), COUNT(CustomerSlip.SlipCount)
,SUM(CustomerSlip.SlipAmount)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,CustomerSlip.SourceId
From Report.SummarySportBetting as CustomerSlip with (nolock) inner join Customer.Customer with (nolock) on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and Customer.Customer.IsBranchCustomer=1  
and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,CustomerSlip.SourceId,PB.IsTerminal '

 
  SET @sqlcommand2 +=   ' insert @TempSummaryBet (ParentBranch,OpenSlipCount,OpenSlipAmount,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId), COUNT(Customer.Slip.SlipId)
,SUM(dbo.FuncCurrencyConverter(Customer.Slip.Amount,Customer.Slip.CurrencyId,'+cast(@UserCurrencyId as nvarchar(10))+'))
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,Customer.Slip.SourceId
From Customer.Slip with (nolock) inner join Customer.Customer with (nolock) on Customer.Slip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where Customer.Customer.IsBranchCustomer=1 and Customer.Slip.SlipStatu not in (2,4)  and Customer.Slip.SlipStateId=1 and Customer.Slip.SlipTypeId<3
and cast(DATEADD(HOUR,1,Customer.Slip.CreateDate) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(DATEADD(HOUR,1,Customer.Slip.CreateDate) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.Slip.SourceId,PB.IsTerminal '
 

    SET @sqlcommand2 +=   ' insert @TempSummaryBet (ParentBranch,OpenSlipCount,OpenSlipAmount,BranchName,SourceId) '+
        'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId), COUNT(Customer.SlipSystem.SystemSlipId)
,SUM( Customer.SlipSystem.Amount)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,Customer.SlipSystem.SourceId
From Customer.SlipSystem with (nolock) inner join Customer.Customer with (nolock) on Customer.SlipSystem.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  Customer.Customer.IsBranchCustomer=1 and  Customer.SlipSystem.SlipStateId=1  and Customer.SlipSystem.NewSlipTypeId in (4,5)
and cast( DATEADD(HOUR,1,Customer.SlipSystem.CreateDate) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( DATEADD(HOUR,1,Customer.SlipSystem.CreateDate) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.SlipSystem.SourceId,PB.IsTerminal '


   SET @sqlcommand22 +=   ' insert @TempSummaryBet (ParentBranch,WonSlipCount ,WonSlipAmount ,WonSlipPayOut,BranchName,SourceId) '+
     'select (select P.BrancName from Parameter.Branch as P  where P.BranchId=PB.ParentBranchId), SUM(CustomerSlip.WonSlipCount)
,SUM(CustomerSlip.WonSlipAmount)
,SUM(WonSlipPayOut)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,CustomerSlip.SourceId
From Report.SummarySportBetting as CustomerSlip  inner join Customer.Customer  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where CustomerSlip.Isview=1 and Customer.Customer.IsBranchCustomer=1  
and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,CustomerSlip.SourceId,PB.IsTerminal '
  

       SET @sqlcommand22 +=   ' insert @TempSummaryBet (ParentBranch,Bonus,BranchName,SourceId ) '+
    'select (select P.BrancName from Parameter.Branch as P  where P.BranchId=PB.ParentBranchId), SUM(CustomerSlip.Amount)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end,1
From Customer.[Transaction] as CustomerSlip with (nolock)  inner join Customer.Customer with (nolock)  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
   Parameter.Branch  as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where Customer.Customer.IsTerminalCustomer=0 and Customer.Customer.IsBranchCustomer=0 and CustomerSlip.TransactionTypeId=35 and  cast( CustomerSlip.TransactionDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( CustomerSlip.TransactionDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal '

--    SET @sqlcommand22 +=   ' insert @TempSummaryBet (ParentBranch,WonSlipCount ,WonSlipAmount ,WonSlipPayOut,BranchName,SourceId) '+
--    'select (select P.BrancName from Parameter.Branch as P where P.BranchId=PB.ParentBranchId), COUNT(Archive.Slip.SlipId)
--,SUM(Archive.Slip.Amount)
--,SUM(Archive.Slip.Amount*Archive.Slip.TotalOddValue)
--,PB.[BranchId]
--,Archive.Slip.SourceId
--From Archive.Slip inner join Customer.Customer on Archive.Slip.CustomerId=Customer.Customer.CustomerId INNER JOIN
--  [Parameter].[Branch] as PB ON  PB.[BranchId]=Customer.Customer.BranchId 
--Where Archive.Slip.SlipStatu not in (2,4)  and Archive.Slip.SlipStateId in (3,5) and Archive.Slip.SlipTypeId<>3
--and cast(DATEADD(HOUR,1,Archive.Slip.EvaluateDate)) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
--and cast(DATEADD(HOUR,1,Archive.Slip.EvaluateDate)) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
-- GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Archive.Slip.SourceId '

--    SET @sqlcommand22 +=   ' insert @TempSummaryBet (ParentBranch,WonSlipCount ,WonSlipAmount ,WonSlipPayOut,BranchName,SourceId) '+
--    'select (select P.BrancName from Parameter.Branch as P where P.BranchId=PB.ParentBranchId), COUNT(Customer.SlipSystem.SystemSlipId)
--,ISNULL((Select SUM(Customer.Slip.Amount) from Customer.Slip where  Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip as CS where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)
--,ISNULL((Select SUM(Customer.Slip.TotalOddValue*Customer.Slip.Amount) from Customer.Slip where Customer.Slip.SlipStateId in (3,6) and Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip as CS where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)
--,PB.[BranchId]
--,Customer.SlipSystem.SourceId
--From Customer.SlipSystem inner join Customer.Customer on Customer.SlipSystem.CustomerId=Customer.Customer.CustomerId INNER JOIN
--  [Parameter].[Branch] as PB ON  PB.[BranchId]=Customer.Customer.BranchId 
--Where Customer.SlipSystem.SlipStatuId not in (2,4)  and Customer.SlipSystem.SlipStateId in (3,5)  
--and cast(DATEADD(HOUR,1,Customer.SlipSystem.EvaluateDate)) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
--and cast(DATEADD(HOUR,1,Customer.SlipSystem.EvaluateDate)) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
-- GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.SlipSystem.SystemSlipId,Customer.SlipSystem.SourceId '

--     SET @sqlcommand22 +=   ' insert @TempSummaryBet (ParentBranch,WonSlipCount ,WonSlipAmount ,WonSlipPayOut,BranchName,SourceId) '+
--    'select (select P.BrancName from Parameter.Branch as P where P.BranchId=PB.ParentBranchId), COUNT(Customer.SlipSystem.SystemSlipId)
--,ISNULL((Select SUM(Archive.Slip.Amount) from Archive.Slip where  Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip as CS where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)
--,ISNULL((Select SUM(Archive.Slip.TotalOddValue*Archive.Slip.Amount) from Archive.Slip where Archive.Slip.SlipStateId in (3,6) and Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip as CS where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)
--,PB.[BranchId]
--,Customer.SlipSystem.SourceId
--From Customer.SlipSystem inner join Customer.Customer on Customer.SlipSystem.CustomerId=Customer.Customer.CustomerId INNER JOIN
--  [Parameter].[Branch] as PB ON  PB.[BranchId]=Customer.Customer.BranchId 
--Where Customer.SlipSystem.SlipStatuId not in (2,4)  and Customer.SlipSystem.SlipStateId in (3,5)  
--and cast(DATEADD(HOUR,1,Customer.SlipSystem.EvaluateDate)) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
--and cast(DATEADD(HOUR,1,Customer.SlipSystem.EvaluateDate)) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
-- GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.SlipSystem.SystemSlipId,Customer.SlipSystem.SourceId '


    SET @sqlcommand221 +=   ' insert @TempSummaryBet (ParentBranch,Cashout,BranchName,SourceId) '+
  'select (select P.BrancName from Parameter.Branch  as P  where P.BranchId=PB.ParentBranchId)
,SUM(CustomerSlip.CashoutSlipAmount)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,CustomerSlip.SourceId
From Report.SummarySportBetting as CustomerSlip  inner join Customer.Customer  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where CustomerSlip.Isview=1 and Customer.Customer.IsBranchCustomer=1  
and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,CustomerSlip.SourceId,PB.IsTerminal '

 

  SET @sqlcommand222 +=   ' insert @TempSummaryBet (ParentBranch,LostSlipCount ,LostSlipAmount,BranchName,SourceId) '+
   'select (select P.BrancName from Parameter.Branch  as P  where P.BranchId=PB.ParentBranchId), SUM(CustomerSlip.LostSlipCount)
,SUM(CustomerSlip.LostSlipAmount)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,CustomerSlip.SourceId
From Report.SummarySportBetting as CustomerSlip  inner join Customer.Customer  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch  as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,CustomerSlip.SourceId,PB.IsTerminal '
  

 SET @sqlcommand222 +=   ' insert @TempSummaryBet (ParentBranch,CancelSlipCount ,CancelSlipAmount,BranchName,SourceId) '+
  'select (select P.BrancName from Parameter.Branch  as P  where P.BranchId=PB.ParentBranchId), COUNT(CustomerSlip.CancelSlipCount)
,SUM(CustomerSlip.CancelSlipAmount)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,CustomerSlip.SourceId
From Report.SummarySportBetting as CustomerSlip  inner join Customer.Customer  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch  as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,CustomerSlip.SourceId,PB.IsTerminal '
 

  SET @sqlcommand2222 +=   ' insert @TempSummaryBet (ParentBranch,TaxCount ,TaxAmount,BranchName,SourceId) '+
     'select (select P.BrancName from Parameter.Branch  as P  where P.BranchId=PB.ParentBranchId), COUNT(CustomerSlip.TaxCount)
,SUM(CustomerSlip.Tax)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,CustomerSlip.SourceId
From Report.SummarySportBetting as CustomerSlip  inner join Customer.Customer  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch  as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,CustomerSlip.SourceId,PB.IsTerminal '

  
   

  SET @sqlcommand22222 +=   ' insert @TempSummaryBet (ParentBranch,PayOutCount ,PayOutAmount,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch  as P  where P.BranchId=PB.ParentBranchId), COUNT(CustomerSlip.PayOutCount)
,SUM(CustomerSlip.PayOutAmount)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,CustomerSlip.SourceId
From Report.SummarySportBetting as CustomerSlip  inner join Customer.Customer  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch  as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and  cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,CustomerSlip.SourceId,PB.IsTerminal '
  
SET @sqlcommand2222 +=   ' insert @TempSummaryBet (ParentBranch, BranchTaxAmount,BranchName,SourceId) '+
    '	select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId)
	,SUM(dbo.FuncCurrencyConverter(ISNULL(Amount,0)*TotalOddValue,Customer.Slip.CurrencyId,'+cast(@UserCurrencyId as nvarchar(10))+')) As Total
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,Customer.Slip.SourceId 
from Customer.Slip with (nolock) INNER JOIN Customer.Customer
ON Customer.Customer.CustomerId=Customer.Slip.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
where (IsPayOut=0 or IsPayOut is null) and SlipStateId in (2,3,5,6)  
 and ( IsBranchCustomer=1) and Customer.Slip.SlipTypeId<3 and cast( DATEADD(HOUR,1,Customer.Slip.EvaluateDate ) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( DATEADD(HOUR,1,Customer.Slip.EvaluateDate ) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.Slip.SourceId,PB.IsTerminal '

  SET @sqlcommand2222 +=' insert @TempSummaryBet (ParentBranch, BranchTaxAmount,BranchName,SourceId) '+
    '	select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId)
	, SUM(dbo.FuncCurrencyConverter(ISNULL(Amount,0)*TotalOddValue,Archive.Slip.CurrencyId,'+cast(@UserCurrencyId as nvarchar(10))+')) As Total
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,Archive.Slip.SourceId 
from Archive.Slip with (nolock) INNER JOIN Customer.Customer
ON Customer.Customer.CustomerId=Archive.Slip.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
where (IsPayOut=0 or IsPayOut is null) and SlipStateId in (2,3,5,6)  
 and ( IsBranchCustomer=1) and Archive.Slip.SlipTypeId<3 and cast( DATEADD(HOUR,1,Archive.Slip.EvaluateDate) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( DATEADD(HOUR,1,Archive.Slip.EvaluateDate) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Archive.Slip.SourceId,PB.IsTerminal '


  SET @sqlcommand2222 +=   ' insert @TempSummaryBet (ParentBranch, BranchTaxAmount,BranchName,SourceId) '+
    '	select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId)
	,cast(ISNULL((Select SUM(dbo.FuncCurrencyConverter(ISNULL(Amount,0)*TotalOddValue,Customer.Slip.CurrencyId,'+cast(@UserCurrencyId as nvarchar(10))+'))
 from Customer.Slip where Customer.Slip.SlipStateId in (3,6) and Customer.Slip.SlipTypeId=3
  and Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) ),0) as money) 
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,Customer.SlipSystem.SourceId 
from Customer.SlipSystem INNER JOIN Customer.Customer
ON Customer.Customer.CustomerId=Customer.SlipSystem.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
where (IsPayOut=0 or IsPayOut is null) and SlipStateId in (2,3,5,6)  
 and ( IsBranchCustomer=1)  and cast( DATEADD(HOUR,1,Customer.SlipSystem.EvaluateDate) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( DATEADD(HOUR,1,Customer.SlipSystem.EvaluateDate) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.SlipSystem.SourceId,Customer.SlipSystem.SystemSlipId,PB.IsTerminal '

   SET @sqlcommand2222 +=   ' insert @TempSummaryBet (ParentBranch, BranchTaxAmount,BranchName,SourceId) '+
    '	select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId)
	,cast(ISNULL((Select SUM(dbo.FuncCurrencyConverter(ISNULL(Amount,0)*TotalOddValue,Archive.Slip.CurrencyId,'+cast(@UserCurrencyId as nvarchar(10))+'))
 from Archive.Slip where Archive.Slip.SlipStateId in (3,6) and Archive.Slip.SlipTypeId=3
  and Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) ),0) as money) 
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
,Customer.SlipSystem.SourceId 
from Customer.SlipSystem INNER JOIN Customer.Customer
ON Customer.Customer.CustomerId=Customer.SlipSystem.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
where (IsPayOut=0 or IsPayOut is null) and SlipStateId in (2,3,5,6)  
 and ( IsBranchCustomer=1)  and cast( DATEADD(HOUR,1,Customer.SlipSystem.EvaluateDate) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( DATEADD(HOUR,1,Customer.SlipSystem.EvaluateDate) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.SlipSystem.SourceId,Customer.SlipSystem.SystemSlipId,PB.IsTerminal '   
-- SET @sqlcommand22222 +=   ' insert @TempSummaryBet (ParentBranch,PartnerTurnOver ,BranchTaxAmount,BranchName,SourceId) '+
--    '	 SELECT (select ppp.BrancName COLLATE SQL_Latin1_General_CP1_CI_AS from Parameter.Branch as ppp with (nolock) where ppp.BranchId in (select pp.ParentBranchId from Parameter.Branch as pp with (nolock) where pp.BrancName COLLATE SQL_Latin1_General_CP1_CI_AS=tp.ParentBranch))
--, SUM(SlipAmount)-(sum(WonSlipPayOut)+ISNULL(sum(Cashout),0)+ISNULL(sum(PayOutAmount),0)+ISNULL(sum(CancelSlipAmount),0)) as Profit
-- ,SUM(TaxAmount) as TaxAmount
-- ,TP.ParentBranch COLLATE SQL_Latin1_General_CP1_CI_AS
-- ,TP.SourceId
-- FROM @TempSummaryBet as TP 
-- where (TP.ParentBranch in (select ppp.BrancName COLLATE SQL_Latin1_General_CP1_CI_AS from Parameter.Branch as ppp with (nolock) where ppp.BranchId in (select pp.ParentBranchId from Parameter.Branch as pp with (nolock) where pp.BrancName COLLATE SQL_Latin1_General_CP1_CI_AS=tp.BranchName))) 
-- GROUP BY  TP.[BranchName],TP.ParentBranch ,TP.SourceId   HAVING SUM(SlipAmount) is not null'

 --set @sqlcommand9 +=' insert @TempSummaryBet (ParentBranch,BranchName ,SlipAmount,WonSlipPayOut,CancelSlipAmount,PayOutAmount,Turnover,PartnerTurnOver,OpenSlipAmount,TaxAmount,BranchTaxAmount,SourceId,Cashout)
 -- SELECT ''Total''
 -- ,''''
 -- ,SUM(SlipAmount) AS TurnOver
 --,ISNULL(sum(WonSlipPayOut),0) as CustomerWining
 --,ISNULL(SUM(CancelSlipAmount),0) as CancelBet
 --,ISNULL(SUM(PayOutAmount),0) 
 -- ,ISNULL(SUM(SlipAmount),0)-(ISNULL(sum(WonSlipPayOut),0)+ISNULL(sum(Cashout),0)+ISNULL(SUM(CancelSlipAmount),0)+ISNULL(SUM(PayOutAmount),0)) as Profit
 -- ,0 as PartnerProfit
  
 --,ISNULL(SUM(OpenSlipAmount),0) as Unsettled
 --,ISNULL(SUM(TaxAmount),0) as Tax
 --,0 as BranchTaxAmount
 --,SourceId
 --,ISNULL(SUM(Cashout),0)
 --  FROM @TempSummaryBet GROUP BY SourceId    HAVING SUM(SlipAmount) is not null '




	set @sqlcommand9+=' declare @TempSummaryBet3 table (ParentBranch nvarchar(50),SlipCount int,SlipAmount money,OpenSlipCount int,OpenSlipAmount money,OpenSlipPayOut money,WonSlipCount int,WonSlipAmount money,WonSlipPayOut money,LostSlipCount int,LostSlipAmount money,CancelSlipCount int,CancelSlipAmount money,TurnOver money,PartnerTurnOver money,BranchName nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS,TaxCount int,TaxAmount money,BranchTaxAmount money,PayOutCount int,PayOutAmount money,Cashout money,Bonus money) '+
  ' insert @TempSummaryBet3 '+
  '   SELECT tp2.ParentBranch,SUM(ISNULL(SlipCount,0))
,SUM(ISNULL(SlipAmount,0)),SUM(ISNULL(OpenSlipCount,0)),SUM(ISNULL(OpenSlipAmount,0)),SUM(ISNULL(OpenSlipPayOut,0)),SUM(ISNULL(WonSlipCount,0)) ,SUM(ISNULL(WonSlipAmount,0))
,SUM(ISNULL(WonSlipPayOut,0)),SUM(ISNULL(LostSlipCount,0)),SUM(ISNULL(LostSlipAmount,0)),SUM(ISNULL(CancelSlipCount,0)),SUM(ISNULL(CancelSlipAmount,0)),SUM(ISNULL(SlipAmount,0))-(SUM(ISNULL(WonSlipPayOut,0))+SUM(ISNULL(Cashout,0))+ISNULL(SUM(CancelSlipAmount),0)) as TurnOver
,(SUM(ISNULL(WonSlipPayOut,0))+SUM(ISNULL(Cashout,0))+ISNULL(SUM(CancelSlipAmount),0))
,tp2.BranchName,SUM(ISNULL(TaxCount,0)),SUM(ISNULL(TaxAmount,0)),SUM(ISNULL(BranchTaxAmount,0)),SUM(ISNULL(PayOutCount,0)),SUM(ISNULL(PayOutAmount,0)),SUM(ISNULL(Cashout,0)),SUM(ISNULL(Bonus,0))
     FROM @TempSummaryBet as tp2 where 1=1  '+@where3 +
	' GROUP BY BranchName,ParentBranch  HAVING SUM(SlipAmount) is not null'

	
		set @sqlcommand9+=  ' insert @TempSummaryBet3 '+
  '   SELECT ''Total'',SUM(ISNULL(SlipCount,0))
,SUM(ISNULL(SlipAmount,0)),SUM(ISNULL(OpenSlipCount,0)),SUM(ISNULL(OpenSlipAmount,0)),SUM(ISNULL(OpenSlipPayOut,0)),SUM(ISNULL(WonSlipCount,0)) ,SUM(ISNULL(WonSlipAmount,0))
,SUM(ISNULL(WonSlipPayOut,0)),SUM(ISNULL(LostSlipCount,0)),SUM(ISNULL(LostSlipAmount,0)),SUM(ISNULL(CancelSlipCount,0)),SUM(ISNULL(CancelSlipAmount,0)),SUM(ISNULL(SlipAmount,0))-(SUM(ISNULL(WonSlipPayOut,0))+SUM(ISNULL(Cashout,0))+ISNULL(SUM(CancelSlipAmount),0)) as TurnOver
,(SUM(ISNULL(WonSlipPayOut,0))+SUM(ISNULL(Cashout,0))+ISNULL(SUM(CancelSlipAmount),0))
,''Total'',SUM(ISNULL(TaxCount,0)),SUM(ISNULL(TaxAmount,0)),SUM(ISNULL(BranchTaxAmount,0)),SUM(ISNULL(PayOutCount,0)),SUM(ISNULL(PayOutAmount,0)),SUM(ISNULL(Cashout,0)),SUM(ISNULL(Bonus,0))
     FROM @TempSummaryBet as tp2 where 1=1  '+@where3 
	
  set @sqlcommand=' declare @total int '+
'select @total=COUNT(SlipCount)  '+
'FROM        @TempSummaryBet3 as tmp LEFT OUTER JOIN Parameter.Branch On tmp.BranchName=Parameter.Branch.BrancName
WHERE    1=1 ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
'	 ParentBranch ,ISNULL([SlipCount],0)  as [SlipCount]
       ,ISNULL(dbo.FuncCurrencyConverter(SlipAmount,3,'+cast(@UserCurrencyId as nvarchar(10))+'),0) as [SlipAmount]
      ,ISNULL([OpenSlipCount],0)  as [OpenSlipCount]
      ,ISNULL([OpenSlipAmount],0)  as [OpenSlipAmount]
      ,ISNULL([OpenSlipPayOut],0)  as [OpenSlipPayOut]
      ,ISNULL([WonSlipCount],0)  as [WonSlipCount]
      ,ISNULL(dbo.FuncCurrencyConverter(WonSlipAmount,3,'+cast(@UserCurrencyId as nvarchar(10))+'),0) as [WonSlipAmount]
      ,ISNULL(dbo.FuncCurrencyConverter(WonSlipPayOut,3,'+cast(@UserCurrencyId as nvarchar(10))+'),0)  as [WonSlipPayOut]
      ,ISNULL([LostSlipCount],0)  as [LostSlipCount]
      ,ISNULL(dbo.FuncCurrencyConverter(LostSlipAmount,3,'+cast(@UserCurrencyId as nvarchar(10))+'),0)  as [LostSlipAmount]
      ,ISNULL([CancelSlipCount],0)  as [CancelSlipCount]
      ,ISNULL(dbo.FuncCurrencyConverter(CancelSlipAmount,3,'+cast(@UserCurrencyId as nvarchar(10))+'),0) as [CancelSlipAmount]
      ,cast(0 as money) as SumTurnOver
	  ,BranchName
	  ,ISNULL(dbo.FuncCurrencyConverter(PartnerTurnOver,3,'+cast(@UserCurrencyId as nvarchar(10))+'),0) as BranchTurnOver
	  ,ISNULL(dbo.FuncCurrencyConverter(TurnOver,3,'+cast(@UserCurrencyId as nvarchar(10))+'),0) as TurnOver
	  ,ISNULL([TaxCount],0)  as [TaxCount]
      ,ISNULL(ISNULL(dbo.FuncCurrencyConverter(TaxAmount,3,'+cast(@UserCurrencyId as nvarchar(10))+'),0),0)  as [TaxAmount]
	  ,  [BranchTaxAmount]
	  ,cast(0 as money) as SumTaxAmount
	  ,ISNULL([PayOutCount],0)  as [PayOutCount]
      ,ISNULL(ISNULL(dbo.FuncCurrencyConverter(PayOutAmount,3,'+cast(@UserCurrencyId as nvarchar(10))+'),0),0)  as PayOutAmount
	  ,ISNULL(ISNULL(dbo.FuncCurrencyConverter(Cashout,3,'+cast(@UserCurrencyId as nvarchar(10))+'),0),0)  as Cashout,ISNULL(ISNULL(dbo.FuncCurrencyConverter(Bonus,3,'+cast(@UserCurrencyId as nvarchar(10))+'),0),0)  as Bonus,cast(0 as money)  as OnlineDeposit,cast(0 as money)  as OnlineWithDraw '+
'FROM         @TempSummaryBet3 as tmp LEFT OUTER JOIN Parameter.Branch On tmp.BranchName=Parameter.Branch.BrancName
WHERE  1=1 '+
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '

end
 --select @sqlcommand2+@sqlcommand22+@sqlcommand221+@sqlcommand222+@sqlcommand2222+@sqlcommand22222+@sqlcommand9+@sqlcommand

 exec (@sqlcommandBranch+@sqlcommand2+@sqlcommand22+@sqlcommand221+@sqlcommand222+@sqlcommand2222+@sqlcommand22222+@sqlcommand9+@sqlcommand)

 end
 else if  (@SourceId=4) -- Terminal
 begin
 exec Report.ProcSummarySportBettingFill1
 
  if(@BranchId not in (1,31970))
	begin

	--set @where2=' PB.BranchId in (select BranchId from Parameter.Branch where IsTerminal=1 and ( ParentBranchId='+cast(@BranchId as nvarchar(7))+ ' ))'  
	set @where2=' (PB.BranchId in (select BranchId from Parameter.Branch with (nolock) where IsTerminal=1 and ParentBranchId in  (select BranchId from Parameter.Branch with (nolock) where  ( ParentBranchId='+cast(@BranchId as nvarchar(7))+ ' ))  ) or PB.BranchId in (select BranchId from Parameter.Branch where IsTerminal=1 and BranchId in  (select BranchId from Parameter.Branch where  ( ParentBranchId='+cast(@BranchId as nvarchar(7))+ ' ))  ))' 
	--set @whereTerminal='  Customer.BranchId in (select BranchId from Parameter.Branch where IsTerminal=1 and (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId in (select BranchId from Parameter.Branch   where IsTerminal=0 and (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ') )))'  

	end
	else
	set @where2=' PB.BranchId in (select BranchId from Parameter.Branch with (nolock) where IsTerminal=1 ) '
	 

	if(@SourceId=4)
		set @SourceId=5

	 if(@SourceId=0)
	set @where3=@where3+' and SourceId in (select SourceId from Parameter.Source with (nolock)) '
else if(@SourceId=1)
	set @where3=@where3+' and SourceId in (1,2) '
else
	set @where3=@where3+' and SourceId='+cast(@SourceId as nvarchar(7)) 



if(@BranchId<>1)
begin
	
		set @sqlcommandBranch=' declare @TempBranchtable table (BranchId bigint) '+
' insert @TempBranchtable select BranchId from Parameter.Branch with (nolock) where IsTerminal=1 and ( BranchId in (select BranchId from Parameter.Branch with (nolock)  where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId in (select BranchId from Parameter.Branch with (nolock) where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ') ))) or ParentBranchId in (select BranchId from Parameter.Branch with (nolock)  where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId in (select BranchId from Parameter.Branch with (nolock) where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ') ))) ) '




set @where2= ' ( PB.BranchId in (select BranchId from @TempBranchtable) or PB.ParentBranchId in (select BranchId from @TempBranchtable)) '
 


 set @sqlcommand2T=' declare @TempSummaryBet table (ParentBranch nvarchar(50),SlipCount int,SlipAmount money,OpenSlipCount int,OpenSlipAmount money,OpenSlipPayOut money,WonSlipCount int,WonSlipAmount money,WonSlipPayOut money,LostSlipCount int,LostSlipAmount money,CancelSlipCount int,CancelSlipAmount money,TurnOver money,PartnerTurnOver money,BranchName nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS,TaxCount int,TaxAmount money,BranchTaxAmount money,PayOutCount int,PayOutAmount money,SourceId int,Cashout money) '+
  'insert @TempSummaryBet (ParentBranch,SlipCount,SlipAmount,BranchName,SourceId) '+
  'select (select P.BrancName from Parameter.Branch  as P  where P.BranchId=PB.ParentBranchId), COUNT(CustomerSlip.SlipCount)
,SUM(CustomerSlip.[OrgSlipAmount])
,PB.[BranchId]
,CustomerSlip.SourceId
From Report.SummarySportBetting as CustomerSlip  inner join Customer.Customer  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch  as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and Customer.Customer.IsTerminalCustomer=1 
and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,CustomerSlip.SourceId '
 
 
  SET @sqlcommand2T +=   ' insert @TempSummaryBet (ParentBranch,OpenSlipCount,OpenSlipAmount,BranchName,SourceId) '+
      'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId), COUNT(Customer.Slip.SlipId)
,SUM(dbo.FuncCurrencyConverter(Customer.Slip.Amount,Customer.Slip.CurrencyId,'+cast(@UserCurrencyId as nvarchar(10))+'))
,PB.[BranchId]
,Customer.Slip.SourceId
From Customer.Slip with (nolock) inner join Customer.Customer with (nolock) on Customer.Slip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where Customer.Customer.IsTerminalCustomer=1 and  Customer.Slip.SlipStatu not in (2,4)  and Customer.Slip.SlipStateId=1  and Customer.Slip.SlipTypeId<3
and cast(DATEADD(HOUR,1,Customer.Slip.CreateDate) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(DATEADD(HOUR,1,Customer.Slip.CreateDate) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.Slip.SourceId '

     SET @sqlcommand2 +=   ' insert @TempSummaryBet (ParentBranch,OpenSlipCount,OpenSlipAmount,BranchName,SourceId) '+
        'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId), COUNT(Customer.SlipSystem.SystemSlipId)
,SUM( Customer.SlipSystem.Amount)
,PB.[BranchId]
,Customer.SlipSystem.SourceId
From Customer.SlipSystem with (nolock) inner join Customer.Customer with (nolock) on Customer.SlipSystem.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  Customer.Customer.IsTerminalCustomer=1 and  Customer.SlipSystem.SlipStateId=1  and Customer.SlipSystem.NewSlipTypeId in (4,5)
and cast( DATEADD(HOUR,1,Customer.SlipSystem.CreateDate) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( DATEADD(HOUR,1,Customer.SlipSystem.CreateDate) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.SlipSystem.SourceId '
   
   SET @sqlcommand22T +=   ' insert @TempSummaryBet (ParentBranch,WonSlipCount ,WonSlipAmount ,WonSlipPayOut,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch as P  where P.BranchId=PB.ParentBranchId), SUM(CustomerSlip.WonSlipCount)
,SUM(CustomerSlip.[OrgWonSlipAmount])
,SUM([OrgWonSlipPayOut])
,PB.[BranchId]
,CustomerSlip.SourceId
From Report.SummarySportBetting as CustomerSlip  inner join Customer.Customer  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
   Parameter.Branch  as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and Customer.Customer.IsTerminalCustomer=1   
and  cast( CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,CustomerSlip.SourceId '

 
  

    SET @sqlcommand221T +=   ' insert @TempSummaryBet (ParentBranch,Cashout,BranchName,SourceId) '+
     'select (select P.BrancName from Parameter.Branch  as P  where P.BranchId=PB.ParentBranchId)
,SUM(CustomerSlip.[OrgCashoutSlipAmount])
,PB.[BranchId]
,CustomerSlip.SourceId
From Report.SummarySportBetting as CustomerSlip  inner join Customer.Customer  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and Customer.Customer.IsTerminalCustomer=1 
and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,CustomerSlip.SourceId '
  

  SET @sqlcommand222T +=   ' insert @TempSummaryBet (ParentBranch,LostSlipCount ,LostSlipAmount,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch  as P  where P.BranchId=PB.ParentBranchId), SUM(CustomerSlip.LostSlipCount)
,SUM(CustomerSlip.[OrgLostSlipAmount])
,PB.[BranchId]
,CustomerSlip.SourceId
From Report.SummarySportBetting as CustomerSlip  inner join Customer.Customer  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch  as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and Customer.Customer.IsTerminalCustomer=1 
and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,CustomerSlip.SourceId '
  

 SET @sqlcommand222T +=  ' insert @TempSummaryBet (ParentBranch,CancelSlipCount ,CancelSlipAmount,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch  as P  where P.BranchId=PB.ParentBranchId), COUNT(CustomerSlip.CancelSlipCount)
,SUM(CustomerSlip.OrgCancelSlipAmount)
,PB.[BranchId]
,5
From Report.SummarySportBetting as CustomerSlip  inner join Customer.Customer  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch  as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and  cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId '


   SET @sqlcommand2222T +=   ' insert @TempSummaryBet (ParentBranch,TaxCount ,TaxAmount,BranchName,SourceId) '+
   'select (select P.BrancName from Parameter.Branch  as P  where P.BranchId=PB.ParentBranchId), COUNT(CustomerSlip.SlipCount)
,(SUM(CustomerSlip.[OrgSlipAmount])*5)/100
,PB.[BranchId]
,CustomerSlip.SourceId
From Report.SummarySportBetting as CustomerSlip  inner join Customer.Customer  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch  as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and Customer.Customer.IsTerminalCustomer=1 
and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,CustomerSlip.SourceId '


 SET @sqlcommand2222 +=   ' insert @TempSummaryBet (ParentBranch, BranchTaxAmount,BranchName,SourceId) '+
    '	select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId)
	
	,case when Customer.Slip.SlipStateId in (3,5,6) and Customer.slip.TotalOddValue>1 then   SUM(dbo.FuncCurrencyConverter(ISNULL(Amount,0)*TotalOddValue,Customer.Slip.CurrencyId,'+cast(@UserCurrencyId as nvarchar(10))+')) else case when (Customer.Slip.SlipStateId in (2) or (Customer.Slip.SlipStateId=3 and Customer.slip.TotalOddValue=1) ) 	then   dbo.FuncCurrencyConverter(SUM(Customer.Slip.Amount) +ISNULL((Select SUM(Customer.Tax.TaxAmount) from Customer.Tax with (nolock)  where SlipId=Customer.Slip.SlipId),0),Customer.Slip.CurrencyId,'+cast(@UserCurrencyId as nvarchar(10))+') else 0 end end As Total
	,PB.[BranchId]
,Customer.Slip.SourceId 
from Customer.Slip with (nolock) INNER JOIN Customer.Customer
ON Customer.Customer.CustomerId=Customer.Slip.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
where (IsPayOut=0 or IsPayOut is null) and SlipStateId in (2,3,5,6)  
 and ( IsBranchCustomer=1) and Customer.Slip.SlipTypeId<3 and cast( DATEADD(HOUR,1,Customer.Slip.EvaluateDate ) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( DATEADD(HOUR,1,Customer.Slip.EvaluateDate ) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.Slip.SourceId,Customer.Slip.SlipStateId,Customer.Slip.SlipId,Customer.slip.TotalOddValue,Customer.Slip.CurrencyId '

  SET @sqlcommand2222 +=' insert @TempSummaryBet (ParentBranch, BranchTaxAmount,BranchName,SourceId) '+
    '	select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId)
	,case when Archive.Slip.SlipStateId in (3,5,6) and Archive.slip.TotalOddValue>1 then   SUM(dbo.FuncCurrencyConverter(ISNULL(Amount,0)*TotalOddValue,Archive.Slip.CurrencyId,'+cast(@UserCurrencyId as nvarchar(10))+')) else case when (Archive.Slip.SlipStateId in (2) or (Archive.Slip.SlipStateId=3 and Archive.slip.TotalOddValue=1) ) 	then   dbo.FuncCurrencyConverter(SUM(Archive.Slip.Amount) +ISNULL((Select SUM(Customer.Tax.TaxAmount) from Customer.Tax with (nolock)  where SlipId=Archive.Slip.SlipId),0),Archive.Slip.CurrencyId,'+cast(@UserCurrencyId as nvarchar(10))+') else 0 end end As Total
	,PB.[BranchId]
,Archive.Slip.SourceId 
from Archive.Slip with (nolock) INNER JOIN Customer.Customer
ON Customer.Customer.CustomerId=Archive.Slip.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
where (IsPayOut=0 or IsPayOut is null) and SlipStateId in (2,3,5,6)  
 and ( IsBranchCustomer=1) and Archive.Slip.SlipTypeId<3 and cast( DATEADD(HOUR,1,Archive.Slip.EvaluateDate) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( DATEADD(HOUR,1,Archive.Slip.EvaluateDate) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Archive.Slip.SourceId,Archive.Slip.SlipStateId,Archive.Slip.SlipId,Archive.slip.TotalOddValue,Archive.Slip.CurrencyId '


  SET @sqlcommand2222 +=   ' insert @TempSummaryBet (ParentBranch, BranchTaxAmount,BranchName,SourceId) '+
    '	select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId)
	,cast(ISNULL((Select SUM(dbo.FuncCurrencyConverter(ISNULL(Amount,0)*TotalOddValue,Customer.Slip.CurrencyId,'+cast(@UserCurrencyId as nvarchar(10))+'))
 from Customer.Slip where Customer.Slip.SlipStateId in (3,6) and Customer.Slip.SlipTypeId=3
  and Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) ),0) as money) 
	,PB.[BranchId]
,Customer.SlipSystem.SourceId 
from Customer.SlipSystem INNER JOIN Customer.Customer
ON Customer.Customer.CustomerId=Customer.SlipSystem.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
where (IsPayOut=0 or IsPayOut is null) and SlipStateId in (2,3,5,6)  
 and ( IsBranchCustomer=1)  and cast( DATEADD(HOUR,1,Customer.SlipSystem.EvaluateDate) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( DATEADD(HOUR,1,Customer.SlipSystem.EvaluateDate) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.SlipSystem.SourceId,Customer.SlipSystem.SystemSlipId '

   SET @sqlcommand2222 +=   ' insert @TempSummaryBet (ParentBranch, BranchTaxAmount,BranchName,SourceId) '+
    '	select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId)
	,cast(ISNULL((Select SUM(dbo.FuncCurrencyConverter(ISNULL(Amount,0)*TotalOddValue,Archive.Slip.CurrencyId,'+cast(@UserCurrencyId as nvarchar(10))+'))
 from Archive.Slip where Archive.Slip.SlipStateId in (3,6) and Archive.Slip.SlipTypeId=3
  and Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) ),0) as money) 
	,PB.[BranchId]
,Customer.SlipSystem.SourceId 
from Customer.SlipSystem INNER JOIN Customer.Customer
ON Customer.Customer.CustomerId=Customer.SlipSystem.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
where (IsPayOut=0 or IsPayOut is null) and SlipStateId in (2,3,5,6)  
 and ( IsBranchCustomer=1)  and cast( DATEADD(HOUR,1,Customer.SlipSystem.EvaluateDate) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( DATEADD(HOUR,1,Customer.SlipSystem.EvaluateDate) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.SlipSystem.SourceId,Customer.SlipSystem.SystemSlipId '   

  SET @sqlcommand22222T +=   ' insert @TempSummaryBet (ParentBranch,PayOutCount ,PayOutAmount,BranchName,SourceId) '+
  'select (select P.BrancName from Parameter.Branch  as P  where P.BranchId=PB.ParentBranchId), COUNT(CustomerSlip.PayOutCount)
,SUM(CustomerSlip.[OrgPayOutAmount])
,PB.[BranchId]
,CustomerSlip.SourceId
From Report.SummarySportBetting as CustomerSlip  inner join Customer.Customer  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch  as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,CustomerSlip.SourceId '

--  SET @sqlcommand22222 +=   ' insert @TempSummaryBet (ParentBranch,PayOutCount ,PayOutAmount,BranchName,SourceId) '+
--    'select (select P.BrancName from Parameter.Branch as P where P.BranchId=PB.ParentBranchId), COUNT(Customer.Slip.SlipId)
--,SUM(Customer.Slip.Amount*Customer.Slip.TotalOddValue)
--,PB.[BranchId]
--,Customer.Slip.SourceId
--From Customer.Slip inner join Customer.Customer on Customer.Slip.CustomerId=Customer.Customer.CustomerId INNER JOIN
--  [Parameter].[Branch] as PB ON  PB.[BranchId]=Customer.Customer.BranchId 
--Where Customer.Slip.SlipStatu not in (2,4) and Customer.Slip.SlipStateId in (3,5)  and Customer.Slip.IsPayOut=1
--and cast(DATEADD(HOUR,1,Customer.Slip.EvaluateDate )) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
--and cast(DATEADD(HOUR,1,Customer.Slip.EvaluateDate )) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
-- GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.Slip.SourceId '

--    SET @sqlcommand22222 +=   ' insert @TempSummaryBet (ParentBranch,PayOutCount ,PayOutAmount,BranchName,SourceId) '+
--    'select (select P.BrancName from Parameter.Branch as P where P.BranchId=PB.ParentBranchId), COUNT(Archive.Slip.SlipId)
--,SUM(Archive.Slip.Amount*Archive.Slip.TotalOddValue)
--,PB.[BranchId]
--,Archive.Slip.SourceId
--From Archive.Slip inner join Customer.Customer on Archive.Slip.CustomerId=Customer.Customer.CustomerId INNER JOIN
--  [Parameter].[Branch] as PB ON  PB.[BranchId]=Customer.Customer.BranchId 
--Where Archive.Slip.SlipStatu not in (2,4)   and Archive.Slip.SlipStateId in (3,5)  and Archive.Slip.IsPayOut=1
--and cast(DATEADD(HOUR,1,Archive.Slip.EvaluateDate)) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
--and cast(DATEADD(HOUR,1,Archive.Slip.EvaluateDate)) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
-- GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Archive.Slip.SourceId '


--    SET @sqlcommand22222T +=   ' insert @TempSummaryBet (ParentBranch,PartnerTurnOver ,BranchTaxAmount,BranchName,SourceId) '+
--    '	 SELECT (select ppp.BrancName COLLATE SQL_Latin1_General_CP1_CI_AS from Parameter.Branch as ppp with (nolock) where ppp.BranchId in (select pp.ParentBranchId from Parameter.Branch as pp with (nolock) where pp.BrancName COLLATE SQL_Latin1_General_CP1_CI_AS=tp.ParentBranch))
--, SUM(SlipAmount)-(ISNULL(sum(WonSlipPayOut),0)+ISNULL(sum(Cashout),0)+ISNULL(sum(PayOutAmount),0)+ISNULL(sum(CancelSlipAmount),0)) as Profit
-- ,SUM(TaxAmount) as TaxAmount
-- ,TP.ParentBranch COLLATE SQL_Latin1_General_CP1_CI_AS
-- ,TP.SourceId
-- FROM @TempSummaryBet as TP 
-- where (TP.ParentBranch in (select ppp.BrancName COLLATE SQL_Latin1_General_CP1_CI_AS from Parameter.Branch as ppp with (nolock) where ppp.BranchId in (select pp.ParentBranchId from Parameter.Branch as pp with (nolock) where pp.BrancName COLLATE SQL_Latin1_General_CP1_CI_AS=tp.BranchName))) 
-- GROUP BY  TP.[BranchName],TP.ParentBranch ,TP.SourceId   HAVING SUM(SlipAmount) is not null'



 ----------------------------------------------------------------------------------------------------------------------------------------------

 
 --set @sqlcommand9 +=' insert @TempSummaryBet (ParentBranch,BranchName ,SlipAmount,WonSlipPayOut,CancelSlipAmount,PayOutAmount,Turnover,PartnerTurnOver,OpenSlipAmount,TaxAmount,BranchTaxAmount,SourceId,Cashout)
 -- SELECT ''Total''
 -- ,''''
 -- ,SUM(SlipAmount) AS TurnOver
 --,ISNULL(sum(WonSlipPayOut),0) as CustomerWining
 --,ISNULL(SUM(CancelSlipAmount),0) as CancelBet
 --,ISNULL(SUM(PayOutAmount),0) 
 -- ,ISNULL(SUM(SlipAmount),0)-(ISNULL(sum(WonSlipPayOut),0)+ISNULL(sum(Cashout),0)+ISNULL(sum(PayOutAmount),0)+ISNULL(SUM(CancelSlipAmount),0)) as Profit
 -- ,0 as PartnerProfit
  
 --,ISNULL(SUM(OpenSlipAmount),0) as Unsettled
 --,ISNULL(SUM(TaxAmount),0) as Tax
 --,0 as BranchTaxAmount
 --,SourceId
 --,ISNULL(SUM(Cashout),0)
 --  FROM @TempSummaryBet GROUP BY SourceId    HAVING SUM(SlipAmount) is not null '




	set @sqlcommand9+=' declare @TempSummaryBet3 table (ParentBranch nvarchar(50),SlipCount int,SlipAmount money,OpenSlipCount int,OpenSlipAmount money,OpenSlipPayOut money,WonSlipCount int,WonSlipAmount money,WonSlipPayOut money,LostSlipCount int,LostSlipAmount money,CancelSlipCount int,CancelSlipAmount money,TurnOver money,PartnerTurnOver money,BranchName nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS,TaxCount int,TaxAmount money,BranchTaxAmount money,PayOutCount int,PayOutAmount money,Cashout money) '+
  ' insert @TempSummaryBet3 '+
  '   SELECT tp2.ParentBranch,SUM(ISNULL(SlipCount,0))
,SUM(ISNULL(SlipAmount,0)),SUM(ISNULL(OpenSlipCount,0)),SUM(ISNULL(OpenSlipAmount,0)),SUM(ISNULL(OpenSlipPayOut,0)),SUM(ISNULL(WonSlipCount,0)) ,SUM(ISNULL(WonSlipAmount,0))
,SUM(ISNULL(WonSlipPayOut,0)),SUM(ISNULL(LostSlipCount,0)),SUM(ISNULL(LostSlipAmount,0)),SUM(ISNULL(CancelSlipCount,0)),SUM(ISNULL(CancelSlipAmount,0)),SUM(ISNULL(SlipAmount,0))-(SUM(ISNULL(WonSlipPayOut,0))+SUM(ISNULL(Cashout,0))+ISNULL(SUM(CancelSlipAmount),0)) as TurnOver
,(SUM(ISNULL(WonSlipPayOut,0))+SUM(ISNULL(Cashout,0))+ISNULL(SUM(CancelSlipAmount),0))
,tp2.BranchName,SUM(ISNULL(TaxCount,0)),SUM(ISNULL(TaxAmount,0)),SUM(ISNULL(BranchTaxAmount,0)),SUM(ISNULL(PayOutCount,0)),SUM(ISNULL(WonSlipPayOut,0)),SUM(ISNULL(Cashout,0))
     FROM @TempSummaryBet as tp2 where 1=1  '+@where3 +
	' GROUP BY BranchName,ParentBranch  HAVING SUM(SlipAmount) is not null'


		set @sqlcommand9+=  ' insert @TempSummaryBet3 '+
  '   SELECT''Total'',SUM(ISNULL(SlipCount,0))
,SUM(ISNULL(SlipAmount,0)),SUM(ISNULL(OpenSlipCount,0)),SUM(ISNULL(OpenSlipAmount,0)),SUM(ISNULL(OpenSlipPayOut,0)),SUM(ISNULL(WonSlipCount,0)) ,SUM(ISNULL(WonSlipAmount,0))
,SUM(ISNULL(WonSlipPayOut,0)),SUM(ISNULL(LostSlipCount,0)),SUM(ISNULL(LostSlipAmount,0)),SUM(ISNULL(CancelSlipCount,0)),SUM(ISNULL(CancelSlipAmount,0)),SUM(ISNULL(SlipAmount,0))-(SUM(ISNULL(WonSlipPayOut,0))+SUM(ISNULL(Cashout,0))+ISNULL(SUM(CancelSlipAmount),0)) as TurnOver
,(SUM(ISNULL(WonSlipPayOut,0))+SUM(ISNULL(Cashout,0))+ISNULL(SUM(CancelSlipAmount),0))
,''Total'',SUM(ISNULL(TaxCount,0)),SUM(ISNULL(TaxAmount,0)),SUM(ISNULL(BranchTaxAmount,0)),SUM(ISNULL(PayOutCount,0)),SUM(ISNULL(WonSlipPayOut,0)),SUM(ISNULL(Cashout,0))
     FROM @TempSummaryBet as tp2 where 1=1  '+@where3  
	 


	
  set @sqlcommand=' declare @total int '+
'select @total=COUNT(SlipCount)  '+
'FROM        @TempSummaryBet3 as tmp LEFT OUTER JOIN Parameter.Branch On tmp.BranchName=Parameter.Branch.BrancName
WHERE    1=1 ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
'	 ParentBranch ,ISNULL([SlipCount],0)  as [SlipCount]
       ,ISNULL(SlipAmount,0) as [SlipAmount]
      ,ISNULL([OpenSlipCount],0)  as [OpenSlipCount]
      ,ISNULL([OpenSlipAmount],0)  as [OpenSlipAmount]
      ,ISNULL([OpenSlipPayOut],0)  as [OpenSlipPayOut]
      ,ISNULL([WonSlipCount],0)  as [WonSlipCount]
      ,ISNULL([WonSlipAmount],0) as [WonSlipAmount]
      ,ISNULL([WonSlipPayOut],0)  as [WonSlipPayOut]
      ,ISNULL([LostSlipCount],0)  as [LostSlipCount]
      ,ISNULL([LostSlipAmount],0)  as [LostSlipAmount]
      ,ISNULL([CancelSlipCount],0)  as [CancelSlipCount]
      ,ISNULL([CancelSlipAmount],0) as [CancelSlipAmount]
      ,cast(0 as money) as SumTurnOver
	  ,BranchName
	  ,(ISNULL(PartnerTurnOver,0)) as BranchTurnOver
	  ,ISNULL(TurnOver,0) as TurnOver
	  ,ISNULL([TaxCount],0)  as [TaxCount]
      ,ISNULL(ISNULL([TaxAmount],0),0)  as [TaxAmount]
	  ,ISNULL(ISNULL([BranchTaxAmount],0),0)  as [BranchTaxAmount]
	  ,ISNULL(ISNULL([TaxAmount],0),0)+ISNULL(ISNULL([BranchTaxAmount],0),0) as SumTaxAmount
	  ,ISNULL([PayOutCount],0)  as [PayOutCount]
      ,ISNULL(ISNULL([PayOutAmount],0),0)  as PayOutAmount,ISNULL(ISNULL([Cashout],0),0)  as Cashout,cast(0 as money) as Bonus,cast(0 as money)  as OnlineDeposit,cast(0 as money)  as OnlineWithDraw '+
'FROM         @TempSummaryBet3 as tmp LEFT OUTER JOIN Parameter.Branch On tmp.BranchName=Parameter.Branch.BrancName
WHERE  1=1 '+
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '

 end
else
	begin
		
 set @sqlcommand2T=' declare @TempSummaryBet table (ParentBranch nvarchar(50),SlipCount int,SlipAmount money,OpenSlipCount int,OpenSlipAmount money,OpenSlipPayOut money,WonSlipCount int,WonSlipAmount money,WonSlipPayOut money,LostSlipCount int,LostSlipAmount money,CancelSlipCount int,CancelSlipAmount money,TurnOver money,PartnerTurnOver money,BranchName nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS,TaxCount int,TaxAmount money,BranchTaxAmount money,PayOutCount int,PayOutAmount money,SourceId int,Cashout money) '+
  'insert @TempSummaryBet (ParentBranch,SlipCount,SlipAmount,BranchName,SourceId) '+
  'select (select P.BrancName from Parameter.Branch  as P  where P.BranchId=PB.ParentBranchId), COUNT(CustomerSlip.SlipCount)
,SUM( CustomerSlip.SlipAmount)
,PB.[BranchId]
,CustomerSlip.SourceId
From Report.SummarySportBetting as CustomerSlip  inner join Customer.Customer  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch  as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and Customer.Customer.IsTerminalCustomer=1 
and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,CustomerSlip.SourceId '
 
 
  SET @sqlcommand2T +=   ' insert @TempSummaryBet (ParentBranch,OpenSlipCount,OpenSlipAmount,BranchName,SourceId) '+
      'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId), COUNT(Customer.Slip.SlipId)
,SUM(dbo.FuncCurrencyConverter(Customer.Slip.Amount,Customer.Slip.CurrencyId,'+cast(@UserCurrencyId as nvarchar(10))+'))
,PB.[BranchId]
,Customer.Slip.SourceId
From Customer.Slip with (nolock) inner join Customer.Customer with (nolock) on Customer.Slip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where Customer.Customer.IsTerminalCustomer=1 and  Customer.Slip.SlipStatu not in (2,4)  and Customer.Slip.SlipStateId=1  and Customer.Slip.SlipTypeID<3
and cast(DATEADD(HOUR,1,Customer.Slip.CreateDate) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(DATEADD(HOUR,1,Customer.Slip.CreateDate) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.Slip.SourceId '

    SET @sqlcommand2 +=   ' insert @TempSummaryBet (ParentBranch,OpenSlipCount,OpenSlipAmount,BranchName,SourceId) '+
        'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId), COUNT(Customer.SlipSystem.SystemSlipId)
,SUM( Customer.SlipSystem.Amount)
,PB.[BranchId]
,Customer.SlipSystem.SourceId
From Customer.SlipSystem with (nolock) inner join Customer.Customer with (nolock) on Customer.SlipSystem.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  Customer.Customer.IsTerminalCustomer=1 and  Customer.SlipSystem.SlipStateId=1  and Customer.SlipSystem.NewSlipTypeId in (4,5)
and cast( DATEADD(HOUR,1,Customer.SlipSystem.CreateDate) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( DATEADD(HOUR,1,Customer.SlipSystem.CreateDate) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.SlipSystem.SourceId '
   
   SET @sqlcommand22T +=   ' insert @TempSummaryBet (ParentBranch,WonSlipCount ,WonSlipAmount ,WonSlipPayOut,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch as P  where P.BranchId=PB.ParentBranchId), SUM(CustomerSlip.WonSlipCount)
,SUM(CustomerSlip.WonSlipAmount)
,SUM(WonSlipPayOut)
,PB.[BranchId]
,CustomerSlip.SourceId
From Report.SummarySportBetting as CustomerSlip  inner join Customer.Customer  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
   Parameter.Branch  as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and Customer.Customer.IsTerminalCustomer=1   
and  cast( CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,CustomerSlip.SourceId '

 
  

    SET @sqlcommand221T +=   ' insert @TempSummaryBet (ParentBranch,Cashout,BranchName,SourceId) '+
     'select (select P.BrancName from Parameter.Branch  as P  where P.BranchId=PB.ParentBranchId)
,SUM(CustomerSlip.CashoutSlipAmount)
,PB.[BranchId]
,CustomerSlip.SourceId
From Report.SummarySportBetting as CustomerSlip  inner join Customer.Customer  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and Customer.Customer.IsTerminalCustomer=1 
and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,CustomerSlip.SourceId '
  

  SET @sqlcommand222T +=   ' insert @TempSummaryBet (ParentBranch,LostSlipCount ,LostSlipAmount,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch  as P  where P.BranchId=PB.ParentBranchId), SUM(CustomerSlip.LostSlipCount)
,SUM(CustomerSlip.LostSlipAmount)
,PB.[BranchId]
,CustomerSlip.SourceId
From Report.SummarySportBetting as CustomerSlip  inner join Customer.Customer  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch  as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and Customer.Customer.IsTerminalCustomer=1 
and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,CustomerSlip.SourceId '
  

 SET @sqlcommand222T +=   ' insert @TempSummaryBet (ParentBranch,CancelSlipCount ,CancelSlipAmount,BranchName,SourceId) '+
  'select (select P.BrancName from Parameter.Branch  as P  where P.BranchId=PB.ParentBranchId), COUNT(CustomerSlip.CancelSlipCount)
,SUM(CustomerSlip.CancelSlipAmount)
,PB.[BranchId]
,5
From Report.SummarySportBetting as CustomerSlip  inner join Customer.Customer  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch  as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where Customer.Customer.IsTerminalCustomer=1  
and   CustomerSlip.Isview=1 and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId '


   SET @sqlcommand2222T +=   ' insert @TempSummaryBet (ParentBranch,TaxCount ,TaxAmount,BranchName,SourceId) '+
     'select (select P.BrancName from Parameter.Branch  as P  where P.BranchId=PB.ParentBranchId), COUNT(CustomerSlip.TaxCount)
,SUM(CustomerSlip.Tax)
,PB.[BranchId]
,5
From Report.SummarySportBetting as CustomerSlip  inner join Customer.Customer  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch  as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and Customer.Customer.IsTerminalCustomer=1  
and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId '

 SET @sqlcommand2222 +=   ' insert @TempSummaryBet (ParentBranch, BranchTaxAmount,BranchName,SourceId) '+
    '	select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId)
	
	,case when Customer.Slip.SlipStateId in (3,5,6) and Customer.slip.TotalOddValue>1 then   SUM(dbo.FuncCurrencyConverter(ISNULL(Amount,0)*TotalOddValue,Customer.Slip.CurrencyId,'+cast(@UserCurrencyId as nvarchar(10))+')) else case when (Customer.Slip.SlipStateId in (2) or (Customer.Slip.SlipStateId=3 and Customer.slip.TotalOddValue=1) ) 	then   dbo.FuncCurrencyConverter(SUM(Customer.Slip.Amount) +ISNULL((Select SUM(Customer.Tax.TaxAmount) from Customer.Tax with (nolock)  where SlipId=Customer.Slip.SlipId),0),Customer.Slip.CurrencyId,'+cast(@UserCurrencyId as nvarchar(10))+') else 0 end end As Total
	,PB.[BranchId]
,Customer.Slip.SourceId 
from Customer.Slip with (nolock) INNER JOIN Customer.Customer
ON Customer.Customer.CustomerId=Customer.Slip.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
where (IsPayOut=0 or IsPayOut is null) and SlipStateId in (2,3,5,6)  
 and ( IsBranchCustomer=1) and Customer.Slip.SlipTypeId<3 and cast( DATEADD(HOUR,1,Customer.Slip.EvaluateDate ) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( DATEADD(HOUR,1,Customer.Slip.EvaluateDate ) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.Slip.SourceId,Customer.Slip.SlipStateId,Customer.Slip.SlipId,Customer.slip.TotalOddValue,Customer.Slip.CurrencyId '

  SET @sqlcommand2222 +=' insert @TempSummaryBet (ParentBranch, BranchTaxAmount,BranchName,SourceId) '+
    '	select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId)
	,case when Archive.Slip.SlipStateId in (3,5,6) and Archive.slip.TotalOddValue>1 then   SUM(dbo.FuncCurrencyConverter(ISNULL(Amount,0)*TotalOddValue,Archive.Slip.CurrencyId,'+cast(@UserCurrencyId as nvarchar(10))+')) else case when (Archive.Slip.SlipStateId in (2) or (Archive.Slip.SlipStateId=3 and Archive.slip.TotalOddValue=1) ) 	then   dbo.FuncCurrencyConverter(SUM(Archive.Slip.Amount) +ISNULL((Select SUM(Customer.Tax.TaxAmount) from Customer.Tax with (nolock)  where SlipId=Archive.Slip.SlipId),0),Archive.Slip.CurrencyId,'+cast(@UserCurrencyId as nvarchar(10))+') else 0 end end As Total
	,PB.[BranchId]
,Archive.Slip.SourceId 
from Archive.Slip with (nolock) INNER JOIN Customer.Customer
ON Customer.Customer.CustomerId=Archive.Slip.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
where (IsPayOut=0 or IsPayOut is null) and SlipStateId in (2,3,5,6)  
 and ( IsBranchCustomer=1) and Archive.Slip.SlipTypeId<3 and cast( DATEADD(HOUR,1,Archive.Slip.EvaluateDate) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( DATEADD(HOUR,1,Archive.Slip.EvaluateDate) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Archive.Slip.SourceId,Archive.Slip.SlipStateId,Archive.Slip.SlipId,Archive.slip.TotalOddValue,Archive.Slip.CurrencyId '


  SET @sqlcommand2222 +=   ' insert @TempSummaryBet (ParentBranch, BranchTaxAmount,BranchName,SourceId) '+
    '	select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId)
	,cast(ISNULL((Select SUM(dbo.FuncCurrencyConverter(ISNULL(Amount,0)*TotalOddValue,Customer.Slip.CurrencyId,'+cast(@UserCurrencyId as nvarchar(10))+'))
 from Customer.Slip where Customer.Slip.SlipStateId in (3,6) and Customer.Slip.SlipTypeId=3
  and Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) ),0) as money) 
	,PB.[BranchId]
,Customer.SlipSystem.SourceId 
from Customer.SlipSystem INNER JOIN Customer.Customer
ON Customer.Customer.CustomerId=Customer.SlipSystem.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
where (IsPayOut=0 or IsPayOut is null) and SlipStateId in (2,3,5,6)  
 and ( IsBranchCustomer=1)  and cast( DATEADD(HOUR,1,Customer.SlipSystem.EvaluateDate) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( DATEADD(HOUR,1,Customer.SlipSystem.EvaluateDate) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.SlipSystem.SourceId,Customer.SlipSystem.SystemSlipId '

   SET @sqlcommand2222 +=   ' insert @TempSummaryBet (ParentBranch, BranchTaxAmount,BranchName,SourceId) '+
    '	select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId)
	,cast(ISNULL((Select SUM(dbo.FuncCurrencyConverter(ISNULL(Amount,0)*TotalOddValue,Archive.Slip.CurrencyId,'+cast(@UserCurrencyId as nvarchar(10))+'))
 from Archive.Slip where Archive.Slip.SlipStateId in (3,6) and Archive.Slip.SlipTypeId=3
  and Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) ),0) as money) 
	,PB.[BranchId]
,Customer.SlipSystem.SourceId 
from Customer.SlipSystem INNER JOIN Customer.Customer
ON Customer.Customer.CustomerId=Customer.SlipSystem.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
where (IsPayOut=0 or IsPayOut is null) and SlipStateId in (2,3,5,6)  
 and ( IsBranchCustomer=1)  and cast( DATEADD(HOUR,1,Customer.SlipSystem.EvaluateDate) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( DATEADD(HOUR,1,Customer.SlipSystem.EvaluateDate) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.SlipSystem.SourceId,Customer.SlipSystem.SystemSlipId '   
 

--  SET @sqlcommand22222T +=   ' insert @TempSummaryBet (ParentBranch,PayOutCount ,PayOutAmount,BranchName,SourceId) '+
--    ' select (select P.BrancName from Parameter.Branch as P where P.BranchId=PB.ParentBranchId), COUNT(RiskManagement.BranchTransaction.BranchTransactionId)
--,SUM(RiskManagement.BranchTransaction.Amount)
--,PB.[BranchId]
--,5
--From RiskManagement.BranchTransaction inner join Customer.Customer on RiskManagement.BranchTransaction.CustomerId=Customer.Customer.CustomerId INNER JOIN
--  [Parameter].[Branch] as PB ON  PB.[BranchId]=Customer.Customer.BranchId 
--Where RiskManagement.BranchTransaction.TransactionTypeId=15 and RiskManagement.BranchTransaction.BranchTransactionId in  (select SlipId from RiskManagement.BranchTransaction where RiskManagement.BranchTransaction.TransactionTypeId=16)
--and cast(RiskManagement.BranchTransaction.CreateDate) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
--and cast(RiskManagement.BranchTransaction.CreateDate) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
-- GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId '

--  SET @sqlcommand22222 +=   ' insert @TempSummaryBet (ParentBranch,PayOutCount ,PayOutAmount,BranchName,SourceId) '+
--    'select (select P.BrancName from Parameter.Branch as P where P.BranchId=PB.ParentBranchId), COUNT(Customer.Slip.SlipId)
--,SUM(Customer.Slip.Amount*Customer.Slip.TotalOddValue)
--,PB.[BranchId]
--,Customer.Slip.SourceId
--From Customer.Slip inner join Customer.Customer on Customer.Slip.CustomerId=Customer.Customer.CustomerId INNER JOIN
--  [Parameter].[Branch] as PB ON  PB.[BranchId]=Customer.Customer.BranchId 
--Where Customer.Slip.SlipStatu not in (2,4) and Customer.Slip.SlipStateId in (3,5)  and Customer.Slip.IsPayOut=1
--and cast(DATEADD(HOUR,1,Customer.Slip.EvaluateDate )) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
--and cast(DATEADD(HOUR,1,Customer.Slip.EvaluateDate )) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
-- GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.Slip.SourceId '

--    SET @sqlcommand22222 +=   ' insert @TempSummaryBet (ParentBranch,PayOutCount ,PayOutAmount,BranchName,SourceId) '+
--    'select (select P.BrancName from Parameter.Branch as P where P.BranchId=PB.ParentBranchId), COUNT(Archive.Slip.SlipId)
--,SUM(Archive.Slip.Amount*Archive.Slip.TotalOddValue)
--,PB.[BranchId]
--,Archive.Slip.SourceId
--From Archive.Slip inner join Customer.Customer on Archive.Slip.CustomerId=Customer.Customer.CustomerId INNER JOIN
--  [Parameter].[Branch] as PB ON  PB.[BranchId]=Customer.Customer.BranchId 
--Where Archive.Slip.SlipStatu not in (2,4)   and Archive.Slip.SlipStateId in (3,5)  and Archive.Slip.IsPayOut=1
--and cast(DATEADD(HOUR,1,Archive.Slip.EvaluateDate)) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
--and cast(DATEADD(HOUR,1,Archive.Slip.EvaluateDate)) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
-- GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Archive.Slip.SourceId '


--    SET @sqlcommand22222T +=   ' insert @TempSummaryBet (ParentBranch,PartnerTurnOver ,BranchTaxAmount,BranchName,SourceId) '+
--    '	 SELECT (select ppp.BrancName COLLATE SQL_Latin1_General_CP1_CI_AS from Parameter.Branch as ppp with (nolock) where ppp.BranchId in (select pp.ParentBranchId from Parameter.Branch as pp with (nolock) where pp.BrancName COLLATE SQL_Latin1_General_CP1_CI_AS=tp.ParentBranch))
--, SUM(SlipAmount)-(ISNULL(sum(WonSlipPayOut),0)+ISNULL(sum(Cashout),0)+ISNULL(sum(PayOutAmount),0)+ISNULL(sum(CancelSlipAmount),0)) as Profit
-- ,SUM(TaxAmount) as TaxAmount
-- ,TP.ParentBranch COLLATE SQL_Latin1_General_CP1_CI_AS
-- ,TP.SourceId
-- FROM @TempSummaryBet as TP 
-- where (TP.ParentBranch in (select ppp.BrancName COLLATE SQL_Latin1_General_CP1_CI_AS from Parameter.Branch as ppp with (nolock) where ppp.BranchId in (select pp.ParentBranchId from Parameter.Branch as pp with (nolock) where pp.BrancName COLLATE SQL_Latin1_General_CP1_CI_AS=tp.BranchName))) 
-- GROUP BY  TP.[BranchName],TP.ParentBranch ,TP.SourceId   HAVING SUM(SlipAmount) is not null'



 ----------------------------------------------------------------------------------------------------------------------------------------------

 
 --set @sqlcommand9 +=' insert @TempSummaryBet (ParentBranch,BranchName ,SlipAmount,WonSlipPayOut,CancelSlipAmount,PayOutAmount,Turnover,PartnerTurnOver,OpenSlipAmount,TaxAmount,BranchTaxAmount,SourceId,Cashout)
 -- SELECT ''Total''
 -- ,''''
 -- ,SUM(SlipAmount) AS TurnOver
 --,ISNULL(sum(WonSlipPayOut),0) as CustomerWining
 --,ISNULL(SUM(CancelSlipAmount),0) as CancelBet
 --,ISNULL(SUM(PayOutAmount),0) 
 -- ,ISNULL(SUM(SlipAmount),0)-(ISNULL(sum(WonSlipPayOut),0)+ISNULL(sum(Cashout),0)+ISNULL(sum(PayOutAmount),0)+ISNULL(SUM(CancelSlipAmount),0)) as Profit
 -- ,0 as PartnerProfit
  
 --,ISNULL(SUM(OpenSlipAmount),0) as Unsettled
 --,ISNULL(SUM(TaxAmount),0) as Tax
 --,0 as BranchTaxAmount
 --,SourceId
 --,ISNULL(SUM(Cashout),0)
 --  FROM @TempSummaryBet GROUP BY SourceId    HAVING SUM(SlipAmount) is not null '




	set @sqlcommand9+=' declare @TempSummaryBet3 table (ParentBranch nvarchar(50),SlipCount int,SlipAmount money,OpenSlipCount int,OpenSlipAmount money,OpenSlipPayOut money,WonSlipCount int,WonSlipAmount money,WonSlipPayOut money,LostSlipCount int,LostSlipAmount money,CancelSlipCount int,CancelSlipAmount money,TurnOver money,PartnerTurnOver money,BranchName nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS,TaxCount int,TaxAmount money,BranchTaxAmount money,PayOutCount int,PayOutAmount money,Cashout money) '+
  ' insert @TempSummaryBet3 '+
  '   SELECT tp2.ParentBranch,SUM(ISNULL(SlipCount,0))
,SUM(ISNULL(SlipAmount,0)),SUM(ISNULL(OpenSlipCount,0)),SUM(ISNULL(OpenSlipAmount,0)),SUM(ISNULL(OpenSlipPayOut,0)),SUM(ISNULL(WonSlipCount,0)) ,SUM(ISNULL(WonSlipAmount,0))
,SUM(ISNULL(WonSlipPayOut,0)),SUM(ISNULL(LostSlipCount,0)),SUM(ISNULL(LostSlipAmount,0)),SUM(ISNULL(CancelSlipCount,0)),SUM(ISNULL(CancelSlipAmount,0)),SUM(ISNULL(SlipAmount,0))-(SUM(ISNULL(WonSlipPayOut,0))+ISNULL(sum(Cashout),0)+SUM(ISNULL(PayOutAmount,0))+ISNULL(SUM(CancelSlipAmount),0)) as TurnOver
,(SUM(ISNULL(WonSlipPayOut,0))+SUM(ISNULL(Cashout,0))+ISNULL(SUM(CancelSlipAmount),0))
,tp2.BranchName,SUM(ISNULL(TaxCount,0)),SUM(ISNULL(TaxAmount,0)),SUM(ISNULL(BranchTaxAmount,0)),SUM(ISNULL(PayOutCount,0)),SUM(ISNULL(WonSlipPayOut,0)),SUM(ISNULL(Cashout,0))
     FROM @TempSummaryBet as tp2 where 1=1  '+@where3 +
	' GROUP BY BranchName,ParentBranch  HAVING SUM(SlipAmount) is not null'

		set @sqlcommand9+=  ' insert @TempSummaryBet3 '+
  '   SELECT''Total'',SUM(ISNULL(SlipCount,0))
,SUM(ISNULL(SlipAmount,0)),SUM(ISNULL(OpenSlipCount,0)),SUM(ISNULL(OpenSlipAmount,0)),SUM(ISNULL(OpenSlipPayOut,0)),SUM(ISNULL(WonSlipCount,0)) ,SUM(ISNULL(WonSlipAmount,0))
,SUM(ISNULL(WonSlipPayOut,0)),SUM(ISNULL(LostSlipCount,0)),SUM(ISNULL(LostSlipAmount,0)),SUM(ISNULL(CancelSlipCount,0)),SUM(ISNULL(CancelSlipAmount,0)),SUM(ISNULL(SlipAmount,0))-(SUM(ISNULL(WonSlipPayOut,0))+SUM(ISNULL(Cashout,0))+ISNULL(SUM(CancelSlipAmount),0)) as TurnOver
,(SUM(ISNULL(WonSlipPayOut,0))+SUM(ISNULL(Cashout,0))+ISNULL(SUM(CancelSlipAmount),0))
,''Total'',SUM(ISNULL(TaxCount,0)),SUM(ISNULL(TaxAmount,0)),SUM(ISNULL(BranchTaxAmount,0)),SUM(ISNULL(PayOutCount,0)),SUM(ISNULL(WonSlipPayOut,0)),SUM(ISNULL(Cashout,0))
     FROM @TempSummaryBet as tp2 where 1=1  '+@where3  

	
  set @sqlcommand=' declare @total int '+
'select @total=COUNT(SlipCount)  '+
'FROM        @TempSummaryBet3 as tmp LEFT OUTER JOIN Parameter.Branch On tmp.BranchName=Parameter.Branch.BrancName
WHERE    1=1 ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
'	 ParentBranch ,ISNULL([SlipCount],0)  as [SlipCount]
       ,ISNULL(dbo.FuncCurrencyConverter(SlipAmount,3,'+cast(@UserCurrencyId as nvarchar(10))+'),0) as [SlipAmount]
      ,ISNULL([OpenSlipCount],0)  as [OpenSlipCount]
      ,ISNULL([OpenSlipAmount],0)  as [OpenSlipAmount]
      ,ISNULL([OpenSlipPayOut],0)  as [OpenSlipPayOut]
      ,ISNULL([WonSlipCount],0)  as [WonSlipCount]
      ,ISNULL(dbo.FuncCurrencyConverter(WonSlipAmount,3,'+cast(@UserCurrencyId as nvarchar(10))+'),0) as [WonSlipAmount]
      ,ISNULL(dbo.FuncCurrencyConverter(WonSlipPayOut,3,'+cast(@UserCurrencyId as nvarchar(10))+'),0)  as [WonSlipPayOut]
      ,ISNULL([LostSlipCount],0)  as [LostSlipCount]
      ,ISNULL(dbo.FuncCurrencyConverter(LostSlipAmount,3,'+cast(@UserCurrencyId as nvarchar(10))+'),0)  as [LostSlipAmount]
      ,ISNULL([CancelSlipCount],0)  as [CancelSlipCount]
      ,ISNULL(dbo.FuncCurrencyConverter(CancelSlipAmount,3,'+cast(@UserCurrencyId as nvarchar(10))+'),0) as [CancelSlipAmount]
      ,cast(0 as money) as SumTurnOver
	  ,BranchName
	  ,ISNULL(dbo.FuncCurrencyConverter(PartnerTurnOver,3,'+cast(@UserCurrencyId as nvarchar(10))+'),0) as BranchTurnOver
	  ,ISNULL(dbo.FuncCurrencyConverter(TurnOver,3,'+cast(@UserCurrencyId as nvarchar(10))+'),0) as TurnOver
	  ,ISNULL([TaxCount],0)  as [TaxCount]
      ,ISNULL(ISNULL(dbo.FuncCurrencyConverter(TaxAmount,3,'+cast(@UserCurrencyId as nvarchar(10))+'),0),0)  as [TaxAmount]
	  ,  [BranchTaxAmount]
	  ,cast(0 as money) as SumTaxAmount
	  ,ISNULL([PayOutCount],0)  as [PayOutCount]
      ,ISNULL(ISNULL(dbo.FuncCurrencyConverter(PayOutAmount,3,'+cast(@UserCurrencyId as nvarchar(10))+'),0),0)  as PayOutAmount
	  ,ISNULL(ISNULL(dbo.FuncCurrencyConverter(Cashout,3,'+cast(@UserCurrencyId as nvarchar(10))+'),0),0)  as Cashout,cast(0 as money) as Bonus,cast(0 as money)  as OnlineDeposit,cast(0 as money)  as OnlineWithDraw '+
'FROM         @TempSummaryBet3 as tmp LEFT OUTER JOIN Parameter.Branch On tmp.BranchName=Parameter.Branch.BrancName
WHERE  1=1 '+
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '


	end

 exec (@sqlcommandBranch+@sqlcommand2T+@sqlcommand22T+@sqlcommand221T+@sqlcommand222T+@sqlcommand2222T+@sqlcommand2222+@sqlcommand22222T+@sqlcommand9+@sqlcommand)

 end
 else if (@SourceId=5) --Casino
 begin

 exec Report.ProcSummaryCasinoBettingFill1


 	
  if(@BranchId<>1)
	begin

	set @where2=' PB.BranchId in (select BranchId from Parameter.Branch with (nolock) where IsTerminal=0 and (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId in (select BranchId from Parameter.Branch  where IsTerminal=0 and (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ') )))'  

	end
 
			 set @sqlcommand2=' declare @TempSummaryBet table (ParentBranch nvarchar(50),SlipCount int,SlipAmount money,OpenSlipCount int,OpenSlipAmount money,OpenSlipPayOut money,WonSlipCount int,WonSlipAmount money,WonSlipPayOut money,LostSlipCount int,LostSlipAmount money,CancelSlipCount int,CancelSlipAmount money,TurnOver money,PartnerTurnOver money,BranchName nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS,TaxCount int,TaxAmount money,BranchTaxAmount money,PayOutCount int,PayOutAmount money) '+
  'insert @TempSummaryBet '+
  'SELECT 
  (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId)
      ,      ISNULL(SUM([SlipCount]),0)  as [SlipCount]
      ,ISNULL(SUM(dbo.FuncCurrencyConverter(SlipAmount,3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)  as [SlipAmount]
      ,ISNULL(SUM([OpenSlipCount]),0)  as [OpenSlipCount]
         ,ISNULL(SUM(OpenSlipAmount),0)  as [OpenSlipAmount]
      ,ISNULL(SUM([OpenSlipPayOut]),0)  as [OpenSlipPayOut]
      ,ISNULL(SUM([WonSlipCount]),0)  as [WonSlipCount]
      ,ISNULL(SUM(dbo.FuncCurrencyConverter(WonSlipAmount,3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)  as [WonSlipAmount]
      ,ISNULL(SUM(dbo.FuncCurrencyConverter(WonSlipAmount,3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)  as [WonSlipPayOut]
      ,ISNULL(SUM([LostSlipCount]),0)  as [LostSlipCount]
      ,ISNULL(SUM(dbo.FuncCurrencyConverter(LostSlipAmount,3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)  as [LostSlipAmount]
      ,ISNULL(SUM([CancelSlipCount]),0)  as [CancelSlipCount]
      ,ISNULL(SUM(dbo.FuncCurrencyConverter(CancelSlipAmount,3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)  as [CancelSlipAmount]
      ,ISNULL(SUM(dbo.FuncCurrencyConverter(SlipAmount,3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)-((ISNULL(SUM(dbo.FuncCurrencyConverter(WonSlipAmount,3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)+ISNULL(SUM(dbo.FuncCurrencyConverter(CancelSlipAmount,3,'+cast(@UserCurrencyId as nvarchar(10))+')),0))) as TurnOver
	   ,0 as BranchTurnOver	
	  ,PB.[BranchId]
	  ,0  as [TaxCount]
      ,0  as [Tax]
	  ,0
	  ,0 as [PayOutCount]
      ,ISNULL(SUM(dbo.FuncCurrencyConverter(WonSlipAmount,3,'+cast(@UserCurrencyId as nvarchar(10))+')),0) as [PayOutAmount]
  FROM [Report].[SummaryCasinoBetting] with (nolock) INNER JOIN 
  Customer.Customer with (nolock) ON Customer.Customer.CustomerId=[Report].[SummaryCasinoBetting].CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
  Where cast([Report].[SummaryCasinoBetting].ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast([Report].[SummaryCasinoBetting].ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND  '+@where2 + ' and '+ @where +'  
  GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId; '


  
  --set @sqlcommand3=' insert @TempSummaryBet '+
  --'SELECT 
		--''Total''
  --    ,ISNULL(SUM([SlipCount]),0)  as [SlipCount]
  --    ,ISNULL(SUM([SlipAmount]),0)  as [SlipAmount]
  --    ,ISNULL(SUM([OpenSlipCount]),0)  as [OpenSlipCount]
  --    ,ISNULL(SUM([OpenSlipAmount]),0)  as [OpenSlipAmount]
  --    ,ISNULL(SUM([OpenSlipPayOut]),0)  as [OpenSlipPayOut]
  --    ,ISNULL(SUM([WonSlipCount]),0)  as [WonSlipCount]
  --    ,ISNULL(SUM([WonSlipAmount]),0)  as [WonSlipAmount]
  --    ,ISNULL(SUM([WonSlipPayOut]),0)  as [WonSlipPayOut]
  --    ,ISNULL(SUM([LostSlipCount]),0)  as [LostSlipCount]
  --    ,ISNULL(SUM([LostSlipAmount]),0)  as [LostSlipAmount]
  --    ,ISNULL(SUM([CancelSlipCount]),0)  as [CancelSlipCount]
  --    ,ISNULL(SUM([CancelSlipAmount]),0)  as [CancelSlipAmount]
  --    ,ISNULL(SUM(TurnOver),0)
	 -- ,0
	 -- ,''''
	 -- ,ISNULL(SUM([TaxCount]),0)  as [TaxCount]
  --     ,ISNULL(SUM(TaxAmount),0)  as [Tax]
	 --     ,ISNULL(SUM(BranchTaxAmount),0)  as [Tax]
	 -- ,ISNULL(SUM([PayOutCount]),0)  as [PayOutCount]
  --    ,ISNULL(SUM([PayOutAmount]),0)  as [PayOutAmount]
  --FROM @TempSummaryBet '

    set @sqlcommand9=' declare @TempSummaryBet3 table (ParentBranch nvarchar(50),SlipCount int,SlipAmount money,OpenSlipCount int,OpenSlipAmount money,OpenSlipPayOut money,WonSlipCount int,WonSlipAmount money,WonSlipPayOut money,LostSlipCount int,LostSlipAmount money,CancelSlipCount int,CancelSlipAmount money,TurnOver money,PartnerTurnOver money,BranchName nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS,TaxCount int,TaxAmount money,BranchTaxAmount money,PayOutCount int,PayOutAmount money) '+
  ' insert @TempSummaryBet3 '+
  '   SELECT tp2.ParentBranch,SUM(ISNULL(SlipCount,0))
,SUM(ISNULL(SlipAmount,0)),SUM(ISNULL(OpenSlipCount,0)),SUM(ISNULL(OpenSlipAmount,0)),SUM(ISNULL(OpenSlipPayOut,0)),SUM(ISNULL(WonSlipCount,0)) ,SUM(ISNULL(WonSlipAmount,0))
,SUM(ISNULL(WonSlipAmount,0)),SUM(ISNULL(LostSlipCount,0)),SUM(ISNULL(LostSlipAmount,0)),SUM(ISNULL(CancelSlipCount,0)),SUM(ISNULL(CancelSlipAmount,0)),SUM(ISNULL(TurnOver,0)) as TurnOver
,( select SUM(TurnOver) from @TempSummaryBet as ttp where ttp.ParentBranch=tp2.BranchName COLLATE SQL_Latin1_General_CP1_CI_AS)
,tp2.BranchName,SUM(ISNULL(TaxCount,0)),SUM(ISNULL(TaxAmount,0)),SUM(ISNULL(BranchTaxAmount,0)),SUM(ISNULL(PayOutCount,0)),SUM(ISNULL(WonSlipAmount,0))
     FROM @TempSummaryBet as tp2 
	 GROUP BY BranchName,ParentBranch '

	   set @sqlcommand9 +=  ' insert @TempSummaryBet3 '+
  '   SELECT ''Total'',SUM(ISNULL(SlipCount,0))
,SUM(ISNULL(SlipAmount,0)),SUM(ISNULL(OpenSlipCount,0)),SUM(ISNULL(OpenSlipAmount,0)),SUM(ISNULL(OpenSlipPayOut,0)),SUM(ISNULL(WonSlipCount,0)) ,SUM(ISNULL(WonSlipAmount,0))
,SUM(ISNULL(WonSlipAmount,0)),SUM(ISNULL(LostSlipCount,0)),SUM(ISNULL(LostSlipAmount,0)),SUM(ISNULL(CancelSlipCount,0)),SUM(ISNULL(CancelSlipAmount,0)),SUM(ISNULL(TurnOver,0)) as TurnOver
,SUM(ISNULL(PartnerTurnOver,0))
,''Total'',SUM(ISNULL(TaxCount,0)),SUM(ISNULL(TaxAmount,0)),SUM(ISNULL(BranchTaxAmount,0)),SUM(ISNULL(PayOutCount,0)),SUM(ISNULL(WonSlipAmount,0))
     FROM @TempSummaryBet3   '
  
  set @sqlcommand=' declare @total int '+
'select @total=COUNT(SlipCount)  '+
'FROM        @TempSummaryBet3 as tmp LEFT OUTER JOIN Parameter.Branch On tmp.BranchName=Parameter.Branch.BrancName
WHERE    1=1 ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
'	 ParentBranch,ISNULL([SlipCount],0)  as [SlipCount]
       ,ISNULL(SlipAmount,0) as [SlipAmount]
      ,ISNULL([OpenSlipCount],0)  as [OpenSlipCount]
      ,ISNULL([OpenSlipAmount],0)  as [OpenSlipAmount]
      ,ISNULL([OpenSlipPayOut],0)  as [OpenSlipPayOut]
      ,ISNULL([WonSlipCount],0)  as [WonSlipCount]
      ,ISNULL([WonSlipAmount],0) as [WonSlipAmount]
      ,ISNULL([WonSlipPayOut],0)  as [WonSlipPayOut]
      ,ISNULL([LostSlipCount],0)  as [LostSlipCount]
      ,ISNULL([LostSlipAmount],0)  as [LostSlipAmount]
      ,ISNULL([CancelSlipCount],0)  as [CancelSlipCount]
      ,ISNULL([CancelSlipAmount],0) as [CancelSlipAmount]
      ,cast(0 as money) as SumTurnOver
	  ,BranchName
	  ,cast(0 as money) as BranchTurnOver
	  ,ISNULL(TurnOver,0) as TurnOver
	  ,ISNULL([TaxCount],0)  as [TaxCount]
      ,cast(0 as money)  as [TaxAmount]
	  ,cast(0 as money) as BranchTaxAmount
	  ,cast(0 as money) as SumTaxAmount
	  ,ISNULL([PayOutCount],0)  as [PayOutCount]
      ,ISNULL(ISNULL([PayOutAmount],0),0)  as PayOutAmount,cast(0 as money) as Cashout,cast(0 as money) as Bonus,cast(0 as money)  as OnlineDeposit,cast(0 as money)  as OnlineWithDraw '+
'FROM         @TempSummaryBet3 as tmp LEFT OUTER JOIN Parameter.Branch with (nolock) On tmp.BranchName=Parameter.Branch.BrancName
WHERE  1=1 '+
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '
  

 exec (@sqlcommand2+@sqlcommand3+@sqlcommand9+@sqlcommand)

 end
 else if (@SourceId=6) --Virtual
 begin

 exec Report.ProcSummaryVirtualBettingFill1


 	
  if(@BranchId<>1)
	begin

	set @where2=' PB.BranchId in (select BranchId from Parameter.Branch with (nolock) where IsTerminal=0 and (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId in (select BranchId from Parameter.Branch  where IsTerminal=0 and (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ') )))'  

	end

		set @sqlcommand2=' declare @TempSummaryBet table (ParentBranch nvarchar(50),SlipCount int,SlipAmount money,OpenSlipCount int,OpenSlipAmount money,OpenSlipPayOut money,WonSlipCount int,WonSlipAmount money,WonSlipPayOut money,LostSlipCount int,LostSlipAmount money,CancelSlipCount int,CancelSlipAmount money,TurnOver money,PartnerTurnOver money,BranchName nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS,TaxCount int,TaxAmount money,BranchTaxAmount money,PayOutCount int,PayOutAmount money) '+
  'insert @TempSummaryBet '+
  'SELECT 
  (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId)
      ,      ISNULL(SUM([SlipCount]),0)  as [SlipCount]
      ,ISNULL(SUM(dbo.FuncCurrencyConverter(SlipAmount,3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)  as [SlipAmount]
      ,ISNULL(SUM([OpenSlipCount]),0)  as [OpenSlipCount]
      ,ISNULL(SUM([OpenSlipAmount]),0)  as [OpenSlipAmount]
      ,ISNULL(SUM([OpenSlipPayOut]),0)  as [OpenSlipPayOut]
      ,ISNULL(SUM([WonSlipCount]),0)  as [WonSlipCount]
      ,ISNULL(SUM(dbo.FuncCurrencyConverter(WonSlipAmount,3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)  as [WonSlipAmount]
      ,ISNULL(SUM(dbo.FuncCurrencyConverter(WonSlipAmount,3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)  as [WonSlipPayOut]
      ,ISNULL(SUM([LostSlipCount]),0)  as [LostSlipCount]
      ,ISNULL(SUM(dbo.FuncCurrencyConverter(LostSlipAmount,3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)  as [LostSlipAmount]
      ,ISNULL(SUM([CancelSlipCount]),0)  as [CancelSlipCount]
      ,ISNULL(SUM(dbo.FuncCurrencyConverter(CancelSlipAmount,3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)  as [CancelSlipAmount]
      ,ISNULL(SUM(dbo.FuncCurrencyConverter(SlipAmount,3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)-((ISNULL(SUM(dbo.FuncCurrencyConverter(WonSlipAmount,3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)+ISNULL(SUM(dbo.FuncCurrencyConverter(CancelSlipAmount,3,'+cast(@UserCurrencyId as nvarchar(10))+')),0))) as TurnOver
	 	   ,0 as BranchTurnOver	
	  ,PB.[BranchId]
	  ,0  as [TaxCount]
      ,0  as [Tax]
	  ,0
	  ,0 as [PayOutCount]
      ,ISNULL(SUM(dbo.FuncCurrencyConverter(WonSlipAmount,3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)   as [PayOutAmount]
  FROM [Report].[SummaryVirtualBetting] with (nolock) INNER JOIN 
  Customer.Customer with (nolock) ON Customer.Customer.CustomerId=[Report].[SummaryVirtualBetting].CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
  Where cast([Report].[SummaryVirtualBetting].ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast([Report].[SummaryVirtualBetting].ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND   '+@where2 + ' and '+ @where +'  
  GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId; '


  -- set @sqlcommand3=' insert @TempSummaryBet '+
  --'SELECT 
		--''Total''
  --    ,ISNULL(SUM([SlipCount]),0)  as [SlipCount]
  --    ,ISNULL(SUM([SlipAmount]),0)  as [SlipAmount]
  --    ,ISNULL(SUM([OpenSlipCount]),0)  as [OpenSlipCount]
  --    ,ISNULL(SUM([OpenSlipAmount]),0)  as [OpenSlipAmount]
  --    ,ISNULL(SUM([OpenSlipPayOut]),0)  as [OpenSlipPayOut]
  --    ,ISNULL(SUM([WonSlipCount]),0)  as [WonSlipCount]
  --    ,ISNULL(SUM([WonSlipAmount]),0)  as [WonSlipAmount]
  --    ,ISNULL(SUM([WonSlipPayOut]),0)  as [WonSlipPayOut]
  --    ,ISNULL(SUM([LostSlipCount]),0)  as [LostSlipCount]
  --    ,ISNULL(SUM([LostSlipAmount]),0)  as [LostSlipAmount]
  --    ,ISNULL(SUM([CancelSlipCount]),0)  as [CancelSlipCount]
  --    ,ISNULL(SUM([CancelSlipAmount]),0)  as [CancelSlipAmount]
  --    ,ISNULL(SUM(TurnOver),0)
	 -- ,0
	 -- ,''''
	 -- ,ISNULL(SUM([TaxCount]),0)  as [TaxCount]
  --     ,ISNULL(SUM(TaxAmount),0)  as [Tax]
	 --     ,ISNULL(SUM(BranchTaxAmount),0)  as [Tax]
	 -- ,ISNULL(SUM([PayOutCount]),0)  as [PayOutCount]
  --    ,ISNULL(SUM([PayOutAmount]),0)  as [PayOutAmount]
  --FROM @TempSummaryBet '
  
  
     set @sqlcommand9=' declare @TempSummaryBet3 table (ParentBranch nvarchar(50),SlipCount int,SlipAmount money,OpenSlipCount int,OpenSlipAmount money,OpenSlipPayOut money,WonSlipCount int,WonSlipAmount money,WonSlipPayOut money,LostSlipCount int,LostSlipAmount money,CancelSlipCount int,CancelSlipAmount money,TurnOver money,PartnerTurnOver money,BranchName nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS,TaxCount int,TaxAmount money,BranchTaxAmount money,PayOutCount int,PayOutAmount money) '+
  ' insert @TempSummaryBet3 '+
  '   SELECT tp2.ParentBranch,SUM(ISNULL(SlipCount,0))
,SUM(ISNULL(SlipAmount,0)),SUM(ISNULL(OpenSlipCount,0)),SUM(ISNULL(OpenSlipAmount,0)),SUM(ISNULL(OpenSlipPayOut,0)),SUM(ISNULL(WonSlipCount,0)) ,SUM(ISNULL(WonSlipAmount,0))
,SUM(ISNULL(WonSlipPayOut,0)),SUM(ISNULL(LostSlipCount,0)),SUM(ISNULL(LostSlipAmount,0)),SUM(ISNULL(CancelSlipCount,0)),SUM(ISNULL(CancelSlipAmount,0)),SUM(ISNULL(TurnOver,0)) as TurnOver
,( select SUM(TurnOver) from @TempSummaryBet as ttp where ttp.ParentBranch=tp2.BranchName COLLATE SQL_Latin1_General_CP1_CI_AS)
,tp2.BranchName,SUM(ISNULL(TaxCount,0)),SUM(ISNULL(TaxAmount,0)),SUM(ISNULL(BranchTaxAmount,0)),SUM(ISNULL(PayOutCount,0)),SUM(ISNULL(PayOutAmount,0))
     FROM @TempSummaryBet as tp2 
	 GROUP BY BranchName,ParentBranch '


  set @sqlcommand=' declare @total int '+
'select @total=COUNT(SlipCount)  '+
'FROM        @TempSummaryBet as tmp LEFT OUTER JOIN Parameter.Branch On tmp.BranchName=Parameter.Branch.BrancName
WHERE    1=1 ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
'	ParentBranch, ISNULL([SlipCount],0)  as [SlipCount]
       ,ISNULL(SlipAmount,0) as [SlipAmount]
      ,ISNULL([OpenSlipCount],0)  as [OpenSlipCount]
      ,ISNULL([OpenSlipAmount],0)  as [OpenSlipAmount]
      ,ISNULL([OpenSlipPayOut],0)  as [OpenSlipPayOut]
      ,ISNULL([WonSlipCount],0)  as [WonSlipCount]
      ,ISNULL([WonSlipAmount],0) as [WonSlipAmount]
      ,ISNULL([WonSlipPayOut],0)  as [WonSlipPayOut]
      ,ISNULL([LostSlipCount],0)  as [LostSlipCount]
      ,ISNULL([LostSlipAmount],0)  as [LostSlipAmount]
      ,ISNULL([CancelSlipCount],0)  as [CancelSlipCount]
      ,ISNULL([CancelSlipAmount],0) as [CancelSlipAmount]
      ,cast(0 as money) as SumTurnOver
	  ,BranchName
	  ,cast(0 as money) as BranchTurnOver
	  ,ISNULL(TurnOver,0) as TurnOver
	  ,ISNULL([TaxCount],0)  as [TaxCount]
      ,cast(0 as money)  as [TaxAmount]
	  	  ,cast(0 as money) as BranchTaxAmount
	  ,cast(0 as money) as SumTaxAmount
	  ,ISNULL([PayOutCount],0)  as [PayOutCount]
      ,ISNULL(ISNULL([PayOutAmount],0),0)  as PayOutAmount,cast(0 as money) as Cashout,cast(0 as money) as Bonus,cast(0 as money)  as OnlineDeposit,cast(0 as money)  as OnlineWithDraw '+
'FROM         @TempSummaryBet as tmp LEFT OUTER JOIN Parameter.Branch with (nolock) On tmp.BranchName=Parameter.Branch.BrancName
WHERE  1=1 '+
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '
 
 execute (@sqlcommand2+@sqlcommand3+@sqlcommand9+@sqlcommand)

 end
  else if (@SourceId=7) -- Total
 begin
 
  exec Report.ProcSummarySportBettingFill1
 --  exec Report.ProcSummaryCasinoBettingFill1
  --  exec Report.ProcSummaryVirtualBettingFill1

		declare @wherePayout nvarchar(max)='1=1'
		

		 if(@BranchId<>1)
	begin
	if (@BranchId<>31970)
		begin
			set @where2=' PB.BranchId in (select BranchId from Parameter.Branch with (nolock)  where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId in (select BranchId from Parameter.Branch with (nolock) where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ') ))) or PB.ParentBranchId in (select BranchId from Parameter.Branch with (nolock)  where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId in (select BranchId from Parameter.Branch with (nolock) where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ') )))'  
			set @whereTerminal='  Customer.BranchId in (select BranchId from Parameter.Branch with (nolock) where IsTerminal=1 and (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ '   '
			set @wherePayout=' BranchId in (select BranchId from Parameter.Branch with (nolock) where IsTerminal=0 and (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId in (select BranchId from Parameter.Branch  where IsTerminal=0 and (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ') )))'  

		end
	else
		begin
			set @where2=' (PB.BranchId in (select BranchId from Parameter.Branch with (nolock)  where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId in (select BranchId from Parameter.Branch with (nolock) where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ') ))) or PB.ParentBranchId in (select BranchId from Parameter.Branch with (nolock)  where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId in (select BranchId from Parameter.Branch with (nolock) where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ') ))))'  
			set @whereTerminal='  Customer.BranchId in (select BranchId from Parameter.Branch with (nolock) where IsTerminal=1 and (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId in (select BranchId from Parameter.Branch with (nolock)   where IsTerminal=0 and (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ') )))'  
		end
	end
else
	set @whereTerminal='  Customer.BranchId in (select BranchId from Parameter.Branch with (nolock) where IsTerminal=1) '
	 
 

if(@BranchId not in (1,31970))
begin	

set @sqlcommandBranch=' declare @TempBranchtable table (BranchId bigint) '+
' insert @TempBranchtable select BranchId from Parameter.Branch with (nolock) where ( BranchId in (select BranchId from Parameter.Branch with (nolock)  where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId in (select BranchId from Parameter.Branch with (nolock) where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ') ))) or ParentBranchId in (select BranchId from Parameter.Branch with (nolock)  where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId in (select BranchId from Parameter.Branch with (nolock) where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ') ))) ) '




set @where2= ' ( PB.BranchId in (select BranchId from @TempBranchtable) or PB.ParentBranchId in (select BranchId from @TempBranchtable)) '
 
 --set @sqlcommandCustomer=' declare @TempCustomerTable table (CustomerId bigint,BranchId bigint) insert @TempCustomerTable select BranchId,CustomerId from Customer.Customer with (nolock) where ( BranchId in (select BranchId from Parameter.Branch with (nolock)  where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId in (select BranchId from Parameter.Branch with (nolock) where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ') )))  )'
  

 set @sqlcommand2=' declare @TempSummaryBet table (ParentBranch nvarchar(50),SlipCount int,SlipAmount money,OpenSlipCount int,OpenSlipAmount money,OpenSlipPayOut money,WonSlipCount int,WonSlipAmount money,WonSlipPayOut money,LostSlipCount int,LostSlipAmount money,CancelSlipCount int,CancelSlipAmount money,TurnOver money,PartnerTurnOver money,BranchName nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS,TaxCount int,TaxAmount money,BranchTaxAmount money,PayOutCount int,PayOutAmount money,Cashout money,Bonus money ,OnlineDeposit money,OnlineWithDraw money) '+
  'insert @TempSummaryBet (ParentBranch,SlipCount,SlipAmount,BranchName) '+
    'select case when PB.IsTerminal=0 then PB.BrancName else  (select P.BrancName from Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId) end
	, COUNT(CustomerSlip.SlipCount)
,SUM(CustomerSlip.[OrgSlipAmount])
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
From Report.SummarySportBetting as CustomerSlip with (nolock) inner join Customer.Customer with (nolock) on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch  as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and 
 cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal '
  

  SET @sqlcommand2 +=   ' insert @TempSummaryBet (ParentBranch,OpenSlipCount,OpenSlipAmount,BranchName) '+
      'select case when PB.IsTerminal=0 then PB.BrancName else  (select P.BrancName from Parameter.Branch  as P with (nolock)   where P.BranchId=PB.ParentBranchId) end, COUNT(Customer.Slip.SlipId)
,SUM( Customer.Slip.Amount)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
From Customer.Slip with (nolock) inner join Customer.Customer with (nolock) on Customer.Slip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where Customer.Slip.SlipStatu not in (2,4)  and Customer.Slip.SlipStateId=1  and Customer.Slip.SlipTypeId<3
and cast(DATEADD(HOUR,1,Customer.Slip.CreateDate) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(DATEADD(HOUR,1,Customer.Slip.CreateDate) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal '
 

   SET @sqlcommand2 +=   ' insert @TempSummaryBet (ParentBranch,OpenSlipCount,OpenSlipAmount,BranchName) '+
        'select case when PB.IsTerminal=0 then PB.BrancName else  (select P.BrancName from Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId) end, COUNT(Customer.SlipSystem.SystemSlipId)
,SUM( Customer.SlipSystem.Amount)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
From Customer.SlipSystem with (nolock) inner join Customer.Customer with (nolock) on Customer.SlipSystem.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where   Customer.SlipSystem.SlipStateId=1  and Customer.SlipSystem.NewSlipTypeId in (4,5)
and cast( DATEADD(HOUR,1,Customer.SlipSystem.CreateDate) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( DATEADD(HOUR,1,Customer.SlipSystem.CreateDate) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.SlipSystem.SourceId,PB.IsTerminal '

   SET @sqlcommand22 +=   ' insert @TempSummaryBet (ParentBranch,WonSlipCount ,WonSlipAmount ,WonSlipPayOut,BranchName) '+
      'select case when PB.IsTerminal=0 then PB.BrancName else  (select P.BrancName from Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId) end, SUM(CustomerSlip.WonSlipCount)
,SUM(CustomerSlip.[OrgWonSlipAmount])
,SUM([OrgWonSlipPayOut])
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
From Report.SummarySportBetting as CustomerSlip with (nolock) inner join Customer.Customer with (nolock) on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
   Parameter.Branch  as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where   CustomerSlip.Isview=1 and cast( CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal '

      SET @sqlcommand22 +=   ' insert @TempSummaryBet (ParentBranch,Bonus,BranchName ) '+
    'select case when PB.IsTerminal=0 then PB.BrancName else  (select P.BrancName from Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId) end, SUM(CustomerSlip.Amount)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
From Customer.[Transaction] as CustomerSlip with (nolock)  inner join Customer.Customer with (nolock)  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
   Parameter.Branch  as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where (Customer.Customer.IsTerminalCustomer=0 or Customer.Customer.IsTerminalCustomer is null)  and (Customer.Customer.IsBranchCustomer=0 or Customer.Customer.IsBranchCustomer is null) and CustomerSlip.TransactionTypeId=35 and  cast( CustomerSlip.TransactionDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( CustomerSlip.TransactionDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal '

--    SET @sqlcommand22 +=   ' insert @TempSummaryBet (ParentBranch,Bonus,BranchName ) '+
--     'select case when PB.IsTerminal=0 then PB.BrancName else  (select P.BrancName from Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId) end 
--,SUM(CustomerSlip.BonusAmount)
--,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
--From Report.SummarySportBetting as CustomerSlip with (nolock) inner join Customer.Customer with (nolock) on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
--   Parameter.Branch  as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
--Where   CustomerSlip.Isview=1 and cast( CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
--and cast( CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
-- GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal '
 

     SET @sqlcommand221 +=   ' insert @TempSummaryBet (ParentBranch,Cashout,BranchName) '+
     'select case when PB.IsTerminal=0 then PB.BrancName else  (select P.BrancName from Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId) end
,SUM(CustomerSlip.[OrgCashoutSlipAmount])
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
From Report.SummarySportBetting as CustomerSlip with (nolock)  inner join Customer.Customer with (nolock) on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch as PB with (nolock)  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal '

  
  SET @sqlcommand222 +=   ' insert @TempSummaryBet (ParentBranch,LostSlipCount ,LostSlipAmount,BranchName) '+
    'select case when PB.IsTerminal=0 then PB.BrancName else  (select P.BrancName from Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId) end, SUM(CustomerSlip.LostSlipCount)
,SUM(CustomerSlip.[OrgLostSlipAmount])
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
From Report.SummarySportBetting as CustomerSlip with (nolock)  inner join Customer.Customer with (nolock)  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch  as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where CustomerSlip.Isview=1 and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal '
 

 SET @sqlcommand222 +=   ' insert @TempSummaryBet (ParentBranch,CancelSlipCount ,CancelSlipAmount,BranchName) '+
     'select case when PB.IsTerminal=0 then PB.BrancName else  (select P.BrancName from Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId) end, COUNT(CustomerSlip.CancelSlipCount)
,SUM(CustomerSlip.[OrgCancelSlipAmount])
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
From Report.SummarySportBetting as CustomerSlip with (nolock) inner join Customer.Customer with (nolock) on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch  as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal '

 
  SET @sqlcommand2222 +=   ' insert @TempSummaryBet (ParentBranch,TaxCount ,TaxAmount,BranchName) '+
      'select case when PB.IsTerminal=0 then PB.BrancName else  (select P.BrancName from Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId) end, COUNT(CustomerSlip.TaxCount)
,SUM(CustomerSlip.[OrgTax])
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
From Report.SummarySportBetting as CustomerSlip with (nolock) inner join Customer.Customer with (nolock) on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch  as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and  cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal '

   SET @sqlcommand2222 +=   ' insert @TempSummaryBet (ParentBranch, BranchTaxAmount,BranchName) '+
    '	select case when PB.IsTerminal=0 then PB.BrancName else  (select P.BrancName from Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId) end
	,case when Customer.Slip.SlipStateId in (3,5,6) and Customer.slip.TotalOddValue>1 then   SUM(Customer.Slip.TotalOddValue * Customer.Slip.Amount) else case when (Customer.Slip.SlipStateId in (2) or (Customer.Slip.SlipStateId=3 and Customer.slip.TotalOddValue=1) ) 	then   SUM(Customer.Slip.Amount) +ISNULL((Select SUM(Customer.Tax.TaxAmount) from Customer.Tax with (nolock)  where SlipId=Customer.Slip.SlipId),0) else 0 end end As Total
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
from Customer.Slip with (nolock) INNER JOIN Customer.Customer with (nolock)
ON Customer.Customer.CustomerId=Customer.Slip.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
where (IsPayOut=0 or IsPayOut is null) and SlipStateId in (2,3,5,6)  
 and ( IsBranchCustomer=1) and Customer.Slip.SlipTypeId<3 and cast( DATEADD(HOUR,1,Customer.Slip.EvaluateDate ) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( DATEADD(HOUR,1,Customer.Slip.EvaluateDate ) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.Slip.SourceId,Customer.Slip.SlipStateId,Customer.Slip.SlipId,Customer.slip.TotalOddValue,PB.IsTerminal '

  SET @sqlcommand2222 +=' insert @TempSummaryBet (ParentBranch, BranchTaxAmount,BranchName) '+
    '	select case when PB.IsTerminal=0 then PB.BrancName else  (select P.BrancName from Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId) end
	,case when Archive.Slip.SlipStateId in (3,5,6) and Archive.slip.TotalOddValue>1 	then   SUM(Archive.Slip.TotalOddValue * Archive.Slip.Amount) else case when (Archive.Slip.SlipStateId in (2) or (Archive.Slip.SlipStateId=3 and Archive.slip.TotalOddValue=1) ) 	then   SUM(Archive.Slip.Amount) +ISNULL((Select SUM(Customer.Tax.TaxAmount) from Customer.Tax with (nolock)  where SlipId=Archive.Slip.SlipId),0) else 0 end end As Total
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
from Archive.Slip with (nolock) INNER JOIN Customer.Customer with (nolock)
ON Customer.Customer.CustomerId=Archive.Slip.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
where (IsPayOut=0 or IsPayOut is null) and SlipStateId in (2,3,5,6)  
 and ( IsBranchCustomer=1) and Archive.Slip.SlipTypeId<3 and cast( DATEADD(HOUR,1,Archive.Slip.EvaluateDate) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( DATEADD(HOUR,1,Archive.Slip.EvaluateDate) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Archive.Slip.SlipStateId,Archive.Slip.SlipId,Archive.slip.TotalOddValue,PB.IsTerminal '


  SET @sqlcommand2222 +=   ' insert @TempSummaryBet (ParentBranch, BranchTaxAmount,BranchName) '+
    '	select case when PB.IsTerminal=0 then PB.BrancName else  (select P.BrancName from Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId) end
	,cast(ISNULL((Select SUM(ISNULL(Amount,0)*TotalOddValue)
 from Customer.Slip where Customer.Slip.SlipStateId in (3,6) and Customer.Slip.SlipTypeId=3
  and Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) ),0) as money) 
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
from Customer.SlipSystem with (nolock)  INNER JOIN Customer.Customer with (nolock)
ON Customer.Customer.CustomerId=Customer.SlipSystem.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
where (IsPayOut=0 or IsPayOut is null) and SlipStateId in (2,3,5,6)  
 and ( IsBranchCustomer=1)  and cast( DATEADD(HOUR,1,Customer.SlipSystem.EvaluateDate) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( DATEADD(HOUR,1,Customer.SlipSystem.EvaluateDate) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.SlipSystem.SystemSlipId,PB.IsTerminal '

   SET @sqlcommand2222 +=   ' insert @TempSummaryBet (ParentBranch, BranchTaxAmount,BranchName) '+
    '	select case when PB.IsTerminal=0 then PB.BrancName else  (select P.BrancName from Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId) end
	,cast(ISNULL((Select SUM(ISNULL(Amount,0)*TotalOddValue)
 from Archive.Slip with (nolock) where Archive.Slip.SlipStateId in (3,6) and Archive.Slip.SlipTypeId=3
  and Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) ),0) as money) 
	,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
from Customer.SlipSystem  with (nolock) INNER JOIN Customer.Customer with (nolock)
ON Customer.Customer.CustomerId=Customer.SlipSystem.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
where (IsPayOut=0 or IsPayOut is null) and SlipStateId in (2,3,5,6)  
 and ( IsBranchCustomer=1)  and cast( DATEADD(HOUR,1,Customer.SlipSystem.EvaluateDate) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( DATEADD(HOUR,1,Customer.SlipSystem.EvaluateDate) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.SlipSystem.SystemSlipId,PB.IsTerminal '   




 SET  @sqlcommand22222 +=   ' insert @TempSummaryBet (ParentBranch,PayOutCount ,PayOutAmount,BranchName)'+
 'select case when PB.IsTerminal=0 then PB.BrancName else  (select P.BrancName from Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId) end, COUNT(CustomerSlip.PayOutCount)
,SUM(CustomerSlip.[OrgPayOutAmount])
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
From Report.SummarySportBetting as CustomerSlip with (nolock) inner join Customer.Customer with (nolock) on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch  as PB with (nolock)  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal '
 
 SET @sqlcommand22222 +=   ' insert @TempSummaryBet (ParentBranch,OnlineDeposit ,OnlineWithDraw,BranchName) '+
  'select (select P.BrancName from Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId) 
,SUM(CustomerSlip.OnlineDeposit)
,SUM(CustomerSlip.OnlineWithDraw)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
From Report.SummarySportBetting as CustomerSlip  inner join Customer.Customer  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch  as PB with (nolock)  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal '

  set @sqlcommand3+=' declare @TempSummaryBet2 table (ParentBranch nvarchar(50),SlipCount int,SlipAmount money,OpenSlipCount int,OpenSlipAmount money,OpenSlipPayOut money,WonSlipCount int,WonSlipAmount money,WonSlipPayOut money,LostSlipCount int,LostSlipAmount money,CancelSlipCount int,CancelSlipAmount money,TurnOver money,PartnerTurnOver money,BranchName nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS,TaxCount int,TaxAmount money,BranchTaxAmount money,PayOutCount int,PayOutAmount money,Cashout money,Bonus money ,OnlineDeposit money,OnlineWithDraw money) '+
  ' insert @TempSummaryBet2 '+
  'SELECT ParentBranch,SUM(SlipCount),SUM(SlipAmount),SUM(OpenSlipCount),SUM(OpenSlipAmount),SUM(OpenSlipPayOut),SUM(WonSlipCount) ,SUM(WonSlipAmount),SUM(WonSlipPayOut),SUM(LostSlipCount),SUM(LostSlipAmount),SUM(CancelSlipCount),SUM(CancelSlipAmount),ISNULL(SUM(SlipAmount),0)-(ISNULL(SUM(WonSlipPayOut),0)+ISNULL(SUM(Cashout),0)+ISNULL(SUM(CancelSlipAmount),0)+ISNULL(SUM(Bonus),0)),(ISNULL(SUM(WonSlipPayOut),0)+ISNULL(SUM(Cashout),0)+ISNULL(SUM(CancelSlipAmount),0)+ISNULL(SUM(Bonus),0)),BranchName,SUM(TaxCount),SUM(TaxAmount),SUM(BranchTaxAmount),SUM(PayOutCount),SUM(WonSlipPayOut),SUM(Cashout),SUM(Bonus) ,SUM(ISNULL(OnlineDeposit,0)),SUM(ISNULL(OnlineWithDraw,0))
     FROM @TempSummaryBet GROUP BY BranchName,ParentBranch   '+
  ' delete from @TempSummaryBet'
 
	

  set @sqlcommand3+= ' insert @TempSummaryBet '+
  'select case when PB.IsTerminal=0 then PB.BrancName else  (select P.BrancName from Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId) end
      ,       ISNULL(SUM([SlipCount]),0)  as [SlipCount]
      ,ISNULL( SUM(dbo.FuncCurrencyConverter([SlipAmount],3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)  as [SlipAmount]
      ,ISNULL(SUM([OpenSlipCount]),0)  as [OpenSlipCount]
      ,ISNULL( SUM(dbo.FuncCurrencyConverter([OpenSlipAmount],3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)  as [OpenSlipAmount]
      ,ISNULL( SUM(dbo.FuncCurrencyConverter([OpenSlipPayOut],3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)  as [OpenSlipPayOut]
      ,ISNULL(SUM([WonSlipCount]),0)  as [WonSlipCount]
      ,ISNULL( SUM(dbo.FuncCurrencyConverter([WonSlipAmount],3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)  as [WonSlipAmount]
      ,ISNULL( SUM(dbo.FuncCurrencyConverter([WonSlipPayOut],3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)  as [WonSlipPayOut]
      ,ISNULL(SUM([LostSlipCount]),0)  as [LostSlipCount]
      ,ISNULL( SUM(dbo.FuncCurrencyConverter([LostSlipAmount],3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)  as [LostSlipAmount]
      ,ISNULL(SUM([CancelSlipCount]),0)  as [CancelSlipCount]
      ,ISNULL( SUM(dbo.FuncCurrencyConverter([CancelSlipAmount],3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)  as [CancelSlipAmount]
      ,ISNULL(SUM(dbo.FuncCurrencyConverter([SlipAmount],3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)-((ISNULL(SUM(dbo.FuncCurrencyConverter([WonSlipAmount],3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)+ISNULL(SUM(dbo.FuncCurrencyConverter([CancelSlipAmount],3,'+cast(@UserCurrencyId as nvarchar(10))+')),0))) as TurnOver
	 	   ,((ISNULL(SUM(dbo.FuncCurrencyConverter([WonSlipAmount],3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)+ISNULL(SUM(dbo.FuncCurrencyConverter([CancelSlipAmount],3,'+cast(@UserCurrencyId as nvarchar(10))+')),0))) as BranchTurnOver			
	  ,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
	  ,0  as [TaxCount]
      ,0  as [Tax]
	  ,0
	  ,0 as [PayOutCount]
      ,ISNULL( SUM(dbo.FuncCurrencyConverter([WonSlipPayOut],3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)   as [PayOutAmount],0 as Cashout,0,0,0
  FROM [Report].[SummaryCasinoBetting] INNER JOIN 
  Customer.Customer ON Customer.Customer.CustomerId=[Report].[SummaryCasinoBetting].CustomerId INNER JOIN
  [Parameter].[Branch] as PB ON  PB.[BranchId]=Customer.Customer.BranchId 
  Where cast([Report].[SummaryCasinoBetting].ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast([Report].[SummaryCasinoBetting].ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' and '+@where2 + ' and '+ @where +'  
  GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal; '

 
   
  set @sqlcommand5= ' insert @TempSummaryBet2 '+
  'SELECT ParentBranch,SUM(SlipCount),SUM(SlipAmount),SUM(OpenSlipCount),SUM(OpenSlipAmount),SUM(OpenSlipPayOut),SUM(WonSlipCount) ,SUM(WonSlipAmount),SUM(WonSlipPayOut),SUM(LostSlipCount),SUM(LostSlipAmount),SUM(CancelSlipCount),SUM(CancelSlipAmount),SUM(TurnOver),SUM(PartnerTurnOver),BranchName,SUM(TaxCount),SUM(TaxAmount),SUM(BranchTaxAmount),SUM(PayOutCount),SUM(PayOutAmount),SUM(Cashout),0,0,0
     FROM @TempSummaryBet GROUP BY BranchName,ParentBranch '+
	 ' delete from @TempSummaryBet '
 

   set @sqlcommand6= ' insert @TempSummaryBet '+
  'select case when PB.IsTerminal=0 then PB.BrancName else  (select P.BrancName from Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId) end
      , ISNULL(SUM([SlipCount]),0)  as [SlipCount]
      ,ISNULL( SUM(dbo.FuncCurrencyConverter([SlipAmount],3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)  as [SlipAmount]
      ,ISNULL(SUM([OpenSlipCount]),0)  as [OpenSlipCount]
      ,ISNULL( SUM(dbo.FuncCurrencyConverter([OpenSlipAmount],3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)  as [OpenSlipAmount]
      ,ISNULL(SUM(dbo.FuncCurrencyConverter([OpenSlipPayOut],3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)  as [OpenSlipPayOut]
      ,ISNULL(SUM([WonSlipCount]),0)  as [WonSlipCount]
      ,ISNULL(SUM(dbo.FuncCurrencyConverter([WonSlipAmount],3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)  as [WonSlipAmount]
      ,ISNULL(SUM(dbo.FuncCurrencyConverter([WonSlipAmount],3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)  as [WonSlipPayOut]
      ,ISNULL(SUM([LostSlipCount]),0)  as [LostSlipCount]
      ,ISNULL(SUM(dbo.FuncCurrencyConverter([LostSlipAmount],3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)  as [LostSlipAmount]
      ,ISNULL(SUM([CancelSlipCount]),0)  as [CancelSlipCount]
      ,ISNULL(SUM(dbo.FuncCurrencyConverter([CancelSlipAmount],3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)  as [CancelSlipAmount]
      ,ISNULL(SUM(dbo.FuncCurrencyConverter([SlipAmount],3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)-((ISNULL(SUM(dbo.FuncCurrencyConverter([WonSlipAmount],3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)+ISNULL(SUM(dbo.FuncCurrencyConverter([CancelSlipAmount],3,'+cast(@UserCurrencyId as nvarchar(10))+')),0))) as TurnOver
	 	   ,((ISNULL(SUM(dbo.FuncCurrencyConverter([WonSlipAmount],3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)+ISNULL(SUM(dbo.FuncCurrencyConverter([CancelSlipAmount],3,'+cast(@UserCurrencyId as nvarchar(10))+')),0))) as BranchTurnOver	
	 ,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
	  ,0  as [TaxCount]
      ,0  as [Tax]
	  ,0
	  ,0 as [PayOutCount]
      ,ISNULL(SUM(dbo.FuncCurrencyConverter([WonSlipAmount],3,'+cast(@UserCurrencyId as nvarchar(10))+')),0) as [PayOutAmount],0 as Cashout,0,0,0
  FROM [Report].[SummaryVirtualBetting] INNER JOIN 
  Customer.Customer ON Customer.Customer.CustomerId=[Report].[SummaryVirtualBetting].CustomerId INNER JOIN
  [Parameter].[Branch] as PB ON  PB.[BranchId]=Customer.Customer.BranchId 
  Where cast([Report].[SummaryVirtualBetting].ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast([Report].[SummaryVirtualBetting].ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND  '+@where2 + ' and '+ @where +'  
  GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal; '

 

  set @sqlcommand8=  ' insert @TempSummaryBet2 '+
  'SELECT ParentBranch,SUM(SlipCount),SUM(SlipAmount),SUM(OpenSlipCount),SUM(OpenSlipAmount),SUM(OpenSlipPayOut),SUM(WonSlipCount) ,SUM(WonSlipAmount),SUM(WonSlipPayOut),SUM(LostSlipCount),SUM(LostSlipAmount),SUM(CancelSlipCount),SUM(CancelSlipAmount),SUM(TurnOver),SUM(PartnerTurnOver),BranchName,SUM(TaxCount),SUM(TaxAmount),SUM(BranchTaxAmount),SUM(PayOutCount),SUM(PayOutAmount),SUM(Cashout),0,0,0
     FROM @TempSummaryBet  GROUP BY BranchName,ParentBranch'+
  ' delete from @TempSummaryBet'


  


  set @sqlcommand9=' declare @TempSummaryBet3 table (ParentBranch nvarchar(50),SlipCount int,SlipAmount money,OpenSlipCount int,OpenSlipAmount money,OpenSlipPayOut money,WonSlipCount int,WonSlipAmount money,WonSlipPayOut money,LostSlipCount int,LostSlipAmount money,CancelSlipCount int,CancelSlipAmount money,TurnOver money,PartnerTurnOver money,BranchName nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS,TaxCount int,TaxAmount money,BranchTaxAmount money,PayOutCount int,PayOutAmount money,Cashout money,Bonus money ,OnlineDeposit money,OnlineWithDraw money) '+
  ' insert @TempSummaryBet3 '+
  '   SELECT tp2.ParentBranch,SUM(ISNULL(SlipCount,0))
,SUM(ISNULL(SlipAmount,0)),SUM(ISNULL(OpenSlipCount,0)),SUM(ISNULL(OpenSlipAmount,0)),SUM(ISNULL(OpenSlipPayOut,0)),SUM(ISNULL(WonSlipCount,0)) ,SUM(ISNULL(WonSlipAmount,0))
,SUM(ISNULL(WonSlipPayOut,0)),SUM(ISNULL(LostSlipCount,0)),SUM(ISNULL(LostSlipAmount,0)),SUM(ISNULL(CancelSlipCount,0)),SUM(ISNULL(CancelSlipAmount,0)),SUM(ISNULL(TurnOver,0)) as TurnOver
,SUM(ISNULL(PartnerTurnOver,0))
,tp2.BranchName,SUM(ISNULL(TaxCount,0)),SUM(ISNULL(TaxAmount,0)),SUM(ISNULL(BranchTaxAmount,0)),SUM(ISNULL(PayOutCount,0)),SUM(ISNULL(PayOutAmount,0)),SUM(ISNULL(Cashout,0)),SUM(ISNULL(Bonus,0))
 ,SUM(ISNULL(OnlineDeposit,0)),SUM(ISNULL(OnlineWithDraw,0))
     FROM @TempSummaryBet2 as tp2 
	 GROUP BY BranchName,ParentBranch '

	 set @sqlcommand9+=' insert @TempSummaryBet3 '+
  '   SELECT ''Total'',SUM(ISNULL(SlipCount,0))
,SUM(ISNULL(SlipAmount,0)),SUM(ISNULL(OpenSlipCount,0)),SUM(ISNULL(OpenSlipAmount,0)),SUM(ISNULL(OpenSlipPayOut,0)),SUM(ISNULL(WonSlipCount,0)) ,SUM(ISNULL(WonSlipAmount,0))
,SUM(ISNULL(WonSlipPayOut,0)),SUM(ISNULL(LostSlipCount,0)),SUM(ISNULL(LostSlipAmount,0)),SUM(ISNULL(CancelSlipCount,0)),SUM(ISNULL(CancelSlipAmount,0)),SUM(ISNULL(TurnOver,0)) as TurnOver
,SUM(ISNULL(PartnerTurnOver,0))
,''Total'',SUM(ISNULL(TaxCount,0)),SUM(ISNULL(TaxAmount,0)),SUM(ISNULL(BranchTaxAmount,0)),SUM(ISNULL(PayOutCount,0)),SUM(ISNULL(PayOutAmount,0)),SUM(ISNULL(Cashout,0)),SUM(ISNULL(Bonus,0))
 ,SUM(ISNULL(OnlineDeposit,0)),SUM(ISNULL(OnlineWithDraw,0))
     FROM @TempSummaryBet2 as tp2 ' 



   set @sqlcommand10=' declare @total int '+
'select @total=COUNT(SlipCount)  '+
'FROM       @TempSummaryBet3 as tmp LEFT OUTER JOIN Parameter.Branch On tmp.BranchName=Parameter.Branch.BrancName
WHERE    1=1 ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
'	 ParentBranch,ISNULL([SlipCount],0)  as [SlipCount]
       ,ISNULL( SlipAmount,0) as [SlipAmount]
      ,ISNULL([OpenSlipCount],0)  as [OpenSlipCount]
      ,ISNULL( [OpenSlipAmount],0)  as [OpenSlipAmount]
      ,ISNULL([OpenSlipPayOut],0)  as [OpenSlipPayOut]
      ,ISNULL([WonSlipCount],0)  as [WonSlipCount]
      ,ISNULL( [WonSlipAmount],0) as [WonSlipAmount]
      ,ISNULL([WonSlipPayOut],0)  as [WonSlipPayOut]
      ,ISNULL([LostSlipCount],0)  as [LostSlipCount]
      ,ISNULL([LostSlipAmount],0)  as [LostSlipAmount]
      ,ISNULL([CancelSlipCount],0)  as [CancelSlipCount]
      ,ISNULL([CancelSlipAmount],0) as [CancelSlipAmount]
      ,cast(0 as money) as SumTurnOver
	  ,BranchName
	  ,(ISNULL(PartnerTurnOver,0)) as BranchTurnOver
	  ,ISNULL(TurnOver,0) as TurnOver
	  ,ISNULL([TaxCount],0)  as [TaxCount]
      ,ISNULL(ISNULL([TaxAmount],0),0)  as [TaxAmount]
	  ,ISNULL(ISNULL([BranchTaxAmount],0),0)  as [BranchTaxAmount]
	  ,cast(0 as money)  as SumTaxAmount
	  ,ISNULL([PayOutCount],0)  as [PayOutCount]
      ,ISNULL(ISNULL([PayOutAmount],0),0)  as PayOutAmount,ISNULL(ISNULL([Cashout],0),0)  as Cashout,ISNULL(ISNULL([Bonus],0),0)  as Bonus ,ISNULL(ISNULL([OnlineDeposit],0),0)  as OnlineDeposit,ISNULL(ISNULL([OnlineWithDraw],0),0)  as OnlineWithDraw '+
'FROM        @TempSummaryBet3 as tmp LEFT OUTER JOIN Parameter.Branch On tmp.BranchName=Parameter.Branch.BrancName
WHERE  1=1  and SlipAmount>0'+
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '
 end
 else
	begin
				
 set @sqlcommand2=' declare @TempSummaryBet table (ParentBranch nvarchar(50),SlipCount int,SlipAmount money,OpenSlipCount int,OpenSlipAmount money,OpenSlipPayOut money,WonSlipCount int,WonSlipAmount money,WonSlipPayOut money,LostSlipCount int,LostSlipAmount money,CancelSlipCount int,CancelSlipAmount money,TurnOver money,PartnerTurnOver money,BranchName nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS,TaxCount int,TaxAmount money,BranchTaxAmount money,PayOutCount int,PayOutAmount money,Cashout money,Bonus money ,OnlineDeposit money,OnlineWithDraw money) '+
  'insert @TempSummaryBet (ParentBranch,SlipCount,SlipAmount,BranchName) '+
    'select (select P.BrancName from Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId), COUNT(CustomerSlip.SlipCount)
,SUM(CustomerSlip.SlipAmount)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
From Report.SummarySportBetting as CustomerSlip  with (nolock) inner join Customer.Customer with (nolock)  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch  as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where   CustomerSlip.Isview=1 and
 cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal '

 

  SET @sqlcommand2 +=   ' insert @TempSummaryBet (ParentBranch,OpenSlipCount,OpenSlipAmount,BranchName) '+
      'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId), COUNT(Customer.Slip.SlipId)
,SUM(dbo.FuncCurrencyConverter(Customer.Slip.Amount,Customer.Slip.CurrencyId,'+cast(@UserCurrencyId as nvarchar(10))+'))
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
From Customer.Slip with (nolock) inner join Customer.Customer with (nolock) on Customer.Slip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where Customer.Slip.SlipStatu not in (2,4)  and Customer.Slip.SlipStateId=1  and Customer.Slip.SlipTypeId<3
and cast(DATEADD(HOUR,1,Customer.Slip.CreateDate) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(DATEADD(HOUR,1,Customer.Slip.CreateDate) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal '
 
 
    SET @sqlcommand2 +=   ' insert @TempSummaryBet (ParentBranch,OpenSlipCount,OpenSlipAmount,BranchName) '+
        'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId), COUNT(Customer.SlipSystem.SystemSlipId)
,SUM( Customer.SlipSystem.Amount)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
From Customer.SlipSystem with (nolock) inner join Customer.Customer with (nolock) on Customer.SlipSystem.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where   Customer.SlipSystem.SlipStateId=1  and Customer.SlipSystem.NewSlipTypeId in (4,5)
and cast( DATEADD(HOUR,1,Customer.SlipSystem.CreateDate) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( DATEADD(HOUR,1,Customer.SlipSystem.CreateDate) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.SlipSystem.SourceId,PB.IsTerminal '


 --select @sqlcommand2

   SET @sqlcommand22 +=   ' insert @TempSummaryBet (ParentBranch,WonSlipCount ,WonSlipAmount ,WonSlipPayOut,BranchName) '+
      'select (select P.BrancName from Parameter.Branch as P  where P.BranchId=PB.ParentBranchId), SUM(CustomerSlip.WonSlipCount)
,SUM(CustomerSlip.WonSlipAmount)
,SUM(WonSlipPayOut)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
From Report.SummarySportBetting as CustomerSlip with (nolock) inner join Customer.Customer with (nolock) on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
   Parameter.Branch  as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and  cast( CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal '
 

      SET @sqlcommand22 +=   ' insert @TempSummaryBet (ParentBranch,Bonus,BranchName ) '+
    'select (select P.BrancName from Parameter.Branch as P  where P.BranchId=PB.ParentBranchId), SUM(CustomerSlip.Amount)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
From Customer.[Transaction] as CustomerSlip with (nolock)  inner join Customer.Customer with (nolock)  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
   Parameter.Branch  as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  (Customer.Customer.IsTerminalCustomer=0 or Customer.Customer.IsTerminalCustomer is null)  and (Customer.Customer.IsBranchCustomer=0 or Customer.Customer.IsBranchCustomer is null) and CustomerSlip.TransactionTypeId=35 and  cast( CustomerSlip.TransactionDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( CustomerSlip.TransactionDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal '

     SET @sqlcommand221 +=   ' insert @TempSummaryBet (ParentBranch,Cashout,BranchName) '+
     'select (select P.BrancName from Parameter.Branch  as P  where P.BranchId=PB.ParentBranchId)
,SUM(CustomerSlip.CashoutSlipAmount)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
From Report.SummarySportBetting as CustomerSlip with (nolock) inner join Customer.Customer with (nolock) on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal '

  
  SET @sqlcommand222 +=   ' insert @TempSummaryBet (ParentBranch,LostSlipCount ,LostSlipAmount,BranchName) '+
    'select (select P.BrancName from Parameter.Branch  as P with (nolock) where P.BranchId=PB.ParentBranchId), SUM(CustomerSlip.LostSlipCount)
,SUM(CustomerSlip.LostSlipAmount)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
From Report.SummarySportBetting as CustomerSlip with (nolock) inner join Customer.Customer with (nolock) on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch  as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal '
 

 SET @sqlcommand222 +=   ' insert @TempSummaryBet (ParentBranch,CancelSlipCount ,CancelSlipAmount,BranchName) '+
     'select (select P.BrancName from Parameter.Branch  as P with (nolock) where P.BranchId=PB.ParentBranchId), COUNT(CustomerSlip.CancelSlipCount)
,SUM(CustomerSlip.CancelSlipAmount)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
From Report.SummarySportBetting as CustomerSlip with (nolock) inner join Customer.Customer with (nolock) on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch  as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal '

 
  SET @sqlcommand2222 +=   ' insert @TempSummaryBet (ParentBranch,TaxCount ,TaxAmount,BranchName) '+
      'select (select P.BrancName from Parameter.Branch  as P with (nolock) where P.BranchId=PB.ParentBranchId), COUNT(CustomerSlip.TaxCount)
,SUM(CustomerSlip.Tax)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
From Report.SummarySportBetting as CustomerSlip with (nolock) inner join Customer.Customer with (nolock) on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch  as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal '

 SET @sqlcommand2222 +=   ' insert @TempSummaryBet (ParentBranch, BranchTaxAmount,BranchName) '+
    '	select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId)
	
	,case when Customer.Slip.SlipStateId in (3,5,6) and Customer.slip.TotalOddValue>1 then   SUM(dbo.FuncCurrencyConverter(ISNULL(Amount,0)*TotalOddValue,Customer.Slip.CurrencyId,'+cast(@UserCurrencyId as nvarchar(10))+')) else case when (Customer.Slip.SlipStateId in (2) or (Customer.Slip.SlipStateId=3 and Customer.slip.TotalOddValue=1) ) 	then   dbo.FuncCurrencyConverter(SUM(Customer.Slip.Amount) +ISNULL((Select SUM(Customer.Tax.TaxAmount) from Customer.Tax with (nolock)  where SlipId=Customer.Slip.SlipId),0),Customer.Slip.CurrencyId,'+cast(@UserCurrencyId as nvarchar(10))+') else 0 end end As Total
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end

from Customer.Slip with (nolock) INNER JOIN Customer.Customer with (nolock)
ON Customer.Customer.CustomerId=Customer.Slip.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
where (IsPayOut=0 or IsPayOut is null) and SlipStateId in (2,3,5,6)  
 and  Customer.Slip.SlipTypeId<3 and cast( DATEADD(HOUR,1,Customer.Slip.EvaluateDate ) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( DATEADD(HOUR,1,Customer.Slip.EvaluateDate ) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.Slip.SlipStateId,Customer.Slip.SlipId,Customer.slip.TotalOddValue,Customer.Slip.CurrencyId,PB.IsTerminal '

  SET @sqlcommand2222 +=' insert @TempSummaryBet (ParentBranch, BranchTaxAmount,BranchName) '+
    '	select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId)
	,case when Archive.Slip.SlipStateId in (3,5,6) and Archive.slip.TotalOddValue>1 then   SUM(dbo.FuncCurrencyConverter(ISNULL(Amount,0)*TotalOddValue,Archive.Slip.CurrencyId,'+cast(@UserCurrencyId as nvarchar(10))+')) else case when (Archive.Slip.SlipStateId in (2) or (Archive.Slip.SlipStateId=3 and Archive.slip.TotalOddValue=1) ) 	then   dbo.FuncCurrencyConverter(SUM(Archive.Slip.Amount) +ISNULL((Select SUM(Customer.Tax.TaxAmount) from Customer.Tax with (nolock)  where SlipId=Archive.Slip.SlipId),0),Archive.Slip.CurrencyId,'+cast(@UserCurrencyId as nvarchar(10))+') else 0 end end As Total
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
from Archive.Slip with (nolock) INNER JOIN Customer.Customer with (nolock)
ON Customer.Customer.CustomerId=Archive.Slip.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
where (IsPayOut=0 or IsPayOut is null) and SlipStateId in (2,3,5,6)  
 and ( IsBranchCustomer=1) and Archive.Slip.SlipTypeId<3 and cast( DATEADD(HOUR,1,Archive.Slip.EvaluateDate) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( DATEADD(HOUR,1,Archive.Slip.EvaluateDate) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Archive.Slip.SlipStateId,Archive.Slip.SlipId,Archive.slip.TotalOddValue,Archive.Slip.CurrencyId,PB.IsTerminal '


  SET @sqlcommand2222 +=   ' insert @TempSummaryBet (ParentBranch, BranchTaxAmount,BranchName) '+
    '	select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId)
	,cast(ISNULL((Select SUM(dbo.FuncCurrencyConverter(ISNULL(Amount,0)*TotalOddValue,Customer.Slip.CurrencyId,'+cast(@UserCurrencyId as nvarchar(10))+'))
 from Customer.Slip where Customer.Slip.SlipStateId in (3,6) and Customer.Slip.SlipTypeId=3
  and Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) ),0) as money) 
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
from Customer.SlipSystem INNER JOIN Customer.Customer with (nolock)
ON Customer.Customer.CustomerId=Customer.SlipSystem.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
where (IsPayOut=0 or IsPayOut is null) and SlipStateId in (2,3,5,6)  
 and ( IsBranchCustomer=1)  and cast( DATEADD(HOUR,1,Customer.SlipSystem.EvaluateDate) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( DATEADD(HOUR,1,Customer.SlipSystem.EvaluateDate) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.SlipSystem.SystemSlipId,PB.IsTerminal '

   SET @sqlcommand2222 +=   ' insert @TempSummaryBet (ParentBranch, BranchTaxAmount,BranchName) '+
    '	select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId)
	,cast(ISNULL((Select SUM(dbo.FuncCurrencyConverter(ISNULL(Amount,0)*TotalOddValue,Archive.Slip.CurrencyId,'+cast(@UserCurrencyId as nvarchar(10))+'))
 from Archive.Slip where Archive.Slip.SlipStateId in (3,6) and Archive.Slip.SlipTypeId=3
  and Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId) ),0) as money) 
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
from Customer.SlipSystem with (nolock) INNER JOIN Customer.Customer with (nolock)
ON Customer.Customer.CustomerId=Customer.SlipSystem.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
where (IsPayOut=0 or IsPayOut is null) and SlipStateId in (2,3,5,6)  
 and ( IsBranchCustomer=1)  and cast( DATEADD(HOUR,1,Customer.SlipSystem.EvaluateDate) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( DATEADD(HOUR,1,Customer.SlipSystem.EvaluateDate) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.SlipSystem.SystemSlipId,PB.IsTerminal '   

--   SET @sqlcommand22222 +=   ' insert @TempSummaryBet (ParentBranch,PartnerTurnOver ,BranchTaxAmount,BranchName) '+
--    '	 SELECT (select ppp.BrancName COLLATE SQL_Latin1_General_CP1_CI_AS from Parameter.Branch as ppp with (nolock) where ppp.BranchId in (select pp.ParentBranchId from Parameter.Branch as pp with (nolock) where pp.BrancName COLLATE SQL_Latin1_General_CP1_CI_AS=tp.ParentBranch))
--, ISNULL(SUM(SlipAmount),0)-((ISNULL(sum(WonSlipPayOut),0)+ISNULL(sum(Cashout),0)+ISNULL(SUM(CancelSlipAmount),0))) as Profit
-- ,ISNULL(SUM(TaxAmount),0) as TaxAmount
-- ,TP.ParentBranch COLLATE SQL_Latin1_General_CP1_CI_AS
-- FROM @TempSummaryBet as TP 
-- where (TP.ParentBranch in (select ppp.BrancName COLLATE SQL_Latin1_General_CP1_CI_AS from Parameter.Branch as ppp with (nolock) where ppp.BranchId in (select pp.ParentBranchId from Parameter.Branch as pp with (nolock) where pp.BrancName COLLATE SQL_Latin1_General_CP1_CI_AS=tp.BranchName))) 
-- GROUP BY  TP.[BranchName],TP.ParentBranch   HAVING SUM(SlipAmount) is not null'




 SET  @sqlcommand22222 +=   ' insert @TempSummaryBet (ParentBranch,PayOutCount ,PayOutAmount,BranchName)'+
 'select (select P.BrancName from Parameter.Branch  as P with (nolock) where P.BranchId=PB.ParentBranchId), COUNT(CustomerSlip.PayOutCount)
,SUM(CustomerSlip.PayOutAmount)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
From Report.SummarySportBetting as CustomerSlip with (nolock)  inner join Customer.Customer with (nolock)  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch  as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal '
 
    SET @sqlcommand22222 +=   ' insert @TempSummaryBet (ParentBranch,OnlineDeposit ,OnlineWithDraw,BranchName) '+
  'select (select P.BrancName from Parameter.Branch  as P  where P.BranchId=PB.ParentBranchId) 
,SUM(CustomerSlip.OnlineDeposit)
,SUM(CustomerSlip.OnlineWithDraw)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
From Report.SummarySportBetting as CustomerSlip  inner join Customer.Customer  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  Parameter.Branch  as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  CustomerSlip.Isview=1 and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal '
 

  set @sqlcommand3+=' declare @TempSummaryBet2 table (ParentBranch nvarchar(50),SlipCount int,SlipAmount money,OpenSlipCount int,OpenSlipAmount money,OpenSlipPayOut money,WonSlipCount int,WonSlipAmount money,WonSlipPayOut money,LostSlipCount int,LostSlipAmount money,CancelSlipCount int,CancelSlipAmount money,TurnOver money,PartnerTurnOver money,BranchName nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS,TaxCount int,TaxAmount money,BranchTaxAmount money,PayOutCount int,PayOutAmount money,Cashout money,Bonus money ,OnlineDeposit money,OnlineWithDraw money) '+
  ' insert @TempSummaryBet2 '+
  'SELECT ParentBranch,SUM(SlipCount),SUM(dbo.FuncCurrencyConverter(SlipAmount,3,'+cast(@UserCurrencyId as nvarchar(10))+'))
  ,SUM(OpenSlipCount),SUM(dbo.FuncCurrencyConverter(OpenSlipAmount,3,'+cast(@UserCurrencyId as nvarchar(10))+'))
  ,SUM(dbo.FuncCurrencyConverter(OpenSlipPayOut,3,'+cast(@UserCurrencyId as nvarchar(10))+')),SUM(WonSlipCount) 
  ,SUM(dbo.FuncCurrencyConverter(WonSlipAmount,3,'+cast(@UserCurrencyId as nvarchar(10))+'))
  ,SUM(dbo.FuncCurrencyConverter(WonSlipPayOut,3,'+cast(@UserCurrencyId as nvarchar(10))+'))
  ,SUM(LostSlipCount)
  ,SUM(dbo.FuncCurrencyConverter(LostSlipAmount,3,'+cast(@UserCurrencyId as nvarchar(10))+'))
  ,SUM(CancelSlipCount)
  ,SUM(dbo.FuncCurrencyConverter(CancelSlipAmount,3,'+cast(@UserCurrencyId as nvarchar(10))+'))
  ,ISNULL(SUM(dbo.FuncCurrencyConverter(SlipAmount,3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)-(ISNULL(SUM(dbo.FuncCurrencyConverter(WonSlipPayOut,3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)+ISNULL(SUM(dbo.FuncCurrencyConverter(Cashout,3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)+ISNULL(SUM(dbo.FuncCurrencyConverter(CancelSlipAmount,3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)+ISNULL(SUM(dbo.FuncCurrencyConverter(Bonus,3,'+cast(@UserCurrencyId as nvarchar(10))+')),0))
  ,(ISNULL(SUM(dbo.FuncCurrencyConverter(WonSlipPayOut,3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)+ISNULL(SUM(dbo.FuncCurrencyConverter(Cashout,3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)+ISNULL(SUM(dbo.FuncCurrencyConverter(CancelSlipAmount,3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)+ISNULL(SUM(dbo.FuncCurrencyConverter(Bonus,3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)),BranchName,SUM(TaxCount)
  ,SUM(dbo.FuncCurrencyConverter(TaxAmount,3,'+cast(@UserCurrencyId as nvarchar(10))+')),SUM(BranchTaxAmount),SUM(PayOutCount)
  ,SUM(dbo.FuncCurrencyConverter(WonSlipPayOut,3,'+cast(@UserCurrencyId as nvarchar(10))+'))
  ,SUM(dbo.FuncCurrencyConverter(Cashout,3,'+cast(@UserCurrencyId as nvarchar(10))+'))  ,SUM(dbo.FuncCurrencyConverter(Bonus,3,'+cast(@UserCurrencyId as nvarchar(10))+'))
   ,SUM(ISNULL(OnlineDeposit,0)),SUM(ISNULL(OnlineWithDraw,0))
     FROM @TempSummaryBet GROUP BY BranchName,ParentBranch   '+
  ' delete from @TempSummaryBet'
 
	
 

  set @sqlcommand3+= ' insert @TempSummaryBet '+
  'select (select P.BrancName from Parameter.Branch  as P with (nolock) where P.BranchId=PB.ParentBranchId)
      ,       ISNULL(SUM([SlipCount]),0)  as [SlipCount]
      ,ISNULL( SUM(dbo.FuncCurrencyConverter([SlipAmount],3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)  as [SlipAmount]
      ,ISNULL(SUM([OpenSlipCount]),0)  as [OpenSlipCount]
      ,ISNULL( SUM(dbo.FuncCurrencyConverter([OpenSlipAmount],3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)  as [OpenSlipAmount]
      ,ISNULL( SUM(dbo.FuncCurrencyConverter([OpenSlipPayOut],3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)  as [OpenSlipPayOut]
      ,ISNULL(SUM([WonSlipCount]),0)  as [WonSlipCount]
      ,ISNULL( SUM(dbo.FuncCurrencyConverter([WonSlipAmount],3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)  as [WonSlipAmount]
      ,ISNULL( SUM(dbo.FuncCurrencyConverter([WonSlipPayOut],3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)  as [WonSlipPayOut]
      ,ISNULL(SUM([LostSlipCount]),0)  as [LostSlipCount]
      ,ISNULL( SUM(dbo.FuncCurrencyConverter([LostSlipAmount],3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)  as [LostSlipAmount]
      ,ISNULL(SUM([CancelSlipCount]),0)  as [CancelSlipCount]
      ,ISNULL( SUM(dbo.FuncCurrencyConverter([CancelSlipAmount],3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)  as [CancelSlipAmount]
      ,ISNULL(SUM(dbo.FuncCurrencyConverter([SlipAmount],3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)-((ISNULL(SUM(dbo.FuncCurrencyConverter([WonSlipAmount],3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)+ISNULL(SUM(dbo.FuncCurrencyConverter([CancelSlipAmount],3,'+cast(@UserCurrencyId as nvarchar(10))+')),0))) as TurnOver
	 	   ,((ISNULL(SUM(dbo.FuncCurrencyConverter([WonSlipAmount],3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)+ISNULL(SUM(dbo.FuncCurrencyConverter([CancelSlipAmount],3,'+cast(@UserCurrencyId as nvarchar(10))+')),0))) as BranchTurnOver			
	  ,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
	  ,0  as [TaxCount]
      ,0  as [Tax]
	  ,0
	  ,0 as [PayOutCount]
      ,ISNULL( SUM(dbo.FuncCurrencyConverter([WonSlipPayOut],3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)   as [PayOutAmount],0 as Cashout,0,0,0
  FROM [Report].[SummaryCasinoBetting] INNER JOIN 
  Customer.Customer ON Customer.Customer.CustomerId=[Report].[SummaryCasinoBetting].CustomerId INNER JOIN
  [Parameter].[Branch] as PB ON  PB.[BranchId]=Customer.Customer.BranchId 
  Where cast([Report].[SummaryCasinoBetting].ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast([Report].[SummaryCasinoBetting].ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' and '+@where2 + ' and '+ @where +'  
  GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal; '

 
   
  set @sqlcommand5= ' insert @TempSummaryBet2 '+
  'SELECT ParentBranch,SUM(SlipCount),SUM(SlipAmount),SUM(OpenSlipCount),SUM(OpenSlipAmount),SUM(OpenSlipPayOut),SUM(WonSlipCount) ,SUM(WonSlipAmount),SUM(WonSlipPayOut),SUM(LostSlipCount),SUM(LostSlipAmount),SUM(CancelSlipCount),SUM(CancelSlipAmount),SUM(TurnOver),SUM(PartnerTurnOver),BranchName,SUM(TaxCount),SUM(TaxAmount),SUM(BranchTaxAmount),SUM(PayOutCount),SUM(PayOutAmount),SUM(Cashout),0,0,0
     FROM @TempSummaryBet GROUP BY BranchName,ParentBranch '+
	 ' delete from @TempSummaryBet '
 

   set @sqlcommand6= ' insert @TempSummaryBet '+
  'select (select P.BrancName from Parameter.Branch  as P with (nolock) where P.BranchId=PB.ParentBranchId)
      , ISNULL(SUM([SlipCount]),0)  as [SlipCount]
      ,ISNULL( SUM(dbo.FuncCurrencyConverter([SlipAmount],3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)  as [SlipAmount]
      ,ISNULL(SUM([OpenSlipCount]),0)  as [OpenSlipCount]
      ,ISNULL( SUM(dbo.FuncCurrencyConverter([OpenSlipAmount],3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)  as [OpenSlipAmount]
      ,ISNULL(SUM(dbo.FuncCurrencyConverter([OpenSlipPayOut],3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)  as [OpenSlipPayOut]
      ,ISNULL(SUM([WonSlipCount]),0)  as [WonSlipCount]
      ,ISNULL(SUM(dbo.FuncCurrencyConverter([WonSlipAmount],3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)  as [WonSlipAmount]
      ,ISNULL(SUM(dbo.FuncCurrencyConverter([WonSlipAmount],3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)  as [WonSlipPayOut]
      ,ISNULL(SUM([LostSlipCount]),0)  as [LostSlipCount]
      ,ISNULL(SUM(dbo.FuncCurrencyConverter([LostSlipAmount],3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)  as [LostSlipAmount]
      ,ISNULL(SUM([CancelSlipCount]),0)  as [CancelSlipCount]
      ,ISNULL(SUM(dbo.FuncCurrencyConverter([CancelSlipAmount],3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)  as [CancelSlipAmount]
      ,ISNULL(SUM(dbo.FuncCurrencyConverter([SlipAmount],3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)-((ISNULL(SUM(dbo.FuncCurrencyConverter([WonSlipAmount],3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)+ISNULL(SUM(dbo.FuncCurrencyConverter([CancelSlipAmount],3,'+cast(@UserCurrencyId as nvarchar(10))+')),0))) as TurnOver
	 	   ,((ISNULL(SUM(dbo.FuncCurrencyConverter([WonSlipAmount],3,'+cast(@UserCurrencyId as nvarchar(10))+')),0)+ISNULL(SUM(dbo.FuncCurrencyConverter([CancelSlipAmount],3,'+cast(@UserCurrencyId as nvarchar(10))+')),0))) as BranchTurnOver	
	 ,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
	  ,0  as [TaxCount]
      ,0  as [Tax]
	  ,0
	  ,0 as [PayOutCount]
      ,ISNULL(SUM(dbo.FuncCurrencyConverter([WonSlipAmount],3,'+cast(@UserCurrencyId as nvarchar(10))+')),0) as [PayOutAmount],0 as Cashout,0,0,0
  FROM [Report].[SummaryVirtualBetting] INNER JOIN 
  Customer.Customer ON Customer.Customer.CustomerId=[Report].[SummaryVirtualBetting].CustomerId INNER JOIN
  [Parameter].[Branch] as PB ON  PB.[BranchId]=Customer.Customer.BranchId 
  Where cast([Report].[SummaryVirtualBetting].ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast([Report].[SummaryVirtualBetting].ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND  '+@where2 + ' and '+ @where +'  
  GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal; '

 

  set @sqlcommand8=  ' insert @TempSummaryBet2 '+
  'SELECT ParentBranch,SUM(SlipCount),SUM(SlipAmount),SUM(OpenSlipCount),SUM(OpenSlipAmount),SUM(OpenSlipPayOut),SUM(WonSlipCount) ,SUM(WonSlipAmount),SUM(WonSlipPayOut),SUM(LostSlipCount),SUM(LostSlipAmount),SUM(CancelSlipCount),SUM(CancelSlipAmount),SUM(TurnOver),SUM(PartnerTurnOver),BranchName,SUM(TaxCount),SUM(TaxAmount),SUM(BranchTaxAmount),SUM(PayOutCount),SUM(PayOutAmount),SUM(Cashout),0,0,0
     FROM @TempSummaryBet  GROUP BY BranchName,ParentBranch'+
  ' delete from @TempSummaryBet'


  


  set @sqlcommand9=' declare @TempSummaryBet3 table (ParentBranch nvarchar(50),SlipCount int,SlipAmount money,OpenSlipCount int,OpenSlipAmount money,OpenSlipPayOut money,WonSlipCount int,WonSlipAmount money,WonSlipPayOut money,LostSlipCount int,LostSlipAmount money,CancelSlipCount int,CancelSlipAmount money,TurnOver money,PartnerTurnOver money,BranchName nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS,TaxCount int,TaxAmount money,BranchTaxAmount money,PayOutCount int,PayOutAmount money,Cashout money,Bonus money ,OnlineDeposit money,OnlineWithDraw money) '+
  ' insert @TempSummaryBet3 '+
  '   SELECT tp2.ParentBranch,SUM(ISNULL(SlipCount,0))
,SUM(ISNULL(SlipAmount,0)),SUM(ISNULL(OpenSlipCount,0)),SUM(ISNULL(OpenSlipAmount,0)),SUM(ISNULL(OpenSlipPayOut,0)),SUM(ISNULL(WonSlipCount,0)) ,SUM(ISNULL(WonSlipAmount,0))
,SUM(ISNULL(WonSlipPayOut,0)),SUM(ISNULL(LostSlipCount,0)),SUM(ISNULL(LostSlipAmount,0)),SUM(ISNULL(CancelSlipCount,0)),SUM(ISNULL(CancelSlipAmount,0)),SUM(ISNULL(TurnOver,0)) as TurnOver
,SUM(ISNULL(PartnerTurnOver,0))
,tp2.BranchName,SUM(ISNULL(TaxCount,0)),SUM(ISNULL(TaxAmount,0)),SUM(ISNULL(BranchTaxAmount,0)),SUM(ISNULL(PayOutCount,0)),SUM(ISNULL(PayOutAmount,0)),SUM(ISNULL(Cashout,0)),SUM(ISNULL(Bonus,0))
 ,SUM(ISNULL(OnlineDeposit,0)),SUM(ISNULL(OnlineWithDraw,0))
     FROM @TempSummaryBet2 as tp2 
	 GROUP BY BranchName,ParentBranch '


	  set @sqlcommand9+=' insert @TempSummaryBet3 '+
  '   SELECT ''Total'',SUM(ISNULL(SlipCount,0))
,SUM(ISNULL(SlipAmount,0)),SUM(ISNULL(OpenSlipCount,0)),SUM(ISNULL(OpenSlipAmount,0)),SUM(ISNULL(OpenSlipPayOut,0)),SUM(ISNULL(WonSlipCount,0)) ,SUM(ISNULL(WonSlipAmount,0))
,SUM(ISNULL(WonSlipPayOut,0)),SUM(ISNULL(LostSlipCount,0)),SUM(ISNULL(LostSlipAmount,0)),SUM(ISNULL(CancelSlipCount,0)),SUM(ISNULL(CancelSlipAmount,0)),SUM(ISNULL(TurnOver,0)) as TurnOver
,SUM(ISNULL(PartnerTurnOver,0))
,''Total'',SUM(ISNULL(TaxCount,0)),SUM(ISNULL(TaxAmount,0)),SUM(ISNULL(BranchTaxAmount,0)),SUM(ISNULL(PayOutCount,0)),SUM(ISNULL(PayOutAmount,0)),SUM(ISNULL(Cashout,0)),SUM(ISNULL(Bonus,0))
 ,SUM(ISNULL(OnlineDeposit,0)),SUM(ISNULL(OnlineWithDraw,0))
     FROM @TempSummaryBet2 as tp2 ' 


   set @sqlcommand10=' declare @total int '+
'select @total=COUNT(SlipCount)  '+
'FROM       @TempSummaryBet3 as tmp LEFT OUTER JOIN Parameter.Branch On tmp.BranchName=Parameter.Branch.BrancName
WHERE    1=1 ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
'	 ParentBranch,ISNULL([SlipCount],0)  as [SlipCount]
       ,ISNULL( SlipAmount,0) as [SlipAmount]
      ,ISNULL([OpenSlipCount],0)  as [OpenSlipCount]
      ,ISNULL( [OpenSlipAmount],0)  as [OpenSlipAmount]
      ,ISNULL([OpenSlipPayOut],0)  as [OpenSlipPayOut]
      ,ISNULL([WonSlipCount],0)  as [WonSlipCount]
      ,ISNULL( [WonSlipAmount],0) as [WonSlipAmount]
      ,ISNULL([WonSlipPayOut],0)  as [WonSlipPayOut]
      ,ISNULL([LostSlipCount],0)  as [LostSlipCount]
      ,ISNULL([LostSlipAmount],0)  as [LostSlipAmount]
      ,ISNULL([CancelSlipCount],0)  as [CancelSlipCount]
      ,ISNULL([CancelSlipAmount],0) as [CancelSlipAmount]
      ,cast(0 as money) as SumTurnOver
	  ,BranchName
	  ,(ISNULL(PartnerTurnOver,0)) as BranchTurnOver
	  ,ISNULL(TurnOver,0) as TurnOver
	  ,ISNULL([TaxCount],0)  as [TaxCount]
      ,ISNULL(ISNULL([TaxAmount],0),0)  as [TaxAmount]
	  ,ISNULL(ISNULL([BranchTaxAmount],0),0)  as [BranchTaxAmount]
	  ,cast(0 as money)  as SumTaxAmount
	  ,ISNULL([PayOutCount],0)  as [PayOutCount]
      ,ISNULL(ISNULL([PayOutAmount],0),0)  as PayOutAmount,ISNULL(ISNULL([Cashout],0),0)  as Cashout,ISNULL(ISNULL([Bonus],0),0)  as Bonus ,ISNULL(ISNULL([OnlineDeposit],0),0)  as OnlineDeposit,ISNULL(ISNULL([OnlineWithDraw],0),0)  as OnlineWithDraw  '+
'FROM        @TempSummaryBet3 as tmp LEFT OUTER JOIN Parameter.Branch On tmp.BranchName=Parameter.Branch.BrancName
WHERE  1=1   '+
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '

	end
 --select @wherePayout
 --select @sqlcommand+@sqlcommand1+@sqlcommand2+@sqlcommand22+@sqlcommand221+@sqlcommand222+@sqlcommand2222+@sqlcommand22222+@sqlcommand2T+@sqlcommand22T+@sqlcommand221T+@sqlcommand222T
-- select @sqlcommand2222T+ @sqlcommand3+@sqlcommand4+@sqlcommand5+@sqlcommand6+@sqlcommand7+@sqlcommand8+@sqlcommand88+@sqlcommand9+@sqlcommand10
 -- select @sqlcommand,@sqlcommand1,@sqlcommand2,@sqlcommand22,@sqlcommand221,@sqlcommand222,@sqlcommand2222,@sqlcommand22222, @sqlcommand3,@sqlcommand4,@sqlcommand5,@sqlcommand6,@sqlcommand7,@sqlcommand8,@sqlcommand88,@sqlcommand9,@sqlcommand10
  
  exec (@sqlcommandBranch+@sqlcommand+@sqlcommand1+@sqlcommand2+@sqlcommand22+@sqlcommand221+@sqlcommand222+@sqlcommand2222+@sqlcommand22222+ @sqlcommand3+@sqlcommand4+@sqlcommand5+@sqlcommand6+@sqlcommand7+@sqlcommand8+@sqlcommand88+@sqlcommand9+@sqlcommand10)

 end





END



GO
