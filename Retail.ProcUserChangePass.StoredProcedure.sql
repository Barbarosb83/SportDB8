USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcUserChangePass]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcUserChangePass] 
@UserId int,
@OldPassword nvarchar(50),
@NewPassword nvarchar(50),
@LangId int
AS

BEGIN
SET NOCOUNT ON;

declare @resultcode int=106
declare @resultmessage nvarchar(max)='Hata oluştu'

select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId

if(select COUNT(*) from Users.Users where Users.Users.UserId=@UserId and Users.Users.Password=@OldPassword and Users.Users.IsDeleted=0)>0
	Begin
		update Users.Users set [Password]=@NewPassword where UserId=@UserId
	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId

	end
else
		select @resultcode=106,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=101 and Log.ErrorCodes.LangId=@LangId



		

	select @resultcode as resultcode,@resultmessage as resultmessage


END





GO
