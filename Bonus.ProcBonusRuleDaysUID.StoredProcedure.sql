USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Bonus].[ProcBonusRuleDaysUID]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Bonus].[ProcBonusRuleDaysUID]
@BonusRuleId int,
@ParameterDayId int,
@LangId int,
@username nvarchar(max),
@ActivityCode int,
@NewValues nvarchar(max)


AS

declare @OldValues nvarchar(max)
declare @resultcode int=106
declare @resultmessage nvarchar(max)='Hata oluştu'


BEGIN
SET NOCOUNT ON;



select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId




if(@ActivityCode=1)
	begin
	

	
		if(select COUNT(*) from  [Bonus].[RuleDays]   where RuleId=@BonusRuleId and ParameterDayId=@ParameterDayId)=0
			insert Bonus.RuleDays(RuleId,ParameterDayId)
					values (@BonusRuleId,@ParameterDayId)
	
			select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId

	end
	
	else if(@ActivityCode=2)
	begin
	
			exec [Log].[ProcTransactionLogUID] 26,@ActivityCode,@Username,@BonusRuleId,'Bonus.RuleDays'
	,@NewValues,null
	
	insert Bonus.RuleDays(RuleId,ParameterDayId)
		values (@BonusRuleId,@ParameterDayId)
		
	
	
	

	
			select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=104 and Log.ErrorCodes.LangId=@LangId
	End
	else if(@ActivityCode=4)
	begin
			delete from Bonus.RuleDays where  RuleDaysId=@ParameterDayId
			
			select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=105 and Log.ErrorCodes.LangId=@LangId
	end
	else
	begin
			delete from Bonus.RuleDays where RuleId=@BonusRuleId
	end
	




	select @resultcode as resultcode,@resultmessage as resultmessage




END


GO
