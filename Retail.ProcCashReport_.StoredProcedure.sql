USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcCashReport_]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcCashReport_]
@BranchId bigint,
@StartDate datetime,
@EndDate datetime,
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
 


declare @TerminalDeposit decimal(18,2)=0
declare @TerminalCustomerDeposit decimal(18,2)=0
declare @SumDeposit decimal(18,2)=0
declare @BranchInfo nvarchar(250)=''
declare @ParentBranch int
declare @BranchName nvarchar(150)

declare @CheckDate nvarchar(100)
declare @TerminalWthdraw decimal(18,2)=0
declare @TerminalCustomerWithdraw decimal(18,2)=0
declare @TerminalId int
 declare @IsTerminal bit
declare @AnonymousBalance money

		declare @CashboxBalance money=0						
declare @CashboxCloseDate datetime
declare @UserCurrencyId int
declare @ParentBranchId int
 SET @StartDate=cast(@StartDate as date) 

 SET @StartDate=@StartDate+'04:01:00'


 if(cast(@EndDate as date)=cast(GETDATE() as date))
	set @EndDate=GETDATE()


declare @TempBranchId table (BranchId int)
declare @ParentBranchControl int=1

insert @TempBranchId
select BranchId  From Parameter.Branch as BranchTable with (nolock)   where  (BranchTable.ParentBranchId=@BranchId or  
BranchTable.ParentBranchId in (select BranchId  From Parameter.Branch with (nolock)  where  Parameter.Branch.ParentBranchId=@BranchId) or BranchId=@BranchId  ) and BranchTable.IsTerminal=0 and (Select COUNT(*) from Parameter.Branch as PB with (nolock)  where PB.IsTerminal=1 and PB.ParentBranchId=BranchTable.BranchId)>0
--select BranchId  From Parameter.Branch with (nolock)  where  (Parameter.Branch.ParentBranchId=@BranchId) and IsTerminal=0
 
if not exists( select BranchId from @TempBranchId)
begin
insert @TempBranchId
select @BranchId

set @ParentBranchControl=0

end
declare @TempSummaryBet2 table (IsTerminal bit,BranchId bigint,ParentBranchId bigint,BranchName nvarchar(50),CustomerDeposit Money,CustomerWithdraw Money,CustomerTotal Money,TerminalDeposit Money,CashVoucher Money,TerminalTotal Money,BetTurnOver money,Tax money,BetPayOuts money,BetCancel money,BetTotal money,CreditVoucher money,CashTotal money,Profit money,Balance money) 

declare @temptable table (IsTerminal bit ,TerminalId int,TerminalDeposit money,TerminalCustomerDeposit money,SumDeposit money,CasboxCloseDate datetime)


declare @BranchTable table (BranchId int,Balance decimal(18,2),ParentBranchId int,BrancName nvarchar(150),IsTerminal bit)

 

set nocount on
					declare cur1112 cursor local for(
					select BranchId  From @TempBranchId

						)

					open cur1112
					fetch next from cur1112 into @ParentBranchId
					while @@fetch_status=0
						begin
							begin
								insert @BranchTable
								select BranchId,ISNULL(Balance,0),ParentBranchId,BrancName,IsTerminal From Parameter.Branch with (nolock)  where  (Parameter.Branch.ParentBranchId=@ParentBranchId or  BranchId=@ParentBranchId)

						end
							fetch next from cur1112 into @ParentBranchId
			
						end
					close cur1112
					deallocate cur1112


								 
set nocount on
					declare cur111 cursor local for(
					select DISTINCT BranchId,ISNULL(Balance,0),ParentBranchId,BrancName,IsTerminal From @BranchTable

						)

					open cur111
					fetch next from cur111 into @TerminalId,@AnonymousBalance,@ParentBranch,@BranchName,@IsTerminal
					while @@fetch_status=0
						begin
							begin
								
	 
select top 1 @UserRoleId=Users.UserRoles.RoleId,@UserId=Users.Users.UserId,@UserBranchId=Users.Users.UnitCode 
from Users.UserRoles with (nolock) 
INNER JOIN Users.Users with (nolock) ON Users.UserRoles.UserId=Users.Users.UserId where UnitCode=@TerminalId

  
declare @CashboxNumber bigint=1
 declare @TempSummaryBet table (IsTerminal bit ,BranchId bigint,ParentBranchId bigint,BranchName nvarchar(50),CustomerDeposit Money,CustomerWithdraw Money,CustomerTotal Money,TerminalDeposit Money,CashVoucher Money,TerminalTotal Money,BetTurnOver money,Tax money,BetPayOuts money,BetCancel money,BetTotal money,CreditVoucher money,CashTotal money,Profit money,Balance money)  
  

--  if (select Count(CreateDate) from RiskManagement.BranchTransaction where UserId=@UserId and TransactionTypeId=6 )>0
--		select   @CashboxNumber=COUNT(CreateDate)+1 from RiskManagement.BranchTransaction where UserId=@UserId and TransactionTypeId=6  
--else
--						select top 1  @CashboxNumber=COUNT(CreateDate)+1 from RiskManagement.BranchTransaction where BranchId=@BranchId and TransactionTypeId=14 

