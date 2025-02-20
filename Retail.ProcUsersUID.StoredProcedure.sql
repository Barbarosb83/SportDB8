USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcUsersUID]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcUsersUID]
@UserId int,
@UserName nvarchar(50),
@Name nvarchar(150),
@Surname nvarchar(100),
@Email nvarchar(100),
@GsmNo nvarchar(50),
@CurrencyId int,
@TimeZoneId int,
@LanguageId int,
@BranchId int,
@ActivityCode int,
@NewValues nvarchar(max),
@CreateUsername nvarchar(50)
AS


declare @OldValues nvarchar(max)
declare @resultcode int=106
declare @resultmessage nvarchar(max)='Hata oluştu'
SET NOCOUNT ON

BEGIN TRAN

if(@ActivityCode=2)
begin
		if(select COUNT(*) from [Users].Users where (UserName=@UserName))=0
		begin
			if(select COUNT(*) from [Users].Users where (Email=@Email))=0
			begin
		exec [Log].[ProcTransactionLogUID] 29,@ActivityCode,@CreateUsername,@UserId,'Users.Users'
		,@NewValues,null
		
		declare @Passwords nvarchar(20)

		set  @Passwords	=  dbo.[FuncGenPass](Rand())

			insert [Users].Users(UserName,Password,Name,Surname,Email,GsmNo,TimeZoneId,CurrencyId,LanguageId,CreateDate,IsLockedOut,FailedPasswordAttemptCount,UnitCode,[Multiplier],MultipDate,LastLoginDate)
			values (@UserName,@Passwords,@Name,@Surname,@Email,@GsmNo,@TimeZoneId,@CurrencyId,@LanguageId,GETDATE(),0,0,@BranchId,1,GETDATE(),GETDATE())
		
			set @UserId=SCOPE_IDENTITY()
			execute Retail.[ProcUsersRoleUID]  0,158,@UserId,2,'',@CreateUsername
		
			select @resultcode=ErrorCodeId,@resultmessage=@Passwords from Log.ErrorCodes where ErrorCodeId=104
			end
			else
		begin
		
			select @resultcode=106,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=107

		end
		end
		else
		begin
		
			select @resultcode=106,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=107

		end
end
else if (@ActivityCode=5)
	begin
		update Users.Users set Password=@Name where UserName=@UserName
		select @resultcode=ErrorCodeId,@resultmessage=@Passwords from Log.ErrorCodes where ErrorCodeId=104

	end
else if (@ActivityCode=6)
	begin
		update Users.Users set Password=@Name where UserId=@UserId
		select @resultcode=ErrorCodeId,@resultmessage=@Passwords from Log.ErrorCodes where ErrorCodeId=104

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
