USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [General].[ProcGeneralSetting]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [General].[ProcGeneralSetting]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT [SettingId]
      ,[CompanyName]
      ,[MaxDayPeriod]
      ,[MaxCopySlip]
      ,[UseSameAmountPerSystemCombi]
      ,[EmailSMTP]
      ,[EmailAccount]
      ,[EmailPort]
      ,[EmailPassword]
      ,[MaxWinningLimit]
	  ,SystemCurrencyId
	  ,Parameter.Currency.Currency
  FROM [General].[Setting] with (nolock) INNER JOIN
  Parameter.Currency with (nolock) ON Parameter.Currency.CurrencyId=General.Setting.SystemCurrencyId
  Where SettingId=1

END


GO
