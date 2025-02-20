USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [CMS].[ProcSideBanner]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [CMS].[ProcSideBanner]

AS


BEGIN
SET NOCOUNT ON;

select CMS.SideBanner.SideBannerId
,CMS.SideBanner.Description
,CMS.SideBanner.EndDate
,CMS.SideBanner.FileName
,CMS.SideBanner.IsActive
,CMS.SideBanner.ItemName
,CMS.SideBanner.LangId
,CMS.SideBanner.Link
,CMS.SideBanner.PositionId
,CMS.SideBanner.StartDate
,CMS.SideBanner.Title
,Language.Language.Language
,CMS.[Parameter.SideBannerPosition].Position

from CMS.SideBanner with (nolock)  INNER JOIN
Language.Language with (nolock)  ON Language.Language.LanguageId=CMS.SideBanner.LangId INNER JOIN
CMS.[Parameter.SideBannerPosition] On CMS.[Parameter.SideBannerPosition].PositionId=CMS.SideBanner.PositionId
  

END


GO
