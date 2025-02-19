USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcStandingsTournamentList]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcStandingsTournamentList]
 
AS

--declare @OldValues nvarchar(max)
--declare @resultcode int=113
--declare @resultmessage nvarchar(max)='Hata oluştu'
--declare @AvailabityId int=0
--declare @matchId bigint
--declare @OddTypeId bigint

BEGIN
SET NOCOUNT ON;

--select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId

  select NewBetradarId as TournamentId from Parameter.Tournament with (nolock) INNER JOIN Parameter.Category with (nolock) On Parameter.Category.CategoryId=Parameter.Tournament.CategoryId --and Parameter.Category.SportId=1  
  where TournamentId in ( select distinct [TournamentId] from [Cache].[Programme2] where SportId=1) --and NewBetradarId=17
 

END


GO
