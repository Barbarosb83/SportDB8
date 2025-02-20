USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerDepositCepBank]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcCustomerDepositCepBank] 
@CustomerId bigint,
@CepBankId int,
@RefNoOrGsmPass nvarchar(50),
@SourceTCKN nvarchar(11),
@SourceGSMNo nvarchar(50),
@ReciverGSMNo nvarchar(50),
@ReciverBirthday date,
@DepositAmount money,
@CurrencyId int,
@IsBonus bit
AS

BEGIN
SET NOCOUNT ON;

declare @DepositCepBankId bigint


insert Customer.DepositCepBank(CustomerId,CepBankId,RefNoOrGsmPass,SourceTCKN,SourceGSMNo,ReciverGSMNo,ReciverBirthday,DepositAmount,CurrencyId,IsBonus,DepositStatuId,CreateDate)
values (@CustomerId,@CepBankId,@RefNoOrGsmPass,@SourceTCKN,@SourceGSMNo,@ReciverGSMNo,@ReciverBirthday,@DepositAmount,@CurrencyId,@IsBonus,1,GETDATE())

set @DepositCepBankId=SCOPE_IDENTITY()

execute Users.Notification 1,0,4,131,''


select @DepositCepBankId


END


GO
