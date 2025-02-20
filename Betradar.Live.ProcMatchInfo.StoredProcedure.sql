USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Live.ProcMatchInfo]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Betradar].[Live.ProcMatchInfo]
@BetradarSportId bigint,
@BetradarCategoryId bigint,
@BetradarTournamentId  bigint,
@BetradarHomeTeamId bigint,
@BetradarAwayTeamId bigint,
@DateOfMatch datetime,
@BetradarMatchId bigint

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

if @SportId=1
begin
if @TournamentId is null
	set @TournamentId=7928

if @CategoryId is null
	set @CategoryId=375
end
else if @SportId=17
begin
if @TournamentId is null
	set @TournamentId=8596

if @CategoryId is null
	set @CategoryId=379
end

--if @SportId=1
--		INSERT INTO [Live].[Score]
--					       ([BetradarMatchId],[Score],ScoreTime)
--						VALUES (@BetradarMAtchId,'0:0',1)
 

 --insert dbo.betslip values (@BetradarMatchId,'[Live.ProcMatchInfo]',GETDATE())

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
				

				 
				if(@DateOfMatch<DATEADD(DAY,20,GETDATE()))
						execute [Betradar].[ProcMatchCodeCreate] @BetradarMatchId,@LiveEventId,1


			 
				--if(@DateOfMatch<DATEADD(DAY,20,GETDATE()))
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

					if(@DateOfMatch<DATEADD(DAY,20,GETDATE()))
						execute [Betradar].[ProcMatchCodeCreate] @BetradarMatchId,@LiveEventId,1
			

			end
		
		
	end

	select @LiveEventId as LiveEventId

END


GO
