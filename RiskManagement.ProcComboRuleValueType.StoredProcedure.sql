USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcComboRuleValueType]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [RiskManagement].[ProcComboRuleValueType]



AS




BEGIN
SET NOCOUNT ON;


select Parameter.RuleValueType.ValueTypeId ,Parameter.RuleValueType.ValueType
From Parameter.RuleValueType

END


GO
