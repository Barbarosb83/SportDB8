USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [BetAcceptance].[ProcStadiumSlipOddCreate]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [BetAcceptance].[ProcStadiumSlipOddCreate] 
@SlipId bigint,
@OddId bigint,
@OddValue float,
@Amount decimal(18,2),
@StateId int,
@BetType int,
@EventName nvarchar(150),
@MatchId bigint,
@CustomerId bigint,
@LangId int,
@Banko int


AS

declare @CurrencyId int
declare @BetradarMatchId bigint



select @CurrencyId=Customer.Customer.CurrencyId from Customer.Customer where Customer.CustomerId=@CustomerId
declare @SlipOddId bigint
declare @EventDate datetime
if(@BetType=0)
begin

select top 1 @EventDate= Match.FixtureDateInfo.MatchDate,@BetradarMatchId=[Match].[Match].BetradarMatchId from  Match.FixtureDateInfo with (nolock) 
INNER JOIN Match.Fixture  with (nolock)
ON Match.FixtureDateInfo.FixtureId=Match.Fixture.FixtureId and Match.Fixture.MatchId=@MatchId INNER JOIN [Match].[Match] ON [Match].[Match].MatchId=Match.Fixture.MatchId

end
else if (@BetType=1)
begin
select top 1 @EventDate=Live.[Event].EventDate,@BetradarMatchId=live.Event.BetradarMatchId from Live.[Event] with (nolock) where Live.[Event].EventId=@MatchId
end
else if (@BetType=2)
begin
select top 1 @EventDate=Outrights.[Event].EventDate,@BetradarMatchId=Outrights.Event.EventBetradarId from Outrights.[Event] with (nolock) where Outrights.[Event].EventId=@MatchId
end
else if (@BetType=3)
begin
select top 1 @EventDate=Virtual.[Event].EventDate,@BetradarMatchId=Virtual.Event.BetradarMatchId from Virtual.[Event] with (nolock) where Virtual.[Event].EventId=@MatchId
end
--else if (@BetType=4)
--begin
--select top 1 @EventDate=LSports.[Event].StartDate from LSports.[Event] where LSports.[Event].EventId=@MatchId
--end



if(@BetType=0)
begin
insert Stadium.SlipOdd(SlipId,OddId,OddValue,Amount,StateId,BetTypeId,OutCome,MatchId,OddsTypeId,SpecialBetValue,ParameterOddId,EventName,EventDate,CurrencyId,SportId,Banko,BetradarMatchId,Score)
select @SlipId,@OddId,@OddValue,@Amount,@StateId,@BetType,
case when Language.[Parameter.Odds].OutComes is not null Then Language.[Parameter.Odds].OutComes else Match.Odd.OutCome end as OutCome,
@MatchId,
Match.Odd.OddsTypeId,
Match.Odd.SpecialBetValue,
Match.Odd.ParameterOddId,@EventName,@EventDate,@CurrencyId,ParameterSportId,@Banko,@BetradarMatchId,'0:0'
From Match.Odd  with (nolock) INNER JOIN
 Parameter.Odds with (nolock) ON Match.Odd.ParameterOddId = Parameter.Odds.OddsId INNER JOIN
 Language.[Parameter.Odds] ON Parameter.Odds.OddsId = Language.[Parameter.Odds].OddsId
where OddId=@OddId and Language.[Parameter.Odds].LanguageId=@LangId

--update Customer.Slip set EventCount=EventCount+1 where Customer.Slip.SlipId=@SlipId

end
else if(@BetType=1)
begin
insert Stadium.SlipOdd(SlipId,OddId,OddValue,Amount,StateId,BetTypeId,OutCome,MatchId,OddsTypeId,SpecialBetValue,ParameterOddId,EventName,EventDate,CurrencyId,Banko,Score,BetradarMatchId)
select @SlipId,@OddId,@OddValue,@Amount,@StateId,@BetType,
case when Language.[Parameter.LiveOdds].OutComes like '%player%' then  Live.EventOdd.OutCome else case when Language.[Parameter.LiveOdds].OutComes like '%none%'  then Live.EventOdd.OutCome else Language.[Parameter.LiveOdds].OutComes end end as OutCome,@MatchId,Live.EventOdd.OddsTypeId,
Live.EventOdd.SpecialBetValue,Live.EventOdd.ParameterOddId,@EventName,@EventDate,@CurrencyId,@Banko,(Select case when  CHARINDEX('-',Live.EventDetail.Score) = 0 then Live.EventDetail.Score else '0:0' end  from Live.EventDetail with (nolock) where Live.EventDetail.EventId=@MatchId),@BetradarMatchId
from Live.EventOdd with (nolock) INNER JOIN Language.[Parameter.LiveOdds] with (nolock) ON Language.[Parameter.LiveOdds].OddsId=live.EventOdd.ParameterOddId 
where Live.EventOdd.MatchId=@MatchId and Live.EventOdd.OddId=@OddId and LanguageId=@LangId

