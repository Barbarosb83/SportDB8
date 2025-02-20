USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcTournamentLanguageUIDOutrights]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [RiskManagement].[ProcTournamentLanguageUIDOutrights]
@ParameterTournamentId int,
@TournamentId int,
@LanguageId int,
@TournamentName nvarchar(250),
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
		exec [Log].ProcConcatOldValues     'Parameter.Tournament','[Language]','ParameterTournamentId',@ParameterTournamentId,@OldValues output
	
	exec [Log].[ProcTransactionLogUID]  17,@ActivityCode,@Username,@ParameterTournamentId,'Language.[Parameter.Tournament]'
	,@NewValues,@OldValues
	
	update Language.[Parameter.TournamentOutrights] set
	TournamentName=@TournamentName

	where Language.[Parameter.TournamentOutrights].ParameterTournamentId=@ParameterTournamentId
	
	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId
	
	
	end
if @ActivityCode=2
	begin

	exec [Log].[ProcTransactionLogUID]  17,@ActivityCode,@Username,@ParameterTournamentId,'Language.[Parameter.Tournament]'
	,@NewValues,null
	
	insert Language.[Parameter.TournamentOutrights](TournamentId,LanguageId,TournamentName)
	values(@TournamentId,@LanguageId,@TournamentName)
	
	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=104 and Log.ErrorCodes.LangId=@LangId
	
	
	end


	select @resultcode as resultcode,@resultmessage as resultmessage
END


GO
