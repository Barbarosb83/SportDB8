USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcTerminalDailyReport]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcTerminalDailyReport] 
@TerminalId int,
@LangId int,
@StartDate datetime
AS
BEGIN
SET NOCOUNT ON;


declare @CashboxCloseDate datetime
 
 
 
 
declare @CashboxNumber bigint=1
 declare @TempSummaryBet table (Id int,TransactionTypeId int,TransactionType nvarchar(50),Amount Money,TrsanctionCount int) 
  

  if (select Count(CreateDate) from RiskManagement.BranchTransaction where BranchId=@TerminalId and TransactionTypeId=6 and cast(CreateDate as Date)=cast(@StartDate as date) )>0
		select   @CashboxCloseDate=MAX(CreateDate),@CashboxNumber=COUNT(CreateDate)+1 from RiskManagement.BranchTransaction where BranchId=@TerminalId and TransactionTypeId=6   and cast(CreateDate as Date)=cast(@StartDate as date)
else
						select top 1 @CashboxCloseDate=MIN(DATEADD(MINUTE,-1,CreateDate)),@CashboxNumber=COUNT(CreateDate)+1 from RiskManagement.BranchTransaction where BranchId=@TerminalId and TransactionTypeId=14 
						 and cast(CreateDate as Date)=cast(@StartDate as date)

						if @CashboxCloseDate is null
							set @CashboxCloseDate=MIN(DATEADD(MINUTE,-1,@StartDate))

if(  select COUNT(RiskManagement.BranchTransaction.TransactionTypeId) --Customer Deposit
from RiskManagement.BranchTransaction INNER JOIN Language.[Parameter.TransactionTypeBranch]
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where BranchId=@TerminalId and TransactionTypeId=1 and LanguageId=@LangId
and CreateDate >@CashboxCloseDate
GROUP BY Language.[Parameter.TransactionTypeBranch].TransactionType,RiskManagement.BranchTransaction.TransactionTypeId)>0
	begin
		  insert @TempSummaryBet
		  select 1,RiskManagement.BranchTransaction.TransactionTypeId,Language.[Parameter.TransactionTypeBranch].TransactionType,ISNULL(SUM(Amount),0),COUNT(RiskManagement.BranchTransaction.TransactionTypeId)
		from RiskManagement.BranchTransaction INNER JOIN Language.[Parameter.TransactionTypeBranch]
		ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
		where BranchId=@TerminalId and TransactionTypeId=1 and LanguageId=@LangId
		and CreateDate >@CashboxCloseDate
		GROUP BY Language.[Parameter.TransactionTypeBranch].TransactionType,RiskManagement.BranchTransaction.TransactionTypeId
	end
else
	begin
		 insert @TempSummaryBet
		select 1,Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId,Language.[Parameter.TransactionTypeBranch].TransactionType,0,0
		from Language.[Parameter.TransactionTypeBranch]
		where  Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=1 and LanguageId=@LangId


	end

if(  select COUNT(RiskManagement.BranchTransaction.TransactionTypeId) --Terminal Deposit
from RiskManagement.BranchTransaction INNER JOIN Language.[Parameter.TransactionTypeBranch]
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where BranchId=@TerminalId and TransactionTypeId=14 and LanguageId=@LangId
and CreateDate >@CashboxCloseDate
GROUP BY Language.[Parameter.TransactionTypeBranch].TransactionType,RiskManagement.BranchTransaction.TransactionTypeId)>0
	begin
		  insert @TempSummaryBet
		  select 4,RiskManagement.BranchTransaction.TransactionTypeId,Language.[Parameter.TransactionTypeBranch].TransactionType,ISNULL(SUM(Amount),0)
		  ,COUNT(RiskManagement.BranchTransaction.TransactionTypeId)
		from RiskManagement.BranchTransaction INNER JOIN Language.[Parameter.TransactionTypeBranch]
		ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
		where BranchId=@TerminalId and TransactionTypeId=14 and LanguageId=@LangId
		and CreateDate >@CashboxCloseDate
		GROUP BY Language.[Parameter.TransactionTypeBranch].TransactionType,RiskManagement.BranchTransaction.TransactionTypeId
	end
else
	begin
		 insert @TempSummaryBet
		select 4,Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId,Language.[Parameter.TransactionTypeBranch].TransactionType,0,
		0
		from Language.[Parameter.TransactionTypeBranch]
		where  Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=14 and LanguageId=@LangId


	end



if(select COUNT(RiskManagement.BranchTransaction.BranchTransactionId) -- Customer Withdraw
from RiskManagement.BranchTransaction INNER JOIN Language.[Parameter.TransactionTypeBranch]
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where BranchId=@TerminalId  and TransactionTypeId=2 and LanguageId=@LangId
and CreateDate >@CashboxCloseDate
GROUP BY Language.[Parameter.TransactionTypeBranch].TransactionType,RiskManagement.BranchTransaction.TransactionTypeId
)>0
	begin
		 insert @TempSummaryBet
		select 2,RiskManagement.BranchTransaction.TransactionTypeId,Language.[Parameter.TransactionTypeBranch].TransactionType,SUM(Amount)
		,COUNT(RiskManagement.BranchTransaction.TransactionTypeId)
		from RiskManagement.BranchTransaction INNER JOIN Language.[Parameter.TransactionTypeBranch]
		ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
		where BranchId=@TerminalId  and TransactionTypeId=2 and LanguageId=@LangId
		and CreateDate >@CashboxCloseDate
		GROUP BY Language.[Parameter.TransactionTypeBranch].TransactionType,RiskManagement.BranchTransaction.TransactionTypeId
	end
