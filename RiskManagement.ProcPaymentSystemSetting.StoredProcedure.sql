USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcPaymentSystemSetting]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcPaymentSystemSetting]
 
AS

BEGIN
SET NOCOUNT ON;

SELECT [PaymentSystemSettingId]
      ,[OxxoUserName]
      ,[OxxoPassword]
      ,[OxxoHashCode]
      ,[OxxoUrl]
      ,[NetellerMerchantId]
      ,[NetellerMerchantKey]
      ,[NetellerMerchantName]
      ,[NetellerMerchantAccount]
      ,[NetellerURL]
      ,[AstroPayXLogin]
      ,[AstroPayXTransKey]
      ,[AstroPayXSecretKey]
      ,[NetellerMinDeposit]
      ,[NetellerMinWithdraw]
      ,[NetellerMaxDeposit]
      ,[NetellerMaxWithdraw]
      ,[EcoPayzMerchantAccountNumber]
      ,[EcoPayzMerchantId]
      ,[EcoPayzPassword]
      ,[EcoPayzURL]
      ,[EcoPayzMinDeposit]
      ,[EcoPayzMinWithdraw]
      ,[EcoPayzMaxDeposit]
      ,[EcoPayzMaxWithdraw]
      ,[BitcoinURL]
      ,[BitcoinAPIKey]
      ,[BitcoinPairingCode]
      ,[BitcoinMinDeposit]
      ,[BitcoinMinWithdraw]
      ,[BitcoinMaxDeposit]
      ,[BitcoinMaxWithdraw]
      ,[IsOxxoEnabled]
      ,[IsNetellerEnabled]
      ,[IsAstroPayEnabled]
      ,[IsEcoPayzEnabled]
      ,[IsBitcoinEnabled]
  FROM [General].[PaymentSystemSetting]


END


GO
