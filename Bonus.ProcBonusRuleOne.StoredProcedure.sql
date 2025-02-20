USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Bonus].[ProcBonusRuleOne]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Bonus].[ProcBonusRuleOne]
@BonusRuleId int,
@LangId int


AS



BEGIN
SET NOCOUNT ON;


SELECT     Bonus.[Rule].BonusRuleId, Bonus.[Rule].BonusTypeId, Bonus.[Rule].BonusName, Bonus.[Rule].GameTypeId, Bonus.[Rule].MaxAmount, Bonus.[Rule].MinAmount, 
                      Bonus.[Rule].BonusRate, Bonus.[Rule].BonusStartDate, Bonus.[Rule].BonusEndDate, Bonus.[Rule].BonusExpiredDay, Bonus.[Rule].BonusMinOddValue, 
                      Bonus.[Rule].BonusOccurences, Bonus.[Rule].ForfeitOnWithdraw, Bonus.[Rule].MinCombineCount, Bonus.[Rule].SameOddtypeTwoOdds, 
                      Parameter.GameType.GameType, Parameter.BonusType.Type, Parameter.BonusType.Description,0 as RuleDaysId,0 as ParameterDayId, 
                      '' as Days, 0 as CashTypeId,'' as CashType, 0 as RuleCashTypeId
FROM         Parameter.BonusType INNER JOIN
                      Bonus.[Rule] ON Parameter.BonusType.BonusTypeId = Bonus.[Rule].BonusTypeId INNER JOIN
                      Parameter.GameType ON Bonus.[Rule].GameTypeId = Parameter.GameType.GameTypeId 
                      where Bonus.[Rule].BonusRuleId=@BonusRuleId


END


GO
