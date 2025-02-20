USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCustomerRuleOne]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [RiskManagement].[ProcCustomerRuleOne] 
@CustomerRuleId  INT,
@LangId int


AS


BEGIN
SET NOCOUNT ON;


select  RiskManagement.CustomerRule.CustomerRuleId
,RiskManagement.CustomerRule.EndDate
,RiskManagement.CustomerRule.IsEnable
,RiskManagement.CustomerRule.ParameterCustomerGroupId
,RiskManagement.CustomerRule.ParameterRuleCompareTypeId
,RiskManagement.CustomerRule.ParameterRuleTimeId
,RiskManagement.CustomerRule.ParameterRuleValueTypeId
,RiskManagement.CustomerRule.Priority
,RiskManagement.CustomerRule.RuleName
,RiskManagement.CustomerRule.StartDate
,RiskManagement.CustomerRule.Value
,Parameter.RuleCompareType.CompareType
,Parameter.RuleTime.RuleTime
,Parameter.RuleValueType.ValueType
,Parameter.CustomerGroup.GroupName
,Parameter.CustomerGroup.GroupComment
FROM       RiskManagement.CustomerRule INNER JOIN
Parameter.RuleCompareType ON Parameter.RuleCompareType.CompareTypeId=RiskManagement.CustomerRule.ParameterRuleCompareTypeId INNER JOIN
Parameter.RuleTime ON Parameter.RuleTime.RuleTimeId=RiskManagement.CustomerRule.ParameterRuleTimeId INNER JOIN
Parameter.RuleValueType ON Parameter.RuleValueType.ValueTypeId=RiskManagement.CustomerRule.ParameterRuleValueTypeId INNER JOIN
Parameter.CustomerGroup ON Parameter.CustomerGroup.CustomerGroupId=RiskManagement.CustomerRule.ParameterCustomerGroupId
WHERE  RiskManagement.CustomerRule.CustomerRuleId=@CustomerRuleId                 

END

GO
