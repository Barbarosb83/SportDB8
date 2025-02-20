USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerDepositAmount]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcCustomerDepositAmount] 
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
 
		select CustomerId,[Customer].[DepositTransfer].DepositAmount,[DepositStatuId] from [Customer].[DepositTransfer] with (nolock) WHERE DepositTransferId=@DepositTransferId
		 
END


GO
