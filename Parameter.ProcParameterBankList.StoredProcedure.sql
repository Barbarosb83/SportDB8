USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Parameter].[ProcParameterBankList]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Parameter].[ProcParameterBankList]

AS

BEGIN
SET NOCOUNT ON;

SELECT [BankId]
      ,[BankCode]
      ,[BankName]
  FROM [Parameter].[BankList]

END


GO
