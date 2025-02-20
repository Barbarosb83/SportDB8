USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Customer].[ProcBitcoinRequest]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Customer].[ProcBitcoinRequest]
	@CustomerId bigint,
    @Amount money,
    @CurrencyId int,
    @CreatedDate datetime,
    @Status nvarchar(10),
    @InvoiceId nvarchar(22)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  
INSERT INTO [Customer].[BitcoinTransaction]
           ([CustomerId]
           ,[Amount]
           ,[CurrencyId]
           ,[CreatedDate]
           ,[Status]
           ,[InvoiceId])
     VALUES
           (@CustomerId
           ,@Amount
           ,@CurrencyId
           ,@CreatedDate
           ,@Status
           ,@InvoiceId)


END


GO
