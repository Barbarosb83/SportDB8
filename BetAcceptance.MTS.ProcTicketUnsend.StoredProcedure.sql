USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [BetAcceptance].[MTS.ProcTicketUnsend]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [BetAcceptance].[MTS.ProcTicketUnsend] 
 
AS

SELECT   TicketId
FROM            MTS.Ticket
WHERE  MTS.Ticket.resultCode is null and MTS.Ticket.HasSent=0


GO
