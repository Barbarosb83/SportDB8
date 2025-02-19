USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [BetAcceptance].[MTS.ProcTicketUpdateSlipId]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [BetAcceptance].[MTS.ProcTicketUpdateSlipId] 
 @TicketId bigint,
 @SlipId bigint
AS

UPDATE           MTS.Ticket
SET SlipId=@SlipId
WHERE  MTS.Ticket.TicketId=@TicketId



GO