if (@IsTerminal=1)
begin
 


if(  select COUNT(RiskManagement.BranchTransaction.TransactionTypeId) --Customer Deposit
from RiskManagement.BranchTransaction with (nolock) INNER JOIN Language.[Parameter.TransactionTypeBranch] with (nolock)
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where BranchId=@TerminalId and TransactionTypeId=1 and LanguageId=@LangId
and CreateDate >=@StartDate and cast(CreateDate as date) <=cast(@EndDate as date)
GROUP BY Language.[Parameter.TransactionTypeBranch].TransactionType,RiskManagement.BranchTransaction.TransactionTypeId)>0
	begin
		  insert @TempSummaryBet (IsTerminal,BranchId,ParentBranchId,BranchName,CustomerDeposit)
		  select @IsTerminal,@TerminalId,@ParentBranch,@BranchName,ISNULL(SUM(dbo.FuncCurrencyConverter(ISNULL(Amount,0),CurrencyId,@UserCurrencyId)),0) 
		from RiskManagement.BranchTransaction with (nolock) INNER JOIN Language.[Parameter.TransactionTypeBranch] with (nolock)
		ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
		where BranchId=@TerminalId and TransactionTypeId=1 and LanguageId=@LangId
		and CreateDate >=@StartDate and cast(CreateDate as date) <=cast(@EndDate as date)
		GROUP BY Language.[Parameter.TransactionTypeBranch].TransactionType,RiskManagement.BranchTransaction.TransactionTypeId
	end
else
	begin
		 insert @TempSummaryBet (IsTerminal,BranchId,ParentBranchId,BranchName,CustomerDeposit)
		  select @IsTerminal,@TerminalId,@ParentBranch,@BranchName,0
		from Language.[Parameter.TransactionTypeBranch] with (nolock)
		where  Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=1 and LanguageId=@LangId


	end

if(  select COUNT(RiskManagement.BranchTransaction.TransactionTypeId) --Terminal Deposit
from RiskManagement.BranchTransaction with (nolock) INNER JOIN Language.[Parameter.TransactionTypeBranch] with (nolock)
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where BranchId=@TerminalId and TransactionTypeId=14 and LanguageId=@LangId
and CreateDate >=@StartDate and cast(CreateDate as date) <=cast(@EndDate as date)
GROUP BY Language.[Parameter.TransactionTypeBranch].TransactionType,RiskManagement.BranchTransaction.TransactionTypeId)>0
	begin
		  insert @TempSummaryBet (IsTerminal,BranchId,ParentBranchId,BranchName,TerminalDeposit)
		  select @IsTerminal,@TerminalId,@ParentBranch,@BranchName,ISNULL(SUM(dbo.FuncCurrencyConverter(ISNULL(Amount,0),CurrencyId,@UserCurrencyId)),0) 
		from RiskManagement.BranchTransaction with (nolock) INNER JOIN Language.[Parameter.TransactionTypeBranch] with (nolock)
		ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
		where BranchId=@TerminalId and TransactionTypeId=14 and LanguageId=@LangId
		and CreateDate >=@StartDate and cast(CreateDate as date) <=cast(@EndDate as date)
		GROUP BY Language.[Parameter.TransactionTypeBranch].TransactionType,RiskManagement.BranchTransaction.TransactionTypeId
	end
else
	begin
		 insert @TempSummaryBet (IsTerminal,BranchId,ParentBranchId,BranchName,TerminalDeposit)
		  select @IsTerminal,@TerminalId,@ParentBranch,@BranchName,0
		from Language.[Parameter.TransactionTypeBranch] with (nolock)
		where  Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=14 and LanguageId=@LangId


	end



if(select COUNT(RiskManagement.BranchTransaction.BranchTransactionId) -- Customer Withdraw
from RiskManagement.BranchTransaction with (nolock) INNER JOIN Language.[Parameter.TransactionTypeBranch] with (nolock)
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where BranchId=@TerminalId and TransactionTypeId=2 and LanguageId=@LangId
and CreateDate >=@StartDate and cast(CreateDate as date) <=cast(@EndDate as date)
GROUP BY Language.[Parameter.TransactionTypeBranch].TransactionType,RiskManagement.BranchTransaction.TransactionTypeId
)>0
	begin
		 insert @TempSummaryBet (IsTerminal,BranchId,ParentBranchId,BranchName,CustomerWithdraw)
		  select @IsTerminal,@TerminalId,@ParentBranch,@BranchName,SUM(dbo.FuncCurrencyConverter(ISNULL(Amount,0),CurrencyId,@UserCurrencyId))*-1
		from RiskManagement.BranchTransaction with (nolock) INNER JOIN Language.[Parameter.TransactionTypeBranch] with (nolock)
		ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
		where BranchId=@TerminalId and TransactionTypeId=2 and LanguageId=@LangId
		and CreateDate >=@StartDate and cast(CreateDate as date) <=cast(@EndDate as date)
		GROUP BY Language.[Parameter.TransactionTypeBranch].TransactionType,RiskManagement.BranchTransaction.TransactionTypeId
	end
