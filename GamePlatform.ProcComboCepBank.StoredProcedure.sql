USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcComboCepBank]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcComboCepBank] 
@LanguageId int


AS


Select Parameter.CepBank.CepBankId,Parameter.CepBank.CepBank
from Parameter.CepBank


GO
