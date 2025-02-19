USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcTournamentUID]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [RiskManagement].[ProcTournamentUID]
@TournamentId int,
@TournamentName nvarchar(250),
@IsActive bit,
@Limit money,
@LimitPerTicket money,
@Availabity nvarchar(20),
@SequenceNumber int,
@IsterminalPopular bit,
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

select @AvailabityId=Parameter.MatchAvailability.AvailabilityId from Parameter.MatchAvailability
where Parameter.MatchAvailability.Availability=@Availabity

select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId


if @ActivityCode=1
	begin
		exec [Log].ProcConcatOldValues  'Tournament','[Parameter]','TournamentId',@TournamentId,@OldValues output
	
	exec [Log].[ProcTransactionLogUID] 16,@ActivityCode,@Username,@TournamentId,'Parameter.Tournament'
	,@NewValues,@OldValues
	
	update Parameter.Tournament set
	TournamentName=@TournamentName,
	IsActive=@IsActive,
	AvailabilityId=@AvailabityId,
	Limit=@Limit,
	LimitPerTicket=@LimitPerTicket,
	SequenceNumber=@SequenceNumber
	,IsPopularTerminal=@IsterminalPopular
	where TournamentId=@TournamentId
	
	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId
	
	
	end


	select @resultcode as resultcode,@resultmessage as resultmessage


END



GO
