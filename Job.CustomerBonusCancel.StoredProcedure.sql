USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Job].[CustomerBonusCancel]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Job].[CustomerBonusCancel]

AS

BEGIN

	
	declare @TempTable table (CustomerId bigint,Bonus money,BonusId bigint)

	insert @TempTable
	select CustomerId,BonusAmount,CustomerBonusId from Customer.Bonus where IsActive=1 and cast(ExpriedDate as date)=cast(GETDATE() as date)



	update Customer.Bonus set IsActive=0 where IsActive=1 and cast(ExpriedDate as date)=cast(GETDATE() as date)


	declare @CustomerId bigint
	declare @BonusAmount bigint
	declare @CurrencyId int
	declare @BonusId bigint


	set nocount on
					declare cur111 cursor local for(
					select tpm.CustomerId,tpm.Bonus,Customer.Customer.CurrencyId,tpm.BonusId from @TempTable as tpm INNER JOIN Customer.Customer ON
					tpm.CustomerId=Customer.CustomerId

						)

					open cur111
					fetch next from cur111 into @CustomerId,@BonusAmount,@CurrencyId,@BonusId
					while @@fetch_status=0
						begin
							begin

							update Customer.Customer set Bonus=Bonus-@BonusAmount where CustomerId=@CustomerId

							insert Customer.[Transaction] (CustomerId,Amount,CurrencyId,TransactionDate,TransactionTypeId,TransactionSourceId,TransactionComment)
													values(@CustomerId,@BonusAmount,@CurrencyId,GETDATE(),49,1,cast(@BonusId as nvarchar(50)))



							end
							fetch next from cur111 into @CustomerId,@BonusAmount,@CurrencyId,@BonusId
			
						end
					close cur111
					deallocate cur111	







END



GO
