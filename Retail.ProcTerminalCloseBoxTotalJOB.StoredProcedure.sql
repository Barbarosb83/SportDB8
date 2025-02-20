USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcTerminalCloseBoxTotalJOB]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Retail].[ProcTerminalCloseBoxTotalJOB]
 
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
 


declare @TerminalDeposit decimal(18,2)=0
declare @TerminalCustomerDeposit decimal(18,2)=0
declare @SumDeposit decimal(18,2)=0
declare @BranchInfo nvarchar(250)=''
 
 declare @TransId bigint
declare @CheckDate nvarchar(100)
declare @TerminalWthdraw decimal(18,2)=0
declare @TerminalCustomerWithdraw decimal(18,2)=0
declare @TerminalId int
 declare @addhour int=1
declare @AnonymousBalance money

		declare @CashboxBalance money=0						
declare @CashboxCloseDate datetime
declare @UserCurrencyId int
 declare @LangId int=3
 declare @Getdate datetime
 declare @Username nvarchar(100)
declare @temptable table (TerminalId int,TerminalDeposit money,TerminalCustomerDeposit money,SumDeposit money,CasboxCloseDate datetime)

set nocount on
					declare cur111 cursor local for(
					select BranchId,ISNULL(Balance,0) From Parameter.Branch  where   IsTerminal=1 

						)

					open cur111
					fetch next from cur111 into @TerminalId,@AnonymousBalance 
					while @@fetch_status=0
						begin
							begin
								
	 
select top 1 @UserRoleId=Users.UserRoles.RoleId,@UserId=Users.Users.UserId,@UserBranchId=Users.Users.UnitCode,@Username=UserName from Users.UserRoles INNER JOIN Users.Users ON Users.UserRoles.UserId=Users.Users.UserId where UnitCode=@TerminalId

  set @Getdate=GETDATE()
declare @CashboxNumber bigint=1
 declare @TempSummaryBet table (Id int,TransactionTypeId int,TransactionType nvarchar(50),Amount Money) 
  

  if (select Count(CreateDate) from RiskManagement.BranchTransaction where UserId=@UserId and TransactionTypeId=6 )>0
		select   @CashboxCloseDate=MAX(CreateDate),@CashboxNumber=COUNT(CreateDate)+1 from RiskManagement.BranchTransaction where UserId=@UserId and TransactionTypeId=6  
else
						select top 1 @CashboxCloseDate=MIN(DATEADD(MINUTE,-1,CreateDate)),@CashboxNumber=COUNT(CreateDate)+1 from RiskManagement.BranchTransaction where BranchId=@TerminalId and TransactionTypeId=14 

insert  [RiskManagement].[TerminalCloseBoxReport] ([BranchId],UserId,[Username],[CreateDate]) values (@TerminalId,@UserId,@Username,@Getdate)

if(  select COUNT(RiskManagement.BranchTransaction.TransactionTypeId) --Customer Deposit
from RiskManagement.BranchTransaction INNER JOIN Language.[Parameter.TransactionTypeBranch]
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where UserId=@UserId and TransactionTypeId=1 and LanguageId=@LangId
and CreateDate >@CashboxCloseDate
GROUP BY Language.[Parameter.TransactionTypeBranch].TransactionType,RiskManagement.BranchTransaction.TransactionTypeId)>0
	begin
		  insert @TempSummaryBet
		  select 1,RiskManagement.BranchTransaction.TransactionTypeId,Language.[Parameter.TransactionTypeBranch].TransactionType,ISNULL(SUM(dbo.FuncCurrencyConverter(ISNULL(Amount,0),CurrencyId,@UserCurrencyId)),0) 
		from RiskManagement.BranchTransaction INNER JOIN Language.[Parameter.TransactionTypeBranch]
		ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
		where UserId=@UserId and TransactionTypeId=1 and LanguageId=@LangId
		and CreateDate >@CashboxCloseDate
		GROUP BY Language.[Parameter.TransactionTypeBranch].TransactionType,RiskManagement.BranchTransaction.TransactionTypeId
	end
else
	begin
		 insert @TempSummaryBet
		select 1,Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId,Language.[Parameter.TransactionTypeBranch].TransactionType,0
		from Language.[Parameter.TransactionTypeBranch]
		where  Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=1 and LanguageId=@LangId


	end

	update [RiskManagement].[TerminalCloseBoxReport] set [CustomerDeposit]= ISNULL(( select Amount from @TempSummaryBet where Id=1),0) where [BranchId]=@TerminalId and [CreateDate]=@Getdate

