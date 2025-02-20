USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcBranchTransaction]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcBranchTransaction] 
 @BranchId bigint,
 @PageSize  INT,
 @PageNum int,
@Username nvarchar(50),
@where nvarchar(1000),
@orderby nvarchar(100),
@LangId int
AS

BEGIN
SET NOCOUNT ON;
declare @sqlcommand nvarchar(max)
declare @UserCurrencyId int
declare @UserBranchId bigint
declare @where2 nvarchar(max)
declare @RoleId int
declare @UserId int
select @UserCurrencyId=Users.Users.CurrencyId,@UserBranchId=Users.Users.UnitCode,@RoleId=RoleId,@UserId=users.Users.UserId from Users.Users with (nolock) INNER JOIN Users.UserRoles with (nolock) ON Users.Users.UserId=Users.UserRoles.UserId  where Users.Users.UserName=@Username


--if(@RoleId<>158)
set @where2=' RiskManagement.BranchTransaction.Isview=1 and (RiskManagement.BranchTransaction.BranchId= '+cast(@BranchId as nvarchar(10))+' or RiskManagement.BranchTransaction.BranchId in (select BranchId from Parameter.Branch with (nolock) where Parameter.Branch.[ParentBranchId]='+cast(@BranchId as nvarchar(10))+') or RiskManagement.BranchTransaction.BranchId in (select BranchId from Parameter.Branch with (nolock) where ParentBranchId in (select BranchId from Parameter.Branch with (nolock) where Parameter.Branch.[ParentBranchId]='+cast(@BranchId as nvarchar(10))+')))'
--else
--set @where2='(RiskManagement.BranchTransaction.BranchId= '+cast(@BranchId as nvarchar(10))+' or RiskManagement.BranchTransaction.BranchId in (select BranchId from Parameter.Branch where Parameter.Branch.[ParentBranchId]='+cast(@BranchId as nvarchar(10))+') or RiskManagement.BranchTransaction.BranchId in (select BranchId from Parameter.Branch where ParentBranchId in (select BranchId from Parameter.Branch where Parameter.Branch.[ParentBranchId]='+cast(@BranchId as nvarchar(10))+')))'+' and RiskManagement.BranchTransaction.UserId='+cast(@UserId as nvarchar(10)) 

if(@BranchId=0)
	if(@RoleId<>158)
		set @where2='  RiskManagement.BranchTransaction.Isview=1 and (RiskManagement.BranchTransaction.BranchId='+cast(@UserBranchId as nvarchar(7))+' or RiskManagement.BranchTransaction.BranchId in (select BranchId from Parameter.Branch with (nolock) where Parameter.Branch.[ParentBranchId]='+cast(@UserBranchId as nvarchar(7))+') or RiskManagement.BranchTransaction.BranchId in (select BranchId from Parameter.Branch with (nolock) where ParentBranchId in (select BranchId from Parameter.Branch with (nolock) where Parameter.Branch.[ParentBranchId]='+cast(@UserBranchId as nvarchar(7))+')))' -- Customer.Customer.BranchId='+cast(@BranchId as nvarchar(7))
	else
		set @where2='  RiskManagement.BranchTransaction.Isview=1 and (RiskManagement.BranchTransaction.UserId='+cast(@UserId as nvarchar(10)) +')'

if(@UserBranchId=32604 )
	set @where2='  RiskManagement.BranchTransaction.Isview=1 '
		 
 set @where=REPLACE(@where,'RiskManagement.BranchTransaction.CreateDate','cast(RiskManagement.BranchTransaction.CreateDate as date)')


--declare @total int 
--select @total=COUNT(RiskManagement.BranchTransaction.BranchTransactionId)  
--from RiskManagement.BranchTransaction INNER JOIN
--Parameter.Branch ON Parameter.Branch.BranchId=RiskManagement.BranchTransaction.BranchId INNER JOIN
--Users.Users On Users.Users.UserId=RiskManagement.BranchTransaction.UserId INNER JOIN 
--Parameter.TransactionTypeBranch ON Parameter.TransactionTypeBranch.BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
--where RiskManagement.BranchTransaction.BranchId=@BranchId  ;
--WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY RiskManagement.BranchTransaction.BranchTransactionId) AS RowNum, 
--	RiskManagement.BranchTransaction.BranchTransactionId,RiskManagement.BranchTransaction.CreateDate,Parameter.Branch.BrancName,RiskManagement.BranchTransaction.UserId,Users.Users.UserName,(select Customer.Customer.Username from Customer.Customer where Customer.Customer.CustomerId=RiskManagement.BranchTransaction.CustomerId) as Customer,Parameter.TransactionTypeBranch.TransactionType,RiskManagement.BranchTransaction.Amount,ISNULL(RiskManagement.BranchTransaction.CashboxBalance,0) as CashboxBalance
--	,Parameter.TransactionTypeBranch.BranchTransactionTypeId
--from RiskManagement.BranchTransaction INNER JOIN
--Parameter.Branch ON Parameter.Branch.BranchId=RiskManagement.BranchTransaction.BranchId INNER JOIN
--Users.Users On Users.Users.UserId=RiskManagement.BranchTransaction.UserId INNER JOIN 
--Parameter.TransactionTypeBranch ON Parameter.TransactionTypeBranch.BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
--where RiskManagement.BranchTransaction.BranchId=@BranchId 

