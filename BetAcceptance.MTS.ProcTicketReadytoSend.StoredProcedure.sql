USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [BetAcceptance].[MTS.ProcTicketReadytoSend]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [BetAcceptance].[MTS.ProcTicketReadytoSend] 
 @TicketId bigint
AS

UPDATE           MTS.Ticket
SET HasSent=0
WHERE  MTS.Ticket.TicketId=@TicketId



GO
