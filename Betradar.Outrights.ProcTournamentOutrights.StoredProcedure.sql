USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Outrights.ProcTournamentOutrights]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Betradar].[Outrights.ProcTournamentOutrights]
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
select @CategoryId=Parameter.Category.CategoryId from Parameter.Category with (nolock)
		where Parameter.Category.CategoryId=@BetradarCategoryId

if not exists (select [Language].[Language].LanguageId from [Language].[Language] with (nolock) where [Language].[Language]=@Language)
			begin
				insert [Language].[Language] values(@Language,'',1)
				set @LanId=SCOPE_IDENTITY()
			end
		else
			select @LanId= [Language].[Language].LanguageId from [Language].[Language] with (nolock) where [Language].[Language].[Language]=@Language

if not exists (select Parameter.TournamentOutrights.TournamentId from Parameter.TournamentOutrights with (nolock) where Parameter.TournamentOutrights.BetradarTournamentId=@BetradarTournamentId and CategoryId=@CategoryId  )
	begin
	 
		
		
		insert Parameter.TournamentOutrights(BetradarTournamentId,CategoryId,TournamentName,BetradarUnigueId,IsActive)
		values (@BetradarTournamentId,@CategoryId,@TournamentName,@BetradarUnigueId,1)
		
		set @TournamentId=SCOPE_IDENTITY()
		if(@SuperTournamentName is not null)
			begin
				insert Language.[Parameter.TournamentOutrights](TournamentId,LanguageId,TournamentName,SuperTournamentName) --values(@TournamentId,@LanId,@TournamentName,@SuperTournamentName)
				select @TournamentId,LanguageId,@TournamentName,@SuperTournamentName from [Language].[Language] with (nolock)
			end
		else
			begin
				insert Language.[Parameter.TournamentOutrights](TournamentId,LanguageId,TournamentName,SuperTournamentName) --values(@TournamentId,@LanId,@TournamentName,@SuperTournamentName)
				select @TournamentId,LanguageId,@TournamentName,@TournamentName from [Language].[Language] with (nolock)
			end
		
	end
else
	begin
				select @TournamentId=Parameter.TournamentOutrights.TournamentId from Parameter.TournamentOutrights with (nolock)
				 where Parameter.TournamentOutrights.BetradarTournamentId=@BetradarTournamentId and CategoryId=@CategoryId

				update Parameter.TournamentOutrights set BetradarUnigueId=@BetradarUnigueId where TournamentId=@TournamentId
	if not exists (select Language.[Parameter.TournamentOutrights].TournamentId  from Language.[Parameter.TournamentOutrights] with (nolock) where Language.[Parameter.TournamentOutrights].TournamentId=@TournamentId and Language.[Parameter.TournamentOutrights].LanguageId=@LanId)
		begin
			
			insert Language.[Parameter.TournamentOutrights](TournamentId,LanguageId,TournamentName,SuperTournamentName) values(@TournamentId,@LanId,@TournamentName,@SuperTournamentName)
		end
		else
			begin
				if(select COUNT(Language.[Parameter.TournamentOutrights].ParameterTournamentId) from Language.[Parameter.TournamentOutrights] with (nolock) where Language.[Parameter.TournamentOutrights].TournamentId=@TournamentId and Language.[Parameter.TournamentOutrights].LanguageId=@LanId and Language.[Parameter.TournamentOutrights].TournamentName=@TournamentName and Language.[Parameter.TournamentOutrights].SuperTournamentName=@SuperTournamentName)=0
					begin
						if(@SuperTournamentName is not null)
							update Language.[Parameter.TournamentOutrights] set SuperTournamentName=@SuperTournamentName,TournamentName=@TournamentName where TournamentId=@TournamentId and LanguageId=@LanId
						else
							update Language.[Parameter.TournamentOutrights] set  TournamentName=@TournamentName where TournamentId=@TournamentId and LanguageId=@LanId
					end
			end
		
	end
 return @TournamentId


END


GO
