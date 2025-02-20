USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Casino].[ProcLuckyStreakGameLimits]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Casino].[ProcLuckyStreakGameLimits]



AS




BEGIN
SET NOCOUNT ON;


SELECT     Casino.[LuckyStreak.LimitGroup].LimitGroupId, GameId, Name,Casino.[LuckyStreak.LimitGroup].GroupId,
				Casino.[LuckyStreak.LimitValue].MinValue,Casino.[LuckyStreak.LimitValue].MaxValue,Casino.[LuckyStreak.LimitValue].CurrencyId,
				Parameter.Currency.Sybol,Parameter.Currency.Currency
FROM            Casino.[LuckyStreak.LimitGroup] inner join Casino.[LuckyStreak.Limit] on Casino.[LuckyStreak.LimitGroup].LimitGroupId=Casino.[LuckyStreak.Limit].LimitGroupId
			inner join Casino.[LuckyStreak.LimitValue] on Casino.[LuckyStreak.LimitValue].LimitId=Casino.[LuckyStreak.Limit].LimitId
			inner join Parameter.Currency on Parameter.Currency.CurrencyId=Casino.[LuckyStreak.LimitValue].CurrencyId




END





GO