--)  
--SELECT *,@total as totalrow 
--  FROM OrdersRN 
--  WHERE RowNum BETWEEN (@PageNum-1 )*(@PageSize )+1 AND (@PageNum * @PageSize )


if (CHARINDEX('BranchId',@orderby) > 0)
	set @orderby=REPLACE(@orderby,'BranchId','RiskManagement.BranchTransaction.BranchId')

if @orderby='BranchTransactionTypeId asc'
	set @orderby=REPLACE(@orderby,'BranchTransactionTypeId','Parameter.TransactionTypeBranch.BranchTransactionTypeId')

if @orderby='BranchTransactionTypeId desc'
	set @orderby=REPLACE(@orderby,'BranchTransactionTypeId','Parameter.TransactionTypeBranch.BranchTransactionTypeId')

	if @orderby='TransactionType asc' 
	set @orderby=REPLACE(@orderby,'TransactionType','Parameter.TransactionTypeBranch.TransactionType')

		if @orderby='TransactionType desc' 
	set @orderby=REPLACE(@orderby,'TransactionType','Parameter.TransactionTypeBranch.TransactionType')


set @sqlcommand='declare @total int '+
'select @total=COUNT(RiskManagement.BranchTransaction.BranchTransactionId) '+
' from RiskManagement.BranchTransaction with (nolock) INNER JOIN
Parameter.Branch with (nolock) ON Parameter.Branch.BranchId=RiskManagement.BranchTransaction.BranchId INNER JOIN
Users.Users with (nolock) On Users.Users.UserId=RiskManagement.BranchTransaction.UserId INNER JOIN 
Parameter.TransactionTypeBranch with (nolock) ON Parameter.TransactionTypeBranch.BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId INNER JOIN
Language.[Parameter.TransactionTypeBranch] with (nolock) ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=Parameter.TransactionTypeBranch.BranchTransactionTypeId'+
' where   (RiskManagement.BranchTransaction.Amount<>0 or Parameter.TransactionTypeBranch.BranchTransactionTypeId<>6) and Parameter.TransactionTypeBranch.BranchTransactionTypeId<>10  and Language.[Parameter.TransactionTypeBranch].LanguageId='+cast(@LangId as nvarchar(4))+' and '+@where2+'  and '+@where+ '   ;' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum,  '+
' RiskManagement.BranchTransaction.BranchTransactionId,RiskManagement.BranchTransaction.CreateDate,Parameter.Branch.BrancName,RiskManagement.BranchTransaction.UserId,Users.Users.UserName,(select Customer.Customer.Username from Customer.Customer with (nolock) where Customer.Customer.CustomerId=RiskManagement.BranchTransaction.CustomerId) as Customer,Language.[Parameter.TransactionTypeBranch].TransactionType as TransactionType,case when RiskManagement.BranchTransaction.TransactionTypeId<>7 then RiskManagement.BranchTransaction.Amount else  cast(ROUND(RiskManagement.BranchTransaction.Amount+((RiskManagement.BranchTransaction.Amount*5)/100),1) as money) end as Amount,ISNULL(RiskManagement.BranchTransaction.CashboxBalance,0) as CashboxBalance
	,Parameter.TransactionTypeBranch.BranchTransactionTypeId,RiskManagement.BranchTransaction.SlipId,RiskManagement.BranchTransaction.BranchId,(Select top 1 Parameter.Branch.IsTerminal from Parameter.Branch with (nolock) where BranchId=RiskManagement.BranchTransaction.BranchId) as IsTerminal '+
' from RiskManagement.BranchTransaction with (nolock) INNER JOIN
Parameter.Branch with (nolock) ON Parameter.Branch.BranchId=RiskManagement.BranchTransaction.BranchId INNER JOIN
Users.Users with (nolock) On Users.Users.UserId=RiskManagement.BranchTransaction.UserId INNER JOIN 
Parameter.TransactionTypeBranch with (nolock) ON Parameter.TransactionTypeBranch.BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId INNER JOIN
Language.[Parameter.TransactionTypeBranch] with (nolock) ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=Parameter.TransactionTypeBranch.BranchTransactionTypeId '+
' where  (RiskManagement.BranchTransaction.Amount<>0 or Parameter.TransactionTypeBranch.BranchTransactionTypeId<>6) and Parameter.TransactionTypeBranch.BranchTransactionTypeId<>10 and Language.[Parameter.TransactionTypeBranch].LanguageId='+cast(@LangId as nvarchar(4))+' and  '+@where2+'  and '+@where+
 ' ) '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '


exec (@sqlcommand)

END




GO
