USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerTicketCount]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [GamePlatform].[ProcCustomerTicketCount] 
@CustomerId bigint
AS

BEGIN
SET NOCOUNT ON;

select Count(*) from RiskManagement.Ticket where CustomerId=@CustomerId and IsRead=0  



END




GO
