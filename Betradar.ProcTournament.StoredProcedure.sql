USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[ProcTournament]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 

CREATE PROCEDURE [Betradar].[ProcTournament]
@BetradarTournamentId bigint,
@BetradarUnigueId bigint,
@BetradarCategoryId bigint,
@Language nvarchar(10),
@TournamentName nvarchar(50),
@SuperTournamentName nvarchar(50)
AS

Declare @TournamentId int=0
Declare @ParameterLangId int=0
declare @IsoId int=0
declare @CategoryId int=0
declare @LanId int=0

BEGIN


if not exists (select Language.Language.LanguageId from Language.Language with (nolock) where Language.Language=@Language)
			begin
				insert Language.Language values(@Language,'',1)
				set @LanId=SCOPE_IDENTITY()
			end
		else
			select @LanId= Language.Language.LanguageId from Language.Language with (nolock) where Language.Language=@Language

if not exists(select Parameter.Tournament.TournamentId from Parameter.Tournament with (nolock) where Parameter.Tournament.NewBetradarId=@BetradarTournamentId )
	begin
		select @CategoryId=Parameter.Category.CategoryId from Parameter.Category with (nolock)
		where Parameter.Category.BetradarCategoryId=@BetradarCategoryId
		
		
		insert Parameter.Tournament(BetradarTournamentId,CategoryId,TournamentName,BetradarUnigueId,IsActive,TerminalTournamentId,NewBetradarId)
		values (@BetradarTournamentId,@CategoryId,@TournamentName,@BetradarUnigueId,1,@BetradarTournamentId,@BetradarTournamentId)
		
		set @TournamentId=SCOPE_IDENTITY()
		if(@SuperTournamentName is not null)
			begin
				insert Language.[Parameter.Tournament](TournamentId,LanguageId,TournamentName,SuperTournamentName) --values(@TournamentId,@LanId,@TournamentName,@SuperTournamentName)
				select @TournamentId,LanguageId,@TournamentName,@SuperTournamentName from Language.Language with (nolock)
			end
		else
			begin
				insert Language.[Parameter.Tournament](TournamentId,LanguageId,TournamentName,SuperTournamentName) --values(@TournamentId,@LanId,@TournamentName,@SuperTournamentName)
				select @TournamentId,LanguageId,@TournamentName,@TournamentName from Language.Language with (nolock)
			end
		
	end
else
	begin
				select top 1 @TournamentId=Parameter.Tournament.TournamentId from Parameter.Tournament with (nolock) where Parameter.Tournament.NewBetradarId=@BetradarTournamentId
				update Parameter.Tournament set BetradarUnigueId=@BetradarUnigueId where TournamentId=@TournamentId
	if not exists(select Language.[Parameter.Tournament].TournamentId from Language.[Parameter.Tournament] with (nolock) where Language.[Parameter.Tournament].TournamentId=@TournamentId and Language.[Parameter.Tournament].LanguageId=@LanId)
		begin
			
			insert Language.[Parameter.Tournament](TournamentId,LanguageId,TournamentName,SuperTournamentName) 
			select @TournamentId,Language.Language.LanguageId,@TournamentName,@SuperTournamentName
		from Language.Language with (nolock)
		where Language.Language.LanguageId not in (select Language.[Parameter.Tournament].LanguageId from Language.[Parameter.Tournament] with (nolock) where Language.[Parameter.Tournament].TournamentId=@TournamentId)
			
		end
		--else
		--	begin
		--		if not exists (select Language.[Parameter.Tournament].ParameterTournamentId from Language.[Parameter.Tournament] with (nolock) where Language.[Parameter.Tournament].TournamentId=@TournamentId and Language.[Parameter.Tournament].LanguageId=@LanId and Language.[Parameter.Tournament].TournamentName=@TournamentName and Language.[Parameter.Tournament].SuperTournamentName=@SuperTournamentName)
		--			begin
		--				if(@SuperTournamentName is not null)
		--					update Language.[Parameter.Tournament] set SuperTournamentName=@SuperTournamentName,TournamentName=@TournamentName where TournamentId=@TournamentId and LanguageId=@LanId
		--				else
		--					update Language.[Parameter.Tournament] set SuperTournamentName=@TournamentName,TournamentName=@TournamentName where TournamentId=@TournamentId and LanguageId=@LanId
		--			end
		--	end
		
	end
 return @TournamentId

END




GO
