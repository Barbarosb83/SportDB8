USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerDepositTransfer]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [GamePlatform].[ProcCustomerDepositTransfer] 
@CustomerId bigint,
@TransferDateTime datetime,
@TransferSourceId int,
@CustomerNote nvarchar(50),
@TransferBankId int,
@TransferBankAcountId int,
@DepositAmount money,
@CurrencyId int,
@IsBonus bit,
@TransactionTypeId int
AS

BEGIN
SET NOCOUNT ON;

declare @DepositTransferId bigint


insert Customer.DepositTransfer (CustomerId,TransferDateTime,TransferSourceId,CustomerNote,TransferBankId,TransferBankAcountId,DepositAmount,CurrencyId,IsBonus,DepositStatuId,CreateDate,TransactionTypeId)
values (@CustomerId,@TransferDateTime,@TransferSourceId,@CustomerNote,@TransferBankId,@TransferBankAcountId,@DepositAmount,3,@IsBonus,1,GETDATE(),@TransactionTypeId)

set @DepositTransferId=SCOPE_IDENTITY()

execute Users.Notification 1,0,5,132,''


select @DepositTransferId


END


GO
