USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcUsersNewPass]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Retail].[ProcUsersNewPass]
@UserId int,
@LanguageId int


AS


declare @OldValues nvarchar(max)
declare @resultcode int=106
declare @resultmessage nvarchar(max)='Hata oluştu'
SET NOCOUNT ON

BEGIN TRAN


		if(select COUNT(*) from [Users].Users where UserId=@UserId)>0
		begin
		
	 
		
		declare @Passwords nvarchar(20)

		set  @Passwords	=  dbo.[FuncGenPass](Rand())

		update Users.Users set [Password]=@Passwords,FailedPasswordAttemptCount=0 where UserId=@UserId
		 
		
			select @resultcode=ErrorCodeId,@resultmessage=@Passwords from Log.ErrorCodes where ErrorCodeId=104 and LangId=@LanguageId
		end
		else
		begin
		
			select @resultcode=106,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=107 and LangId=@LanguageId

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
