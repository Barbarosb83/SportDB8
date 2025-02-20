USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcTournament]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [RiskManagement].[ProcTournament] 
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

--select @total=COUNT( Parameter.Tournament.TournamentId) 
--FROM         Parameter.Tournament INNER JOIN
--                      Parameter.MatchAvailability ON Parameter.Tournament.AvailabilityId = Parameter.MatchAvailability.AvailabilityId ; 
--WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY Parameter.Tournament.TournamentName) AS RowNum,
--  Parameter.Tournament.TournamentId, Parameter.Tournament.TournamentName, Parameter.Tournament.IsActive, Parameter.Tournament.Limit, 
--                      Parameter.Tournament.LimitPerTicket, Parameter.Tournament.AvailabilityId, Parameter.MatchAvailability.Availability
--FROM         Parameter.Tournament INNER JOIN
--                      Parameter.MatchAvailability ON Parameter.Tournament.AvailabilityId = Parameter.MatchAvailability.AvailabilityId
--)  
--SELECT *,@total as totalrow 
--FROM OrdersRN 
--WHERE RowNum BETWEEN ((@PageNum-1 )*(@PageSize))+1 AND (@PageNum * @PageSize ) 

if (CHARINDEX('SequenceNumber',@orderby) > 0)
set @orderby=REPLACE(@orderby,'SequenceNumber','Parameter.Tournament.SequenceNumber')

set @sqlcommand='declare @total int '+
'select @total=COUNT(Parameter.Tournament.TournamentId)  '+
'FROM         Parameter.Tournament INNER JOIN
                      Parameter.MatchAvailability ON Parameter.Tournament.AvailabilityId = Parameter.MatchAvailability.AvailabilityId INNER JOIN
                      Parameter.Category ON Parameter.Category.CategoryId=Parameter.Tournament.CategoryId INNER JOIN
                      Parameter.Sport On Parameter.Sport.SportId=Parameter.Category.SportId' +
                      ' WHERE (1 = 1) and '+@where +' ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
'Parameter.Tournament.TournamentId, Parameter.Tournament.TournamentName, Parameter.Tournament.IsActive, Parameter.Tournament.Limit, 
                      Parameter.Tournament.LimitPerTicket, Parameter.Tournament.AvailabilityId, cast(Parameter.Tournament.NewBetradarId as nvarchar(15))  as Availability,Parameter.Tournament.SequenceNumber,
					  Parameter.Sport.SportName,Parameter.Category.CategoryName, Parameter.Tournament.IsPopularTerminal
FROM         Parameter.Tournament INNER JOIN
                      Parameter.MatchAvailability ON Parameter.Tournament.AvailabilityId = Parameter.MatchAvailability.AvailabilityId INNER JOIN
                      Parameter.Category ON Parameter.Category.CategoryId=Parameter.Tournament.CategoryId INNER JOIN
                      Parameter.Sport On Parameter.Sport.SportId=Parameter.Category.SportId '+
                      ' WHERE (1 = 1) and '+@where +
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '


--declare @total int 
--select @total=COUNT(Parameter.Tournament.TournamentId)  
--FROM         Parameter.Tournament INNER JOIN
--                      Parameter.MatchAvailability ON Parameter.Tournament.AvailabilityId = Parameter.MatchAvailability.AvailabilityId 
--                      WHERE (1 = 1);
--WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY Parameter.Tournament.TournamentName) AS RowNum, 
--Parameter.Tournament.TournamentId, Parameter.Tournament.TournamentName, Parameter.Tournament.IsActive, Parameter.Tournament.Limit,
--                      Parameter.Tournament.LimitPerTicket, Parameter.Tournament.AvailabilityId, Parameter.MatchAvailability.Availability,Parameter.Tournament.SequenceNumber
--FROM         Parameter.Tournament INNER JOIN
--                      Parameter.MatchAvailability ON Parameter.Tournament.AvailabilityId = Parameter.MatchAvailability.AvailabilityId 
--                      WHERE (1 = 1)
-- )   
-- SELECT *,@total as totalrow 
--  FROM OrdersRN 
-- -- WHERE RowNum BETWEEN ((cast(@PageNum-1 as nvarchar(5)))*(cast(@PageSize  as nvarchar(5))))+1 AND (cast(@PageNum * @PageSize as nvarchar(10)) )






execute (@sqlcommand)
END


GO
