USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcComboLanguage]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [RiskManagement].[ProcComboLanguage]



AS




BEGIN
SET NOCOUNT ON;


select Language.[Language].LanguageId,Language.[Language].Comments as Language,Language.[Language].Comments 
from Language.[Language] where LanguageId<>1

END



GO
