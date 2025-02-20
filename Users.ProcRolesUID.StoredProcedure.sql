USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Users].[ProcRolesUID]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Users].[ProcRolesUID]
@RoleId int,
@RoleName nvarchar(50),
@Description nvarchar(300),
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
	
	exec [Log].ProcConcatOldValues  'Roles','[Users]','RoleId',@RoleId,@OldValues output
	
		exec [Log].[ProcTransactionLogUID] 12,@ActivityCode,@Username,@RoleId,'Users.Roles'
		,@NewValues,@OldValues
		
		update [Users].Roles set RoleName=@RoleName,[Description]=@Description where RoleId=@RoleId
		
		select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103
		
	end
else if (@ActivityCode=2)
	begin
	
		if(select COUNT(*) from [Users].Roles where RoleName=@RoleName)=0
		begin
			insert [Users].Roles(RoleName,[Description],IsDeleted,IsVisible)
			values (@RoleName,@Description,0,1)
		
			set @RoleId=SCOPE_IDENTITY()
			exec [Log].[ProcTransactionLogUID] 12,@ActivityCode,@Username,@RoleId,'Users.Roles'
			,@NewValues,null
		
			select @resultcode=@RoleId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=104
		end
		else
		begin
		
			select @resultcode=-1,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=107

		end
	end
else if (@ActivityCode=3)
	begin
	
		exec [Log].ProcConcatOldValues  'Roles','[Users]','RoleId',@RoleId,@OldValues output
	
		exec [Log].[ProcTransactionLogUID] 12,@ActivityCode,@Username,@RoleId,'Users.Roles'
		,null,@OldValues
		if(@RoleId<>1)
		begin
			update  [Users].Roles set IsDeleted=1   where RoleId=@RoleId
		end
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
