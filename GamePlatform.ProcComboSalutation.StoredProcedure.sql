USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcComboSalutation]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcComboSalutation] 
@LanguageId int
AS

BEGIN
SET NOCOUNT ON;

SELECT     Parameter.Salutation.SalutationId, Language.[Parameter.Salutation].Salutation
FROM         Parameter.Salutation INNER JOIN
                      Language.[Parameter.Salutation] ON Parameter.Salutation.SalutationId = Language.[Parameter.Salutation].SalutationId
where Language.[Parameter.Salutation].LanguageId=@LanguageId

END


GO
