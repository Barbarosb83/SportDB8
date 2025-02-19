USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCategoryOne]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcCategoryOne]
@CategoryId int,
@username nvarchar(max)

AS



BEGIN
SET NOCOUNT ON;

Select Parameter.Category.CategoryId, Parameter.Category.BetradarCategoryId, Parameter.Category.IsoId, Parameter.Category.CategoryName, Parameter.Category.SportId, 
                      Parameter.Sport.SportName, Parameter.Category.IsActive, Parameter.Category.Ispopular,Parameter.Category.SequenceNumber
FROM         Parameter.Category INNER JOIN
                      Parameter.Sport ON Parameter.Category.SportId = Parameter.Sport.SportId
Where      Parameter.Category.CategoryId=@CategoryId                 




END


GO
