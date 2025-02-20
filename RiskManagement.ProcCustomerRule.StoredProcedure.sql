USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCustomerRule]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 

CREATE PROCEDURE [RiskManagement].[ProcCustomerRule] 
@PageSize  INT,
 @PageNum int,
@Username nvarchar(50),
@where nvarchar(250),
@orderby nvarchar(100)


AS




BEGIN
SET NOCOUNT ON;

declare @sqlcommand nvarchar(max)

--declare @total int 
--select @total=COUNT(RiskManagement.CustomerRule.CustomerRuleId)  
--FROM        RiskManagement.CustomerRule
--WHERE  1=1 ;
--WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY RiskManagement.CustomerRule.CustomerRuleId) AS RowNum, 
--   RiskManagement.CustomerRule.CustomerRuleId
--,RiskManagement.CustomerRule.EndDate
--,RiskManagement.CustomerRule.IsEnable
--,RiskManagement.CustomerRule.ParameterCustomerGroupId
--,RiskManagement.CustomerRule.ParameterRuleCompareTypeId
--,RiskManagement.CustomerRule.ParameterRuleTimeId
--,RiskManagement.CustomerRule.ParameterRuleValueTypeId
--,RiskManagement.CustomerRule.Priority
--,RiskManagement.CustomerRule.RuleName
--,RiskManagement.CustomerRule.StartDate
--,RiskManagement.CustomerRule.Value
--,Parameter.RuleCompareType.CompareType
--,Parameter.RuleTime.RuleTime
--,Parameter.RuleValueType.ValueType
--,Parameter.CustomerGroup.GroupName
--,Parameter.CustomerGroup.GroupComment
--FROM       RiskManagement.CustomerRule INNER JOIN
--Parameter.RuleCompareType ON Parameter.RuleCompareType.CompareTypeId=RiskManagement.CustomerRule.ParameterRuleCompareTypeId INNER JOIN
--Parameter.RuleTime ON Parameter.RuleTime.RuleTimeId=RiskManagement.CustomerRule.ParameterRuleTimeId INNER JOIN
--Parameter.RuleValueType ON Parameter.RuleValueType.ValueTypeId=RiskManagement.CustomerRule.ParameterRuleValueTypeId INNER JOIN
--Parameter.CustomerGroup ON Parameter.CustomerGroup.CustomerGroupId=RiskManagement.CustomerRule.ParameterCustomerGroupId
--WHERE  1=1

--)  
--SELECT *,@total as totalrow 
--  FROM OrdersRN 
--  WHERE RowNum BETWEEN (@PageNum-1 )*(@PageSize )+1 AND (@PageNum * @PageSize )


  set @sqlcommand='declare @total int '+
'select @total=COUNT(RiskManagement.CustomerRule.CustomerRuleId)  '+
'FROM         RiskManagement.CustomerRule ' +
                      'WHERE (1 = 1) and '+@where +' ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
' RiskManagement.CustomerRule.CustomerRuleId
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
FROM         RiskManagement.CustomerRule INNER JOIN
Parameter.RuleCompareType ON Parameter.RuleCompareType.CompareTypeId=RiskManagement.CustomerRule.ParameterRuleCompareTypeId INNER JOIN
Parameter.RuleTime ON Parameter.RuleTime.RuleTimeId=RiskManagement.CustomerRule.ParameterRuleTimeId INNER JOIN
Parameter.RuleValueType ON Parameter.RuleValueType.ValueTypeId=RiskManagement.CustomerRule.ParameterRuleValueTypeId INNER JOIN
Parameter.CustomerGroup ON Parameter.CustomerGroup.CustomerGroupId=RiskManagement.CustomerRule.ParameterCustomerGroupId '+
                      'WHERE (1 = 1) and '+@where +
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '

execute (@sqlcommand)                   

END


GO
