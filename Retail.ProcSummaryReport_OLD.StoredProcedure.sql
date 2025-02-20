USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcSummaryReport_OLD]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Retail].[ProcSummaryReport_OLD] 
 @PageSize  INT,
 @PageNum int,
@Username nvarchar(50),
@where nvarchar(1000),
@orderby nvarchar(100),
@StartDate nvarchar(20),
@EndDate nvarchar(20),
@BranchId int
AS
 

exec Report.ProcSummarySportBettingFill1
--exec Report.ProcSummaryCasinoBettingFill1
--exec Report.ProcSummaryVirtualBettingFill1

declare @sqlcommand nvarchar(max)=''
declare @sqlcommand0 nvarchar(max)=''
declare @sqlcommand1 nvarchar(max)=''
declare @sqlcommand2 nvarchar(max)=''
declare @sqlcommand11 nvarchar(max)=''
declare @sqlcommand3 nvarchar(max)=''
declare @sqlcommand33 nvarchar(max)=''

 


declare @UserCurrencyId int
--declare @BranchId int
declare @where2 nvarchar(max)=' 1=1'
declare @SystemCurrencyId int
select top 1 @SystemCurrencyId=SystemCurrencyId from General.Setting 
select  @UserCurrencyId=Users.Users.CurrencyId from Users.Users where Users.Users.UserName=@Username
declare @where3 nvarchar(max)=' Customer.Customer.BranchId in (select BranchId from Parameter.Branch with (nolock) where (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId in (select BranchId from Parameter.Branch with (nolock)  where (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ') ))) '

set @UserCurrencyId=3
if(@BranchId<>1)
	begin

	set @where2=' Customer.Customer.BranchId in (select BranchId from Parameter.Branch with (nolock) where (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId in (select BranchId from Parameter.Branch with (nolock)  where (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ') ))) and ReportDate >= '''+cast(@StartDate as nvarchar(20))+''' and ReportDate <= '''+cast(@EndDate as nvarchar(20))+''' '

	end


	declare @Report datetime
	

	set @sqlcommand=' declare @TempSummaryBet table (CustomerId bigint,UserName nvarchar(50),CustomerName nvarchar(50),CustomerSurname nvarchar(50),BranchName nvarchar(50),Balance money,Bonus money,STurnOver money,SWon money,STax money,SProfit money,CTurnOver money,CWon money,CProfit money,LTurnOver money,LWon money,LProfit money,IsActive bit,Picture1 nvarchar(250),Picture2 nvarchar(250),Picture3 nvarchar(250)) '+
  'insert @TempSummaryBet '+
  'SELECT Customer.Customer.CustomerId
  ,Customer.Customer.UserName
  ,Customer.Customer.CustomerName
  ,Customer.Customer.CustomerSurname
  ,Parameter.Branch.[BrancName]
  ,0
  ,SUM(ISNULL([Report].[SummarySportBetting].BonusAmount,0))
  ,SUM(ISNULL([Report].[SummarySportBetting].SlipAmount,0)) as TurnOver
  ,SUM(ISNULL([Report].[SummarySportBetting].WonSlipAll,0)) as Won
