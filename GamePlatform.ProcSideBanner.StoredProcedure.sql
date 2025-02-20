USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcSideBanner]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [GamePlatform].[ProcSideBanner] 
@LangId int

AS

BEGIN

SELECT SideBannerId
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
  FROM CMS.[SideBanner]
  WHERE [IsActive]=1 AND [StartDate]<GETDATE() AND [EndDate]>GETDATE() AND [LangId]=@LangId



END


GO
