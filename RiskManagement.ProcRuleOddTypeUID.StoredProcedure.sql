USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcRuleOddTypeUID]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcRuleOddTypeUID]
@RuleOddTypeId bigint,
@RuleId bigint,
@OddTypeId bigint,
@StateId int,
@LossLimit money,
@LimitPerTicket money,
@StakeLimit money,
@Availabity nvarchar(20),
@MinCombiBranch int,
@MinCombiInternet int,
@MinCombiMachine int,
@Comment nvarchar(450),
@IsPopular bit,
@MaxGainTicket money,
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
	
	exec [Log].ProcConcatOldValues   'RuleOddType','[RiskManagement]','RuleOddTypeId',@RuleOddTypeId,@OldValues output
	
	exec [Log].[ProcTransactionLogUID] 9,@ActivityCode,@Username,@RuleOddTypeId,'RiskManagement.RuleOddType'
	,@NewValues,@OldValues
	
	
	
	update [RiskManagement].[RuleOddType] set
	StateId=@StateId,
	LossLimit=@LossLimit,
	StakeLimit=@StakeLimit,
	LimitPerTicket=@LimitPerTicket,
	AvailabilityId=@AvailabityId,
	MinCombiBranch=@MinCombiBranch,
	MinCombiInternet=@MinCombiInternet,
	MinCombiMachine=@MinCombiMachine,
	Comment=@Comment,
	IsPopular=@IsPopular,
	MaxGainTicket=@MaxGainTicket
	where RuleOddTypeId=@RuleOddTypeId

			select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId

	end
	
	else if(@ActivityCode=2)
	begin
	

		exec [Log].[ProcTransactionLogUID] 9,@ActivityCode,@Username,@RuleOddTypeId,'RiskManagement.RuleOddType'
	,@NewValues,null
	
	insert [RiskManagement].[RuleOddType] (RuleId,OddTypeId,StateId,LossLimit,LimitPerTicket,StakeLimit,AvailabilityId,MinCombiBranch,MinCombiInternet,MinCombiMachine,Comment,IsPopular,MaxGainTicket)
	values(@RuleId,@OddTypeId,@StateId,@LossLimit,@LimitPerTicket,@StakeLimit,@AvailabityId,@MinCombiBranch,@MinCombiInternet,@MinCombiMachine,@Comment,@IsPopular,@MaxGainTicket)
		
	
	
			select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=104 and Log.ErrorCodes.LangId=@LangId

	end
	
	else if(@ActivityCode=3)
	begin
	

	--exec [Log].ProcConcatOldValues   'Rule','[RiskManagement]','RuleId',@RuleId,@OldValues output
	
	--exec [Log].[ProcTransactionLogUID] 8,@ActivityCode,@Username,@RuleId,'RiskManagement.Rule'
	--,@NewValues,@OldValues
	
	
	--delete from [RiskManagement].[RuleOddType] where RuleId=@RuleId
	--delete from [RiskManagement].[Rule] where RuleId=@RuleId
	
			select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=105 and Log.ErrorCodes.LangId=@LangId

	end



	select @resultcode as resultcode,@resultmessage as resultmessage




END


GO
