USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcBranchUpdateActive]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcBranchUpdateActive]
@BranchId int,
@IsActive bit,
@LangId int,
@username nvarchar(max),
@NewValues nvarchar(max)


AS




BEGIN
SET NOCOUNT ON;
 
declare @resultcode int=106
declare @resultmessage nvarchar(max)='Hata oluştu'
  
 
	--	exec [Log].ProcConcatOldValues     'Branch','[Parameter]','BranchId',@BranchId,@OldValues output
	
	--exec [Log].[ProcTransactionLogUID]  35,@ActivityCode,@Username,@BranchId,'Parameter.Branch'
	--,@NewValues,@OldValues
	
	update Parameter.Branch set
	IsActive=@IsActive
	where Parameter.Branch.BranchId=@BranchId
	

	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId
 
 
 

	select @resultcode as resultcode,@resultmessage as resultmessage
END




GO
