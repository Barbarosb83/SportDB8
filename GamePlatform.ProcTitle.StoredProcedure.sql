USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcTitle]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcTitle] 
@LangId int
AS

BEGIN
SET NOCOUNT ON;

SELECT      TitleId, HomePage, Sportsbook, Live, Virtual, Casino, Mobile, LanguageId
FROM            CMS.Title
Where LanguageId=@LangId

END


GO
