USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[ProcCategory]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Betradar].[ProcCategory]
@BetradarCategoryId bigint,
@BetradarIsoId bigint,
@BetradarSportId int,
@Language nvarchar(10),
@CategoryName nvarchar(50)
AS

Declare @SportId int=0
Declare @ParameterLangId int=0
declare @IsoId int=0
declare @CategoryId int=0
declare @LanId int=0
BEGIN


if not exists (select [Language].[Language].LanguageId from [Language].[Language] with (nolock) where [Language].[Language].Language=@Language)
			begin
				insert [Language].[Language] values(@Language,'',1)
				set @LanId=SCOPE_IDENTITY()
			end
		else
			select @LanId= [Language].[Language].LanguageId from [Language].[Language] with (nolock) where [Language].[Language].Language=@Language

if not exists (select Parameter.Category.BetradarCategoryId from Parameter.Category with (nolock) where Parameter.Category.BetradarCategoryId=@BetradarCategoryId)
	begin
		select @SportId=Parameter.Sport.SportId from Parameter.Sport  with (nolock)
		where Parameter.Sport.BetRadarSportId=@BetradarSportId
		
		select @IsoId=Parameter.Iso.IsoId from Parameter.Iso with (nolock) where Parameter.Iso.BetradarIsoId=@BetradarIsoId
		if(@IsoId is null)
			set @IsoId=0
		insert Parameter.Category(BetradarCategoryId,IsoId,CategoryName,SportId,IsActive,SequenceNumber)
		values (@BetradarCategoryId,@IsoId,@CategoryName,@SportId,1,999)
		
		set @CategoryId=SCOPE_IDENTITY()
		
		insert Language.[Parameter.Category]
		select @CategoryId,Language.Language.LanguageId,@CategoryName
		from [Language].[Language] with (nolock)
		
		
	end
else
	begin
				select @CategoryId=Parameter.Category.CategoryId from Parameter.Category with (nolock) where Parameter.Category.BetradarCategoryId=@BetradarCategoryId
	if not exists (select Language.[Parameter.Category].CategoryId from Language.[Parameter.Category] with (nolock) where Language.[Parameter.Category].CategoryId=@CategoryId and Language.[Parameter.Category].LanguageId=@LanId)
		begin

			insert Language.[Parameter.Category] 
			select @CategoryId,Language.Language.LanguageId,@CategoryName
		from [Language].[Language] with (nolock)
		where [Language].[Language].LanguageId not in (select Language.[Parameter.Category].LanguageId from Language.[Parameter.Category] with (nolock) where Language.[Parameter.Category].CategoryId=@CategoryId)
		end
	--else
	--	begin
	--		update Language.[Parameter.Category] set CategoryName=@CategoryName where Language.[Parameter.Category].CategoryId=@CategoryId and Language.[Parameter.Category].LanguageId=@LanId
	--	end
		
	end
 return @CategoryId

END




GO
