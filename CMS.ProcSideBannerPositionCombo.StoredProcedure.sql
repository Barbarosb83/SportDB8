USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [CMS].[ProcSideBannerPositionCombo]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [CMS].[ProcSideBannerPositionCombo]

AS


BEGIN
SET NOCOUNT ON;

select CMS.[Parameter.SideBannerPosition].PositionId
,CMS.[Parameter.SideBannerPosition].Position
,CMS.[Parameter.SideBannerPosition].Description
 from CMS.[Parameter.SideBannerPosition]



END


GO