else
	begin
			insert @TempSummaryBet (IsTerminal,BranchId,ParentBranchId,BranchName,CustomerWithdraw)
		  select @IsTerminal,@TerminalId,@ParentBranch,@BranchName,0
		from Language.[Parameter.TransactionTypeBranch] with (nolock)
		where  Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=2 and LanguageId=@LangId
		
	end


if(  select COUNT(RiskManagement.BranchTransaction.TransactionTypeId) --Terminal Withdraw
from RiskManagement.BranchTransaction with (nolock) INNER JOIN Language.[Parameter.TransactionTypeBranch] with (nolock)
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where BranchId=@TerminalId and TransactionTypeId=16 and LanguageId=@LangId
and CreateDate >=@StartDate and cast(CreateDate as date) <=cast(@EndDate as date)
GROUP BY Language.[Parameter.TransactionTypeBranch].TransactionType,RiskManagement.BranchTransaction.TransactionTypeId)>0
	begin
		  insert @TempSummaryBet (IsTerminal,BranchId,ParentBranchId,BranchName,CashVoucher)
		  select @IsTerminal,@TerminalId,@ParentBranch,@BranchName,ISNULL(SUM(dbo.FuncCurrencyConverter(ISNULL(Amount,0),CurrencyId,@UserCurrencyId)),0)*-1 
		from RiskManagement.BranchTransaction INNER JOIN Language.[Parameter.TransactionTypeBranch]
		ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
		where BranchId=@TerminalId and TransactionTypeId=16 and LanguageId=@LangId
		and CreateDate >=@StartDate and cast(CreateDate as date) <=cast(@EndDate as date)
		GROUP BY Language.[Parameter.TransactionTypeBranch].TransactionType,RiskManagement.BranchTransaction.TransactionTypeId
	end
else
	begin
		 insert @TempSummaryBet (IsTerminal,BranchId,ParentBranchId,BranchName,CashVoucher)
		  select @IsTerminal,@TerminalId,@ParentBranch,@BranchName,0
		from Language.[Parameter.TransactionTypeBranch] with (nolock)
		where  Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=16 and LanguageId=@LangId


	end


 insert @TempSummaryBet (IsTerminal,BranchId,ParentBranchId,BranchName,BetTurnOver)
		  select @IsTerminal,@TerminalId,@ParentBranch,@BranchName,ISNULL(SUM(dbo.FuncCurrencyConverter(ISNULL(Amount,0),CurrencyId,@UserCurrencyId)),0)
from RiskManagement.BranchTransaction with (nolock) INNER JOIN Language.[Parameter.TransactionTypeBranch] with (nolock)
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where BranchId=@TerminalId and TransactionTypeId=7 and LanguageId=@LangId
and CreateDate >=@StartDate and cast(CreateDate as date) <=cast(@EndDate as date)


 insert @TempSummaryBet (IsTerminal,BranchId,ParentBranchId,BranchName,Tax)
		  select @IsTerminal,@TerminalId,@ParentBranch,@BranchName,ISNULL(SUM(dbo.FuncCurrencyConverter(ISNULL(Amount,0),CurrencyId,@UserCurrencyId)),0)
from RiskManagement.BranchTransaction with (nolock) INNER JOIN Language.[Parameter.TransactionTypeBranch] with (nolock)
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where BranchId=@TerminalId and TransactionTypeId=10 and LanguageId=@LangId
and CreateDate >=@StartDate and cast(CreateDate as date) <=cast(@EndDate as date)


-- insert @TempSummaryBet (IsTerminal,BranchId,ParentBranchId,BranchName,BetPayOuts)
--		  select @IsTerminal,@TerminalId,@ParentBranch,@BranchName,ISNULL(SUM(dbo.FuncCurrencyConverter((Amount),CurrencyId,@UserCurrencyId)),0) 
--from RiskManagement.BranchTransaction INNER JOIN Language.[Parameter.TransactionTypeBranch]
--ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
--where BranchId=@TerminalId and TransactionTypeId in (11,8,12) and LanguageId=@LangId
--and CreateDate >=@StartDate and CreateDate <=@EndDate



-- insert @TempSummaryBet
--select 10,109,'Bet cancellations',ISNULL(SUM(dbo.FuncCurrencyConverter((Amount),CurrencyId,@UserCurrencyId)),0) 
--from RiskManagement.BranchTransaction INNER JOIN Language.[Parameter.TransactionTypeBranch]
--ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
--where UserId=@UserId and TransactionTypeId=9 and LanguageId=@LangId
--and CreateDate >@CashboxCloseDate





--select top 1 @CashboxBalance=ISNULL(RiskManagement.BranchTransaction.CashboxBalance,0) from RiskManagement.BranchTransaction
--						where UserId=@UserId and BranchId=@BranchId order by CreateDate desc


