USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcRuleOddType]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcRuleOddType]
@RuleId bigint,
 @PageSize  INT,
 @PageNum int,
@Username nvarchar(50),
@where nvarchar(1000),
@orderby nvarchar(100),
@LangId int


AS



BEGIN
SET NOCOUNT ON;

--SELECT     RiskManagement.RuleOddType.RuleOddTypeId, RiskManagement.RuleOddType.RuleId, RiskManagement.RuleOddType.OddTypeId, Parameter.OddsType.OddsType, 
--                      RiskManagement.RuleOddType.StateId, RiskManagement.RuleOddType.LossLimit, RiskManagement.RuleOddType.LimitPerTicket, 
--                      RiskManagement.RuleOddType.StakeLimit, RiskManagement.RuleOddType.AvailabilityId, RiskManagement.RuleOddType.MinCombiBranch, 
--                      RiskManagement.RuleOddType.MinCombiInternet, RiskManagement.RuleOddType.MinCombiMachine, RiskManagement.RuleOddType.Comment, 
--                      Parameter.MatchState.State, Parameter.MatchAvailability.Availability,RiskManagement.RuleOddType.IsPopular,RiskManagement.RuleOddType.MaxGainTicket
--FROM         Parameter.OddsType INNER JOIN
--                      RiskManagement.RuleOddType ON Parameter.OddsType.OddsTypeId = RiskManagement.RuleOddType.OddTypeId INNER JOIN
--                      Parameter.MatchState ON RiskManagement.RuleOddType.StateId = Parameter.MatchState.StateId INNER JOIN
--                      Parameter.MatchAvailability ON RiskManagement.RuleOddType.AvailabilityId = Parameter.MatchAvailability.AvailabilityId
--Where RiskManagement.RuleOddType.RuleId=@RuleId and   RiskManagement.RuleOddType.OddTypeId not in (1833,1832,1840,1839,1835,1834)
--Order by RiskManagement.RuleOddType.RuleOddTypeId desc



declare @sqlcommand nvarchar(max)



set @sqlcommand='declare @total int '+
'select @total=COUNT(RiskManagement.RuleOddType.RuleOddTypeId)  '+
'FROM         Parameter.OddsType INNER JOIN
                      RiskManagement.RuleOddType ON Parameter.OddsType.OddsTypeId = RiskManagement.RuleOddType.OddTypeId INNER JOIN
                      Parameter.MatchState ON RiskManagement.RuleOddType.StateId = Parameter.MatchState.StateId INNER JOIN
                      Parameter.MatchAvailability ON RiskManagement.RuleOddType.AvailabilityId = Parameter.MatchAvailability.AvailabilityId '+
'Where RiskManagement.RuleOddType.RuleId='+cast(@RuleId as nvarchar(50))+' and   RiskManagement.RuleOddType.OddTypeId not in (1833,1832,1840,1839,1835,1834) and '+@where +' ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
'RiskManagement.RuleOddType.RuleOddTypeId, RiskManagement.RuleOddType.RuleId, RiskManagement.RuleOddType.OddTypeId, Parameter.OddsType.OddsType, 
                      RiskManagement.RuleOddType.StateId, RiskManagement.RuleOddType.LossLimit, RiskManagement.RuleOddType.LimitPerTicket, 
                      RiskManagement.RuleOddType.StakeLimit, RiskManagement.RuleOddType.AvailabilityId, RiskManagement.RuleOddType.MinCombiBranch, 
                      RiskManagement.RuleOddType.MinCombiInternet, RiskManagement.RuleOddType.MinCombiMachine, RiskManagement.RuleOddType.Comment, 
                      Parameter.MatchState.State, Parameter.MatchAvailability.Availability,RiskManagement.RuleOddType.IsPopular,RiskManagement.RuleOddType.MaxGainTicket '+
'FROM         Parameter.OddsType INNER JOIN
                      RiskManagement.RuleOddType ON Parameter.OddsType.OddsTypeId = RiskManagement.RuleOddType.OddTypeId INNER JOIN
                      Parameter.MatchState ON RiskManagement.RuleOddType.StateId = Parameter.MatchState.StateId INNER JOIN
                      Parameter.MatchAvailability ON RiskManagement.RuleOddType.AvailabilityId = Parameter.MatchAvailability.AvailabilityId '+
'Where RiskManagement.RuleOddType.RuleId='+cast(@RuleId as nvarchar(50))+' and   RiskManagement.RuleOddType.OddTypeId not in (1833,1832,1840,1839,1835,1834) and '+@where +
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '


execute (@sqlcommand)

END


GO
