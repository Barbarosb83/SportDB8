USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcSummaryBranchBettingMessage]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcSummaryBranchBettingMessage] 

@BranchId bigint
AS
BEGIN
SET NOCOUNT ON;
 
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
declare @sqlcommand0222T nvarchar(max)=''
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
 
declare @where2 nvarchar(max)=' 1=1'
declare @SystemCurrencyId int
 declare @BranchName nvarchar(150)=''
 declare @Currency nvarchar(10)
declare @whereTerminal  nvarchar(max)=' 1=1'
	declare @where3 nvarchar(250)=''

	select @BranchName= Parameter.Branch.BrancName,@Currency=Parameter.Currency.Sybol from Parameter.Branch INNER JOIN Parameter.Currency On Parameter.Branch.CurrencyId=Parameter.Currency.CurrencyId where BranchId=@BranchId

if(@BranchId<>1)
	begin

	set @where2=' [Parameter].[Branch].BranchId='+cast(@BranchId as nvarchar(7))

	end



 
 exec Report.ProcSummarySportBettingFill1_2





	
  if(@BranchId<>1)
	begin

	set @where2=' PB.BranchId in (select BranchId from Parameter.Branch with (nolock) where IsTerminal=0 and (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId in (select BranchId from Parameter.Branch with (nolock)   where IsTerminal=0 and (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ') )))'  
	set @whereTerminal='  Customer.BranchId in (select BranchId from Parameter.Branch with (nolock) where IsTerminal=1 and (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId in (select BranchId from Parameter.Branch with (nolock)   where IsTerminal=0 and (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ') )))'  

	end


 
	set @where3=@where3+' and SourceId in (select SourceId from Parameter.Source) '
 



	
 set @sqlcommand2=' declare @TempSummaryBet table (ParentBranch nvarchar(50),SlipCount int,SlipAmount money,OpenSlipCount int,OpenSlipAmount money,OpenSlipPayOut money,WonSlipCount int,WonSlipAmount money,WonSlipPayOut money,LostSlipCount int,LostSlipAmount money,CancelSlipCount int,CancelSlipAmount money,TurnOver money,PartnerTurnOver money,BranchName nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS,TaxCount int,TaxAmount money,BranchTaxAmount money,PayOutCount int,PayOutAmount money,SourceId int,Cashout money) '+
  'insert @TempSummaryBet (ParentBranch,SlipCount,SlipAmount,BranchName,SourceId) '+
  'select (select P.BrancName from Parameter.Branch  as P with (nolock) where P.BranchId=PB.ParentBranchId), COUNT(Customer.Slip.SlipId)
