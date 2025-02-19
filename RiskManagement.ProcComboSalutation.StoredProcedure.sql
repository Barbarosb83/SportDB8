USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcComboSalutation]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [RiskManagement].[ProcComboSalutation]
@LanguageId int


AS




BEGIN
SET NOCOUNT ON;


select Language.[Parameter.Salutation].SalutationId,Language.[Parameter.Salutation].Salutation
from Language.[Parameter.Salutation] 
where Language.[Parameter.Salutation] .LanguageId=@LanguageId

END




GO
