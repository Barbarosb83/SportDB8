USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcBranchBetTypeCommissionUID]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcBranchBetTypeCommissionUID]
@BranchBetTypeCommisionId int,
@BranchId int,
@BetTypeId int,
@CommissionRate float,
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
		exec [Log].ProcConcatOldValues  'BranchBetTypeCommision','[RiskManagement]','BranchBetTypeCommisionId',@BranchBetTypeCommisionId,@OldValues output
	
	exec [Log].[ProcTransactionLogUID]  37,@ActivityCode,@Username,@BranchBetTypeCommisionId,'RiskManagement.BranchBetTypeCommision'
	,@NewValues,@OldValues
	
	update RiskManagement.BranchBetTypeCommision set
	BetTypeId =@BetTypeId,
	CommissionRate=@CommissionRate
	where RiskManagement.BranchBetTypeCommision.BranchBetTypeCommisionId=@BranchBetTypeCommisionId
	
	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId
	
	
	end
if @ActivityCode=2
	begin

	
	exec [Log].[ProcTransactionLogUID]  37,@ActivityCode,@Username,@BranchBetTypeCommisionId,'RiskManagement.BranchBetTypeCommision'
	,@NewValues,null
	
	insert RiskManagement.BranchBetTypeCommision (BranchId,BetTypeId,CommissionRate)
	values(@BranchId,@BetTypeId,@CommissionRate)
	
	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=104 and Log.ErrorCodes.LangId=@LangId
	
	
	end
	
	if @ActivityCode=3
	begin

		exec [Log].ProcConcatOldValues  'BranchBetTypeCommision','[RiskManagement]','BranchBetTypeCommisionId',@BranchBetTypeCommisionId,@OldValues output
	
	exec [Log].[ProcTransactionLogUID]  37,@ActivityCode,@Username,@BranchBetTypeCommisionId,'RiskManagement.BranchBetTypeCommision'
	,null,@OldValues
	
	delete from RiskManagement.BranchBetTypeCommision where RiskManagement.BranchBetTypeCommision .BranchBetTypeCommisionId=@BranchBetTypeCommisionId
	
	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=105 and Log.ErrorCodes.LangId=@LangId
	
	
	end
	


	select @resultcode as resultcode,@resultmessage as resultmessage
END


GO
