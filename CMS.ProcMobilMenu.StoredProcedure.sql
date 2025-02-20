USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [CMS].[ProcMobilMenu]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [CMS].[ProcMobilMenu]

AS


BEGIN
SET NOCOUNT ON;


SELECT [MobileHomeMenuId]
      ,[Title]
      ,[CMS].[MobileHomeMenu].[Icon]
      ,[CMS].[MobileHomeMenu].[LanguageId]
	  ,[Language].[Language]
      ,[NavigateURL]
      ,[Position]
      ,[IsTop]
      ,[CMS].[MobileHomeMenu].[SportId]
	  ,Parameter.Sport.SportName
      ,[TournamentId]
      ,[TimeRangeId]
      ,[IsEnabled]
  FROM [CMS].[MobileHomeMenu] with (nolock)  INNER JOIN 
  Language.[Language] with (nolock)  ON [Language].LanguageId=Cms.MobileHomeMenu.LanguageId Left Outer JOIN
  Parameter.Sport with (nolock)  ON Parameter.Sport.SportId=CMS.MobileHomeMenu.SportId and [CMS].[MobileHomeMenu].IsEnabled=1
  

END

GO
