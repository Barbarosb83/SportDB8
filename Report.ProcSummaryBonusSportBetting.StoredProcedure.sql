USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Report].[ProcSummaryBonusSportBetting]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Report].[ProcSummaryBonusSportBetting] 
 @ViewType int, --0 günlük,1 aylık , 2 yıllık
 @PageSize  INT,
 @PageNum int,
@Username nvarchar(50),
@where nvarchar(1000),
@orderby nvarchar(100)
AS

BEGIN
SET NOCOUNT ON;

exec Report.ProcSummaryBonusSportBettingFill1
declare @sqlcommand nvarchar(max)
declare @sqlcommand2 nvarchar(max)

declare @total int =0


declare @UserCurrencyId int
declare @BranchId int
declare @where2 nvarchar(max)=' 1=1'
declare @SystemCurrencyId int
declare @RoleId int
declare @Multip float=0
declare @MultipDate nvarchar(20) 
select top 1 @SystemCurrencyId=SystemCurrencyId from General.Setting 
select top 1  @RoleId=Users.UserRoles.RoleId,@BranchId=Users.Users.UnitCode, @UserCurrencyId=Users.Users.CurrencyId ,@Multip=Multiplier,@MultipDate=MultipDate from Users.Users INNER JOIN Users.UserRoles ON Users.UserRoles.UserId=Users.Users.UserId 
where Users.Users.UserName=@Username



if(@orderby='ReportId desc')
	set @orderby=REPLACE(@orderby,'ReportId','ReportDate')
else if(@orderby='SlipId asc')
	set @orderby=REPLACE(@orderby,'ReportId','ReportDate')


if(@BranchId<>1)
	begin

	set @where2=' Customer.Customer.BranchId='+cast(@BranchId as nvarchar(7))

	end


if(@RoleId<>156)
begin
if(@ViewType=0)
begin

 
 set @sqlcommand2=' declare @TempSummaryBet table (ReportId nvarchar(50),ReportDate nvarchar(10),SlipCount int,SlipAmount money,OpenSlipCount int,OpenSlipAmount money,OpenSlipPayOut money,WonSlipCount int,WonSlipAmount money,WonSlipPayOut money,LostSlipCount int,LostSlipAmount money,CancelSlipCount int,CancelSlipAmount money,TurnOver money,BranchName nvarchar(100)  COLLATE SQL_Latin1_General_CP1_CI_AS) '+
  'insert @TempSummaryBet '+
  'SELECT cast(NEWID() as nvarchar(50))
      ,cast(ReportDate as nvarchar(10)) as ReportDate 
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
      ,ISNULL(SUM([SlipAmount]),0)-(ISNULL(SUM([WonSlipPayOut]),0)+ISNULL(SUM([CancelSlipAmount]),0)) as TurnOver
	  ,Parameter.Branch.[BrancName]
  FROM [Report].[SummaryBonusSportBetting] INNER JOIN 
  Customer.Customer ON Customer.Customer.CustomerId=[Report].[SummaryBonusSportBetting].CustomerId INNER JOIN
  [Parameter].[Branch] ON  [Parameter].[Branch].[BranchId]=Customer.Customer.BranchId 
  Where  '+@where2 + ' 
  GROUP BY Parameter.Branch.[BrancName],cast(ReportDate as nvarchar(10)); '
  
  
  
  set @sqlcommand='declare @total int '+
