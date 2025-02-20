USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Report].[ProcBranchCommision]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Report].[ProcBranchCommision] 
 @ViewType int, --0 günlük,1 aylık , 2 yıllık
 @IsBetTypeDetail bit,
 @PageSize  INT,
 @PageNum int,
@Username nvarchar(50),
@where nvarchar(1000),
@orderby nvarchar(100)
AS

BEGIN
SET NOCOUNT ON;

exec [Report].[ProcBranchCommisionFill1]
declare @sqlcommand nvarchar(max)
declare @sqlcommand2 nvarchar(max)

declare @UserCurrencyId int
declare @BranchId int
declare @where2 nvarchar(max)=' and 1=1'

select @BranchId=Users.Users.UnitCode, @UserCurrencyId=Users.Users.CurrencyId from Users.Users where Users.Users.UserName=@Username


if(@BranchId<>1)
	begin

	set @where2=' and BranchId='+cast(@BranchId as nvarchar(7))

	end

--declare @total int =0


--declare @TempSummaryBet table (Id nvarchar(100) ,ReportDate nvarchar(20),BranchId int,BrancName nvarchar(100),Commission money,CurrencyId int,Currency nvarchar(30),BetTypeId int,BetType nvarchar(30))

--select 0 as totalrow,*
--from @TempSummaryBet

--select 0 as totalrow,'' AS Id,CAST(Report.BranchCommissionBalance.EndDate as nvarchar(12)) as ReportDate,Report.BranchCommissionBalance.BranchId
--,Parameter.Branch.BrancName
--, SUM(Amount) as Commission
--,Parameter.Currency.CurrencyId
--,Parameter.Currency.Currency 
--,Parameter.BetType.BetTypeId
--,Parameter.BetType.BetType
--from Report.BranchCommissionBalance INNER JOIN
--Parameter.Branch ON Parameter.Branch.BranchId=Report.BranchCommissionBalance.BranchId INNER JOIN
--Parameter.Currency ON Parameter.Currency.CurrencyId=Report.BranchCommissionBalance.CurrencyId INNER JOIN
--Parameter.BetType ON Parameter.BetType.BetTypeId=Report.BranchCommissionBalance.BetTypeId
--GROUP BY  CAST(CommissionDate as nvarchar(12)) ,Report.BranchCommissionBalance.BranchId
--,Parameter.Branch.BrancName
--,Parameter.Currency.CurrencyId
--,Parameter.Currency.Currency 
--,Parameter.BetType.BetTypeId
--,Parameter.BetType.BetType


