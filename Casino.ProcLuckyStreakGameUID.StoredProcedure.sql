USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Casino].[ProcLuckyStreakGameUID]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Casino].[ProcLuckyStreakGameUID]
@GameId bigint,
@DealerName nvarchar(150),
@AvatarUrl nvarchar(max),
@ThumbnailAvatarURL nvarchar(max),
@GameName nvarchar(150),
@GameType nvarchar(150),
@IsOpen bit,
@LaunchUrl nvarchar(max),
@OpenHour nvarchar(10),
@CloseHour nvarchar(10)


AS

declare @GameDealerId bigint
declare @GameTypeId int 

BEGIN
SET NOCOUNT ON;


select @GameTypeId=Casino.[LuckyStreak.ParameterGameType].GameTypeId
from Casino.[LuckyStreak.ParameterGameType]
where Casino.[LuckyStreak.ParameterGameType].GameType=@GameType

if exists (Select Casino.[LuckyStreak.GameDealer].GameDealerId from Casino.[LuckyStreak.GameDealer] where Casino.[LuckyStreak.GameDealer].Name=@DealerName)
	begin
		select @GameDealerId=Casino.[LuckyStreak.GameDealer].GameDealerId
		from Casino.[LuckyStreak.GameDealer]
		where Casino.[LuckyStreak.GameDealer].Name=@DealerName
		
		update Casino.[LuckyStreak.GameDealer] set 
		AvatarUrl=@AvatarUrl
		,ThumbnailAvatarURL=@ThumbnailAvatarURL
		where GameDealerId=@GameDealerId
	
	end
else
	begin
		insert Casino.[LuckyStreak.GameDealer] (Name,AvatarUrl,ThumbnailAvatarURL)
		values (@DealerName,@AvatarUrl,@ThumbnailAvatarURL)
		set @GameDealerId=SCOPE_IDENTITY()
	end


if exists (select Casino.[LuckyStreak.Game].Id from Casino.[LuckyStreak.Game] where Casino.[LuckyStreak.Game].GameId=@GameId)
	begin
		
	
	
		update Casino.[LuckyStreak.Game] set 
		GameName=@GameName
		,GameTypeId=@GameTypeId
		,IsOpen=@IsOpen
		,LaunchUrl=@LaunchUrl
		,OpenHour=@OpenHour
		,CloseHour=@CloseHour
		,GameDealerId=@GameDealerId
		where Casino.[LuckyStreak.Game].GameId=@GameId
	
	end
else
	begin
		insert Casino.[LuckyStreak.Game] (GameId,GameName,GameTypeId,IsOpen,LaunchUrl,OpenHour,CloseHour,GameDealerId)
		values (@GameId,@GameName,@GameTypeId,@IsOpen,@LaunchUrl,@OpenHour,@CloseHour,@GameDealerId)
	end


END


GO
