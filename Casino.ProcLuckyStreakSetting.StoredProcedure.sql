USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Casino].[ProcLuckyStreakSetting]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Casino].[ProcLuckyStreakSetting]



AS




BEGIN
SET NOCOUNT ON;


Select Casino.[LuckyStreak.Setting].AccessToken
 ,Casino.[LuckyStreak.Setting].AuthUrl
 ,Casino.[LuckyStreak.Setting].ClientId
 ,Casino.[LuckyStreak.Setting].LobbyUrl
 ,Casino.[LuckyStreak.Setting].LuckyStreakSettingId
 ,Casino.[LuckyStreak.Setting].OperatorName
 ,Casino.[LuckyStreak.Setting].RefreshToken
 ,Casino.[LuckyStreak.Setting].Secret
 from Casino.[LuckyStreak.Setting]



END


GO
