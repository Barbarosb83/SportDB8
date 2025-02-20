USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerForgetPassword]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcCustomerForgetPassword] 
@Username nvarchar(max),
@RecoveryCode char(36),
@LangId int
AS

BEGIN
SET NOCOUNT ON;

declare @resultcode int=114
declare @resultmessage nvarchar(max)='Hata oluştu'


select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId

--select @resultcode as resultcode,@resultmessage as resultmessage

declare @CustomerId bigint

select @CustomerId=Customer.Customer.CustomerId from Customer.Customer where (Customer.Customer.UserName=@Username or Customer.Customer.Email=@Username) --and Customer.Customer.IsActive=1

if(@CustomerId is not null)
	begin
	
		update Customer.Customer set Customer.RecoveryCode=@RecoveryCode,RecoveryDate=getdate()
		where (Customer.Customer.UserName=@Username or Customer.Customer.Email=@Username) --and Customer.Customer.IsActive=1
		
		select @resultcode=@CustomerId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=115 and Log.ErrorCodes.LangId=@LangId
	end

select @resultcode as resultcode,@resultmessage as resultmessage

END


GO
