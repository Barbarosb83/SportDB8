USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerChangePassword]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcCustomerChangePassword] 
@CustomerId bigint,
@Password nvarchar(150),
@NewPassword nvarchar(150),
@LangId int
AS

BEGIN
SET NOCOUNT ON;

declare @resultcode int=101
declare @resultmessage nvarchar(max)='Hata oluştu'

select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId

if(select (Customer.Customer.CustomerId) from Customer.Customer where Customer.Customer.CustomerId=@CustomerId and Customer.Customer.Password=@Password)>0
begin
	update Customer.Customer set Password=@NewPassword where CustomerId=@CustomerId
		select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=112 and Log.ErrorCodes.LangId=@LangId

	
end


	select @resultcode as resultcode,@resultmessage as resultmessage


END


GO
