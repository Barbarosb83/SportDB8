USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerTax]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcCustomerTax] 
@CustomerId bigint,
@SlipId bigint,
@TotalAmount money,
@SlipAmount money,
@TaxAmount money,
@CurrencyId int,
@TransactionTypeId int,
@TaxStatusId int
AS

BEGIN
SET NOCOUNT ON;

declare @Balance money



 insert Customer.Tax ([CustomerId],[SlipId],[TotalAmount],[SlipAmount],[TaxAmount],[CurrencyId],[TransactionTypeId],[TaxStatusId])
 values (
 @CustomerId
 ,@SlipId
 ,@TotalAmount
 ,@SlipAmount
 ,@TaxAmount
 ,@CurrencyId
 ,@TransactionTypeId
 ,@TaxStatusId
 )





--insert Customer.[Transaction] (CustomerId,Amount,CurrencyId,TransactionDate,TransactionTypeId,TransactionSourceId)
--values(@CustomerId,@Amount,@CurrenyId,GETDATE(),7,1)

select @Balance=ISNULL(Customer.Customer.Balance,0) from Customer.Customer where Customer.CustomerId=@CustomerId


--set @Balance=@Balance+@Amount

--update Customer.Customer set Balance=@Balance where CustomerId=@CustomerId

select @Balance as Balance

END


GO