if(  select COUNT(RiskManagement.BranchTransaction.TransactionTypeId) --Terminal Deposit
from RiskManagement.BranchTransaction INNER JOIN Language.[Parameter.TransactionTypeBranch]
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where UserId=@UserId and TransactionTypeId=14 and LanguageId=@LangId
and CreateDate >@CashboxCloseDate
GROUP BY Language.[Parameter.TransactionTypeBranch].TransactionType,RiskManagement.BranchTransaction.TransactionTypeId)>0
	begin
		  insert @TempSummaryBet
		  select 4,RiskManagement.BranchTransaction.TransactionTypeId,Language.[Parameter.TransactionTypeBranch].TransactionType,ISNULL(SUM(dbo.FuncCurrencyConverter(ISNULL(Amount,0),CurrencyId,@UserCurrencyId)),0) 
		from RiskManagement.BranchTransaction INNER JOIN Language.[Parameter.TransactionTypeBranch]
		ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
		where UserId=@UserId and TransactionTypeId=14 and LanguageId=@LangId
		and CreateDate >@CashboxCloseDate
		GROUP BY Language.[Parameter.TransactionTypeBranch].TransactionType,RiskManagement.BranchTransaction.TransactionTypeId
	end
else
	begin
		 insert @TempSummaryBet
		select 4,Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId,Language.[Parameter.TransactionTypeBranch].TransactionType,0
		from Language.[Parameter.TransactionTypeBranch]
		where  Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=14 and LanguageId=@LangId


	end
	update [RiskManagement].[TerminalCloseBoxReport] set TerminalDeposit= ISNULL(( select Amount from @TempSummaryBet where Id=4),0) where [BranchId]=@TerminalId and [CreateDate]=@Getdate



if(select COUNT(RiskManagement.BranchTransaction.BranchTransactionId) -- Customer Withdraw
from RiskManagement.BranchTransaction INNER JOIN Language.[Parameter.TransactionTypeBranch]
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where UserId=@UserId and TransactionTypeId=2 and LanguageId=@LangId
and CreateDate >@CashboxCloseDate
GROUP BY Language.[Parameter.TransactionTypeBranch].TransactionType,RiskManagement.BranchTransaction.TransactionTypeId
)>0
	begin
		 insert @TempSummaryBet
		select 2,RiskManagement.BranchTransaction.TransactionTypeId,Language.[Parameter.TransactionTypeBranch].TransactionType,SUM(dbo.FuncCurrencyConverter(ISNULL(Amount,0),CurrencyId,@UserCurrencyId)) 
		from RiskManagement.BranchTransaction INNER JOIN Language.[Parameter.TransactionTypeBranch]
		ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
		where UserId=@UserId and TransactionTypeId=2 and LanguageId=@LangId
		and CreateDate >@CashboxCloseDate
		GROUP BY Language.[Parameter.TransactionTypeBranch].TransactionType,RiskManagement.BranchTransaction.TransactionTypeId
	end
else
	begin
			 insert @TempSummaryBet
		select 2,Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId,Language.[Parameter.TransactionTypeBranch].TransactionType,0
		from Language.[Parameter.TransactionTypeBranch]
		where  Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=2 and LanguageId=@LangId
		
	end
		update [RiskManagement].[TerminalCloseBoxReport] set CustomerWithdraw= ISNULL(( select Amount from @TempSummaryBet where Id=2),0) where [BranchId]=@TerminalId and [CreateDate]=@Getdate


if(  select COUNT(RiskManagement.BranchTransaction.TransactionTypeId) --Terminal Withdraw
from RiskManagement.BranchTransaction INNER JOIN Language.[Parameter.TransactionTypeBranch]
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where UserId=@UserId and TransactionTypeId=15 and LanguageId=@LangId
and CreateDate >@CashboxCloseDate
GROUP BY Language.[Parameter.TransactionTypeBranch].TransactionType,RiskManagement.BranchTransaction.TransactionTypeId)>0
	begin
		  insert @TempSummaryBet
		  select 5,RiskManagement.BranchTransaction.TransactionTypeId,Language.[Parameter.TransactionTypeBranch].TransactionType,ISNULL(SUM(dbo.FuncCurrencyConverter(ISNULL(Amount,0),CurrencyId,@UserCurrencyId)),0) 
		from RiskManagement.BranchTransaction INNER JOIN Language.[Parameter.TransactionTypeBranch]
		ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
		where UserId=@UserId and TransactionTypeId=15 and LanguageId=@LangId
		and CreateDate >@CashboxCloseDate
		GROUP BY Language.[Parameter.TransactionTypeBranch].TransactionType,RiskManagement.BranchTransaction.TransactionTypeId
	end
else
	begin
		 insert @TempSummaryBet
		select 5,Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId,Language.[Parameter.TransactionTypeBranch].TransactionType,0
		from Language.[Parameter.TransactionTypeBranch]
		where  Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=15 and LanguageId=@LangId


	end
	update [RiskManagement].[TerminalCloseBoxReport] set TerminalWithdraw= ISNULL(( select Amount from @TempSummaryBet where Id=5),0) where [BranchId]=@TerminalId and [CreateDate]=@Getdate


 insert @TempSummaryBet
select 7,7,'Bet TurnOver' as TransactionType,ISNULL(SUM(dbo.FuncCurrencyConverter(ISNULL(Amount,0),CurrencyId,@UserCurrencyId)),0)
from RiskManagement.BranchTransaction INNER JOIN Language.[Parameter.TransactionTypeBranch]
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where UserId=@UserId and TransactionTypeId=7 and LanguageId=@LangId
and CreateDate >@CashboxCloseDate

