USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Virtual.ProcMatchInfo]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Betradar].[Virtual.ProcMatchInfo]
@SportId bigint,
@CategoryId bigint,
@TournamentId  bigint,
@HomeTeamId bigint,
@AwayTeamId bigint,
@DateOfMatch datetime,
@BetradarMatchId bigint,
@TournamentName nvarchar(250),
@MatchDay varchar(15)

AS

declare @VirtualEventId int=-1
BEGIN


if((@SportId is not null) and (@CategoryId is not null) and (@TournamentId is not null))
	begin
		
		select @VirtualEventId=[Virtual].[Event].EventId from [Virtual].[Event] where [Virtual].[Event].[BetradarMatchId]=@BetradarMatchId
		
		if (@VirtualEventId=-1)
			begin
				INSERT INTO [Virtual].[Event]
				   ([BetradarMatchId]
				   ,[TournamentId]
				   ,[EventDate]
				   ,[HomeTeam]
				   ,[AwayTeam]
				   ,[EventStatu]
				   ,[IsActive]
				   ,[FeedStatu]
				   ,[ConnectionStatu]
				   ,[TournamentName]
				   ,[MatchDay])
			 VALUES
				   (@BetradarMatchId
				   ,@TournamentId
				   ,@DateOfMatch
				   ,@HomeTeamId
				   ,@AwayTeamId
				   ,1
				   ,0
				   ,2
				   ,2
				   ,@TournamentName
				   ,@MatchDay)
				
				set @VirtualEventId=SCOPE_IDENTITY()
				
				execute [Betradar].[Virtual.ProcEventSettingInsert]  @TournamentId,@VirtualEventId


				execute [Betradar].[Virtual.ProcEventTopOddInsert] @VirtualEventId


			end
		else
			begin
				update [Virtual].[Event]
				set [TournamentId]=@TournamentId
				   ,[EventDate]=@DateOfMatch
				   ,[HomeTeam]=@HomeTeamId
				   ,[AwayTeam]=@AwayTeamId
				   ,[FeedStatu] =2
				   ,[TournamentName]=@TournamentName
				   ,[MatchDay]=@MatchDay
				where [Virtual].[Event].EventId=@VirtualEventId
			end
		
		
	end

	select @VirtualEventId as VirtualEventId

END


GO
