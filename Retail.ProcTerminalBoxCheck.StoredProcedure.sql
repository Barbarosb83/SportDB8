USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcTerminalBoxCheck]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcTerminalBoxCheck] 
@UserId int,
@LangId int
AS
BEGIN
SET NOCOUNT ON;


declare @CashboxCloseDate datetime
declare @UserCurrencyId int
declare @BranchId int

declare @SystemCurrencyId int
select top 1 @SystemCurrencyId=SystemCurrencyId from General.Setting 
select @BranchId=Users.Users.UnitCode, @UserCurrencyId=Users.Users.CurrencyId from Users.Users where Users.Users.UserId=@UserId
declare @CashboxNumber bigint=1
 declare @TempSummaryBet table (Id int,TransactionTypeId int,TransactionType nvarchar(50),Amount Money) 
  

  if (select Count(CreateDate) from RiskManagement.BranchTransaction where UserId=@UserId and TransactionTypeId=6 )>0
		select   @CashboxCloseDate=MAX(CreateDate),@CashboxNumber=COUNT(CreateDate)+1 from RiskManagement.BranchTransaction where UserId=@UserId and TransactionTypeId=6  
else
						select top 1 @CashboxCloseDate=MIN(DATEADD(MINUTE,-1,CreateDate)),@CashboxNumber=COUNT(CreateDate)+1 from RiskManagement.BranchTransaction where BranchId=@BranchId and TransactionTypeId=14 

						if @CashboxCloseDate is null
							set @CashboxCloseDate=MIN(DATEADD(MINUTE,-1,GETDATE()))

if(  select COUNT(RiskManagement.BranchTransaction.TransactionTypeId) --Customer Deposit
from RiskManagement.BranchTransaction INNER JOIN Language.[Parameter.TransactionTypeBranch]
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where UserId=@UserId and TransactionTypeId=1 and LanguageId=@LangId
and CreateDate >@CashboxCloseDate
GROUP BY Language.[Parameter.TransactionTypeBranch].TransactionType,RiskManagement.BranchTransaction.TransactionTypeId)>0
	begin
		  insert @TempSummaryBet
		  select 1,RiskManagement.BranchTransaction.TransactionTypeId,Language.[Parameter.TransactionTypeBranch].TransactionType,ISNULL(SUM(ISNULL(Amount,0)),0) 
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

if(  select COUNT(RiskManagement.BranchTransaction.TransactionTypeId) --Terminal Deposit
from RiskManagement.BranchTransaction INNER JOIN Language.[Parameter.TransactionTypeBranch]
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where UserId=@UserId and TransactionTypeId=14 and LanguageId=@LangId
and CreateDate >@CashboxCloseDate
GROUP BY Language.[Parameter.TransactionTypeBranch].TransactionType,RiskManagement.BranchTransaction.TransactionTypeId)>0
	begin
		  insert @TempSummaryBet
		  select 4,RiskManagement.BranchTransaction.TransactionTypeId,Language.[Parameter.TransactionTypeBranch].TransactionType,ISNULL(SUM(ISNULL(Amount,0)),0) 
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



if(select COUNT(RiskManagement.BranchTransaction.BranchTransactionId) -- Customer Withdraw
from RiskManagement.BranchTransaction INNER JOIN Language.[Parameter.TransactionTypeBranch]
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where UserId=@UserId and TransactionTypeId=2 and LanguageId=@LangId
and CreateDate >@CashboxCloseDate
GROUP BY Language.[Parameter.TransactionTypeBranch].TransactionType,RiskManagement.BranchTransaction.TransactionTypeId
)>0
	begin
		 insert @TempSummaryBet
		select 2,RiskManagement.BranchTransaction.TransactionTypeId,Language.[Parameter.TransactionTypeBranch].TransactionType,SUM(ISNULL(Amount,0)) 
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


if(  select COUNT(RiskManagement.BranchTransaction.TransactionTypeId) --Terminal Withdraw
from RiskManagement.BranchTransaction INNER JOIN Language.[Parameter.TransactionTypeBranch]
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where UserId=@UserId and TransactionTypeId=15 and LanguageId=@LangId
and CreateDate >@CashboxCloseDate
GROUP BY Language.[Parameter.TransactionTypeBranch].TransactionType,RiskManagement.BranchTransaction.TransactionTypeId)>0
	begin
		  insert @TempSummaryBet
		  select 5,RiskManagement.BranchTransaction.TransactionTypeId,Language.[Parameter.TransactionTypeBranch].TransactionType,ISNULL(SUM(ISNULL(Amount,0)),0) 
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


 insert @TempSummaryBet
select 8,7,Language.[Parameter.TransactionTypeBranch].TransactionType as TransactionType,ISNULL(SUM(ISNULL(Amount,0)),0)
from RiskManagement.BranchTransaction INNER JOIN Language.[Parameter.TransactionTypeBranch]
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where UserId=@UserId and TransactionTypeId=7 and LanguageId=@LangId
and CreateDate >@CashboxCloseDate
group by Language.[Parameter.TransactionTypeBranch].TransactionType


 insert @TempSummaryBet
