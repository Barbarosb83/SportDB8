USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcMatchStandings]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
 
CREATE PROCEDURE [Retail].[ProcMatchStandings]
	@Name nvarchar(max) ,
	@SportId int ,
	@CategoryId int ,
	@TournamentId bigint ,
	@TeamId bigint,
	@Season nvarchar(50) ,
	@TeamName nvarchar(150) ,
	@Rank int ,
	@CurrentOutcome nvarchar(150) ,
	@Played int ,
	@Win int ,
	@Draw int ,
	@Loss int ,
	@GoalFor int ,
	@GoalAgainst int ,
	@GoalDiff int ,
	@Points int 
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

 declare @Id bigint

 declare @trnmtId int

 select @trnmtId=Parameter.Tournament.TournamentId from Parameter.Tournament with (nolock) INNER JOIN Parameter.Category with (nolock) ON Parameter.Category.CategoryId=Parameter.Tournament.CategoryId where Parameter.Tournament.NewBetradarId=@TournamentId and Parameter.Category.SportId=1

 if(@trnmtId is not null and @trnmtId<>1125)
 begin
	if exists (Select [Match].[Standings].Id from [Match].[Standings] with (nolock) where  [Match].[Standings].TournamentId=@trnmtId and TeamId=@TeamId and  [Match].[Standings].Name=@Name )	
		begin
		delete [Match].[Standings] where  [Match].[Standings].TournamentId=@trnmtId and TeamId=@TeamId and  [Match].[Standings].Name=@Name
		end

			INSERT INTO [Match].[Standings]
           ([Name]
           ,[SportId]
           ,[CategoryId]
           ,[TournamentId]
           ,[TeamId]
           ,[Season]
           ,[TeamName]
           ,[Rank]
           ,[CurrentOutcome]
           ,[Played]
           ,[Win]
           ,[Draw]
           ,[Loss]
           ,[GoalFor]
           ,[GoalAgainst]
           ,[GoalDiff]
           ,[Points])
     VALUES
           (@Name 
           ,@SportId 
           ,@CategoryId
           ,@trnmtId
           ,@TeamId
           ,@Season
           ,@TeamName
           ,@Rank
           ,@CurrentOutcome
           ,@Played
           ,@Win 
           ,@Draw 
           ,@Loss 
           ,@GoalFor 
           ,@GoalAgainst 
           ,@GoalDiff 
           ,@Points )

	 end

 select 1 as result


END


GO