update Customer.Slip set IsLive=1 where Customer.Slip.SlipId=@SlipId

end
else if(@BetType=2)
begin
insert Stadium.SlipOdd(SlipId,OddId,OddValue,Amount,StateId,BetTypeId,OutCome,MatchId,OddsTypeId,SpecialBetValue,ParameterOddId,EventName,EventDate,CurrencyId,Banko,BetradarMatchId)
select @SlipId,@OddId,@OddValue,@Amount,@StateId,@BetType,
Language.[ParameterCompetitor].CompetitorName,@MatchId,Outrights.Odd.OddsTypeId,
Outrights.Odd.SpecialBetValue,Outrights.Odd.ParameterOddId,@EventName,@EventDate,@CurrencyId,@Banko,@BetradarMatchId
from Outrights.Odd  with (nolock)
inner join Language.[ParameterCompetitor] with (nolock) on 
	Language.[ParameterCompetitor].CompetitorId=Outrights.Odd.CompetitorId and
		 Language.[ParameterCompetitor].LanguageId=1
where Outrights.Odd.MatchId=@MatchId and Outrights.Odd.OddId=@OddId

--update Customer.Slip set EventCount=EventCount+1 where Customer.Slip.SlipId=@SlipId

end
else if(@BetType=3)
begin
insert Stadium.SlipOdd(SlipId,OddId,OddValue,Amount,StateId,BetTypeId,OutCome,MatchId,OddsTypeId,SpecialBetValue,ParameterOddId,EventName,EventDate,CurrencyId,Banko,BetradarMatchId)
select @SlipId,@OddId,@OddValue,@Amount,@StateId,@BetType,
Virtual.EventOdd.OutCome,@MatchId,Virtual.EventOdd.OddsTypeId,
Virtual.EventOdd.SpecialBetValue,Virtual.EventOdd.ParameterOddId,@EventName,@EventDate,@CurrencyId,@Banko,@BetradarMatchId
from Virtual.EventOdd with (nolock) where Virtual.EventOdd.MatchId=@MatchId and Virtual.EventOdd.OddId=@OddId

--update Customer.Slip set EventCount=EventCount+1 where Customer.Slip.SlipId=@SlipId

end
--else if(@BetType=4)
--begin
--insert Stadium.SlipOdd(SlipId,OddId,OddValue,Amount,StateId,BetTypeId,OutCome,MatchId,OddsTypeId,SpecialBetValue,ParameterOddId,EventName,EventDate,CurrencyId)
--select @SlipId,LSports.EventParticipants.EventParticipantId,@OddValue,@Amount,@StateId,@BetType,
--LSports.EventParticipants.Name,@MatchId,case when LSports.EventOdds.CurrentPrice>1 then  
--LSports.[Parameter.OutcomeType].OutcomeTypeId else 5 end,
--'',@OddId,@EventName,@EventDate,@CurrencyId
--from LSports.EventOdds
--inner join LSports.EventParticipants on LSports.EventParticipants.EventId=LSports.EventOdds.EventId and 
--LSports.EventParticipants.EventParticipantId=LSports.EventOdds.EventPaticipantId  INNER JOIN
-- LSports.[Parameter.OutcomeType] ON LSports.EventOdds.OutcomeTypeId = LSports.[Parameter.OutcomeType].LOutComeTypeId
--where LSports.EventOdds.EventId=@MatchId and LSports.EventOdds.EventOddId=@OddId

--update Customer.Slip set EventCount=EventCount+1 where Customer.Slip.SlipId=@SlipId

--end


set @SlipOddId=SCOPE_IDENTITY()


	return @SlipOddId


GO
