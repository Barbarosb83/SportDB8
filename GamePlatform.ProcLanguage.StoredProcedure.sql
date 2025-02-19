USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcLanguage]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [GamePlatform].[ProcLanguage] 


AS


 Select Language.[Language].LanguageId,Language.[Language].Comments,Language.[Language].Language
 from Language.[Language] with (nolock)
 where Language.[Language].IsActive=1


GO
