USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[TV.ProcVersionControl]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[TV.ProcVersionControl]
 



AS




BEGIN
SET NOCOUNT ON;

 
SELECT [TVversionId]
      ,[Version]
      ,[DownloadLink]
      ,[Applink]
  FROM [Parameter].[TVVersion]


END





GO
