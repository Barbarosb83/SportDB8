USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [BetAcceptance].[MTS.ProcTicket]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [BetAcceptance].[MTS.ProcTicket] 
 @TicketId bigint
AS

SELECT   TicketId, betSHA1, channelID, endCustomerID, endCustomerIP, 
				shopID, terminalID, deviceID, languageID, stk, cur,
					 [sys], ts_UTC, TotalOddValue, SlipStateId, GroupId, SlipTypeId, SourceId, SlipStatu, 
                         CurrencyId, resultCode, result, exceptionMessage, 
								intExceptionMessage, exchangeRate, betAcceptanceId
FROM            MTS.Ticket
WHERE  MTS.Ticket.TicketId=@TicketId


GO
