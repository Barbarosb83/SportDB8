USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcTerminalCheckTotal]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcTerminalCheckTotal]
@BranchId int,
@LangId int,
@username nvarchar(max)


AS




BEGIN
SET NOCOUNT ON;

declare @OldValues nvarchar(max)
declare @resultcode bigint=106
declare @resultmessage nvarchar(max)='Hata oluştu'
declare @BranchBalance money=0
declare @ParentBranchBalance money
declare @Control int=0
declare @UserId int
declare @UserRoleId int
declare @UserBranchId int 
declare @CurrenyId int
declare @CustomerId bigint
select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId
		 
	 
select @UserRoleId=Users.UserRoles.RoleId,@UserId=Users.Users.UserId,@UserBranchId=Users.Users.UnitCode from Users.UserRoles INNER JOIN Users.Users ON Users.UserRoles.UserId=Users.Users.UserId where UserName=@username

 

declare @TerminalDeposit decimal(18,2)=0
declare @TerminalCustomerDeposit decimal(18,2)=0
declare @SumDeposit decimal(18,2)=0
declare @BranchInfo nvarchar(250)=''
declare @CashboxCloseDate datetime

declare @CheckDate nvarchar(100)
declare @TerminalWthdraw decimal(18,2)=0
declare @TerminalCustomerWithdraw decimal(18,2)=0
declare @TerminalId int
declare @CashboxBalance money
declare @AnonymousBalance money



declare @temptable table (TerminalId int,TerminalDeposit money,TerminalCustomerDeposit money,SumDeposit money,CasboxCloseDate datetime)

set nocount on
					declare cur111 cursor local for(
					select BranchId,ISNULL(Balance,0) From Parameter.Branch  where ParentBranchId=@BranchId and IsTerminal=1

						)

					open cur111
					fetch next from cur111 into @TerminalId,@AnonymousBalance 
					while @@fetch_status=0
						begin
							begin
							 if (select Count(CreateDate) from RiskManagement.BranchTransaction where BranchId=@TerminalId and TransactionTypeId=6 )>0
		select top 1 @CashboxCloseDate=CreateDate from RiskManagement.BranchTransaction where BranchId=@TerminalId and TransactionTypeId=6 order by CreateDate desc
else
	select top 1 @CashboxCloseDate=CreateDate from RiskManagement.BranchTransaction where BranchId=@TerminalId and TransactionTypeId=3 order by CreateDate desc
	if (@CashboxCloseDate is null)
	set @CashboxCloseDate=DATEADD(DAY,-1,GETDATE())
							  --set @CheckDate= convert(varchar(20), @CashboxCloseDate,113)+' - '+convert(varchar(20), GETDATE(),113)

							  select @CustomerId=CustomerId from Customer.Customer where BranchId=@TerminalId and IsBranchCustomer=1

select @TerminalDeposit=ISNULL(SUM(Amount),0) from RiskManagement.BranchTransaction where BranchId=@TerminalId and TransactionTypeId in (14) and CustomerId=@CustomerId and CreateDate>@CashboxCloseDate

select @TerminalCustomerDeposit=ISNULL(SUM(Amount),0) from RiskManagement.BranchTransaction where BranchId=@TerminalId and TransactionTypeId=1 and CustomerId<>@CustomerId and CreateDate>@CashboxCloseDate

set @SumDeposit=(@TerminalDeposit+@TerminalCustomerDeposit)-(@TerminalCustomerWithdraw+@TerminalWthdraw)
								
								insert @temptable
								select @TerminalId,@TerminalDeposit,@TerminalCustomerDeposit,@SumDeposit,@CashboxCloseDate

							end
							fetch next from cur111 into @TerminalId,@AnonymousBalance 
			
						end
					close cur111
					deallocate cur111

 

		
		
		select ISNULL(SUM(TerminalCustomerDeposit),0) as CustomerDeposit
		,ISNULL(SUM(TerminalDeposit),0) as TerminalDeposit
		,ISNULL(SUM(SumDeposit),0) as SumDeposit
		,convert(varchar(20), ISNULL(MIN(DATEADD(HOUR,2,CasboxCloseDate)),GETDATE()),113)+' - '+convert(varchar(20), DATEADD(HOUR,2,GETDATE()),113) as CheckDate
		
		from @temptable
		

		 
END




GO
