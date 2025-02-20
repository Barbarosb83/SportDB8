USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [BetAcceptance].[MTS.ProcTicketUpdate]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [BetAcceptance].[MTS.ProcTicketUpdate] 
@TicketId bigint,
@resultCode int,
@result nvarchar(50),
@exceptionMessage nvarchar(max),
@intExceptionMessage nvarchar(max),
@exchangeRate nvarchar(10),
@betAcceptanceId nvarchar(max)
AS

UPDATE [MTS].[Ticket]
   SET 
       [resultCode] = @resultCode
      ,[result] = @result
      ,[exceptionMessage] = @exceptionMessage
      ,[intExceptionMessage] = @intExceptionMessage
      ,[exchangeRate] = @exchangeRate
      ,[betAcceptanceId] = @betAcceptanceId
 WHERE TicketId=@TicketId


GO
