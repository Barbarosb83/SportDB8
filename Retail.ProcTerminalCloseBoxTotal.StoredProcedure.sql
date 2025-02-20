USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcTerminalCloseBoxTotal]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcTerminalCloseBoxTotal]
@BranchId int,
@LangId int

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
		 


declare @TerminalDeposit decimal(18,2)=0
declare @TerminalCustomerDeposit decimal(18,2)=0
declare @SumDeposit decimal(18,2)=0
declare @BranchInfo nvarchar(250)=''
 

declare @CheckDate nvarchar(100)
declare @TerminalWthdraw decimal(18,2)=0
declare @TerminalCustomerWithdraw decimal(18,2)=0
declare @TerminalId int
 
declare @AnonymousBalance money

		declare @CashboxBalance money=0						
declare @CashboxCloseDate datetime
declare @UserCurrencyId int
 


declare @temptable table (TerminalId int,TerminalDeposit money,TerminalCustomerDeposit money,SumDeposit money,CasboxCloseDate datetime)

set nocount on
					declare cur111 cursor local for(
					select BranchId,ISNULL(Balance,0) From Parameter.Branch with (nolock)  where ParentBranchId=@BranchId and IsTerminal=1

						)

					open cur111
					fetch next from cur111 into @TerminalId,@AnonymousBalance 
					while @@fetch_status=0
						begin
							begin
								
	 
select top 1 @UserRoleId=Users.UserRoles.RoleId,@UserId=Users.Users.UserId,@UserBranchId=Users.Users.UnitCode 
from Users.UserRoles with (nolock) INNER JOIN Users.Users with (nolock) ON Users.UserRoles.UserId=Users.Users.UserId where UnitCode=@TerminalId

  
declare @CashboxNumber bigint=1
 declare @TempSummaryBet table (Id int,TransactionTypeId int,TransactionType nvarchar(50),Amount Money) 
  

  if (select Count(CreateDate) from RiskManagement.BranchTransaction with (nolock) where UserId=@UserId and TransactionTypeId=6 )>0
		select   @CashboxCloseDate=MAX(CreateDate),@CashboxNumber=COUNT(CreateDate)+1 from RiskManagement.BranchTransaction with (nolock) where UserId=@UserId and TransactionTypeId=6  
else
						select top 1 @CashboxCloseDate=MIN(DATEADD(MINUTE,-1,CreateDate)),@CashboxNumber=COUNT(CreateDate)+1 from RiskManagement.BranchTransaction where BranchId=@TerminalId and TransactionTypeId=14 


if(  select COUNT(RiskManagement.BranchTransaction.TransactionTypeId) --Customer Deposit
from RiskManagement.BranchTransaction with (nolock) INNER JOIN Language.[Parameter.TransactionTypeBranch] with (nolock)
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where UserId=@UserId and TransactionTypeId=1 and LanguageId=@LangId
and CreateDate >@CashboxCloseDate
GROUP BY Language.[Parameter.TransactionTypeBranch].TransactionType,RiskManagement.BranchTransaction.TransactionTypeId)>0
	begin
		  insert @TempSummaryBet
		  select 1,RiskManagement.BranchTransaction.TransactionTypeId,Language.[Parameter.TransactionTypeBranch].TransactionType,ISNULL(SUM(dbo.FuncCurrencyConverter(ISNULL(Amount,0),CurrencyId,@UserCurrencyId)),0) 
		from RiskManagement.BranchTransaction with (nolock) INNER JOIN Language.[Parameter.TransactionTypeBranch] with (nolock)
		ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
		where UserId=@UserId and TransactionTypeId=1 and LanguageId=@LangId
		and CreateDate >@CashboxCloseDate
		GROUP BY Language.[Parameter.TransactionTypeBranch].TransactionType,RiskManagement.BranchTransaction.TransactionTypeId
	end
else
	begin
		 insert @TempSummaryBet
		select 1,Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId,Language.[Parameter.TransactionTypeBranch].TransactionType,0
		from Language.[Parameter.TransactionTypeBranch] with (nolock)
		where  Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=1 and LanguageId=@LangId


	end

