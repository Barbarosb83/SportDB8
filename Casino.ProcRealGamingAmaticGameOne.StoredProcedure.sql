USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Casino].[ProcRealGamingAmaticGameOne]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [Casino].[ProcRealGamingAmaticGameOne]
@GameId bigint,
@CasinoType nvarchar(20)


AS




BEGIN
SET NOCOUNT ON;

if(@CasinoType='rgamatic')
Begin
Select Casino.[RealGaming.AmaticGame].GameId,Casino.[RealGaming.AmaticGame].Name,Casino.[RealGaming.AmaticGame].Title,
Casino.[RealGaming.AmaticGame].Img,Casino.[RealGaming.AmaticGame].GameUrl
From Casino.[RealGaming.AmaticGame]
where Casino.[RealGaming.AmaticGame].GameId=@GameId
end
else if (@CasinoType='rgnetent')
begin
	Select Casino.[RealGaming.NetentGame].GameId,Casino.[RealGaming.NetentGame].Name,Casino.[RealGaming.NetentGame].Title,
Casino.[RealGaming.NetentGame].Img,Casino.[RealGaming.NetentGame].GameUrl
From Casino.[RealGaming.NetentGame]
where Casino.[RealGaming.NetentGame].GameId=@GameId
end
else if (@CasinoType='rgplaytech')
begin
	Select Casino.[RealGaming.Playtech].GameId,Casino.[RealGaming.Playtech].Name,Casino.[RealGaming.Playtech].Title,
Casino.[RealGaming.Playtech].Img,Casino.[RealGaming.Playtech].GameUrl
From Casino.[RealGaming.Playtech]
where Casino.[RealGaming.Playtech].GameId=@GameId
end
else if (@CasinoType='swisssoft')
begin
	Select Casino.[SwissSoft.GameList].GameId,Casino.[SwissSoft.GameList].Name,Casino.[SwissSoft.GameList].Title,
Casino.[SwissSoft.GameList].Img,Casino.[SwissSoft.GameList].GameUrl
From Casino.[SwissSoft.GameList]
where Casino.[SwissSoft.GameList].GameId=@GameId
end

END


GO
