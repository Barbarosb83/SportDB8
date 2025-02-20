USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Casino].[ProcRealGamingAmaticGameSetting]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Casino].[ProcRealGamingAmaticGameSetting]



AS




BEGIN
SET NOCOUNT ON;


Select Casino.[RealGaming.AmaticGameSetting].AccessToken,
Casino.[RealGaming.AmaticGameSetting].AmaticGameSettingId,
Casino.[RealGaming.AmaticGameSetting].AuthUrl,
Casino.[RealGaming.AmaticGameSetting].ClienId,
Casino.[RealGaming.AmaticGameSetting].LobbyUrl,Casino.[RealGaming.AmaticGameSetting].OperatorName,
Casino.[RealGaming.AmaticGameSetting].RefreshToken,Casino.[RealGaming.AmaticGameSetting].Secret,
Casino.[RealGaming.AmaticGameSetting].Passwords,
Casino.[RealGaming.AmaticGameSetting].ExitUrl,
Casino.[RealGaming.AmaticGameSetting].RemoteUrl
 from Casino.[RealGaming.AmaticGameSetting]



END


GO
