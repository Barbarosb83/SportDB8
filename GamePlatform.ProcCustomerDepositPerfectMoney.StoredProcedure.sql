USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerDepositPerfectMoney]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [GamePlatform].[ProcCustomerDepositPerfectMoney] 
@CustomerId bigint,
@TransferDateTime datetime,
@TransferSourceId int,
@CustomerNote nvarchar(50),
@TransferBankId int,
@TransferBankAcountId int,
@DepositAmount money,
@CurrencyId int,
@IsBonus bit
AS

BEGIN
SET NOCOUNT ON;

declare @DepositTransferId bigint
declare @Balance money
declare @resultcode int=106
declare @resultmessage nvarchar(max)='Hata oluştu'
declare @Amount money=@DepositAmount
declare @DepositStatuId int
declare @CurrenyId int=3
declare @CustomerCreateDate datetime

insert Customer.DepositTransfer (CustomerId,TransferDateTime,TransferSourceId,CustomerNote,TransferBankId,TransferBankAcountId,DepositAmount,CurrencyId,IsBonus,DepositStatuId,CreateDate)
values (@CustomerId,@TransferDateTime,@TransferSourceId,@CustomerNote,@TransferBankId,@TransferBankAcountId,@DepositAmount,@CurrencyId,@IsBonus,1,GETDATE())

set @DepositTransferId=SCOPE_IDENTITY()

insert Customer.[Transaction] (CustomerId,Amount,CurrencyId,TransactionDate,TransactionTypeId,TransactionSourceId)
			values(@CustomerId,@DepositAmount,@CurrencyId,GETDATE(),55,1)

			select @Balance=ISNULL(Customer.Customer.Balance,0),@CustomerCreateDate=CreateDate from Customer.Customer where Customer.CustomerId=@CustomerId

			set @Balance=@Balance+@Amount

			update Customer.Customer set Balance=@Balance where CustomerId=@CustomerId
		
			select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=123 and Log.ErrorCodes.LangId=2
	
			UPDATE [Customer].[DepositTransfer]  SET [DepositStatuId] = 2,[UpdateDate] = GetDate()  WHERE DepositTransferId=@DepositTransferId
			exec [Bonus].[ProcBonusCustomer]  @CustomerId,@Amount,@CurrenyId,@CustomerCreateDate,2

END

select @resultcode as resultcode,@resultmessage as resultmessage


GO
