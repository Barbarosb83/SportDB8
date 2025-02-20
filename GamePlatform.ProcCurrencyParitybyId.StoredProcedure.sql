USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCurrencyParitybyId]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [GamePlatform].[ProcCurrencyParitybyId] 
@CurrencyId int
AS

BEGIN
SET NOCOUNT ON;

SELECT top 1[CurrencyParityId]
      ,[ParityDate]
      ,[CurrencyId]
      ,[Parity]
  FROM [Parameter].[CurrencyParity]
  Where CurrencyId=@CurrencyId
  order by [ParityDate] desc


END



GO
