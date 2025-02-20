USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [CMS].[ProcPage]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [CMS].[ProcPage]

AS


BEGIN
SET NOCOUNT ON;

SELECT [PageId]
      ,[PageTitle]
      ,[LangId]
      ,[HtmlContent]
	  ,Language.[Language].[Language]
	  ,'/content.aspx?c='+cast([PageId] as nvarchar(max))+'&t='+[PageTitle] as PageUrl
  FROM [CMS].[Page] with (nolock) 
  inner join  Language.[Language]  with (nolock) on Language.[LanguageId]=[CMS].[Page].[LangId]



END


GO
