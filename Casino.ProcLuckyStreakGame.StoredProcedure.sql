USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Casino].[ProcLuckyStreakGame]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Casino].[ProcLuckyStreakGame]



AS




BEGIN
SET NOCOUNT ON;


Select Casino.[LuckyStreak.Game].Id
,Casino.[LuckyStreak.Game].GameId
,Casino.[LuckyStreak.Game].GameDealerId
,Casino.[LuckyStreak.GameDealer].Name as DealerName
,Casino.[LuckyStreak.GameDealer].AvatarUrl
,Casino.[LuckyStreak.GameDealer].ThumbnailAvatarURL
,Casino.[LuckyStreak.Game].GameName
,Casino.[LuckyStreak.Game].GameTypeId
,Casino.[LuckyStreak.ParameterGameType].GameType
,Casino.[LuckyStreak.Game].IsOpen
,Casino.[LuckyStreak.Game].LaunchUrl
,Casino.[LuckyStreak.Game].OpenHour
,Casino.[LuckyStreak.Game].CloseHour

From Casino.[LuckyStreak.Game] INNER JOIN
Casino.[LuckyStreak.GameDealer] ON 
Casino.[LuckyStreak.GameDealer].GameDealerId=Casino.[LuckyStreak.Game].GameDealerId INNER JOIN
Casino.[LuckyStreak.ParameterGameType] ON
Casino.[LuckyStreak.ParameterGameType].GameTypeId=Casino.[LuckyStreak.Game].GameTypeId
where Casino.[LuckyStreak.Game].GameId in (select Distinct GameId from [Casino].[LuckyStreak.LimitGroup])



END


GO
