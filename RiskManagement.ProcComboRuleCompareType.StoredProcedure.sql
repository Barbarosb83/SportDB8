USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcComboRuleCompareType]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcComboRuleCompareType]



AS




BEGIN
SET NOCOUNT ON;


select Parameter.RuleCompareType.CompareTypeId,Parameter.RuleCompareType.CompareType
From Parameter.RuleCompareType

END

GO