if(  select COUNT(RiskManagement.BranchTransaction.TransactionTypeId) --Terminal Deposit
from RiskManagement.BranchTransaction with (nolock) INNER JOIN Language.[Parameter.TransactionTypeBranch] with (nolock)
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where UserId=@UserId and TransactionTypeId=14 and LanguageId=@LangId
and CreateDate >@CashboxCloseDate
GROUP BY Language.[Parameter.TransactionTypeBranch].TransactionType,RiskManagement.BranchTransaction.TransactionTypeId)>0
	begin
		  insert @TempSummaryBet
		  select 4,RiskManagement.BranchTransaction.TransactionTypeId,Language.[Parameter.TransactionTypeBranch].TransactionType,ISNULL(SUM(dbo.FuncCurrencyConverter(ISNULL(Amount,0),CurrencyId,@UserCurrencyId)),0) 
		from RiskManagement.BranchTransaction with (nolock) INNER JOIN Language.[Parameter.TransactionTypeBranch] with (nolock)
		ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
		where UserId=@UserId and TransactionTypeId=14 and LanguageId=@LangId
		and CreateDate >@CashboxCloseDate
		GROUP BY Language.[Parameter.TransactionTypeBranch].TransactionType,RiskManagement.BranchTransaction.TransactionTypeId
	end
else
	begin
		 insert @TempSummaryBet
		select 4,Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId,Language.[Parameter.TransactionTypeBranch].TransactionType,0
		from Language.[Parameter.TransactionTypeBranch] with (nolock)
		where  Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=14 and LanguageId=@LangId


	end



if(select COUNT(RiskManagement.BranchTransaction.BranchTransactionId) -- Customer Withdraw
from RiskManagement.BranchTransaction with (nolock) INNER JOIN Language.[Parameter.TransactionTypeBranch] with (nolock)
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where UserId=@UserId and TransactionTypeId=2 and LanguageId=@LangId
and CreateDate >@CashboxCloseDate
GROUP BY Language.[Parameter.TransactionTypeBranch].TransactionType,RiskManagement.BranchTransaction.TransactionTypeId
)>0
	begin
		 insert @TempSummaryBet
		select 2,RiskManagement.BranchTransaction.TransactionTypeId,Language.[Parameter.TransactionTypeBranch].TransactionType,SUM(dbo.FuncCurrencyConverter(ISNULL(Amount,0),CurrencyId,@UserCurrencyId)) 
		from RiskManagement.BranchTransaction with (nolock) INNER JOIN Language.[Parameter.TransactionTypeBranch] with (nolock)
		ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
		where UserId=@UserId and TransactionTypeId=2 and LanguageId=@LangId
		and CreateDate >@CashboxCloseDate
		GROUP BY Language.[Parameter.TransactionTypeBranch].TransactionType,RiskManagement.BranchTransaction.TransactionTypeId
	end
else
	begin
			 insert @TempSummaryBet
		select 2,Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId,Language.[Parameter.TransactionTypeBranch].TransactionType,0
		from Language.[Parameter.TransactionTypeBranch] with (nolock)
		where  Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=2 and LanguageId=@LangId
		
	end


if(  select COUNT(RiskManagement.BranchTransaction.TransactionTypeId) --Terminal Withdraw
from RiskManagement.BranchTransaction with (nolock) INNER JOIN Language.[Parameter.TransactionTypeBranch] with (nolock)
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where UserId=@UserId and TransactionTypeId=15 and LanguageId=@LangId
and CreateDate >@CashboxCloseDate
GROUP BY Language.[Parameter.TransactionTypeBranch].TransactionType,RiskManagement.BranchTransaction.TransactionTypeId)>0
	begin
		  insert @TempSummaryBet
		  select 5,RiskManagement.BranchTransaction.TransactionTypeId,Language.[Parameter.TransactionTypeBranch].TransactionType,ISNULL(SUM(dbo.FuncCurrencyConverter(ISNULL(Amount,0),CurrencyId,@UserCurrencyId)),0) 
		from RiskManagement.BranchTransaction with (nolock) INNER JOIN Language.[Parameter.TransactionTypeBranch] with (nolock)
		ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
		where UserId=@UserId and TransactionTypeId=15 and LanguageId=@LangId
		and CreateDate >@CashboxCloseDate
		GROUP BY Language.[Parameter.TransactionTypeBranch].TransactionType,RiskManagement.BranchTransaction.TransactionTypeId
	end
