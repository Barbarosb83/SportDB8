USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcTournamentOutright]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [RiskManagement].[ProcTournamentOutright] 
 @PageSize  INT,
 @PageNum int,
@Username nvarchar(50),
@where nvarchar(1000),
@orderby nvarchar(100)
AS

BEGIN
SET NOCOUNT ON;


declare @sqlcommand nvarchar(max)
declare @sqlcommand2 nvarchar(max)

--declare @total int 

--select @total=COUNT( Parameter.TournamentOutrights.TournamentId) 
--FROM         Parameter.TournamentOutrights INNER JOIN
--                      Parameter.Category ON Parameter.Category.CategoryId=Parameter.TournamentOutrights.CategoryId INNER JOIN
--                      Parameter.Sport On Parameter.Sport.SportId=Parameter.Category.SportId ; 
--WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY Parameter.TournamentOutrights.TournamentName) AS RowNum,
-- Parameter.TournamentOutrights.TournamentId, Parameter.TournamentOutrights.TournamentName, Parameter.TournamentOutrights.IsActive, Parameter.TournamentOutrights.Limit, 
--                      Parameter.TournamentOutrights.LimitPerTicket, Parameter.TournamentOutrights.AvailabilityId, Parameter.TournamentOutrights.SequenceNumber,
--					  Parameter.Sport.SportName,Parameter.Category.CategoryName
--FROM         Parameter.TournamentOutrights INNER JOIN
--                      Parameter.Category ON Parameter.Category.CategoryId=Parameter.TournamentOutrights.CategoryId INNER JOIN
--                      Parameter.Sport On Parameter.Sport.SportId=Parameter.Category.SportId
--)  
--SELECT *,@total as totalrow 
--FROM OrdersRN 



set @sqlcommand='declare @total int '+
'select @total=COUNT(Parameter.TournamentOutrights.TournamentId)  '+
'FROM         Parameter.TournamentOutrights INNER JOIN
                      Parameter.Category ON Parameter.Category.CategoryId=Parameter.TournamentOutrights.CategoryId INNER JOIN
                      Parameter.Sport On Parameter.Sport.SportId=Parameter.Category.SportId ' +
                      ' WHERE (1 = 1) and '+@where +' ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
'Parameter.TournamentOutrights.TournamentId, Parameter.TournamentOutrights.TournamentName, Parameter.TournamentOutrights.IsActive, Parameter.TournamentOutrights.Limit, 
                      Parameter.TournamentOutrights.LimitPerTicket, Parameter.TournamentOutrights.AvailabilityId, Parameter.TournamentOutrights.SequenceNumber,
					  Parameter.Sport.SportName,Parameter.Category.CategoryName
FROM         Parameter.TournamentOutrights INNER JOIN
                      Parameter.Category ON Parameter.Category.CategoryId=Parameter.TournamentOutrights.CategoryId INNER JOIN
                      Parameter.Sport On Parameter.Sport.SportId=Parameter.Category.SportId '+
                      ' WHERE (1 = 1) and '+@where +
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '






execute (@sqlcommand)
END


GO
