USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[ProcSport]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Betradar].[ProcSport]
@BetradarSportId int,
@SportName nvarchar(50),
@Language nvarchar(10)
AS
declare @SportId int
declare @LanId int=0
BEGIN


if not exists (select [Language].[Language].LanguageId from [Language].[Language] with (nolock) where [Language].[Language].[Language]=@Language)
			begin
				insert [Language].[Language] values(@Language,'',1)
				set @LanId=SCOPE_IDENTITY()
			end
		else
			select @LanId= [Language].[Language].LanguageId from [Language].[Language] with (nolock) where [Language].[Language].[Language]=@Language

if not exists(select Parameter.Sport.SportId from Parameter.Sport with (nolock) where Parameter.Sport.BetRadarSportId=@BetradarSportId)
	begin
		
		insert Parameter.Sport(BetRadarSportId,SportName,IsActive)
		values (@BetradarSportId,@SportName,1)
		
		set @SportId=SCOPE_IDENTITY()
		
		insert Language.[Parameter.Sport]
		select @SportId,[Language].[Language].LanguageId,@SportName
		from [Language].[Language] with (nolock)
		
	end
else
	begin
				select @SportId=Parameter.Sport.SportId from Parameter.Sport with (nolock) where Parameter.Sport.BetRadarSportId=@BetradarSportId
	if not exists (select Language.[Parameter.Sport].SportId from Language.[Parameter.Sport] where Language.[Parameter.Sport].SportId=@SportId and Language.[Parameter.Sport].LanguageId=@LanId)
		begin

			insert Language.[Parameter.Sport] values(@SportId,@LanId,@SportName)
		end
	--else
	--	begin
			--update Language.[Parameter.Sport] set SportName=@SportName where Language.[Parameter.Sport].SportId=@SportId and Language.[Parameter.Sport].LanguageId=@LanId
	--	end
		
	end
	
	select @SportId


END




GO
