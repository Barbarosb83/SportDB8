USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcTerminalTotal]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcTerminalTotal] 
@BranchId int,
@Username nvarchar(50)
AS

BEGIN
SET NOCOUNT ON;
declare @sqlcommand nvarchar(max)
declare @UserCurrencyId int
declare @UserBranchId bigint
declare @where2 nvarchar(max)
declare @RoleId int
declare @UserId int
 
--select @UserCurrencyId=Users.Users.CurrencyId,@RoleId=RoleId,@UserId=users.Users.UserId from Users.Users with (nolock) INNER JOIN Users.UserRoles ON Users.Users.UserId=Users.UserRoles.UserId  where Users.Users.UserName=@Username


declare @TerminalId int
declare @CashboxBalance money
declare @AnonymousBalance money
declare @TerminalUserId int



declare @temptable table (TerminalId int,CashboxBalance money,AnonymousBalance money)

set nocount on
					declare cur111 cursor local for(
					select BranchId,ISNULL(Balance,0),Users.Users.UserId From Parameter.Branch with (nolock)
					INNER JOIN Users.Users with (nolock) ON Users.Users.UnitCode=Parameter.Branch.BranchId 
					INNER JOIN Users.UserRoles with (nolock) ON Users.UserRoles.RoleId=159 
					and Users.UserRoles.UserId=Users.Users.UserId where ParentBranchId=@BranchId

						)

					open cur111
					fetch next from cur111 into @TerminalId,@AnonymousBalance,@TerminalUserId
					while @@fetch_status=0
						begin
							begin

							
							if exists(select top 1 CreateDate from RiskManagement.BranchTransaction with (nolock) where UserId=@TerminalUserId  and TransactionTypeId=6 order by CreateDate desc)
								begin
							select @CashboxBalance =ISNULL(SUM(Amount),0) from RiskManagement.BranchTransaction with (nolock) where  UserId=@TerminalUserId   and TransactionTypeId in (14,1)
							and CreateDate>(
							select top 1 ISNULL(CreateDate,cast(GETDATE() as date)) from RiskManagement.BranchTransaction with (nolock)
								where UserId=@TerminalUserId  and TransactionTypeId=6 order by CreateDate desc)
								end
								else
								begin
									select @CashboxBalance =ISNULL(SUM(Amount),0) from RiskManagement.BranchTransaction with (nolock) where  UserId=@TerminalUserId   and TransactionTypeId in (14,1)
							and CreateDate>DATEADD(DAY,-1,GETDATE())

								end

						 



								insert @temptable
								select @TerminalId,@CashboxBalance,@AnonymousBalance

							end
							fetch next from cur111 into @TerminalId,@AnonymousBalance,@TerminalUserId
			
						end
					close cur111
					deallocate cur111

 





 
	 select  ISNULL(SUM(CashboxBalance),0) as CasboxBalance,ISNULL(SUM(AnonymousBalance),0) as AnonymousBalance from @temptable
 



END




GO
