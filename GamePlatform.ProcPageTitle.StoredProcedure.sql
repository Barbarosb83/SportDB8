USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcPageTitle]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [GamePlatform].[ProcPageTitle]
@PageTitle nvarchar(150),
@LangId int
AS

BEGIN
SET NOCOUNT ON;

SELECT [PageId]
      ,[PageTitle]
      ,[LangId]
      ,[HtmlContent]
	  ,Language.[Language].[Language]
	  ,'/content.aspx?c='+cast([PageId] as nvarchar(max))+'&t='+[PageTitle] as PageUrl
  FROM [CMS].[Page]
  inner join  Language.[Language] on Language.[LanguageId]=[CMS].[Page].[LangId]
  where PageTitle=@PageTitle and [LangId]=@LangId


END


GO
