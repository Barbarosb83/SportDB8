USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerDepositPaypal]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcCustomerDepositPaypal] 
@CustomerId bigint,
@DepositTransferId bigint,
@IsSuccessfull bit,
@ReferenceCode nvarchar(50)

AS

BEGIN
SET NOCOUNT ON;

declare @Balance money
declare @resultcode int=106
declare @resultmessage nvarchar(max)='Hata oluştu'
declare @Amount money
declare @DepositStatuId int
declare @CurrenyId int=3
declare @TransactionType int
declare @CustomerCreateDate datetime
if @IsSuccessfull=1
	begin

		select @CustomerId=CustomerId,@Amount=[Customer].[DepositTransfer].DepositAmount,@DepositStatuId=[DepositStatuId],@CurrenyId=CurrencyId,@TransactionType=TransactionTypeId from [Customer].[DepositTransfer] WHERE DepositTransferId=@DepositTransferId
		
		if (@DepositStatuId=1)
		begin
			select @Balance=ISNULL(Customer.Customer.Balance,0),@CustomerCreateDate=CreateDate from Customer.Customer where Customer.CustomerId=@CustomerId

			insert Customer.[Transaction] (CustomerId,Amount,CurrencyId,TransactionDate,TransactionTypeId,TransactionSourceId,TransactionBalance)
			values(@CustomerId,@Amount,@CurrenyId,GETDATE(),@TransactionType,1,@Balance+@Amount)

			select @Balance=ISNULL(Customer.Customer.Balance,0) from Customer.Customer where Customer.CustomerId=@CustomerId

			set @Balance=@Balance+@Amount

			update Customer.Customer set Balance=@Balance where CustomerId=@CustomerId
		
			--select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=123 and Log.ErrorCodes.LangId=@LangId
	
			UPDATE [Customer].[DepositTransfer]  SET [DepositStatuId] = 2,[UpdateDate] = GetDate(),[CustomerNote]=@ReferenceCode WHERE DepositTransferId=@DepositTransferId

				exec [Bonus].[ProcBonusCustomer]  @CustomerId,@Amount,@CurrenyId,@CustomerCreateDate,2

			--if(select COUNT(*) from Bonus.[Rule] INNER JOIN Bonus.RuleCashType ON Bonus.[Rule].BonusRuleId=Bonus.RuleCashType.RuleId where cast(Bonus.[Rule].BonusStartDate as date)<=CAST(GETDATE() as date) and CAST(Bonus.[Rule].BonusEndDate as date)>CAST(GETDATE() as date) and Bonus.[Rule].BonusTypeId in (1,3) and Bonus.[Rule].MinAmount<@Amount and Bonus.RuleCashType.CashTypeId=5 )>0
			--BEGIN
				
			--	declare @BonusId int=0
			--	declare @BonusOccurences int=0
			--	select top 1  @BonusId=Bonus.[Rule].BonusRuleId,@BonusOccurences=Bonus.[Rule].BonusOccurences from Bonus.[Rule] INNER JOIN Bonus.RuleCashType ON Bonus.[Rule].BonusRuleId=Bonus.RuleCashType.RuleId where cast(Bonus.[Rule].BonusStartDate as date)<=CAST(GETDATE() as date) and CAST(Bonus.[Rule].BonusEndDate as date)>CAST(GETDATE() as date) and Bonus.[Rule].BonusTypeId=3 and Bonus.[Rule].BonusTypeId in (1,3) and Bonus.[Rule].MinAmount<@Amount and Bonus.RuleCashType.CashTypeId=5
								

			--	if(select Count(Customer.[Transaction].TransactionId) From Customer.[Transaction] where Customer.[Transaction].CustomerId=@CustomerId and Customer.[Transaction].TransactionTypeId in (46) )<=@BonusOccurences
			--		begin
			--			if not exists(Select * from Customer.Bonus where CustomerId=@CustomerId and BonusId=@BonusId and Customer.Bonus.IsUsed=0 and Customer.Bonus.IsActive=0)
			--			begin
			--			declare @BonusAmount money
			--			declare @MaxBonusAmount money
			--			declare @BonusRate float
			--			declare @BonusExpiredDay int
			--			select top 1 @MaxBonusAmount=Bonus.[Rule].MaxAmount,@BonusRate=Bonus.[Rule].BonusRate,@BonusExpiredDay=Bonus.[Rule].BonusExpiredDay from Bonus.[Rule] where Bonus.[Rule].BonusRuleId=@BonusId
			--			if(@Amount>=@MaxBonusAmount)
			--				set @BonusAmount=(@MaxBonusAmount/100)*@BonusRate
			--			else
			--				set @BonusAmount=(@Amount/100)*@BonusRate

			--					insert Customer.Bonus (CustomerId,BonusId,CreateDate,BonusAmount,DepositAmount,ExpriedDate,IsActive,IsUsed) values (@CustomerId,@BonusId,GETDATE(),@BonusAmount,@Amount,DATEADD(DAY,@BonusExpiredDay,GETDATE()) ,1,0)

			--			insert Customer.[Transaction] (CustomerId,Amount,CurrencyId,TransactionDate,TransactionTypeId,TransactionSourceId)
			--			values(@CustomerId,@BonusAmount,@CurrenyId,GETDATE(),35,1)

			--			--select @Balance=ISNULL(Customer.Customer.Balance,0) from Customer.Customer where Customer.CustomerId=@CustomerId

			--			--set @Balance=@Balance+@BonusAmount

			--			update Customer.Customer set Bonus=ISNULL(Bonus,0)+@BonusAmount where CustomerId=@CustomerId
			--			end

			--		end

			--END

		end
	end
else
	begin

		select @DepositStatuId=[DepositStatuId] from [Customer].[DepositTransfer] WHERE DepositTransferId=@DepositTransferId
		

		if (@DepositStatuId=1)
			begin
				UPDATE [Customer].[DepositTransfer]  SET [DepositStatuId] = 3,[UpdateDate] = GetDate(),[CustomerNote]=@ReferenceCode WHERE DepositTransferId=@DepositTransferId
			end
	end
	
	
END


GO
