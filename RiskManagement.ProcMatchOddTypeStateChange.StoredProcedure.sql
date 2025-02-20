USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcMatchOddTypeStateChange]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcMatchOddTypeStateChange]
@OddtypeId int,
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



BEGIN
SET NOCOUNT ON;

declare @OddtypeSettingId bigint

select @OddtypeSettingId=Match.OddTypeSetting.OddTypeSettingId from Match.OddTypeSetting
where Match.OddTypeSetting.OddTypeId=@OddtypeId and MatchId=@MatchId


select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId


	
	exec [Log].ProcConcatOldValues  'OddTypeSetting','[Match]','OddTypeSettingId',@OddTypeSettingId,@OldValues output
	
	exec [Log].[ProcTransactionLogUID] 5,@ActivityCode,@Username,@OddTypeSettingId,'Match.OddTypeSetting'
	,@NewValues,@OldValues
	

	
	update Match.OddTypeSetting set
	StateId=@ActivityCode
	where OddTypeSettingId=@OddtypeSettingId
	
	
	update Match.Odd set StateId=@ActivityCode 
	where MatchId=@MatchId and OddsTypeId=@OddtypeId
	
	--update Match.OddSetting set
	--Match.OddSetting.StateId=@ActivityCode
	--where Match.OddSetting.OddId in (select Match.Odd.OddId from Match.Odd where Match.Odd.OddsTypeId=@OddtypeId and Match.Odd.MatchId=@MatchId)

			select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId





	select @resultcode as resultcode,@resultmessage as resultmessage




END


GO
