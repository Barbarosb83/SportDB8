USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcTerminal]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcTerminal] 
 @BranchId bigint,
 @PageSize  INT,
 @PageNum int,
@Username nvarchar(50),
@where nvarchar(1000),
@orderby nvarchar(100)
AS

BEGIN
SET NOCOUNT ON;
declare @sqlcommand nvarchar(max)
--declare @UserCurrencyId int
--declare @UserBranchId bigint
declare @where2 nvarchar(max)
--declare @RoleId int
--declare @UserId int
--select @UserCurrencyId=Users.Users.CurrencyId,@UserBranchId=Users.Users.UnitCode,@RoleId=RoleId,@UserId=users.Users.UserId 
--from Users.Users with (nolock) INNER JOIN Users.UserRoles with (nolock) ON Users.Users.UserId=Users.UserRoles.UserId  where Users.Users.UserName=@Username


declare @TerminalId int
declare @CashboxBalance money
declare @AnonymousBalance money
declare @TerminalUserId int
--if(@RoleId<>158)
--set @where2='RiskManagement.BranchTransaction.BranchId= '+cast(@BranchId as nvarchar(10))
--else
--set @where2='RiskManagement.BranchTransaction.BranchId= '+cast(@BranchId as nvarchar(10)) + ' and RiskManagement.BranchTransaction.UserId='+cast(@UserId as nvarchar(10)) 

--if(@BranchId=0)
--	if(@RoleId<>158)
--		set @where2='  (RiskManagement.BranchTransaction.BranchId='+cast(@UserBranchId as nvarchar(7))+' or RiskManagement.BranchTransaction.BranchId in (select BranchId from Parameter.Branch where Parameter.Branch.[ParentBranchId]='+cast(@UserBranchId as nvarchar(7))+') or RiskManagement.BranchTransaction.BranchId in (select BranchId from Parameter.Branch where ParentBranchId in (select BranchId from Parameter.Branch where Parameter.Branch.[ParentBranchId]='+cast(@UserBranchId as nvarchar(7))+')))' -- Customer.Customer.BranchId='+cast(@BranchId as nvarchar(7))
--	else
--		set @where2='  (RiskManagement.BranchTransaction.UserId='+cast(@UserId as nvarchar(10)) +')'

--set @where2='  (RiskManagement.BranchTransaction.UserId='+cast(@UserId as nvarchar(10)) +')'


declare @temptable table (TerminalId int,CashboxBalance money,AnonymousBalance money)

set nocount on
					declare cur111 cursor local for(
					select BranchId,Balance,Users.Users.UserId From Parameter.Branch with (nolock) 
					INNER JOIN Users.Users with (nolock) ON Users.Users.UnitCode=Parameter.Branch.BranchId 
					INNER JOIN Users.UserRoles ON Users.UserRoles.RoleId=159 and Users.UserRoles.UserId=Users.Users.UserId where ParentBranchId=@BranchId

						)

					open cur111
					fetch next from cur111 into @TerminalId,@AnonymousBalance,@TerminalUserId
					while @@fetch_status=0
						begin
							begin
							if exists (select  CreateDate from RiskManagement.BranchTransaction
								where UserId=@TerminalUserId  and TransactionTypeId=6)
								begin
							select @CashboxBalance =ISNULL(SUM(Amount),0) from RiskManagement.BranchTransaction with (nolock) where  UserId=@TerminalUserId  and TransactionTypeId in (14,1)
							and CreateDate>(
							select top 1 CreateDate from RiskManagement.BranchTransaction with (nolock)
								where UserId=@TerminalUserId  and TransactionTypeId=6 order by CreateDate desc)
								end
								else
								begin
								select @CashboxBalance =ISNULL(SUM(Amount),0) from RiskManagement.BranchTransaction with (nolock) where  UserId=@TerminalUserId  and TransactionTypeId in (14,1)
							
								end

								insert @temptable
								select @TerminalId,@CashboxBalance,@AnonymousBalance

							end
							fetch next from cur111 into @TerminalId,@AnonymousBalance,@TerminalUserId
			
						end
					close cur111
					deallocate cur111

 





declare @total int 
select @total=COUNT(TerminalId)  
from @temptable ;
WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY TerminalId) AS RowNum, 
	TerminalId,CashboxBalance,AnonymousBalance
from @temptable

)  
SELECT *,@total as totalrow 
  FROM OrdersRN 
  WHERE RowNum BETWEEN (@PageNum-1 )*(@PageSize )+1 AND (@PageNum * @PageSize )


----if (CHARINDEX('CreateDate',@where) > 0)
----	set @where=REPLACE(@where,'CreateDate','cast(RiskManagement.BranchTransaction.CreateDate as date)')


--set @sqlcommand='declare @total int '+
--'select @total=COUNT(RiskManagement.BranchTransaction.BranchTransactionId) '+
--' from RiskManagement.BranchTransaction INNER JOIN
--Parameter.Branch ON Parameter.Branch.BranchId=RiskManagement.BranchTransaction.BranchId INNER JOIN
--Users.Users On Users.Users.UserId=RiskManagement.BranchTransaction.UserId INNER JOIN 
--Parameter.TransactionTypeBranch ON Parameter.TransactionTypeBranch.BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId '+
--' where '+@where2+'  and '+@where+ '   ;' +
--'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum,  '+
--' RiskManagement.BranchTransaction.BranchTransactionId,RiskManagement.BranchTransaction.CreateDate,Parameter.Branch.BrancName,RiskManagement.BranchTransaction.UserId,Users.Users.UserName,(select Customer.Customer.Username from Customer.Customer where Customer.Customer.CustomerId=RiskManagement.BranchTransaction.CustomerId) as Customer,Parameter.TransactionTypeBranch.TransactionType,RiskManagement.BranchTransaction.Amount,ISNULL(RiskManagement.BranchTransaction.CashboxBalance,0) as CashboxBalance
--	,Parameter.TransactionTypeBranch.BranchTransactionTypeId,RiskManagement.BranchTransaction.SlipId '+
--' from RiskManagement.BranchTransaction INNER JOIN
--Parameter.Branch ON Parameter.Branch.BranchId=RiskManagement.BranchTransaction.BranchId INNER JOIN
--Users.Users On Users.Users.UserId=RiskManagement.BranchTransaction.UserId INNER JOIN 
--Parameter.TransactionTypeBranch ON Parameter.TransactionTypeBranch.BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId '+
--' where '+@where2+'  and '+@where+
-- ' ) '+  
--'SELECT *,@total as totalrow '+
--  'FROM OrdersRN '+
-- ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '


--execute (@sqlcommand)

END




GO
