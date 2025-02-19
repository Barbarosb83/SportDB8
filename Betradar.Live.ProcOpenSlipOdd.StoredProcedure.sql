USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Live.ProcOpenSlipOdd]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Betradar].[Live.ProcOpenSlipOdd]

AS


BEGIN
 



select DISTINCT Live.EventOdd.BetradarMatchId,BettradarOddId from Live.EventOdd with (nolock) INNER JOIN Customer.SlipOdd with (nolock) ON
Live.EventOdd.OddId=Customer.SlipOdd.OddId and Customer.SlipOdd.StateId=1 and Customer.SlipOdd.BetTypeId=1


END


GO
