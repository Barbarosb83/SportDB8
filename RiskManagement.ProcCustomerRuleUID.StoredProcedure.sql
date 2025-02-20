USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCustomerRuleUID]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcCustomerRuleUID]
@CustomerRuleId int,
@RuleName nvarchar(150) ,
@StartDate datetime ,
@EndDate datetime ,
@Priority int ,
@IsEnable bit ,
@ParameterRuleTimeId int ,
@ParameterRuleValueTypeId int ,
@Value decimal(18, 0) ,
@ParameterRuleCompareTypeId int ,
@ParameterCustomerGroupId int ,
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



select @resultcode=ErrorCodeId,@resultmessage=ErrorCode 
from Log.ErrorCodes 
where ErrorCodeId=@resultcode 
and Log.ErrorCodes.LangId=@LangId




if(@ActivityCode=1)
	begin
	
	exec [Log].ProcConcatOldValues 'CustomerRule','[RiskManagement]','CustomerRuleId',@CustomerRuleId,@OldValues output
	
	exec [Log].[ProcTransactionLogUID] 39,@ActivityCode,@Username,@CustomerRuleId,'RiskManagement.CustomerRule'
	,@NewValues,@OldValues
	
	
	
	update [RiskManagement].[CustomerRule] set
	RuleName=@RuleName
	,StartDate=@StartDate
	,EndDate=@EndDate
	,Priority=@Priority
	,IsEnable=@IsEnable
	,ParameterRuleTimeId=@ParameterRuleTimeId
	,ParameterRuleValueTypeId=@ParameterRuleValueTypeId
	,Value=@Value
	,ParameterRuleCompareTypeId=@ParameterRuleCompareTypeId
	,ParameterCustomerGroupId=@ParameterCustomerGroupId
	where CustomerRuleId=@CustomerRuleId
	

	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode 
	from Log.ErrorCodes 
	where ErrorCodeId=103 
	and Log.ErrorCodes.LangId=@LangId

	end
	
	else if(@ActivityCode=2)
	begin
	
		exec [Log].[ProcTransactionLogUID] 39,@ActivityCode,@Username,@CustomerRuleId,'RiskManagement.CustomerRule'
	,@NewValues,null
	
		insert RiskManagement.CustomerRule(RuleName,StartDate,EndDate,Priority,IsEnable,ParameterRuleTimeId,ParameterRuleValueTypeId,Value,ParameterRuleCompareTypeId,ParameterCustomerGroupId)
		values(@RuleName,@StartDate,@EndDate,@Priority,@IsEnable,@ParameterRuleTimeId,@ParameterRuleValueTypeId,@Value,@ParameterRuleCompareTypeId,@ParameterCustomerGroupId)
	
		select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=104 and Log.ErrorCodes.LangId=@LangId
	end




	select @resultcode as resultcode,@resultmessage as resultmessage




END

GO
