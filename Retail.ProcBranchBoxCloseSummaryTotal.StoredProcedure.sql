USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcBranchBoxCloseSummaryTotal]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcBranchBoxCloseSummaryTotal]
@BranchId int,
@StartDate datetime,
@EndDate datetime,
@LangId int
AS


BEGIN
SET NOCOUNT ON;


declare @CashboxCloseDate datetime
declare @UserCurrencyId int
 declare @UserId int
declare @CasBoxstartDate datetime
declare @SystemCurrencyId int
declare @UserName nvarchar(100)
select top 1 @SystemCurrencyId=SystemCurrencyId from General.Setting with (nolock) 
declare @TransactionId bigint

 declare @TempSummaryBet table (Id int,TransactionTypeId int,TransactionType nvarchar(50),Amount Money) 

 declare @TempBranchBoxClose table (UserId int,Username nvarchar(100),CreateDate datetime,KKIn money,KKAut money, BetStake money,Tax money,CancelBet money,BetPayOut money,CreditVoucher money )
  

   set nocount on
					declare cur111 cursor local for(
					select BranchId,RiskManagement.BranchTransaction.UserId,BranchTransactionId,UserName,Users.Users.CurrencyId from RiskManagement.BranchTransaction with (nolock) INNER JOIN Users.Users with (nolock) ON USers.Users.UserId=RiskManagement.BranchTransaction.UserId
					where BranchId=@BranchId and TransactionTypeId=6 and  cast(RiskManagement.BranchTransaction.CreateDate as date)>=cast(@StartDate as date) and cast(RiskManagement.BranchTransaction.CreateDate as date)<=cast(@EndDate as date)

						)
						 order by RiskManagement.BranchTransaction.CreateDate desc
					open cur111
					fetch next from cur111 into @BranchId,@UserId,@TransactionId,@UserName,@UserCurrencyId
					while @@fetch_status=0
						begin
							begin

  select top 1 @CasBoxstartDate=CreateDate from RiskManagement.BranchTransaction with (nolock) where BranchTransactionId=@TransactionId order by CreateDate desc

  if (select Count(CreateDate) from RiskManagement.BranchTransaction with (nolock) where UserId=@UserId and TransactionTypeId=6 and BranchTransactionId<@TransactionId )>0
		select top 1 @CashboxCloseDate=CreateDate from RiskManagement.BranchTransaction with (nolock) where UserId=@UserId and TransactionTypeId=6 and BranchTransactionId<@TransactionId order by CreateDate desc
else
			select top 1 @CashboxCloseDate=CreateDate from RiskManagement.BranchTransaction with (nolock) where BranchId=@BranchId and TransactionTypeId=3 order by CreateDate desc

			if(@CashboxCloseDate is null)
			select  top 1 @CashboxCloseDate=CreateDate from RiskManagement.BranchTransaction with (nolock) where BranchId=@BranchId and UserId=@UserId  order by CreateDate asc

insert @TempBranchBoxClose (UserId,Username,CreateDate) values (@UserId,@UserName,@CasBoxstartDate)



--if(  select COUNT(RiskManagement.BranchTransaction.TransactionTypeId)
--from RiskManagement.BranchTransaction with (nolock) INNER JOIN Language.[Parameter.TransactionTypeBranch] with (nolock)
--ON Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId=RiskManagement.BranchTransaction.TransactionTypeId
--where UserId=@UserId and TransactionTypeId=1 and LanguageId=@LangId
--and CreateDate >@CashboxCloseDate and BranchTransactionId<@TransactionId
--GROUP BY Language.[Parameter.TransactionTypeBranch].TransactionType,RiskManagement.BranchTransaction.TransactionTypeId)>0
--	begin
		 
	update @TempBranchBoxClose set KKIn=	ISNULL( ( select ISNULL(SUM(ISNULL(Amount,0)),0) 
		from RiskManagement.BranchTransaction with (nolock)  
		where UserId=@UserId and TransactionTypeId=1  and BranchTransactionId<@TransactionId
		and CreateDate >@CashboxCloseDate
	 ),0) where UserId=@UserId and CreateDate=@CasBoxstartDate
--	end
--else
--	begin
--		update @TempBranchBoxClose set KKIn=0 where UserId=@UserId and CreateDate=@CasBoxstartDate


--	end

 

--if(select COUNT(RiskManagement.BranchTransaction.BranchTransactionId)
--from RiskManagement.BranchTransaction with (nolock)  
--where UserId=@UserId and TransactionTypeId=2  
--and CreateDate >@CashboxCloseDate and BranchTransactionId<@TransactionId
 
--)>0
--	begin
	 
		 	update @TempBranchBoxClose set KKAut=ISNULL( (select SUM(ISNULL(Amount,0)) 
		from RiskManagement.BranchTransaction with (nolock)  
		where UserId=@UserId and TransactionTypeId=2  
		and CreateDate >@CashboxCloseDate and BranchTransactionId<@TransactionId),0)  where UserId=@UserId and CreateDate=@CasBoxstartDate
--	end
--else
--	begin
--		update @TempBranchBoxClose set KKAut=0 where UserId=@UserId and CreateDate=@CasBoxstartDate
		
