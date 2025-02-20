USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Live].[RiskManagement.ProcRuleOddType]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Live].[RiskManagement.ProcRuleOddType]
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


declare @sqlcommand nvarchar(max)
--declare @total int
--select @total=COUNT(Live.[RiskManagement.RuleOddType].RuleOddTypeId) 
--FROM         Live.[Parameter.OddType] INNER JOIN
--                      Live.[RiskManagement.RuleOddType] ON Live.[Parameter.OddType].OddTypeId = Live.[RiskManagement.RuleOddType].OddTypeId INNER JOIN
--                      Parameter.MatchState ON Live.[RiskManagement.RuleOddType].StateId = Parameter.MatchState.StateId INNER JOIN
--                      Parameter.MatchAvailability ON Live.[RiskManagement.RuleOddType].AvailabilityId = Parameter.MatchAvailability.AvailabilityId
--Where Live.[RiskManagement.RuleOddType].RuleId=@RuleId and   Live.[RiskManagement.RuleOddType].OddTypeId not in (1833,1832,1840,1839,1835,1834)  ; 
--WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY Live.[RiskManagement.RuleOddType].RuleOddTypeId) AS RowNum, 
--Live.[RiskManagement.RuleOddType].RuleOddTypeId, Live.[RiskManagement.RuleOddType].RuleId, Live.[RiskManagement.RuleOddType].OddTypeId, Live.[Parameter.OddType].OddType, 
--                      Live.[RiskManagement.RuleOddType].StateId, Live.[RiskManagement.RuleOddType].LossLimit, Live.[RiskManagement.RuleOddType].LimitPerTicket, 
--                      Live.[RiskManagement.RuleOddType].StakeLimit, Live.[RiskManagement.RuleOddType].AvailabilityId, Live.[RiskManagement.RuleOddType].MinCombiBranch, 
--                      Live.[RiskManagement.RuleOddType].MinCombiInternet, Live.[RiskManagement.RuleOddType].MinCombiMachine, Live.[RiskManagement.RuleOddType].Comment, 
--                      Parameter.MatchState.State, Parameter.MatchAvailability.Availability,Live.[RiskManagement.RuleOddType].IsPopular,Live.[RiskManagement.RuleOddType].MaxGainTicket
--FROM         Live.[Parameter.OddType] INNER JOIN
--                      Live.[RiskManagement.RuleOddType] ON Live.[Parameter.OddType].OddTypeId = Live.[RiskManagement.RuleOddType].OddTypeId INNER JOIN
--                      Parameter.MatchState ON Live.[RiskManagement.RuleOddType].StateId = Parameter.MatchState.StateId INNER JOIN
--                      Parameter.MatchAvailability ON Live.[RiskManagement.RuleOddType].AvailabilityId = Parameter.MatchAvailability.AvailabilityId
--Where Live.[RiskManagement.RuleOddType].RuleId=@RuleId and   Live.[RiskManagement.RuleOddType].OddTypeId not in (1833,1832,1840,1839,1835,1834)
--)   
--SELECT *,@total as totalrow 
-- FROM OrdersRN 

set @orderby=REPLACE(@orderby,'IsPopular','Live.[RiskManagement.RuleOddType].IsPopular')

set @sqlcommand='declare @total int '+
'select @total=COUNT(Live.[RiskManagement.RuleOddType].RuleOddTypeId)  '+
'FROM         Live.[Parameter.OddType] with (nolock) INNER JOIN
                      Live.[RiskManagement.RuleOddType] with (nolock) ON Live.[Parameter.OddType].OddTypeId = Live.[RiskManagement.RuleOddType].OddTypeId INNER JOIN
                      Parameter.MatchState with (nolock) ON Live.[RiskManagement.RuleOddType].StateId = Parameter.MatchState.StateId INNER JOIN
                      Parameter.MatchAvailability with (nolock) ON Live.[RiskManagement.RuleOddType].AvailabilityId = Parameter.MatchAvailability.AvailabilityId '+
' Where Live.[RiskManagement.RuleOddType].RuleId='+cast(@RuleId as nvarchar(10))+' and Live.[RiskManagement.RuleOddType].OddTypeId not in (1833,1832,1840,1839,1835,1834) and '+@where +' ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
'Live.[RiskManagement.RuleOddType].RuleOddTypeId, Live.[RiskManagement.RuleOddType].RuleId, Live.[RiskManagement.RuleOddType].OddTypeId, Live.[Parameter.OddType].OddType, 
                      Live.[RiskManagement.RuleOddType].StateId, Live.[RiskManagement.RuleOddType].LossLimit, Live.[RiskManagement.RuleOddType].LimitPerTicket, 
                      Live.[RiskManagement.RuleOddType].StakeLimit, Live.[RiskManagement.RuleOddType].AvailabilityId, Live.[RiskManagement.RuleOddType].MinCombiBranch, 
                      Live.[RiskManagement.RuleOddType].MinCombiInternet, Live.[RiskManagement.RuleOddType].MinCombiMachine, Live.[RiskManagement.RuleOddType].Comment, 
                      Parameter.MatchState.State, Parameter.MatchAvailability.Availability,Live.[RiskManagement.RuleOddType].IsPopular,Live.[RiskManagement.RuleOddType].MaxGainTicket '+
'FROM         Live.[Parameter.OddType] with (nolock) INNER JOIN
                      Live.[RiskManagement.RuleOddType] with (nolock) ON Live.[Parameter.OddType].OddTypeId = Live.[RiskManagement.RuleOddType].OddTypeId INNER JOIN
                      Parameter.MatchState with (nolock) ON Live.[RiskManagement.RuleOddType].StateId = Parameter.MatchState.StateId INNER JOIN
                      Parameter.MatchAvailability with (nolock) ON Live.[RiskManagement.RuleOddType].AvailabilityId = Parameter.MatchAvailability.AvailabilityId  '+
' Where Live.[RiskManagement.RuleOddType].RuleId='+cast(@RuleId as nvarchar(10))+' and Live.[RiskManagement.RuleOddType].OddTypeId not in (1833,1832,1840,1839,1835,1834) and '+@where +
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' )'

execute (@sqlcommand)


END


GO
