USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [CasinoGame].[ProcGetGamesByCategory]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [CasinoGame].[ProcGetGamesByCategory]
@CategoryId int

AS


BEGIN
SET NOCOUNT ON;
 
SELECT [CasinoGame].[Game].[GameId]
      ,[CasinoGame].[Game].[GameName]
      ,[CasinoGame].[Game].[GameText]
      ,[CasinoGame].[Game].[GameImg]
      ,[CasinoGame].[Game].[RowNumber]
      ,[CasinoGame].[Game].[IsEnabled]
      ,[CasinoGame].[Provider].[ProviderId]
	  ,[CasinoGame].[Provider].[ProviderName]
      ,[CasinoGame].[Game].[IsPopular]
      ,CasinoGame.Game.[CategoryId]
	  ,[CasinoGame].[Category].[CatergoryName]
      ,[CasinoGame].[Game].[Aggregator]
      ,[CasinoGame].[Game].[ProductId]
  FROM [CasinoGame].[Game] INNER JOIN CasinoGame.Category On CasinoGame.Game.CategoryId=[CasinoGame].[Category].CategoryId 
  INNER JOIN [CasinoGame].[Provider] ON [CasinoGame].[Provider].[ProviderId]=[CasinoGame].[Game].[ProviderId]
  where [CasinoGame].[Game].[IsEnabled]=1 and [CasinoGame].[Category].CategoryId =@CategoryId
 

	
END

GO
