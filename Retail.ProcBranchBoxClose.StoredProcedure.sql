USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcBranchBoxClose]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcBranchBoxClose] 
@UserId int,
@LangId int
AS
BEGIN
SET NOCOUNT ON;

declare @TransId bigint
declare @CashboxCloseDate datetime
declare @UserCurrencyId int
declare @BranchId int
declare @Username nvarchar(100)
declare @SystemCurrencyId int
select top 1 @SystemCurrencyId=SystemCurrencyId from General.Setting with (nolock)
select @BranchId=Users.Users.UnitCode, @UserCurrencyId=Users.Users.CurrencyId,@Username=UserName from Users.Users with (nolock) where Users.Users.UserId=@UserId
declare @Getdate datetime=GETDATE()
 declare @TempSummaryBet table (Id int,TransactionTypeId int,TransactionType nvarchar(50),Amount Money) 
  

  if (select Count(CreateDate) from RiskManagement.BranchTransaction with (nolock) where UserId=@UserId and TransactionTypeId=6 )>0
		select top 1 @CashboxCloseDate=CreateDate from RiskManagement.BranchTransaction with (nolock) where UserId=@UserId and TransactionTypeId=6 order by CreateDate desc
else if (select COUNT(BranchTransactionId) from RiskManagement.BranchTransaction with (nolock) where BranchId=@BranchId and TransactionTypeId=3 )>0
	select top 1 @CashboxCloseDate=CreateDate from RiskManagement.BranchTransaction with (nolock) where BranchId=@BranchId and TransactionTypeId=3 order by CreateDate desc
		else
			select  top 1 @CashboxCloseDate=DATEADD(MINUTE,-10,CreateDate) from RiskManagement.BranchTransaction with (nolock) where BranchId=@BranchId and UserId=@UserId  order by CreateDate asc
	
		if(@CashboxCloseDate is null)
	select top 1 @CashboxCloseDate=DATEADD(MINUTE,-1,CreateDate) from RiskManagement.BranchTransaction with (nolock) where BranchId=@BranchId  order by CreateDate asc


	insert  [RiskManagement].[BranchCloseBoxReport] ([BranchId],[UserId],[Username],[CreateDate]) values (@BranchId,@UserId,@Username,@Getdate)

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


	update [RiskManagement].[BranchCloseBoxReport] set [CustomerDeposit]= ISNULL(( select Amount from @TempSummaryBet where Id=1),0) where [UserId]=@UserId and [CreateDate]=@Getdate


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


		update [RiskManagement].[BranchCloseBoxReport] set [CustomerWithdraw]=  ISNULL(( select Amount from @TempSummaryBet where Id=2),0) where [UserId]=@UserId and [CreateDate]=@Getdate

 insert @TempSummaryBet
select 4,7,'Bet TurnOver' as TransactionType,ISNULL(SUM(ISNULL(Amount,0)),0)
from RiskManagement.BranchTransaction with (nolock) INNER JOIN Language.[Parameter.TransactionTypeBranch] with (nolock)
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where UserId=@UserId and TransactionTypeId=7 and LanguageId=@LangId
and CreateDate >@CashboxCloseDate


		update [RiskManagement].[BranchCloseBoxReport] set [BetStake]= ISNULL(( select Amount from @TempSummaryBet where Id=4),0) where [UserId]=@UserId and [CreateDate]=@Getdate


 insert @TempSummaryBet
select 5,107,'Tax' as TransactionType,ISNULL(SUM(ISNULL(Amount,0)),0)
from RiskManagement.BranchTransaction with (nolock) INNER JOIN Language.[Parameter.TransactionTypeBranch] with (nolock)
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where UserId=@UserId and TransactionTypeId=10 and LanguageId=@LangId
and CreateDate >@CashboxCloseDate


		update [RiskManagement].[BranchCloseBoxReport] set [Tax]= ISNULL(( select Amount from @TempSummaryBet where Id=5),0) where [UserId]=@UserId and [CreateDate]=@Getdate

 insert @TempSummaryBet
select 6,108,'Bet PayOuts' as TransactionType,ISNULL(SUM((Amount)),0) 
from RiskManagement.BranchTransaction with (nolock) INNER JOIN Language.[Parameter.TransactionTypeBranch] with (nolock)
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where UserId=@UserId and TransactionTypeId in (8,11) and LanguageId=@LangId
and CreateDate >@CashboxCloseDate

	update [RiskManagement].[BranchCloseBoxReport] set [BetPayout]= ISNULL(( select Amount from @TempSummaryBet where Id=6),0) where [UserId]=@UserId and [CreateDate]=@Getdate


 insert @TempSummaryBet
select 7,109,'Bet cancellations',ISNULL(SUM((Amount)),0) 
from RiskManagement.BranchTransaction with (nolock) INNER JOIN Language.[Parameter.TransactionTypeBranch] with (nolock)
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where UserId=@UserId and TransactionTypeId=9 and LanguageId=@LangId
and CreateDate >@CashboxCloseDate


