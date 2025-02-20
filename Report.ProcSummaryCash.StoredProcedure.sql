USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Report].[ProcSummaryCash]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Report].[ProcSummaryCash] 
 @ViewType int, --0 günlük,1 aylık , 2 yıllık
 @PageSize  INT,
 @PageNum int,
@Username nvarchar(50),
@where nvarchar(1000),
@orderby nvarchar(100)
AS

BEGIN
SET NOCOUNT ON;

exec Report.ProcSummaryCashFill1
declare @sqlcommand nvarchar(max)
declare @sqlcommand2 nvarchar(max)
declare @BranchId int
declare @where2 nvarchar(max)=' where 1=1'
declare @UserCurrencyId int
declare @SystemCurrencyId int
declare @RoleId int

select top 1 @SystemCurrencyId=SystemCurrencyId from General.Setting 
select top 1  @RoleId=Users.UserRoles.RoleId,@BranchId=Users.Users.UnitCode, @UserCurrencyId=Users.Users.CurrencyId from Users.Users INNER JOIN Users.UserRoles ON Users.UserRoles.UserId=Users.Users.UserId 
where Users.Users.UserName=@Username


if(@BranchId<>1)
	begin

	set @where2=' where Report.SummaryCash.CustomerId in (select Customer.Customer.CustomerId from Customer.Customer where Customer.Customer.BranchId='+cast(@BranchId as nvarchar(7))+')'

	end

