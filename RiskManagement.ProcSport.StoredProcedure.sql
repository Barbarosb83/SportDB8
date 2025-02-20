USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcSport]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcSport]
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

--SELECT     Parameter.Sport.SportId, Parameter.Sport.SportName, Parameter.Sport.IsActive, Parameter.Sport.Icon, Parameter.Sport.IconColor, Parameter.Sport.Limit, 
--                      Parameter.Sport.LimitPerTicket, Parameter.MatchAvailability.AvailabilityId, Parameter.MatchAvailability.Availability
--FROM         Parameter.Sport INNER JOIN
--                      Parameter.MatchAvailability ON Parameter.Sport.AvailabilityId = Parameter.MatchAvailability.AvailabilityId



set @sqlcommand='declare @total int '+
'select @total=COUNT(Parameter.Sport.SportId)  '+
'FROM         Parameter.Sport INNER JOIN
                      Parameter.MatchAvailability ON Parameter.Sport.AvailabilityId = Parameter.MatchAvailability.AvailabilityId '+
'WHERE (1 = 1) and '+@where +' ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
'Parameter.Sport.SportId, Parameter.Sport.SportName, Parameter.Sport.IsActive, Parameter.Sport.Icon, Parameter.Sport.IconColor, Parameter.Sport.Limit, 
                      Parameter.Sport.LimitPerTicket, Parameter.MatchAvailability.AvailabilityId, Parameter.MatchAvailability.Availability '+
'FROM         Parameter.Sport INNER JOIN
                      Parameter.MatchAvailability ON Parameter.Sport.AvailabilityId = Parameter.MatchAvailability.AvailabilityId '+
'WHERE (1 = 1) and '+@where +
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' )'

execute (@sqlcommand)


END


GO
