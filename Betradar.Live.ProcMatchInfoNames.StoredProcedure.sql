USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Live.ProcMatchInfoNames]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
 
CREATE PROCEDURE [Betradar].[Live.ProcMatchInfoNames]
@BetradarSportId bigint,
@BetradarCategoryId bigint,
@BetradarTournamentId  bigint,
@BetradarHomeTeamId bigint,
@BetradarAwayTeamId bigint,
@DateOfMatch datetime,
@BetradarMatchId bigint,
@HomeTeam nvarchar(200),
@AwayTeam nvarchar(200),
@TournamentName nvarchar(200),
@CategoryName nvarchar(200)
AS
declare @SportId int
declare @CategoryId int
declare @TournamentId int
declare @HomeTeamId int
declare @AwayTeamId int
declare @LiveEventId int=-1
BEGIN



select @SportId=Parameter.Sport.SportId from Parameter.Sport with (nolock) where Parameter.Sport.BetRadarSportId=@BetradarSportId
select @CategoryId=Parameter.Category.CategoryId from Parameter.Category with (nolock) where Parameter.Category.BetradarCategoryId=@BetradarCategoryId
select top 1 @TournamentId=Parameter.Tournament.TournamentId from Parameter.Tournament with (nolock) INNER JOIN Parameter.Category with (nolock) On Parameter.Category.CategoryId=Parameter.Tournament.CategoryId
where Parameter.Tournament.NewBetradarId=@BetradarTournamentId and Parameter.Category.SportId=@SportId and Parameter.Category.CategoryId=@CategoryId

select @HomeTeamId=Parameter.Competitor.CompetitorId from Parameter.Competitor with (nolock) where Parameter.Competitor.BetradarSuperId=@BetradarHomeTeamId
select @AwayTeamId=Parameter.Competitor.CompetitorId from Parameter.Competitor with (nolock) where Parameter.Competitor.BetradarSuperId=@BetradarAwayTeamId

if(@SportId is not null)
begin

if(@CategoryId is null)
begin
	insert Parameter.Category (BetradarCategoryId,CategoryName,IsActive,Ispopular,SequenceNumber,SportId,IsoId)
	values (@BetradarCategoryId,@CategoryName,1,0,999,@SportId,0)
	set @CategoryId=SCOPE_IDENTITY()


	insert Language.[Parameter.Category](CategoryId,CategoryName,LanguageId)
	select @CategoryId,@CategoryName,LanguageId from Language.Language with (nolock)

end

if(@TournamentId is null)
	begin
		--	select @CategoryId=Parameter.Category.CategoryId from Parameter.Category 
		--where Parameter.Category.BetradarCategoryId=@BetradarCategoryId
		
		
		insert Parameter.Tournament(BetradarTournamentId,CategoryId,TournamentName,IsActive,AvailabilityId,BetradarTournamentId2,NewBetradarId,TerminalTournamentId)
		values (@BetradarTournamentId,@CategoryId,@TournamentName,1,1,@BetradarTournamentId,@BetradarTournamentId,@BetradarTournamentId)
		
		set @TournamentId=SCOPE_IDENTITY()
	 
				insert Language.[Parameter.Tournament](TournamentId,LanguageId,TournamentName,SuperTournamentName) --values(@TournamentId,@LanId,@TournamentName,@SuperTournamentName)
				select @TournamentId,LanguageId,@TournamentName,@TournamentName from Language.Language with (nolock)
		 
	end

if (@HomeTeamId is null and @BetradarHomeTeamId is not null)
begin
	insert Parameter.Competitor(BetradarSuperId,CompetitorName)
			values (@BetradarHomeTeamId,Replace(@HomeTeam,'-',' '))
			
			set @HomeTeamId=SCOPE_IDENTITY()
			
					insert Language.ParameterCompetitor(CompetitorId,LanguageId,CompetitorName) --values (@compId,@lanId,@CompetitorName)
				select @HomeTeamId,Language.Language.LanguageId,Replace(@HomeTeam,'-',' ') from Language.Language with (nolock)
end

if (@AwayTeamId is null and @BetradarAwayTeamId is not null)
begin
	insert Parameter.Competitor(BetradarSuperId,CompetitorName)
			values (@BetradarAwayTeamId,Replace(@AwayTeam,'-',' '))
			
			set @AwayTeamId=SCOPE_IDENTITY()
			
					insert Language.ParameterCompetitor(CompetitorId,LanguageId,CompetitorName) --values (@compId,@lanId,@CompetitorName)
				select @AwayTeamId,Language.Language.LanguageId,Replace(@AwayTeam,'-',' ') from Language.Language with (nolock)
end

end


--insert [dbo].[tempLiveEvent] values(@BetradarSportId,@BetradarCategoryId,@BetradarTournamentId,@BetradarHomeTeamId,@BetradarAwayTeamId,@DateOfMatch,@BetradarMatchId)


if((@SportId is not null) and (@CategoryId is not null) and (@TournamentId is not null) and (@HomeTeamId is not null) and (@AwayTeamId is not null))
	begin
		
		
		if not exists (select [Live].[Event].EventId from [Live].[Event] with (nolock) where [Live].[Event].[BetradarMatchId]=@BetradarMatchId)
			begin
				INSERT INTO [Live].[Event]
				   (EventId,[BetradarMatchId]
				   ,[TournamentId]
				   ,[EventDate]
				   ,[HomeTeam]
				   ,[AwayTeam]
				   ,[EventStatu]
				   ,[IsActive]
				   ,[FeedStatu]
				   ,[ConnectionStatu])
			 VALUES
				   (@BetradarMatchId,@BetradarMatchId
				   ,@TournamentId
				   ,@DateOfMatch
				   ,@HomeTeamId
				   ,@AwayTeamId
				   ,1
				   ,0
				   ,2
				   ,2)
				
				set @LiveEventId=@BetradarMatchId
				

				  
				if(@DateOfMatch<DATEADD(Day,20,GETDATE()))
						execute [Betradar].[ProcMatchCodeCreate] @BetradarMatchId,@LiveEventId,1

 

				execute [Betradar].[Live.ProcEventTopOddInsert] @LiveEventId,@BetradarMatchId


			end
		else
			begin

			 select @LiveEventId=[Live].[Event].EventId from [Live].[Event] with (nolock) where [Live].[Event].[BetradarMatchId]=@BetradarMatchId
		
				update [Live].[Event]
				set [TournamentId]=@TournamentId
				   ,[EventDate]=@DateOfMatch
				   ,[HomeTeam]=@HomeTeamId
				   ,[AwayTeam]=@AwayTeamId
				   ,[FeedStatu] =2
				where [Live].[Event].EventId=@LiveEventId

					if(@DateOfMatch<DATEADD(Day,20,GETDATE()))
						execute [Betradar].[ProcMatchCodeCreate] @BetradarMatchId,@LiveEventId,1
			

			end
		
		
	end

	select @LiveEventId as LiveEventId

END


GO
