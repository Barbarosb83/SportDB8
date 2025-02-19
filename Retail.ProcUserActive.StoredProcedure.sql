USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcUserActive]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 

CREATE PROCEDURE [Retail].[ProcUserActive]
@UserId bigint,
@IsActive bit,
@LangId int,
@username nvarchar(max)


AS




BEGIN
SET NOCOUNT ON;

declare @OldValues nvarchar(max)
declare @resultcode int=103
declare @resultmessage nvarchar(max)='Hata oluştu'

select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId

  
  update Users.Users set IsLockedOut=@IsActive where UserId=@UserId


	select @resultcode as resultcode,@resultmessage as resultmessage
END





GO
