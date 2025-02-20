USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Users].[ProcUsersRoleUID]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Users].[ProcUsersRoleUID]
@UserRolesId int,
@RoleId int,
@UserId int,
@ActivityCode int,
@NewValues nvarchar(max),
@Username nvarchar(50)
AS


declare @OldValues nvarchar(max)
declare @resultcode int=106
declare @resultmessage nvarchar(max)='Hata oluştu'
SET NOCOUNT ON

BEGIN TRAN

if(@ActivityCode=1)
	begin
	
	exec [Log].ProcConcatOldValues  'UserRoles','[Users]','RoleId',@RoleId,@OldValues output
	
		exec [Log].[ProcTransactionLogUID] 30,@ActivityCode,@Username,@RoleId,'Users.UserRoles'
		,@NewValues,@OldValues
		
		update [Users].UserRoles set RoleId=@RoleId  where UserId=@UserId
		
		select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103
		
	end
else 
if (@ActivityCode=2)
	begin
	
		if(select COUNT(*) from [Users].UserRoles where RoleId=@RoleId and UserId=@UserId)=0
		begin
			insert [Users].UserRoles(UserId,RoleId)
			values (@UserId,@RoleId)
		
			set @UserRolesId=SCOPE_IDENTITY()
			exec [Log].[ProcTransactionLogUID] 30,@ActivityCode,@Username,@UserRolesId,'Users.UserRoles'
			,@NewValues,null
		
			select @resultcode=@UserRolesId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=104
		end
		else
		begin
		
			select @resultcode=-1,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=107

		end
	end
--else if (@ActivityCode=3)
--	begin
	
--		exec [Log].ProcConcatOldValues  'Roles','[Users]','RoleId',@RoleId,@OldValues output
	
--		exec [Log].[ProcTransactionLogUID] 12,@ActivityCode,@Username,@RoleId,'Users.Roles'
--		,null,@OldValues
			
--		update  [Users].Roles set IsDeleted=1   where RoleId=@RoleId
		
--		select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=105
	
--	end

COMMIT TRAN



select @resultcode as resultcode,@resultmessage as resultmessage

--HANDLE_ERROR:
--	insert Log.ErrorLog(Username,SpName,Message,[Parameters],CreateDate)
--	values (@Username,'[Case].[ProcCaseTypeUID]',cast(@@ERROR as nvarchar),@NewValues,GETDATE())
--    IF @@TRANCOUNT > 0
--    ROLLBACK TRAN
--	select @resultcode as resultcode,@resultmessage as resultmessage


GO
