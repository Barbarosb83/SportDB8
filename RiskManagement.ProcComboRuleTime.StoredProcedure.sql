USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcComboRuleTime]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [RiskManagement].[ProcComboRuleTime]



AS




BEGIN
SET NOCOUNT ON;


select Parameter.RuleTime.RuleTimeId,Parameter.RuleTime.RuleTime
From Parameter.RuleTime

END


GO
