USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Virtual].[RiskManagement.ProcEventSettingUID]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Virtual].[RiskManagement.ProcEventSettingUID]
	@EventId bigint,
	@StateId int,
    @LossLimit money,
    @LimitPerTicket money,
    @StakeLimit money,
    @Availability nvarchar(20),
    @MaxGainLimit money,
@username nvarchar(max),
@langId int,
@ActivityCode int,
@NewValues nvarchar(max)


AS

declare @OldValues nvarchar(max)
declare @resultcode int=106
declare @resultmessage nvarchar(max)='Hata oluştu'
declare @settingId int


BEGIN
SET NOCOUNT ON;


select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@langId

--exec [Log].ProcConcatOldValues  'EventSetting','[Virtual]','SettingId',@settingId,@OldValues output
	
--	exec [Log].[ProcTransactionLogUID] 2,@ActivityCode,@Username,@settingId,'Virtual.EventSetting'
	--,@NewValues,@OldValues
	
declare @AvailabilityId int=0
select @AvailabilityId=Parameter.MatchAvailability.AvailabilityId from Parameter.MatchAvailability
where Parameter.MatchAvailability.Availability=@Availability

UPDATE [Virtual].[EventSetting]
   SET [StateId] = @StateId
      ,[LossLimit] = @LossLimit
      ,[LimitPerTicket] = @LimitPerTicket
      ,[StakeLimit] = @StakeLimit
      ,[AvailabilityId] = @AvailabilityId
      ,[MaxGainLimit] = @MaxGainLimit
   Where Virtual.EventSetting.MatchId=@EventId
   
	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@langId

	


	select @resultcode as resultcode,@resultmessage as resultmessage




END


GO
