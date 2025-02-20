USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcCustomerActive]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Retail].[ProcCustomerActive]
@CustomerId bigint,
@IsActive bit,
@LangId int,
@username nvarchar(max)


AS




BEGIN
SET NOCOUNT ON;

declare @OldValues nvarchar(max)
declare @resultcode int=103
declare @resultmessage nvarchar(max)='Hata oluştu'

select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId
declare @CustomerActive bit=@IsActive
if(@IsActive=0)
	set @IsActive=1
else
	set @IsActive=0

	update Customer.Customer set IsLockedOut=@IsActive,IsActive=@CustomerActive,FailedPasswordAttemptCount=0 where CustomerId=@CustomerId


	select @resultcode as resultcode,@resultmessage as resultmessage
END





GO
