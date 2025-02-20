USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerForgetPasswordChange]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcCustomerForgetPasswordChange] 
@CustomerId bigint,
@NewPassword nvarchar(max),
@LangId int
AS

BEGIN
SET NOCOUNT ON;


declare @resultcode int=101
declare @resultmessage nvarchar(max)='Hata oluştu'

select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId


	update Customer.Customer set Password=@NewPassword,GroupId=1
		where Customer.Customer.CustomerId=@CustomerId
		select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=112 and Log.ErrorCodes.LangId=@LangId


	select @resultcode as resultcode,@resultmessage as resultmessage


End


GO