'select @total=COUNT(ReportDate)  '+
'FROM       @TempSummaryBet as tmp INNER JOIN [Parameter].[Branch] ON [Parameter].[Branch].[BrancName]=tmp.BranchName
WHERE    '+@where +' ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
'		ReportId
	  ,ReportDate as ReportDate
      ,ISNULL([SlipCount],0)  as [SlipCount]
       ,ISNULL(dbo.FuncCurrencyConverter(SlipAmount,'+cast(@SystemCurrencyId as nvarchar(2))+','+cast(@UserCurrencyId as nvarchar(2))+'),0)* case when cast(ReportDate as date )>='''+@MultipDate+''' and SlipAmount>0 then '+cast(@Multip as nvarchar(4))+' else 1 end as [SlipAmount]
      ,ISNULL([OpenSlipCount],0)  as [OpenSlipCount]
      ,ISNULL(dbo.FuncCurrencyConverter([OpenSlipAmount],'+cast(@SystemCurrencyId as nvarchar(2))+','+cast(@UserCurrencyId as nvarchar(2))+'),0)* case when cast(ReportDate as date )>='''+@MultipDate+''' and OpenSlipAmount>0 then '+cast(@Multip as nvarchar(4))+' else 1 end  as [OpenSlipAmount]
      ,ISNULL(dbo.FuncCurrencyConverter([OpenSlipPayOut],'+cast(@SystemCurrencyId as nvarchar(2))+','+cast(@UserCurrencyId as nvarchar(2))+'),0)* case when cast(ReportDate as date )>='''+@MultipDate+''' and OpenSlipPayOut>0 then '+cast(@Multip as nvarchar(4))+' else 1 end  as [OpenSlipPayOut]
      ,ISNULL([WonSlipCount],0) as [WonSlipCount]
      ,ISNULL(dbo.FuncCurrencyConverter([WonSlipAmount],'+cast(@SystemCurrencyId as nvarchar(2))+','+cast(@UserCurrencyId as nvarchar(2))+'),0)* case when cast(ReportDate as date )>='''+@MultipDate+''' and WonSlipAmount>0  then '+cast(@Multip as nvarchar(4))+' else 1 end as [WonSlipAmount]
      ,ISNULL(dbo.FuncCurrencyConverter([WonSlipPayOut],'+cast(@SystemCurrencyId as nvarchar(2))+','+cast(@UserCurrencyId as nvarchar(2))+'),0)* case when cast(ReportDate as date )>='''+@MultipDate+''' and WonSlipPayOut>0 then '+cast(@Multip as nvarchar(4))+' else 1 end as [WonSlipPayOut]
      ,ISNULL([LostSlipCount],0)  as [LostSlipCount]
      ,ISNULL(dbo.FuncCurrencyConverter([LostSlipAmount],'+cast(@SystemCurrencyId as nvarchar(2))+','+cast(@UserCurrencyId as nvarchar(2))+'),0)* case when cast(ReportDate as date )>='''+@MultipDate+'''  and LostSlipAmount>0 then '+cast(@Multip as nvarchar(4))+' else 1 end  as [LostSlipAmount]
      ,ISNULL([CancelSlipCount],0)  as [CancelSlipCount]
      ,ISNULL(dbo.FuncCurrencyConverter([CancelSlipAmount],'+cast(@SystemCurrencyId as nvarchar(2))+','+cast(@UserCurrencyId as nvarchar(2))+'),0)* case when cast(ReportDate as date )>='''+@MultipDate+''' and CancelSlipAmount>0 then '+cast(@Multip as nvarchar(4))+' else 1 end as [CancelSlipAmount]
      ,ISNULL(dbo.FuncCurrencyConverter(TurnOver,'+cast(@SystemCurrencyId as nvarchar(2))+','+cast(@UserCurrencyId as nvarchar(2))+'),0)* case when cast(ReportDate as date )>='''+@MultipDate+''' and TurnOver>0 then '+cast(@Multip as nvarchar(4))+' else 1 end as TurnOver
	  ,BranchName '+
