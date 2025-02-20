USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[ProcMatchFixtureDateInfo]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Betradar].[ProcMatchFixtureDateInfo]
@FixtureId bigint,
@BetradarTypeId int,
@TypeName nvarchar(50),
@Comment nvarchar(250),
@ConfirmedMatchStart datetime,
@MatchDate datetime,
@Language nvarchar(10)
AS


declare @TypeId int=0
declare @lanId int=0
declare @BetradarMatchId bigint
declare @MatchId bigint
select @lanId=Language.Language.LanguageId from Language.Language  with (nolock)  where Language.Language.Language=@Language

BEGIN


	if exists (select Parameter.DateInfoType.BetradarTypeId from Parameter.DateInfoType with (nolock) where Parameter.DateInfoType.BetradarTypeId=@BetradarTypeId)
			begin
				select @TypeId=Parameter.DateInfoType.DateInfoTypeId from Parameter.DateInfoType with (nolock) where Parameter.DateInfoType.BetradarTypeId=@BetradarTypeId

			end
	Else
		begin
			insert Parameter.DateInfoType (BetradarTypeId,TypeName)
			values (@BetradarTypeId,@TypeName)
			
			set @TypeId=SCOPE_IDENTITY()
			
		end
		
	
	if not exists (select Match.FixtureDateInfo.FixtureDateInfoId from Match.FixtureDateInfo with (nolock) where Match.FixtureDateInfo.FixtureId=@FixtureId and  LanguageId=@lanId)
		 begin
				insert Match.FixtureDateInfo(FixtureId,DateInfoTypeId,Comment,ConfirmedMatchStart,MatchDate,LanguageId) 
				values (@FixtureId,@TypeId,@Comment,@ConfirmedMatchStart,@MatchDate,@lanId)

				if(@MatchDate<DATEADD(DAY,20,GETDATE()))
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
			update Match.FixtureDateInfo
			set DateInfoTypeId=@TypeId,
			Comment=@Comment,
			ConfirmedMatchStart=@ConfirmedMatchStart,
			MatchDate=@MatchDate
			where FixtureId=@FixtureId and LanguageId=@lanId


			if(@MatchDate<DATEADD(DAY,20,GETDATE()))
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
