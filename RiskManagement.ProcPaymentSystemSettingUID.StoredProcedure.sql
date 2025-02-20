USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcPaymentSystemSettingUID]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcPaymentSystemSettingUID]
@PaymentSystemSettingId int,
@OxxoUserName nvarchar(max),
@OxxoPassword nvarchar(max),
@OxxoHashCode nvarchar(max),
@OxxoUrl nvarchar(max),
@NetellerMerchantId nvarchar(max),
@NetellerMerchantKey nvarchar(max),
@NetellerMerchantName nvarchar(max),
@NetellerMerchantAccount nvarchar(max),
@NetellerURL nvarchar(max),
@AstroPayXLogin nvarchar(max),
@AstroPayXTransKey nvarchar(max),
@AstroPayXSecretKey nvarchar(max),
@NetellerMinDeposit money,
@NetellerMinWithdraw money,
@NetellerMaxDeposit money,
@NetellerMaxWithdraw money,
@EcoPayzMerchantAccountNumber int,
@EcoPayzMerchantId int,
@EcoPayzPassword nvarchar(max),
@EcoPayzURL nvarchar(max),
@EcoPayzMinDeposit money,
@EcoPayzMinWithdraw money,
@EcoPayzMaxDeposit money,
@EcoPayzMaxWithdraw money,
@BitcoinURL nvarchar(max),
@BitcoinAPIKey nvarchar(max),
@BitcoinPairingCode nvarchar(max),
@BitcoinMinDeposit money,
@BitcoinMinWithdraw money,
@BitcoinMaxDeposit money,
@BitcoinMaxWithdraw money,
@IsOxxoEnabled bit,
@IsNetellerEnabled bit,
@IsAstroPayEnabled bit,
@IsEcoPayzEnabled bit,
@IsBitcoinEnabled bit,
@ActivityCode int,
@NewValues nvarchar(max),
@UserName nvarchar(max),
@LangId int
AS

declare @OldValues nvarchar(max)
declare @resultcode int=113
declare @resultmessage nvarchar(max)='Hata oluştu'
declare @AvailabityId int=0
declare @matchId bigint
declare @OddTypeId bigint

BEGIN
SET NOCOUNT ON;

select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId


if(@ActivityCode=1)
	begin
	
	exec [Log].ProcConcatOldValues  'PaymentSystemSetting','[General]','PaymentSystemSettingId',1,@OldValues output
	
	exec [Log].[ProcTransactionLogUID] 3,@ActivityCode,@Username,1,'General.PaymentSystemSetting'
	,@NewValues,@OldValues
	

	UPDATE [General].[PaymentSystemSetting]
   SET [OxxoUserName] = @OxxoUserName
      ,[OxxoPassword] = @OxxoPassword
      ,[OxxoHashCode] = @OxxoHashCode
      ,[OxxoUrl] = @OxxoUrl
      ,[NetellerMerchantId] = @NetellerMerchantId
      ,[NetellerMerchantKey] = @NetellerMerchantKey
      ,[NetellerMerchantName] = @NetellerMerchantName
      ,[NetellerMerchantAccount] = @NetellerMerchantAccount
      ,[NetellerURL] = @NetellerURL
      ,[AstroPayXLogin] = @AstroPayXLogin
      ,[AstroPayXTransKey] = @AstroPayXTransKey
      ,[AstroPayXSecretKey] = @AstroPayXSecretKey
      ,[NetellerMinDeposit] = @NetellerMinDeposit
      ,[NetellerMinWithdraw] = @NetellerMinWithdraw
      ,[NetellerMaxDeposit] = @NetellerMaxDeposit
      ,[NetellerMaxWithdraw] = @NetellerMaxWithdraw
      ,[EcoPayzMerchantAccountNumber] = @EcoPayzMerchantAccountNumber
      ,[EcoPayzMerchantId] = @EcoPayzMerchantId
      ,[EcoPayzPassword] = @EcoPayzPassword
      ,[EcoPayzURL] = @EcoPayzURL
      ,[EcoPayzMinDeposit] = @EcoPayzMinDeposit
      ,[EcoPayzMinWithdraw] = @EcoPayzMinWithdraw
      ,[EcoPayzMaxDeposit] = @EcoPayzMaxDeposit
      ,[EcoPayzMaxWithdraw] = @EcoPayzMaxWithdraw
      ,[BitcoinURL] = @BitcoinURL
      ,[BitcoinAPIKey] = @BitcoinAPIKey
      ,[BitcoinPairingCode] = @BitcoinPairingCode
      ,[BitcoinMinDeposit] = @BitcoinMinDeposit
      ,[BitcoinMinWithdraw] = @BitcoinMinWithdraw
      ,[BitcoinMaxDeposit] = @BitcoinMaxDeposit
      ,[BitcoinMaxWithdraw] = @BitcoinMaxWithdraw
      ,[IsOxxoEnabled] = @IsOxxoEnabled
      ,[IsNetellerEnabled] = @IsNetellerEnabled
      ,[IsAstroPayEnabled] = @IsAstroPayEnabled
      ,[IsEcoPayzEnabled] = @IsEcoPayzEnabled
      ,[IsBitcoinEnabled] = @IsBitcoinEnabled
 WHERE [PaymentSystemSettingId]=1




			select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId

	end



	select @resultcode as resultcode,@resultmessage as resultmessage




END


GO
