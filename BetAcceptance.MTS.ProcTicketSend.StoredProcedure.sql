USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [BetAcceptance].[MTS.ProcTicketSend]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [BetAcceptance].[MTS.ProcTicketSend] 
 @TicketId bigint
AS

UPDATE           MTS.Ticket
SET HasSent=1
WHERE  MTS.Ticket.TicketId=@TicketId



GO
