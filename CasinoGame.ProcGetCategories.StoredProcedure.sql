USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [CasinoGame].[ProcGetCategories]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [CasinoGame].[ProcGetCategories]
 

AS


BEGIN
SET NOCOUNT ON;

SELECT [CategoryId]
      ,[CatergoryName]
      ,[IsPopular]
  FROM [CasinoGame].[Category]

	
END

GO
