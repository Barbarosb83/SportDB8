USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcComboPasswordQuestion]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcComboPasswordQuestion] 
@LanguageId int
AS

BEGIN
SET NOCOUNT ON;


SELECT     Parameter.PasswordQuestion.PasswordQuestionId,  Language.[Parameter.PasswordQuestion].PasswordQuestion
FROM         Parameter.PasswordQuestion INNER JOIN
                      Language.[Parameter.PasswordQuestion] ON Parameter.PasswordQuestion.PasswordQuestionId = Language.[Parameter.PasswordQuestion].PasswordQuestionId
Where Language.[Parameter.PasswordQuestion].LanguageId=@LanguageId


END


GO
