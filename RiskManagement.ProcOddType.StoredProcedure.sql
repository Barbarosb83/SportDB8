USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcOddType]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcOddType]
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
--select @total=COUNT(Parameter.OddsType.OddsTypeId) 
--FROM          Parameter.OddsType INNER JOIN
--                      Parameter.MatchAvailability ON Parameter.OddsType.AvailabilityId = Parameter.MatchAvailability.AvailabilityId INNER JOIN
--                      Parameter.Sport ON Parameter.OddsType.SportId = Parameter.Sport.SportId 
--WHERE (1 = 1)  ; 
--WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY Parameter.OddsType.OddsTypeId) AS RowNum, 
--Parameter.OddsType.OddsTypeId, Parameter.OddsType.OddsType, Parameter.OddsType.OutcomesDescription, Parameter.OddsType.AvailabilityId, 
--                      Parameter.MatchAvailability.Availability, Parameter.OddsType.IsActive, Parameter.OddsType.ShortSign, Parameter.OddsType.IsPopular, 
--                      Parameter.Sport.SportName ,Parameter.OddsType.SeqNumber
--FROM         Parameter.OddsType INNER JOIN
--                      Parameter.MatchAvailability ON Parameter.OddsType.AvailabilityId = Parameter.MatchAvailability.AvailabilityId INNER JOIN
--                      Parameter.Sport ON Parameter.OddsType.SportId = Parameter.Sport.SportId 
--WHERE (1 = 1) 
--)   
--SELECT *,@total as totalrow 
-- FROM OrdersRN 


set @sqlcommand='declare @total int '+
'select @total=COUNT(Parameter.OddsType.OddsTypeId)  '+
'FROM          Parameter.OddsType INNER JOIN
                      Parameter.MatchAvailability ON Parameter.OddsType.AvailabilityId = Parameter.MatchAvailability.AvailabilityId INNER JOIN
                      Parameter.Sport ON Parameter.OddsType.SportId = Parameter.Sport.SportId '+
'WHERE (1 = 1) '+@where +' ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
'Parameter.OddsType.OddsTypeId, Parameter.OddsType.OddsType, Parameter.OddsType.OutcomesDescription, Parameter.OddsType.AvailabilityId, 
                      Parameter.MatchAvailability.Availability, Parameter.OddsType.IsActive, Parameter.OddsType.ShortSign, Parameter.OddsType.IsPopular, 
                      Parameter.Sport.SportName ,Parameter.OddsType.SeqNumber,Parameter.OddsType.BetradarOddsTypeId '+
'FROM         Parameter.OddsType INNER JOIN
                      Parameter.MatchAvailability ON Parameter.OddsType.AvailabilityId = Parameter.MatchAvailability.AvailabilityId INNER JOIN
                      Parameter.Sport ON Parameter.OddsType.SportId = Parameter.Sport.SportId   '+
'WHERE (1 = 1) '+@where +
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' )'

execute (@sqlcommand)


END



GO