if(@ViewType=0)
begin

  if(@IsBetTypeDetail=1)
	begin
			 set @sqlcommand2=' declare @TempSummaryBet table (Id nvarchar(100) ,ReportDate nvarchar(20),BranchId int,BrancName nvarchar(100),TurnOver money,Hold money,CurrencyId int,Currency nvarchar(30),BetTypeId int,BetType nvarchar(30))  '+
			  'insert @TempSummaryBet '+
			  'select NEWID(),CAST(Report.BranchCommission.ReportDate as nvarchar(12)),Report.BranchCommission.BranchId
			,Parameter.Branch.BrancName
			, SUM(Turnover)
			, SUM(Hold)
			,Parameter.Currency.CurrencyId
			,Parameter.Currency.Currency 
			,Parameter.BetType.BetTypeId
			,Parameter.BetType.BetType
			from Report.BranchCommission INNER JOIN
			Parameter.Branch ON Parameter.Branch.BranchId=Report.BranchCommission.BranchId INNER JOIN
			Parameter.Currency ON Parameter.Currency.CurrencyId=Report.BranchCommission.CurrencyId INNER JOIN
			Parameter.BetType ON Parameter.BetType.BetTypeId=Report.BranchCommission.BetTypeId
			GROUP BY  CAST(Report.BranchCommission.ReportDate as nvarchar(12)) ,Report.BranchCommission.BranchId
			,Parameter.Branch.BrancName
			,Parameter.Currency.CurrencyId
			,Parameter.Currency.Currency 
			,Parameter.BetType.BetTypeId
			,Parameter.BetType.BetType ; '
	end
  else
  	begin
			 set @sqlcommand2=' declare @TempSummaryBet table (Id nvarchar(100) ,ReportDate nvarchar(20),BranchId int,BrancName nvarchar(100),TurnOver money,Hold money,CurrencyId int,Currency nvarchar(30),BetTypeId int,BetType nvarchar(30))  '+
			  'insert @TempSummaryBet '+
			  'select NEWID(),CAST(Report.BranchCommission.ReportDate as nvarchar(12)),Report.BranchCommission.BranchId
			,Parameter.Branch.BrancName
			, SUM(Turnover)
			, SUM(Hold)
			,Parameter.Currency.CurrencyId
			,Parameter.Currency.Currency 
			,0
			,''''
			from Report.BranchCommission INNER JOIN
			Parameter.Branch ON Parameter.Branch.BranchId=Report.BranchCommission.BranchId INNER JOIN
			Parameter.Currency ON Parameter.Currency.CurrencyId=Report.BranchCommission.CurrencyId INNER JOIN
			Parameter.BetType ON Parameter.BetType.BetTypeId=Report.BranchCommission.BetTypeId
			GROUP BY  CAST(Report.BranchCommission.ReportDate as nvarchar(12)) ,Report.BranchCommission.BranchId
			,Parameter.Branch.BrancName
			,Parameter.Currency.CurrencyId
			,Parameter.Currency.Currency ; '
	end
  
  set @sqlcommand='declare @total int '+
'select @total=COUNT(Id)  '+
'FROM       @TempSummaryBet
WHERE    '+@where +@where2+' ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
' Id
      ,ReportDate
      ,BranchId
      ,BrancName
      ,TurnOver
	  ,Hold
      ,CurrencyId
      ,Currency
      ,BetTypeId
      ,BetType '+
'FROM        @TempSummaryBet
WHERE     '+@where +@where2+' '+
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '

  
  
  
end
else if (@ViewType=1)
begin


  if(@IsBetTypeDetail=1)
	begin
			 set @sqlcommand2=' declare @TempSummaryBet table (Id nvarchar(100) ,ReportDate nvarchar(20),BranchId int,BrancName nvarchar(100),TurnOver money,Hold money,CurrencyId int,Currency nvarchar(30),BetTypeId int,BetType nvarchar(30))  '+
			  'insert @TempSummaryBet '+
			  'select NEWID()
			  ,CAST(YEAR(Report.BranchCommission.ReportDate)as nvarchar(4))+''-''+cast(MONTH(Report.BranchCommission.ReportDate) as nvarchar(2))+''-01''
			  ,Report.BranchCommission.BranchId
			,Parameter.Branch.BrancName
			, SUM(Turnover)
			, SUM(Hold)
			,Parameter.Currency.CurrencyId
			,Parameter.Currency.Currency 
			,Parameter.BetType.BetTypeId
			,Parameter.BetType.BetType
			from Report.BranchCommission INNER JOIN
			Parameter.Branch ON Parameter.Branch.BranchId=Report.BranchCommission.BranchId INNER JOIN
			Parameter.Currency ON Parameter.Currency.CurrencyId=Report.BranchCommission.CurrencyId INNER JOIN
			Parameter.BetType ON Parameter.BetType.BetTypeId=Report.BranchCommission.BetTypeId
			GROUP BY  CAST(YEAR(Report.BranchCommission.ReportDate)as nvarchar(4))+''-''+cast(MONTH(Report.BranchCommission.ReportDate) as nvarchar(2))+''-01'' ,Report.BranchCommission.BranchId
			,Parameter.Branch.BrancName
			,Parameter.Currency.CurrencyId
			,Parameter.Currency.Currency 
			,Parameter.BetType.BetTypeId
			,Parameter.BetType.BetType ; '
	end
  else
  	begin
			 set @sqlcommand2=' declare @TempSummaryBet table (Id nvarchar(100) ,ReportDate nvarchar(20),BranchId int,BrancName nvarchar(100),TurnOver money,Hold money,CurrencyId int,Currency nvarchar(30),BetTypeId int,BetType nvarchar(30))  '+
			  'insert @TempSummaryBet '+
			  'select NEWID()
			  ,CAST(YEAR(Report.BranchCommission.ReportDate)as nvarchar(4))+''-''+cast(MONTH(Report.BranchCommission.ReportDate) as nvarchar(2))+''-01''
			  ,Report.BranchCommission.BranchId
			,Parameter.Branch.BrancName
			, SUM(Turnover)
			, SUM(Hold)
			,Parameter.Currency.CurrencyId
			,Parameter.Currency.Currency 
			,0
			,''''
			from Report.BranchCommission INNER JOIN
			Parameter.Branch ON Parameter.Branch.BranchId=Report.BranchCommission.BranchId INNER JOIN
			Parameter.Currency ON Parameter.Currency.CurrencyId=Report.BranchCommission.CurrencyId INNER JOIN
			Parameter.BetType ON Parameter.BetType.BetTypeId=Report.BranchCommission.BetTypeId
			GROUP BY  CAST(YEAR(Report.BranchCommission.ReportDate)as nvarchar(4))+''-''+cast(MONTH(Report.BranchCommission.ReportDate) as nvarchar(2))+''-01'' ,Report.BranchCommission.BranchId
			,Parameter.Branch.BrancName
			,Parameter.Currency.CurrencyId
			,Parameter.Currency.Currency ; '
	end
  
  set @sqlcommand='declare @total int '+
