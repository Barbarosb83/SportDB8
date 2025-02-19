USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Dashboard].[ProcPendingTaskDepositCepBankRequest]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Dashboard].[ProcPendingTaskDepositCepBankRequest] 

AS

BEGIN
SET NOCOUNT ON;



select ISNULL(COUNT( RiskManagement.Ticket.TicketId),0) 
FROM    RiskManagement.Ticket with (nolock)    
WHERE  RiskManagement.Ticket.TicketStatusId =1 and cast(RiskManagement.Ticket.CreateDate as date)>'20201231'


END


GO
