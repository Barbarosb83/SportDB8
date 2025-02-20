USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcOdds]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcOdds]
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



set @sqlcommand='declare @total int '+
'select @total=COUNT(Parameter.Odds.OddsId)  '+
'FROM         Parameter.Odds INNER JOIN Parameter.OddsType ON Parameter.Odds.OddTypeId=Parameter.OddsType.OddsTypeId
INNER JOIN  Parameter.Sport ON Parameter.OddsType.SportId = Parameter.Sport.SportId '+
'WHERE (1 = 1)  '+@where +' ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
'Parameter.Odds.OddsId, Parameter.Odds.Outcomes, Parameter.Odds.OutcomesDescription, Parameter.OddsType.OddsType, Parameter.Sport.SportName '+
'FROM         Parameter.Odds INNER JOIN Parameter.OddsType ON Parameter.Odds.OddTypeId=Parameter.OddsType.OddsTypeId
INNER JOIN  Parameter.Sport ON Parameter.OddsType.SportId = Parameter.Sport.SportId  '+
'WHERE (1 = 1)  '+@where +
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '


--declare @total int
--select @total=COUNT(Parameter.Odds.OddsId) 
--FROM         Parameter.Odds INNER JOIN Parameter.OddsType ON Parameter.Odds.OddTypeId=Parameter.OddsType.OddsTypeId
--INNER JOIN  Parameter.Sport ON Parameter.OddsType.SportId = Parameter.Sport.SportId 
--WHERE (1 = 1)  ; 
--WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY Parameter.Odds.OddsId) AS RowNum, 
-- Parameter.Odds.OddsId, Parameter.Odds.Outcomes, Parameter.Odds.OutcomesDescription, Parameter.OddsType.OddsType, Parameter.Sport.SportName
--FROM         Parameter.Odds INNER JOIN Parameter.OddsType ON Parameter.Odds.OddTypeId=Parameter.OddsType.OddsTypeId
--INNER JOIN  Parameter.Sport ON Parameter.OddsType.SportId = Parameter.Sport.SportId 
--WHERE (1 = 1) 
--)   
--SELECT *,@total as totalrow 
-- FROM OrdersRN 
  --WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' )




--SELECT     Parameter.OddsType.OddsTypeId, Parameter.OddsType.OddsType, Parameter.OddsType.OutcomesDescription, Parameter.OddsType.AvailabilityId, 
--                      Parameter.MatchAvailability.Availability, Parameter.OddsType.IsActive, Parameter.OddsType.ShortSign, Parameter.OddsType.IsPopular, 
--                      Parameter.Sport.SportName
--FROM         Parameter.OddsType INNER JOIN
--                      Parameter.MatchAvailability ON Parameter.OddsType.AvailabilityId = Parameter.MatchAvailability.AvailabilityId INNER JOIN
--                      Parameter.Sport ON Parameter.OddsType.SportId = Parameter.Sport.SportId



execute (@sqlcommand)


END



GO
