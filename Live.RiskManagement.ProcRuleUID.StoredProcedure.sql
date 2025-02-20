USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Live].[RiskManagement.ProcRuleUID]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Live].[RiskManagement.ProcRuleUID]
@RuleId bigint,
@SportId bigint,
@CategoryId bigint,
@TournamentId bigint,
@CompetitorId bigint,
@StateId int,
@LossLimit money,
@LimitPerTicket money,
@StakeLimit money,
@Availabity nvarchar(20),
@MinCombiBranch int,
@MinCombiInternet int,
@MinCombiMachine int,
@StarDate datetime,
@StopDate datetime,
@IsActive bit,
@IsPopular bit,
@MaxGainTicket money,
@Comment nvarchar(450),
@IsCurrentData bit,
@LangId int,	
@username nvarchar(max),
@ActivityCode int,
@NewValues nvarchar(max)


AS

declare @OldValues nvarchar(max)
declare @resultcode int=106
declare @resultmessage nvarchar(max)='Hata oluştu'
declare @AvailabityId int

BEGIN
SET NOCOUNT ON;

select @AvailabityId=Parameter.MatchAvailability.AvailabilityId from Parameter.MatchAvailability
where Parameter.MatchAvailability.Availability=@Availabity

select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId




if(@ActivityCode=1)
	begin
	
	exec [Log].ProcConcatOldValues 'RiskManagement.Rule','[Live]','RuleId',@RuleId,@OldValues output
	
	exec [Log].[ProcTransactionLogUID] 8,@ActivityCode,@Username,@RuleId,'Live.[RiskManagement.Rule]'
	,@NewValues,@OldValues
	
	
	
	update Live.[RiskManagement.Rule] set
	SportId=@SportId,
	CategoryId=@CategoryId,
	TournamentId=@TournamentId,
	CompetitorId=@CompetitorId,
	StateId=@StateId,
	LossLimit=@LossLimit,
	StakeLimit=@StakeLimit,
	LimitPerTicket=@LimitPerTicket,
	AvailabilityId=@AvailabityId,
	MinCombiBranch=@MinCombiBranch,
	MinCombiInternet=@MinCombiInternet,
	MinCombiMachine=@MinCombiMachine,
	StarDate=@StarDate,
	StopDate=@StopDate,
	IsActive=@IsActive,
	Comment=@Comment,
	MaxGainTicket=@MaxGainTicket,
	IsPopular=@IsPopular
	where RuleId=@RuleId
	
	update Live.[RiskManagement.RuleOddType] set
		StateId=@StateId,
	LossLimit=@LossLimit,
	StakeLimit=@StakeLimit,
	LimitPerTicket=@LimitPerTicket,
	AvailabilityId=@AvailabityId,
	MinCombiBranch=@MinCombiBranch,
	MinCombiInternet=@MinCombiInternet,
	MinCombiMachine=@MinCombiMachine,
	Comment=@Comment,
	MaxGainTicket=@MaxGainTicket
	where RuleId=@RuleId
	
	if(@IsCurrentData=1)
		begin
			 if(@TournamentId<>-1)
			 begin
			update Live.EventSetting set LossLimit=@LossLimit,
			StakeLimit=@StakeLimit,
			LimitPerTicket=@LimitPerTicket,
			AvailabilityId=@AvailabityId,
			MinCombiBranch=@MinCombiBranch,
			MinCombiInternet=@MinCombiInternet,
			MinCombiMachine=@MinCombiMachine,
			IsPopular=@IsPopular
			,StateId=@StateId
			where MatchId in (select Live.Event.EventId from Live.Event 
			where Live.Event.TournamentId in (select TournamentId from Parameter.Tournament where NewBetradarId in
			 (select NewBetradarId from Parameter.Tournament where TournamentId=@TournamentId and CategoryId=@CategoryId)))
			end
			else if (@CategoryId<>-1)
			begin
				update Live.EventSetting set LossLimit=@LossLimit,
			StakeLimit=@StakeLimit,
			LimitPerTicket=@LimitPerTicket,
			AvailabilityId=@AvailabityId,
			MinCombiBranch=@MinCombiBranch,
			MinCombiInternet=@MinCombiInternet,
			MinCombiMachine=@MinCombiMachine,
			IsPopular=@IsPopular,
			StateId=@StateId
			where MatchId  in (select Live.Event.EventId from Live.Event where Live.Event.TournamentId in (select Parameter.Tournament.TournamentId from Parameter.Tournament where Parameter.Tournament.CategoryId=@CategoryId))

			--	update [Match].[OddTypeSetting] set LossLimit=@LossLimit,
			--StakeLimit=@StakeLimit,
			--LimitPerTicket=@LimitPerTicket,
			--AvailabilityId=@AvailabityId,
			--MinCombiBranch=@MinCombiBranch,
			--MinCombiInternet=@MinCombiInternet,
			--MinCombiMachine=@MinCombiMachine,
			--IsPopular=@IsPopular
			--	,StateId=@StateId
			--where MatchId in (select Match.Match.MatchId from Match.Match where Match.Match.TournamentId in (select Parameter.Tournament.TournamentId from Parameter.Tournament where Parameter.Tournament.CategoryId=@CategoryId))

			--update [Match].[OddSetting] set LossLimit=@LossLimit,
			--StakeLimit=@StakeLimit,
			--LimitPerTicket=@LimitPerTicket,
			--AvailabilityId=@AvailabityId,
			--MinCombiBranch=@MinCombiBranch,
			--MinCombiInternet=@MinCombiInternet,
			--MinCombiMachine=@MinCombiMachine
			--	,StateId=@StateId
			--where OddId in (select OddId from Match.Odd where Match.Odd.MatchId in (select Match.Match.MatchId from Match.Match where Match.Match.TournamentId in (select Parameter.Tournament.TournamentId from Parameter.Tournament where Parameter.Tournament.CategoryId=@CategoryId)))


			end
			else if (@SportId<>-1)
			begin
					update Live.EventSetting set LossLimit=@LossLimit,
			StakeLimit=@StakeLimit,
			LimitPerTicket=@LimitPerTicket,
			AvailabilityId=@AvailabityId,
			MinCombiBranch=@MinCombiBranch,
			MinCombiInternet=@MinCombiInternet,
			MinCombiMachine=@MinCombiMachine,
			IsPopular=@IsPopular,
			StateId=@StateId
			where MatchId  in (select Live.Event.EventId from Live.Event where Live.Event.TournamentId in (select Parameter.Tournament.TournamentId from Parameter.Tournament where Parameter.Tournament.CategoryId in (select CategoryId from Parameter.Category where SportId=@SportId)))

		 
			--update [Match].[OddSetting] set LossLimit=@LossLimit,
			--StakeLimit=@StakeLimit,
			--LimitPerTicket=@LimitPerTicket,
			--AvailabilityId=@AvailabityId,
			--MinCombiBranch=@MinCombiBranch,
			--MinCombiInternet=@MinCombiInternet,
			--MinCombiMachine=@MinCombiMachine
			--	,StateId=@StateId
			--where OddId in (select OddId from Match.Odd where Match.Odd.MatchId in (select Match.Match.MatchId from Match.Match where Match.Match.TournamentId in (select Parameter.Tournament.TournamentId from Parameter.Tournament where Parameter.Tournament.CategoryId=@CategoryId)))


			end
		end
			

			select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId

	end
	
	else if(@ActivityCode=2)
	begin
	
	if(select COUNT(*) from Live.[RiskManagement.Rule] where SportId=@SportId and CategoryId=@CategoryId and TournamentId=@TournamentId and CompetitorId=@CompetitorId)=0
	begin
			exec [Log].[ProcTransactionLogUID] 8,@ActivityCode,@Username,@RuleId,'Live.[RiskManagement.Rule]'
	,@NewValues,null
	
	insert Live.[RiskManagement.Rule] (SportId,CategoryId,TournamentId,CompetitorId,StateId,LossLimit,LimitPerTicket,StakeLimit,AvailabilityId,MinCombiBranch,MinCombiInternet,MinCombiMachine,StarDate,StopDate,IsActive,Comment,IsPopular,MaxGainTicket)
	values(@SportId,@CategoryId,@TournamentId,@CompetitorId,@StateId,@LossLimit,@LimitPerTicket,@StakeLimit,@AvailabityId,@MinCombiBranch,@MinCombiInternet,@MinCombiMachine,@StarDate,@StopDate,@IsActive,@Comment,@IsPopular,@MaxGainTicket)
			set @RuleId=SCOPE_IDENTITY()
	--if(@SportId<>-1)
	--	begin
	--	insert Live.[RiskManagement.RuleOddType](RuleId,OddTypeId,StateId,LossLimit,LimitPerTicket,StakeLimit,AvailabilityId,MinCombiBranch,MinCombiInternet,MinCombiMachine,IsPopular,MaxGainTicket)
	--	select @RuleId,Live.[Parameter.OddType].OddTypeId,@StateId,@LossLimit,@LimitPerTicket,@StakeLimit,@AvailabityId,@MinCombiBranch,@MinCombiInternet,@MinCombiMachine,0,@MaxGainTicket
	--	from Live.[Parameter.OddType]
	
	----if(@IsCurrentData=1)
	----	begin
	----		if(@TournamentId<>-1)
	----		update Live.EventSetting set LossLimit=@LossLimit,
	----		StakeLimit=@StakeLimit,
	----		LimitPerTicket=@LimitPerTicket,
	----		AvailabilityId=@AvailabityId,
	----		MinCombiBranch=@MinCombiBranch,
	----		MinCombiInternet=@MinCombiInternet,
	----		MinCombiMachine=@MinCombiMachine,
	----		IsPopular=@IsPopular
	----		where MatchId in (select Live.Event.EventId from Live.Event where Live.Event.TournamentId=@TournamentId)
	----	end
	
	--	end
	--else
	--	begin
			insert Live.[RiskManagement.RuleOddType](RuleId,OddTypeId,StateId,LossLimit,LimitPerTicket,StakeLimit,AvailabilityId,MinCombiBranch,MinCombiInternet,MinCombiMachine,IsPopular,MaxGainTicket)
			select @RuleId,Live.[Parameter.OddType].OddTypeId,@StateId,@LossLimit,@LimitPerTicket,@StakeLimit,@AvailabityId,@MinCombiBranch,@MinCombiInternet,@MinCombiMachine,0,@MaxGainTicket
			from Live.[Parameter.OddType]
		
	--	end

	
			select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=104 and Log.ErrorCodes.LangId=@LangId
	end
	else
		select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=124 and Log.ErrorCodes.LangId=@LangId
	end
	
	else if(@ActivityCode=3)
	begin
	

	exec [Log].ProcConcatOldValues   'Rule','[RiskManagement]','RuleId',@RuleId,@OldValues output
	
	exec [Log].[ProcTransactionLogUID] 8,@ActivityCode,@Username,@RuleId,'RiskManagement.Rule'
	,@NewValues,@OldValues
	
	if(@RuleId<>1)
	begin
	delete from Live.[RiskManagement.RuleOddType] where RuleId=@RuleId
	delete from Live.[RiskManagement.Rule] where RuleId=@RuleId
	end
			select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=105 and Log.ErrorCodes.LangId=@LangId

	end



	select @resultcode as resultcode,@resultmessage as resultmessage




END


GO
