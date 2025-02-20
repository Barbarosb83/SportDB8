USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcTerminalMoneyTransaction]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE PROCEDURE [Retail].[ProcTerminalMoneyTransaction]
@TerminalId bigint,
@TransactionId nvarchar(max),
@CustomerId bigint,
@CurrencyId int,
@LocalTime datetime,
@TransactionAmount money,
@Status nvarchar(50)


AS




BEGIN
SET NOCOUNT ON;

declare @OldValues nvarchar(max)
declare @resultcode int=106
declare @resultmessage nvarchar(max)='Hata oluştu'
 
select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=2
 

 INSERT INTO [Retail].[ValidatorTransaction]
           ([TerminalId]
           ,[TerminalTransactionId]
           ,[CustomerId]
           ,[CurrencyId]
           ,[LocalTime]
           ,[TransactionMoney]
           ,[Status]
           ,[CreateDate])
     VALUES (@TerminalId,@TransactionId,@CustomerId,@CurrencyId,@LocalTime,@TransactionAmount,@Status,GETDATE())


	select @resultcode as resultcode,@resultmessage as resultmessage
END




GO
