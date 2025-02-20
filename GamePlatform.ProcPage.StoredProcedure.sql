USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcPage]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcPage]
@PageId int,
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
  where PageId=@PageId and [LangId]=@LangId


END


GO
