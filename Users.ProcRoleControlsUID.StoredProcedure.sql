USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Users].[ProcRoleControlsUID]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Users].[ProcRoleControlsUID]
@RoleId int,
@ControlId int,
@IsSelect bit,
@IsUpdate bit,
@IsInsert bit,
@IsDelete bit,
@NewValues nvarchar(max),
@Username nvarchar(50)
AS

declare @OldValues nvarchar(max)
declare @resultcode int=106
declare @resultmessage nvarchar(max)='Hata oluştu'
SET NOCOUNT ON

--BEGIN TRAN

declare @ActivityCode int
declare @RoleControlId int

select @RoleControlId=RoleControlId from [Users].RoleControls where [Users].RoleControls.RoleId=@RoleId and [Users].RoleControls.ControlId=@ControlId

if(@IsSelect=0 and @IsUpdate=0 and @IsInsert=0 and @IsDelete=0 )
	begin
	
		if (@RoleControlId is null)
		begin
			select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103
		end
		else
		begin
			exec [Log].ProcConcatOldValues  'RoleControls','[Users]','RoleControlId',@RoleId,@OldValues output
			set @ActivityCode=3
			
			exec [Log].[ProcTransactionLogUID] 24,@ActivityCode,@Username,@RoleControlId,'Users.RoleControls'
			,@NewValues,@OldValues
			
			delete [Users].RoleControls where [Users].RoleControls.RoleControlId=@RoleControlId
			
			select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103
		end
	end
else if (@IsSelect=1 or @IsUpdate=1 or @IsInsert=1 or @IsDelete=1)
	begin
	
		if (@RoleControlId is null)
		begin
		
				INSERT INTO [Users].[RoleControls]
			   ([RoleId]
			   ,[ControlId]
			   ,[IsUpdate]
			   ,[IsDelete]
			   ,[IsSelect]
			   ,[IsInsert])
				VALUES
			   (@RoleId
			   ,@ControlId
			   ,@IsUpdate
			   ,@IsDelete
			   ,@IsSelect
			   ,@IsInsert)
           
			set @RoleControlId=SCOPE_IDENTITY()
			set @ActivityCode=2
			exec [Log].[ProcTransactionLogUID] 24,@ActivityCode,@Username,@RoleControlId,'Users.RoleControls'
			,@NewValues,null
		
			select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103
			
		end
		else
		begin
			exec [Log].ProcConcatOldValues  'RoleControls','[Users]','RoleControlId',@RoleId,@OldValues output
			set @ActivityCode=1
			
			exec [Log].[ProcTransactionLogUID] 22,@ActivityCode,@Username,@RoleControlId,'Users.RoleControls'
			,@NewValues,@OldValues
			
			UPDATE [Users].[RoleControls]
			   SET [RoleId] = @RoleId
				  ,[ControlId] = @ControlId
				  ,[IsUpdate] = @IsUpdate
				  ,[IsDelete] = @IsDelete
				  ,[IsSelect] = @IsSelect
				  ,[IsInsert] = @IsInsert
			 WHERE [Users].RoleControls.RoleControlId=@RoleControlId
			
			select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103
		end
	end


--COMMIT TRAN



select @resultcode as resultcode,@resultmessage as resultmessage

--HANDLE_ERROR:
--	insert Log.ErrorLog(Username,SpName,Message,[Parameters],CreateDate)
--	values (@Username,'[Case].[ProcCaseTypeUID]',cast(@@ERROR as nvarchar),@NewValues,GETDATE())
--    IF @@TRANCOUNT > 0
--    ROLLBACK TRAN
--	select @resultcode as resultcode,@resultmessage as resultmessage


GO
