USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCompetitor]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcCompetitor] 
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

--select @total=COUNT(Parameter.Competitor.CompetitorId) 
--FROM         Parameter.Competitor
--WHERE     (CompetitorId <> 0) ; 
--WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY Parameter.Competitor.CompetitorId) AS RowNum,
--  CompetitorId, CompetitorName
--FROM         Parameter.Competitor
--WHERE     (CompetitorId <> 0)
--)  
--SELECT *,@total as totalrow 
--FROM OrdersRN 
--WHERE RowNum BETWEEN ((@PageNum-1 )*(@PageSize))+1 AND (@PageNum * @PageSize ) 





set @sqlcommand='declare @total int '+
'select @total=COUNT(Parameter.Competitor.CompetitorId)  '+
'FROM         Parameter.Competitor
WHERE     (CompetitorId <> 0) and '+@where +' ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
'CompetitorId, CompetitorName,BetradarSuperId
FROM         Parameter.Competitor
WHERE     (CompetitorId <> 0) and '+@where +' '+
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '


execute (@sqlcommand)
END


GO
