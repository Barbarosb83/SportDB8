USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcGeneralSettingUID]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcGeneralSettingUID]
@CompanyName nvarchar(100),
@MaxDayPeriod int,
@MaxCopySlip int,
@UseSameAmountPerSystemCombi bit,
@EmailSMTP nvarchar(50),
@EmailAccount nvarchar(50),
@EmailPort int,
@EmailPassword nvarchar(50),
@MaxWinningLimit money,
@LangId int,
@username nvarchar(max),
@ActivityCode int,
@NewValues nvarchar(max)
AS

declare @OldValues nvarchar(max)
declare @resultcode int=113
declare @resultmessage nvarchar(max)='Hata oluştu'
declare @AvailabityId int=0
declare @matchId bigint
declare @OddTypeId bigint

BEGIN
SET NOCOUNT ON;

select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId





if(@ActivityCode=1)
	begin
	
	exec [Log].ProcConcatOldValues  'Setting','[General]','SettingId',1,@OldValues output
	
	exec [Log].[ProcTransactionLogUID] 3,@ActivityCode,@Username,1,'Match.OddTypeSetting'
	,@NewValues,@OldValues
	

	
	UPDATE [General].[Setting]
   SET [CompanyName] = @CompanyName
      ,[MaxDayPeriod] = @MaxDayPeriod
      ,[MaxCopySlip] = @MaxCopySlip
      ,[UseSameAmountPerSystemCombi] = @UseSameAmountPerSystemCombi
      ,[EmailSMTP] = @EmailSMTP
      ,[EmailAccount] = @EmailAccount
      ,[EmailPort] = @EmailPort
      ,[EmailPassword] = @EmailPassword
      ,[MaxWinningLimit] =@MaxWinningLimit
 WHERE [SettingId]=1




			select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId

	end



	select @resultcode as resultcode,@resultmessage as resultmessage




END


GO
