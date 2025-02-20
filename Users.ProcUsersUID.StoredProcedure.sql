USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Users].[ProcUsersUID]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Users].[ProcUsersUID]
@UserId int,
@UserName nvarchar(50),
@Password nvarchar(95),
@Name nvarchar(100),
@Surname nvarchar(100),
@Email nvarchar(100),
@GsmNo nvarchar(50),
@CurrencyId int,
@TimeZoneId int,
@LanguageId int,
@BranchId int,
@IsLockOut bit,
@FailPassCount int,
@ActivityCode int,
@NewValues nvarchar(max),
@CreateUsername nvarchar(50)
AS


declare @OldValues nvarchar(max)
declare @resultcode int=106
declare @resultmessage nvarchar(max)='Hata oluştu'

SET NOCOUNT ON

BEGIN TRAN

if(@ActivityCode=1)
	begin
	
	--exec [Log].ProcConcatOldValues  'Users','[Users]','UserID',@UserId,@OldValues output
	
	--	exec [Log].[ProcTransactionLogUID] 29,@ActivityCode,@CreateUsername,@UserId,'Users.Users'
	--	,@NewValues,@OldValues
		

		if(@Password<>'')
		update [Users].Users set Name=@Name,Surname=@Surname,Email=@Email,GsmNo=@GsmNo,Password=@Password,TimeZoneId=@TimeZoneId,CurrencyId=@CurrencyId,LanguageId=@LanguageId
		--,UnitCode=@BranchId
		,FailedPasswordAttemptCount=@FailPassCount,IsLockedOut=@IsLockOut
		where UserId=@UserId
		else
			update [Users].Users set Name=@Name,Surname=@Surname,Email=@Email,GsmNo=@GsmNo,TimeZoneId=@TimeZoneId,CurrencyId=@CurrencyId,LanguageId=@LanguageId
		--,UnitCode=@BranchId
		,FailedPasswordAttemptCount=@FailPassCount,IsLockedOut=@IsLockOut
		where UserId=@UserId
		
		select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103
		
	end
else if (@ActivityCode=2)
	begin
	
		if(select COUNT(*) from [Users].Users where UserName=@UserName)=0
		begin
		
		exec [Log].[ProcTransactionLogUID] 29,@ActivityCode,@CreateUsername,@UserId,'Users.Users'
		,@NewValues,null
		
			insert [Users].Users(UserName,Password,Name,Surname,Email,GsmNo,TimeZoneId,CurrencyId,LanguageId,CreateDate,IsLockedOut,FailedPasswordAttemptCount,UnitCode,Multiplier,MultipDate,IsActive)
			values (@UserName,@Password,@Name,@Surname,@Email,@GsmNo,@TimeZoneId,@CurrencyId,@LanguageId,GETDATE(),0,0,@BranchId,1,GETDATE(),1)
		
			set @UserId=SCOPE_IDENTITY()
			
		
			select @resultcode=@UserId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=104
		end
		else
		begin
		
			select @resultcode=-1,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=107

		end
	end
else if (@ActivityCode=3)
	begin
	
		exec [Log].ProcConcatOldValues  'Users','[Users]','UserID',@UserId,@OldValues output
	
		exec [Log].[ProcTransactionLogUID] 29,@ActivityCode,@CreateUsername,@UserId,'Users.Users'
		,null,@OldValues
			
		delete from Users.UserRoles where UserId=@UserId
		delete from Users.Users where UserId=@UserId
		
		select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=105
	
	end

COMMIT TRAN



select @resultcode as resultcode,@resultmessage as resultmessage

--HANDLE_ERROR:
--	insert Log.ErrorLog(Username,SpName,Message,[Parameters],CreateDate)
--	values (@Username,'[Case].[ProcCaseTypeUID]',cast(@@ERROR as nvarchar),@NewValues,GETDATE())
--    IF @@TRANCOUNT > 0
--    ROLLBACK TRAN
--	select @resultcode as resultcode,@resultmessage as resultmessage



GO