'FROM        @TempSummaryBet as tmp INNER JOIN [Parameter].[Branch] ON Parameter.Branch.[BrancName]=tmp.BranchName
WHERE     '+@where +' '+
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '

  
  
  
end
else if (@ViewType=1)
begin

 set @sqlcommand2=' declare @TempSummaryBet table (ReportId nvarchar(50),ReportDate nvarchar(10),SlipCount int,SlipAmount money,OpenSlipCount int,OpenSlipAmount money,OpenSlipPayOut money,WonSlipCount int,WonSlipAmount money,WonSlipPayOut money,LostSlipCount int,LostSlipAmount money,CancelSlipCount int,CancelSlipAmount money,TurnOver money,BranchName nvarchar(100)) '+
  'insert @TempSummaryBet '+
  'SELECT cast(NEWID() as nvarchar(50))
	  ,cast(YEAR([ReportDate]) as nvarchar(4))+''-''+cast(MONTH(ReportDate) as nvarchar(4))+''-1'' as ReportDate
      ,SUM(ISNULL([SlipCount],0))  as [SlipCount]
      ,dbo.FuncCurrencyConverter(SUM([SlipAmount]),'+cast(@SystemCurrencyId as nvarchar(2))+','+cast(@UserCurrencyId as nvarchar(2))+')* case when cast(ReportDate as date )>='''+@MultipDate+''' and SUM([SlipAmount])>0 then '+cast(@Multip as nvarchar(4))+' else 1 end 
      ,SUM(ISNULL([OpenSlipCount],0))  as [OpenSlipCount]
      ,dbo.FuncCurrencyConverter(SUM([OpenSlipAmount]),'+cast(@SystemCurrencyId as nvarchar(2))+','+cast(@UserCurrencyId as nvarchar(2))+')* case when cast(ReportDate as date )>='''+@MultipDate+''' and SUM([OpenSlipAmount])>0 then '+cast(@Multip as nvarchar(4))+' else 1 end 
      ,dbo.FuncCurrencyConverter(SUM([OpenSlipPayOut]),'+cast(@SystemCurrencyId as nvarchar(2))+','+cast(@UserCurrencyId as nvarchar(2))+')* case when cast(ReportDate as date )>='''+@MultipDate+''' and SUM([OpenSlipPayOut])>0 then '+cast(@Multip as nvarchar(4))+' else 1 end 
      ,SUM(ISNULL([WonSlipCount],0))  as [WonSlipCount]
      ,dbo.FuncCurrencyConverter(SUM([WonSlipAmount]),'+cast(@SystemCurrencyId as nvarchar(2))+','+cast(@UserCurrencyId as nvarchar(2))+')* case when cast(ReportDate as date )>='''+@MultipDate+''' and SUM([WonSlipAmount])>0 then '+cast(@Multip as nvarchar(4))+' else 1 end 
      ,dbo.FuncCurrencyConverter(SUM([WonSlipPayOut]),'+cast(@SystemCurrencyId as nvarchar(2))+','+cast(@UserCurrencyId as nvarchar(2))+')* case when cast(ReportDate as date )>='''+@MultipDate+''' and SUM([WonSlipPayOut])>0 then '+cast(@Multip as nvarchar(4))+' else 1 end 
      ,SUM(ISNULL([LostSlipCount],0))  as [LostSlipCount]
      ,dbo.FuncCurrencyConverter(SUM([LostSlipAmount]),'+cast(@SystemCurrencyId as nvarchar(2))+','+cast(@UserCurrencyId as nvarchar(2))+')* case when cast(ReportDate as date )>='''+@MultipDate+''' and SUM([LostSlipAmount])>0 then '+cast(@Multip as nvarchar(4))+' else 1 end 
      ,SUM(ISNULL([CancelSlipCount],0))  as [CancelSlipCount]
      ,dbo.FuncCurrencyConverter(SUM([CancelSlipAmount]),'+cast(@SystemCurrencyId as nvarchar(2))+','+cast(@UserCurrencyId as nvarchar(2))+')* case when cast(ReportDate as date )>='''+@MultipDate+''' and SUM([CancelSlipAmount])>0 then '+cast(@Multip as nvarchar(4))+' else 1 end 
      ,dbo.FuncCurrencyConverter(ISNULL(SUM([SlipAmount]),0)-(ISNULL(SUM([WonSlipPayOut]),0)+ISNULL(SUM([CancelSlipAmount]),0)),'+cast(@SystemCurrencyId as nvarchar(2))+','+cast(@UserCurrencyId as nvarchar(2))+')* case when cast(ReportDate as date )>='''+@MultipDate+''' then '+cast(@Multip as nvarchar(4))+' else 1 end  as TurnOver
   ,Parameter.Branch.[BrancName]
  FROM [Report].[SummaryBonusSportBetting] INNER JOIN 
  Customer.Customer ON Customer.Customer.CustomerId=[Report].[SummaryBonusSportBetting].CustomerId INNER JOIN
  Parameter.Branch ON Parameter.Branch.BranchId=Customer.Customer.BranchId 
  Where  '+@where + '
  GROUP BY cast(YEAR([ReportDate]) as nvarchar(4))+''-''+cast(MONTH(ReportDate) as nvarchar(4))+''-1'',Parameter.Branch.[BrancName],ReportDate  ; '

    set @sqlcommand='declare @TempSummaryBet2 table (ReportDate nvarchar(10),SlipCount int,SlipAmount money,OpenSlipCount int,OpenSlipAmount money,OpenSlipPayOut money,WonSlipCount int,WonSlipAmount money,WonSlipPayOut money,LostSlipCount int,LostSlipAmount money,CancelSlipCount int,CancelSlipAmount money,TurnOver money,BranchName nvarchar(100))'+
  ' insert @TempSummaryBet2  '+
  ' select ReportDate,SUM(SlipCount),SUM(SlipAmount),SUM(OpenSlipCount),SUM(OpenSlipAmount),SUM(OpenSlipPayOut),SUM(WonSlipCount),SUM(WonSlipAmount),SUM(WonSlipPayOut),SUM(LostSlipCount),SUM(LostSlipAmount),SUM(CancelSlipCount),SUM(CancelSlipAmount),SUM(TurnOver),BranchName from @TempSummaryBet GROUP BY ReportDate,BranchName '

  
  set @sqlcommand+=' declare @total int '+
'select @total=COUNT(ReportDate)  '+
'FROM        @TempSummaryBet2 as tmp INNER JOIN [Parameter].[Branch] ON [Parameter].[Branch].[BrancName]=tmp.BranchName
WHERE    '+@where +'; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
'	cast(NEWID() as nvarchar(50)) as  ReportId 
	 ,cast(YEAR([ReportDate]) as nvarchar(4))+''-''+cast(MONTH(ReportDate) as nvarchar(4)) as ReportDate
      ,ISNULL([SlipCount],0) as [SlipCount]
      ,[SlipAmount] as [SlipAmount]
      ,ISNULL([OpenSlipCount],0)  as [OpenSlipCount]
      ,[OpenSlipAmount]   as [OpenSlipAmount]
      ,[OpenSlipPayOut]   as [OpenSlipPayOut]
      ,ISNULL([WonSlipCount],0)  as [WonSlipCount]
      ,[WonSlipAmount]  as [WonSlipAmount]
      ,[WonSlipPayOut]   as [WonSlipPayOut]
      ,ISNULL([LostSlipCount],0) as [LostSlipCount]
      ,[LostSlipAmount]   as [LostSlipAmount]
      ,ISNULL([CancelSlipCount],0)  as [CancelSlipCount]
      ,[CancelSlipAmount]  as [CancelSlipAmount]
       ,TurnOver  as TurnOver
	  ,BranchName '+
