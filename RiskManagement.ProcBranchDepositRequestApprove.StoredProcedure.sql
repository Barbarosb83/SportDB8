USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcBranchDepositRequestApprove]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcBranchDepositRequestApprove] 
@BranchDepositId bigint,
@IsApproved bit,
@Username nvarchar(50),
@UserId int,
@LangId int
AS

BEGIN
SET NOCOUNT ON;


declare @resultcode int=145
declare @resultmessage nvarchar(max)='Hata oluştu'
declare @Amount money
declare @TransactionType int
declare @CurrencyId int
declare @BranchId bigint
declare @TransactionTypeId int
				
select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId


		if(@IsApproved=1)
			begin
				select @Amount=Amount,@CurrencyId=CurrencyId,@BranchId=BranchId,@TransactionTypeId=RiskManagement.BranchDepositRequest.TransactionTypeId
				from  RiskManagement.BranchDepositRequest where RiskManagement.BranchDepositRequest.BranchDepositId =@BranchDepositId

				UPDATE RiskManagement.BranchDepositRequest
				SET IsApproved = 1
			   ,ApprovedUserId = @UserId
				 ,ApprovedDate = GetDate()
				WHERE RiskManagement.BranchDepositRequest.BranchDepositId =@BranchDepositId
				
				if(@TransactionTypeId=3) --Deposit Talebi
					begin
						update Parameter.Branch set Balance=Balance+@Amount where BranchId=@BranchId
						
						insert RiskManagement.BranchTransaction (BranchId,TransactionTypeId,Amount,CurrencyId,CreateDate,UserId)
						values(@BranchId,3,@Amount,@CurrencyId,GETDATE(),@UserId)
					end
				else --Withdraw talebi
					begin
						update Parameter.Branch set Balance=Balance-@Amount where BranchId=@BranchId
						
						insert RiskManagement.BranchTransaction (BranchId,TransactionTypeId,Amount,CurrencyId,CreateDate,UserId)
						values(@BranchId,5,@Amount,@CurrencyId,GETDATE(),@UserId)
					
					end
				execute Users.Notification @UserId,0,7,139,''
				
				select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=146 and Log.ErrorCodes.LangId=@LangId

			end
		Else
			begin

				UPDATE RiskManagement.BranchDepositRequest
				SET IsApproved = 0
			   ,ApprovedUserId = @UserId
				 ,ApprovedDate = GetDate()
				WHERE RiskManagement.BranchDepositRequest.BranchDepositId =@BranchDepositId
			
			
				execute Users.Notification @UserId,0,7,139,''
			
				select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=147 and Log.ErrorCodes.LangId=@LangId

			end
	
select @resultcode as resultcode,@resultmessage as resultmessage

END


GO
