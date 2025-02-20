USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcBranchDepositRequestUID]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [RiskManagement].[ProcBranchDepositRequestUID]
@BranchDepositId INT,
@TransactionTypeId int,
@RequestUserId int,
@BranchId int,
@Amount money,
@CurrencyId int,
@BranchNote nvarchar(150),
@Username nvarchar(50),
@LangId int


AS

declare @resultcode int=106
declare @resultmessage nvarchar(max)='Hata oluştu'
declare @UserId int


select @UserId= UserId from Users.Users where UserName=@Username
select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId

declare @BranchBalance money


BEGIN
SET NOCOUNT ON;

if(@TransactionTypeId=5)
	begin
		select @BranchBalance=Parameter.Branch.Balance from Parameter.Branch
		where Parameter.Branch.BranchId=@BranchId
		
		if(@BranchBalance>=@Amount)
			begin
				insert RiskManagement.BranchDepositRequest(RequestUserId,BranchId,RequestDate,Amount,CurrencyId,BranchNote,TransactionTypeId)
				values (@RequestUserId,@BranchId,GETDATE(),@Amount,@CurrencyId,@BranchNote,@TransactionTypeId)

				select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=104 and Log.ErrorCodes.LangId=@LangId

				execute Users.Notification @UserId,@BranchId,6,138,''
			end
		else
			begin
				select @resultcode=ErrorCodeId,@resultmessage=ErrorCode+cast(@BranchBalance as nvarchar(10)) from Log.ErrorCodes where ErrorCodeId=149 and Log.ErrorCodes.LangId=@LangId
			end
		
	end
else
	begin
		insert RiskManagement.BranchDepositRequest(RequestUserId,BranchId,RequestDate,Amount,CurrencyId,BranchNote,TransactionTypeId)
		values (@RequestUserId,@BranchId,GETDATE(),@Amount,@CurrencyId,@BranchNote,@TransactionTypeId)

		select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=104 and Log.ErrorCodes.LangId=@LangId

		execute Users.Notification @UserId,@BranchId,6,138,''
	end
	
		select @resultcode as resultcode,@resultmessage as resultmessage


END



GO