insert @TempSummaryBet (IsTerminal,BranchId,ParentBranchId,BranchName,CustomerTotal)
		  select @IsTerminal,@TerminalId,@ParentBranch,@BranchName,(select SUM(ISNULL(CustomerDeposit,0)) From @TempSummaryBet )+(select SUM(ISNULL(CustomerWithdraw,0)) From @TempSummaryBet ) as Amount








insert @TempSummaryBet (IsTerminal,BranchId,ParentBranchId,BranchName,CreditVoucher)
		   select @IsTerminal,@TerminalId,@ParentBranch,@BranchName,ISNULL(SUM(dbo.FuncCurrencyConverter(ISNULL(Amount,0),CurrencyId,@UserCurrencyId)),0)*-1 
		from RiskManagement.BranchTransaction with (nolock)  INNER JOIN Language.[Parameter.TransactionTypeBranch] with (nolock) 
		ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
		where BranchId=@TerminalId and TransactionTypeId=15 and LanguageId=@LangId
		and CreateDate >=@StartDate and cast(CreateDate as date) <=cast(@EndDate as date)
		GROUP BY Language.[Parameter.TransactionTypeBranch].TransactionType,RiskManagement.BranchTransaction.TransactionTypeId

insert @TempSummaryBet (IsTerminal,BranchId,ParentBranchId,BranchName,TerminalTotal)
		  select @IsTerminal,@TerminalId,@ParentBranch,@BranchName,(select SUM(ISNULL(TerminalDeposit,0)) From @TempSummaryBet )+(select SUM(ISNULL(CashVoucher,0)) From @TempSummaryBet ) as Amount

insert @TempSummaryBet (IsTerminal,BranchId,ParentBranchId,BranchName,CashTotal)
		  select @IsTerminal,@TerminalId,@ParentBranch,@BranchName,(select SUM(ISNULL(CustomerDeposit,0)) From @TempSummaryBet  )+(select SUM(ISNULL(TerminalDeposit,0)) From @TempSummaryBet  ) as Amount

--insert @TempSummaryBet
--select 10,111,'Credit Voucher',0

insert @TempSummaryBet (IsTerminal,BranchId,ParentBranchId,BranchName,BetTotal)
		  select @IsTerminal,@TerminalId,@ParentBranch,@BranchName,((select ISNULL(SUM(BetTurnOver),0) From @TempSummaryBet )+(select ISNULL(SUM(Tax),0) From @TempSummaryBet  ))-((select ISNULL(SUM(BetPayOuts),0) From @TempSummaryBet )) as Amount


insert @TempSummaryBet (IsTerminal,BranchId,ParentBranchId,BranchName,Profit)
		  select @IsTerminal,@TerminalId,@ParentBranch,@BranchName,(select SUM(ISNULL(CashTotal,0)) From @TempSummaryBet )+(select SUM(ISNULL(CreditVoucher,0)) From @TempSummaryBet ) as Amount


		  insert @TempSummaryBet (IsTerminal,BranchId,ParentBranchId,BranchName,Balance)
		  select @IsTerminal,@TerminalId,@ParentBranch,@BranchName,(select SUM(ISNULL(CustomerTotal,0)) From @TempSummaryBet )+(select SUM(ISNULL(TerminalTotal,0)) From @TempSummaryBet ) as Amount

end
else
begin
 

if(  select COUNT(RiskManagement.BranchTransaction.TransactionTypeId) --Customer Deposit
from RiskManagement.BranchTransaction with (nolock) INNER JOIN Language.[Parameter.TransactionTypeBranch] with (nolock)
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where BranchId=@TerminalId and TransactionTypeId=1 and LanguageId=@LangId
and CreateDate >=@StartDate and  cast(CreateDate as date) <=cast(@EndDate as date)
GROUP BY Language.[Parameter.TransactionTypeBranch].TransactionType,RiskManagement.BranchTransaction.TransactionTypeId)>0
	begin
		  insert @TempSummaryBet (IsTerminal,BranchId,ParentBranchId,BranchName,CustomerDeposit)
		  select @IsTerminal,@TerminalId,@ParentBranch,@BranchName,ISNULL(SUM(dbo.FuncCurrencyConverter(ISNULL(Amount,0),CurrencyId,@UserCurrencyId)),0) 
		from RiskManagement.BranchTransaction with (nolock) INNER JOIN Language.[Parameter.TransactionTypeBranch] with (nolock)
		ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
		where BranchId=@TerminalId and TransactionTypeId=1 and LanguageId=@LangId
		and CreateDate >=@StartDate and cast(CreateDate as date) <=cast(@EndDate as date)
		GROUP BY Language.[Parameter.TransactionTypeBranch].TransactionType,RiskManagement.BranchTransaction.TransactionTypeId
	end
else
	begin
		 insert @TempSummaryBet (IsTerminal,BranchId,ParentBranchId,BranchName,CustomerDeposit)
		  select @IsTerminal,@TerminalId,@ParentBranch,@BranchName,0
		from Language.[Parameter.TransactionTypeBranch] with (nolock) 
		where  Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=1 and LanguageId=@LangId


	end