'select @total=COUNT(Id)  '+
'FROM       @TempSummaryBet
WHERE    '+@where +@where2+' ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
' Id
      ,cast(ReportDate as nvarchar(6)) as ReportDate
      ,BranchId
      ,BrancName
      ,TurnOver
	  ,Hold
      ,CurrencyId
      ,Currency
      ,BetTypeId
      ,BetType '+
'FROM        @TempSummaryBet
WHERE     '+@where +@where2+' '+
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '

  
  
 end
else 
begin


  if(@IsBetTypeDetail=1)
	begin
			 set @sqlcommand2=' declare @TempSummaryBet table (Id nvarchar(100) ,ReportDate nvarchar(20),BranchId int,BrancName nvarchar(100),TurnOver money,Hold money,CurrencyId int,Currency nvarchar(30),BetTypeId int,BetType nvarchar(30))  '+
			  'insert @TempSummaryBet '+
			  'select NEWID()
			   ,CAST(YEAR(Report.BranchCommission.ReportDate)as nvarchar(4))+''-01-01''
			  ,Report.BranchCommission.BranchId
			,Parameter.Branch.BrancName
			, SUM(Turnover)
			, SUM(Hold)
			,Parameter.Currency.CurrencyId
			,Parameter.Currency.Currency 
			,Parameter.BetType.BetTypeId
			,Parameter.BetType.BetType
			from Report.BranchCommission INNER JOIN
			Parameter.Branch ON Parameter.Branch.BranchId=Report.BranchCommission.BranchId INNER JOIN
			Parameter.Currency ON Parameter.Currency.CurrencyId=Report.BranchCommission.CurrencyId INNER JOIN
			Parameter.BetType ON Parameter.BetType.BetTypeId=Report.BranchCommission.BetTypeId
			GROUP BY  CAST(YEAR(Report.BranchCommission.ReportDate)as nvarchar(4))+''-01-01'' ,Report.BranchCommission.BranchId
			,Parameter.Branch.BrancName
			,Parameter.Currency.CurrencyId
			,Parameter.Currency.Currency 
			,Parameter.BetType.BetTypeId
			,Parameter.BetType.BetType ; '
	end
  else
  	begin
			 set @sqlcommand2=' declare @TempSummaryBet table (Id nvarchar(100) ,ReportDate nvarchar(20),BranchId int,BrancName nvarchar(100),TurnOver money,Hold money,CurrencyId int,Currency nvarchar(30),BetTypeId int,BetType nvarchar(30))  '+
			  'insert @TempSummaryBet '+
			  'select NEWID()
			     ,CAST(YEAR(Report.BranchCommission.ReportDate)as nvarchar(4))+''-01-01''
			  ,Report.BranchCommission.BranchId
			,Parameter.Branch.BrancName
			, SUM(Turnover)
			, SUM(Hold)
			,Parameter.Currency.CurrencyId
			,Parameter.Currency.Currency 
			,0
			,''''
			from Report.BranchCommission INNER JOIN
			Parameter.Branch ON Parameter.Branch.BranchId=Report.BranchCommission.BranchId INNER JOIN
			Parameter.Currency ON Parameter.Currency.CurrencyId=Report.BranchCommission.CurrencyId INNER JOIN
			Parameter.BetType ON Parameter.BetType.BetTypeId=Report.BranchCommission.BetTypeId
			GROUP BY CAST(YEAR(Report.BranchCommission.ReportDate)as nvarchar(4))+''-01-01'' ,Report.BranchCommission.BranchId
			,Parameter.Branch.BrancName
			,Parameter.Currency.CurrencyId
			,Parameter.Currency.Currency ; '
	end
  
  set @sqlcommand='declare @total int '+
'select @total=COUNT(Id)  '+
'FROM       @TempSummaryBet
WHERE    '+@where +@where2+' ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
' Id
      ,cast(ReportDate as nvarchar(4)) as ReportDate
      ,BranchId
      ,BrancName
      ,TurnOver
	  ,Hold
      ,CurrencyId
      ,Currency
      ,BetTypeId
      ,BetType '+
'FROM        @TempSummaryBet
WHERE     '+@where +@where2+' '+
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '

  
  
 end

execute (@sqlcommand2+@sqlcommand)
END



GO
