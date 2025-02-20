USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [BetAcceptance].[MTS.ProcSelectionCreate]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [BetAcceptance].[MTS.ProcSelectionCreate] 
@TicketId bigint,
@OddId bigint,
@OddValue float,
@Amount money,
@StateId int,
@BetType int,
@EventName nvarchar(150),
@MatchId bigint,
@CustomerId bigint,
@Bank int


AS

declare @CurrencyId int

select @CurrencyId=Customer.Customer.CurrencyId from Customer.Customer where Customer.CustomerId=@CustomerId

declare @SlipOddId bigint
declare @EventDate datetime

if(@BetType=0)
begin
	select @EventDate= Match.FixtureDateInfo.MatchDate from  Match.FixtureDateInfo
	where  Match.FixtureDateInfo.FixtureId=(select FixtureId from Match.Fixture where Match.Fixture.MatchId=@MatchId)
end
else if (@BetType=1)
begin
	select @EventDate=Live.[Event].EventDate from Live.[Event] where Live.[Event].EventId=@MatchId
end
else if (@BetType=2)
begin
	select @EventDate=Outrights.[Event].EventDate from Outrights.[Event] where Outrights.[Event].EventId=@MatchId
end
else if (@BetType=3)
begin
	select @EventDate=Virtual.[Event].EventDate from Virtual.[Event] where Virtual.[Event].EventId=@MatchId
end

declare @OddsTypeId int
declare @SpecialBetValue nvarchar(50)
declare @ParameterOddId int
declare @Outcome nvarchar(50)
declare @BetradarOddsTypeId int
declare @BetradarOddsSubTypeId int
declare @BetradarMatchId bigint
declare @PlayerId nvarchar(50)
if(@BetType=0)
begin

select @Outcome= OutCome, @OddsTypeId=OddsTypeId,@SpecialBetValue=SpecialBetValue,@ParameterOddId=ParameterOddId,@PlayerId=BetradarPlayerId
From Match.Odd where OddId=@OddId



select @BetradarOddsTypeId=Parameter.OddsType.BetradarOddsTypeId from Parameter.OddsType where Parameter.OddsType.OddsTypeId=@OddsTypeId
select @BetradarMatchId=Match.Match.BetradarMatchId,@BetradarOddsSubTypeId=Parameter.Sport.BetRadarSportId from Match.Match INNER JOIN 
Parameter.Tournament ON Parameter.Tournament.TournamentId=Match.TournamentId  INNER JOIN
Parameter.Category ON Parameter.Category.CategoryId=Parameter.Tournament.CategoryId INNER JOIN 
Parameter.Sport On Parameter.Sport.SportId=Parameter.Category.SportId
where Match.MatchId=@MatchId


if(@BetradarOddsTypeId in (201,235,389))
	begin
		set @Outcome=@Outcome+'!'+isnull(@PlayerId,'')
	end


INSERT INTO [MTS].[Selection]
           ([TicketId]
           ,[line]
           ,[BetradarOddsTypeId]
           ,[BetradarOddsSubTypeId]
           ,[SpecialBetValue]
           ,[Outcome]
           ,[BetradarMatchId]
           ,[OddValue]
           ,[bank]
           ,[ways]
           ,[OddId]
           ,[Amount]
           ,[StateId]
           ,[BetTypeId]
           ,[MatchId]
           ,[ParameterOddId]
           ,[EventName]
           ,[EventDate]
           ,[CurrencyId])
     VALUES
           (@TicketId
           ,'prematch'
           ,@BetradarOddsTypeId
           ,@BetradarOddsSubTypeId
           ,@SpecialBetValue
           ,@Outcome
           ,@BetradarMatchId
           ,@OddValue
           ,@Bank
           ,0
           ,@OddId
           ,@Amount
           ,@StateId
           ,@BetType
           ,@MatchId
           ,@ParameterOddId
           ,@EventName
           ,@EventDate
           ,@CurrencyId)




end
else if(@BetType=1)
begin

select @Outcome= OutCome, @OddsTypeId=OddsTypeId,@SpecialBetValue=SpecialBetValue,@ParameterOddId=ParameterOddId
From Live.EventOdd where Live.EventOdd.MatchId=@MatchId and Live.EventOdd.OddId=@OddId

select @BetradarOddsTypeId=Live.[Parameter.OddType].BetradarOddsTypeId,@BetradarOddsSubTypeId=Live.[Parameter.OddType].BetradarOddsSubTypeId from Live.[Parameter.OddType] where Live.[Parameter.OddType].OddTypeId=@OddsTypeId
select @BetradarMatchId=Live.[Event].BetradarMatchId from Live.[Event] where Live.[Event].EventId=@MatchId


