USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcBranchBoxCheck]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcBranchBoxCheck] 
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
select @BranchId=Users.Users.UnitCode, @UserCurrencyId=Users.Users.CurrencyId from Users.Users with (nolock) where Users.Users.UserId=@UserId

 declare @TempSummaryBet table (Id int,TransactionTypeId int,TransactionType nvarchar(50),Amount Money) 
  
   if (select Count(CreateDate) from RiskManagement.BranchTransaction where UserId=@UserId and TransactionTypeId=6 )>0
		select top 1 @CashboxCloseDate=CreateDate from RiskManagement.BranchTransaction with (nolock) where UserId=@UserId and TransactionTypeId=6 order by CreateDate desc
else if (select COUNT(BranchTransactionId) from RiskManagement.BranchTransaction with (nolock) where BranchId=@BranchId and TransactionTypeId=3 )>0
	select top 1 @CashboxCloseDate=CreateDate from RiskManagement.BranchTransaction with (nolock) where BranchId=@BranchId and TransactionTypeId=3 order by CreateDate desc
		else
	select top 1 @CashboxCloseDate=DATEADD(MINUTE,-1,CreateDate) from RiskManagement.BranchTransaction with (nolock) where BranchId=@BranchId  order by CreateDate asc

 
 
if(  select COUNT(RiskManagement.BranchTransaction.TransactionTypeId)
from RiskManagement.BranchTransaction with (nolock) INNER JOIN Language.[Parameter.TransactionTypeBranch] with (nolock)
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where UserId=@UserId and TransactionTypeId=1 and LanguageId=@LangId
and CreateDate >@CashboxCloseDate
GROUP BY Language.[Parameter.TransactionTypeBranch].TransactionType,RiskManagement.BranchTransaction.TransactionTypeId)>0
	begin
		  insert @TempSummaryBet
		  select 1,RiskManagement.BranchTransaction.TransactionTypeId,Language.[Parameter.TransactionTypeBranch].TransactionType,ISNULL(SUM(ISNULL(Amount,0)),0) 
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



if(select COUNT(RiskManagement.BranchTransaction.BranchTransactionId)
from RiskManagement.BranchTransaction with (nolock) INNER JOIN Language.[Parameter.TransactionTypeBranch] with (nolock)
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where UserId=@UserId and TransactionTypeId=2 and LanguageId=@LangId
and CreateDate >@CashboxCloseDate
GROUP BY Language.[Parameter.TransactionTypeBranch].TransactionType,RiskManagement.BranchTransaction.TransactionTypeId
)>0
	begin
		 insert @TempSummaryBet
		select 2,RiskManagement.BranchTransaction.TransactionTypeId,Language.[Parameter.TransactionTypeBranch].TransactionType,SUM(ISNULL(Amount,0)) 
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




 insert @TempSummaryBet
select 4,7,'Wett. Einsatz' as TransactionType,ISNULL(SUM(ISNULL(Amount,0)),0)
from RiskManagement.BranchTransaction with (nolock) INNER JOIN Language.[Parameter.TransactionTypeBranch] with (nolock)
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where UserId=@UserId and TransactionTypeId=7 and LanguageId=@LangId
and CreateDate >@CashboxCloseDate


 insert @TempSummaryBet
select 5,107,'Gebühr' as TransactionType,ISNULL(SUM(ISNULL(Amount,0)),0) 
from RiskManagement.BranchTransaction with (nolock) INNER JOIN Language.[Parameter.TransactionTypeBranch] with (nolock)
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where UserId=@UserId and TransactionTypeId=10 and LanguageId=@LangId
and CreateDate >@CashboxCloseDate


 insert @TempSummaryBet
select 6,108,'Wett Auszahlung' as TransactionType,ISNULL(SUM((Amount)),0)
from RiskManagement.BranchTransaction with (nolock) INNER JOIN Language.[Parameter.TransactionTypeBranch] with (nolock)
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where UserId=@UserId and TransactionTypeId in (11,8) and LanguageId=@LangId
and CreateDate >@CashboxCloseDate





 insert @TempSummaryBet
select 7,109,'Wett. Storno',ISNULL(SUM((Amount)),0) 
from RiskManagement.BranchTransaction with (nolock) INNER JOIN Language.[Parameter.TransactionTypeBranch] with (nolock)
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where UserId=@UserId and TransactionTypeId=9 and LanguageId=@LangId
and CreateDate >@CashboxCloseDate
 


insert @TempSummaryBet
select 3,110,'K.K. Total',(select Amount From @TempSummaryBet where Id=1)-(select Amount From @TempSummaryBet where Id=2) as Amount


--insert @TempSummaryBet
--select 7,111,'Credit Voucher',0

 insert @TempSummaryBet
select 9,111,'Guthaben Aus.',ISNULL(SUM((Amount)),0)*-1
from RiskManagement.BranchTransaction with (nolock) INNER JOIN Language.[Parameter.TransactionTypeBranch] with (nolock)
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where UserId=@UserId and TransactionTypeId=16 and LanguageId=@LangId
and CreateDate >@CashboxCloseDate


insert @TempSummaryBet
select 8,111,'Wett. Total',(select ISNULL(SUM(Amount),0) From @TempSummaryBet where TransactionTypeId=7)+((select ISNULL(SUM(Amount),0) From @TempSummaryBet where TransactionTypeId=107))-(select ISNULL(SUM(Amount),0) From @TempSummaryBet where TransactionTypeId=108)-(select ISNULL(SUM(Amount),0) From @TempSummaryBet where TransactionTypeId=109) as Amount



declare @CashboxBalance money=0


select top 1 @CashboxBalance=ISNULL(RiskManagement.BranchTransaction.CashboxBalance,0) from RiskManagement.BranchTransaction with (nolock)
						where UserId=@UserId and BranchId=@BranchId order by CreateDate desc


declare @TempSummaryBet2 table (Id int,TransactionTypeId int,TransactionType nvarchar(50),Amount Money) 

insert @TempSummaryBet2
select * from @TempSummaryBet order by Id

select TransactionType,convert(varchar, cast(Amount as money), 1) as Amount,convert(varchar(20), @CashboxCloseDate,113)+' - '+convert(varchar(20), GETDATE(),113) as Period,convert(varchar,(cast((select ISNULL(SUM(Amount),0) From @TempSummaryBet where Id=3) as money)+cast((select ISNULL(SUM(Amount),0) From @TempSummaryBet where Id=8) as money)+cast((select ISNULL(SUM(Amount),0) From @TempSummaryBet where Id=9) as money)), 1)  as Balance  from @TempSummaryBet2 
UNION ALL
select ' ',' ' as Amount,convert(varchar(20), @CashboxCloseDate,113)+' - '+convert(varchar(20), GETDATE(),113) as Period,convert(varchar,(cast((select ISNULL(SUM(Amount),0) From @TempSummaryBet where Id=3) as money)+cast((select ISNULL(SUM(Amount),0) From @TempSummaryBet where Id=8) as money)+cast((select ISNULL(SUM(Amount),0) From @TempSummaryBet where Id=9) as money)), 1)  as Balance






END



GO