if(select COUNT(RiskManagement.BranchTransaction.BranchTransactionId) -- Customer Withdraw
from RiskManagement.BranchTransaction with (nolock) INNER JOIN Language.[Parameter.TransactionTypeBranch] with (nolock)
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where BranchId=@TerminalId and TransactionTypeId=2 and LanguageId=@LangId
and CreateDate >=@StartDate and cast(CreateDate as date) <=cast(@EndDate as date)
GROUP BY Language.[Parameter.TransactionTypeBranch].TransactionType,RiskManagement.BranchTransaction.TransactionTypeId
)>0
	begin
		 insert @TempSummaryBet (IsTerminal,BranchId,ParentBranchId,BranchName,CustomerWithdraw)
		  select @IsTerminal,@TerminalId,@ParentBranch,@BranchName,SUM(dbo.FuncCurrencyConverter(ISNULL(Amount,0),CurrencyId,@UserCurrencyId))*-1 
		from RiskManagement.BranchTransaction with (nolock) INNER JOIN Language.[Parameter.TransactionTypeBranch] with (nolock)
		ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
		where BranchId=@TerminalId and TransactionTypeId=2 and LanguageId=@LangId
		and CreateDate >=@StartDate and cast(CreateDate as date) <=cast(@EndDate as date)
		GROUP BY Language.[Parameter.TransactionTypeBranch].TransactionType,RiskManagement.BranchTransaction.TransactionTypeId
	end
else
	begin
			insert @TempSummaryBet (IsTerminal,BranchId,ParentBranchId,BranchName,CustomerWithdraw)
		  select @IsTerminal,@TerminalId,@ParentBranch,@BranchName,0
		from Language.[Parameter.TransactionTypeBranch] with (nolock)
		where  Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=2 and LanguageId=@LangId
		
	end




 insert @TempSummaryBet (IsTerminal,BranchId,ParentBranchId,BranchName,BetTurnOver)
		  select @IsTerminal,@TerminalId,@ParentBranch,@BranchName,ISNULL(SUM(dbo.FuncCurrencyConverter(ISNULL(Amount,0),CurrencyId,@UserCurrencyId)),0)
from RiskManagement.BranchTransaction with (nolock) INNER JOIN Language.[Parameter.TransactionTypeBranch] with (nolock)
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where BranchId=@TerminalId and TransactionTypeId=7 and LanguageId=@LangId
and CreateDate >=@StartDate and cast(CreateDate as date) <=cast(@EndDate as date)


 insert @TempSummaryBet (IsTerminal,BranchId,ParentBranchId,BranchName,BetCancel)
		  select @IsTerminal,@TerminalId,@ParentBranch,@BranchName,ISNULL(SUM(dbo.FuncCurrencyConverter(ISNULL(Amount,0),CurrencyId,@UserCurrencyId)),0)*-1
from RiskManagement.BranchTransaction with (nolock) INNER JOIN Language.[Parameter.TransactionTypeBranch] with (nolock)
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where BranchId=@TerminalId and TransactionTypeId=9 and LanguageId=@LangId
and CreateDate >=@StartDate and cast(CreateDate as date) <=cast(@EndDate as date)


 insert @TempSummaryBet (IsTerminal,BranchId,ParentBranchId,BranchName,Tax)
		  select @IsTerminal,@TerminalId,@ParentBranch,@BranchName,ISNULL(SUM(dbo.FuncCurrencyConverter(ISNULL(Amount,0),CurrencyId,@UserCurrencyId)),0)
from RiskManagement.BranchTransaction with (nolock) INNER JOIN Language.[Parameter.TransactionTypeBranch] with (nolock)
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where BranchId=@TerminalId and TransactionTypeId=10 and LanguageId=@LangId
and CreateDate >=@StartDate and cast(CreateDate as date) <=cast(@EndDate as date)


 insert @TempSummaryBet (IsTerminal,BranchId,ParentBranchId,BranchName,BetPayOuts)
		  select @IsTerminal,@TerminalId,@ParentBranch,@BranchName,ISNULL(SUM(dbo.FuncCurrencyConverter((Amount),CurrencyId,@UserCurrencyId)),0) *-1
from RiskManagement.BranchTransaction with (nolock) INNER JOIN Language.[Parameter.TransactionTypeBranch] with (nolock)
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where BranchId=@TerminalId and TransactionTypeId in (11,8,12) and LanguageId=@LangId
and CreateDate >=@StartDate and cast(CreateDate as date) <=cast(@EndDate as date)



-- insert @TempSummaryBet
--select 10,109,'Bet cancellations',ISNULL(SUM(dbo.FuncCurrencyConverter((Amount),CurrencyId,@UserCurrencyId)),0) 
--from RiskManagement.BranchTransaction INNER JOIN Language.[Parameter.TransactionTypeBranch]
--ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
--where UserId=@UserId and TransactionTypeId=9 and LanguageId=@LangId
--and CreateDate >@CashboxCloseDate





