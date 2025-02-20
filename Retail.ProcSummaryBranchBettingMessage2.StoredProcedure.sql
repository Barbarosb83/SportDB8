USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcSummaryBranchBettingMessage2]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcSummaryBranchBettingMessage2] 

@Username nvarchar(50),
@StartDate nvarchar(20),
@EndDate nvarchar(20)
AS
BEGIN
SET NOCOUNT ON;

 declare  @SourceId int=7
declare   @PageSize  INT=1000
 declare  @PageNum int=1
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

declare @where nvarchar(1000)='1=1'
declare @orderby nvarchar(100)='BranchId'
 

declare @UserCurrencyId int
declare @BranchId int
declare @where2 nvarchar(max)=' 1=1'
declare @SystemCurrencyId int
select top 1 @SystemCurrencyId=SystemCurrencyId from General.Setting 
select @BranchId=Users.Users.UnitCode, @UserCurrencyId=Users.Users.CurrencyId from Users.Users where Users.Users.UserName=@Username
declare @whereTerminal  nvarchar(max)=' 1=1'
	declare @where3 nvarchar(250)=''
	 

 
 
 
  exec Report.ProcSummarySportBettingFill1
 --  exec Report.ProcSummaryCasinoBettingFill1
  --  exec Report.ProcSummaryVirtualBettingFill1

		declare @wherePayout nvarchar(max)='1=1'
		
		
if(@BranchId<>1)
	begin

	set @where2=' [Parameter].[Branch].BranchId='+cast(@BranchId as nvarchar(7))

	end

		 if(@BranchId<>1)
	begin
	if (@BranchId<>32604)
		begin
			set @where2=' PB.BranchId in (select BranchId from [BettingReport].Parameter.Branch with (nolock)  where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId in (select BranchId from [BettingReport].Parameter.Branch with (nolock) where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ') ))) or PB.ParentBranchId in (select BranchId from [BettingReport].Parameter.Branch with (nolock)  where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId in (select BranchId from [BettingReport].Parameter.Branch with (nolock) where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ') )))'  
			set @whereTerminal='  Customer.BranchId in (select BranchId from [BettingReport].Parameter.Branch with (nolock) where IsTerminal=1 and (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ '   '
			set @wherePayout=' BranchId in (select BranchId from [BettingReport].Parameter.Branch with (nolock) where IsTerminal=0 and (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId in (select BranchId from [BettingReport].Parameter.Branch  where IsTerminal=0 and (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ') )))'  

		end
	else
		begin
			set @where2=' PB.ParentBranchId in ( (select BranchId from [BettingReport].Parameter.Branch as BB where  BB.BranchId in (select BranchId from [BettingReport].Parameter.Branch with (nolock)  where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId in (select BranchId from [BettingReport].Parameter.Branch with (nolock) where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ') ))) or BB.ParentBranchId in (select BranchId from [BettingReport].Parameter.Branch with (nolock)  where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId in (select BranchId from [BettingReport].Parameter.Branch with (nolock) where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ') )))))'  
			set @whereTerminal='  Customer.BranchId in (select BranchId from [BettingReport].Parameter.Branch with (nolock) where IsTerminal=1 and (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId in (select BranchId from [BettingReport].Parameter.Branch with (nolock)   where IsTerminal=0 and (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ') )) or ParentBranchId in (select BranchId from [BettingReport].Parameter.Branch with (nolock)   where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId in (select BranchId from [BettingReport].Parameter.Branch with (nolock) where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ') ))))'  
		end
	end
else
	set @whereTerminal='  Customer.BranchId in (select BranchId from [BettingReport].Parameter.Branch with (nolock) where IsTerminal=1) '
	 
 


if(@BranchId not in (1,32604))
begin	

set @sqlcommandBranch=' declare @TempBranchtable table (BranchId bigint) '+
' insert @TempBranchtable select BranchId from [BettingReport].Parameter.Branch with (nolock) where ( BranchId in (select BranchId from [BettingReport].Parameter.Branch with (nolock)  where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId in (select BranchId from [BettingReport].Parameter.Branch with (nolock) where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ') ))) or ParentBranchId in (select BranchId from [BettingReport].Parameter.Branch with (nolock)  where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId in (select BranchId from [BettingReport].Parameter.Branch with (nolock) where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ') ))) ) '




set @where2= ' ( PB.BranchId in (select BranchId from @TempBranchtable) or PB.ParentBranchId in (select BranchId from @TempBranchtable)) '
 
 --set @sqlcommandCustomer=' declare @TempCustomerTable table (CustomerId bigint,BranchId bigint) insert @TempCustomerTable select BranchId,CustomerId from Customer.Customer with (nolock) where ( BranchId in (select BranchId from [BettingReport].Parameter.Branch with (nolock)  where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId in (select BranchId from [BettingReport].Parameter.Branch with (nolock) where  (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ') )))  )'
  

 set @sqlcommand2=' declare @TempSummaryBet table (Parent nvarchar(50),ParentBranch nvarchar(50),SlipCount int,SlipAmount money,OpenSlipCount int,OpenSlipAmount money,OpenSlipPayOut money,WonSlipCount int,WonSlipAmount money,WonSlipPayOut money,LostSlipCount int,LostSlipAmount money,CancelSlipCount int,CancelSlipAmount money,TurnOver money,PartnerTurnOver money,BranchName nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS,TaxCount int,TaxAmount money,BranchTaxAmount money,PayOutCount int,PayOutAmount money,Cashout money,Bonus money ,OnlineDeposit money,OnlineWithDraw money) '+
  'insert @TempSummaryBet (Parent,ParentBranch,SlipCount,SlipAmount,BranchName) '+
    'select case when PB.IsTerminal=0 then PB.BrancName else  (select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId) end
	,case when PB.IsTerminal=0 then PB.BrancName else  (select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId) end
	, COUNT(CustomerSlip.SlipCount)
,SUM(CustomerSlip.[OrgSlipAmount])
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
From [BettingReport].Report.SummarySportBetting as CustomerSlip with (nolock)  INNER JOIN
  [BettingReport].Parameter.Branch  as PB with (nolock) ON  PB.[BranchId]=CustomerSlip.BranchId 
Where  CustomerSlip.Isview=1 and 
 cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal '
  

  SET @sqlcommand2 +=   ' insert @TempSummaryBet (Parent,ParentBranch,OpenSlipCount,OpenSlipAmount,BranchName) '+
      'select case when PB.IsTerminal=0 then PB.BrancName else  (select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId) end,case when PB.IsTerminal=0 then PB.BrancName else  (select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock)   where P.BranchId=PB.ParentBranchId) end, COUNT(Customer.Slip.SlipId)
