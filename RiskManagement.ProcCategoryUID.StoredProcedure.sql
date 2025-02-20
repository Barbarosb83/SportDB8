USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCategoryUID]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcCategoryUID]
@CategoryId int,
@IsActive bit,
@IsPopular bit,
@SequenceNumber int,
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
declare @AvailabityId int


select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId


if @ActivityCode=1
	begin
		exec [Log].ProcConcatOldValues 'Category','[Parameter]','CategoryId',@CategoryId,@OldValues output
	
	exec [Log].[ProcTransactionLogUID] 22,@ActivityCode,@Username,@CategoryId,'Parameter.Category'
	,@NewValues,@OldValues
	
	update Parameter.Category set
	IsActive=@IsActive,
	SequenceNumber=@SequenceNumber,
	Ispopular=@IsPopular
	where CategoryId=@CategoryId
	
	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId
	
	
	end


	select @resultcode as resultcode,@resultmessage as resultmessage


END


GO