--select top 1 @CashboxBalance=ISNULL(RiskManagement.BranchTransaction.CashboxBalance,0) from RiskManagement.BranchTransaction
--						where UserId=@UserId and BranchId=@BranchId order by CreateDate desc


insert @TempSummaryBet (IsTerminal,BranchId,ParentBranchId,BranchName,CustomerTotal)
		  select @IsTerminal,@TerminalId,@ParentBranch,@BranchName,(select SUM(ISNULL(CustomerDeposit,0)) From @TempSummaryBet )+(select SUM(ISNULL(CustomerWithdraw,0)) From @TempSummaryBet ) as Amount
		   
		    




insert @TempSummaryBet (IsTerminal,BranchId,ParentBranchId,BranchName,CashVoucher)
		  select @IsTerminal,@TerminalId,@ParentBranch,@BranchName,ISNULL(SUM(dbo.FuncCurrencyConverter((Amount),CurrencyId,@UserCurrencyId)),0)*-1 
from RiskManagement.BranchTransaction with (nolock) INNER JOIN Language.[Parameter.TransactionTypeBranch] with (nolock)
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where BranchId=@TerminalId and TransactionTypeId=16 and LanguageId=@LangId
and CreateDate >=@StartDate and cast(CreateDate as date) <=cast(@EndDate as date)
--insert @TempSummaryBet
--select 10,111,'Credit Voucher',0


insert @TempSummaryBet (IsTerminal,BranchId,ParentBranchId,BranchName,TerminalTotal)
		  select @IsTerminal,@TerminalId,@ParentBranch,@BranchName,(select SUM(ISNULL(CashVoucher,0)) From @TempSummaryBet ) 

insert @TempSummaryBet (IsTerminal,BranchId,ParentBranchId,BranchName,BetTotal)
		  select @IsTerminal,@TerminalId,@ParentBranch,@BranchName,((select ISNULL(SUM(BetTurnOver),0) From @TempSummaryBet )+(select ISNULL(SUM(Tax),0) From @TempSummaryBet  ))+((select ISNULL(SUM(BetPayOuts),0) From @TempSummaryBet ))+((select ISNULL(SUM(CreditVoucher),0) From @TempSummaryBet ))+((select ISNULL(SUM(BetCancel),0) From @TempSummaryBet )) as Amount


insert @TempSummaryBet (IsTerminal,BranchId,ParentBranchId,BranchName,Profit)
		  select @IsTerminal,@TerminalId,@ParentBranch,@BranchName,((select SUM(ISNULL(CustomerTotal,0)) From @TempSummaryBet )+(select SUM(ISNULL(BetTotal,0)) From @TempSummaryBet ))+(select SUM(ISNULL(CreditVoucher,0)) From @TempSummaryBet ) as Amount


		  insert @TempSummaryBet (IsTerminal,BranchId,ParentBranchId,BranchName,Balance)
		  select @IsTerminal,@TerminalId,@ParentBranch,@BranchName,((select SUM(ISNULL(CustomerTotal,0)) From @TempSummaryBet )+(select SUM(ISNULL(TerminalTotal,0)) From @TempSummaryBet )+(select SUM(ISNULL(BetTotal,0)) From @TempSummaryBet ))  as Amount

		  

end

insert @TempSummaryBet2
select * from @TempSummaryBet



--insert RiskManagement.BranchTransaction (BranchId,CustomerId,TransactionTypeId,Amount,CurrencyId,CreateDate,UserId,[CashboxBalance])
--								values(@BranchId,null,6,(select ISNULL(SUM(Amount),0) From @TempSummaryBet where Id=11),@UserCurrencyId,GETDATE(),@UserId,0)