if(@RoleId<>156)
begin
if(@ViewType=0)
begin
--SELECT 0 as totalrow, cast(ReportDate as nvarchar(10)) as ReportDate
--      ,case when Parameter.TransactionType.Direction=0 Then SUM(ISNULL(Amount,0))*-1 else  SUM(ISNULL(Amount,0)) end as [Amount]
--      ,ISNULL(Parameter.TransactionType.TransactionType,'')  as TransactionType
--  FROM Report.SummaryCash Inner Join Parameter.TransactionType on 
--  Parameter.TransactionType.TransactionTypeId=Report.SummaryCash.TransactionTypeId
--  GROUP BY Parameter.TransactionType.TransactionType,ReportDate,Parameter.TransactionType.Direction
  

  
  
 set @sqlcommand2=' declare @TempSummaryBet table (ReportDate nvarchar(10),Amount money,TransactionType nvarchar(100),TransactionTypeId int,IsOnline bit) '+
  'insert @TempSummaryBet '+
  'SELECT  cast(ReportDate as nvarchar(10)) as ReportDate
      ,case when Parameter.TransactionType.Direction=0 Then SUM(ISNULL(Amount,0))*-1 else case when Parameter.TransactionType.TransactionTypeId=35 then SUM(ISNULL(Amount,0))*-1 else  SUM(ISNULL(Amount,0)) end end as [Amount]
      ,ISNULL(Parameter.TransactionType.TransactionType,'''')  as TransactionType,Parameter.TransactionType.Direction,Parameter.TransactionType.IsOnline
  FROM Report.SummaryCash Inner Join Parameter.TransactionType on 
  Parameter.TransactionType.TransactionTypeId=Report.SummaryCash.TransactionTypeId '+
  @where2 +' and Parameter.TransactionType.TransactionTypeId not in (3,8,4,33,34,36,37,38,39,40,41,42,43,53,54,47,63)'+
  ' GROUP BY Parameter.TransactionType.TransactionType,ReportDate,Parameter.TransactionType.Direction,Parameter.TransactionType.TransactionTypeId,Parameter.TransactionType.IsOnline ; '
  
  
  
  set @sqlcommand='declare @total int '+
'select @total=COUNT(ReportDate)  '+
'FROM       @TempSummaryBet
WHERE    '+@where +' ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
' ReportDate as ReportDate
      ,ISNULL(dbo.FuncCurrencyConverter([Amount],'+cast(@SystemCurrencyId as nvarchar(3))+','+cast(@UserCurrencyId as nvarchar(3))+'),0)  as [Amount]
      ,[TransactionType]  as [TransactionType] '+
'FROM        @TempSummaryBet
WHERE     '+@where +' '+
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '

  
  
  
end
else if (@ViewType=1)
begin

--SELECT 0 as totalrow, cast(YEAR([ReportDate]) as nvarchar(4))+'-'+cast(MONTH(ReportDate) as nvarchar(4)) as ReportDate
--      ,case when Parameter.TransactionType.Direction=0 Then SUM(ISNULL(Amount,0))*-1 else  SUM(ISNULL(Amount,0)) end as [Amount]
--      ,ISNULL(Parameter.TransactionType.TransactionType,'')  as TransactionType
--  FROM Report.SummaryCash Inner Join Parameter.TransactionType on 
--  Parameter.TransactionType.TransactionTypeId=Report.SummaryCash.TransactionTypeId
--  GROUP BY Parameter.TransactionType.TransactionType,cast(YEAR([ReportDate]) as nvarchar(4))+'-'+cast(MONTH(ReportDate) as nvarchar(4)),Parameter.TransactionType.Direction


 set @sqlcommand2=' declare @TempSummaryBet table (ReportDate nvarchar(10),Amount money,TransactionType nvarchar(100),TransactionTypeId int,IsOnline bit) '+
  'insert @TempSummaryBet '+
  'SELECT  cast(YEAR([ReportDate]) as nvarchar(4))+''-''+cast(MONTH(ReportDate) as nvarchar(4))+''-1'' as ReportDate
     ,case when Parameter.TransactionType.Direction=0 Then SUM(ISNULL(Amount,0))*-1 else case when Parameter.TransactionType.TransactionTypeId=35 then SUM(ISNULL(Amount,0))*-1 else  SUM(ISNULL(Amount,0)) end end as [Amount]
      ,ISNULL(Parameter.TransactionType.TransactionType,'''')  as TransactionType,Parameter.TransactionType.Direction,Parameter.TransactionType.IsOnline
  FROM Report.SummaryCash Inner Join Parameter.TransactionType on 
  Parameter.TransactionType.TransactionTypeId=Report.SummaryCash.TransactionTypeId '+
  @where2 +' and Parameter.TransactionType.TransactionTypeId not in (3,8,4,33,34,36,37,38,39,40,41,42,43)'+
  ' GROUP BY Parameter.TransactionType.TransactionType,cast(YEAR([ReportDate]) as nvarchar(4))+''-''+cast(MONTH(ReportDate) as nvarchar(4)),Parameter.TransactionType.Direction,Parameter.TransactionType.TransactionTypeId,Parameter.TransactionType.IsOnline ; '
  
  
  
  set @sqlcommand='declare @total int '+
'select @total=COUNT(ReportDate)  '+
'FROM       @TempSummaryBet
WHERE    '+@where +' ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
' cast(YEAR([ReportDate]) as nvarchar(4))+''-''+cast(MONTH(ReportDate) as nvarchar(4)) as ReportDate
      ,ISNULL(dbo.FuncCurrencyConverter([Amount],'+cast(@SystemCurrencyId as nvarchar(3))+','+cast(@UserCurrencyId as nvarchar(3))+'),0) as [Amount]
      ,[TransactionType]  as [TransactionType] '+
'FROM        @TempSummaryBet
WHERE     '+@where +' '+
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '

  
  
 end
 else
 begin 
 
 --SELECT 0 as totalrow, cast(YEAR([ReportDate]) as nvarchar(4)) as ReportDate
 --     ,case when Parameter.TransactionType.Direction=0 Then SUM(ISNULL(Amount,0))*-1 else  SUM(ISNULL(Amount,0)) end as [Amount]
 --     ,ISNULL(Parameter.TransactionType.TransactionType,'')  as TransactionType
 -- FROM Report.SummaryCash Inner Join Parameter.TransactionType on 
 -- Parameter.TransactionType.TransactionTypeId=Report.SummaryCash.TransactionTypeId
 -- GROUP BY Parameter.TransactionType.TransactionType,cast(YEAR([ReportDate]) as nvarchar(4)),Parameter.TransactionType.Direction



 set @sqlcommand2=' declare @TempSummaryBet table (ReportDate nvarchar(10),Amount money,TransactionType nvarchar(100),TransactionTypeId int,IsOnline bit) '+
  'insert @TempSummaryBet '+
  'SELECT  cast(YEAR([ReportDate]) as nvarchar(4)) as ReportDate
      ,case when Parameter.TransactionType.Direction=0 Then SUM(ISNULL(Amount,0))*-1 else case when Parameter.TransactionType.TransactionTypeId=35 then SUM(ISNULL(Amount,0))*-1 else  SUM(ISNULL(Amount,0)) end end as [Amount]
      ,ISNULL(Parameter.TransactionType.TransactionType,'''')  as TransactionType,Parameter.TransactionType.Direction,Parameter.TransactionType.IsOnline
  FROM Report.SummaryCash Inner Join Parameter.TransactionType on 
  Parameter.TransactionType.TransactionTypeId=Report.SummaryCash.TransactionTypeId'+
  @where2 +' and Parameter.TransactionType.TransactionTypeId not in (3,8,4,33,34,36,37,38,39,40,41,42,43)'+
  ' GROUP BY Parameter.TransactionType.TransactionType,cast(YEAR([ReportDate]) as nvarchar(4)),Parameter.TransactionType.Direction,Parameter.TransactionType.TransactionTypeId,Parameter.TransactionType.IsOnline ; '
  
  
  
  set @sqlcommand='declare @total int '+
'select @total=COUNT(ReportDate)  '+
'FROM       @TempSummaryBet
WHERE    '+@where +' ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
' ReportDate as ReportDate
      ,ISNULL(ISNULL(dbo.FuncCurrencyConverter([Amount],'+cast(@SystemCurrencyId as nvarchar(3))+','+cast(@UserCurrencyId as nvarchar(3))+'),0),0)  as [Amount]
      ,[TransactionType]  as [TransactionType] '+
'FROM        @TempSummaryBet
WHERE     '+@where +' '+
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '

  
end
end
else
begin
if(@ViewType=0)
begin
--SELECT 0 as totalrow, cast(ReportDate as nvarchar(10)) as ReportDate
--      ,case when Parameter.TransactionType.Direction=0 Then SUM(ISNULL(Amount,0))*-1 else  SUM(ISNULL(Amount,0)) end as [Amount]
--      ,ISNULL(Parameter.TransactionType.TransactionType,'')  as TransactionType
--  FROM Report.SummaryCash Inner Join Parameter.TransactionType on 
--  Parameter.TransactionType.TransactionTypeId=Report.SummaryCash.TransactionTypeId
--  GROUP BY Parameter.TransactionType.TransactionType,ReportDate,Parameter.TransactionType.Direction
  

  
  
 set @sqlcommand2=' declare @TempSummaryBet table (ReportDate nvarchar(10),Amount money,TransactionType nvarchar(100)) '+
  'insert @TempSummaryBet '+
  'SELECT  cast(ReportDate as nvarchar(10)) as ReportDate
      ,case when Parameter.TransactionType.Direction=0 Then SUM(ISNULL(Amount,0))*-1 else case when Parameter.TransactionType.TransactionTypeId=35 then SUM(ISNULL(Amount,0))*-1 else  SUM(ISNULL(Amount,0)) end end as [Amount]
      ,ISNULL(Parameter.TransactionType.TransactionType,'''')  as TransactionType
  FROM Report.SummaryCash Inner Join Parameter.TransactionType on 
  Parameter.TransactionType.TransactionTypeId=Report.SummaryCash.TransactionTypeId '+
  @where2 +' and Parameter.TransactionType.TransactionTypeId not in (3,8,4,33,34,36,37,38,39,40,41,42,43)'+
  ' GROUP BY Parameter.TransactionType.TransactionType,ReportDate,Parameter.TransactionType.Direction,Parameter.TransactionType.TransactionTypeId ; '
  
  
  
  set @sqlcommand='declare @total int '+
'select @total=COUNT(ReportDate)  '+
'FROM       @TempSummaryBet
WHERE    '+@where +' ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
' ReportDate as ReportDate
      ,ISNULL(dbo.FuncCurrencyConverter([Amount],'+cast(@SystemCurrencyId as nvarchar(3))+','+cast(@UserCurrencyId as nvarchar(3))+'),0)/5  as [Amount]
      ,[TransactionType]  as [TransactionType] '+
'FROM        @TempSummaryBet
WHERE     '+@where +' '+
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '

  
  
  
end
else if (@ViewType=1)
begin

--SELECT 0 as totalrow, cast(YEAR([ReportDate]) as nvarchar(4))+'-'+cast(MONTH(ReportDate) as nvarchar(4)) as ReportDate
--      ,case when Parameter.TransactionType.Direction=0 Then SUM(ISNULL(Amount,0))*-1 else  SUM(ISNULL(Amount,0)) end as [Amount]
--      ,ISNULL(Parameter.TransactionType.TransactionType,'')  as TransactionType
--  FROM Report.SummaryCash Inner Join Parameter.TransactionType on 
--  Parameter.TransactionType.TransactionTypeId=Report.SummaryCash.TransactionTypeId
--  GROUP BY Parameter.TransactionType.TransactionType,cast(YEAR([ReportDate]) as nvarchar(4))+'-'+cast(MONTH(ReportDate) as nvarchar(4)),Parameter.TransactionType.Direction


 set @sqlcommand2=' declare @TempSummaryBet table (ReportDate nvarchar(10),Amount money,TransactionType nvarchar(100)) '+
  'insert @TempSummaryBet '+
  'SELECT  cast(YEAR([ReportDate]) as nvarchar(4))+''-''+cast(MONTH(ReportDate) as nvarchar(4))+''-1'' as ReportDate
     ,case when Parameter.TransactionType.Direction=0 Then SUM(ISNULL(Amount,0))*-1 else case when Parameter.TransactionType.TransactionTypeId=35 then SUM(ISNULL(Amount,0))*-1 else  SUM(ISNULL(Amount,0)) end end as [Amount]
      ,ISNULL(Parameter.TransactionType.TransactionType,'''')  as TransactionType
  FROM Report.SummaryCash Inner Join Parameter.TransactionType on 
  Parameter.TransactionType.TransactionTypeId=Report.SummaryCash.TransactionTypeId '+
  @where2 +' and Parameter.TransactionType.TransactionTypeId not in (3,8,4,33,34,36,37,38,39,40,41,42,43)'+
  ' GROUP BY Parameter.TransactionType.TransactionType,cast(YEAR([ReportDate]) as nvarchar(4))+''-''+cast(MONTH(ReportDate) as nvarchar(4)),Parameter.TransactionType.Direction,Parameter.TransactionType.TransactionTypeId ; '
  
  
  
  set @sqlcommand='declare @total int '+
'select @total=COUNT(ReportDate)  '+
'FROM       @TempSummaryBet
WHERE    '+@where +' ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
' cast(YEAR([ReportDate]) as nvarchar(4))+''-''+cast(MONTH(ReportDate) as nvarchar(4)) as ReportDate
      ,ISNULL(dbo.FuncCurrencyConverter([Amount],'+cast(@SystemCurrencyId as nvarchar(3))+','+cast(@UserCurrencyId as nvarchar(3))+'),0)/5 as [Amount]
      ,[TransactionType]  as [TransactionType] '+
'FROM        @TempSummaryBet
WHERE     '+@where +' '+
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '

  
  
 end
 else
 begin 
 
 --SELECT 0 as totalrow, cast(YEAR([ReportDate]) as nvarchar(4)) as ReportDate
 --     ,case when Parameter.TransactionType.Direction=0 Then SUM(ISNULL(Amount,0))*-1 else  SUM(ISNULL(Amount,0)) end as [Amount]
 --     ,ISNULL(Parameter.TransactionType.TransactionType,'')  as TransactionType
 -- FROM Report.SummaryCash Inner Join Parameter.TransactionType on 
 -- Parameter.TransactionType.TransactionTypeId=Report.SummaryCash.TransactionTypeId
 -- GROUP BY Parameter.TransactionType.TransactionType,cast(YEAR([ReportDate]) as nvarchar(4)),Parameter.TransactionType.Direction



 set @sqlcommand2=' declare @TempSummaryBet table (ReportDate nvarchar(10),Amount money,TransactionType nvarchar(100)) '+
  'insert @TempSummaryBet '+
  'SELECT  cast(YEAR([ReportDate]) as nvarchar(4)) as ReportDate
      ,case when Parameter.TransactionType.Direction=0 Then SUM(ISNULL(Amount,0))*-1 else case when Parameter.TransactionType.TransactionTypeId=35 then SUM(ISNULL(Amount,0))*-1 else  SUM(ISNULL(Amount,0)) end end as [Amount]
      ,ISNULL(Parameter.TransactionType.TransactionType,'''')  as TransactionType
  FROM Report.SummaryCash Inner Join Parameter.TransactionType on 
  Parameter.TransactionType.TransactionTypeId=Report.SummaryCash.TransactionTypeId'+
  @where2 +' and Parameter.TransactionType.TransactionTypeId not in (3,8,4,33,34,36,37,38,39,40,41,42,43)'+
  ' GROUP BY Parameter.TransactionType.TransactionType,cast(YEAR([ReportDate]) as nvarchar(4)),Parameter.TransactionType.Direction,Parameter.TransactionType.TransactionTypeId ; '
  
  
  
  set @sqlcommand='declare @total int '+
'select @total=COUNT(ReportDate)  '+
'FROM       @TempSummaryBet
WHERE    '+@where +' ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
' ReportDate as ReportDate
      ,ISNULL(ISNULL(dbo.FuncCurrencyConverter([Amount],'+cast(@SystemCurrencyId as nvarchar(3))+','+cast(@UserCurrencyId as nvarchar(3))+'),0),0)/5  as [Amount]
      ,[TransactionType]  as [TransactionType] '+
'FROM        @TempSummaryBet
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