select 9,107,Language.[Parameter.TransactionTypeBranch].TransactionType as TransactionType,ISNULL(SUM(ISNULL(Amount,0)),0)
from RiskManagement.BranchTransaction INNER JOIN Language.[Parameter.TransactionTypeBranch]
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where UserId=@UserId and TransactionTypeId=10 and LanguageId=@LangId
and CreateDate >@CashboxCloseDate
group by Language.[Parameter.TransactionTypeBranch].TransactionType


 insert @TempSummaryBet
select 10,108, case when @LangId<>3 then  'Wett Auszahlung' else 'Bahis Kazanc' end  as TransactionType,ISNULL(SUM((Amount)),0) 
from RiskManagement.BranchTransaction INNER JOIN Language.[Parameter.TransactionTypeBranch]
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where UserId=@UserId and TransactionTypeId in (11,12) and LanguageId=@LangId
and CreateDate >@CashboxCloseDate



-- insert @TempSummaryBet
--select 10,109,'Bet cancellations',ISNULL(SUM(dbo.FuncCurrencyConverter((Amount),CurrencyId,@UserCurrencyId)),0) 
--from RiskManagement.BranchTransaction INNER JOIN Language.[Parameter.TransactionTypeBranch]
--ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
--where UserId=@UserId and TransactionTypeId=9 and LanguageId=@LangId
--and CreateDate >@CashboxCloseDate


declare @CashboxBalance money=0


--select top 1 @CashboxBalance=ISNULL(RiskManagement.BranchTransaction.CashboxBalance,0) from RiskManagement.BranchTransaction
--						where UserId=@UserId and BranchId=@BranchId order by CreateDate desc


insert @TempSummaryBet
select 3,110,case when @LangId<>3 then 'K.K. Gesamt' else 'M. Toplam' end  ,(select Amount From @TempSummaryBet where Id=1)-(select Amount From @TempSummaryBet where Id=2) as Amount

insert @TempSummaryBet
select 6,110,case when @LangId<>3 then 'Terminal Gesamt' else 'Terminal Toplam' end,(select Amount From @TempSummaryBet where Id=4)-(select ISNULL(Amount,0) From @TempSummaryBet where Id=5) as Amount

insert @TempSummaryBet
select 13,110,case when @LangId<>3 then 'Bargeld Gesamt' else 'Toplam' end ,(select Amount From @TempSummaryBet where Id=1)+(select ISNULL(Amount,0) From @TempSummaryBet where Id=4) as Amount





 insert @TempSummaryBet
select 12,112,Language.[Parameter.TransactionTypeBranch].TransactionType,ISNULL(SUM((Amount)),0)*-1 
from RiskManagement.BranchTransaction INNER JOIN Language.[Parameter.TransactionTypeBranch]
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where UserId=@UserId and TransactionTypeId=16 and LanguageId=@LangId
and CreateDate >@CashboxCloseDate
group by Language.[Parameter.TransactionTypeBranch].TransactionType
--insert @TempSummaryBet
--select 10,111,'Credit Voucher',0

insert @TempSummaryBet
select 11,111,case when @LangId<>3 then 'Wett Gesamt' else 'Bahis Toplam' end ,((select ISNULL(SUM(Amount),0) From @TempSummaryBet where TransactionTypeId=7)+(select ISNULL(SUM(Amount),0) From @TempSummaryBet where TransactionTypeId=107))-((select ISNULL(SUM(Amount),0) From @TempSummaryBet where TransactionTypeId=108)) as Amount




insert @TempSummaryBet
select 14,113,case when @LangId<>3 then 'Profit' else 'Kar/Zarar' end ,(select Amount From @TempSummaryBet where Id=13)+ISNULL((select ISNULL(Amount,0) From @TempSummaryBet where Id=12),0) as Amount

declare @TempSummaryBet2 table (Id int,TransactionTypeId int,TransactionType nvarchar(50),Amount Money) 

insert @TempSummaryBet2
select * from @TempSummaryBet order by Id



--insert RiskManagement.BranchTransaction (BranchId,CustomerId,TransactionTypeId,Amount,CurrencyId,CreateDate,UserId,[CashboxBalance])
--								values(@BranchId,null,6,(select ISNULL(SUM(Amount),0) From @TempSummaryBet where Id=11),@UserCurrencyId,GETDATE(),@UserId,0)


select TransactionType,convert(varchar, cast(ISNULL(Amount,0) as money), 1) as Amount,convert(varchar(20), @CashboxCloseDate,113)+' - '+convert(varchar(20), GETDATE(),113) as Period,convert(varchar, (cast((select ISNULL(SUM(Amount),0) From @TempSummaryBet where Id=1) as money)+cast((select ISNULL(SUM(Amount),0) From @TempSummaryBet where Id=4) as money)), 1)  as Balance,@CashboxNumber as ReportNo  from @TempSummaryBet2 






END



GO