,SUM(Customer.Slip.Amount)
,PB.[BrancName]
,Customer.Slip.SourceId
From Customer.Slip with (nolock) inner join Customer.Customer with (nolock) on Customer.Slip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where Customer.Slip.SlipStatu not in (2,4) 
and cast(DATEADD(MINUTE,180,Customer.Slip.CreateDate) as date)>='''+cast(cast(GETDATE() as date) as NVARCHAR(20))+''' 
and cast(DATEADD(MINUTE,180,Customer.Slip.CreateDate) as date)<='''+cast(cast(GETDATE() as date) as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.Slip.SourceId '


 SET @sqlcommand2 +=   ' insert @TempSummaryBet (ParentBranch,SlipCount,SlipAmount,BranchName,SourceId) '+
  'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId), COUNT(Archive.Slip.SlipId)
,SUM(Archive.Slip.Amount)
,PB.[BrancName]
,Archive.Slip.SourceId
From Archive.Slip with (nolock) inner join Customer.Customer with (nolock) on Archive.Slip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where Archive.Slip.SlipStatu not in (2,4) 
and cast(DATEADD(MINUTE,180,Archive.Slip.CreateDate) as date)>='''+cast(cast(GETDATE() as date) as NVARCHAR(20))+''' 
and cast(DATEADD(MINUTE,180,Archive.Slip.CreateDate) as date)<='''+cast(cast(GETDATE() as date) as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Archive.Slip.SourceId '

  SET @sqlcommand2 +=   ' insert @TempSummaryBet (ParentBranch,OpenSlipCount,OpenSlipAmount,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId), COUNT(Customer.Slip.SlipId)
,SUM(Customer.Slip.Amount)
,PB.[BrancName]
,Customer.Slip.SourceId
From Customer.Slip with (nolock) inner join Customer.Customer with (nolock) on Customer.Slip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where Customer.Slip.SlipStatu not in (2,4)  and Customer.Slip.SlipStateId=1  and Customer.Slip.SlipTypeId<>3 
and cast(DATEADD(MINUTE,180,Customer.Slip.CreateDate) as date)>='''+cast(cast(GETDATE() as date) as NVARCHAR(20))+''' 
and cast(DATEADD(MINUTE,180,Customer.Slip.CreateDate) as date)<='''+cast(cast(GETDATE() as date) as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.Slip.SourceId '

   SET @sqlcommand2 +=   ' insert @TempSummaryBet (ParentBranch,OpenSlipCount,OpenSlipAmount,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId), COUNT( DISTINCT Customer.SlipSystem.SystemSlipId)
,(select SUM(CS.Amount) from Customer.SlipSystem as CS with (nolock) where cs.SystemSlipId=Customer.SlipSystem.SystemSlipId)
,PB.[BrancName]
,Customer.SlipSystem.SourceId
From Customer.SlipSystem with (nolock) inner join Customer.Customer with (nolock) on Customer.SlipSystem.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId INNER JOIN Customer.SlipSystemSlip ON Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId 
Where Customer.SlipSystem.SlipStatuId not in (2,4)  and Customer.SlipSystem.SlipStateId=1 
and cast(DATEADD(MINUTE,180,Customer.SlipSystem.CreateDate) as date)>='''+cast(cast(GETDATE() as date) as NVARCHAR(20))+''' 
and cast(DATEADD(MINUTE,180,Customer.SlipSystem.CreateDate) as date)<='''+cast(cast(GETDATE() as date) as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId, Customer.SlipSystem.SystemSlipId,Customer.SlipSystem.SourceId '

   SET @sqlcommand22 +=   ' insert @TempSummaryBet (ParentBranch,WonSlipCount ,WonSlipAmount ,WonSlipPayOut,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId), COUNT(Customer.Slip.SlipId)
,SUM(Customer.Slip.Amount)
,SUM(Customer.Slip.Amount*Customer.Slip.TotalOddValue)
,PB.[BrancName]
,Customer.Slip.SourceId
From Customer.Slip with (nolock) inner join Customer.Customer with (nolock) on Customer.Slip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where Customer.Slip.SlipStatu not in (2,4)  and Customer.Slip.SlipStateId in (3,5) and Customer.Slip.SlipTypeId<>3
and cast(DATEADD(MINUTE,180,Customer.Slip.EvaluateDate) as date)>='''+cast(cast(GETDATE() as date) as NVARCHAR(20))+''' 
and cast(DATEADD(MINUTE,180,Customer.Slip.EvaluateDate) as date)<='''+cast(cast(GETDATE() as date) as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.Slip.SourceId '

    SET @sqlcommand22 +=   ' insert @TempSummaryBet (ParentBranch,WonSlipCount ,WonSlipAmount ,WonSlipPayOut,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId), COUNT(Archive.Slip.SlipId)
,SUM(Archive.Slip.Amount)
,SUM(Archive.Slip.Amount*Archive.Slip.TotalOddValue)
,PB.[BrancName]
,Archive.Slip.SourceId
From Archive.Slip with (nolock) inner join Customer.Customer with (nolock) on Archive.Slip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where Archive.Slip.SlipStatu not in (2,4)  and Archive.Slip.SlipStateId in (3,5) and Archive.Slip.SlipTypeId<>3
and cast(DATEADD(MINUTE,180,Archive.Slip.EvaluateDate) as date)>='''+cast(cast(GETDATE() as date) as NVARCHAR(20))+''' 
and cast(DATEADD(MINUTE,180,Archive.Slip.EvaluateDate) as date)<='''+cast(cast(GETDATE() as date) as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Archive.Slip.SourceId '

    SET @sqlcommand22 +=   ' insert @TempSummaryBet (ParentBranch,WonSlipCount ,WonSlipAmount ,WonSlipPayOut,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId), COUNT(Customer.SlipSystem.SystemSlipId)
,ISNULL((Select SUM(Customer.Slip.Amount) from Customer.Slip with (nolock) where  Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip as CS with (nolock) where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)
,ISNULL((Select SUM(Customer.Slip.TotalOddValue*Customer.Slip.Amount) from Customer.Slip with (nolock) where Customer.Slip.SlipStateId in (3,6) and Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip as CS with (nolock) where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)
,PB.[BrancName]
,Customer.SlipSystem.SourceId
From Customer.SlipSystem with (nolock) inner join Customer.Customer with (nolock) on Customer.SlipSystem.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where Customer.SlipSystem.SlipStatuId not in (2,4)  and Customer.SlipSystem.SlipStateId in (3,5)  
and cast(DATEADD(MINUTE,180,Customer.SlipSystem.EvaluateDate) as date)>='''+cast(cast(GETDATE() as date) as NVARCHAR(20))+''' 
and cast(DATEADD(MINUTE,180,Customer.SlipSystem.EvaluateDate) as date)<='''+cast(cast(GETDATE() as date) as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.SlipSystem.SystemSlipId,Customer.SlipSystem.SourceId '

     SET @sqlcommand22 +=   ' insert @TempSummaryBet (ParentBranch,WonSlipCount ,WonSlipAmount ,WonSlipPayOut,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId), COUNT(Customer.SlipSystem.SystemSlipId)
,ISNULL((Select SUM(Archive.Slip.Amount) from Archive.Slip with (nolock) where  Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip as CS with (nolock) where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)
,ISNULL((Select SUM(Archive.Slip.TotalOddValue*Archive.Slip.Amount) from Archive.Slip with (nolock) where Archive.Slip.SlipStateId in (3,6) and Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip as CS with (nolock) where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)
,PB.[BrancName]
,Customer.SlipSystem.SourceId
From Customer.SlipSystem with (nolock) inner join Customer.Customer with (nolock) on Customer.SlipSystem.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where Customer.SlipSystem.SlipStatuId not in (2,4)  and Customer.SlipSystem.SlipStateId in (3,5)  
and cast(DATEADD(MINUTE,180,Customer.SlipSystem.EvaluateDate) as date)>='''+cast(cast(GETDATE() as date) as NVARCHAR(20))+''' 
and cast(DATEADD(MINUTE,180,Customer.SlipSystem.EvaluateDate) as date)<='''+cast(cast(GETDATE() as date) as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.SlipSystem.SystemSlipId,Customer.SlipSystem.SourceId '


    SET @sqlcommand221 +=   ' insert @TempSummaryBet (ParentBranch,Cashout,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId)
,(select SUM(CashOutValue) from Customer.SlipCashOut with (nolock) where SlipId=Customer.Slip.SlipId) 
,PB.[BrancName]
,Customer.Slip.SourceId
From Customer.Slip with (nolock) inner join Customer.Customer with (nolock) on Customer.Slip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where Customer.Slip.SlipStatu not in (2,4)  and Customer.Slip.SlipStateId in (7) and Customer.Slip.SlipTypeId<>3
and cast(DATEADD(MINUTE,180,Customer.Slip.EvaluateDate) as date)>='''+cast(cast(GETDATE() as date) as NVARCHAR(20))+''' 
and cast(DATEADD(MINUTE,180,Customer.Slip.EvaluateDate) as date)<='''+cast(cast(GETDATE() as date) as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.Slip.SourceId,Customer.Slip.SlipId '

     SET @sqlcommand221 +=   ' insert @TempSummaryBet (ParentBranch,Cashout,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId)
,(select SUM(CashOutValue) from Customer.SlipCashOut with (nolock) where SlipId=Archive.Slip.SlipId) 
,PB.[BrancName]
,Archive.Slip.SourceId
From Archive.Slip with (nolock) inner join Customer.Customer with (nolock) on Archive.Slip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where Archive.Slip.SlipStatu not in (2,4)  and Archive.Slip.SlipStateId in (7) and Archive.Slip.SlipTypeId<>3
and cast(DATEADD(MINUTE,180,Archive.Slip.EvaluateDate) as date)>='''+cast(cast(GETDATE() as date) as NVARCHAR(20))+''' 
and cast(DATEADD(MINUTE,180,Archive.Slip.EvaluateDate) as date)<='''+cast(cast(GETDATE() as date) as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Archive.Slip.SourceId,Archive.Slip.SlipId '


  SET @sqlcommand222 +=   ' insert @TempSummaryBet (ParentBranch,LostSlipCount ,LostSlipAmount,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId), COUNT(Customer.Slip.SlipId)
,SUM(Customer.Slip.Amount)
,PB.[BrancName]
,Customer.Slip.SourceId
From Customer.Slip with (nolock) inner join Customer.Customer with (nolock) on Customer.Slip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where Customer.Slip.SlipStatu not in (2,4)  and Customer.Slip.SlipStateId=4 and Customer.Slip.SlipTypeId<>3
and cast(DATEADD(MINUTE,180,Customer.Slip.EvaluateDate) as date)>='''+cast(cast(GETDATE() as date) as NVARCHAR(20))+''' 
and cast(DATEADD(MINUTE,180,Customer.Slip.EvaluateDate) as date)<='''+cast(cast(GETDATE() as date) as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.Slip.SourceId '

    SET @sqlcommand222 +=   ' insert @TempSummaryBet (ParentBranch,LostSlipCount ,LostSlipAmount,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId), COUNT(Archive.Slip.SlipId)
,SUM(Archive.Slip.Amount)
,PB.[BrancName]
,Archive.Slip.SourceId
From Archive.Slip with (nolock) inner  join Customer.Customer with (nolock) on Archive.Slip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where Archive.Slip.SlipStatu not in (2,4)   and Archive.Slip.SlipStateId=4 and Archive.Slip.SlipTypeId<>3
and cast(DATEADD(MINUTE,180,Archive.Slip.EvaluateDate) as date)>='''+cast(cast(GETDATE() as date) as NVARCHAR(20))+''' 
and cast(DATEADD(MINUTE,180,Archive.Slip.EvaluateDate) as date)<='''+cast(cast(GETDATE() as date) as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Archive.Slip.SourceId '


     SET @sqlcommand222 +=   ' insert @TempSummaryBet (ParentBranch,LostSlipCount ,LostSlipAmount,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId), COUNT(Customer.SlipSystem.SystemSlipId)
,SUM(Customer.SlipSystem.Amount)
,PB.[BrancName]
,Customer.SlipSystem.SourceId
From Customer.SlipSystem with (nolock) inner join Customer.Customer with (nolock) on Customer.SlipSystem.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where Customer.SlipSystem.SlipStatuId not in (2,4)   and Customer.SlipSystem.SlipStateId=4  
and cast(DATEADD(MINUTE,180,Customer.SlipSystem.EvaluateDate) as date)>='''+cast(cast(GETDATE() as date) as NVARCHAR(20))+''' 
and cast(DATEADD(MINUTE,180,Customer.SlipSystem.EvaluateDate) as date)<='''+cast(cast(GETDATE() as date) as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.SlipSystem.SystemSlipId,Customer.SlipSystem.SourceId '


 SET @sqlcommand222 +=   ' insert @TempSummaryBet (ParentBranch,CancelSlipCount ,CancelSlipAmount,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId), COUNT(Customer.Slip.SlipId)
,SUM(Customer.Slip.Amount)
,PB.[BrancName]
,Customer.Slip.SourceId
From Customer.Slip with (nolock) inner join Customer.Customer with (nolock) on Customer.Slip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where Customer.Slip.SlipStatu not in (2,4)  and Customer.Slip.SlipStateId=2 
and cast(DATEADD(MINUTE,180,Customer.Slip.EvaluateDate) as date)>='''+cast(cast(GETDATE() as date) as NVARCHAR(20))+''' 
and cast(DATEADD(MINUTE,180,Customer.Slip.EvaluateDate) as date)<='''+cast(cast(GETDATE() as date) as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.Slip.SlipId,Customer.Slip.SourceId '

    SET @sqlcommand222 +=   ' insert @TempSummaryBet (ParentBranch,CancelSlipCount ,CancelSlipAmount,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId), COUNT(Archive.Slip.SlipId)
,SUM(Archive.Slip.Amount)
,PB.[BrancName]
,Archive.Slip.SourceId
From Archive.Slip with (nolock) inner join Customer.Customer with (nolock) on Archive.Slip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where Archive.Slip.SlipStatu not in (2,4)  and Archive.Slip.SlipStateId=2 
and cast(DATEADD(MINUTE,180,Archive.Slip.EvaluateDate) as date)>='''+cast(cast(GETDATE() as date) as NVARCHAR(20))+''' 
and cast(DATEADD(MINUTE,180,Archive.Slip.EvaluateDate) as date)<='''+cast(cast(GETDATE() as date) as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Archive.Slip.SlipId,Archive.Slip.SourceId '

   SET @sqlcommand2222 +=   ' insert @TempSummaryBet (ParentBranch,CancelSlipCount ,CancelSlipAmount,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId)
	, COUNT(Customer.Tax.SlipId)
,SUM(Customer.Tax.[TaxAmount])
,PB.[BrancName]
,Customer.Slip.SourceId
From Customer.Tax with (nolock) inner join Customer.Customer with (nolock) on Customer.Tax.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId INNER JOIN Customer.Slip ON Customer.Slip.SlipId=Customer.Tax.SlipId
Where Customer.Tax.TaxStatusId in (2)  
and cast(DATEADD(MINUTE,180,Customer.Tax.[CreateDate]) as date)>='''+cast(cast(GETDATE() as date) as NVARCHAR(20))+''' 
and cast(DATEADD(MINUTE,180,Customer.Tax.[CreateDate]) as date)<='''+cast(cast(GETDATE() as date) as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId ,Customer.Slip.SourceId '

   SET @sqlcommand2222 +=   ' insert @TempSummaryBet (ParentBranch,CancelSlipCount ,CancelSlipAmount,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId)
	, COUNT(Customer.Tax.SlipId)
,SUM(Customer.Tax.[TaxAmount])
,PB.[BrancName]
,Archive.Slip.SourceId
From Customer.Tax with (nolock) inner join Customer.Customer with (nolock) on Customer.Tax.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId INNER JOIN Archive.Slip ON Archive.Slip.SlipId=Customer.Tax.SlipId
Where Customer.Tax.TaxStatusId in (2)  
and cast(DATEADD(MINUTE,180,Customer.Tax.[CreateDate]) as date)>='''+cast(cast(GETDATE() as date) as NVARCHAR(20))+''' 
and cast(DATEADD(MINUTE,180,Customer.Tax.[CreateDate]) as date)<='''+cast(cast(GETDATE() as date) as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId ,Archive.Slip.SourceId '


  SET @sqlcommand2222 +=   ' insert @TempSummaryBet (ParentBranch,TaxCount ,TaxAmount,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId)
	, COUNT(Customer.Tax.SlipId)
,SUM(Customer.Tax.[TaxAmount])
,PB.[BrancName]
,Customer.Slip.SourceId
From Customer.Tax with (nolock) inner join Customer.Customer with (nolock) on Customer.Tax.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId INNER JOIN Customer.Slip ON Customer.Slip.SlipId=Customer.Tax.SlipId
Where Customer.Tax.TaxStatusId in (1,3)  
and cast(DATEADD(MINUTE,180,Customer.Tax.[CreateDate]) as date)>='''+cast(cast(GETDATE() as date) as NVARCHAR(20))+''' 
and cast(DATEADD(MINUTE,180,Customer.Tax.[CreateDate]) as date)<='''+cast(cast(GETDATE() as date) as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId ,Customer.Slip.SourceId '

   SET @sqlcommand2222 +=   ' insert @TempSummaryBet (ParentBranch,TaxCount ,TaxAmount,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId)
	, COUNT(Customer.Tax.SlipId)
,SUM(Customer.Tax.[TaxAmount])
,PB.[BrancName]
,Archive.Slip.SourceId
From Customer.Tax with (nolock) inner join Customer.Customer with (nolock) on Customer.Tax.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId INNER JOIN Archive.Slip ON Archive.Slip.SlipId=Customer.Tax.SlipId
Where Customer.Tax.TaxStatusId in (1,3)  
and cast(DATEADD(MINUTE,180,Customer.Tax.[CreateDate]) as date)>='''+cast(cast(GETDATE() as date) as NVARCHAR(20))+''' 
and cast(DATEADD(MINUTE,180,Customer.Tax.[CreateDate]) as date)<='''+cast(cast(GETDATE() as date) as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId ,Archive.Slip.SourceId '


   SET @sqlcommand2222 +=   ' insert @TempSummaryBet (ParentBranch,PartnerTurnOver ,BranchTaxAmount,BranchName,SourceId) '+
    '	 SELECT (select ppp.BrancName COLLATE SQL_Latin1_General_CP1_CI_AS from Parameter.Branch as ppp with (nolock) where ppp.BranchId in (select pp.ParentBranchId from Parameter.Branch as pp with (nolock) where pp.BrancName COLLATE SQL_Latin1_General_CP1_CI_AS=tp.ParentBranch))
, SUM(SlipAmount)-(sum(WonSlipPayOut)+ISNULL(sum(Cashout),0)+ISNULL(sum(CancelSlipAmount),0)) as Profit
 ,SUM(TaxAmount) as TaxAmount
 ,TP.ParentBranch COLLATE SQL_Latin1_General_CP1_CI_AS
 ,TP.SourceId
 FROM @TempSummaryBet as TP 
 where (TP.ParentBranch in (select ppp.BrancName COLLATE SQL_Latin1_General_CP1_CI_AS from Parameter.Branch as ppp with (nolock) where ppp.BranchId in (select pp.ParentBranchId from Parameter.Branch as pp with (nolock) where pp.BrancName COLLATE SQL_Latin1_General_CP1_CI_AS=tp.BranchName))) 
 GROUP BY  TP.[BranchName],TP.ParentBranch ,TP.SourceId   HAVING SUM(SlipAmount) is not null'

  SET @sqlcommand22222 +=   ' insert @TempSummaryBet (ParentBranch,PayOutCount ,PayOutAmount,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId), COUNT(Customer.Slip.SlipId)
,SUM(Customer.Slip.Amount*Customer.Slip.TotalOddValue)
,PB.[BrancName]
,Customer.Slip.SourceId
From Customer.Slip with (nolock) inner join Customer.Customer with (nolock) on Customer.Slip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where Customer.Slip.SlipStatu not in (2,4) and Customer.Slip.SlipStateId in (3,5)  and Customer.Slip.IsPayOut=1
and cast(DATEADD(MINUTE,180,Customer.Slip.EvaluateDate) as date)>='''+cast(cast(GETDATE() as date) as NVARCHAR(20))+''' 
and cast(DATEADD(MINUTE,180,Customer.Slip.EvaluateDate) as date)<='''+cast(cast(GETDATE() as date) as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Customer.Slip.SourceId '

    SET @sqlcommand22222 +=   ' insert @TempSummaryBet (ParentBranch,PayOutCount ,PayOutAmount,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=PB.ParentBranchId), COUNT(Archive.Slip.SlipId)
,SUM(Archive.Slip.Amount*Archive.Slip.TotalOddValue)
,PB.[BrancName]
,Archive.Slip.SourceId
From Archive.Slip with (nolock) inner join Customer.Customer with (nolock) on Archive.Slip.CustomerId=Customer.Customer.CustomerId INNER JOIN
  [Parameter].[Branch] as PB with (nolock) ON  PB.[BranchId]=Customer.Customer.BranchId 
Where Archive.Slip.SlipStatu not in (2,4)   and Archive.Slip.SlipStateId in (3,5)  and Archive.Slip.IsPayOut=1
and cast(DATEADD(MINUTE,180,Archive.Slip.EvaluateDate) as date)>='''+cast(cast(GETDATE() as date) as NVARCHAR(20))+''' 
and cast(DATEADD(MINUTE,180,Archive.Slip.EvaluateDate) as date)<='''+cast(cast(GETDATE() as date) as NVARCHAR(20)) +''' AND '+@where2+'
 GROUP BY PB.[BrancName],PB.BranchId,PB.ParentBranchId,Archive.Slip.SourceId '


 -----------------------------------------------Terminal Hesapları -----------------------------------------------------------------------
 
	
 set @sqlcommand2T=
  'insert @TempSummaryBet (ParentBranch,SlipCount,SlipAmount,BranchName,SourceId) '+
  'select  (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=(select P.ParentBranchId from Parameter.Branch as P where P.BranchId='''+cast(@BranchId as NVARCHAR(20))+''' )), COUNT(Customer.Slip.SlipId)
,SUM(Customer.Slip.Amount)
, (select P.BrancName from Parameter.Branch as P where P.BranchId='''+cast(@BranchId as NVARCHAR(20))+''')
,Customer.Slip.SourceId
From Customer.Slip with (nolock) inner join Customer.Customer with (nolock) on Customer.Slip.CustomerId=Customer.Customer.CustomerId  
Where Customer.Slip.SlipStatu not in (2,4) 
and cast(DATEADD(MINUTE,180,Customer.Slip.CreateDate) as date)>='''+cast(cast(GETDATE() as date) as NVARCHAR(20))+''' 
and cast(DATEADD(MINUTE,180,Customer.Slip.CreateDate) as date)<='''+cast(cast(GETDATE() as date) as NVARCHAR(20)) +''' AND '+@whereTerminal+'
 GROUP BY Customer.Slip.SourceId '


 SET @sqlcommand2T +=   ' insert @TempSummaryBet (ParentBranch,SlipCount,SlipAmount,BranchName,SourceId) '+
  'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=(select P.ParentBranchId from Parameter.Branch as P with (nolock) where P.BranchId='''+cast(@BranchId as NVARCHAR(20))+''' )), COUNT(Archive.Slip.SlipId)
,SUM(Archive.Slip.Amount)
, (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId='''+cast(@BranchId as NVARCHAR(20))+''')
,Archive.Slip.SourceId
From Archive.Slip with (nolock) inner join Customer.Customer with (nolock) on Archive.Slip.CustomerId=Customer.Customer.CustomerId 
Where Archive.Slip.SlipStatu not in (2,4) 
and cast(DATEADD(MINUTE,180,Archive.Slip.CreateDate) as date)>='''+cast(cast(GETDATE() as date) as NVARCHAR(20))+''' 
and cast(DATEADD(MINUTE,180,Archive.Slip.CreateDate) as date)<='''+cast(cast(GETDATE() as date) as NVARCHAR(20)) +''' AND '+@whereTerminal+'
 GROUP BY  Archive.Slip.SourceId '

  SET @sqlcommand2T +=   ' insert @TempSummaryBet (ParentBranch,OpenSlipCount,OpenSlipAmount,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=(select P.ParentBranchId from Parameter.Branch as P with (nolock) where P.BranchId='''+cast(@BranchId as NVARCHAR(20))+''' )), COUNT(Customer.Slip.SlipId)
,SUM(Customer.Slip.Amount)
, (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId='''+cast(@BranchId as NVARCHAR(20))+''')
,Customer.Slip.SourceId
From Customer.Slip with (nolock) inner join Customer.Customer with (nolock) on Customer.Slip.CustomerId=Customer.Customer.CustomerId 
Where Customer.Slip.SlipStatu not in (2,4)  and Customer.Slip.SlipStateId=1  and Customer.Slip.SlipTypeId<>3 
and cast(DATEADD(MINUTE,180,Customer.Slip.CreateDate) as date)>='''+cast(cast(GETDATE() as date) as NVARCHAR(20))+''' 
and cast(DATEADD(MINUTE,180,Customer.Slip.CreateDate) as date)<='''+cast(cast(GETDATE() as date) as NVARCHAR(20)) +''' AND '+@whereTerminal+'
 GROUP BY Customer.Slip.SourceId '

   SET @sqlcommand2T +=   ' insert @TempSummaryBet (ParentBranch,OpenSlipCount,OpenSlipAmount,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=(select P.ParentBranchId from Parameter.Branch as P with (nolock) where P.BranchId='''+cast(@BranchId as NVARCHAR(20))+''' )), COUNT( DISTINCT Customer.SlipSystem.SystemSlipId)
,(select SUM(CS.Amount) from Customer.SlipSystem as CS with (nolock) where cs.SystemSlipId=Customer.SlipSystem.SystemSlipId)
, (select P.BrancName from Parameter.Branch as P where P.BranchId='''+cast(@BranchId as NVARCHAR(20))+''')
,Customer.SlipSystem.SourceId
From Customer.SlipSystem with (nolock) inner join Customer.Customer with (nolock) on Customer.SlipSystem.CustomerId=Customer.Customer.CustomerId 
INNER JOIN Customer.SlipSystemSlip with (nolock) ON Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId 
Where Customer.SlipSystem.SlipStatuId not in (2,4)  and Customer.SlipSystem.SlipStateId=1 
and cast(DATEADD(MINUTE,180,Customer.SlipSystem.CreateDate) as date)>='''+cast(cast(GETDATE() as date) as NVARCHAR(20))+''' 
and cast(DATEADD(MINUTE,180,Customer.SlipSystem.CreateDate) as date)<='''+cast(cast(GETDATE() as date) as NVARCHAR(20)) +''' AND '+@whereTerminal+'
 GROUP BY  Customer.SlipSystem.SystemSlipId,Customer.SlipSystem.SourceId '

   SET @sqlcommand22T +=   ' insert @TempSummaryBet (ParentBranch,WonSlipCount ,WonSlipAmount ,WonSlipPayOut,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=(select P.ParentBranchId from Parameter.Branch as P with (nolock) where P.BranchId='''+cast(@BranchId as NVARCHAR(20))+''' )), COUNT(Customer.Slip.SlipId)
,SUM(Customer.Slip.Amount)
,SUM(Customer.Slip.Amount*Customer.Slip.TotalOddValue)
,(select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId='''+cast(@BranchId as NVARCHAR(20))+''')
,Customer.Slip.SourceId
From Customer.Slip with (nolock) inner join Customer.Customer with (nolock) on Customer.Slip.CustomerId=Customer.Customer.CustomerId
Where Customer.Slip.SlipStatu not in (2,4)  and Customer.Slip.SlipStateId in (3,5) and Customer.Slip.SlipTypeId<>3
and cast(DATEADD(MINUTE,180,Customer.Slip.EvaluateDate) as date)>='''+cast(cast(GETDATE() as date) as NVARCHAR(20))+''' 
and cast(DATEADD(MINUTE,180,Customer.Slip.EvaluateDate) as date)<='''+cast(cast(GETDATE() as date) as NVARCHAR(20)) +''' AND '+@whereTerminal+'
 GROUP BY Customer.Slip.SourceId '

    SET @sqlcommand22T +=   ' insert @TempSummaryBet (ParentBranch,WonSlipCount ,WonSlipAmount ,WonSlipPayOut,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=(select P.ParentBranchId from Parameter.Branch as P with (nolock) where P.BranchId='''+cast(@BranchId as NVARCHAR(20))+''' )), COUNT(Archive.Slip.SlipId)
,SUM(Archive.Slip.Amount)
,SUM(Archive.Slip.Amount*Archive.Slip.TotalOddValue)
,(select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId='''+cast(@BranchId as NVARCHAR(20))+''')
,Archive.Slip.SourceId
From Archive.Slip with (nolock) inner join Customer.Customer with (nolock) on Archive.Slip.CustomerId=Customer.Customer.CustomerId 
Where Archive.Slip.SlipStatu not in (2,4)  and Archive.Slip.SlipStateId in (3,5) and Archive.Slip.SlipTypeId<>3
and cast(DATEADD(MINUTE,180,Archive.Slip.EvaluateDate) as date)>='''+cast(cast(GETDATE() as date) as NVARCHAR(20))+''' 
and cast(DATEADD(MINUTE,180,Archive.Slip.EvaluateDate) as date)<='''+cast(cast(GETDATE() as date) as NVARCHAR(20)) +''' AND '+@whereTerminal+'
 GROUP BY Archive.Slip.SourceId '

    SET @sqlcommand22T +=   ' insert @TempSummaryBet (ParentBranch,WonSlipCount ,WonSlipAmount ,WonSlipPayOut,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=(select P.ParentBranchId from Parameter.Branch as P with (nolock) where P.BranchId='''+cast(@BranchId as NVARCHAR(20))+''' )), COUNT(Customer.SlipSystem.SystemSlipId)
,ISNULL((Select SUM(Customer.Slip.Amount) from Customer.Slip with (nolock) where  Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip as CS with (nolock) where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)
,ISNULL((Select SUM(Customer.Slip.TotalOddValue*Customer.Slip.Amount) from Customer.Slip with (nolock) where Customer.Slip.SlipStateId in (3,6) and Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip as CS with (nolock) where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)
,(select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId='''+cast(@BranchId as NVARCHAR(20))+''')
,Customer.SlipSystem.SourceId
From Customer.SlipSystem with (nolock) inner join Customer.Customer with (nolock) on Customer.SlipSystem.CustomerId=Customer.Customer.CustomerId 
Where Customer.SlipSystem.SlipStatuId not in (2,4)  and Customer.SlipSystem.SlipStateId in (3,5)  
and cast(DATEADD(MINUTE,180,Customer.SlipSystem.EvaluateDate) as date)>='''+cast(cast(GETDATE() as date) as NVARCHAR(20))+''' 
and cast(DATEADD(MINUTE,180,Customer.SlipSystem.EvaluateDate) as date)<='''+cast(cast(GETDATE() as date) as NVARCHAR(20)) +''' AND '+@whereTerminal+'
 GROUP BY Customer.SlipSystem.SystemSlipId,Customer.SlipSystem.SourceId '

     SET @sqlcommand22T +=   ' insert @TempSummaryBet (ParentBranch,WonSlipCount ,WonSlipAmount ,WonSlipPayOut,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=(select P.ParentBranchId from Parameter.Branch as P with (nolock) where P.BranchId='''+cast(@BranchId as NVARCHAR(20))+''' )), COUNT(Customer.SlipSystem.SystemSlipId)
,ISNULL((Select SUM(Archive.Slip.Amount) from Archive.Slip with (nolock) where  Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip as CS with (nolock) where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)
,ISNULL((Select SUM(Archive.Slip.TotalOddValue*Archive.Slip.Amount) from Archive.Slip with (nolock) where Archive.Slip.SlipStateId in (3,6) and Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip as CS with (nolock) where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)
,(select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId='''+cast(@BranchId as NVARCHAR(20))+''')
,Customer.SlipSystem.SourceId
From Customer.SlipSystem with (nolock) inner join Customer.Customer with (nolock) on Customer.SlipSystem.CustomerId=Customer.Customer.CustomerId 
Where Customer.SlipSystem.SlipStatuId not in (2,4)  and Customer.SlipSystem.SlipStateId in (3,5)  
and cast(DATEADD(MINUTE,180,Customer.SlipSystem.EvaluateDate) as date)>='''+cast(cast(GETDATE() as date) as NVARCHAR(20))+''' 
and cast(DATEADD(MINUTE,180,Customer.SlipSystem.EvaluateDate) as date)<='''+cast(cast(GETDATE() as date) as NVARCHAR(20)) +''' AND '+@whereTerminal+'
 GROUP BY  Customer.SlipSystem.SystemSlipId,Customer.SlipSystem.SourceId '


    SET @sqlcommand221T +=   ' insert @TempSummaryBet (ParentBranch,Cashout,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=(select P.ParentBranchId from Parameter.Branch as P with (nolock) where P.BranchId='''+cast(@BranchId as NVARCHAR(20))+''' ))
,(select SUM(CashOutValue) from Customer.SlipCashOut where SlipId=Customer.Slip.SlipId) 
,(select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId='''+cast(@BranchId as NVARCHAR(20))+''')
,Customer.Slip.SourceId
From Customer.Slip with (nolock) inner join Customer.Customer with (nolock) on Customer.Slip.CustomerId=Customer.Customer.CustomerId 
Where Customer.Slip.SlipStatu not in (2,4)  and Customer.Slip.SlipStateId in (7) and Customer.Slip.SlipTypeId<>3
and cast(DATEADD(MINUTE,180,Customer.Slip.EvaluateDate) as date)>='''+cast(cast(GETDATE() as date) as NVARCHAR(20))+''' 
and cast(DATEADD(MINUTE,180,Customer.Slip.EvaluateDate) as date)<='''+cast(cast(GETDATE() as date) as NVARCHAR(20)) +''' AND '+@whereTerminal+'
 GROUP BY Customer.Slip.SourceId,Customer.Slip.SlipId '

     SET @sqlcommand221T +=   ' insert @TempSummaryBet (ParentBranch,Cashout,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=(select P.ParentBranchId from Parameter.Branch as P with (nolock) where P.BranchId='''+cast(@BranchId as NVARCHAR(20))+''' ))
,(select SUM(CashOutValue) from Customer.SlipCashOut with (nolock) where SlipId=Archive.Slip.SlipId) 
,(select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId='''+cast(@BranchId as NVARCHAR(20))+''')
,Archive.Slip.SourceId
From Archive.Slip with (nolock) inner join Customer.Customer with (nolock) on Archive.Slip.CustomerId=Customer.Customer.CustomerId 
Where Archive.Slip.SlipStatu not in (2,4)  and Archive.Slip.SlipStateId in (7) and Archive.Slip.SlipTypeId<>3
and cast(DATEADD(MINUTE,180,Archive.Slip.EvaluateDate) as date)>='''+cast(cast(GETDATE() as date) as NVARCHAR(20))+''' 
and cast(DATEADD(MINUTE,180,Archive.Slip.EvaluateDate) as date)<='''+cast(cast(GETDATE() as date) as NVARCHAR(20)) +''' AND '+@whereTerminal+'
 GROUP BY Archive.Slip.SourceId,Archive.Slip.SlipId '


  SET @sqlcommand222T +=   ' insert @TempSummaryBet (ParentBranch,LostSlipCount ,LostSlipAmount,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=(select P.ParentBranchId from Parameter.Branch as P with (nolock) where P.BranchId='''+cast(@BranchId as NVARCHAR(20))+''' )), COUNT(Customer.Slip.SlipId)
,SUM(Customer.Slip.Amount)
,(select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId='''+cast(@BranchId as NVARCHAR(20))+''')
,Customer.Slip.SourceId
From Customer.Slip with (nolock) inner join Customer.Customer with (nolock) on Customer.Slip.CustomerId=Customer.Customer.CustomerId 
Where Customer.Slip.SlipStatu not in (2,4)  and Customer.Slip.SlipStateId=4 and Customer.Slip.SlipTypeId<>3
and cast(DATEADD(MINUTE,180,Customer.Slip.EvaluateDate) as date)>='''+cast(cast(GETDATE() as date) as NVARCHAR(20))+''' 
and cast(DATEADD(MINUTE,180,Customer.Slip.EvaluateDate) as date)<='''+cast(cast(GETDATE() as date) as NVARCHAR(20)) +''' AND '+@whereTerminal+'
 GROUP BY  Customer.Slip.SourceId '

    SET @sqlcommand222T +=   ' insert @TempSummaryBet (ParentBranch,LostSlipCount ,LostSlipAmount,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=(select P.ParentBranchId from Parameter.Branch as P with (nolock) where P.BranchId='''+cast(@BranchId as NVARCHAR(20))+''' )), COUNT(Archive.Slip.SlipId)
,SUM(Archive.Slip.Amount)
,(select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId='''+cast(@BranchId as NVARCHAR(20))+''')
,Archive.Slip.SourceId
From Archive.Slip with (nolock) inner join Customer.Customer with (nolock) on Archive.Slip.CustomerId=Customer.Customer.CustomerId 
Where Archive.Slip.SlipStatu not in (2,4)   and Archive.Slip.SlipStateId=4 and Archive.Slip.SlipTypeId<>3
and cast(DATEADD(MINUTE,180,Archive.Slip.EvaluateDate) as date)>='''+cast(cast(GETDATE() as date) as NVARCHAR(20))+''' 
and cast(DATEADD(MINUTE,180,Archive.Slip.EvaluateDate) as date)<='''+cast(cast(GETDATE() as date) as NVARCHAR(20)) +''' AND '+@whereTerminal+'
 GROUP BY  Archive.Slip.SourceId '


     SET @sqlcommand222T +=   ' insert @TempSummaryBet (ParentBranch,LostSlipCount ,LostSlipAmount,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=(select P.ParentBranchId from Parameter.Branch as P with (nolock) where P.BranchId='''+cast(@BranchId as NVARCHAR(20))+''' )), COUNT(Customer.SlipSystem.SystemSlipId)
,SUM(Customer.SlipSystem.Amount)
,(select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId='''+cast(@BranchId as NVARCHAR(20))+''')
,Customer.SlipSystem.SourceId
From Customer.SlipSystem with (nolock) inner join Customer.Customer with (nolock) on Customer.SlipSystem.CustomerId=Customer.Customer.CustomerId 
Where Customer.SlipSystem.SlipStatuId not in (2,4)   and Customer.SlipSystem.SlipStateId=4  
and cast(DATEADD(MINUTE,180,Customer.SlipSystem.EvaluateDate) as date)>='''+cast(cast(GETDATE() as date) as NVARCHAR(20))+''' 
and cast(DATEADD(MINUTE,180,Customer.SlipSystem.EvaluateDate) as date)<='''+cast(cast(GETDATE() as date) as NVARCHAR(20)) +''' AND '+@whereTerminal+'
 GROUP BY Customer.SlipSystem.SystemSlipId,Customer.SlipSystem.SourceId '


 SET @sqlcommand0222T +=   ' insert @TempSummaryBet (ParentBranch,CancelSlipCount ,CancelSlipAmount,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=(select P.ParentBranchId from Parameter.Branch as P with (nolock) where P.BranchId='''+cast(@BranchId as NVARCHAR(20))+''' )), COUNT(Customer.Slip.SlipId)
,SUM(Customer.Slip.Amount)
,(select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId='''+cast(@BranchId as NVARCHAR(20))+''')
,Customer.Slip.SourceId
From Customer.Slip with (nolock) inner join Customer.Customer with (nolock) on Customer.Slip.CustomerId=Customer.Customer.CustomerId 
Where Customer.Slip.SlipStatu not in (2,4)  and Customer.Slip.SlipStateId=2 
and cast(DATEADD(MINUTE,180,Customer.Slip.EvaluateDate) as date)>='''+cast(cast(GETDATE() as date) as NVARCHAR(20))+''' 
and cast(DATEADD(MINUTE,180,Customer.Slip.EvaluateDate) as date)<='''+cast(cast(GETDATE() as date) as NVARCHAR(20)) +''' AND '+@whereTerminal+'
 GROUP BY Customer.Slip.SlipId,Customer.Slip.SourceId '

    SET @sqlcommand0222T +=   ' insert @TempSummaryBet (ParentBranch,CancelSlipCount ,CancelSlipAmount,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=(select P.ParentBranchId from Parameter.Branch as P with (nolock) where P.BranchId='''+cast(@BranchId as NVARCHAR(20))+''' )), COUNT(Archive.Slip.SlipId)
,SUM(Archive.Slip.Amount)
,(select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId='''+cast(@BranchId as NVARCHAR(20))+''')
,Archive.Slip.SourceId
From Archive.Slip with (nolock) inner join Customer.Customer with (nolock) on Archive.Slip.CustomerId=Customer.Customer.CustomerId
Where Archive.Slip.SlipStatu not in (2,4)  and Archive.Slip.SlipStateId=2 
and cast(DATEADD(MINUTE,180,Archive.Slip.EvaluateDate) as date)>='''+cast(cast(GETDATE() as date) as NVARCHAR(20))+''' 
and cast(DATEADD(MINUTE,180,Archive.Slip.EvaluateDate) as date)<='''+cast(cast(GETDATE() as date) as NVARCHAR(20)) +''' AND '+@whereTerminal+'
 GROUP BY Archive.Slip.SlipId,Archive.Slip.SourceId '

   SET @sqlcommand2222T +=   ' insert @TempSummaryBet (ParentBranch,CancelSlipCount ,CancelSlipAmount,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=(select P.ParentBranchId from Parameter.Branch as P with (nolock) where P.BranchId='''+cast(@BranchId as NVARCHAR(20))+''' ))
	, COUNT(Customer.Tax.SlipId)
,SUM(Customer.Tax.[TaxAmount])
,(select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId='''+cast(@BranchId as NVARCHAR(20))+''')
,Customer.Slip.SourceId
From Customer.Tax with (nolock) inner join Customer.Customer with (nolock) on Customer.Tax.CustomerId=Customer.Customer.CustomerId INNER JOIN Customer.Slip with (nolock) ON Customer.Slip.SlipId=Customer.Tax.SlipId
Where Customer.Tax.TaxStatusId in (2)  
and cast(DATEADD(MINUTE,180,Customer.Tax.[CreateDate]) as date)>='''+cast(cast(GETDATE() as date) as NVARCHAR(20))+''' 
and cast(DATEADD(MINUTE,180,Customer.Tax.[CreateDate]) as date)<='''+cast(cast(GETDATE() as date) as NVARCHAR(20)) +''' AND '+@whereTerminal+'
 GROUP BY Customer.Slip.SourceId '

   SET @sqlcommand2222T +=   ' insert @TempSummaryBet (ParentBranch,CancelSlipCount ,CancelSlipAmount,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=(select P.ParentBranchId from Parameter.Branch as P with (nolock) where P.BranchId='''+cast(@BranchId as NVARCHAR(20))+''' ))
	, COUNT(Customer.Tax.SlipId)
,SUM(Customer.Tax.[TaxAmount])
,(select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId='''+cast(@BranchId as NVARCHAR(20))+''')
,Archive.Slip.SourceId
From Customer.Tax with (nolock) inner join Customer.Customer with (nolock) on Customer.Tax.CustomerId=Customer.Customer.CustomerId INNER JOIN Archive.Slip ON Archive.Slip.SlipId=Customer.Tax.SlipId
Where Customer.Tax.TaxStatusId in (2)  
and cast(DATEADD(MINUTE,180,Customer.Tax.[CreateDate]) as date)>='''+cast(cast(GETDATE() as date) as NVARCHAR(20))+''' 
and cast(DATEADD(MINUTE,180,Customer.Tax.[CreateDate]) as date)<='''+cast(cast(GETDATE() as date) as NVARCHAR(20)) +''' AND '+@whereTerminal+'
 GROUP BY Archive.Slip.SourceId '


  SET @sqlcommand2222T +=   ' insert @TempSummaryBet (ParentBranch,TaxCount ,TaxAmount,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=(select P.ParentBranchId from Parameter.Branch as P with (nolock) where P.BranchId='''+cast(@BranchId as NVARCHAR(20))+''' ))
	, COUNT(Customer.Tax.SlipId)
,SUM(Customer.Tax.[TaxAmount])
,(select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId='''+cast(@BranchId as NVARCHAR(20))+''')
,Customer.Slip.SourceId
From Customer.Tax with (nolock) inner join Customer.Customer with (nolock) on Customer.Tax.CustomerId=Customer.Customer.CustomerId INNER JOIN Customer.Slip with (nolock) ON Customer.Slip.SlipId=Customer.Tax.SlipId
Where Customer.Tax.TaxStatusId in (1,3)  
and cast(DATEADD(MINUTE,180,Customer.Tax.[CreateDate]) as date)>='''+cast(cast(GETDATE() as date) as NVARCHAR(20))+''' 
and cast(DATEADD(MINUTE,180,Customer.Tax.[CreateDate]) as date)<='''+cast(cast(GETDATE() as date) as NVARCHAR(20)) +''' AND '+@whereTerminal+'
 GROUP BY Customer.Slip.SourceId '

   SET @sqlcommand2222T +=   ' insert @TempSummaryBet (ParentBranch,TaxCount ,TaxAmount,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=(select P.ParentBranchId from Parameter.Branch as P with (nolock) where P.BranchId='''+cast(@BranchId as NVARCHAR(20))+''' ))
	, COUNT(Customer.Tax.SlipId)
,SUM(Customer.Tax.[TaxAmount])
,(select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId='''+cast(@BranchId as NVARCHAR(20))+''')
,Archive.Slip.SourceId
From Customer.Tax with (nolock) inner join Customer.Customer with (nolock) on Customer.Tax.CustomerId=Customer.Customer.CustomerId INNER JOIN Archive.Slip with (nolock) ON Archive.Slip.SlipId=Customer.Tax.SlipId
Where Customer.Tax.TaxStatusId in (1,3)  
and cast(DATEADD(MINUTE,180,Customer.Tax.[CreateDate]) as date)>='''+cast(cast(GETDATE() as date) as NVARCHAR(20))+''' 
and cast(DATEADD(MINUTE,180,Customer.Tax.[CreateDate]) as date)<='''+cast(cast(GETDATE() as date) as NVARCHAR(20)) +''' AND '+@whereTerminal+'
 GROUP BY Archive.Slip.SourceId '


  

  SET @sqlcommand22222T +=   ' insert @TempSummaryBet (ParentBranch,PayOutCount ,PayOutAmount,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=(select P.ParentBranchId from Parameter.Branch as P with (nolock) where P.BranchId='''+cast(@BranchId as NVARCHAR(20))+''' )), COUNT(Customer.Slip.SlipId)
,SUM(Customer.Slip.Amount*Customer.Slip.TotalOddValue)
,(select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId='''+cast(@BranchId as NVARCHAR(20))+''')
,Customer.Slip.SourceId
From Customer.Slip with (nolock) inner join Customer.Customer with (nolock) on Customer.Slip.CustomerId=Customer.Customer.CustomerId 
Where Customer.Slip.SlipStatu not in (2,4) and Customer.Slip.SlipStateId in (3,5)  and Customer.Slip.IsPayOut=1
and cast(DATEADD(MINUTE,180,Customer.Slip.EvaluateDate) as date)>='''+cast(cast(GETDATE() as date) as NVARCHAR(20))+''' 
and cast(DATEADD(MINUTE,180,Customer.Slip.EvaluateDate) as date)<='''+cast(cast(GETDATE() as date) as NVARCHAR(20)) +''' AND '+@whereTerminal+'
 GROUP BY Customer.Slip.SourceId '

    SET @sqlcommand22222T +=   ' insert @TempSummaryBet (ParentBranch,PayOutCount ,PayOutAmount,BranchName,SourceId) '+
    'select (select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId=(select P.ParentBranchId from Parameter.Branch as P with (nolock) where P.BranchId='''+cast(@BranchId as NVARCHAR(20))+''' )), COUNT(Archive.Slip.SlipId)
,SUM(Archive.Slip.Amount*Archive.Slip.TotalOddValue)
,(select P.BrancName from Parameter.Branch as P with (nolock) where P.BranchId='''+cast(@BranchId as NVARCHAR(20))+''')
,Archive.Slip.SourceId
From Archive.Slip with (nolock) inner join Customer.Customer with (nolock) on Archive.Slip.CustomerId=Customer.Customer.CustomerId 
Where Archive.Slip.SlipStatu not in (2,4)   and Archive.Slip.SlipStateId in (3,5)  and Archive.Slip.IsPayOut=1
and cast(DATEADD(MINUTE,180,Archive.Slip.EvaluateDate) as date)>='''+cast(cast(GETDATE() as date) as NVARCHAR(20))+''' 
and cast(DATEADD(MINUTE,180,Archive.Slip.EvaluateDate) as date)<='''+cast(cast(GETDATE() as date) as NVARCHAR(20)) +''' AND '+@whereTerminal+'
 GROUP BY Archive.Slip.SourceId '




 ----------------------------------------------------------------------------------------------------------------------------------------------

 
 set @sqlcommand9 +=' insert @TempSummaryBet (ParentBranch,BranchName ,SlipAmount,WonSlipPayOut,CancelSlipAmount,PayOutAmount,Turnover,PartnerTurnOver,OpenSlipAmount,TaxAmount,BranchTaxAmount,SourceId,Cashout)
  SELECT ''Total''
  ,''''
  ,SUM(SlipAmount) AS TurnOver
 ,ISNULL(sum(WonSlipPayOut),0) as CustomerWining
 ,ISNULL(SUM(CancelSlipAmount),0) as CancelBet
 ,ISNULL(SUM(PayOutAmount),0) 
  ,ISNULL(SUM(SlipAmount),0)-ISNULL(sum(WonSlipPayOut),0)-ISNULL(sum(Cashout),0)-ISNULL(SUM(CancelSlipAmount),0) as Profit
  ,0 as PartnerProfit
  
 ,ISNULL(SUM(OpenSlipAmount),0) as Unsettled
 ,ISNULL(SUM(TaxAmount),0) as Tax
 ,0 as BranchTaxAmount
 ,SourceId
 ,ISNULL(SUM(Cashout),0)
   FROM @TempSummaryBet GROUP BY SourceId    HAVING SUM(SlipAmount) is not null '




	set @sqlcommand9+=' declare @TempSummaryBet3 table (ParentBranch nvarchar(50),SlipCount int,SlipAmount money,OpenSlipCount int,OpenSlipAmount money,OpenSlipPayOut money,WonSlipCount int,WonSlipAmount money,WonSlipPayOut money,LostSlipCount int,LostSlipAmount money,CancelSlipCount int,CancelSlipAmount money,TurnOver money,PartnerTurnOver money,BranchName nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS,TaxCount int,TaxAmount money,BranchTaxAmount money,PayOutCount int,PayOutAmount money,Cashout money) '+
  ' insert @TempSummaryBet3 '+
  '   SELECT tp2.ParentBranch,SUM(ISNULL(SlipCount,0))
,SUM(ISNULL(SlipAmount,0)),SUM(ISNULL(OpenSlipCount,0)),SUM(ISNULL(OpenSlipAmount,0)),SUM(ISNULL(OpenSlipPayOut,0)),SUM(ISNULL(WonSlipCount,0)) ,SUM(ISNULL(WonSlipAmount,0))
,SUM(ISNULL(WonSlipPayOut,0)),SUM(ISNULL(LostSlipCount,0)),SUM(ISNULL(LostSlipAmount,0)),SUM(ISNULL(CancelSlipCount,0)),SUM(ISNULL(CancelSlipAmount,0)),SUM(ISNULL(SlipAmount,0))-(SUM(ISNULL(WonSlipPayOut,0))+SUM(ISNULL(Cashout,0))+ISNULL(SUM(CancelSlipAmount),0)) as TurnOver
,( select SUM(TurnOver) from @TempSummaryBet as ttp where ttp.ParentBranch=tp2.BranchName COLLATE SQL_Latin1_General_CP1_CI_AS)
,tp2.BranchName,SUM(ISNULL(TaxCount,0)),SUM(ISNULL(TaxAmount,0)),SUM(ISNULL(BranchTaxAmount,0)),SUM(ISNULL(PayOutCount,0)),SUM(ISNULL(PayOutAmount,0)),SUM(ISNULL(Cashout,0))
     FROM @TempSummaryBet as tp2 where 1=1  '+@where3 +
	' GROUP BY BranchName,ParentBranch  HAVING SUM(SlipAmount) is not null'


	
  set @sqlcommand=' select ''Branch ''+ '''+cast(@BranchId as NVARCHAR(20))+'''+'' Today Total Profit :''+  cast(ISNULL(TurnOver,0)+(ISNULL(PartnerTurnOver,0)) as nvarchar(100)) +'+''''+@Currency+''''+
' FROM         @TempSummaryBet3 as tmp LEFT OUTER JOIN Parameter.Branch On tmp.BranchName=Parameter.Branch.BrancName
WHERE  tmp.BranchName='+''''+@BranchName+''''

 
 exec (@sqlcommand2+@sqlcommand22+@sqlcommand221+@sqlcommand222+@sqlcommand2222+@sqlcommand22222+@sqlcommand2T+@sqlcommand22T+@sqlcommand221T+@sqlcommand222T+@sqlcommand0222T+@sqlcommand2222T+@sqlcommand22222T+@sqlcommand9+@sqlcommand)

 






END



GO
