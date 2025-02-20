USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Bonus].[ProcBonusRuleCashTypeUID]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Bonus].[ProcBonusRuleCashTypeUID]
@BonusRuleId int,
@ParameterCashTypeId int,
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
	

	
		if( select COUNT(*) from  [Bonus].[RuleCashType]   where RuleId=@BonusRuleId and CashTypeId=@ParameterCashTypeId)=0
		insert Bonus.[RuleCashType](RuleId,CashTypeId )
		values (@BonusRuleId,@ParameterCashTypeId)
	
			select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId

	end
	
	else if(@ActivityCode=2)
	begin
	
			exec [Log].[ProcTransactionLogUID] 26,@ActivityCode,@Username,@BonusRuleId,'Bonus.RuleCashType'
	,@NewValues,null
	
		insert Bonus.[RuleCashType](RuleId,CashTypeId )
		values (@BonusRuleId,@ParameterCashTypeId)
		
	
	
	

	
			select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=104 and Log.ErrorCodes.LangId=@LangId
	End
	else if(@ActivityCode=4)
	begin
	
	
			delete from Bonus.RuleCashType where RuleCashTypeId=@ParameterCashTypeId
		
	
	
	

	
			select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=105 and Log.ErrorCodes.LangId=@LangId
	End
	else
		delete from Bonus.RuleCashType where RuleId=@BonusRuleId




	select @resultcode as resultcode,@resultmessage as resultmessage




END


GO
