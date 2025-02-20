USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCompetitorUID]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcCompetitorUID]
@CompetitorId bigint,
@CompetitorName nvarchar(250),
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

select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId


if @ActivityCode=1
	begin
		exec [Log].ProcConcatOldValues 'Competitor','[Parameter]','CompetitorId',@CompetitorId,@OldValues output
	
	exec [Log].[ProcTransactionLogUID] 14,@ActivityCode,@Username,@CompetitorId,'Parameter.Competitor'
	,@NewValues,@OldValues
	
	update Parameter.Competitor set
	CompetitorName=@CompetitorName
	where CompetitorId=@CompetitorId
	
	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId
	
	
	end


	select @resultcode as resultcode,@resultmessage as resultmessage


END


GO