'FROM        @TempSummaryBet2 as tmp INNER JOIN [Parameter].[Branch] ON [Parameter].[Branch].[BrancName]=tmp.BranchName
WHERE     '+@where +' '+
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '

  
  
 end
 else
 begin 
 
 
 
 set @sqlcommand2=' declare @TempSummaryBet table (ReportId nvarchar(50),ReportDate nvarchar(10),SlipCount int,SlipAmount money,OpenSlipCount int,OpenSlipAmount money,OpenSlipPayOut money,WonSlipCount int,WonSlipAmount money,WonSlipPayOut money,LostSlipCount int,LostSlipAmount money,CancelSlipCount int,CancelSlipAmount money,TurnOver money,BranchName nvarchar(100)) '+
  'insert @TempSummaryBet '+
  'SELECT cast(NEWID() as nvarchar(50))
  ,cast(YEAR([ReportDate]) as nvarchar(4)) as ReportDate
      ,SUM(ISNULL([SlipCount],0))  as [SlipCount]
      ,SUM(ISNULL([SlipAmount],0))* case when cast(ReportDate as date )>='''+@MultipDate+'''  and SUM(ISNULL([SlipAmount],0))>0 then '+cast(@Multip as nvarchar(4))+' else 1 end as [SlipAmount]
      ,SUM(ISNULL([OpenSlipCount],0))  as [OpenSlipCount]
      ,SUM(ISNULL([OpenSlipAmount],0))* case when cast(ReportDate as date )>='''+@MultipDate+'''  and SUM(ISNULL([OpenSlipAmount],0))>0 then '+cast(@Multip as nvarchar(4))+' else 1 end as [OpenSlipAmount]
      ,SUM(ISNULL([OpenSlipPayOut],0))* case when cast(ReportDate as date )>='''+@MultipDate+'''  and SUM(ISNULL([OpenSlipPayOut],0))>0 then '+cast(@Multip as nvarchar(4))+' else 1 end as [OpenSlipPayOut]
      ,SUM(ISNULL([WonSlipCount],0))  as [WonSlipCount]
      ,SUM(ISNULL([WonSlipAmount],0))* case when cast(ReportDate as date )>='''+@MultipDate+'''  and SUM(ISNULL([WonSlipAmount],0))>0 then '+cast(@Multip as nvarchar(4))+' else 1 end as [WonSlipAmount]
      ,SUM(ISNULL([WonSlipPayOut],0))* case when cast(ReportDate as date )>='''+@MultipDate+'''  and SUM(ISNULL([WonSlipPayOut],0))>0 then '+cast(@Multip as nvarchar(4))+' else 1 end as [WonSlipPayOut]
      ,SUM(ISNULL([LostSlipCount],0))  as [LostSlipCount]
      ,SUM(ISNULL([LostSlipAmount],0))* case when cast(ReportDate as date )>='''+@MultipDate+'''  and SUM(ISNULL([LostSlipAmount],0))>0 then '+cast(@Multip as nvarchar(4))+' else 1 end as [LostSlipAmount]
      ,SUM(ISNULL([CancelSlipCount],0)) * case when cast(ReportDate as date )>='''+@MultipDate+'''  and SUM(ISNULL([CancelSlipCount],0))>0 then '+cast(@Multip as nvarchar(4))+' else 1 end as [CancelSlipCount]
      ,SUM(ISNULL([CancelSlipAmount],0))* case when cast(ReportDate as date )>='''+@MultipDate+'''  and SUM(ISNULL([CancelSlipAmount],0))>0 then '+cast(@Multip as nvarchar(4))+' else 1 end as [CancelSlipAmount]
      ,ISNULL(SUM([SlipAmount]),0)-ISNULL(SUM([WonSlipPayOut]),0)-ISNULL(SUM([CancelSlipAmount]),0)* case when cast(ReportDate as date )>='''+@MultipDate+'''  and SUM(ISNULL([SlipAmount],0))>0 then '+cast(@Multip as nvarchar(4))+' else 1 end as TurnOver
		,Parameter.Branch.[BrancName]
  FROM [Report].[SummaryBonusSportBetting] INNER JOIN 
  Customer.Customer ON Customer.Customer.CustomerId=[Report].[SummaryBonusSportBetting].CustomerId INNER JOIN
  Parameter.Branch ON Parameter.Branch.BranchId=Customer.Customer.BranchId 
  Where  '+@where2 + '
  GROUP BY cast(YEAR([ReportDate]) as nvarchar(4)),Parameter.Branch.[BrancName],ReportDate ; '
 
     set @sqlcommand='declare @TempSummaryBet2 table (ReportDate nvarchar(10),SlipCount int,SlipAmount money,OpenSlipCount int,OpenSlipAmount money,OpenSlipPayOut money,WonSlipCount int,WonSlipAmount money,WonSlipPayOut money,LostSlipCount int,LostSlipAmount money,CancelSlipCount int,CancelSlipAmount money,TurnOver money,BranchName nvarchar(100))'+
  ' insert @TempSummaryBet2  '+
  ' select ReportDate,SUM(SlipCount),SUM(SlipAmount),SUM(OpenSlipCount),SUM(OpenSlipAmount),SUM(OpenSlipPayOut),SUM(WonSlipCount),SUM(WonSlipAmount),SUM(WonSlipPayOut),SUM(LostSlipCount),SUM(LostSlipAmount),SUM(CancelSlipCount),SUM(CancelSlipAmount),SUM(TurnOver),BranchName from @TempSummaryBet GROUP BY ReportDate,BranchName '

  
  set @sqlcommand+=' declare @total int '+