update [RiskManagement].[BranchCloseBoxReport] set [CancelBet]= ISNULL(( select Amount from @TempSummaryBet where Id=7),0) where [UserId]=@UserId and [CreateDate]=@Getdate


declare @CashboxBalance money=0


select top 1 @CashboxBalance=ISNULL(RiskManagement.BranchTransaction.CashboxBalance,0) from RiskManagement.BranchTransaction
						where UserId=@UserId and BranchId=@BranchId order by CreateDate desc


insert @TempSummaryBet
select 3,110,'Customer Total',(select Amount From @TempSummaryBet where Id=1)-(select Amount From @TempSummaryBet where Id=2) as Amount

update [RiskManagement].[BranchCloseBoxReport] set [CustomerTotal]= ISNULL(((select Amount From @TempSummaryBet where Id=1)-(select Amount From @TempSummaryBet where Id=2)),0) where [UserId]=@UserId and [CreateDate]=@Getdate



 insert @TempSummaryBet
select 9,111,'Credit Voucher',ISNULL(SUM((Amount)),0) *-1
from RiskManagement.BranchTransaction with (nolock) INNER JOIN Language.[Parameter.TransactionTypeBranch] with (nolock)
ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
where UserId=@UserId and TransactionTypeId=16 and LanguageId=@LangId
and CreateDate >@CashboxCloseDate


update [RiskManagement].[BranchCloseBoxReport] set [CreditVoucher]= ISNULL(( select Amount from @TempSummaryBet where Id=9),0) where [UserId]=@UserId and [CreateDate]=@Getdate


insert @TempSummaryBet
select 8,111,'Bet Total',(select ISNULL(SUM(Amount),0) From @TempSummaryBet where TransactionTypeId=7)+((select ISNULL(SUM(Amount),0) From @TempSummaryBet where TransactionTypeId=107))-(select ISNULL(SUM(Amount),0) From @TempSummaryBet where TransactionTypeId=108)-(select ISNULL(SUM(Amount),0) From @TempSummaryBet where TransactionTypeId=109) as Amount


update [RiskManagement].[BranchCloseBoxReport] set [BetTotal]= ISNULL(( (select ISNULL(SUM(Amount),0) From @TempSummaryBet where TransactionTypeId=7)+((select ISNULL(SUM(Amount),0) From @TempSummaryBet where TransactionTypeId=107))-(select ISNULL(SUM(Amount),0) From @TempSummaryBet where TransactionTypeId=108)-(select ISNULL(SUM(Amount),0) From @TempSummaryBet where TransactionTypeId=109)),0) where [UserId]=@UserId and [CreateDate]=@Getdate


declare @TempSummaryBet2 table (Id int,TransactionTypeId int,TransactionType nvarchar(50),Amount Money) 

insert @TempSummaryBet2
select * from @TempSummaryBet order by Id

update [RiskManagement].[BranchCloseBoxReport] set [Balance]=ISNULL((cast((select ISNULL(SUM(Amount),0) From @TempSummaryBet where Id=3) as money)+cast((select ISNULL(SUM(Amount),0) From @TempSummaryBet where Id=8) as money)+cast((select ISNULL(SUM(Amount),0) From @TempSummaryBet where Id=9) as money)),0)  where [UserId]=@UserId and [CreateDate]=@Getdate


insert RiskManagement.BranchTransaction (BranchId,CustomerId,TransactionTypeId,Amount,CurrencyId,CreateDate,UserId,[CashboxBalance])
								values(@BranchId,null,6,(cast((select ISNULL(SUM(Amount),0) From @TempSummaryBet where Id=3) as money)+cast((select ISNULL(SUM(Amount),0) From @TempSummaryBet where Id=8) as money)+cast((select ISNULL(SUM(Amount),0) From @TempSummaryBet where Id=9) as money)),@UserCurrencyId,GETDATE(),@UserId,0)

		set @TransId=SCOPE_IDENTITY()

update [RiskManagement].[BranchCloseBoxReport] set TransactionId=@TransId  where [UserId]=@UserId and [CreateDate]=@Getdate



select TransactionType,convert(varchar, cast(ISNULL(Amount,0) as money), 1) as Amount,convert(varchar(20), @CashboxCloseDate,113)+' - '+convert(varchar(20), GETDATE(),113) as Period,convert(varchar, (cast((select ISNULL(SUM(Amount),0) From @TempSummaryBet where Id=3) as money)+cast((select ISNULL(SUM(Amount),0) From @TempSummaryBet where Id=8) as money)+cast((select ISNULL(SUM(Amount),0) From @TempSummaryBet where Id=9) as money)), 1)  as Balance  from @TempSummaryBet2 






END



GO