update [RiskManagement].[TerminalCloseBoxReport] set BetStake= ISNULL(( select Amount from @TempSummaryBet where Id=7),0) where [BranchId]=@TerminalId and [CreateDate]=@Getdate


 insert @TempSummaryBet
select 8,107,'Tax' as TransactionType,ISNULL(SUM(dbo.FuncCurrencyConverter(ISNULL(Amount,0),CurrencyId,@UserCurrencyId)),0)
from RiskManagement.BranchTransaction INNER JOIN Language.[Parameter.TransactionTypeBranch]
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where UserId=@UserId and TransactionTypeId=10 and LanguageId=@LangId
and CreateDate >@CashboxCloseDate

update [RiskManagement].[TerminalCloseBoxReport] set Tax= ISNULL(( select Amount from @TempSummaryBet where Id=8),0) where [BranchId]=@TerminalId and [CreateDate]=@Getdate


 insert @TempSummaryBet
select 9,108,'Bet PayOuts' as TransactionType,ISNULL(SUM(dbo.FuncCurrencyConverter((Amount),CurrencyId,@UserCurrencyId)),0) 
from RiskManagement.BranchTransaction INNER JOIN Language.[Parameter.TransactionTypeBranch]
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where UserId=@UserId and TransactionTypeId in (8,11,12) and LanguageId=@LangId
and CreateDate >@CashboxCloseDate

update [RiskManagement].[TerminalCloseBoxReport] set BetPayout= ISNULL(( select Amount from @TempSummaryBet where Id=9),0) where [BranchId]=@TerminalId and [CreateDate]=@Getdate


insert @TempSummaryBet
select 11,111,'Bet Total',((select ISNULL(SUM(Amount),0) From @TempSummaryBet where TransactionTypeId=7)+(select ISNULL(SUM(Amount),0) From @TempSummaryBet where TransactionTypeId=107))-((select ISNULL(SUM(Amount),0) From @TempSummaryBet where TransactionTypeId=108)) as Amount

update [RiskManagement].[TerminalCloseBoxReport] set BetTotal= ISNULL(( select Amount from @TempSummaryBet where Id=11),0) where [BranchId]=@TerminalId and [CreateDate]=@Getdate



 insert @TempSummaryBet
select 12,112,'Credit Voucher',ISNULL(SUM(dbo.FuncCurrencyConverter((Amount),CurrencyId,@UserCurrencyId)),0)*-1 
from RiskManagement.BranchTransaction INNER JOIN Language.[Parameter.TransactionTypeBranch]
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where UserId=@UserId and TransactionTypeId=16 and LanguageId=@LangId
and CreateDate >@CashboxCloseDate

update [RiskManagement].[TerminalCloseBoxReport] set CreditVoucher= ISNULL(( select Amount from @TempSummaryBet where Id=12),0) where [BranchId]=@TerminalId and [CreateDate]=@Getdate

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


update [RiskManagement].[TerminalCloseBoxReport] set CustomerTotal= ISNULL(( (select Amount From @TempSummaryBet where Id=1)-(select Amount From @TempSummaryBet where Id=2)),0) where [BranchId]=@TerminalId and [CreateDate]=@Getdate


insert @TempSummaryBet
select 6,110,'Terminal Total',(select Amount From @TempSummaryBet where Id=4)-(select ISNULL(Amount,0) From @TempSummaryBet where Id=5) as Amount

update [RiskManagement].[TerminalCloseBoxReport] set TerminalTotal= ISNULL(( (select Amount From @TempSummaryBet where Id=4)-(select ISNULL(Amount,0) From @TempSummaryBet where Id=5)),0) where [BranchId]=@TerminalId and [CreateDate]=@Getdate


insert @TempSummaryBet
select 14,113,'Profit',(select Amount From @TempSummaryBet where Id=13)+(select ISNULL(Amount,0) From @TempSummaryBet where Id=12) as Amount

update [RiskManagement].[TerminalCloseBoxReport] set Balance= ISNULL(( cast((select ISNULL(SUM(Amount),0) From @TempSummaryBet where Id=1) as money)+cast((select ISNULL(SUM(Amount),0) From @TempSummaryBet where Id=4) as money)),0) where [BranchId]=@TerminalId and [CreateDate]=@Getdate


insert RiskManagement.BranchTransaction (BranchId,CustomerId,TransactionTypeId,Amount,CurrencyId,CreateDate,UserId,[CashboxBalance])
								values(@TerminalId,null,6,(select ISNULL(SUM(Amount),0) From @TempSummaryBet where Id=1) +(select ISNULL(SUM(Amount),0) From @TempSummaryBet where Id=4) ,@UserCurrencyId,GETDATE(),@UserId,0)


set @TransId=SCOPE_IDENTITY()


update [RiskManagement].[TerminalCloseBoxReport] set  TransactionId=@TransId  where [BranchId]=@TerminalId and [CreateDate]=@Getdate

								
delete @TempSummaryBet
							end
							fetch next from cur111 into @TerminalId,@AnonymousBalance 
			
						end
					close cur111
					deallocate cur111

  
END




GO