'select @total=COUNT(ReportDate)  '+
'FROM        @TempSummaryBet2 as tmp INNER JOIN [Parameter].[Branch] ON [Parameter].[Branch].[BrancName]=tmp.BranchName
WHERE    '+@where +'; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
'    cast(NEWID() as nvarchar(50)) as ReportId 
	  ,ReportDate as ReportDate
      ,ISNULL([SlipCount],0)  as [SlipCount]
      ,ISNULL(dbo.FuncCurrencyConverter([SlipAmount],'+cast(@SystemCurrencyId as nvarchar(2))+','+cast(@UserCurrencyId as nvarchar(2))+'),0)  as [SlipAmount]
      ,ISNULL([OpenSlipCount],0)  as [OpenSlipCount]
      ,ISNULL(dbo.FuncCurrencyConverter([OpenSlipAmount],'+cast(@SystemCurrencyId as nvarchar(2))+','+cast(@UserCurrencyId as nvarchar(2))+'),0)   as [OpenSlipAmount]
      ,ISNULL(dbo.FuncCurrencyConverter([OpenSlipPayOut],'+cast(@SystemCurrencyId as nvarchar(2))+','+cast(@UserCurrencyId as nvarchar(2))+'),0)   as [OpenSlipPayOut]
      ,ISNULL([WonSlipCount],0)  as [WonSlipCount]
      ,ISNULL(dbo.FuncCurrencyConverter([WonSlipAmount],'+cast(@SystemCurrencyId as nvarchar(2))+','+cast(@UserCurrencyId as nvarchar(2))+'),0)  as [WonSlipAmount]
      ,ISNULL(dbo.FuncCurrencyConverter([WonSlipPayOut],'+cast(@SystemCurrencyId as nvarchar(2))+','+cast(@UserCurrencyId as nvarchar(2))+'),0)   as [WonSlipPayOut]
      ,ISNULL([LostSlipCount],0)  as [LostSlipCount]
      ,ISNULL(dbo.FuncCurrencyConverter([LostSlipAmount],'+cast(@SystemCurrencyId as nvarchar(2))+','+cast(@UserCurrencyId as nvarchar(2))+'),0)   as [LostSlipAmount]
      ,ISNULL([CancelSlipCount],0)  as [CancelSlipCount]
      ,ISNULL(dbo.FuncCurrencyConverter([CancelSlipAmount],'+cast(@SystemCurrencyId as nvarchar(2))+','+cast(@UserCurrencyId as nvarchar(2))+'),0)  as [CancelSlipAmount]
       ,ISNULL(dbo.FuncCurrencyConverter(TurnOver,'+cast(@SystemCurrencyId as nvarchar(2))+','+cast(@UserCurrencyId as nvarchar(2))+'),0)  as TurnOver
	  ,BranchName '+
'FROM        @TempSummaryBet2 as tmp INNER JOIN [Parameter].[Branch] ON [Parameter].[Branch].[BrancName]=tmp.BranchName
WHERE     '+@where +' '+
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '

  
 
 
end
END
else
	begin
	if(@ViewType=0)
begin

 
 set @sqlcommand2=' declare @TempSummaryBet table (ReportId nvarchar(50),ReportDate nvarchar(10),SlipCount int,SlipAmount money,OpenSlipCount int,OpenSlipAmount money,OpenSlipPayOut money,WonSlipCount int,WonSlipAmount money,WonSlipPayOut money,LostSlipCount int,LostSlipAmount money,CancelSlipCount int,CancelSlipAmount money,TurnOver money,BranchName nvarchar(100)) '+
  'insert @TempSummaryBet '+
  'SELECT cast(NEWID() as nvarchar(50))
      ,cast(ReportDate as nvarchar(10)) as ReportDate 
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
      ,ISNULL(SUM([SlipAmount]),0)-(ISNULL(SUM([WonSlipPayOut]),0)+ISNULL(SUM([CancelSlipAmount]),0)) as TurnOver
	  ,Parameter.Branch.[BrancName]
  FROM [Report].[SummaryBonusSportBetting] INNER JOIN 
  Customer.Customer ON Customer.Customer.CustomerId=[Report].[SummaryBonusSportBetting].CustomerId INNER JOIN
  [Parameter].[Branch] ON  [Parameter].[Branch].[BranchId]=Customer.Customer.BranchId 
  Where  '+@where2 + ' 
  GROUP BY Parameter.Branch.[BrancName],cast(ReportDate as nvarchar(10)); '
  
  
  
  set @sqlcommand='declare @total int '+