else
	begin
			 insert @TempSummaryBet
		select 2,Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId,Language.[Parameter.TransactionTypeBranch].TransactionType,0
		,0
		from Language.[Parameter.TransactionTypeBranch]
		where  Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=2 and LanguageId=@LangId
		
	end


if(  select COUNT(RiskManagement.BranchTransaction.TransactionTypeId) --Terminal Withdraw
from RiskManagement.BranchTransaction INNER JOIN Language.[Parameter.TransactionTypeBranch]
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where BranchId=@TerminalId  and TransactionTypeId=15 and LanguageId=@LangId
and CreateDate >@CashboxCloseDate
GROUP BY Language.[Parameter.TransactionTypeBranch].TransactionType,RiskManagement.BranchTransaction.TransactionTypeId)>0
	begin
		  insert @TempSummaryBet
		  select 5,RiskManagement.BranchTransaction.TransactionTypeId,Language.[Parameter.TransactionTypeBranch].TransactionType,ISNULL(SUM( Amount),0)
		  ,COUNT(RiskManagement.BranchTransaction.TransactionTypeId)
		from RiskManagement.BranchTransaction INNER JOIN Language.[Parameter.TransactionTypeBranch]
		ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
		where BranchId=@TerminalId  and TransactionTypeId=15 and LanguageId=@LangId
		and CreateDate >@CashboxCloseDate
		GROUP BY Language.[Parameter.TransactionTypeBranch].TransactionType,RiskManagement.BranchTransaction.TransactionTypeId
	end
else
	begin
		 insert @TempSummaryBet
		select 5,Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId,Language.[Parameter.TransactionTypeBranch].TransactionType,0
		,0
		from Language.[Parameter.TransactionTypeBranch]
		where  Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=15 and LanguageId=@LangId


	end

	--betstake
 insert @TempSummaryBet
select 8,7,Language.[Parameter.TransactionTypeBranch].TransactionType as TransactionType,ISNULL(SUM(Amount),0)
,COUNT(RiskManagement.BranchTransaction.TransactionTypeId)
from RiskManagement.BranchTransaction INNER JOIN Language.[Parameter.TransactionTypeBranch]
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where BranchId=@TerminalId  and TransactionTypeId=7 and LanguageId=@LangId
and CreateDate >@CashboxCloseDate
group by Language.[Parameter.TransactionTypeBranch].TransactionType


 insert @TempSummaryBet --tax
select 9,107,Language.[Parameter.TransactionTypeBranch].TransactionType as TransactionType,ISNULL(SUM( Amount ),0)
,COUNT(RiskManagement.BranchTransaction.TransactionTypeId)
from RiskManagement.BranchTransaction INNER JOIN Language.[Parameter.TransactionTypeBranch]
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where BranchId=@TerminalId  and TransactionTypeId=10 and LanguageId=@LangId
and CreateDate >@CashboxCloseDate
group by Language.[Parameter.TransactionTypeBranch].TransactionType


 insert @TempSummaryBet --bet payout
select 10,108, case when @LangId<>3 then  'Wett Auszahlung' else 'Bahis Kazanc' end  as TransactionType,ISNULL(SUM( Amount ),0)
,COUNT(RiskManagement.BranchTransaction.TransactionTypeId)
from RiskManagement.BranchTransaction INNER JOIN Language.[Parameter.TransactionTypeBranch]
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where  BranchId=@TerminalId and TransactionTypeId in (11,12) and LanguageId=@LangId
and CreateDate >@CashboxCloseDate



-- insert @TempSummaryBet
--select 10,109,'Bet cancellations',ISNULL(SUM(dbo.FuncCurrencyConverter((Amount),CurrencyId,@UserCurrencyId)),0) 
--from RiskManagement.BranchTransaction INNER JOIN Language.[Parameter.TransactionTypeBranch]
--ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
--where UserId=@UserId and TransactionTypeId=9 and LanguageId=@LangId
--and CreateDate >@CashboxCloseDate


declare @CashboxBalance money=0





 insert @TempSummaryBet --Para ödeme,
select 12,112,Language.[Parameter.TransactionTypeBranch].TransactionType,ISNULL(SUM( Amount),0)
,COUNT(Language.[Parameter.TransactionTypeBranch].TransactionType)
from RiskManagement.BranchTransaction INNER JOIN Language.[Parameter.TransactionTypeBranch]
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where BranchId=@TerminalId and TransactionTypeId=16 and LanguageId=@LangId
and CreateDate >@CashboxCloseDate
group by Language.[Parameter.TransactionTypeBranch].TransactionType

declare @TempSummaryBet2 table (Id int,TransactionTypeId int,TransactionType nvarchar(50),Amount Money,TransactionCount int) 

insert @TempSummaryBet2
select * from @TempSummaryBet order by Id





select TransactionType,convert(varchar, cast(ISNULL(Amount,0) as money), 1) as Amount,  @CashboxCloseDate as StartDate,GETDATE() as EndDate ,convert(varchar, (cast((select ISNULL(SUM(Amount),0) From @TempSummaryBet where Id=1) as money)+cast((select ISNULL(SUM(Amount),0) From @TempSummaryBet where Id=4) as money)), 1)  as Balance,@CashboxNumber as ReportNo,TransactionCount  from @TempSummaryBet2 






END



GO
