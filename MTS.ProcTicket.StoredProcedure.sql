USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [MTS].[ProcTicket]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [MTS].[ProcTicket]
@TicketId bigint


AS




BEGIN
SET NOCOUNT ON;

if(@TicketId=0)
begin
SELECT    TicketId, betSHA1, channelID, endCustomerID, endCustomerIP, shopID, terminalID, deviceID, languageID, stk, cur, sys, ts_UTC, MTS.Ticket.TotalOddValue, MTS.Ticket.SlipStateId, MTS.Ticket.GroupId, MTS.Ticket.SlipTypeId, MTS.Ticket.SourceId, MTS.Ticket.SlipStatu, 
                         MTS.Ticket.CurrencyId, resultCode, result, exceptionMessage, intExceptionMessage, exchangeRate, betAcceptanceId, HasSent, Mts.Ticket.SlipId
FROM            MTS.Ticket
where TicketId not in (SELECT    TicketId
FROM            MTS.Ticket INNER JOIN Archive.Slip ON Mts.Ticket.TicketId=Archive.Slip.MTSTicketId) and TicketId not in (SELECT    TicketId
FROM            MTS.Ticket INNER JOIN Customer.Slip ON Mts.Ticket.TicketId=Customer.Slip.MTSTicketId)
UNION ALL
SELECT        MTS.Ticket.TicketId, MTS.Ticket.betSHA1, MTS.Ticket.channelID, MTS.Ticket.endCustomerID, MTS.Ticket.endCustomerIP, MTS.Ticket.shopID, MTS.Ticket.terminalID, MTS.Ticket.deviceID, MTS.Ticket.languageID, 
                         MTS.Ticket.stk, MTS.Ticket.cur, MTS.Ticket.sys, MTS.Ticket.ts_UTC, MTS.Ticket.TotalOddValue, MTS.Ticket.SlipStateId, MTS.Ticket.GroupId, MTS.Ticket.SlipTypeId, MTS.Ticket.SourceId, MTS.Ticket.SlipStatu, 
                         MTS.Ticket.CurrencyId, MTS.Ticket.resultCode, MTS.Ticket.result, MTS.Ticket.exceptionMessage, MTS.Ticket.intExceptionMessage, MTS.Ticket.exchangeRate, MTS.Ticket.betAcceptanceId, MTS.Ticket.HasSent, 
                         Archive.Slip.SlipId
FROM            MTS.Ticket INNER JOIN
                         Archive.Slip ON MTS.Ticket.TicketId = Archive.Slip.MTSTicketId
						 UNION ALL
SELECT        MTS.Ticket.TicketId, MTS.Ticket.betSHA1, MTS.Ticket.channelID, MTS.Ticket.endCustomerID, MTS.Ticket.endCustomerIP, MTS.Ticket.shopID, MTS.Ticket.terminalID, MTS.Ticket.deviceID, MTS.Ticket.languageID, 
                         MTS.Ticket.stk, MTS.Ticket.cur, MTS.Ticket.sys, MTS.Ticket.ts_UTC, MTS.Ticket.TotalOddValue, MTS.Ticket.SlipStateId, MTS.Ticket.GroupId, MTS.Ticket.SlipTypeId, MTS.Ticket.SourceId, MTS.Ticket.SlipStatu, 
                         MTS.Ticket.CurrencyId, MTS.Ticket.resultCode, MTS.Ticket.result, MTS.Ticket.exceptionMessage, MTS.Ticket.intExceptionMessage, MTS.Ticket.exchangeRate, MTS.Ticket.betAcceptanceId, MTS.Ticket.HasSent, 
                         Customer.Slip.SlipId
FROM            MTS.Ticket INNER JOIN
                         Customer.Slip ON MTS.Ticket.TicketId = Customer.Slip.MTSTicketId
end
else
begin
SELECT    TicketId, betSHA1, channelID, endCustomerID, endCustomerIP, shopID, terminalID, deviceID, languageID, stk, cur, sys, ts_UTC, MTS.Ticket.TotalOddValue, MTS.Ticket.SlipStateId, MTS.Ticket.GroupId, MTS.Ticket.SlipTypeId, MTS.Ticket.SourceId, MTS.Ticket.SlipStatu, 
                         MTS.Ticket.CurrencyId, resultCode, result, exceptionMessage, intExceptionMessage, exchangeRate, betAcceptanceId, HasSent, Mts.Ticket.SlipId
FROM            MTS.Ticket
where TicketId not in (SELECT    TicketId
FROM            MTS.Ticket INNER JOIN Archive.Slip ON Mts.Ticket.TicketId=Archive.Slip.MTSTicketId) and TicketId not in (SELECT    TicketId
FROM            MTS.Ticket INNER JOIN Customer.Slip ON Mts.Ticket.TicketId=Customer.Slip.MTSTicketId) and TicketId=@TicketId
UNION ALL
SELECT        MTS.Ticket.TicketId, MTS.Ticket.betSHA1, MTS.Ticket.channelID, MTS.Ticket.endCustomerID, MTS.Ticket.endCustomerIP, MTS.Ticket.shopID, MTS.Ticket.terminalID, MTS.Ticket.deviceID, MTS.Ticket.languageID, 
                         MTS.Ticket.stk, MTS.Ticket.cur, MTS.Ticket.sys, MTS.Ticket.ts_UTC, MTS.Ticket.TotalOddValue, MTS.Ticket.SlipStateId, MTS.Ticket.GroupId, MTS.Ticket.SlipTypeId, MTS.Ticket.SourceId, MTS.Ticket.SlipStatu, 
                         MTS.Ticket.CurrencyId, MTS.Ticket.resultCode, MTS.Ticket.result, MTS.Ticket.exceptionMessage, MTS.Ticket.intExceptionMessage, MTS.Ticket.exchangeRate, MTS.Ticket.betAcceptanceId, MTS.Ticket.HasSent, 
                         Archive.Slip.SlipId
FROM            MTS.Ticket INNER JOIN
                         Archive.Slip ON MTS.Ticket.TicketId = Archive.Slip.MTSTicketId and TicketId=@TicketId
						 UNION ALL
SELECT        MTS.Ticket.TicketId, MTS.Ticket.betSHA1, MTS.Ticket.channelID, MTS.Ticket.endCustomerID, MTS.Ticket.endCustomerIP, MTS.Ticket.shopID, MTS.Ticket.terminalID, MTS.Ticket.deviceID, MTS.Ticket.languageID, 
                         MTS.Ticket.stk, MTS.Ticket.cur, MTS.Ticket.sys, MTS.Ticket.ts_UTC, MTS.Ticket.TotalOddValue, MTS.Ticket.SlipStateId, MTS.Ticket.GroupId, MTS.Ticket.SlipTypeId, MTS.Ticket.SourceId, MTS.Ticket.SlipStatu, 
                         MTS.Ticket.CurrencyId, MTS.Ticket.resultCode, MTS.Ticket.result, MTS.Ticket.exceptionMessage, MTS.Ticket.intExceptionMessage, MTS.Ticket.exchangeRate, MTS.Ticket.betAcceptanceId, MTS.Ticket.HasSent, 
                         Customer.Slip.SlipId
FROM            MTS.Ticket INNER JOIN
                         Customer.Slip ON MTS.Ticket.TicketId = Customer.Slip.MTSTicketId and TicketId=@TicketId
end

END



GO
