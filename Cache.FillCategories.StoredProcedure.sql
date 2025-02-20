USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Cache].[FillCategories]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [Cache].[FillCategories]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @temptable  table (CategoryId int, SportId int,CategoryEventCount int, IsoName nchar(2),Ispopular bit,EndDay int)
    
    insert @temptable exec [Cache].[FillCategoriesbyDay] 7

	insert @temptable exec [Cache].[FillCategoriesbyDay] 4
		
	insert @temptable exec [Cache].[FillCategoriesbyDay] 2
		
	insert @temptable exec [Cache].[FillCategoriesbyDay] 1
    
    truncate table Cache.[Category]
    
INSERT INTO [Cache].[Category]
           ([CategoryId]
           ,[SportId]
           ,[CategoryEventCount]
           ,[IsoName]
           ,[Ispopular]
           ,[EndDay])
    select CategoryId , SportId ,CategoryEventCount , IsoName ,Ispopular ,EndDay 
    from @temptable
    
END


GO
