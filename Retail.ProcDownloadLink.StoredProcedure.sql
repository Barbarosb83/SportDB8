USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcDownloadLink]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcDownloadLink] 
@LangId int
AS
BEGIN
SET NOCOUNT ON;

  



SELECT [DownloadLinkId]
      ,[DownloadTitle]
      ,[DownloadLink]
      ,[LangId]
  FROM [Retail].[DownloadLink] where [LangId]=6


END
GO
