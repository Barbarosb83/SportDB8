USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcOddTypeUID]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcOddTypeUID]
@OddsTypeId int,
@OddsType nvarchar(250),
@OutcomesDescription nvarchar(250),
@Availabity nvarchar(20),
@IsActive bit,
@ShortSign nvarchar(20),
@IsPopular bit,
@SeqNumber int,
@LangId int,
@username nvarchar(max),
@ActivityCode int,
@NewValues nvarchar(max)
AS



BEGIN
SET NOCOUNT ON;

declare @OldValues nvarchar(max)
declare @resultcode int=106
declare @resultmessage nvarchar(max)='Hata oluştu'
declare @AvailabityId int

select @AvailabityId=Parameter.MatchAvailability.AvailabilityId from Parameter.MatchAvailability
where Parameter.MatchAvailability.Availability=@Availabity

select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId


if @ActivityCode=1
	begin
		exec [Log].ProcConcatOldValues    'OddsType','[Parameter]','OddsTypeId',@OddsTypeId,@OldValues output
	
	exec [Log].[ProcTransactionLogUID] 10,@ActivityCode,@Username,@OddsTypeId,'Parameter.OddsType'
	,@NewValues,@OldValues
	
	update Parameter.OddsType set
	OddsType=@OddsType,
	OutcomesDescription=@OutcomesDescription,
	AvailabilityId=@AvailabityId,
	IsActive=@IsActive,
	ShortSign=@ShortSign,
	IsPopular= @IsPopular,
	SeqNumber=@SeqNumber
	where OddsTypeId=@OddsTypeId
	
	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId
	
	
	end


	select @resultcode as resultcode,@resultmessage as resultmessage


END


GO
