USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCustomerCreditCardApprove]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [RiskManagement].[ProcCustomerCreditCardApprove] 
@CreditCardId bigint,
@IsApproved bit,
@Username nvarchar(50),
@UserId int,
@Comment nvarchar(250),
@LangId int
AS

BEGIN
SET NOCOUNT ON;


declare @resultcode int=103
declare @resultmessage nvarchar(max)='Hata oluştu'
declare @Amount money
declare @TransactionType int
declare @CurrencyId int
declare @BranchId bigint
declare @TransactionTypeId int
				
select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId


		update Customer.CreditCard set IsApproved=@IsApproved,ApprovedComment=@Comment,ApprovedDate=GETDATE() where CreditCardId=@CreditCardId
	
select @resultcode as resultcode,@resultmessage as resultmessage

END




GO
