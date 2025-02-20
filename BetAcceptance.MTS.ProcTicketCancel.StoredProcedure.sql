USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [BetAcceptance].[MTS.ProcTicketCancel]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [BetAcceptance].[MTS.ProcTicketCancel] 
@TicketId bigint,
@resultCode int,
@result nvarchar(50),
@exceptionMessage nvarchar(max),
@intExceptionMessage nvarchar(max),
@exchangeRate nvarchar(10),
@betAcceptanceId nvarchar(max)
AS


declare @SlipId bigint


	select @SlipId=SlipId from MTS.Ticket where TicketId=@TicketId

update Customer.Slip set Customer.Slip.SlipStateId=2 where Customer.Slip.SlipId=@SlipId
update Customer.SlipOdd set Customer.SlipOdd.StateId=2 where Customer.SlipOdd.SlipId=@SlipId

	
	declare @Amount money
	declare @CustomerId bigint
	
	select @Amount=Customer.Slip.Amount,@CustomerId=Customer.Slip.CustomerId from Customer.Slip 
	where Customer.Slip.SlipId=@SlipId
	
	update Customer.Customer set Customer.Customer.Balance=Customer.Customer.Balance+@Amount 
	where Customer.Customer.CustomerId=@CustomerId

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