'select @total=COUNT(ReportDate)  '+
'FROM       @TempSummaryBet as tmp INNER JOIN [Parameter].[Branch] ON [Parameter].[Branch].[BrancName]=tmp.BranchName
WHERE    '+@where +' ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
'		ReportId
	  ,ReportDate as ReportDate
      ,ISNULL([SlipCount],0)  as [SlipCount]
       ,ISNULL(dbo.FuncCurrencyConverter(SlipAmount,'+cast(@SystemCurrencyId as nvarchar(2))+','+cast(@UserCurrencyId as nvarchar(2))+'),0)/5 as [SlipAmount]
      ,ISNULL([OpenSlipCount],0)  as [OpenSlipCount]
      ,ISNULL(dbo.FuncCurrencyConverter([OpenSlipAmount],'+cast(@SystemCurrencyId as nvarchar(2))+','+cast(@UserCurrencyId as nvarchar(2))+'),0)/5  as [OpenSlipAmount]
      ,ISNULL(dbo.FuncCurrencyConverter([OpenSlipPayOut],'+cast(@SystemCurrencyId as nvarchar(2))+','+cast(@UserCurrencyId as nvarchar(2))+'),0)/5  as [OpenSlipPayOut]
      ,ISNULL([WonSlipCount],0)  as [WonSlipCount]
      ,ISNULL(dbo.FuncCurrencyConverter([WonSlipAmount],'+cast(@SystemCurrencyId as nvarchar(2))+','+cast(@UserCurrencyId as nvarchar(2))+'),0)/5 as [WonSlipAmount]
      ,ISNULL(dbo.FuncCurrencyConverter([WonSlipPayOut],'+cast(@SystemCurrencyId as nvarchar(2))+','+cast(@UserCurrencyId as nvarchar(2))+'),0)/5  as [WonSlipPayOut]
      ,ISNULL([LostSlipCount],0)  as [LostSlipCount]
      ,ISNULL(dbo.FuncCurrencyConverter([LostSlipAmount],'+cast(@SystemCurrencyId as nvarchar(2))+','+cast(@UserCurrencyId as nvarchar(2))+'),0)/5  as [LostSlipAmount]
      ,ISNULL([CancelSlipCount],0)  as [CancelSlipCount]
      ,ISNULL(dbo.FuncCurrencyConverter([CancelSlipAmount],'+cast(@SystemCurrencyId as nvarchar(2))+','+cast(@UserCurrencyId as nvarchar(2))+'),0)/5 as [CancelSlipAmount]
      ,ISNULL(dbo.FuncCurrencyConverter(TurnOver,'+cast(@SystemCurrencyId as nvarchar(2))+','+cast(@UserCurrencyId as nvarchar(2))+'),0)/5 as TurnOver
	  ,BranchName '+
'FROM        @TempSummaryBet as tmp INNER JOIN [Parameter].[Branch] ON Parameter.Branch.[BrancName]=tmp.BranchName
WHERE     '+@where +' '+
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '

  
  
  
end
else if (@ViewType=1)
begin

 set @sqlcommand2=' declare @TempSummaryBet table (ReportId nvarchar(50),ReportDate nvarchar(10),SlipCount int,SlipAmount money,OpenSlipCount int,OpenSlipAmount money,OpenSlipPayOut money,WonSlipCount int,WonSlipAmount money,WonSlipPayOut money,LostSlipCount int,LostSlipAmount money,CancelSlipCount int,CancelSlipAmount money,TurnOver money,BranchName nvarchar(100)) '+
  'insert @TempSummaryBet '+
  'SELECT cast(NEWID() as nvarchar(50))
	  ,cast(YEAR([ReportDate]) as nvarchar(4))+''-''+cast(MONTH(ReportDate) as nvarchar(4))+''-1'' as ReportDate
      ,SUM(ISNULL([SlipCount],0))  as [SlipCount]
      ,SUM([SlipAmount])
      ,SUM(ISNULL([OpenSlipCount],0))  as [OpenSlipCount]
      ,SUM([OpenSlipAmount])
      ,SUM([OpenSlipPayOut])
      ,SUM(ISNULL([WonSlipCount],0))  as [WonSlipCount]
      ,SUM([WonSlipAmount])
      ,SUM([WonSlipPayOut])
      ,SUM(ISNULL([LostSlipCount],0))  as [LostSlipCount]
      ,SUM([LostSlipAmount])
      ,SUM(ISNULL([CancelSlipCount],0))  as [CancelSlipCount]
      ,SUM([CancelSlipAmount])
      ,ISNULL(SUM([SlipAmount]),0)-(ISNULL(SUM([WonSlipPayOut]),0)+ISNULL(SUM([CancelSlipAmount]),0)) as TurnOver
   ,Parameter.Branch.[BrancName]
  FROM [Report].[SummaryBonusSportBetting] INNER JOIN 
  Customer.Customer ON Customer.Customer.CustomerId=[Report].[SummaryBonusSportBetting].CustomerId INNER JOIN
  Parameter.Branch ON Parameter.Branch.BranchId=Customer.Customer.BranchId 
  Where  '+@where2 + '
  GROUP BY cast(YEAR([ReportDate]) as nvarchar(4))+''-''+cast(MONTH(ReportDate) as nvarchar(4)),Parameter.Branch.[BrancName] ; '

  
  set @sqlcommand='declare @total int '+
