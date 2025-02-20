USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Parameter].[ProcOddTypeGroupOddTypeUID]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Parameter].[ProcOddTypeGroupOddTypeUID] 
@OddTypeGroupOddTypeId int,
@OddTypeGroupId int,
@OddTypeId int,
@Seqnumber int,
@IsLive bit,
@ActivityCode int,
@LangId int 



AS

BEGIN
SET NOCOUNT ON;

declare @resultcode int=106
declare @resultmessage nvarchar(max)='Hata oluştu'

select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId

if (@IsLive=1)
begin
	if(@ActivityCode=2)
	begin

		insert [Live].[Parameter.OddTypeGroupOddType]   ([OddTypeGroupId],[OddTypeId],[SeqNumber]) values (@OddTypeGroupId,@OddTypeId,@Seqnumber)
		select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId
	end
	else if (@ActivityCode=3)
		begin
			delete from [Live].[Parameter.OddTypeGroupOddType] where OddTypeGroupOddTypeId=@OddTypeGroupOddTypeId
			select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=105 and Log.ErrorCodes.LangId=@LangId
		end

end
else
	begin
		if (@ActivityCode=2)
			begin
				insert Parameter.OddTypeGroupOddType   ([OddTypeGroupId]
           ,[OddTypeId]
           ,[SeqNumber])
		   values (@OddTypeGroupId,@OddTypeId,@Seqnumber)
		   select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId
			end
		else if (@ActivityCode=3)
			begin
				delete from Parameter.OddTypeGroupOddType where [OddTypeGroupOddTypeId]=@OddTypeGroupOddTypeId
				select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=105 and Log.ErrorCodes.LangId=@LangId
			end


	end

		select @resultcode as resultcode,@resultmessage as resultmessage

END



GO
