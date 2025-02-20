USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [BetAcceptance].[ProcSlipOddCreate_old]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [BetAcceptance].[ProcSlipOddCreate_old] 
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

declare @CurrencyId int=3
declare @BetradarMatchId bigint



--select @CurrencyId=Customer.Customer.CurrencyId from Customer.Customer where Customer.CustomerId=@CustomerId
declare @SlipOddId bigint
declare @EventDate datetime
--if(@BetType=0)
--begin



--end
--else if (@BetType=1)
--begin

--end
--else if (@BetType=2)
--begin

--end
--else if (@BetType=3)
--begin

--end
----else if (@BetType=4)
----begin

----end



if(@BetType=0)
begin
select top 1 @EventDate= Archive.FixtureDateInfo.MatchDate,@BetradarMatchId=Archive.[Match].BetradarMatchId from  Archive.FixtureDateInfo with (nolock) 
INNER JOIN Archive.Fixture  with (nolock)
ON Archive.FixtureDateInfo.FixtureId=Archive.Fixture.FixtureId and Archive.Fixture.MatchId=@MatchId INNER JOIN Archive.[Match] ON Archive.[Match].MatchId=Archive.Fixture.MatchId


insert Customer.SlipOdd(SlipId,OddId,OddValue,Amount,StateId,BetTypeId,OutCome,MatchId,OddsTypeId,SpecialBetValue,ParameterOddId,EventName,EventDate,CurrencyId,SportId,Banko,BetradarMatchId,Score)
select @SlipId,@OddId,@OddValue,@Amount,@StateId,@BetType,
case when Language.[Parameter.Odds].OutComes is not null Then Language.[Parameter.Odds].OutComes else Archive.Odd.OutCome end as OutCome,
@MatchId,
Archive.Odd.OddsTypeId,
Archive.Odd.SpecialBetValue,
Archive.Odd.ParameterOddId,@EventName,@EventDate,@CurrencyId,ParameterSportId,@Banko,@BetradarMatchId,'0:0'
From Archive.Odd  with (nolock)  INNER JOIN
 Language.[Parameter.Odds] ON Language.[Parameter.Odds].OddsId=Archive.Odd.ParameterOddId and Language.[Parameter.Odds].LanguageId=@LangId
where OddId=@OddId --and Language.[Parameter.Odds].LanguageId=@LangId

--update Customer.Slip set EventCount=EventCount+1 where Customer.Slip.SlipId=@SlipId

end
else if(@BetType=1)
begin

select top 1 @EventDate=Archive.[Live.Event].EventDate  from Archive.[Live.Event]  with (nolock) where Archive.[Live.Event].EventId=@MatchId

insert Customer.SlipOdd(SlipId,OddId,OddValue,Amount,StateId,BetTypeId,OutCome,MatchId,OddsTypeId,SpecialBetValue,ParameterOddId,EventName,EventDate,CurrencyId,Banko,Score,BetradarMatchId)
select @SlipId,@OddId,@OddValue,@Amount,@StateId,@BetType,
case when Language.[Parameter.LiveOdds].OutComes like '%player%' then  Archive.[Live.EventOdd].OutCome else case when Language.[Parameter.LiveOdds].OutComes like '%none%'  then Archive.[Live.EventOdd].OutCome else Language.[Parameter.LiveOdds].OutComes end end as OutCome,@MatchId,Archive.[Live.EventOdd].OddsTypeId,
Archive.[Live.EventOdd].SpecialBetValue,Language.[Parameter.LiveOdds].OddsId,@EventName,@EventDate,@CurrencyId,@Banko,
 case when  CHARINDEX('-',Archive.[Live.EventDetail].Score) = 0 then Archive.[Live.EventDetail].Score else '0:0' end ,Archive.[Live.EventDetail].BetradarMatchIds
from Archive.[Live.EventOdd]  with (nolock) INNER JOIN Language.[Parameter.LiveOdds] with (nolock) ON Language.[Parameter.LiveOdds].OddsId=Archive.[Live.EventOdd].ParameterOddId and Language.[Parameter.LiveOdds].LanguageId=@LangId 
INNER JOIN Archive.[Live.EventDetail] ON Archive.[Live.EventDetail].BetradarMatchIds=Archive.[Live.EventOdd].BetradarMatchId
where Archive.[Live.EventOdd].OddId=@OddId 

--update Customer.Slip set IsLive=1 where Customer.Slip.SlipId=@SlipId

end
else if(@BetType=2)
begin

select top 1 @EventDate=Outrights.[Event].EventDate,@BetradarMatchId=Outrights.Event.EventBetradarId from Outrights.[Event] with (nolock) where Outrights.[Event].EventId=@MatchId

insert Customer.SlipOdd(SlipId,OddId,OddValue,Amount,StateId,BetTypeId,OutCome,MatchId,OddsTypeId,SpecialBetValue,ParameterOddId,EventName,EventDate,CurrencyId,Banko,BetradarMatchId)
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

select top 1 @EventDate=Virtual.[Event].EventDate,@BetradarMatchId=Virtual.Event.BetradarMatchId from Virtual.[Event] with (nolock) where Virtual.[Event].EventId=@MatchId

insert Customer.SlipOdd(SlipId,OddId,OddValue,Amount,StateId,BetTypeId,OutCome,MatchId,OddsTypeId,SpecialBetValue,ParameterOddId,EventName,EventDate,CurrencyId,Banko,BetradarMatchId)
select @SlipId,@OddId,@OddValue,@Amount,@StateId,@BetType,
Virtual.EventOdd.OutCome,@MatchId,Virtual.EventOdd.OddsTypeId,
Virtual.EventOdd.SpecialBetValue,Virtual.EventOdd.ParameterOddId,@EventName,@EventDate,@CurrencyId,@Banko,@BetradarMatchId
from Virtual.EventOdd with (nolock) where Virtual.EventOdd.MatchId=@MatchId and Virtual.EventOdd.OddId=@OddId

--update Customer.Slip set EventCount=EventCount+1 where Customer.Slip.SlipId=@SlipId

end
--else if(@BetType=4)
--begin
--select top 1 @EventDate=LSports.[Event].StartDate from LSports.[Event] where LSports.[Event].EventId=@MatchId

--select top 1 @EventDate=Virtual.[Event].EventDate,@BetradarMatchId=Virtual.Event.BetradarMatchId from Virtual.[Event] with (nolock) where Virtual.[Event].EventId=@MatchId
--insert Customer.SlipOdd(SlipId,OddId,OddValue,Amount,StateId,BetTypeId,OutCome,MatchId,OddsTypeId,SpecialBetValue,ParameterOddId,EventName,EventDate,CurrencyId)
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
