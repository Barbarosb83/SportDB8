USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcSummarySportBetting_BettingReport]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcSummarySportBetting_BettingReport] 
 @PageSize  INT,
 @PageNum int,
@Username nvarchar(50),
@where nvarchar(1000),
@orderby nvarchar(100)
AS

BEGIN
SET NOCOUNT ON;

exec Report.ProcSummarySportBettingFill1
declare @sqlcommand nvarchar(max)
declare @sqlcommand2 nvarchar(max)

declare @total int =0


declare @UserCurrencyId int
declare @BranchId int
declare @where2 nvarchar(max)=' 1=1'
declare @SystemCurrencyId int
select top 1 @SystemCurrencyId=SystemCurrencyId from General.Setting 
select @BranchId=Users.Users.UnitCode, @UserCurrencyId=Users.Users.CurrencyId from Users.Users where Users.Users.UserName=@Username



if(@orderby='ReportId desc')
	set @orderby=REPLACE(@orderby,'ReportId','ReportDate')
else if(@orderby='SlipId asc')
	set @orderby=REPLACE(@orderby,'ReportId','ReportDate')


if(@BranchId<>1)
	begin

	set @where2=' Customer.Customer.BranchId in (select BranchId from [BettingReport].Parameter.Branch where IsTerminal=0 and (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId in (select BranchId from [BettingReport].Parameter.Branch  where (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ') )))'

	end


	declare @Report datetime
 set @sqlcommand2=' declare @TempSummaryBet table (ReportId nvarchar(50),ReportDate Datetime,SlipCount int,SlipAmount money,OpenSlipCount int,OpenSlipAmount money,OpenSlipPayOut money,WonSlipCount int,WonSlipAmount money,WonSlipPayOut money,LostSlipCount int,LostSlipAmount money,CancelSlipCount int,CancelSlipAmount money,TurnOver money,BranchName nvarchar(100)) '+
  'insert @TempSummaryBet '+
  'SELECT cast(NEWID() as nvarchar(50))
  ,ReportDate
      ,ISNULL(SUM([SlipCount]),0)  as [SlipCount]
      ,ISNULL(SUM([SlipAmount]),0)  as [SlipAmount]
      ,ISNULL(SUM([OpenSlipCount]),0)  as [OpenSlipCount]
      ,ISNULL(SUM([OpenSlipAmount]),0)  as [OpenSlipAmount]
      ,ISNULL(SUM([OpenSlipPayOut]),0)  as [OpenSlipPayOut]
      ,ISNULL(SUM([WonSlipCount]),0)  as [WonSlipCount]
      ,ISNULL(SUM([WonSlipAmount]),0)  as [WonSlipAmount]
      ,ISNULL(SUM([WonSlipPayOut]),0)  as [WonSlipPayOut]
      ,ISNULL(SUM([LostSlipCount]),0)  as [LostSlipCount]
      ,ISNULL(SUM([LostSlipAmount]),0)  as [LostSlipAmount]
      ,ISNULL(SUM([CancelSlipCount]),0)  as [CancelSlipCount]
      ,ISNULL(SUM([CancelSlipAmount]),0)  as [CancelSlipAmount]
      ,ISNULL(SUM([SlipAmount]),0)-(ISNULL(SUM([WonSlipPayOut]),0)-ISNULL(SUM([CancelSlipAmount]),0)) as TurnOver
	  ,[BettingReport].Parameter.Branch.[BrancName]
  FROM [BettingReport].[Report].[SummarySportBetting] INNER JOIN 
  Customer.Customer ON Customer.Customer.CustomerId=[BettingReport].[Report].[SummarySportBetting].CustomerId INNER JOIN
  [BettingReport].[Parameter].[Branch] ON  [BettingReport].[Parameter].[Branch].[BranchId]=Customer.Customer.BranchId 
  Where  '+@where2 + ' 
  GROUP BY [BettingReport].Parameter.Branch.[BrancName]; '
  
  
  
  set @sqlcommand='declare @total int '+
'select @total=COUNT(ReportId)  '+
'FROM       @TempSummaryBet as tmp INNER JOIN [Parameter].[Branch] ON [Parameter].[Branch].[BrancName]=tmp.BranchName
WHERE    '+@where +' ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
'		ReportId
      ,ISNULL([SlipCount],0)  as [SlipCount]
       ,ISNULL(dbo.FuncCurrencyConverter(SlipAmount,'+cast(@SystemCurrencyId as nvarchar(3))+','+cast(@UserCurrencyId as nvarchar(3))+'),0) as [SlipAmount]
      ,ISNULL([OpenSlipCount],0)  as [OpenSlipCount]
      ,ISNULL(dbo.FuncCurrencyConverter([OpenSlipAmount],'+cast(@SystemCurrencyId as nvarchar(3))+','+cast(@UserCurrencyId as nvarchar(3))+'),0)  as [OpenSlipAmount]
      ,ISNULL(dbo.FuncCurrencyConverter([OpenSlipPayOut],'+cast(@SystemCurrencyId as nvarchar(3))+','+cast(@UserCurrencyId as nvarchar(3))+'),0)  as [OpenSlipPayOut]
      ,ISNULL([WonSlipCount],0)  as [WonSlipCount]
      ,ISNULL(dbo.FuncCurrencyConverter([WonSlipAmount],'+cast(@SystemCurrencyId as nvarchar(3))+','+cast(@UserCurrencyId as nvarchar(3))+'),0) as [WonSlipAmount]
      ,ISNULL(dbo.FuncCurrencyConverter([WonSlipPayOut],'+cast(@SystemCurrencyId as nvarchar(3))+','+cast(@UserCurrencyId as nvarchar(3))+'),0)  as [WonSlipPayOut]
      ,ISNULL([LostSlipCount],0)  as [LostSlipCount]
      ,ISNULL(dbo.FuncCurrencyConverter([LostSlipAmount],'+cast(@SystemCurrencyId as nvarchar(3))+','+cast(@UserCurrencyId as nvarchar(3))+'),0)  as [LostSlipAmount]
      ,ISNULL([CancelSlipCount],0)  as [CancelSlipCount]
      ,ISNULL(dbo.FuncCurrencyConverter([CancelSlipAmount],'+cast(@SystemCurrencyId as nvarchar(3))+','+cast(@UserCurrencyId as nvarchar(3))+'),0) as [CancelSlipAmount]
      ,ISNULL(dbo.FuncCurrencyConverter(TurnOver,'+cast(@SystemCurrencyId as nvarchar(3))+','+cast(@UserCurrencyId as nvarchar(3))+'),0) as TurnOver
	  ,BranchName '+
'FROM        @TempSummaryBet as tmp INNER JOIN [BettingReport].[Parameter].[Branch] ON [BettingReport].Parameter.Branch.[BrancName]=tmp.BranchName
WHERE     '+@where +' '+
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '

  
  
  

execute (@sqlcommand2+@sqlcommand)
END



GO
