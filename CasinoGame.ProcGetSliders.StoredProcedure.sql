USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [CasinoGame].[ProcGetSliders]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [CasinoGame].[ProcGetSliders]
 

AS


BEGIN
SET NOCOUNT ON;


SELECT [SliderId]
      ,[SliderName]
      ,[Img]
      ,[RowNumber]
      ,[IsEnabled]
  FROM [CasinoGame].[Slider]
	
END

GO
