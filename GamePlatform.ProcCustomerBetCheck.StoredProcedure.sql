USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerBetCheck]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 

CREATE PROCEDURE [GamePlatform].[ProcCustomerBetCheck] 
@CustomerId bigint,
@BetradarMatchId bigint,
@BetTypeId int
AS

BEGIN
SET NOCOUNT ON;

declare @MatchId bigint
select @MatchId=Live.[Event].EventId
from Live.[Event] with (nolock) where Live.[Event].BetradarMatchId=@BetradarMatchId

declare @result int=0

if exists (
select Customer.SlipOdd.SlipOddId 
from Customer.SlipOdd with (nolock) INNER JOIN Customer.Slip with (nolock) On Customer.Slip.SlipId=Customer.SlipOdd.SlipId 
where Customer.SlipOdd.MatchId=@MatchId and Customer.Slip.CustomerId=@CustomerId and Customer.SlipOdd.BetTypeId=1 )
 set @result=1



 select @result as results

END





GO
