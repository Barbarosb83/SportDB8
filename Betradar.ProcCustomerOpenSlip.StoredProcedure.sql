USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[ProcCustomerOpenSlip]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Betradar].[ProcCustomerOpenSlip]

AS


BEGIN

 


select DISTINCT Live.Event.BetradarMatchId from Live.Event with (nolock) INNER JOIn Customer.SlipOdd with (nolock)
ON Live.Event.EventId=Customer.SlipOdd.MatchId and  Customer.SlipOdd.StateId=1 and Customer.SlipOdd.BetTypeId=1


END


GO
