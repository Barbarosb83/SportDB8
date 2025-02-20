USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Lsports].[ProcMatchFixtureDateInfo]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Lsports].[ProcMatchFixtureDateInfo]
@FixtureId bigint,
@MatchDate datetime,
@Language nvarchar(10)
AS


declare @TypeId int=1
declare @lanId int=0
declare @BetradarMatchId bigint
declare @MatchId bigint
select @lanId=Language.Language.LanguageId from Language.Language where Language.Language.Language=@Language

BEGIN

	
		
	
	if not exists (select Match.FixtureDateInfo.FixtureDateInfoId from Match.FixtureDateInfo with (nolock) where Match.FixtureDateInfo.FixtureId=@FixtureId and  LanguageId=@lanId)
		if not exists (select Archive.FixtureDateInfo.FixtureDateInfoId from Archive.FixtureDateInfo with (nolock) where Archive.FixtureDateInfo.FixtureId=@FixtureId and  LanguageId=@lanId)
			begin
				insert Match.FixtureDateInfo(FixtureId,DateInfoTypeId,Comment,ConfirmedMatchStart,MatchDate,LanguageId) 
				values (@FixtureId,@TypeId,'',null,@MatchDate,@lanId)

				if(@MatchDate<DATEADD(WEEK,2,GETDATE()))
				begin
					select @BetradarMatchId= Match.BetradarMatchId,@MatchId=Match.Match.MatchId  from Match.Match with (nolock) 
					INNER JOIN Match.Fixture with (nolock) On Match.Fixture.MatchId=Match.MatchId 
					where Match.Fixture.FixtureId=@FixtureId

					if (@BetradarMatchId is not null and @MatchId is not null)
						execute [Betradar].[ProcMatchCodeCreate] @BetradarMatchId,@MatchId,0

				end

			end
		else
			begin
				update Archive.FixtureDateInfo
			set DateInfoTypeId=@TypeId,
			MatchDate=@MatchDate
			where FixtureId=@FixtureId and LanguageId=@lanId
			end
	else
		begin
			update Match.FixtureDateInfo
			set DateInfoTypeId=@TypeId,
			MatchDate=@MatchDate
			where FixtureId=@FixtureId and LanguageId=@lanId


			if(@MatchDate<DATEADD(WEEK,2,GETDATE()))
				begin
					select @BetradarMatchId= Match.BetradarMatchId,@MatchId=Match.Match.MatchId  from Match.Match with (nolock) 
					INNER JOIN Match.Fixture with (nolock) On Match.Fixture.MatchId=Match.MatchId 
					where Match.Fixture.FixtureId=@FixtureId

					if (@BetradarMatchId is not null and @MatchId is not null)
						execute [Betradar].[ProcMatchCodeCreate] @BetradarMatchId,@MatchId,0

				end
			
		end	
	
	

END


GO
