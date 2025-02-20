USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Customer].[ProcBitcoinPendingList]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Customer].[ProcBitcoinPendingList]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SELECT [BitcoinTransactionId]
      ,[CustomerId]
      ,[Amount]
      ,[CurrencyId]
      ,[CreatedDate]
      ,[Status]
      ,[InvoiceId]
  FROM [Customer].[BitcoinTransaction]
where [Status]!='complete' and [Status]!='expired' and [Status]!='invalid'

END


GO
