USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcGameDataOutrightsUID]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcGameDataOutrightsUID]
@EventId bigint,
@IsActive bit,
@LangId int,
@username nvarchar(max),
@ActivityCode int,
@NewValues nvarchar(max)


AS

declare @OldValues nvarchar(max)
declare @resultcode int=106
declare @resultmessage nvarchar(max)='Hata oluştu'
declare @AvailabityId int=0
declare @SequenceNumber int=@LangId
set @LangId=2


BEGIN
SET NOCOUNT ON;



select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId




if(@ActivityCode=1)
	begin
	
	--exec [Log].ProcConcatOldValues   'Event','[Outrights]','EventId',@EventId,@OldValues output
	
	--exec [Log].[ProcTransactionLogUID] 31,@ActivityCode,@Username,@EventId,'Outrights.Event'
	--,@NewValues,@OldValues
	
	update Outrights.Event set 
	IsActive=@IsActive
	,SequenceNumber=@SequenceNumber
	where EventId=@EventId
	
			select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId

	end



	select @resultcode as resultcode,@resultmessage as resultmessage




END


GO
