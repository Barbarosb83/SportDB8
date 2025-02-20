USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCustomerNotesUID]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcCustomerNotesUID]
@CustomerId bigint, 
@Notes nvarchar(250),
@LangId int,
@username nvarchar(max),
@ActivityCode int,
@NewValues nvarchar(max)


AS




BEGIN
SET NOCOUNT ON;


declare @OldValues nvarchar(max)
declare @resultcode int=106
declare @resultmessage nvarchar(max)='Hata oluştu'
declare @UserId int
select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId


if @ActivityCode=2
	begin
		
	select @UserId=Users.Users.UserId from Users.Users where Users.Users.UserName=@username
	
	
	insert Customer.Notes(CustomerId,CreateDate,CreateUserId,Notes,IsPrivate)
	values(@CustomerId,GETDATE(),@UserId,@Notes,0)
	
	execute Users.Notification @UserId,@CustomerId,8,99,''
	
	
	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId
	
	
	end
if @ActivityCode=4
	begin
		
	select @UserId=Users.Users.UserId from Users.Users where Users.Users.UserName=@username
	
	
	insert Customer.Notes(CustomerId,CreateDate,CreateUserId,Notes,IsPrivate)
	values(@CustomerId,GETDATE(),@UserId,@Notes,1)
	
	--execute Users.Notification @UserId,@CustomerId,8,99,''
	
	
	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId
	
	
	end


	select @resultcode as resultcode,@resultmessage as resultmessage              

END


GO