'select @total=COUNT(ReportDate)  '+
'FROM        @TempSummaryBet as tmp INNER JOIN [Parameter].[Branch] ON [Parameter].[Branch].[BrancName]=tmp.BranchName
WHERE    '+@where +'; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
'	 ReportId 
	 ,cast(YEAR([ReportDate]) as nvarchar(4))+''-''+cast(MONTH(ReportDate) as nvarchar(4)) as ReportDate
      ,ISNULL([SlipCount],0)  as [SlipCount]
      ,ISNULL(dbo.FuncCurrencyConverter([SlipAmount],'+cast(@SystemCurrencyId as nvarchar(2))+','+cast(@UserCurrencyId as nvarchar(2))+'),0)/5 as [SlipAmount]
      ,ISNULL([OpenSlipCount],0)  as [OpenSlipCount]
      ,ISNULL(dbo.FuncCurrencyConverter([OpenSlipAmount],'+cast(@SystemCurrencyId as nvarchar(2))+','+cast(@UserCurrencyId as nvarchar(2))+'),0)/5  as [OpenSlipAmount]
      ,ISNULL(dbo.FuncCurrencyConverter([OpenSlipPayOut],'+cast(@SystemCurrencyId as nvarchar(2))+','+cast(@UserCurrencyId as nvarchar(2))+'),0)/5  as [OpenSlipPayOut]
      ,ISNULL([WonSlipCount],0)  as [WonSlipCount]
      ,ISNULL(dbo.FuncCurrencyConverter([WonSlipAmount],'+cast(@SystemCurrencyId as nvarchar(2))+','+cast(@UserCurrencyId as nvarchar(2))+'),0)/5 as [WonSlipAmount]
      ,ISNULL(dbo.FuncCurrencyConverter([WonSlipPayOut],'+cast(@SystemCurrencyId as nvarchar(2))+','+cast(@UserCurrencyId as nvarchar(2))+'),0)/5  as [WonSlipPayOut]
      ,ISNULL([LostSlipCount],0)  as [LostSlipCount]
      ,ISNULL(dbo.FuncCurrencyConverter([LostSlipAmount],'+cast(@SystemCurrencyId as nvarchar(2))+','+cast(@UserCurrencyId as nvarchar(2))+'),0)/5  as [LostSlipAmount]
      ,ISNULL([CancelSlipCount],0)  as [CancelSlipCount]
      ,ISNULL(dbo.FuncCurrencyConverter([CancelSlipAmount],'+cast(@SystemCurrencyId as nvarchar(2))+','+cast(@UserCurrencyId as nvarchar(2))+'),0)/5 as [CancelSlipAmount]
       ,ISNULL(dbo.FuncCurrencyConverter(TurnOver,'+cast(@SystemCurrencyId as nvarchar(2))+','+cast(@UserCurrencyId as nvarchar(2))+'),0)/5 as TurnOver
	  ,BranchName '+
