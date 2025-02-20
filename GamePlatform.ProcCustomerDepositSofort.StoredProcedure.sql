USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerDepositSofort]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcCustomerDepositSofort] 
@CustomerId bigint,
@DepositTransferId bigint,
@IsSuccessfull bit,
@ReferenceCode nvarchar(50),
@Refund int

AS

BEGIN
SET NOCOUNT ON;

declare @Balance money
declare @resultcode int=106
declare @resultmessage nvarchar(max)='Hata oluştu'
declare @Amount money
declare @DepositStatuId int
declare @CurrenyId int=3
declare @TransactionId bigint

declare @CustomerCreateDate datetime
if @IsSuccessfull=1
	begin

		select @CustomerId=CustomerId,@Amount=[Customer].[DepositTransfer].DepositAmount,@DepositStatuId=[DepositStatuId] from [Customer].[DepositTransfer] with (nolock) WHERE DepositTransferId=@DepositTransferId
		
		if (@DepositStatuId=1)
		begin
			insert Customer.[Transaction] (CustomerId,Amount,CurrencyId,TransactionDate,TransactionTypeId,TransactionSourceId)
			values(@CustomerId,@Amount,@CurrenyId,GETDATE(),68,1)
			set @TransactionId=SCOPE_IDENTITY()


			INSERT INTO [RiskManagement].[BranchTransaction]
           ([BranchId]
           ,[CustomerId]
           ,[TransactionTypeId]
           ,[Amount]
           ,[CurrencyId]
           ,[CreateDate]
           ,[UserId]
           ,[SlipId]
           ,[IsView])
     VALUES (1,@CustomerId,17,@Amount,@CurrenyId,GETDATE(),1,@TransactionId,1)

			--select @Balance=ISNULL(Customer.Customer.Balance,0) from Customer.Customer where Customer.CustomerId=@CustomerId

			--set @Balance=@Balance+@Amount

			update Customer.Customer set Balance=Balance+@Amount,@CustomerCreateDate=CreateDate where CustomerId=@CustomerId
		
			--select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=123 and Log.ErrorCodes.LangId=@LangId
	
			UPDATE [Customer].[DepositTransfer]  SET [DepositStatuId] = 2,[UpdateDate] = GetDate(),[CustomerNote]=@ReferenceCode WHERE DepositTransferId=@DepositTransferId

			exec [Bonus].[ProcBonusCustomer]  @CustomerId,@Amount,@CurrenyId,@CustomerCreateDate,2
		--if(select COUNT(*) from Bonus.[Rule] where cast(Bonus.[Rule].BonusStartDate as date)<=CAST(GETDATE() as date) and CAST(Bonus.[Rule].BonusEndDate as date)>CAST(GETDATE() as date)  and Bonus.[Rule].MinAmount<=@Amount and Bonus.[Rule].BonusTypeId=3 )>0
		--	BEGIN
		--		declare @BonusId int=0
		--		select top 1  @BonusId=Bonus.[Rule].BonusRuleId from Bonus.[Rule] where cast(Bonus.[Rule].BonusStartDate as date)<=CAST(GETDATE() as date) and CAST(Bonus.[Rule].BonusEndDate as date)>CAST(GETDATE() as date) and Bonus.[Rule].BonusTypeId=3
				
		--		if(select Count(Customer.Bonus.CustomerBonusId) From Customer.Bonus where Customer.Bonus.CustomerId=@CustomerId and Customer.Bonus.BonusId=@BonusId)=0
		--			begin
		--				declare @BonusAmount money
		--				declare @MaxBonusAmount money
		--				declare @BonusRate float
		--				select top 1 @MaxBonusAmount=Bonus.[Rule].MaxAmount,@BonusRate=Bonus.[Rule].BonusRate from Bonus.[Rule] where BonusRuleId=@BonusId
		--				if(@Amount>=@MaxBonusAmount)
		--					set @BonusAmount=(@MaxBonusAmount/100)*@BonusRate
		--				else
		--					set @BonusAmount=(@Amount/100)*@BonusRate


		--					insert Customer.Bonus (CustomerId,BonusId,CreateDate,BonusAmount) values (@CustomerId,@BonusId,GETDATE(),@BonusAmount)


		--				insert Customer.[Transaction] (CustomerId,Amount,CurrencyId,TransactionDate,TransactionTypeId,TransactionSourceId)
		--				values(@CustomerId,@BonusAmount,@CurrenyId,GETDATE(),35,1)

		--				select @Balance=ISNULL(Customer.Customer.Balance,0) from Customer.Customer where Customer.CustomerId=@CustomerId

		--				set @Balance=@Balance+@BonusAmount

		--				update Customer.Customer set Balance=@Balance where CustomerId=@CustomerId


		--			end

		--	END

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
