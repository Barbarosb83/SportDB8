USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Job].[CustomerLimitUpdate]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Job].[CustomerLimitUpdate]

AS

BEGIN

		declare @CustomerId bigint
	declare @StakeDay money
	declare @StakeWeek money
	declare @StakeMonth money
	declare @DepositDay money
	declare @DepositWeek money
	declare @DepositMonth money
	declare @LossDay money
	declare @LossWeek money
	declare @LossMonth money
	declare @CurrencyId  int
	declare @SystemCurrency int


	declare @TempTable table (CustomerId bigint,StakeDailyLimit money,StakeWeeklyLimit money,StakeMonthlyLimit money,DepositDay money,DepositWeek money,DepositMonth money,LossDay money,LossWeek money,LossMonth money)
 

	update Customer.Customer set IsActive=0,IsActiveChangeDate=GETDATE(),IsActiveChangeUser='System (Validation timed out) ' where CustomerId in (
	select Customer.CustomerId from Customer.PEPControl INNER JOIN Customer.Customer On Customer.CustomerId=Customer.PepControl.CustomerId 
	where IsSanction=0 and  BranchId=32643 and cast(Customer.CreateDate as date)=cast(DATEADD(DAY,-3,GETDATE()) as date))


	insert @TempTable
	select CustomerId,StakeDailyLimitConsumed,StakeWeeklyLimitConsumed,StakeMonthlyLimitConsumed,DepositDailyLimitConsumed,DepositWeeklyLimitConsumed,DepositMonthlyLimitConsumed,LossDailyLimitConsumed,LossWeeklyLimitConsumed,LossMonthlyLimitConsumed 
	from Customer.Limit where  cast(UpdateDate as date)=cast(DATEADD(DAY,-7,GETDATE()) as date)


	select @SystemCurrency=General.Setting.SystemCurrencyId from General.Setting
	 


	set nocount on
					declare cur111 cursor local for(
					select tpm.CustomerId,tpm.StakeDailyLimit,tpm.StakeWeeklyLimit,tpm.StakeMonthlyLimit,Customer.Customer.CurrencyId,tpm.DepositDay,tpm.DepositWeek,tpm.DepositMonth 
					,tpm.LossDay,tpm.LossWeek,tpm.LossMonth
					from @TempTable as tpm INNER JOIN Customer.Customer ON
					tpm.CustomerId=Customer.CustomerId

						)

					open cur111
					fetch next from cur111 into @CustomerId,@StakeDay,@StakeWeek,@StakeMonth,@CurrencyId,@DepositDay,@DepositWeek,@DepositMonth,@LossDay,@LossWeek,@LossMonth
					while @@fetch_status=0
						begin
							begin

							update Customer.StakeLimit set 
							StakeDay=@StakeDay
							,StakeWeek=@StakeWeek
							,StakeMonth=@StakeMonth

							,[DepositDay]=@DepositDay
							,[DepositWeek]=@DepositWeek
							,[DepositMonth]=@DepositMonth
							,[LossDay]=@LossDay
							,[LossWeek]=@LossWeek
							,[LossMonth]=@LossMonth
							where CustomerId=@CustomerId



							end
							fetch next from cur111 into @CustomerId,@StakeDay,@StakeWeek,@StakeMonth,@CurrencyId,@DepositDay,@DepositWeek,@DepositMonth,@LossDay,@LossWeek,@LossMonth
			
						end
					close cur111
					deallocate cur111	







END



GO