,SUM(ISNULL([Report].[SummarySportBetting].Tax,0)) as Tax
  ,SUM(ISNULL([Report].[SummarySportBetting].SlipAmount,0))-SUM(ISNULL([Report].[SummarySportBetting].WonSlipAll,0)) as Profit 
  ,0
  ,0
  ,0
  ,0
  ,0
  ,0
  ,case when Customer.Customer.IsActive=1 then case when  Customer.IsLockedOut=0 then Customer.Customer.IsActive else 0 end else Customer.Customer.IsActive end 
 ,(Select top 1  Customer.[Document].DocumentFile from   Customer.[Document] with (nolock) where   Customer.[Document].CustomerId=Customer.Customer.CustomerId and  Customer.[Document].DocumentTypeId=4 order by CreateDate)
  ,(Select top 1  Customer.[Document].DocumentFile from   Customer.[Document] with (nolock) where   Customer.[Document].CustomerId=Customer.Customer.CustomerId and  Customer.[Document].DocumentTypeId=1 order by CreateDate desc)
  ,'''' '

 set @sqlcommand0=' FROM [Report].[SummarySportBetting] with (nolock) INNER JOIN 
  Customer.Customer with (nolock) ON Customer.Customer.CustomerId=[Report].[SummarySportBetting].CustomerId INNER JOIN
  [Parameter].[Branch] with (nolock) ON  [Parameter].[Branch].[BranchId]=Customer.Customer.BranchId 
  Where Customer.Customer.IsBranchCustomer<>1 and  '+@where2 + ' 
  GROUP BY Parameter.Branch.[BrancName],Customer.Customer.CustomerId,Customer.Customer.UserName,Customer.Customer.CustomerName,Customer.Customer.CustomerSurname,Customer.Customer.IsActive, Customer.IsLockedOut,Customer.Customer.Balance; '
  


-- set @sqlcommand=' declare @TempSummaryBet table (CustomerId bigint,UserName nvarchar(50),CustomerName nvarchar(50),CustomerSurname nvarchar(50),BranchName nvarchar(50),Balance money,Bonus money,STurnOver money,SWon money,STax money,SProfit money,CTurnOver money,CWon money,CProfit money,LTurnOver money,LWon money,LProfit money,IsActive bit,Picture1 nvarchar(250),Picture2 nvarchar(250),Picture3 nvarchar(250)) '+
--  'insert @TempSummaryBet '+
--  'SELECT Customer.Customer.CustomerId
--  ,Customer.Customer.UserName
--  ,Customer.Customer.CustomerName
--  ,Customer.Customer.CustomerSurname
--  ,Parameter.Branch.[BrancName]
--  ,0
--  ,ISNULL((select SUM(Customer.[Transaction].Amount)
--from Customer.[Transaction]  with (nolock)
--where Customer.[Transaction].CustomerId=Customer.Customer.CustomerId 
--and Customer.[Transaction].TransactionTypeId in (35) and TransactionDate>= '''+cast(DATEADD(DAY,1,@StartDate) as nvarchar(20))+''' and TransactionDate<='''+cast(DATEADD(DAY,2,@EndDate) as nvarchar(20))+''' ),0) as Bonus
--  ,ISNULL((select SUM(Customer.[Transaction].Amount)
--from Customer.[Transaction]  with (nolock)
--where Customer.[Transaction].CustomerId=Customer.Customer.CustomerId 
--and Customer.[Transaction].TransactionTypeId in (4) and DATEADD(HOUR,2,TransactionDate)>= '''+cast(@StartDate as nvarchar(20))+''' and DATEADD(HOUR,2,TransactionDate)<'''+cast(DATEADD(DAY,1,@EndDate) as nvarchar(20))+''' ),0) as TurnOver
--  ,ISNULL((select SUM(Customer.[Transaction].Amount)
--from Customer.[Transaction]  with (nolock)
--where Customer.[Transaction].CustomerId=Customer.Customer.CustomerId  
--and Customer.[Transaction].TransactionTypeId in (3,63) and DATEADD(HOUR,2,TransactionDate)>= '''+cast(@StartDate as nvarchar(20))+''' and DATEADD(HOUR,2,TransactionDate)<'''+cast(DATEADD(DAY,1,@EndDate) as nvarchar(20))+''' ),0) as Won
--,ISNULL((select SUM(Customer.[Transaction].Amount)
--from Customer.[Transaction]  with (nolock)
--where Customer.[Transaction].CustomerId=Customer.Customer.CustomerId  
--and Customer.[Transaction].TransactionTypeId in (53) and DATEADD(HOUR,2,TransactionDate)>= '''+cast(@StartDate as nvarchar(20))+''' and DATEADD(HOUR,2,TransactionDate)<'''+cast(DATEADD(DAY,1,@EndDate) as nvarchar(20))+''' ),0) as Tax
--  ,ISNULL((select SUM(Customer.[Transaction].Amount)
--from Customer.[Transaction]  with (nolock)
--where Customer.[Transaction].CustomerId=Customer.Customer.CustomerId 
--and Customer.[Transaction].TransactionTypeId in (4) and DATEADD(HOUR,2,TransactionDate)>= '''+cast(@StartDate as nvarchar(20))+''' and DATEADD(HOUR,2,TransactionDate)<'''+cast(DATEADD(DAY,1,@EndDate) as nvarchar(20))+''' ),0)-(ISNULL((select SUM(Customer.[Transaction].Amount)
--from Customer.[Transaction]  with (nolock)
--where Customer.[Transaction].CustomerId=Customer.Customer.CustomerId  
--and Customer.[Transaction].TransactionTypeId in (3,63) and DATEADD(HOUR,2,TransactionDate)>= '''+cast(@StartDate as nvarchar(20))+''' and DATEADD(HOUR,2,TransactionDate)<'''+cast(DATEADD(DAY,1,@EndDate) as nvarchar(20))+''' ),0)+ISNULL((select SUM(Customer.[Transaction].Amount)
--from Customer.[Transaction]  with (nolock)
--where Customer.[Transaction].CustomerId=Customer.Customer.CustomerId 
--and Customer.[Transaction].TransactionTypeId in (35) and TransactionDate>= '''+cast(DATEADD(DAY,1,@StartDate) as nvarchar(20))+''' and TransactionDate<='''+cast(DATEADD(DAY,2,@EndDate) as nvarchar(20))+''' ),0)) as Profit 
--  ,0
--  ,0
--  ,0
--  ,0
--  ,0
--  ,0
--  ,case when Customer.Customer.IsActive=1 then case when  Customer.IsLockedOut=0 then Customer.Customer.IsActive else 0 end else Customer.Customer.IsActive end 
--  ,(Select top 1  Customer.[Document].DocumentFile from   Customer.[Document] with (nolock) where   Customer.[Document].CustomerId=Customer.Customer.CustomerId and  Customer.[Document].DocumentTypeId=4 order by CreateDate)
--  ,(Select top 1  Customer.[Document].DocumentFile from   Customer.[Document] with (nolock) where   Customer.[Document].CustomerId=Customer.Customer.CustomerId and  Customer.[Document].DocumentTypeId=1 order by CreateDate desc)
--  ,(Select top 1  Customer.[Document].DocumentFile from   Customer.[Document] with (nolock) where   Customer.[Document].CustomerId=Customer.Customer.CustomerId and  Customer.[Document].DocumentTypeId=4 order by CreateDate desc) '

-- set @sqlcommand0=' FROM [Report].[SummarySportBetting] with (nolock) INNER JOIN 
--  Customer.Customer with (nolock) ON Customer.Customer.CustomerId=[Report].[SummarySportBetting].CustomerId INNER JOIN
--  [Parameter].[Branch] with (nolock) ON  [Parameter].[Branch].[BranchId]=Customer.Customer.BranchId 
--  Where Customer.Customer.IsBranchCustomer<>1 and  '+@where2 + ' 
--  GROUP BY Parameter.Branch.[BrancName],Customer.Customer.CustomerId,Customer.Customer.UserName,Customer.Customer.CustomerName,Customer.Customer.CustomerSurname,Customer.Customer.IsActive, Customer.IsLockedOut,Customer.Customer.Balance; '
  

 

 -- set @sqlcommand1=  ' insert @TempSummaryBet '+
 -- 'SELECT Customer.Customer.CustomerId
 -- ,Customer.Customer.UserName
 -- ,Customer.Customer.CustomerName
 -- ,Customer.Customer.CustomerSurname
 -- ,Parameter.Branch.[BrancName]
 -- ,0
 --  ,0
 --  ,0
 -- ,0
 -- ,0
 -- ,0
	--,SUM(SlipAmount) 
	--,Sum(WonSlipAmount)  
	--,SUM(SlipAmount-WonSlipAmount)  
 -- ,0
 -- ,0
 -- ,0
 -- ,case when Customer.Customer.IsActive=1 then case when  Customer.IsLockedOut=0 then Customer.Customer.IsActive else 0 end else Customer.Customer.IsActive end 
 -- ,(Select top 1  Customer.[Document].DocumentFile from   Customer.[Document] with (nolock) where   Customer.[Document].CustomerId=Customer.Customer.CustomerId and  Customer.[Document].DocumentTypeId=4 order by CreateDate)
 -- ,(Select top 1  Customer.[Document].DocumentFile from   Customer.[Document] with (nolock) where   Customer.[Document].CustomerId=Customer.Customer.CustomerId and  Customer.[Document].DocumentTypeId=1 order by CreateDate desc)
 -- ,(Select top 1  Customer.[Document].DocumentFile from   Customer.[Document] with (nolock) where   Customer.[Document].CustomerId=Customer.Customer.CustomerId and  Customer.[Document].DocumentTypeId=4 order by CreateDate desc)
 -- FROM Report.SummaryCasinoBetting with (nolock) INNER JOIN 
 -- Customer.Customer with (nolock) ON Customer.Customer.CustomerId=[Report].[SummaryCasinoBetting].CustomerId INNER JOIN
 -- [Parameter].[Branch] with (nolock) ON  [Parameter].[Branch].[BranchId]=Customer.Customer.BranchId 
 -- Where Customer.Customer.IsBranchCustomer<>1 and  '+@where2 + ' 
 -- GROUP BY Parameter.Branch.[BrancName],Customer.Customer.CustomerId,Customer.Customer.UserName,Customer.Customer.CustomerName,Customer.Customer.CustomerSurname,Customer.Customer.IsActive,Customer.IsLockedOut,Customer.Customer.Balance; '

 

 --   set @sqlcommand11=  ' insert @TempSummaryBet '+
 -- 'SELECT Customer.Customer.CustomerId
 -- ,Customer.Customer.UserName
 -- ,Customer.Customer.CustomerName
 -- ,Customer.Customer.CustomerSurname
 -- ,Parameter.Branch.[BrancName]
 -- ,0
 --  ,0
 --  ,0
 --  ,0
 -- ,0
 -- ,0
 -- ,0
 -- ,0
 -- ,0
 -- ,SUM(SlipAmount) 
	--,Sum(WonSlipAmount)  
	--,SUM(SlipAmount-WonSlipAmount) 
 -- ,case when Customer.Customer.IsActive=1 then case when  Customer.IsLockedOut=0 then Customer.Customer.IsActive else 0 end else Customer.Customer.IsActive end 
 -- ,(Select top 1  Customer.[Document].DocumentFile from   Customer.[Document] with (nolock) where   Customer.[Document].CustomerId=Customer.Customer.CustomerId and  Customer.[Document].DocumentTypeId=4 order by CreateDate)
 -- ,(Select top 1  Customer.[Document].DocumentFile from   Customer.[Document] with (nolock) where   Customer.[Document].CustomerId=Customer.Customer.CustomerId and  Customer.[Document].DocumentTypeId=1 order by CreateDate desc)
 -- ,(Select top 1  Customer.[Document].DocumentFile from   Customer.[Document] with (nolock) where   Customer.[Document].CustomerId=Customer.Customer.CustomerId and  Customer.[Document].DocumentTypeId=4 order by CreateDate desc)
 -- FROM Report.SummaryVirtualBetting with (nolock) INNER JOIN 
 -- Customer.Customer with (nolock) ON Customer.Customer.CustomerId=[Report].[SummaryVirtualBetting].CustomerId INNER JOIN
 -- [Parameter].[Branch] with (nolock) ON  [Parameter].[Branch].[BranchId]=Customer.Customer.BranchId 
 -- Where Customer.Customer.IsBranchCustomer<>1 and  '+@where2 + ' 
 -- GROUP BY Parameter.Branch.[BrancName],Customer.Customer.CustomerId,Customer.Customer.UserName,Customer.Customer.CustomerName,Customer.Customer.CustomerSurname,Customer.Customer.IsActive,Customer.IsLockedOut,Customer.Customer.Balance; '
  
   
     set @sqlcommand11+=  ' insert @TempSummaryBet '+
  'SELECT Customer.Customer.CustomerId
  ,Customer.Customer.UserName
  ,Customer.Customer.CustomerName
  ,Customer.Customer.CustomerSurname
  ,Parameter.Branch.[BrancName]
  ,Customer.Customer.Balance
   ,0
  ,0
  ,0
  ,0
  ,0
  ,0
  ,0
  ,0
  ,0 
	,0 
	,0
  ,case when Customer.Customer.IsActive=1 then case when  Customer.IsLockedOut=0 then Customer.Customer.IsActive else 0 end else Customer.Customer.IsActive end 
 ,(Select top 1  Customer.[Document].DocumentFile from   Customer.[Document] with (nolock) where   Customer.[Document].CustomerId=Customer.Customer.CustomerId and  Customer.[Document].DocumentTypeId=4 order by CreateDate)
  ,(Select top 1  Customer.[Document].DocumentFile from   Customer.[Document] with (nolock) where   Customer.[Document].CustomerId=Customer.Customer.CustomerId and  Customer.[Document].DocumentTypeId=1 order by CreateDate desc)
  ,''''
   FROM   Customer.Customer with (nolock) INNER JOIN
  [Parameter].[Branch] with (nolock) ON  [Parameter].[Branch].[BranchId]=Customer.Customer.BranchId 
  Where Customer.Customer.IsBranchCustomer<>1 and  '+@where3 + ' 
  GROUP BY Parameter.Branch.[BrancName],Customer.Customer.CustomerId,Customer.Customer.UserName,Customer.Customer.CustomerName,Customer.Customer.CustomerSurname,Customer.Customer.IsActive,Customer.IsLockedOut,Customer.Customer.Balance; '
  
 

  set @sqlcommand2=' declare @TempSummaryBet2 table (CustomerId bigint,UserName nvarchar(50),CustomerName nvarchar(50),CustomerSurname nvarchar(50),BranchName nvarchar(50),Balance money,Bonus money,STurnOver money,SWon money,STax money,SProfit money,CTurnOver money,CWon money,CProfit money,LTurnOver money,LWon money,LProfit money,IsActive bit,Picture1 nvarchar(250),Picture2 nvarchar(250),Picture3 nvarchar(250)) '+
  ' insert @TempSummaryBet2 '+
  ' select	CustomerId
  ,UserName
  ,CustomerName
  ,CustomerSurname
  ,BranchName
       ,ISNULL(SUM(ISNULL(Balance,0)),0) as Balance
	   ,ISNULL(SUM(ISNULL(Bonus,0)),0) as Bonus
      ,ISNULL(SUM(STurnOver),0)  as STurnOver
      ,ISNULL(SUM(SWon),0)  as SWon
	  ,ISNULL(SUM(STax),0)  as STax
      ,ISNULL(SUM(SProfit),0) as SProfit
      ,ISNULL(SUM(CTurnOver),0)  as CTurnOver
      ,ISNULL(SUM(CWon),0)  as CWon
	  ,ISNULL(SUM(CProfit),0)  as CProfit
	  ,ISNULL(SUM(LTurnOver),0)  as LTurnOver
	  ,ISNULL(SUM(LWon),0)  as LWon
	  ,ISNULL(SUM(LProfit),0)  as LProfit 
	  , IsActive,Picture1,Picture2 ,Picture3'+
