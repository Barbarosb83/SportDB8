USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerBonusCashback]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 
CREATE PROCEDURE [GamePlatform].[ProcCustomerBonusCashback] 
@CustomerId bigint
AS

BEGIN
SET NOCOUNT ON;

 declare @ActiveDate datetime
 declare @BonusStartDate datetime
 declare @BonusEndDate datetime
 declare @BonusRate int
 declare @BetStake money
 declare @BetGain money
 declare @CashBack money=0
 declare @BetStakeOrt money=0
 if exists (select BonusRuleId from Bonus.[Rule] where BonusTypeId=5 and BonusEndDate>=Getdate())
 begin
	if exists (Select Customer.BonusRequest.CustomerId from Customer.BonusRequest where CustomerId=@CustomerId and BonusId=5 and (Select count(CustomerId) from Customer.Customer where BranchId in (32377,32350,32348,32342,32332,32352,32342,32377) and CustomerId=@CustomerId)=0)
	begin
			 select @BonusStartDate=CreateDate,@ActiveDate=BonusStartDate from Customer.BonusRequest where CustomerId=@CustomerId and BonusId=5

			 select @BonusEndDate=BonusEndDate,@BonusRate= BonusRate from Bonus.[Rule] where BonusTypeId=5 and BonusEndDate>Getdate()


			 --select @BonusStartDate,@BonusEndDate,@BonusRate
			 if (select COUNT(*) from Customer.[Transaction] with (nolock) where CustomerId=@CustomerId and DATEADD(HOUR,1,TransactionDate)>=@BonusStartDate and DATEADD(HOUR,1,TransactionDate)<@BonusEndDate and TransactionTypeId=4)>1
			 begin
			  select @BetStake=ISNULL(SUM(Amount),0) from Customer.[Transaction] with (nolock) where CustomerId=@CustomerId and DATEADD(HOUR,1,TransactionDate)>=@BonusStartDate and DATEADD(HOUR,1,TransactionDate)<@BonusEndDate and TransactionTypeId=4

			  set @BetStakeOrt=@BetStake/(select COUNT(*) from Customer.[Transaction] with (nolock) where CustomerId=@CustomerId and DATEADD(HOUR,1,TransactionDate)>=@BonusStartDate and DATEADD(HOUR,1,TransactionDate)<@BonusEndDate and TransactionTypeId=4)
			  declare @CouponCount int
			  select @CouponCount=COUNT(*) from Customer.[Transaction] with (nolock) where CustomerId=@CustomerId and DATEADD(HOUR,1,TransactionDate)>=@BonusStartDate and DATEADD(HOUR,1,TransactionDate)<@BonusEndDate and TransactionTypeId=4
			  if((select COUNT(*) from Customer.[Transaction] with (nolock) where CustomerId=@CustomerId and DATEADD(HOUR,1,TransactionDate)>=@BonusStartDate and DATEADD(HOUR,1,TransactionDate)<@BonusEndDate and TransactionTypeId=4 and Amount>=@BetStakeOrt)>1 or @CouponCount>8)
			  begin

				  select @BetGain=ISNULL(SUM(Amount),0) from Customer.[Transaction] with (nolock) where CustomerId=@CustomerId and DATEADD(HOUR,1,TransactionDate)>=@BonusStartDate and DATEADD(HOUR,1,TransactionDate)<@BonusEndDate and TransactionTypeId in (3,63,8)

				   set @CashBack=@BetStake-@BetGain

				   if(@CashBack>0)
					set @CashBack=(@CashBack*@BonusRate)/100
					else
						set @CashBack=0
				end
			end
		end
  end
			select @CashBack as CashBackBalance,@BonusStartDate as ActiveDate
END




GO
