USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Bonus].[ProcBonusRuleUID]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Bonus].[ProcBonusRuleUID]
@BonusRuleId int,
@BonusTypeId int,
@BonusName nvarchar(50),
@GameTypeId int,
@MaxAmount money,
@MinAmount money,
@BonusRate float,
@BonusStartDate date,
@BonusEndDate date,
@BonusExpiredDay int,
@BonusMinOddValue float,
@BonusOccurences int,
@ForfeitOnWithdraw bit,
@MinCombineCount int,
@SameOddtypeTwoOdds bit,
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
	
	exec [Log].ProcConcatOldValues   'Rule','[Bonus]','BonusRuleId',@BonusRuleId,@OldValues output
	
	exec [Log].[ProcTransactionLogUID] 27,@ActivityCode,@Username,@BonusRuleId,'Bonus.Rule'
	,@NewValues,@OldValues
	
	
	
	update [Bonus].[Rule] set
	BonusTypeId=@BonusTypeId,
	BonusName=@BonusName,
	GameTypeId=@GameTypeId,
	MaxAmount=@MaxAmount,
	MinAmount=@MinAmount,
	BonusRate=@BonusRate,
	BonusStartDate=@BonusStartDate,
	BonusEndDate=@BonusEndDate,
	BonusExpiredDay=@BonusExpiredDay,
	BonusMinOddValue=@BonusMinOddValue,
	BonusOccurences=@BonusOccurences,
	ForfeitOnWithdraw=@ForfeitOnWithdraw,
	MinCombineCount=@MinCombineCount,
	SameOddtypeTwoOdds=@SameOddtypeTwoOdds
	where BonusRuleId=@BonusRuleId	
	
			select @resultcode=0,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId

	end
	
	else if(@ActivityCode=2)
	begin
	
			exec [Log].[ProcTransactionLogUID] 27,@ActivityCode,@Username,@BonusRuleId,'Bonus.Rule'
	,@NewValues,null
	
	insert Bonus.[Rule](BonusTypeId,BonusName,GameTypeId,MaxAmount,MinAmount,BonusRate,BonusStartDate,BonusEndDate,BonusExpiredDay,BonusMinOddValue,BonusOccurences,ForfeitOnWithdraw,MinCombineCount,SameOddtypeTwoOdds,CreateDate)
	values (@BonusTypeId,@BonusName,@GameTypeId,@MaxAmount,@MinAmount,@BonusRate,@BonusStartDate,@BonusEndDate,@BonusExpiredDay,@BonusMinOddValue,@BonusOccurences,@ForfeitOnWithdraw,@MinCombineCount,@SameOddtypeTwoOdds,GETDATE())	
	
		set @BonusRuleId=SCOPE_IDENTITY()
	
	

	
			select @resultcode=@BonusRuleId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=104 and Log.ErrorCodes.LangId=@LangId
	End
	
	else if(@ActivityCode=3)
	begin
	

	exec [Log].ProcConcatOldValues   'Rule','[Bonus]','BonusRuleId',@BonusRuleId,@OldValues output
	
	exec [Log].[ProcTransactionLogUID] 27,@ActivityCode,@Username,@BonusRuleId,'Bonus.Rule'
	,@NewValues,@OldValues
	
	
	delete from [Bonus].[RuleCashType]  where RuleId=@BonusRuleId
	delete from [Bonus].[RuleDays]   where RuleId=@BonusRuleId
	delete from [Bonus].[Rule]   where BonusRuleId=@BonusRuleId
	
			select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=105 and Log.ErrorCodes.LangId=@LangId

	end



	select @resultcode as resultcode,@resultmessage as resultmessage




END



GO
