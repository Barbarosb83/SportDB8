USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [CMS].[ProcLandingPage]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [CMS].[ProcLandingPage]

AS


BEGIN
SET NOCOUNT ON;

select CMS.LandingPage.LandingPageId
,CMS.LandingPage.Description
,CMS.LandingPage.EndDate
,CMS.LandingPage.FileName
,CMS.LandingPage.IsActive
,CMS.LandingPage.ItemName
,CMS.LandingPage.LangId
,CMS.LandingPage.Link
,CMS.LandingPage.PositionId
,CMS.LandingPage.StartDate
,CMS.LandingPage.Title
,Language.Language.Language
,CMS.[Parameter.LandingPagePosition].Position

from CMS.LandingPage INNER JOIN
Language.Language ON Language.Language.LanguageId=CMS.LandingPage.LangId INNER JOIN
CMS.[Parameter.LandingPagePosition] On CMS.[Parameter.LandingPagePosition].PositionId=CMS.LandingPage.PositionId
  

END


GO
