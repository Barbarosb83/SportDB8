USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerBonusCashbackJOB]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 CREATE PROCEDURE [GamePlatform].[ProcCustomerBonusCashbackJOB] 

AS

BEGIN
SET NOCOUNT ON;
declare @CustomerId bigint
 declare @BonusStartDate datetime
 declare @BonusEndDate datetime
 declare @BonusRate int
 declare @BetStake money
 declare @BetGain money
 declare @CashBack money=0
 declare @BetStakeOrt money=0
 declare @BonusId int
 declare @Balance money=0

 declare @temptable table (CustomerId bigint,cashback money)
 declare @Counter int=0
  select @BonusEndDate=BonusEndDate,@BonusRate= 20,@BonusId=2,@BonusStartDate=BonusStartDate from Bonus.[Rule] where BonusTypeId=5 


  update Customer.Bonus set IsActive=0 where IsActive=1 and BonusId=2
	set nocount on
					declare cur111 cursor local for(
					select distinct CustomerId,CreateDate from Customer.BonusRequest with (nolock) where  
					IsEnable=1 and  CustomerId not in (select CustomerId from Customer.Customer where 
  (IsBranchCustomer=1 or IsBranchCustomer is null) and (IsTerminalCustomer=1 or IsTerminalCustomer is null)
 
  )   
					 

						)

					open cur111
					fetch next from cur111 into @CustomerId,@BonusStartDate 
					while @@fetch_status=0
						begin
							begin
				set @BetGain=0
				set @BetGain=0
				set @BetStakeOrt=0
				set @CashBack=0
				set @Balance=0
			 if (select COUNT(*) from Customer.[Transaction] with (nolock) where CustomerId=@CustomerId and DATEADD(HOUR,2,TransactionDate)>=@BonusStartDate and DATEADD(HOUR,2,TransactionDate)<@BonusEndDate and TransactionTypeId=4)>1
			 begin
			  select @BetStake=ISNULL(SUM(Amount),0) from Customer.[Transaction] with (nolock) where CustomerId=@CustomerId and DATEADD(HOUR,2,TransactionDate)>=@BonusStartDate and DATEADD(HOUR,2,TransactionDate)<@BonusEndDate and TransactionTypeId=4

			  set @BetStakeOrt=@BetStake/(select COUNT(*) from Customer.[Transaction] with (nolock) where CustomerId=@CustomerId and DATEADD(HOUR,2,TransactionDate)>=@BonusStartDate and DATEADD(HOUR,2,TransactionDate)<@BonusEndDate and TransactionTypeId=4)
			   declare @CouponCount int
			  select @CouponCount=COUNT(*) from Customer.[Transaction] with (nolock) where CustomerId=@CustomerId and DATEADD(HOUR,2,TransactionDate)>=@BonusStartDate and DATEADD(HOUR,2,TransactionDate)<@BonusEndDate and TransactionTypeId=4
			  if((select COUNT(*) from Customer.[Transaction] with (nolock) where CustomerId=@CustomerId and DATEADD(HOUR,2,TransactionDate)>=@BonusStartDate and DATEADD(HOUR,2,TransactionDate)<@BonusEndDate and TransactionTypeId=4 and Amount>=@BetStakeOrt)>1 or @CouponCount>8)
			  begin

				  select @BetGain=ISNULL(SUM(Amount),0) from Customer.[Transaction] with (nolock) where CustomerId=@CustomerId and DATEADD(HOUR,2,TransactionDate)>=@BonusStartDate and DATEADD(HOUR,2,TransactionDate)<@BonusEndDate and TransactionTypeId in (3,63,8)

				   set @CashBack=@BetStake-@BetGain
				   
				   if(@CashBack>0)
					begin
					set @CashBack=(@CashBack*@BonusRate)/100
							if not exists (Select CustomerId from Customer.Bonus with (nolock) where   BonusId=8 and IsActive=1)
							begin
									select @Balance= Customer.Customer.Balance from Customer.Customer with (nolock) where CustomerId=@CustomerId
									insert Customer.Bonus (CustomerId,BonusId,CreateDate,BonusAmount,ExpriedDate,IsActive,IsUsed,DepositAmount) values (@CustomerId,@BonusId,@BonusStartDate,@CashBack, GETDATE(),1,1,@CashBack)
									set @Balance=@Balance+@CashBack
									insert Customer.[Transaction] (CustomerId,Amount,CurrencyId,TransactionDate,TransactionTypeId,TransactionSourceId,TransactionComment,TransactionBalance)
									values(@CustomerId,@CashBack,3,GETDATE(),35,1,cast(@BonusId as nvarchar(50))+' - Cashback',@Balance)

								    update Customer.Customer set Balance=Balance+@CashBack where CustomerId=@CustomerId
								 --insert @temptable values (@CustomerId,@CashBack)
							 

							end
					end
					else
						set @CashBack=0
				end
			end
			end
							fetch next from cur111 into @CustomerId,@BonusStartDate 
			
						end
					close cur111
					deallocate cur111

				 
				  

		   update Bonus.[Rule] set BonusStartDate='20211021',BonusEndDate=DATEADD(MONTH,1,GETDATE()) where BonusTypeId=5 
			update Customer.BonusRequest set CreateDate='2021-10-21 00:00:00.000'

 --select * from @temptable
 --select * from Customer.[Transaction] where CustomerId in (
 --select CustomerId from @temptable) and TransactionTypeId=35 order by TransactionId desc
END




GO
