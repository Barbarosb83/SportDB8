USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Bonus].[ProcBonusRuleCashType]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Bonus].[ProcBonusRuleCashType]
@BonusRuleId int,
@LangId int


AS



BEGIN
SET NOCOUNT ON;

SELECT     Bonus.RuleCashType.RuleCashTypeId, Bonus.RuleCashType.CashTypeId, Parameter.CashType.CashType
FROM         Bonus.RuleCashType INNER JOIN
                      Parameter.CashType ON Bonus.RuleCashType.CashTypeId = Parameter.CashType.CashTypeId
WHERE     (Bonus.RuleCashType.RuleId = @BonusRuleId)



END


GO