'FROM        @TempSummaryBet as tmp INNER JOIN [Parameter].[Branch] ON [Parameter].[Branch].[BrancName]=tmp.BranchName
WHERE     '+@where +' '+
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '

  
  
 end
 else
 begin 
 
 
 
 set @sqlcommand2=' declare @TempSummaryBet table (ReportId nvarchar(50),ReportDate nvarchar(10),SlipCount int,SlipAmount money,OpenSlipCount int,OpenSlipAmount money,OpenSlipPayOut money,WonSlipCount int,WonSlipAmount money,WonSlipPayOut money,LostSlipCount int,LostSlipAmount money,CancelSlipCount int,CancelSlipAmount money,TurnOver money,BranchName nvarchar(100)) '+
  'insert @TempSummaryBet '+
  'SELECT cast(NEWID() as nvarchar(50))
  ,cast(YEAR([ReportDate]) as nvarchar(4)) as ReportDate
      ,SUM(ISNULL([SlipCount],0))  as [SlipCount]
      ,SUM(ISNULL([SlipAmount],0))  as [SlipAmount]
      ,SUM(ISNULL([OpenSlipCount],0))  as [OpenSlipCount]
      ,SUM(ISNULL([OpenSlipAmount],0))  as [OpenSlipAmount]
      ,SUM(ISNULL([OpenSlipPayOut],0))  as [OpenSlipPayOut]
      ,SUM(ISNULL([WonSlipCount],0))  as [WonSlipCount]
      ,SUM(ISNULL([WonSlipAmount],0))  as [WonSlipAmount]
      ,SUM(ISNULL([WonSlipPayOut],0))  as [WonSlipPayOut]
      ,SUM(ISNULL([LostSlipCount],0))  as [LostSlipCount]
      ,SUM(ISNULL([LostSlipAmount],0))  as [LostSlipAmount]
      ,SUM(ISNULL([CancelSlipCount],0))  as [CancelSlipCount]
      ,SUM(ISNULL([CancelSlipAmount],0))  as [CancelSlipAmount]
      ,ISNULL(SUM([SlipAmount]),0)-ISNULL(SUM([WonSlipPayOut]),0)-ISNULL(SUM([CancelSlipAmount]),0) as TurnOver
		,Parameter.Branch.[BrancName]
  FROM [Report].[SummaryBonusSportBetting] INNER JOIN 
  Customer.Customer ON Customer.Customer.CustomerId=[Report].[SummaryBonusSportBetting].CustomerId INNER JOIN
  Parameter.Branch ON Parameter.Branch.BranchId=Customer.Customer.BranchId 
  Where  '+@where2 + '
  GROUP BY cast(YEAR([ReportDate]) as nvarchar(4)),Parameter.Branch.[BrancName] ; '
 
  
  set @sqlcommand='declare @total int '+
'select @total=COUNT(ReportDate)  '+
'FROM        @TempSummaryBet as tmp INNER JOIN [Parameter].[Branch] ON [Parameter].[Branch].[BrancName]=tmp.BranchName
WHERE    '+@where +'; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
'     ReportId 
	  ,ReportDate as ReportDate
      ,ISNULL([SlipCount],0)  as [SlipCount]
      ,ISNULL(dbo.FuncCurrencyConverter([SlipAmount],'+cast(@SystemCurrencyId as nvarchar(2))+','+cast(@UserCurrencyId as nvarchar(2))+'),0)/5 as [SlipAmount]
      ,ISNULL([OpenSlipCount],0)  as [OpenSlipCount]
      ,ISNULL(dbo.FuncCurrencyConverter([OpenSlipAmount],'+cast(@SystemCurrencyId as nvarchar(2))+','+cast(@UserCurrencyId as nvarchar(2))+'),0)/5  as [OpenSlipAmount]
      ,ISNULL(dbo.FuncCurrencyConverter([OpenSlipPayOut],'+cast(@SystemCurrencyId as nvarchar(2))+','+cast(@UserCurrencyId as nvarchar(2))+'),0)/5  as [OpenSlipPayOut]
      ,ISNULL([WonSlipCount],0)  as [WonSlipCount]
      ,ISNULL(dbo.FuncCurrencyConverter([WonSlipAmount],'+cast(@SystemCurrencyId as nvarchar(2))+','+cast(@UserCurrencyId as nvarchar(2))+'),0)/5 as [WonSlipAmount]
      ,ISNULL(dbo.FuncCurrencyConverter([WonSlipPayOut],'+cast(@SystemCurrencyId as nvarchar(2))+','+cast(@UserCurrencyId as nvarchar(2))+'),0)/5  as [WonSlipPayOut]
      ,ISNULL([LostSlipCount],0)  as [LostSlipCount]
      ,ISNULL(dbo.FuncCurrencyConverter([LostSlipAmount],'+cast(@SystemCurrencyId as nvarchar(2))+','+cast(@UserCurrencyId as nvarchar(2))+'),0)/5  as [LostSlipAmount]
      ,ISNULL([CancelSlipCount],0)  as [CancelSlipCount]
      ,ISNULL(dbo.FuncCurrencyConverter([CancelSlipAmount],'+cast(@SystemCurrencyId as nvarchar(2))+','+cast(@UserCurrencyId as nvarchar(2))+'),0)/5 as [CancelSlipAmount]
       ,ISNULL(dbo.FuncCurrencyConverter(TurnOver,'+cast(@SystemCurrencyId as nvarchar(2))+','+cast(@UserCurrencyId as nvarchar(2))+'),0)/5 as TurnOver
	  ,BranchName '+
'FROM        @TempSummaryBet as tmp INNER JOIN [Parameter].[Branch] ON [Parameter].[Branch].[BrancName]=tmp.BranchName
WHERE     '+@where +' '+
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '

  
 
 
end

	end


execute (@sqlcommand2+@sqlcommand)
END



GO
