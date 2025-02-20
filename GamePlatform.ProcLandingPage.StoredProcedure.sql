USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcLandingPage]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [GamePlatform].[ProcLandingPage] 
@LangId int

AS

BEGIN

SELECT LandingPageId
      ,ItemName
      ,[FileName]
      ,[IsActive]
      ,[StartDate]
      ,[EndDate]
      ,PositionId
      ,[Link]
      ,[LangId]
	  ,Title
	  ,Description
  FROM CMS.[LandingPage]
  WHERE [IsActive]=1 AND [StartDate]<GETDATE() AND [EndDate]>GETDATE() AND [LangId]=@LangId



END


GO