INSERT INTO [MTS].[Selection]
           ([TicketId]
           ,[line]
           ,[BetradarOddsTypeId]
           ,[BetradarOddsSubTypeId]
           ,[SpecialBetValue]
           ,[Outcome]
           ,[BetradarMatchId]
           ,[OddValue]
           ,[bank]
           ,[ways]
           ,[OddId]
           ,[Amount]
           ,[StateId]
           ,[BetTypeId]
           ,[MatchId]
           ,[ParameterOddId]
           ,[EventName]
           ,[EventDate]
           ,[CurrencyId])
     VALUES
           (@TicketId
           ,'live'
           ,@BetradarOddsTypeId
           ,@BetradarOddsSubTypeId
           ,@SpecialBetValue
           ,@Outcome
           ,@BetradarMatchId
           ,@OddValue
           ,@Bank
           ,0
           ,@OddId
           ,@Amount
           ,@StateId
           ,@BetType
           ,@MatchId
           ,@ParameterOddId
           ,@EventName
           ,@EventDate
           ,@CurrencyId)


end
else if(@BetType=2)
begin

select @Outcome= Outrights.Odd.CompetitorId, @OddsTypeId=Outrights.Odd.OddsTypeId,
@SpecialBetValue=Outrights.Odd.SpecialBetValue,@ParameterOddId=Outrights.Odd.ParameterOddId
from Outrights.Odd 
where Outrights.Odd.MatchId=@MatchId and Outrights.Odd.OddId=@OddId

select @BetradarOddsTypeId=Parameter.OddsType.BetradarOddsTypeId from Parameter.OddsType where Parameter.OddsType.OddsTypeId=@OddsTypeId
select @BetradarMatchId=Outrights.[Event].EventBetradarId,@BetradarOddsSubTypeId=Parameter.Sport.BetRadarSportId
from Outrights.[Event] INNER JOIN 
[Parameter].[TournamentOutrights] ON [Parameter].[TournamentOutrights].TournamentId=Outrights.[Event].TournamentId  INNER JOIN
Parameter.Category ON Parameter.Category.CategoryId=[Parameter].[TournamentOutrights].CategoryId INNER JOIN 
Parameter.Sport On Parameter.Sport.SportId=Parameter.Category.SportId
where Outrights.[Event].EventId=@MatchId 

SELECT @Outcome=[CompetitorBetradarId]
  FROM [Outrights].[Competitor] 
  where [Outrights].[Competitor].CompetitorId=@Outcome and [Outrights].[Competitor].EventId=@MatchId


INSERT INTO [MTS].[Selection]
           ([TicketId]
           ,[line]
           ,[BetradarOddsTypeId]
           ,[BetradarOddsSubTypeId]
           ,[SpecialBetValue]
           ,[Outcome]
           ,[BetradarMatchId]
           ,[OddValue]
           ,[bank]
           ,[ways]
           ,[OddId]
           ,[Amount]
           ,[StateId]
           ,[BetTypeId]
           ,[MatchId]
           ,[ParameterOddId]
           ,[EventName]
           ,[EventDate]
           ,[CurrencyId])
     VALUES
           (@TicketId
           ,'prematch'
           ,@BetradarOddsTypeId
           ,@BetradarOddsSubTypeId
           ,@SpecialBetValue
           ,@Outcome
           ,@BetradarMatchId
           ,@OddValue
           ,@Bank
           ,0
           ,@OddId
           ,@Amount
           ,@StateId
           ,@BetType
           ,@MatchId
           ,@ParameterOddId
           ,@EventName
           ,@EventDate
           ,@CurrencyId)

end
else if(@BetType=3)
begin
--insert Customer.SlipOdd(SlipId,OddId,OddValue,Amount,StateId,BetTypeId,OutCome,MatchId,OddsTypeId,SpecialBetValue,ParameterOddId,EventName,EventDate,CurrencyId)
--select @SlipId,@OddId,@OddValue,@Amount,@StateId,@BetType,
--Virtual.EventOdd.OutCome,@MatchId,Virtual.EventOdd.OddsTypeId,
--Virtual.EventOdd.SpecialBetValue,Virtual.EventOdd.ParameterOddId,@EventName,@EventDate,@CurrencyId
--from Virtual.EventOdd where Virtual.EventOdd.MatchId=@MatchId and Virtual.EventOdd.OddId=@OddId
select 0
end


set @SlipOddId=SCOPE_IDENTITY()


	return @SlipOddId


GO
