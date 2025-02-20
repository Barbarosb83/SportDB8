USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcSlider]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [GamePlatform].[ProcSlider] 
@LangId int

AS

BEGIN

SELECT [SliderId]
      ,[SliderItemName]
      ,[FileName]
      ,[IsActive]
      ,[StartDate]
      ,[EndDate]
      ,[SeqNo]
      ,[Link]
      ,[LangId]
	  ,[MobileLink]
	  ,[Title] 
	  ,[Description] 
  FROM [CMS].[Slider]
  WHERE [IsActive]=1 AND [StartDate]<GETDATE() AND [EndDate]>GETDATE() AND [LangId]=@LangId
  ORDER BY [SeqNo]


END


GO