' FROM        @TempSummaryBet GROUP BY CustomerId ,UserName  ,CustomerName  ,CustomerSurname  ,BranchName,IsActive,Picture1,Picture2 ,Picture3 '


set @sqlcommand33=' '
--' insert @TempSummaryBet2 '+
--' select CustomerId
--  ,UserName
--  ,CustomerName
--  ,CustomerSurname
--  ,Parameter.Branch.BrancName,ISNULL(dbo.FuncCurrencyConverter(Customer.Customer.Balance,Customer.Customer.CurrencyId,'+cast(@SystemCurrencyId as nvarchar(3))+'),0),0,0,0,0,0,0,0,0,0  ,case when Customer.Customer.IsActive=1 then case when  Customer.IsLockedOut=0 then Customer.Customer.IsActive else 0 end else Customer.Customer.IsActive end  from Customer.Customer INNER JOIN Parameter.Branch ON Customer.Customer.BranchId=Parameter.Branch.BranchId 
--where Customer.Customer.IsBranchCustomer<>1 and Customer.Customer.BranchId='+cast(@BranchId as nvarchar(7)) +' and CustomerId not in (select CustomerId from @TempSummaryBet2) '


  set @sqlcommand3='declare @total int '+
'select @total=COUNT(DISTINCT CustomerId)  '+
'FROM       @TempSummaryBet2 as tmp
WHERE 1=1 and '+ @where +' ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
'		CustomerId
  ,UserName
  ,CustomerName
  ,CustomerSurname
  ,BranchName
       ,ISNULL(Balance,0) as Balance
	   ,ISNULL(Bonus,0) as Bonus
      ,ISNULL(STurnOver,0)  as STurnOver
      ,ISNULL(SWon,0)  as SWon
	  ,ISNULL(STax,0)  as STax
      ,ISNULL(SProfit,0) as SProfit
      ,ISNULL(CTurnOver,0)  as CTurnOver
      ,ISNULL(CWon,0)  as CWon
	  ,ISNULL(CProfit,0)  as CProfit
	  ,ISNULL(LTurnOver,0)  as LTurnOver
	  ,ISNULL(LWon,0)  as LWon
	  ,ISNULL(LProfit,0)  as LProfit 
	  ,IsActive,Picture1 as Picture1,Picture2 as Picture2 ,'''' as Picture3 '+
' FROM        @TempSummaryBet2 as tmp  where '+ @where +
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '
    
 
exec (@sqlcommand+@sqlcommand0+@sqlcommand1+@sqlcommand11+@sqlcommand2+@sqlcommand33+@sqlcommand3)



--  declare @TempSummaryBet2 table (CustomerId bigint,UserName nvarchar(50),CustomerName nvarchar(50),CustomerSurname nvarchar(50),BranchName nvarchar(50),Balance money,STurnOver money,SWon money,SProfit money,CTurnOver money,CWon money,CProfit money,LTurnOver money,LWon money,LProfit money,IsActive bit)
  
--declare @total int 
--select @total=COUNT(DISTINCT CustomerId)  
--FROM       @TempSummaryBet2 as tmp
--WHERE 1=1 ; 
--WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY @orderby) AS RowNum, 
--		CustomerId
--  ,UserName
--  ,CustomerName
--  ,CustomerSurname
--  ,BranchName
--       ,ISNULL(dbo.FuncCurrencyConverter(Balance,@SystemCurrencyId,@UserCurrencyId),0) as Balance
--      ,ISNULL(dbo.FuncCurrencyConverter(Balance,@SystemCurrencyId,@UserCurrencyId),0)  as STurnOver
--      ,ISNULL(dbo.FuncCurrencyConverter(Balance,@SystemCurrencyId,@UserCurrencyId),0)  as SWon
--      ,ISNULL(dbo.FuncCurrencyConverter(Balance,@SystemCurrencyId,@UserCurrencyId),0) as SProfit
--      ,ISNULL(dbo.FuncCurrencyConverter(Balance,@SystemCurrencyId,@UserCurrencyId),0)  as CTurnOver
--      ,ISNULL(dbo.FuncCurrencyConverter(Balance,@SystemCurrencyId,@UserCurrencyId),0)  as CWon
--	  ,ISNULL(dbo.FuncCurrencyConverter(Balance,@SystemCurrencyId,@UserCurrencyId),0)  as CProfit
--	  ,ISNULL(dbo.FuncCurrencyConverter(Balance,@SystemCurrencyId,@UserCurrencyId),0)  as LTurnOver
--	  ,ISNULL(dbo.FuncCurrencyConverter(Balance,@SystemCurrencyId,@UserCurrencyId),0)  as LWon
--	  ,ISNULL(dbo.FuncCurrencyConverter(Balance,@SystemCurrencyId,@UserCurrencyId),0)  as LProfit 
--,IsActive
--FROM        @TempSummaryBet2 as tmp 
-- ) 
--SELECT *,@total as totalrow 
--  FROM OrdersRN 
-- WHERE RowNum BETWEEN (@PageNum-1 )*(@PageSize )+1 AND (@PageNum * @PageSize )






GO
