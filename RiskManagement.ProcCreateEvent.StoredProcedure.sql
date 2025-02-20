USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCreateEvent]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [RiskManagement].[ProcCreateEvent] 
@SportId int,
@TournamentId int,
@Comment nvarchar(250),
@HomeTeamId int,
@AwayTeamId int,
@MatchDate datetime,
@StateId int,
@LossLimit money,
@LimitPerTicket money,
@StakeLimit money,
@Availability nvarchar(10),
@MinCombiBranch int,
@MinCombiInternet int,
@MinCombiMachine int,
@IsPopular bit,
@LangId int,
@UserName nvarchar(50),
@NewValues nvarchar(max)
AS

BEGIN
SET NOCOUNT ON;


declare @resultcode int=106
declare @resultmessage nvarchar(max)='Hata oluştu'
declare @MatchId bigint
declare @FixtureId bigint
declare @AvailabilityId int

select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId




select @AvailabilityId=Parameter.MatchAvailability.AvailabilityId from Parameter.MatchAvailability
where Parameter.MatchAvailability.Availability=@Availability

insert Match.Match(TournamentId,BetradarMatchId,MonitoringMatchId)
values (@TournamentId,-1,-1)

set @MatchId=SCOPE_IDENTITY()

exec [Log].[ProcTransactionLogUID] 6,2,@Username,@MatchId,'Match.Match'
		,@NewValues,null

insert Match.Fixture(MatchId,Latitude,Longitude,HasStatistics,NeutralGround,LiveMultiCast,LiveScore,StatusInfoId,CupRoundId,VenueId)
values (@MatchId,0,0,0,1,0,0,0,0,137)

set @FixtureId=SCOPE_IDENTITY()


insert Match.FixtureCompetitor(FixtureId,CompetitorId,TypeId)
values(@FixtureId,@HomeTeamId,1)

insert Match.FixtureCompetitor(FixtureId,CompetitorId,TypeId)
values(@FixtureId,@AwayTeamId,2)

insert Match.FixtureDateInfo(FixtureId,DateInfoTypeId,Comment,MatchDate,LanguageId)
values(@FixtureId,1,@Comment,@MatchDate,1)

insert Match.Setting(MatchId,StateId,LossLimit,LimitPerTicket,StakeLimit,AvailabilityId,MinCombiBranch,MinCombiInternet,MinCombiMachine,IsPopular)
values(@MatchId,@StateId,@LossLimit,@LimitPerTicket,@StakeLimit,@AvailabilityId,@MinCombiBranch,@MinCombiInternet,@MinCombiMachine,@IsPopular)

insert Match.Odd(OddsTypeId,OutCome,OutComeId,SpecialBetValue,OddValue,MatchId,BettradarOddId,Suggestion,ParameterOddId,StateId)
select Parameter.Odds.OddTypeId,Parameter.Odds.Outcomes,0,Parameter.Odds.SpecialBetValue,0,@MatchId,0,0,Parameter.Odds.OddsId,2
FROM         Parameter.Odds INNER JOIN
                      Parameter.OddsType ON Parameter.Odds.OddTypeId = Parameter.OddsType.OddsTypeId
where (Parameter.OddsType.SportId=@SportId OR Parameter.OddsType.SportId=30)

insert Match.OddTypeSetting(OddTypeId,StateId,LossLimit,LimitPerTicket,StakeLimit,AvailabilityId,MinCombiBranch,MinCombiInternet,MinCombiMachine,MatchId)
select distinct OddsTypeId,1,@LossLimit,@LimitPerTicket,@StakeLimit,@AvailabilityId,@MinCombiBranch,@MinCombiInternet,@MinCombiMachine,@MatchId
from Match.Odd
where MatchId=@MatchId

--insert Match.OddSetting(OddId,StateId,LossLimit,LimitPerTicket,StakeLimit,AvailabilityId,MinCombiBranch,MinCombiInternet,MinCombiMachine)
--select Match.Odd.OddId,1,@LossLimit,@LimitPerTicket,@StakeLimit,@AvailabilityId,@MinCombiBranch,@MinCombiInternet,@MinCombiMachine
--from Match.Odd
--where MatchId=@MatchId

			select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=104 and Log.ErrorCodes.LangId=@LangId

select @resultcode as resultcode,@resultmessage as resultmessage


END


GO
