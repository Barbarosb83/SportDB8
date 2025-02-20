USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [CMS].[ProcSlider]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [CMS].[ProcSlider]

AS


BEGIN
SET NOCOUNT ON;


SELECT [SliderId]
      ,[SliderItemName]
      ,[FileName]
      ,[CMS].[Slider].[IsActive]
      ,[StartDate]
      ,[EndDate]
	  ,[Link]
	  ,[LangId]
	  ,Language.[Language].[Language]
	  ,[SeqNo]
	  ,[MobileLink] 
	  ,Title
	  ,[Description]
  FROM [CMS].[Slider] with (nolock) 
  inner join  Language.[Language] with (nolock)  on Language.[LanguageId]=[CMS].[Slider].[LangId] --where [CMS].[Slider].IsActive=1
  

END


GO
