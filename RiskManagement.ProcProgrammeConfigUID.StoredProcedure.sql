USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcProgrammeConfigUID]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [RiskManagement].[ProcProgrammeConfigUID]
@SportId int,
@CategoryId int,
@TournamentId int,
@ReportCount int,
@IsHighlights bit,
@LangId int

AS


declare @resultcode int=106
declare @resultmessage nvarchar(max)='Hata oluştu'


select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId

BEGIN
SET NOCOUNT ON;


		update Retail.ProgrammeConfig set ReportCount=@ReportCount,IsHighlights=@IsHighlights where Id=@TournamentId


	
			select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId

			
	select @resultcode as resultcode,@resultmessage as resultmessage
END



GO
