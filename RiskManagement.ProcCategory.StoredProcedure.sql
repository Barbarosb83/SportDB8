USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCategory]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcCategory] 
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

--select @total=COUNT( Parameter.Category.CategoryId) 
--FROM          Parameter.Category INNER JOIN
--                      Parameter.Sport ON Parameter.Category.SportId = Parameter.Sport.SportId ; 
--WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY  Parameter.Category.CategoryId) AS RowNum,
--  Parameter.Category.CategoryId, Parameter.Category.BetradarCategoryId, Parameter.Category.IsoId, Parameter.Category.CategoryName, Parameter.Category.SportId, 
--                      Parameter.Sport.SportName, Parameter.Category.IsActive, Parameter.Category.Ispopular,Parameter.Category.SequenceNumber
--FROM         Parameter.Category INNER JOIN
--                      Parameter.Sport ON Parameter.Category.SportId = Parameter.Sport.SportId
--)  
--SELECT *,@total as totalrow 
--FROM OrdersRN 
--WHERE RowNum BETWEEN ((@PageNum-1 )*(@PageSize))+1 AND (@PageNum * @PageSize ) 



set @sqlcommand='declare @total int '+
'select @total=COUNT(Parameter.Category.CategoryId)  '+
'FROM          Parameter.Category INNER JOIN
                      Parameter.Sport ON Parameter.Category.SportId = Parameter.Sport.SportId ' +
                      'WHERE (1 = 1) and '+@where +' ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
'Parameter.Category.CategoryId, Parameter.Category.BetradarCategoryId, Parameter.Category.IsoId, Parameter.Category.CategoryName, Parameter.Category.SportId, 
                      Parameter.Sport.SportName, Parameter.Category.IsActive, Parameter.Category.Ispopular,Parameter.Category.SequenceNumber
FROM         Parameter.Category INNER JOIN
                      Parameter.Sport ON Parameter.Category.SportId = Parameter.Sport.SportId '+
                      'WHERE (1 = 1) and '+@where +
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '






execute (@sqlcommand)
END


GO
