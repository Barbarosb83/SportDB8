USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [BetAcceptance].[ProcEventOddInfo]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [BetAcceptance].[ProcEventOddInfo] 
@OddId bigint,
@BetType int


AS

declare @result int=0

if (@BetType=0)
begin
	select OddsTypeId,OutCome,SpecialBetValue from Match.Odd with (nolock) where OddId=@OddId
 end
else if (@BetType=1)
begin

	select OddsTypeId ,OutCome,SpecialBetValue from Live.EventOdd with (nolock) where OddId=@OddId
end
else if (@BetType=2)
begin

	select CAST(534 as int) as OddsTypeId ,OutCome,SpecialBetValue from Outrights.Odd with (nolock) where OddId=@OddId
end


GO