else
	begin
		 insert @TempSummaryBet
		select 5,Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId,Language.[Parameter.TransactionTypeBranch].TransactionType,0
		from Language.[Parameter.TransactionTypeBranch] with (nolock)
		where  Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=15 and LanguageId=@LangId


	end


 insert @TempSummaryBet
select 7,7,'Bet TurnOver' as TransactionType,ISNULL(SUM(dbo.FuncCurrencyConverter(ISNULL(Amount,0),CurrencyId,@UserCurrencyId)),0)
from RiskManagement.BranchTransaction with (nolock) INNER JOIN Language.[Parameter.TransactionTypeBranch] with (nolock)
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where UserId=@UserId and TransactionTypeId=7 and LanguageId=@LangId
and CreateDate >@CashboxCloseDate


 insert @TempSummaryBet
select 8,107,'Tax' as TransactionType,ISNULL(SUM(dbo.FuncCurrencyConverter(ISNULL(Amount,0),CurrencyId,@UserCurrencyId)),0)
from RiskManagement.BranchTransaction with (nolock) INNER JOIN Language.[Parameter.TransactionTypeBranch] with (nolock)
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where UserId=@UserId and TransactionTypeId=10 and LanguageId=@LangId
and CreateDate >@CashboxCloseDate


 insert @TempSummaryBet
select 9,108,'Bet PayOuts' as TransactionType,ISNULL(SUM(dbo.FuncCurrencyConverter((Amount),CurrencyId,@UserCurrencyId)),0) 
from RiskManagement.BranchTransaction with (nolock) INNER JOIN Language.[Parameter.TransactionTypeBranch] with (nolock)
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where UserId=@UserId and TransactionTypeId in (8,11,12) and LanguageId=@LangId
and CreateDate >@CashboxCloseDate

 insert @TempSummaryBet
select 12,112,'Credit Voucher',ISNULL(SUM(dbo.FuncCurrencyConverter((Amount),CurrencyId,@UserCurrencyId)),0) 
from RiskManagement.BranchTransaction with (nolock)  INNER JOIN Language.[Parameter.TransactionTypeBranch] with (nolock)
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where UserId=@UserId and TransactionTypeId=16 and LanguageId=@LangId
and CreateDate >@CashboxCloseDate

-- insert @TempSummaryBet
--select 10,109,'Bet cancellations',ISNULL(SUM(dbo.FuncCurrencyConverter((Amount),CurrencyId,@UserCurrencyId)),0) 
--from RiskManagement.BranchTransaction INNER JOIN Language.[Parameter.TransactionTypeBranch]
--ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
--where UserId=@UserId and TransactionTypeId=9 and LanguageId=@LangId
--and CreateDate >@CashboxCloseDate





--select top 1 @CashboxBalance=ISNULL(RiskManagement.BranchTransaction.CashboxBalance,0) from RiskManagement.BranchTransaction
--						where UserId=@UserId and BranchId=@BranchId order by CreateDate desc


insert @TempSummaryBet
select 3,110,'Customer Total',(select Amount From @TempSummaryBet where Id=1)-(select Amount From @TempSummaryBet where Id=2) as Amount

insert @TempSummaryBet
select 6,110,'Terminal Total',(select Amount From @TempSummaryBet where Id=4)-(select ISNULL(Amount,0) From @TempSummaryBet where Id=5) as Amount





--insert RiskManagement.BranchTransaction (BranchId,CustomerId,TransactionTypeId,Amount,CurrencyId,CreateDate,UserId,[CashboxBalance])
--								values(@TerminalId,null,6,(select ISNULL(SUM(Amount),0) From @TempSummaryBet where Id=11)+(select ISNULL(SUM(Amount),0) From @TempSummaryBet where Id=3)-(select ISNULL(SUM(Amount),0) From @TempSummaryBet where TransactionTypeId=112)+(select ISNULL(SUM(Amount),0) From @TempSummaryBet where Id=2),@UserCurrencyId,GETDATE(),@UserId,0)


								
delete @TempSummaryBet
							end
							fetch next from cur111 into @TerminalId,@AnonymousBalance 
			
						end
					close cur111
					deallocate cur111

 



	select @resultcode as resultcode,@resultmessage as resultmessage

		 
END




GO
