USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcMobileHomeMenu]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcMobileHomeMenu]
@LangId int
AS

BEGIN
SET NOCOUNT ON;

SELECT [MobileHomeMenuId]
      ,[Title]
      ,[Icon]
      ,[LanguageId]
      ,[NavigateURL]
      ,[Position]
      ,[IsTop]
      ,[SportId]
      ,cast(0 as bigint) as TournamentId
      ,[TimeRangeId]
  FROM [CMS].[MobileHomeMenu] with (nolock)
  where  [LanguageId]=@LangId and IsEnabled=1
  order by [Position]

END



GO
