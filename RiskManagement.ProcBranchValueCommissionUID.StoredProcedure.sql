USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcBranchValueCommissionUID]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcBranchValueCommissionUID]
@BranchValueCommissionId int,
@BranchId int,
@Value1 money,
@Value2 money,
@CommissionRate float,
@BetTypeId int,
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

select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId


if @ActivityCode=1
	begin
		exec [Log].ProcConcatOldValues  'BranchValueCommission','[RiskManagement]','BranchValueCommissionId',@BranchValueCommissionId,@OldValues output
	
	exec [Log].[ProcTransactionLogUID]  36,@ActivityCode,@Username,@BranchValueCommissionId,'RiskManagement.BranchValueCommission'
	,@NewValues,@OldValues
	
	update RiskManagement.BranchValueCommission set
	Value1=@Value1,
	Value2=@Value2,
	CommissionRate=@CommissionRate,
	BetTypeId=@BetTypeId
	where RiskManagement.BranchValueCommission.BranchValueCommissionId=@BranchValueCommissionId
	
	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId
	
	
	end
if @ActivityCode=2
	begin

	exec [Log].[ProcTransactionLogUID]  36,@ActivityCode,@Username,@BranchValueCommissionId,'RiskManagement.BranchValueCommission'
	,@NewValues,null
	
	insert RiskManagement.BranchValueCommission(BranchId,Value1,Value2,CommissionRate,BetTypeId)
	values(@BranchId,@Value1,@Value2,@CommissionRate,@BetTypeId)
	
	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=104 and Log.ErrorCodes.LangId=@LangId
	
	
	end
	
	if @ActivityCode=3
	begin

		exec [Log].ProcConcatOldValues  'BranchValueCommission','[RiskManagement]','BranchValueCommissionId',@BranchValueCommissionId,@OldValues output
	
	exec [Log].[ProcTransactionLogUID]  36,@ActivityCode,@Username,@BranchValueCommissionId,'RiskManagement.BranchValueCommission'
	,null,@OldValues
	
	delete from RiskManagement.BranchValueCommission where RiskManagement.BranchValueCommission.BranchValueCommissionId=@BranchValueCommissionId
	
	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=105 and Log.ErrorCodes.LangId=@LangId
	
	
	end
	


	select @resultcode as resultcode,@resultmessage as resultmessage
END


GO
