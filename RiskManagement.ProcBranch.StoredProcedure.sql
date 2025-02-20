USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcBranch]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [RiskManagement].[ProcBranch]
 @PageSize  INT,
 @PageNum int,
@Username nvarchar(50),
@where nvarchar(1000),
@orderby nvarchar(100),
@LangId int


AS




BEGIN
SET NOCOUNT ON;


declare @UserBranchId int
declare @sqlcommand nvarchar(max)


select @UserBranchId =UnitCode from Users.Users where UserName=@Username

--declare @total int 
-- select @total=COUNT(Parameter.Branch.BranchId)  
-- from Parameter.Branch INNER JOIN 
--Parameter.Currency on Parameter.Currency.CurrencyId=Parameter.Branch.CurrencyId INNER JOIN
--Parameter.BranchCommisionType ON Parameter.BranchCommisionType.BranchCommisionTypeId=Parameter.Branch.BranchCommisionTypeId  
--WHERE 1=1; 
--WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY Parameter.Branch.BranchId) AS RowNum, 
--	Parameter.Branch.BranchId,Parameter.Branch.BrancName,Parameter.Branch.Balance,Parameter.Branch.CommisionRate
--,dbo.UserTimeZoneDate('administrator',Parameter.Branch.CreateDate,0) as CreateDate
--,Parameter.Branch.IsActive,Parameter.Branch.CurrencyId,
--Parameter.Currency.Currency,Parameter.Branch.BranchCommisionTypeId,
--Parameter.Branch.IsBonusDeducting,Parameter.BranchCommisionType.CommissionType,
--Parameter.Branch.MaxWinningLimit,Parameter.Branch.MaxCopySlip,
--Parameter.Branch.BranchId as BrachCode,
--Parameter.Branch.MinTicketLimit,
--Parameter.Branch.MaxEventForTicket
--,(Select PB.BrancName From Parameter.Branch as PB where PB.BranchId=Parameter.Branch.ParentBranchId) as ParentBranch 
--from Parameter.Branch INNER JOIN 
--Parameter.Currency on Parameter.Currency.CurrencyId=Parameter.Branch.CurrencyId INNER JOIN
--Parameter.BranchCommisionType ON Parameter.BranchCommisionType.BranchCommisionTypeId=Parameter.Branch.BranchCommisionTypeId 
--WHERE 1=1
--)   
--SELECT *,@total as totalrow 
--  FROM OrdersRN



if(@UserBranchId<>1)
begin
set @sqlcommand='declare @total int '+
'select @total=COUNT(Parameter.Branch.BranchId) '+
'from Parameter.Branch INNER JOIN 
Parameter.Currency on Parameter.Currency.CurrencyId=Parameter.Branch.CurrencyId INNER JOIN
Parameter.BranchCommisionType ON Parameter.BranchCommisionType.BranchCommisionTypeId=Parameter.Branch.BranchCommisionTypeId '+
'WHERE  Parameter.Branch.ParentBranchId='+cast(@UserBranchId as nvarchar(20))+' and  '+@where +' ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
'	Parameter.Branch.BranchId,Parameter.Branch.BrancName,Parameter.Branch.Balance,Parameter.Branch.CommisionRate
,dbo.UserTimeZoneDate('''+@Username+''',Parameter.Branch.CreateDate,0) as CreateDate
,Parameter.Branch.IsActive,Parameter.Branch.CurrencyId,
Parameter.Currency.Currency,Parameter.Branch.BranchCommisionTypeId,
Parameter.Branch.IsTerminal as IsBonusDeducting,Parameter.BranchCommisionType.CommissionType,Parameter.Branch.MaxWinningLimit,Parameter.Branch.MaxCopySlip,Parameter.Branch.BranchId as BrachCode,Parameter.Branch.MinTicketLimit,
Parameter.Branch.MaxEventForTicket,(Select PB.BrancName From Parameter.Branch as PB where PB.BranchId=Parameter.Branch.ParentBranchId) as ParentBranch ,Parameter.Branch.IsWebPos '+
'from Parameter.Branch INNER JOIN 
Parameter.Currency on Parameter.Currency.CurrencyId=Parameter.Branch.CurrencyId INNER JOIN
Parameter.BranchCommisionType ON Parameter.BranchCommisionType.BranchCommisionTypeId=Parameter.Branch.BranchCommisionTypeId '+
'WHERE  Parameter.Branch.ParentBranchId='+cast(@UserBranchId as nvarchar(20))+' and  '+@where +
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '
 end
 else
 begin
 set @sqlcommand='declare @total int '+
'select @total=COUNT(Parameter.Branch.BranchId) '+
'from Parameter.Branch INNER JOIN 
Parameter.Currency on Parameter.Currency.CurrencyId=Parameter.Branch.CurrencyId INNER JOIN
Parameter.BranchCommisionType ON Parameter.BranchCommisionType.BranchCommisionTypeId=Parameter.Branch.BranchCommisionTypeId '+
'WHERE  '+@where +' ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
'	Parameter.Branch.BranchId,Parameter.Branch.BrancName,Parameter.Branch.Balance,Parameter.Branch.CommisionRate
,dbo.UserTimeZoneDate('''+@Username+''',Parameter.Branch.CreateDate,0) as CreateDate
,Parameter.Branch.IsActive,Parameter.Branch.CurrencyId,
Parameter.Currency.Currency,Parameter.Branch.BranchCommisionTypeId,
Parameter.Branch.IsTerminal as IsBonusDeducting,Parameter.BranchCommisionType.CommissionType,Parameter.Branch.MaxWinningLimit,Parameter.Branch.MaxCopySlip,Parameter.Branch.BranchId as BrachCode,Parameter.Branch.MinTicketLimit,
Parameter.Branch.MaxEventForTicket,(Select PB.BrancName From Parameter.Branch as PB where PB.BranchId=Parameter.Branch.ParentBranchId) as ParentBranch ,Parameter.Branch.IsWebPos '+
'from Parameter.Branch INNER JOIN 
Parameter.Currency on Parameter.Currency.CurrencyId=Parameter.Branch.CurrencyId INNER JOIN
Parameter.BranchCommisionType ON Parameter.BranchCommisionType.BranchCommisionTypeId=Parameter.Branch.BranchCommisionTypeId '+
'WHERE 1=1 and  '+@where +
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '

 end

execute (@sqlcommand) 



END




GO
