USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerTicket]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcCustomerTicket] 
@CustomerId bigint
AS

BEGIN
SET NOCOUNT ON;

select RiskManagement.Ticket.TicketId
,RiskManagement.Ticket.Subject
,RiskManagement.Ticket.Description
,RiskManagement.Ticket.CreateDate
,RiskManagement.Ticket.TicketStatusId 
,Parameter.TicketStatus.TicketStatus
,RiskManagement.Ticket.UploadFile
,RiskManagement.Ticket.IsRead
from RiskManagement.Ticket INNER JOIN Parameter.TicketStatus On
Parameter.TicketStatus.TicketStatusId=RiskManagement.Ticket.TicketStatusId 
where CustomerId=@CustomerId



END




GO
