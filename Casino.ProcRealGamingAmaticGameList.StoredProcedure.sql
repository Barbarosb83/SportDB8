USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Casino].[ProcRealGamingAmaticGameList]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Casino].[ProcRealGamingAmaticGameList]



AS




BEGIN
SET NOCOUNT ON;


Select Casino.[RealGaming.AmaticGame].GameId,Casino.[RealGaming.AmaticGame].Name,Casino.[RealGaming.AmaticGame].Title,
Casino.[RealGaming.AmaticGame].Img,Casino.[RealGaming.AmaticGame].GameUrl
From Casino.[RealGaming.AmaticGame]



END


GO
