USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Bonus].[ProcBonusRuleDays]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Bonus].[ProcBonusRuleDays]
@BonusRuleId int,
@LangId int


AS



BEGIN
SET NOCOUNT ON;

SELECT     Bonus.RuleDays.RuleDaysId, Bonus.RuleDays.ParameterDayId, Parameter.Days.Days
FROM         Bonus.RuleDays INNER JOIN
                      Parameter.Days ON Bonus.RuleDays.ParameterDayId = Parameter.Days.DaysId
WHERE     (Bonus.RuleDays.RuleId = @BonusRuleId)



END


GO
