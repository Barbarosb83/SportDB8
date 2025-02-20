USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcMatchOddUID]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcMatchOddUID]
@OddId int,
@OddValue float,
@StateId int,
@Limit money,
@LimitPerTicket money,
@StakeLimit money,
@Availabity nvarchar(20),
@MinCombiBranch int,
@MinCombiInternet int,
@MinCombiMachine int,
@IsOddValueLock bit,
@LangId int,
@username nvarchar(max),
@ActivityCode int,
@NewValues nvarchar(max)


AS

declare @OldValues nvarchar(max)
declare @resultcode int=106
declare @resultmessage nvarchar(max)='Hata oluştu'
declare @AvailabityId int=0
declare @oddSettingId int


BEGIN
SET NOCOUNT ON;

--select @AvailabityId=Parameter.MatchAvailability.AvailabilityId from Parameter.MatchAvailability
--where Parameter.MatchAvailability.Availability=@Availabity

--select @oddSettingId=Match.OddSetting.OddSettingId
--from Match.OddSetting
--where Match.OddSetting.OddId=@OddId

select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId

declare @FixtureId int



if(@ActivityCode=1)
	begin
	
	--exec [Log].ProcConcatOldValues  'OddSetting','[Archive]','OddSettingId',@oddSettingId,@OldValues output
	
	--exec [Log].[ProcTransactionLogUID] 4,@ActivityCode,@Username,@oddSettingId,'Archive.OddSettingId'
	--,@NewValues,@OldValues
	

	
	--update Match.OddSetting set
	--LossLimit=@Limit,
	--StateId=@StateId,
	--LimitPerTicket=@LimitPerTicket,
	--AvailabilityId=@AvailabityId,
	--MinCombiBranch=@MinCombiBranch,
	--MinCombiInternet=@MinCombiInternet,
	--MinCombiMachine=@MinCombiMachine,
	--StakeLimit=@StakeLimit
	--where OddSettingId=@oddSettingId
	
	update Match.Odd set
	OddValue=@OddValue
	,IsOddValueLock=@IsOddValueLock
	,StateId=@StateId
	where Match.Odd.OddId=@OddId
	
	

			select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId

	end



	select @resultcode as resultcode,@resultmessage as resultmessage




END


GO