--select TransactionType,convert(varchar, cast(ISNULL(Amount,0) as money), 1) as Amount,convert(varchar(20),@StartDate,113)+' - '+convert(varchar(20), @EndDate,113) as Period,convert(varchar, (cast((select ISNULL(SUM(Amount),0) 
--From @TempSummaryBet where Id=1) as money)+cast((select ISNULL(SUM(Amount),0) From @TempSummaryBet where Id=4) as money)), 1)  as Balance,@CashboxNumber as ReportNo  from @TempSummaryBet2 



								
delete @TempSummaryBet
							end
							fetch next from cur111 into @TerminalId,@AnonymousBalance,@ParentBranch,@BranchName,@IsTerminal
			
						end
					close cur111
					deallocate cur111


	if(@ParentBranchControl=0)
	begin
		  select IsTerminal,ParentBranchId,BranchId,(Select Top 1 Parameter.Branch.BrancName from Parameter.Branch with (nolock) where BranchId=tt.ParentBranchId) as ParentBranchName,BranchName
		  ,SUM(ISNULL(CustomerDeposit,0)) as CustomerDeposit 
		  ,SUM(ISNULL(CustomerWithdraw,0))+(select ISNULL(SUM(CustomerWithdraw),0) from @TempSummaryBet2 as t2 where t2.ParentBranchId=tt.BranchId and IsTerminal=1) as CustomerWithdraw 
		  ,SUM(ISNULL(CustomerTotal,0)) as CustomerTotal
		   ,SUM(ISNULL(TerminalDeposit,0))+(select ISNULL(SUM(TerminalDeposit),0) from @TempSummaryBet2 as t2 where t2.ParentBranchId=tt.BranchId and IsTerminal=1)+(select ISNULL(SUM(CustomerDeposit),0) from @TempSummaryBet2 as t2 where t2.ParentBranchId=tt.BranchId and IsTerminal=1) as TerminalDeposit
		   ,SUM(ISNULL(CashVoucher,0))+(select ISNULL(SUM(CashVoucher),0) from @TempSummaryBet2 as t2 where t2.ParentBranchId=tt.BranchId and IsTerminal=1) as CashVoucher
		   ,SUM(ISNULL(TerminalTotal,0))+(select ISNULL(SUM(CustomerDeposit),0) from @TempSummaryBet2 as t2 where t2.ParentBranchId=tt.BranchId and IsTerminal=1)+(select ISNULL(SUM(TerminalTotal),0) from @TempSummaryBet2 as t2 where t2.ParentBranchId=tt.BranchId and IsTerminal=1) as TerminalTotal
		   ,SUM(ISNULL(BetTurnOver,0))  as BetTurnOver
		   ,SUM(ISNULL(Tax,0))  as Tax
		   ,SUM(ISNULL(BetPayOuts,0))  as BetPayOuts
		   ,SUM(ISNULL(BetCancel,0))  as BetCancel
		   ,SUM(ISNULL(BetTotal,0))  as BetTotal
		   ,SUM(ISNULL(CreditVoucher,0))+(select ISNULL(SUM(CreditVoucher),0) from @TempSummaryBet2 as t2 where t2.ParentBranchId=tt.BranchId and IsTerminal=1) as CreditVoucher
		   ,SUM(ISNULL(CashTotal,0))+(select ISNULL(SUM(CashTotal),0) from @TempSummaryBet2 as t2 where t2.ParentBranchId=tt.BranchId and IsTerminal=1) as CashTotal
		   ,SUM(ISNULL(Profit,0)) as Profit
		   ,(select ISNULL(SUM(Profit),0) from @TempSummaryBet2 as t2 where t2.ParentBranchId=tt.BranchId and IsTerminal=1) as PartnerProfit
		   ,SUM(ISNULL(Profit,0))+(select ISNULL(SUM(Profit),0) from @TempSummaryBet2 as t2 where t2.ParentBranchId=tt.BranchId and IsTerminal=1) as TotalProfit
		   ,SUM(ISNULL(Balance,0)) as Balance
		   ,(select ISNULL(SUM(Balance),0) from @TempSummaryBet2 as t2 where t2.ParentBranchId=tt.BranchId and IsTerminal=1) as PartnerBalance
		   ,SUM(ISNULL(Balance,0))+(select ISNULL(SUM(Balance),0) from @TempSummaryBet2 as t2 where t2.ParentBranchId=tt.BranchId and IsTerminal=1) as TotalBalance
		  from @TempSummaryBet2 as tt GROUP BY IsTerminal,ParentBranchId,BranchId,BranchName
	end
	else
	begin


	select cast(0 as bit) as IsTerminal,cast(0 as bigint) as ParentBranchId,cast(0 as bigint) as BranchId,'' as ParentBranchName,'Total' as BranchName
		  ,SUM(ISNULL(CustomerDeposit,0)) as CustomerDeposit 
		  ,SUM(ISNULL(CustomerWithdraw,0))+(select ISNULL(SUM(CustomerWithdraw),0) from @TempSummaryBet2 as t2 where  IsTerminal=1) as CustomerWithdraw 
		  ,SUM(ISNULL(CustomerTotal,0)) as CustomerTotal
		   ,SUM(ISNULL(TerminalDeposit,0))+(select ISNULL(SUM(TerminalDeposit),0) from @TempSummaryBet2 as t2 where  IsTerminal=1)+(select ISNULL(SUM(CustomerDeposit),0) from @TempSummaryBet2 as t2 where  IsTerminal=1) as TerminalDeposit
		   ,SUM(ISNULL(CashVoucher,0))+(select ISNULL(SUM(CashVoucher),0) from @TempSummaryBet2 as t2 where  IsTerminal=1) as CashVoucher
		   ,SUM(ISNULL(TerminalTotal,0))+(select ISNULL(SUM(CustomerDeposit),0) from @TempSummaryBet2 as t2 where   IsTerminal=1)+(select ISNULL(SUM(TerminalTotal),0) from @TempSummaryBet2 as t2 where  IsTerminal=1) as TerminalTotal
		   ,SUM(ISNULL(BetTurnOver,0))  as BetTurnOver
		   ,SUM(ISNULL(Tax,0))  as Tax
		   ,SUM(ISNULL(BetPayOuts,0))  as BetPayOuts
		   ,SUM(ISNULL(BetCancel,0))  as BetCancel
		   ,SUM(ISNULL(BetTotal,0))  as BetTotal
		   ,SUM(ISNULL(CreditVoucher,0))+(select ISNULL(SUM(CreditVoucher),0) from @TempSummaryBet2 as t2 where   IsTerminal=1) as CreditVoucher
		   ,SUM(ISNULL(CashTotal,0))+(select ISNULL(SUM(CashTotal),0) from @TempSummaryBet2 as t2 where   IsTerminal=1) as CashTotal
		   ,SUM(ISNULL(Profit,0)) as Profit
		   ,(select ISNULL(SUM(Profit),0) from @TempSummaryBet2 as t2 where  IsTerminal=1) as PartnerProfit
		   ,SUM(ISNULL(Profit,0))+(select ISNULL(SUM(Profit),0) from @TempSummaryBet2 as t2 where   IsTerminal=1) as TotalProfit
		   ,SUM(ISNULL(Balance,0)) as Balance
		   ,(select ISNULL(SUM(Balance),0) from @TempSummaryBet2 as t2 where  IsTerminal=1) as PartnerBalance
		   ,SUM(ISNULL(Balance,0))+(select ISNULL(SUM(Balance),0) from @TempSummaryBet2 as t2 where IsTerminal=1) as TotalBalance
		  from @TempSummaryBet2 as tt  where IsTerminal=0 
		UNION ALL
		select IsTerminal,ParentBranchId,BranchId,(Select Top 1 Parameter.Branch.BrancName from Parameter.Branch with (nolock) where BranchId=tt.ParentBranchId) as ParentBranchName,BranchName
		  ,SUM(ISNULL(CustomerDeposit,0)) as CustomerDeposit 
		  ,SUM(ISNULL(CustomerWithdraw,0))+(select ISNULL(SUM(CustomerWithdraw),0) from @TempSummaryBet2 as t2 where t2.ParentBranchId=tt.BranchId and IsTerminal=1) as CustomerWithdraw 
		  ,SUM(ISNULL(CustomerTotal,0)) as CustomerTotal
		   ,SUM(ISNULL(TerminalDeposit,0))+(select ISNULL(SUM(TerminalDeposit),0) from @TempSummaryBet2 as t2 where t2.ParentBranchId=tt.BranchId and IsTerminal=1)+(select ISNULL(SUM(CustomerDeposit),0) from @TempSummaryBet2 as t2 where t2.ParentBranchId=tt.BranchId and IsTerminal=1) as TerminalDeposit
		   ,SUM(ISNULL(CashVoucher,0))+(select ISNULL(SUM(CashVoucher),0) from @TempSummaryBet2 as t2 where t2.ParentBranchId=tt.BranchId and IsTerminal=1) as CashVoucher
		   ,SUM(ISNULL(TerminalTotal,0))+(select ISNULL(SUM(CustomerDeposit),0) from @TempSummaryBet2 as t2 where t2.ParentBranchId=tt.BranchId and IsTerminal=1)+(select ISNULL(SUM(TerminalTotal),0) from @TempSummaryBet2 as t2 where t2.ParentBranchId=tt.BranchId and IsTerminal=1) as TerminalTotal
		   ,SUM(ISNULL(BetTurnOver,0))  as BetTurnOver
		   ,SUM(ISNULL(Tax,0))  as Tax
		   ,SUM(ISNULL(BetPayOuts,0))  as BetPayOuts
		   ,SUM(ISNULL(BetCancel,0))  as BetCancel
		   ,SUM(ISNULL(BetTotal,0))  as BetTotal
		   ,SUM(ISNULL(CreditVoucher,0))+(select ISNULL(SUM(CreditVoucher),0) from @TempSummaryBet2 as t2 where t2.ParentBranchId=tt.BranchId and IsTerminal=1) as CreditVoucher
		   ,SUM(ISNULL(CashTotal,0))+(select ISNULL(SUM(CashTotal),0) from @TempSummaryBet2 as t2 where t2.ParentBranchId=tt.BranchId and IsTerminal=1) as CashTotal
		   ,SUM(ISNULL(Profit,0)) as Profit
		   ,(select ISNULL(SUM(Profit),0) from @TempSummaryBet2 as t2 where t2.ParentBranchId=tt.BranchId and IsTerminal=1) as PartnerProfit
		   ,SUM(ISNULL(Profit,0))+(select ISNULL(SUM(Profit),0) from @TempSummaryBet2 as t2 where t2.ParentBranchId=tt.BranchId and IsTerminal=1) as TotalProfit
		   ,SUM(ISNULL(Balance,0)) as Balance
		   ,(select ISNULL(SUM(Balance),0) from @TempSummaryBet2 as t2 where t2.ParentBranchId=tt.BranchId and IsTerminal=1) as PartnerBalance
		   ,SUM(ISNULL(Balance,0))+(select ISNULL(SUM(Balance),0) from @TempSummaryBet2 as t2 where t2.ParentBranchId=tt.BranchId and IsTerminal=1) as TotalBalance
		  from @TempSummaryBet2 as tt GROUP BY IsTerminal,ParentBranchId,BranchId,BranchName


	end
END




GO
