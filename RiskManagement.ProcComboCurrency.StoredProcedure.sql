USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcComboCurrency]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcComboCurrency]



AS




BEGIN
SET NOCOUNT ON;


select Parameter.Currency.CurrencyId,Parameter.Currency.Currency from Parameter.Currency where CurrencyId=3

END


GO
