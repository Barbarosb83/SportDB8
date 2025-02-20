USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcGameDataUID]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcGameDataUID]
@MatchId int,
@HometeamId int,
@AwayTeamId int,
@StartDate datetime,
@StateId int,
@Limit money,
@LimitPerTicket money,
@StakeLimit money,
@Availabity nvarchar(20),
@VenueId int,
@MinCombiBranch int,
@MinCombiInternet int,
@MinCombiMachine int,
@IsPopular bit,
@LangId int,
@username nvarchar(max),
@ActivityCode int,
@NewValues nvarchar(max)


AS

declare @OldValues nvarchar(max)
declare @resultcode int=106
declare @resultmessage nvarchar(max)='Hata oluştu'
declare @AvailabityId int=0



BEGIN
SET NOCOUNT ON;

select @AvailabityId=Parameter.MatchAvailability.AvailabilityId from Parameter.MatchAvailability
where Parameter.MatchAvailability.Availability=@Availabity

select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes with (nolock)  where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId

declare @FixtureId int

select @FixtureId=Match.Fixture.FixtureId from Match.Fixture with (nolock) 
where Match.Fixture.MatchId=@MatchId


if(@ActivityCode=1)
	begin
	
	exec [Log].ProcConcatOldValues  'Fixture','[Match]','FixtureId',@FixtureId,@OldValues output
	
	exec [Log].[ProcTransactionLogUID] 1,@ActivityCode,@Username,@FixtureId,'Match.Fixture'
	,@NewValues,@OldValues
	
	update Match.FixtureCompetitor set 
	CompetitorId=@HometeamId
	where FixtureId=@FixtureId and TypeId=1
	
	update Match.FixtureCompetitor set 
	CompetitorId=@AwayTeamId
	where FixtureId=@FixtureId and TypeId=2

	update Match.FixtureDateInfo set
	MatchDate=dbo.UserTimeZoneDate(@Username,@StartDate,1)
	where FixtureId=@FixtureId
	
	--update Match.Fixture set
	--VenueId=@VenueId
	--where FixtureId=@FixtureId
	
	update Match.Setting set
	StateId=@StateId,
	LossLimit=@Limit,
	StakeLimit=@StakeLimit,
	LimitPerTicket=@LimitPerTicket,
	AvailabilityId=@AvailabityId,
	MinCombiBranch=@MinCombiBranch,
	MinCombiInternet=@MinCombiInternet,
	MinCombiMachine=@MinCombiMachine,
	IsPopular=@IsPopular
	where MatchId=@MatchId
	
	update Match.OddTypeSetting set
	LossLimit=@Limit,
	LimitPerTicket=@LimitPerTicket,
	AvailabilityId=@AvailabityId,
	MinCombiBranch=@MinCombiBranch,
	MinCombiInternet=@MinCombiInternet,
	MinCombiMachine=@MinCombiMachine
	where MatchId=@MatchId
	
	--update Match.OddSetting set
	--LossLimit=@Limit,
	--LimitPerTicket=@LimitPerTicket,
	--AvailabilityId=@AvailabityId,
	--MinCombiBranch=@MinCombiBranch,
	--MinCombiInternet=@MinCombiInternet,
	--MinCombiMachine=@MinCombiMachine
	--where Match.OddSetting.OddId in (select Match.Odd.OddId from Match.Odd where Match.Odd.MatchId=@MatchId)
		
			select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId

	end



	select @resultcode as resultcode,@resultmessage as resultmessage




END


GO