,SUM( Customer.Slip.Amount)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
From Customer.Slip with (nolock) inner join Customer.Customer with (nolock) on Customer.Slip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where Customer.Slip.SlipStatu not in (2,4)  and Customer.Slip.SlipStateId=1  and Customer.Slip.SlipTypeId<3
and cast(DATEADD(HOUR,1,Customer.Slip.CreateDate) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(DATEADD(HOUR,1,Customer.Slip.CreateDate) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal '
 

   SET @sqlcommand2 +=   ' insert @TempSummaryBet (Parent,ParentBranch,OpenSlipCount,OpenSlipAmount,BranchName) '+
        'select case when PB.IsTerminal=0 then PB.BrancName else  (select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId) end
		,case when PB.IsTerminal=0 then PB.BrancName else  (select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId) end
		, COUNT(Customer.SlipSystem.SystemSlipId)
,SUM( Customer.SlipSystem.Amount)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
From Customer.SlipSystem with (nolock) inner join Customer.Customer with (nolock) on Customer.SlipSystem.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where   Customer.SlipSystem.SlipStateId=1  and Customer.SlipSystem.NewSlipTypeId in (4,5)
and cast( DATEADD(HOUR,1,Customer.SlipSystem.CreateDate) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( DATEADD(HOUR,1,Customer.SlipSystem.CreateDate) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.SlipSystem.SourceId,PB.IsTerminal '

   SET @sqlcommand22 +=   ' insert @TempSummaryBet (Parent,ParentBranch,WonSlipCount ,WonSlipAmount ,WonSlipPayOut,BranchName) '+
      'select case when PB.IsTerminal=0 then PB.BrancName else  (select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId) end,case when PB.IsTerminal=0 then PB.BrancName else  (select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId) end, SUM(CustomerSlip.WonSlipCount)
,SUM(CustomerSlip.[OrgWonSlipAmount])
,SUM([OrgWonSlipPayOut])
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
From [BettingReport].Report.SummarySportBetting as CustomerSlip with (nolock)  INNER JOIN
   [BettingReport].Parameter.Branch  as PB with (nolock) ON  PB.[BranchId]=CustomerSlip.BranchId 
Where   CustomerSlip.Isview=1 and cast( CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal '

      SET @sqlcommand22 +=   ' insert @TempSummaryBet (Parent,ParentBranch,Bonus,BranchName ) '+
    'select case when PB.IsTerminal=0 then PB.BrancName else  (select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId) end,case when PB.IsTerminal=0 then PB.BrancName else  (select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId) end, SUM(CustomerSlip.Amount)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
From Customer.[Transaction] as CustomerSlip with (nolock)  inner join Customer.Customer with (nolock)  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
   [BettingReport].Parameter.Branch  as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where (Customer.Customer.IsTerminalCustomer=0 or Customer.Customer.IsTerminalCustomer is null)  and (Customer.Customer.IsBranchCustomer=0 or Customer.Customer.IsBranchCustomer is null) and CustomerSlip.TransactionTypeId=35 and  cast( CustomerSlip.TransactionDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( CustomerSlip.TransactionDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal '

--    SET @sqlcommand22 +=   ' insert @TempSummaryBet (ParentBranch,Bonus,BranchName ) '+
--     'select case when PB.IsTerminal=0 then PB.BrancName else  (select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId) end 
--,SUM(CustomerSlip.BonusAmount)
--,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
--From [BettingReport].Report.SummarySportBetting as CustomerSlip with (nolock)   INNER JOIN
--   [BettingReport].Parameter.Branch  as PB with (nolock) ON  PB.[BranchId]=CustomerSlip.BranchId 
--Where   CustomerSlip.Isview=1 and cast( CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
--and cast( CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
-- GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal '
 

     SET @sqlcommand221 +=   ' insert @TempSummaryBet (Parent,ParentBranch,Cashout,BranchName) '+
     'select case when PB.IsTerminal=0 then PB.BrancName else  (select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId) end,case when PB.IsTerminal=0 then PB.BrancName else  (select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId) end
,SUM(CustomerSlip.[OrgCashoutSlipAmount])
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
From [BettingReport].Report.SummarySportBetting as CustomerSlip with (nolock)  INNER JOIN
  [BettingReport].Parameter.Branch as PB with (nolock)  ON  PB.[BranchId]=CustomerSlip.BranchId 
Where  CustomerSlip.Isview=1 and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal '

  
--  SET @sqlcommand222 +=   ' insert @TempSummaryBet (Parent,ParentBranch,LostSlipCount ,LostSlipAmount,BranchName) '+
--    'select case when PB.IsTerminal=0 then PB.BrancName else  (select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId) end,case when PB.IsTerminal=0 then PB.BrancName else  (select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId) end, SUM(CustomerSlip.LostSlipCount)
--,SUM(CustomerSlip.[OrgLostSlipAmount])
--,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
--From [BettingReport].Report.SummarySportBetting as CustomerSlip with (nolock)    INNER JOIN
--  [BettingReport].Parameter.Branch  as PB with (nolock) ON  PB.[BranchId]=CustomerSlip.BranchId 
--Where CustomerSlip.Isview=1 and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
--and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
-- GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal '

      SET @sqlcommand222 +=   ' insert @TempSummaryBet (Parent,ParentBranch,LostSlipAmount,BranchName ) '+
    'select case when PB.IsTerminal=0 then PB.BrancName else  (select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId) end,case when PB.IsTerminal=0 then PB.BrancName else  (select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId) end, SUM(CustomerSlip.Amount)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
From Customer.[Transaction] as CustomerSlip with (nolock)  inner join Customer.Customer with (nolock)  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
   [BettingReport].Parameter.Branch  as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where (Customer.Customer.IsTerminalCustomer=0 or Customer.Customer.IsTerminalCustomer is null)  and (Customer.Customer.IsBranchCustomer=0 or Customer.Customer.IsBranchCustomer is null) and CustomerSlip.TransactionTypeId=75 and  cast( CustomerSlip.TransactionDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( CustomerSlip.TransactionDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal '
 

 SET @sqlcommand222 +=   ' insert @TempSummaryBet (Parent,ParentBranch,CancelSlipCount ,CancelSlipAmount,BranchName) '+
     'select case when PB.IsTerminal=0 then PB.BrancName else  (select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId) end,case when PB.IsTerminal=0 then PB.BrancName else  (select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId) end, COUNT(CustomerSlip.CancelSlipCount)
,SUM(CustomerSlip.[OrgCancelSlipAmount])
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
From [BettingReport].Report.SummarySportBetting as CustomerSlip with (nolock)   INNER JOIN
  [BettingReport].Parameter.Branch  as PB with (nolock) ON  PB.[BranchId]=CustomerSlip.BranchId 
Where  CustomerSlip.Isview=1 and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal '

 
  SET @sqlcommand2222 +=   ' insert @TempSummaryBet (Parent,ParentBranch,TaxCount ,TaxAmount,BranchName) '+
      'select case when PB.IsTerminal=0 then PB.BrancName else  (select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId) end,case when PB.IsTerminal=0 then PB.BrancName else  (select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId) end, COUNT(CustomerSlip.TaxCount)
,SUM(CustomerSlip.[OrgTax])
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
From [BettingReport].Report.SummarySportBetting as CustomerSlip with (nolock)   INNER JOIN
  [BettingReport].Parameter.Branch  as PB with (nolock) ON  PB.[BranchId]=CustomerSlip.BranchId 
Where  CustomerSlip.Isview=1 and  cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal '

   SET @sqlcommand2222 +=   ' insert @TempSummaryBet (Parent,ParentBranch, BranchTaxAmount,BranchName) '+
    '	select case when PB.IsTerminal=0 then PB.BrancName else  (select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId) end
	,case when PB.IsTerminal=0 then PB.BrancName else  (select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId) end
	,case when Customer.Slip.SlipStateId in (3,5,6) and Customer.slip.TotalOddValue>1 then   SUM(Customer.Slip.TotalOddValue * Customer.Slip.Amount) else case when (Customer.Slip.SlipStateId in (2) or (Customer.Slip.SlipStateId=3 and Customer.slip.TotalOddValue=1) ) 	then   SUM(Customer.Slip.Amount) +ISNULL((Select SUM(Customer.Tax.TaxAmount) from Customer.Tax with (nolock)  where SlipId=Customer.Slip.SlipId),0) else 0 end end As Total
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
from Customer.Slip with (nolock) INNER JOIN Customer.Customer with (nolock)
ON Customer.Customer.CustomerId=Customer.Slip.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
where (IsPayOut=0 or IsPayOut is null) and SlipStateId in (2,3,5,6)  
 and ( IsBranchCustomer=1) and Customer.Slip.SlipTypeId<3 and cast( DATEADD(HOUR,1,Customer.Slip.EvaluateDate ) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( DATEADD(HOUR,1,Customer.Slip.EvaluateDate ) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.Slip.SourceId,Customer.Slip.SlipStateId,Customer.Slip.SlipId,Customer.slip.TotalOddValue,PB.IsTerminal '

  SET @sqlcommand2222 +=' insert @TempSummaryBet (Parent,ParentBranch, BranchTaxAmount,BranchName) '+
    '	select case when PB.IsTerminal=0 then PB.BrancName else  (select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId) end
	,case when PB.IsTerminal=0 then PB.BrancName else  (select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId) end
	,case when Archive.Slip.SlipStateId in (3,5,6) and Archive.slip.TotalOddValue>1 	then   SUM(Archive.Slip.TotalOddValue * Archive.Slip.Amount) else case when (Archive.Slip.SlipStateId in (2) or (Archive.Slip.SlipStateId=3 and Archive.slip.TotalOddValue=1) ) 	then   SUM(Archive.Slip.Amount) +ISNULL((Select SUM(Customer.Tax.TaxAmount) from Customer.Tax with (nolock)  where SlipId=Archive.Slip.SlipId),0) else 0 end end As Total
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
from Archive.Slip with (nolock) INNER JOIN Customer.Customer with (nolock)
ON Customer.Customer.CustomerId=Archive.Slip.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
where (IsPayOut=0 or IsPayOut is null) and SlipStateId in (2,3,5,6)  
 and ( IsBranchCustomer=1) and Archive.Slip.SlipTypeId<3 and cast( DATEADD(HOUR,1,Archive.Slip.EvaluateDate) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( DATEADD(HOUR,1,Archive.Slip.EvaluateDate) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Archive.Slip.SlipStateId,Archive.Slip.SlipId,Archive.slip.TotalOddValue,PB.IsTerminal '


  SET @sqlcommand2222 +=   ' insert @TempSummaryBet (Parent,ParentBranch, BranchTaxAmount,BranchName) '+
    '	select case when PB.IsTerminal=0 then PB.BrancName else  (select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId) end
	,case when PB.IsTerminal=0 then PB.BrancName else  (select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId) end
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

   SET @sqlcommand2222 +=   ' insert @TempSummaryBet (Parent,ParentBranch, BranchTaxAmount,BranchName) '+
    '	select case when PB.IsTerminal=0 then PB.BrancName else  (select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId) end
	,case when PB.IsTerminal=0 then PB.BrancName else  (select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId) end
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




 SET  @sqlcommand22222 +=   ' insert @TempSummaryBet (Parent,ParentBranch,PayOutCount ,PayOutAmount,BranchName)'+
 'select case when PB.IsTerminal=0 then PB.BrancName else  (select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId) end
 ,case when PB.IsTerminal=0 then PB.BrancName else  (select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId) end, COUNT(CustomerSlip.PayOutCount)
,SUM(CustomerSlip.[OrgPayOutAmount])
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
From [BettingReport].Report.SummarySportBetting as CustomerSlip with (nolock)   INNER JOIN
  [BettingReport].Parameter.Branch  as PB with (nolock)  ON  PB.[BranchId]=CustomerSlip.BranchId 
Where  CustomerSlip.Isview=1 and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal '
 
 SET @sqlcommand22222 +=   ' insert @TempSummaryBet (Parent,ParentBranch,OnlineDeposit ,OnlineWithDraw,BranchName) '+
  'select case when PB.IsTerminal=0 then PB.BrancName else  (select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId) end
  ,case when PB.IsTerminal=0 then PB.BrancName else  (select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId) end
,SUM(CustomerSlip.OnlineDeposit)
,SUM(CustomerSlip.OnlineWithDraw)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
From [BettingReport].Report.SummarySportBetting as CustomerSlip  inner join 
  [BettingReport].Parameter.Branch  as PB with (nolock)  ON  PB.[BranchId]=CustomerSlip.BranchId 
Where  CustomerSlip.Isview=1 and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal '

  set @sqlcommand3+=' declare @TempSummaryBet2 table (Parent nvarchar(50),ParentBranch nvarchar(50),SlipCount int,SlipAmount money,OpenSlipCount int,OpenSlipAmount money,OpenSlipPayOut money,WonSlipCount int,WonSlipAmount money,WonSlipPayOut money,LostSlipCount int,LostSlipAmount money,CancelSlipCount int,CancelSlipAmount money,TurnOver money,PartnerTurnOver money,BranchName nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS,TaxCount int,TaxAmount money,BranchTaxAmount money,PayOutCount int,PayOutAmount money,Cashout money,Bonus money ,OnlineDeposit money,OnlineWithDraw money) '+
  ' insert @TempSummaryBet2 '+
  'SELECT Parent,ParentBranch,SUM(SlipCount),SUM(SlipAmount),SUM(OpenSlipCount),SUM(OpenSlipAmount),SUM(OpenSlipPayOut),SUM(WonSlipCount) ,SUM(WonSlipAmount),SUM(WonSlipPayOut),SUM(LostSlipCount),SUM(LostSlipAmount),SUM(CancelSlipCount),SUM(CancelSlipAmount),ISNULL(SUM(SlipAmount),0)-(ISNULL(SUM(WonSlipPayOut),0)+ISNULL(SUM(Cashout),0)+ISNULL(SUM(CancelSlipAmount),0)+ISNULL(SUM(Bonus),0)),(ISNULL(SUM(WonSlipPayOut),0)+ISNULL(SUM(Cashout),0)+ISNULL(SUM(CancelSlipAmount),0)+ISNULL(SUM(Bonus),0)),BranchName,SUM(TaxCount),SUM(TaxAmount),SUM(BranchTaxAmount),SUM(PayOutCount),SUM(WonSlipPayOut),SUM(Cashout),SUM(Bonus) ,SUM(ISNULL(OnlineDeposit,0)),SUM(ISNULL(OnlineWithDraw,0))
     FROM @TempSummaryBet GROUP BY BranchName,ParentBranch,Parent   '+
  ' delete from @TempSummaryBet'
 
	

  set @sqlcommand3+= ' insert @TempSummaryBet '+
  'SELECT  case when PB.IsTerminal=0 then PB.BrancName else  (select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId) end
  ,case when PB.IsTerminal=0 then PB.BrancName else  (select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId) end
      ,       ISNULL(SUM([SlipCount]),0)  as [SlipCount]
      ,ISNULL( SUM([SlipAmount]),0)  as [SlipAmount]
      ,ISNULL(SUM([OpenSlipCount]),0)  as [OpenSlipCount]
      ,ISNULL( SUM([OpenSlipAmount]),0)  as [OpenSlipAmount]
      ,ISNULL( SUM([OpenSlipPayOut]),0)  as [OpenSlipPayOut]
      ,ISNULL(SUM([WonSlipCount]),0)  as [WonSlipCount]
      ,ISNULL( SUM([WonSlipAmount]),0)  as [WonSlipAmount]
      ,ISNULL( SUM([WonSlipPayOut]),0)  as [WonSlipPayOut]
      ,ISNULL(SUM([LostSlipCount]),0)  as [LostSlipCount]
      ,ISNULL( SUM([LostSlipAmount]),0)  as [LostSlipAmount]
      ,ISNULL(SUM([CancelSlipCount]),0)  as [CancelSlipCount]
      ,ISNULL( SUM([CancelSlipAmount]),0)  as [CancelSlipAmount]
      ,ISNULL(SUM([SlipAmount]),0)-((ISNULL(SUM([WonSlipAmount]),0)+ISNULL(SUM([CancelSlipAmount]),0))) as TurnOver
	 	   ,((ISNULL(SUM([WonSlipAmount]),0)+ISNULL(SUM([CancelSlipAmount]),0))) as BranchTurnOver			
	  ,PB.[BrancName]
	  ,0  as [TaxCount]
      ,0  as [Tax]
	  ,0
	  ,0 as [PayOutCount]
      ,ISNULL( SUM([WonSlipPayOut]),0)   as [PayOutAmount],0 as Cashout,0,0,0
  FROM [Report].[SummaryCasinoBetting] INNER JOIN 
  Customer.Customer ON Customer.Customer.CustomerId=[Report].[SummaryCasinoBetting].CustomerId INNER JOIN
  [Parameter].[Branch] as PB ON  PB.[BranchId]=Customer.Customer.BranchId 
  Where cast([Report].[SummaryCasinoBetting].ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast([Report].[SummaryCasinoBetting].ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' and '+@where2 + ' and '+ @where +'  
  GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal; '

 
   
  set @sqlcommand5= ' insert @TempSummaryBet2 '+
  'SELECT Parent,ParentBranch,SUM(SlipCount),SUM(SlipAmount),SUM(OpenSlipCount),SUM(OpenSlipAmount),SUM(OpenSlipPayOut),SUM(WonSlipCount) ,SUM(WonSlipAmount),SUM(WonSlipPayOut),SUM(LostSlipCount),SUM(LostSlipAmount),SUM(CancelSlipCount),SUM(CancelSlipAmount),SUM(TurnOver),SUM(PartnerTurnOver),BranchName,SUM(TaxCount),SUM(TaxAmount),SUM(BranchTaxAmount),SUM(PayOutCount),SUM(PayOutAmount),SUM(Cashout),0,0,0
     FROM @TempSummaryBet GROUP BY BranchName,ParentBranch,Parent '+
	 ' delete from @TempSummaryBet '
 

   set @sqlcommand6= ' insert @TempSummaryBet '+
  'SELECT case when PB.IsTerminal=0 then PB.BrancName else  (select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId) end
  ,case when PB.IsTerminal=0 then PB.BrancName else  (select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId) end
      , ISNULL(SUM([SlipCount]),0)  as [SlipCount]
      ,ISNULL( SUM([SlipAmount]),0)  as [SlipAmount]
      ,ISNULL(SUM([OpenSlipCount]),0)  as [OpenSlipCount]
      ,ISNULL( SUM([OpenSlipAmount]),0)  as [OpenSlipAmount]
      ,ISNULL(SUM([OpenSlipPayOut]),0)  as [OpenSlipPayOut]
      ,ISNULL(SUM([WonSlipCount]),0)  as [WonSlipCount]
      ,ISNULL(SUM([WonSlipAmount]),0)  as [WonSlipAmount]
      ,ISNULL(SUM([WonSlipAmount]),0)  as [WonSlipPayOut]
      ,ISNULL(SUM([LostSlipCount]),0)  as [LostSlipCount]
      ,ISNULL(SUM([LostSlipAmount]),0)  as [LostSlipAmount]
      ,ISNULL(SUM([CancelSlipCount]),0)  as [CancelSlipCount]
      ,ISNULL(SUM([CancelSlipAmount]),0)  as [CancelSlipAmount]
      ,ISNULL(SUM([SlipAmount]),0)-((ISNULL(SUM([WonSlipAmount]),0)+ISNULL(SUM([CancelSlipAmount]),0))) as TurnOver
	 	   ,((ISNULL(SUM([WonSlipAmount]),0)+ISNULL(SUM([CancelSlipAmount]),0))) as BranchTurnOver	
	  ,PB.[BrancName]
	  ,0  as [TaxCount]
      ,0  as [Tax]
	  ,0
	  ,0 as [PayOutCount]
      ,ISNULL(SUM([WonSlipAmount]),0) as [PayOutAmount],0 as Cashout,0,0,0
  FROM [Report].[SummaryVirtualBetting] INNER JOIN 
  Customer.Customer ON Customer.Customer.CustomerId=[Report].[SummaryVirtualBetting].CustomerId INNER JOIN
  [Parameter].[Branch] as PB ON  PB.[BranchId]=Customer.Customer.BranchId 
  Where cast([Report].[SummaryVirtualBetting].ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast([Report].[SummaryVirtualBetting].ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND  '+@where2 + ' and '+ @where +'  
  GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal; '

 

  set @sqlcommand8=  ' insert @TempSummaryBet2 '+
  'SELECT Parent,ParentBranch,SUM(SlipCount),SUM(SlipAmount),SUM(OpenSlipCount),SUM(OpenSlipAmount),SUM(OpenSlipPayOut),SUM(WonSlipCount) ,SUM(WonSlipAmount),SUM(WonSlipPayOut),SUM(LostSlipCount),SUM(LostSlipAmount),SUM(CancelSlipCount),SUM(CancelSlipAmount),SUM(TurnOver),SUM(PartnerTurnOver),BranchName,SUM(TaxCount),SUM(TaxAmount),SUM(BranchTaxAmount),SUM(PayOutCount),SUM(PayOutAmount),SUM(Cashout),0,0,0
     FROM @TempSummaryBet  GROUP BY BranchName,ParentBranch,Parent'+
  ' delete from @TempSummaryBet'

  declare @Usersss nvarchar(150)


  set @sqlcommand9=' declare @TempSummaryBet3 table (Parent nvarchar(50),ParentBranch nvarchar(50),SlipCount int,SlipAmount money,OpenSlipCount int,OpenSlipAmount money,OpenSlipPayOut money,WonSlipCount int,WonSlipAmount money,WonSlipPayOut money,LostSlipCount int,LostSlipAmount money,CancelSlipCount int,CancelSlipAmount money,TurnOver money,PartnerTurnOver money,BranchName nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS,TaxCount int,TaxAmount money,BranchTaxAmount money,PayOutCount int,PayOutAmount money,Cashout money,Bonus money ,OnlineDeposit money,OnlineWithDraw money) '+
  ' insert @TempSummaryBet3 '+
  '   SELECT tp2.Parent,tp2.ParentBranch,SUM(ISNULL(SlipCount,0))
,SUM(ISNULL(SlipAmount,0)),SUM(ISNULL(OpenSlipCount,0)),SUM(ISNULL(OpenSlipAmount,0)),SUM(ISNULL(OpenSlipPayOut,0)),SUM(ISNULL(WonSlipCount,0)) ,SUM(ISNULL(WonSlipAmount,0))
,SUM(ISNULL(WonSlipPayOut,0)),SUM(ISNULL(LostSlipCount,0)),SUM(ISNULL(LostSlipAmount,0)),SUM(ISNULL(CancelSlipCount,0)),SUM(ISNULL(CancelSlipAmount,0)),SUM(ISNULL(TurnOver,0)) as TurnOver
,SUM(ISNULL(PartnerTurnOver,0))
,tp2.BranchName,SUM(ISNULL(TaxCount,0)),SUM(ISNULL(TaxAmount,0)),SUM(ISNULL(BranchTaxAmount,0)),SUM(ISNULL(PayOutCount,0)),SUM(ISNULL(PayOutAmount,0)),SUM(ISNULL(Cashout,0)),SUM(ISNULL(Bonus,0))
 ,SUM(ISNULL(OnlineDeposit,0)),SUM(ISNULL(OnlineWithDraw,0))
     FROM @TempSummaryBet2 as tp2 
	 GROUP BY BranchName,ParentBranch,Parent '

	  if(@Username='wettarenad')
		set @Usersss='Wettarena.de'

		else  if(@Username='wettarenaf')
		set @Usersss='Franchise'
		else   
		set @Usersss=@Username

		--else  if(@Username='wettarenao')
		--set @Usersss='Online'


	 if(@Username<>'wettarenao')
	 set @sqlcommand10+=' Select ''Bayi :''+  '''+CAST(@Usersss as nvarchar(50))+ ''' UNION ALL Select ''Oynanan Oyun :''+ cast(FORMAT(SUM(SlipAmount), ''C'', ''fr-FR'') as nvarchar(50)) from @TempSummaryBet3 where SlipAmount>0 UNION ALL Select ''Kalan :''+ cast(FORMAT(SUM(TurnOver), ''C'', ''fr-FR'') as nvarchar(50)) from @TempSummaryBet3 where  SlipAmount>0 ' 
	 else
	 set @sqlcommand10+=' Select ''Bayi : Online'' UNION ALL Select ''Yatirilan Para :''+ cast(FORMAT(SUM(OnlineDeposit), ''C'', ''fr-FR'') as nvarchar(50)) from @TempSummaryBet3 where SlipAmount>0  UNION ALL Select ''Oynanan Oyun :''+ cast(FORMAT(SUM(SlipAmount), ''C'', ''fr-FR'') as nvarchar(50)) from @TempSummaryBet3 where SlipAmount>0 UNION ALL Select ''Kalan :''+ cast(FORMAT(SUM(TurnOver), ''C'', ''fr-FR'') as nvarchar(50)) from @TempSummaryBet3 where  SlipAmount>0 ' 
																													
 end
 else
	begin
				
 set @sqlcommand2=' declare @TempSummaryBet table (Parent nvarchar(50),ParentBranch nvarchar(50),SlipCount int,SlipAmount money,OpenSlipCount int,OpenSlipAmount money,OpenSlipPayOut money,WonSlipCount int,WonSlipAmount money,WonSlipPayOut money,LostSlipCount int,LostSlipAmount money,CancelSlipCount int,CancelSlipAmount money,TurnOver money,PartnerTurnOver money,BranchName nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS,TaxCount int,TaxAmount money,BranchTaxAmount money,PayOutCount int,PayOutAmount money,Cashout money,Bonus money ,OnlineDeposit money,OnlineWithDraw money) '+
  'insert @TempSummaryBet (Parent,ParentBranch,SlipCount,SlipAmount,BranchName) '+
    'select (select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId),(select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId), COUNT(CustomerSlip.SlipCount)
,SUM(CustomerSlip.SlipAmount)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
From [BettingReport].Report.SummarySportBetting as CustomerSlip  with (nolock)   INNER JOIN
  [BettingReport].Parameter.Branch  as PB  ON  PB.[BranchId]=CustomerSlip.BranchId 
Where   CustomerSlip.Isview=1 and
 cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal '

 

  SET @sqlcommand2 +=   ' insert @TempSummaryBet (Parent,ParentBranch,OpenSlipCount,OpenSlipAmount,BranchName) '+
      'select (select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId),(select P.BrancName from [BettingReport].Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId), COUNT(Customer.Slip.SlipId)
,SUM(Customer.Slip.Amount)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
From Customer.Slip with (nolock) inner join Customer.Customer with (nolock) on Customer.Slip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where Customer.Slip.SlipStatu not in (2,4)  and Customer.Slip.SlipStateId=1  and Customer.Slip.SlipTypeId<3
and cast(DATEADD(HOUR,1,Customer.Slip.CreateDate) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(DATEADD(HOUR,1,Customer.Slip.CreateDate) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal '
 
 
    SET @sqlcommand2 +=   ' insert @TempSummaryBet (Parent,ParentBranch,OpenSlipCount,OpenSlipAmount,BranchName) '+
        'select (select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId),(select P.BrancName from [BettingReport].Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId), COUNT(Customer.SlipSystem.SystemSlipId)
,SUM( Customer.SlipSystem.Amount)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
From Customer.SlipSystem with (nolock) inner join Customer.Customer with (nolock) on Customer.SlipSystem.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where   Customer.SlipSystem.SlipStateId=1  and Customer.SlipSystem.NewSlipTypeId in (4,5)
and cast( DATEADD(HOUR,1,Customer.SlipSystem.CreateDate) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( DATEADD(HOUR,1,Customer.SlipSystem.CreateDate) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.SlipSystem.SourceId,PB.IsTerminal '


 --select @sqlcommand2

   SET @sqlcommand22 +=   ' insert @TempSummaryBet (Parent,ParentBranch,WonSlipCount ,WonSlipAmount ,WonSlipPayOut,BranchName) '+
      'select (select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId),(select P.BrancName from [BettingReport].Parameter.Branch as P  where P.BranchId=PB.ParentBranchId), SUM(CustomerSlip.WonSlipCount)
,SUM(CustomerSlip.WonSlipAmount)
,SUM(WonSlipPayOut)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
From [BettingReport].Report.SummarySportBetting as CustomerSlip with (nolock)   INNER JOIN
   [BettingReport].Parameter.Branch  as PB with (nolock) ON  PB.[BranchId]=CustomerSlip.BranchId 
Where  CustomerSlip.Isview=1 and  cast( CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal '
 

      SET @sqlcommand22 +=   ' insert @TempSummaryBet (Parent,ParentBranch,Bonus,BranchName ) '+
    'select (select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId),(select P.BrancName from [BettingReport].Parameter.Branch as P  where P.BranchId=PB.ParentBranchId), SUM(CustomerSlip.Amount)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
From Customer.[Transaction] as CustomerSlip with (nolock)  inner join Customer.Customer with (nolock)  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
   [BettingReport].Parameter.Branch  as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  (Customer.Customer.IsTerminalCustomer=0 or Customer.Customer.IsTerminalCustomer is null)  and (Customer.Customer.IsBranchCustomer=0 or Customer.Customer.IsBranchCustomer is null) and CustomerSlip.TransactionTypeId=35 and  cast( CustomerSlip.TransactionDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( CustomerSlip.TransactionDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal '

     SET @sqlcommand221 +=   ' insert @TempSummaryBet (Parent,ParentBranch,Cashout,BranchName) '+
     'select (select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId),(select P.BrancName from [BettingReport].Parameter.Branch  as P  where P.BranchId=PB.ParentBranchId)
,SUM(CustomerSlip.CashoutSlipAmount)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
From [BettingReport].Report.SummarySportBetting as CustomerSlip with (nolock) INNER JOIN
  [BettingReport].Parameter.Branch as PB with (nolock) ON  PB.[BranchId]=CustomerSlip.BranchId 
Where  CustomerSlip.Isview=1 and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal '

  
--  SET @sqlcommand222 +=   ' insert @TempSummaryBet (Parent,ParentBranch,LostSlipCount ,LostSlipAmount,BranchName) '+
--    'select (select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId),(select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock) where P.BranchId=PB.ParentBranchId), SUM(CustomerSlip.LostSlipCount)
--,SUM(CustomerSlip.LostSlipAmount)
--,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
--From [BettingReport].Report.SummarySportBetting as CustomerSlip with (nolock)  INNER JOIN
--  [BettingReport].Parameter.Branch  as PB with (nolock) ON  PB.[BranchId]=CustomerSlip.BranchId 
--Where  CustomerSlip.Isview=1 and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
--and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
-- GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal '

     SET @sqlcommand222 +=   ' insert @TempSummaryBet (Parent,ParentBranch,LostSlipAmount,BranchName ) '+
    'select (select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId),(select P.BrancName from [BettingReport].Parameter.Branch as P  where P.BranchId=PB.ParentBranchId), SUM(CustomerSlip.Amount)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
From Customer.[Transaction] as CustomerSlip with (nolock)  inner join Customer.Customer with (nolock)  on CustomerSlip.CustomerId=Customer.Customer.CustomerId INNER JOIN
   [BettingReport].Parameter.Branch  as PB  ON  PB.[BranchId]=Customer.Customer.BranchId 
Where  (Customer.Customer.IsTerminalCustomer=0 or Customer.Customer.IsTerminalCustomer is null)  and (Customer.Customer.IsBranchCustomer=0 or Customer.Customer.IsBranchCustomer is null) and CustomerSlip.TransactionTypeId=75 and  cast( CustomerSlip.TransactionDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( CustomerSlip.TransactionDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal '
 

 SET @sqlcommand222 +=   ' insert @TempSummaryBet (Parent,ParentBranch,CancelSlipCount ,CancelSlipAmount,BranchName) '+
     'select (select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId),(select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock) where P.BranchId=PB.ParentBranchId), COUNT(CustomerSlip.CancelSlipCount)
,SUM(CustomerSlip.CancelSlipAmount)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
From [BettingReport].Report.SummarySportBetting as CustomerSlip with (nolock)  INNER JOIN
  [BettingReport].Parameter.Branch  as PB with (nolock) ON  PB.[BranchId]=CustomerSlip.BranchId 
Where  CustomerSlip.Isview=1 and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal '

 
  SET @sqlcommand2222 +=   ' insert @TempSummaryBet (Parent,ParentBranch,TaxCount ,TaxAmount,BranchName) '+
      'select (select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId),(select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock) where P.BranchId=PB.ParentBranchId), COUNT(CustomerSlip.TaxCount)
,SUM(CustomerSlip.Tax)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
From [BettingReport].Report.SummarySportBetting as CustomerSlip with (nolock)  INNER JOIN
  [BettingReport].Parameter.Branch  as PB with (nolock) ON  PB.[BranchId]=CustomerSlip.BranchId 
Where  CustomerSlip.Isview=1 and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal '

 SET @sqlcommand2222 +=   ' insert @TempSummaryBet (Parent,ParentBranch, BranchTaxAmount,BranchName) '+
    '	select (select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId),(select P.BrancName from [BettingReport].Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId)
	
	,case when Customer.Slip.SlipStateId in (3,5,6) and Customer.slip.TotalOddValue>1 then   SUM(ISNULL(Amount,0)*TotalOddValue) else case when (Customer.Slip.SlipStateId in (2) or (Customer.Slip.SlipStateId=3 and Customer.slip.TotalOddValue=1) ) 	then   SUM(Customer.Slip.Amount) +ISNULL((Select SUM(Customer.Tax.TaxAmount) from Customer.Tax with (nolock)  where SlipId=Customer.Slip.SlipId),0) else 0 end end As Total
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end

from Customer.Slip with (nolock) INNER JOIN Customer.Customer with (nolock)
ON Customer.Customer.CustomerId=Customer.Slip.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
where (IsPayOut=0 or IsPayOut is null) and SlipStateId in (2,3,5,6)  
 and  Customer.Slip.SlipTypeId<3 and cast( DATEADD(HOUR,1,Customer.Slip.EvaluateDate ) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( DATEADD(HOUR,1,Customer.Slip.EvaluateDate ) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.Slip.SlipStateId,Customer.Slip.SlipId,Customer.slip.TotalOddValue,Customer.Slip.CurrencyId,PB.IsTerminal '

  SET @sqlcommand2222 +=' insert @TempSummaryBet (Parent,ParentBranch, BranchTaxAmount,BranchName) '+
    '	select (select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId),(select P.BrancName from [BettingReport].Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId)
	,case when Archive.Slip.SlipStateId in (3,5,6) and Archive.slip.TotalOddValue>1 then   SUM(ISNULL(Amount,0)*TotalOddValue) else case when (Archive.Slip.SlipStateId in (2) or (Archive.Slip.SlipStateId=3 and Archive.slip.TotalOddValue=1) ) 	then   SUM(Archive.Slip.Amount) +ISNULL((Select SUM(Customer.Tax.TaxAmount) from Customer.Tax with (nolock)  where SlipId=Archive.Slip.SlipId),0) else 0 end end As Total
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
from Archive.Slip with (nolock) INNER JOIN Customer.Customer with (nolock)
ON Customer.Customer.CustomerId=Archive.Slip.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
where (IsPayOut=0 or IsPayOut is null) and SlipStateId in (2,3,5,6)  
 and ( IsBranchCustomer=1) and Archive.Slip.SlipTypeId<3 and cast( DATEADD(HOUR,1,Archive.Slip.EvaluateDate) as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast( DATEADD(HOUR,1,Archive.Slip.EvaluateDate) as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Archive.Slip.SlipStateId,Archive.Slip.SlipId,Archive.slip.TotalOddValue,Archive.Slip.CurrencyId,PB.IsTerminal '


  SET @sqlcommand2222 +=   ' insert @TempSummaryBet (Parent,ParentBranch, BranchTaxAmount,BranchName) '+
    '	select (select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId),(select P.BrancName from [BettingReport].Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId)
	,cast(ISNULL((Select SUM(ISNULL(Amount,0)*TotalOddValue)
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

   SET @sqlcommand2222 +=   ' insert @TempSummaryBet (Parent,ParentBranch, BranchTaxAmount,BranchName) '+
    '	select (select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId),(select P.BrancName from [BettingReport].Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId)
	,cast(ISNULL((Select SUM(ISNULL(Amount,0)*TotalOddValue)
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
--    '	 SELECT (select ppp.BrancName COLLATE SQL_Latin1_General_CP1_CI_AS from [BettingReport].Parameter.Branch as ppp with (nolock) where ppp.BranchId in (select pp.ParentBranchId from [BettingReport].Parameter.Branch as pp with (nolock) where pp.BrancName COLLATE SQL_Latin1_General_CP1_CI_AS=tp.ParentBranch))
--, ISNULL(SUM(SlipAmount),0)-((ISNULL(sum(WonSlipPayOut),0)+ISNULL(sum(Cashout),0)+ISNULL(SUM(CancelSlipAmount),0))) as Profit
-- ,ISNULL(SUM(TaxAmount),0) as TaxAmount
-- ,TP.ParentBranch COLLATE SQL_Latin1_General_CP1_CI_AS
-- FROM @TempSummaryBet as TP 
-- where (TP.ParentBranch in (select ppp.BrancName COLLATE SQL_Latin1_General_CP1_CI_AS from [BettingReport].Parameter.Branch as ppp with (nolock) where ppp.BranchId in (select pp.ParentBranchId from [BettingReport].Parameter.Branch as pp with (nolock) where pp.BrancName COLLATE SQL_Latin1_General_CP1_CI_AS=tp.BranchName))) 
-- GROUP BY  TP.[BranchName],TP.ParentBranch   HAVING SUM(SlipAmount) is not null'




 SET  @sqlcommand22222 +=   ' insert @TempSummaryBet (Parent,ParentBranch,PayOutCount ,PayOutAmount,BranchName)'+
 'select (select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId),(select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock) where P.BranchId=PB.ParentBranchId), COUNT(CustomerSlip.PayOutCount)
,SUM(CustomerSlip.PayOutAmount)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
From [BettingReport].Report.SummarySportBetting as CustomerSlip with (nolock)   INNER JOIN
  [BettingReport].Parameter.Branch  as PB with (nolock) ON  PB.[BranchId]=CustomerSlip.BranchId 
Where  CustomerSlip.Isview=1 and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal '
 
    SET @sqlcommand22222 +=   ' insert @TempSummaryBet (Parent,ParentBranch,OnlineDeposit ,OnlineWithDraw,BranchName) '+
  'select (select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId),(select P.BrancName from [BettingReport].Parameter.Branch  as P  where P.BranchId=PB.ParentBranchId) 
,SUM(CustomerSlip.OnlineDeposit)
,SUM(CustomerSlip.OnlineWithDraw)
,cast(PB.[BranchId] as nvarchar(20))+ case when PB.IsTerminal=0 then ''-''+PB.BrancName else '''' end
From [BettingReport].Report.SummarySportBetting as CustomerSlip  inner join  
  [BettingReport].Parameter.Branch  as PB  ON  PB.[BranchId]=CustomerSlip.BranchId 
Where  CustomerSlip.Isview=1 and cast(CustomerSlip.ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast(CustomerSlip.ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,PB.IsTerminal '
 

  set @sqlcommand3+=' declare @TempSummaryBet2 table (Parent nvarchar(50),ParentBranch nvarchar(50),SlipCount int,SlipAmount money,OpenSlipCount int,OpenSlipAmount money,OpenSlipPayOut money,WonSlipCount int,WonSlipAmount money,WonSlipPayOut money,LostSlipCount int,LostSlipAmount money,CancelSlipCount int,CancelSlipAmount money,TurnOver money,PartnerTurnOver money,BranchName nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS,TaxCount int,TaxAmount money,BranchTaxAmount money,PayOutCount int,PayOutAmount money,Cashout money,Bonus money ,OnlineDeposit money,OnlineWithDraw money) '+
  ' insert @TempSummaryBet2 '+
  'SELECT Parent,ParentBranch,SUM(SlipCount),SUM(SlipAmount)
  ,SUM(OpenSlipCount),SUM(OpenSlipAmount)
  ,SUM(OpenSlipPayOut),SUM(WonSlipCount) 
  ,SUM(WonSlipAmount)
  ,SUM(WonSlipPayOut)
  ,SUM(LostSlipCount)
  ,SUM(LostSlipAmount)
  ,SUM(CancelSlipCount)
  ,SUM(CancelSlipAmount)
  ,ISNULL(SUM(SlipAmount),0)-(ISNULL(SUM(WonSlipPayOut),0)+ISNULL(SUM(Cashout),0)+ISNULL(SUM(CancelSlipAmount),0)+ISNULL(SUM(Bonus),0))
  ,(ISNULL(SUM(WonSlipPayOut),0)+ISNULL(SUM(Cashout),0)+ISNULL(SUM(CancelSlipAmount),0)+ISNULL(SUM(Bonus),0)),BranchName,SUM(TaxCount)
  ,SUM(TaxAmount),SUM(BranchTaxAmount),SUM(PayOutCount)
  ,SUM(WonSlipPayOut)
  ,SUM(Cashout)  ,SUM(Bonus)
   ,SUM(ISNULL(OnlineDeposit,0)),SUM(ISNULL(OnlineWithDraw,0))
     FROM @TempSummaryBet GROUP BY BranchName,ParentBranch,Parent   '+
  ' delete from @TempSummaryBet'
 
	
 

  set @sqlcommand3+= ' insert @TempSummaryBet '+
  'SELECT  (select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId),(select P.BrancName from [BettingReport].Parameter.Branch as P where P.BranchId=PB.ParentBranchId)
      ,       ISNULL(SUM([SlipCount]),0)  as [SlipCount]
      ,ISNULL( SUM([SlipAmount]),0)  as [SlipAmount]
      ,ISNULL(SUM([OpenSlipCount]),0)  as [OpenSlipCount]
      ,ISNULL( SUM([OpenSlipAmount]),0)  as [OpenSlipAmount]
      ,ISNULL( SUM([OpenSlipPayOut]),0)  as [OpenSlipPayOut]
      ,ISNULL(SUM([WonSlipCount]),0)  as [WonSlipCount]
      ,ISNULL( SUM([WonSlipAmount]),0)  as [WonSlipAmount]
      ,ISNULL( SUM([WonSlipPayOut]),0)  as [WonSlipPayOut]
      ,ISNULL(SUM([LostSlipCount]),0)  as [LostSlipCount]
      ,ISNULL( SUM([LostSlipAmount]),0)  as [LostSlipAmount]
      ,ISNULL(SUM([CancelSlipCount]),0)  as [CancelSlipCount]
      ,ISNULL( SUM([CancelSlipAmount]),0)  as [CancelSlipAmount]
      ,ISNULL(SUM([SlipAmount]),0)-((ISNULL(SUM([WonSlipAmount]),0)+ISNULL(SUM([CancelSlipAmount]),0))) as TurnOver
	 	   ,((ISNULL(SUM([WonSlipAmount]),0)+ISNULL(SUM([CancelSlipAmount]),0))) as BranchTurnOver			
	  ,PB.[BrancName]
	  ,0  as [TaxCount]
      ,0  as [Tax]
	  ,0
	  ,0 as [PayOutCount]
      ,ISNULL( SUM([WonSlipPayOut]),0)   as [PayOutAmount],0 as Cashout,0,0,0
  FROM [Report].[SummaryCasinoBetting] INNER JOIN 
  Customer.Customer ON Customer.Customer.CustomerId=[Report].[SummaryCasinoBetting].CustomerId INNER JOIN
  [Parameter].[Branch] as PB ON  PB.[BranchId]=Customer.Customer.BranchId 
 
  Where cast([Report].[SummaryCasinoBetting].ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast([Report].[SummaryCasinoBetting].ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' and '+@where2 + ' and '+ @where +'  
  GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId; '

 
   
  set @sqlcommand5= ' insert @TempSummaryBet2 '+
  'SELECT Parent,ParentBranch,SUM(SlipCount),SUM(SlipAmount),SUM(OpenSlipCount),SUM(OpenSlipAmount),SUM(OpenSlipPayOut),SUM(WonSlipCount) ,SUM(WonSlipAmount),SUM(WonSlipPayOut),SUM(LostSlipCount),SUM(LostSlipAmount),SUM(CancelSlipCount),SUM(CancelSlipAmount),SUM(TurnOver),SUM(PartnerTurnOver),BranchName,SUM(TaxCount),SUM(TaxAmount),SUM(BranchTaxAmount),SUM(PayOutCount),SUM(PayOutAmount),SUM(Cashout),0,0,0
     FROM @TempSummaryBet GROUP BY BranchName,ParentBranch,Parent '+
	 ' delete from @TempSummaryBet '
 

   set @sqlcommand6= ' insert @TempSummaryBet '+
  'SELECT (select P.BrancName from [BettingReport].Parameter.Branch  as P with (nolock)  where P.BranchId=PB.ParentBranchId),(select P.BrancName from [BettingReport].Parameter.Branch as P where P.BranchId=PB.ParentBranchId)
      , ISNULL(SUM([SlipCount]),0)  as [SlipCount]
      ,ISNULL( SUM([SlipAmount]),0)  as [SlipAmount]
      ,ISNULL(SUM([OpenSlipCount]),0)  as [OpenSlipCount]
      ,ISNULL( SUM([OpenSlipAmount]),0)  as [OpenSlipAmount]
      ,ISNULL(SUM([OpenSlipPayOut]),0)  as [OpenSlipPayOut]
      ,ISNULL(SUM([WonSlipCount]),0)  as [WonSlipCount]
      ,ISNULL(SUM([WonSlipAmount]),0)  as [WonSlipAmount]
      ,ISNULL(SUM([WonSlipAmount]),0)  as [WonSlipPayOut]
      ,ISNULL(SUM([LostSlipCount]),0)  as [LostSlipCount]
      ,ISNULL(SUM([LostSlipAmount]),0)  as [LostSlipAmount]
      ,ISNULL(SUM([CancelSlipCount]),0)  as [CancelSlipCount]
      ,ISNULL(SUM([CancelSlipAmount]),0)  as [CancelSlipAmount]
      ,ISNULL(SUM([SlipAmount]),0)-((ISNULL(SUM([WonSlipAmount]),0)+ISNULL(SUM([CancelSlipAmount]),0))) as TurnOver
	 	   ,((ISNULL(SUM([WonSlipAmount]),0)+ISNULL(SUM([CancelSlipAmount]),0))) as BranchTurnOver	
	  ,PB.[BrancName]
	  ,0  as [TaxCount]
      ,0  as [Tax]
	  ,0
	  ,0 as [PayOutCount]
      ,ISNULL(SUM([WonSlipAmount]),0) as [PayOutAmount],0 as Cashout,0,0,0
  FROM [Report].[SummaryVirtualBetting] INNER JOIN 
  Customer.Customer ON Customer.Customer.CustomerId=[Report].[SummaryVirtualBetting].CustomerId INNER JOIN
  [Parameter].[Branch] as PB ON  PB.[BranchId]=Customer.Customer.BranchId 
  Where cast([Report].[SummaryVirtualBetting].ReportDate as date)>='''+cast(@StartDate as NVARCHAR(20))+''' 
and cast([Report].[SummaryVirtualBetting].ReportDate as date)<='''+cast(@EndDate as NVARCHAR(20)) +''' AND  '+@where2 + ' and '+ @where +'  
  GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId; '

 

  set @sqlcommand8=  ' insert @TempSummaryBet2 '+
  'SELECT Parent,ParentBranch,SUM(SlipCount),SUM(SlipAmount),SUM(OpenSlipCount),SUM(OpenSlipAmount),SUM(OpenSlipPayOut),SUM(WonSlipCount) ,SUM(WonSlipAmount),SUM(WonSlipPayOut),SUM(LostSlipCount),SUM(LostSlipAmount),SUM(CancelSlipCount),SUM(CancelSlipAmount),SUM(TurnOver),SUM(PartnerTurnOver),BranchName,SUM(TaxCount),SUM(TaxAmount),SUM(BranchTaxAmount),SUM(PayOutCount),SUM(PayOutAmount),SUM(Cashout),0,0,0
     FROM @TempSummaryBet  GROUP BY BranchName,ParentBranch,Parent'+
  ' delete from @TempSummaryBet'





  set @sqlcommand9=' declare @TempSummaryBet3 table (Parent nvarchar(50),ParentBranch nvarchar(50),SlipCount int,SlipAmount money,OpenSlipCount int,OpenSlipAmount money,OpenSlipPayOut money,WonSlipCount int,WonSlipAmount money,WonSlipPayOut money,LostSlipCount int,LostSlipAmount money,CancelSlipCount int,CancelSlipAmount money,TurnOver money,PartnerTurnOver money,BranchName nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS,TaxCount int,TaxAmount money,BranchTaxAmount money,PayOutCount int,PayOutAmount money,Cashout money,Bonus money ,OnlineDeposit money,OnlineWithDraw money) '+
  ' insert @TempSummaryBet3 '+
  '   SELECT tp2.Parent,tp2.ParentBranch,SUM(ISNULL(SlipCount,0))
,SUM(ISNULL(SlipAmount,0)),SUM(ISNULL(OpenSlipCount,0)),SUM(ISNULL(OpenSlipAmount,0)),SUM(ISNULL(OpenSlipPayOut,0)),SUM(ISNULL(WonSlipCount,0)) ,SUM(ISNULL(WonSlipAmount,0))
,SUM(ISNULL(WonSlipPayOut,0)),SUM(ISNULL(LostSlipCount,0)),SUM(ISNULL(LostSlipAmount,0)),SUM(ISNULL(CancelSlipCount,0)),SUM(ISNULL(CancelSlipAmount,0)),SUM(ISNULL(TurnOver,0)) as TurnOver
,SUM(ISNULL(PartnerTurnOver,0))
,tp2.BranchName,SUM(ISNULL(TaxCount,0)),SUM(ISNULL(TaxAmount,0)),SUM(ISNULL(BranchTaxAmount,0)),SUM(ISNULL(PayOutCount,0)),SUM(ISNULL(PayOutAmount,0)),SUM(ISNULL(Cashout,0)),SUM(ISNULL(Bonus,0))
 ,SUM(ISNULL(OnlineDeposit,0)),SUM(ISNULL(OnlineWithDraw,0))
     FROM @TempSummaryBet2 as tp2 
	 GROUP BY BranchName,ParentBranch,Parent '

	  set @sqlcommand10+=' Select ''BranchName :'' + '''+CAST(@Username as nvarchar(50))+ ''' UNION ALL Select ''Einsatz :''+ cast(FORMAT(SUM(SlipAmount), ''C'', ''fr-FR'') as nvarchar(50)) from @TempSummaryBet3 UNION ALL Select ''Gesamtgewinn :''+ cast(FORMAT(SUM(TurnOver), ''C'', ''fr-FR'') as nvarchar(50)) from @TempSummaryBet3  ' 
	end
 --select @wherePayout
 --select @sqlcommand+@sqlcommand1+@sqlcommand2+@sqlcommand22+@sqlcommand221+@sqlcommand222+@sqlcommand2222+@sqlcommand22222+@sqlcommand2T+@sqlcommand22T+@sqlcommand221T+@sqlcommand222T
-- select @sqlcommand2222T+ @sqlcommand3+@sqlcommand4+@sqlcommand5+@sqlcommand6+@sqlcommand7+@sqlcommand8+@sqlcommand88+@sqlcommand9+@sqlcommand10
 --select @sqlcommandBranch,@sqlcommand,@sqlcommand1,@sqlcommand2,@sqlcommand22,@sqlcommand221,@sqlcommand222,@sqlcommand2222,@sqlcommand22222, @sqlcommand3,@sqlcommand4,@sqlcommand5,@sqlcommand6,@sqlcommand7,@sqlcommand8,@sqlcommand88,@sqlcommand9,@sqlcommand10
  
  exec (@sqlcommandBranch+@sqlcommand+@sqlcommand1+@sqlcommand2+@sqlcommand22+@sqlcommand221+@sqlcommand222+@sqlcommand2222+@sqlcommand22222+ @sqlcommand3+@sqlcommand4+@sqlcommand5+@sqlcommand6+@sqlcommand7+@sqlcommand8+@sqlcommand88+@sqlcommand9+@sqlcommand10)

 





END



GO
