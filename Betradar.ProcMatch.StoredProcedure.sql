USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[ProcMatch]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 
CREATE PROCEDURE [Betradar].[ProcMatch]
@BetradarTournamentId bigint,
@BetradarMatchId bigint,
@MonitoringMatchId bigint,
@TimeStamp datetime,
@BetradarSportId bigint,
@BetradarCategoryId bigint
AS

Declare @TempTournamentId bigint=0
Declare @TempMonitoringMatchId bigint=0
declare @TournamentId int=0
declare @SportId int
declare @CategoryId int
declare @MatchId bigint=0
BEGIN

 

if Not Exists (select Match.Match.MatchId from Match.Match with (nolock) where Match.Match.BetradarMatchId=@BetradarMatchId)
	begin
		if Not Exists (select  Archive.Match.MatchId from Archive.Match with (nolock) where Archive.Match.BetradarMatchId=@BetradarMatchId)
		begin
			select @SportId=Parameter.Sport.SportId from Parameter.Sport with (nolock) where Parameter.Sport.BetRadarSportId=@BetradarSportId
select @CategoryId=Parameter.Category.CategoryId from Parameter.Category with (nolock) where Parameter.Category.BetradarCategoryId=@BetradarCategoryId
select top 1 @TournamentId=Parameter.Tournament.TournamentId from Parameter.Tournament with (nolock) INNER JOIN Parameter.Category with (nolock) On Parameter.Category.CategoryId=Parameter.Tournament.CategoryId
where Parameter.Tournament.NewBetradarId=@BetradarTournamentId and Parameter.Category.SportId=@SportId and Parameter.Category.CategoryId=@CategoryId
			
			if(@TournamentId=30879)
				set @TournamentId=1125
			
			if (@TournamentId>0)
			insert Match.Match(MatchId,TournamentId,BetradarMatchId,MonitoringMatchId,[TimeStamp])
			values(@BetradarMatchId,@TournamentId,@BetradarMatchId,@BetradarTournamentId,@TimeStamp)
			
			set @MatchId=@BetradarMatchId
			
				


		 
		end
		else
			begin


		 insert Match.Match(MatchId,TournamentId,BetradarMatchId,MonitoringMatchId,[TimeStamp])
			select MatchId,TournamentId,BetradarMatchId,MonitoringMatchId,[TimeStamp]
					from Archive.Match with (nolock) where 
					Archive.Match.MatchId=@BetradarMatchId

					set @MatchId=@BetradarMatchId
					
					delete from Archive.Match where MatchId=@MatchId
			end
	end
else
	begin
	select @SportId=Parameter.Sport.SportId from Parameter.Sport with (nolock) where Parameter.Sport.BetRadarSportId=@BetradarSportId
select @CategoryId=Parameter.Category.CategoryId from Parameter.Category with (nolock) where Parameter.Category.BetradarCategoryId=@BetradarCategoryId
select top 1 @TournamentId=Parameter.Tournament.TournamentId from Parameter.Tournament with (nolock) INNER JOIN Parameter.Category with (nolock) On Parameter.Category.CategoryId=Parameter.Tournament.CategoryId
where Parameter.Tournament.NewBetradarId=@BetradarTournamentId and Parameter.Category.SportId=@SportId and Parameter.Category.CategoryId=@CategoryId

		 	if(@TournamentId=30879)
				set @TournamentId=1125
		
		select @MatchId=Match.MatchId,@TempTournamentId=Match.Match.TournamentId,@TempMonitoringMatchId=Match.Match.MonitoringMatchId
		from Match.Match with (nolock) where Match.BetradarMatchId=@BetradarMatchId
		--if exists (select MatchId from Match.Setting with (nolock) where MatchId=@MatchId and StateId=1)
		--			update Match.Setting set StateId=2 where MatchId=@MatchId
		 
		
	--	if(@TempMonitoringMatchId<>@MonitoringMatchId)
			update Match.Match set MonitoringMatchId=@MonitoringMatchId,TournamentId=@TournamentId,[TimeStamp]=@TimeStamp
			where BetradarMatchId=@BetradarMatchId		
			
				
	end

	return @MatchId

END


GO
