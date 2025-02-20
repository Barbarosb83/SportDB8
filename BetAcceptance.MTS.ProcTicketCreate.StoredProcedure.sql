USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [BetAcceptance].[MTS.ProcTicketCreate]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [BetAcceptance].[MTS.ProcTicketCreate] 
@CustomerId bigint,
@TotalOddValue float,
@Amount money,
@SlipStateId int,
@SlipTypeId int,
@SourceId int,
@SlipStatu int,
@betSHA1 char(40),
@channelID nvarchar(10),
@endCustomerIP nchar(15),
@shopID nchar(10),
@terminalID nchar(10),
@deviceID nchar(10),
@languageID nchar(2),
@sys nchar(20),
@ts_UTC nchar(14)

AS

declare @TicketId bigint=0
declare @CurrencyId int
declare @Balance money=0

select @CurrencyId=Customer.Customer.CurrencyId,@Balance=Customer.Balance from Customer.Customer where Customer.CustomerId=@CustomerId

if(@Balance>@Amount)
begin

declare @CurrencySymbol nchar(3)
select @CurrencySymbol=Parameter.Currency.Symbol3 from Parameter.Currency where Parameter.Currency.CurrencyId=@CurrencyId

INSERT INTO [MTS].[Ticket]
           ([betSHA1]
           ,[channelID]
           ,[endCustomerID]
           ,[endCustomerIP]
           ,[shopID]
           ,[terminalID]
           ,[deviceID]
           ,[languageID]
           ,[stk]
           ,[cur]
           ,[sys]
           ,[ts_UTC]
           ,[TotalOddValue]
           ,[SlipStateId]
           ,[SlipTypeId]
           ,[SourceId]
           ,[SlipStatu]
           ,[CurrencyId]
		   ,[HasSent])
     VALUES
           (@betSHA1
           ,@channelID
           ,@CustomerId
           ,@endCustomerIP
           ,@shopID
           ,@terminalID
           ,@deviceID
           ,@languageID
           ,@Amount
           ,@CurrencySymbol
           ,@sys
           ,@ts_UTC
           ,@TotalOddValue
           ,@SlipStateId
           ,@SlipTypeId
           ,@SourceId
           ,@SlipStatu
           ,@CurrencyId
		   ,1)


set @TicketId=SCOPE_IDENTITY()
end



return @TicketId


GO
