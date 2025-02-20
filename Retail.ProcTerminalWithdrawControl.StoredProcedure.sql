USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcTerminalWithdrawControl]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcTerminalWithdrawControl]
@TransactionId Bigint,
@LangId int,
@username nvarchar(max)


AS




BEGIN
SET NOCOUNT ON;

declare @OldValues nvarchar(max)
declare @resultcode bigint=106
declare @resultmessage nvarchar(max)='Hata oluştu'
declare @BranchBalance money=0
declare @ParentBranchBalance money
declare @Control int=0
declare @UserId int
declare @UserRoleId int
declare @UserBranchId int 
declare @CurrenyId int
declare @CustomerId bigint
select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId
		 
	 
select @UserRoleId=Users.UserRoles.RoleId,@UserId=Users.Users.UserId,@UserBranchId=Users.Users.UnitCode from Users.UserRoles INNER JOIN Users.Users ON Users.UserRoles.UserId=Users.Users.UserId where UserName=@username


		
					select RiskManagement.BranchTransactionPass.BranchTransactionId,Amount,Parameter.Currency.CurrencyId,Parameter.Currency.Currency
					,RiskManagement.BranchTransactionPass.UpdateDate
					,RiskManagement.BranchTransactionPass.UpdateUserName
					,RiskManagement.BranchTransactionPass.CreateDate
					,RiskManagement.BranchTransactionPass.IsPaid from RiskManagement.BranchTransaction  INNER JOIN Parameter.Currency
					ON Parameter.Currency.CurrencyId=RiskManagement.BranchTransaction.CurrencyId INNER JOIN
					RiskManagement.BranchTransactionPass ON RiskManagement.BranchTransactionPass.BranchTransactionId=RiskManagement.BranchTransaction.BranchTransactionId
					where RiskManagement.BranchTransactionPass.BranchTransactionId=@TransactionId

		

		 
END




GO
