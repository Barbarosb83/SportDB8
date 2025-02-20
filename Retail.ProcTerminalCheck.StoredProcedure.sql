USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcTerminalCheck]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcTerminalCheck]
@TerminalId int,
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

select @CustomerId=CustomerId from Customer.Customer where BranchId=@TerminalId

declare @TerminalDeposit decimal(18,2)=0
declare @TerminalCustomerDeposit decimal(18,2)=0
declare @SumDeposit decimal(18,2)=0
declare @BranchInfo nvarchar(250)=''
declare @CashboxCloseDate datetime
declare @BranchId int
declare @CheckDate nvarchar(100)
declare @TerminalWthdraw decimal(18,2)=0
declare @TerminalCustomerWithdraw decimal(18,2)=0

--select @BranchId=BranchId,@BranchInfo=[Address] from Parameter.Branch where BranchId=(select PB.ParentBranchId from Parameter.Branch as PB where PB.BranchId=@TerminalId)
select @BranchId=BranchId,@BranchInfo=Parameter.Branch.BrancName from Parameter.Branch where BranchId=@TerminalId
   if (select Count(CreateDate) from RiskManagement.BranchTransaction where BranchId=@TerminalId and TransactionTypeId=6 )>0
		select top 1 @CashboxCloseDate=CreateDate from RiskManagement.BranchTransaction where BranchId=@TerminalId and TransactionTypeId=6 order by CreateDate desc
else
	select top 1 @CashboxCloseDate=DATEADD(HOUR,2,CreateDate) from RiskManagement.BranchTransaction where BranchId=@TerminalId and TransactionTypeId=3 order by CreateDate desc

 
 set @CheckDate= convert(varchar(20), DATEADD(HOUR,2,@CashboxCloseDate),113)+' - '+convert(varchar(20),DATEADD(HOUR,2,GETDATE()),113)

select @TerminalDeposit=ISNULL(SUM(Amount),0) from RiskManagement.BranchTransaction where BranchId=@TerminalId and TransactionTypeId=14 and CustomerId=@CustomerId
 and BranchTransactionId>ISNULL((select top 1 BranchTransactionId from RiskManagement.BranchTransaction where BranchId=@TerminalId and TransactionTypeId=6
  order by BranchTransactionId desc),1)

select @TerminalCustomerDeposit=ISNULL(SUM(Amount),0) from RiskManagement.BranchTransaction where BranchId=@TerminalId and TransactionTypeId=1 and CustomerId<>@CustomerId and BranchTransactionId>(select top 1 BranchTransactionId from RiskManagement.BranchTransaction where BranchId=@TerminalId and TransactionTypeId=6 order by BranchTransactionId desc)

--select @TerminalWthdraw=ISNULL(SUM(Amount),0) from RiskManagement.BranchTransaction where BranchId=@TerminalId and TransactionTypeId=15 and CustomerId=@CustomerId and BranchTransactionId>(select top 1 BranchTransactionId from RiskManagement.BranchTransaction where BranchId=@TerminalId and TransactionTypeId=6 order by BranchTransactionId desc)

--select @TerminalCustomerWithdraw=ISNULL(SUM(Amount),0) from RiskManagement.BranchTransaction where BranchId=@TerminalId and TransactionTypeId=5 and CustomerId<>@CustomerId and BranchTransactionId>(select top 1 BranchTransactionId from RiskManagement.BranchTransaction where BranchId=@TerminalId and TransactionTypeId=6 order by BranchTransactionId desc)

set @SumDeposit=(@TerminalDeposit+@TerminalCustomerDeposit)-(@TerminalCustomerWithdraw+@TerminalWthdraw)
		
		
		select @TerminalCustomerDeposit as CustomerDeposit
		,@TerminalDeposit as TerminalDeposit
		,@SumDeposit as SumDeposit
		,ISNULL(@CheckDate,convert(varchar(20), GETDATE(),113)) as CheckDate
		,@BranchInfo as BranchInfo
		,@TerminalId as BranchId
		,@TerminalCustomerWithdraw as CustomerWithdraw
		,@TerminalWthdraw as TerminalWithdraw
		

		 
END




GO