--	end


 
update @TempBranchBoxClose set BetStake= ISNULL((select  ISNULL(SUM(ISNULL(Amount,0)),0)
from RiskManagement.BranchTransaction with (nolock)  
where UserId=@UserId and TransactionTypeId=7 
and CreateDate >@CashboxCloseDate and BranchTransactionId<@TransactionId ),0) where UserId=@UserId and CreateDate=@CasBoxstartDate

 
update @TempBranchBoxClose set Tax= ISNULL((select ISNULL(SUM(ISNULL(Amount,0)),0)
from RiskManagement.BranchTransaction with (nolock)  
where UserId=@UserId and TransactionTypeId=10  
and CreateDate >@CashboxCloseDate and BranchTransactionId<@TransactionId),0)  where UserId=@UserId and CreateDate=@CasBoxstartDate


 
update @TempBranchBoxClose set BetPayOut= ISNULL((select  ISNULL(SUM((Amount)),0) 
from RiskManagement.BranchTransaction with (nolock) 
where UserId=@UserId and TransactionTypeId in (11,8)  
and CreateDate >@CashboxCloseDate and BranchTransactionId<@TransactionId),0)  where UserId=@UserId and CreateDate=@CasBoxstartDate



  
update @TempBranchBoxClose set CancelBet= ISNULL((select  ISNULL(SUM((Amount)),0) 
from RiskManagement.BranchTransaction with (nolock)  
where UserId=@UserId and TransactionTypeId=9 
and CreateDate >@CashboxCloseDate and BranchTransactionId<@TransactionId ),0)  where UserId=@UserId and CreateDate=@CasBoxstartDate



--declare @CashboxBalance money=0


--select top 1 @CashboxBalance=ISNULL(RiskManagement.BranchTransaction.CashboxBalance,0) from RiskManagement.BranchTransaction
--						where UserId=@UserId and BranchId=@BranchId and BranchTransactionId<@TransactionId order by CreateDate desc


--update @TempBranchBoxClose set CancelBet= 

--insert @TempSummaryBet
--select 3,110,'Customer Total',ISNULL((select Amount From @TempSummaryBet where Id=1),0)-ISNULL((select Amount From @TempSummaryBet where Id=2),0) as Amount


 
update @TempBranchBoxClose set CreditVoucher=  ISNULL((select ISNULL(SUM((Amount)),0) *-1
from RiskManagement.BranchTransaction with (nolock)  
where UserId=@UserId and TransactionTypeId=16 
and CreateDate >@CashboxCloseDate and BranchTransactionId<@TransactionId),0)  where UserId=@UserId and CreateDate=@CasBoxstartDate

--insert @TempSummaryBet
--select 8,111,'Bet Total',(select ISNULL(SUM(Amount),0) From @TempSummaryBet where TransactionTypeId=7)+((select ISNULL(SUM(Amount),0) From @TempSummaryBet where TransactionTypeId=107))-(select ISNULL(SUM(Amount),0) From @TempSummaryBet where TransactionTypeId=108)-(select ISNULL(SUM(Amount),0) From @TempSummaryBet where TransactionTypeId=109) as Amount

 



--insert RiskManagement.BranchTransaction (BranchId,CustomerId,TransactionTypeId,Amount,CurrencyId,CreateDate,UserId,[CashboxBalance])
--								values(@BranchId,null,6,@CashboxBalance,@UserCurrencyId,GETDATE(),@UserId,0)



 	end
							fetch next from cur111 into   @BranchId,@UserId,@TransactionId,@UserName,@UserCurrencyId
			
						end
					close cur111
					deallocate cur111



INSERT INTO [RiskManagement].[BranchCloseBoxReport]
           ( [BranchId]
           ,[UserId]
           ,[Username]
           ,[CreateDate]
           ,[CustomerDeposit]
           ,[CustomerWithdraw]
           ,[CustomerTotal]
           ,[BetStake]
           ,[Tax]
           ,[CancelBet]
           ,[BetPayout]
           ,[BetTotal]
           ,[CreditVoucher]
           ,[Balance])
     
select @BranchId,UserId ,Username ,CreateDate ,KKIn ,KKAut ,KKIn-KKAut as KKBalance, BetStake ,Tax ,CancelBet,BetPayOut,(BetStake+Tax)-(CancelBet+BetPayOut) as BetTotal ,CreditVoucher,(KKIn-KKAut)+((BetStake+Tax)-(CancelBet+BetPayOut))+CreditVoucher as Balance 
 from @TempBranchBoxClose  

--select TransactionType,convert(varchar, cast(ISNULL(Amount,0) as money), 1) as Amount
--,convert(varchar(20), @CashboxCloseDate,113)+' - '+convert(varchar(20), @CasBoxstartDate,113) as Period
--,convert(varchar, (cast((select ISNULL(SUM(Amount),0) From @TempSummaryBet where Id=3) as money)+cast((select ISNULL(SUM(Amount),0) From @TempSummaryBet where Id=8) as money)+cast((select ISNULL(SUM(Amount),0) From @TempSummaryBet where Id=9) as money)), 1)  as Balance  from @TempSummaryBet2 






END



GO
