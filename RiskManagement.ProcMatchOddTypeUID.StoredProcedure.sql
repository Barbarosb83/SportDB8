USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcMatchOddTypeUID]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcMatchOddTypeUID]
@OddtypeId int,
@StateId int,
@Limit money,
@LimitPerTicket money,
@StakeLimit money,
@Availabity nvarchar(20),
@MinCombiBranch int,
@MinCombiInternet int,
@MinCombiMachine int,
@IsPopular bit,
@MatchId bigint,
@LangId int,
@username nvarchar(max),
@ActivityCode int,
@NewValues nvarchar(max)


AS

declare @OldValues nvarchar(max)
declare @resultcode int=106
declare @resultmessage nvarchar(max)='Hata oluştu'
declare @AvailabityId int=0
declare @OddtypeSettingId bigint

BEGIN
SET NOCOUNT ON;

select @AvailabityId=Parameter.MatchAvailability.AvailabilityId from Parameter.MatchAvailability
where Parameter.MatchAvailability.Availability=@Availabity

select @OddtypeSettingId=Match.OddTypeSetting.OddTypeSettingId from Match.OddTypeSetting
where Match.OddTypeSetting.OddTypeId=@OddtypeId and MatchId=@MatchId




select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId





if(@ActivityCode=1)
	begin
	
	exec [Log].ProcConcatOldValues  'OddTypeSetting','[Match]','OddTypeSettingId',@OddTypeSettingId,@OldValues output
	
	exec [Log].[ProcTransactionLogUID] 3,@ActivityCode,@Username,@OddTypeSettingId,'Match.OddTypeSetting'
	,@NewValues,@OldValues
	

	
	update Match.OddTypeSetting set
	LossLimit=@Limit,
	StateId=@StateId,
	LimitPerTicket=@LimitPerTicket,
	AvailabilityId=@AvailabityId,
	MinCombiBranch=@MinCombiBranch,
	MinCombiInternet=@MinCombiInternet,
	MinCombiMachine=@MinCombiMachine,
	StakeLimit=@StakeLimit
	--IsPopular=@IsPopular
	where OddTypeSettingId=@OddtypeSettingId
	
	--	update Match.OddSetting set
	--LossLimit=@Limit,
	--StateId=@StateId,
	--LimitPerTicket=@LimitPerTicket,
	--AvailabilityId=@AvailabityId,
	--MinCombiBranch=@MinCombiBranch,
	--MinCombiInternet=@MinCombiInternet,
	--MinCombiMachine=@MinCombiMachine,
	--StakeLimit=@StakeLimit
	--where OddId in (select  Match.Odd.OddId from Match.Odd where Match.Odd.MatchId=@matchId and Match.Odd.OddsTypeId=@OddTypeId)
	

			select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId

	end



	select @resultcode as resultcode,@resultmessage as resultmessage




END


GO
