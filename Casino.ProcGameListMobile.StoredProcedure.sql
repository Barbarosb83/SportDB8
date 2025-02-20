USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Casino].[ProcGameListMobile]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [Casino].[ProcGameListMobile]
@GameTypeId int


AS




BEGIN
SET NOCOUNT ON;

if(@GameTypeId=0)
begin
--Select [Casino].[RealGaming.NetentGame].GameId,[Casino].[RealGaming.NetentGame].Name,[Casino].[RealGaming.NetentGame].Title,
--[Casino].[RealGaming.NetentGame].Img,[Casino].[RealGaming.NetentGame].GameUrl,[Casino].[RealGaming.NetentGame].ParameterGameTypeId,'rgnetent' as CasinoType 
--From [Casino].[RealGaming.NetentGame]
--where IsPopular=1 and IsMobile=1
--UNION ALL
--Select Casino.[RealGaming.AmaticGame].GameId,Casino.[RealGaming.AmaticGame].Name,Casino.[RealGaming.AmaticGame].Title,
--Casino.[RealGaming.AmaticGame].Img,Casino.[RealGaming.AmaticGame].GameUrl,Casino.[RealGaming.AmaticGame].ParameterGameTypeId,'rgamatic' as CasinoType 
--From Casino.[RealGaming.AmaticGame]
--where IsPopular=1  and IsMobile=1
--UNION ALL
Select   [Casino].[SwissSoft.GameList].GameId,[Casino].[SwissSoft.GameList].Name,[Casino].[SwissSoft.GameList].Title,
[Casino].[SwissSoft.GameList].Img,[Casino].[SwissSoft.GameList].GameUrl,[Casino].[SwissSoft.GameList].ParameterGameTypeId,'swisssoft' as CasinoType 
From [Casino].[SwissSoft.GameList]
where IsPopular=1 and IsMobile=1 and IsEnable=1 and IsMobile=1
UNION ALL
Select  [Casino].[Spinmatic.Game].GameId,[Casino].[Spinmatic.Game].Name,[Casino].[Spinmatic.Game].FriendlyName as Title,
'Spinmatic/'+cast([Casino].[Spinmatic.Game].GameId as nvarchar(30))+'_s.jpg' as Img,'' as GameUrl,[Casino].[Spinmatic.Game].ParameterGameTypeId,'spinmatic' as CasinoType 
From [Casino].[Spinmatic.Game]
where IsPopular=1 and IsEnable=1 and IsMobile=1
UNION ALL
Select  [Casino].[XprressGaming.Game].GameId,[Casino].[XprressGaming.Game].Name,[Casino].[XprressGaming.Game].FriendlyName as Title,
IMG as Img,cast([ProviderId] as nvarchar(10)) as GameUrl,[Casino].[XprressGaming.Game].ParameterGameTypeId,'xpressgaming' as CasinoType 
From [Casino].[XprressGaming.Game]
where IsPopular=1 and IsEnable=1 and IsMobile=1

--UNION ALL
--Select Casino.[LuckyStreak.Game].Id as GameId
--,Casino.[LuckyStreak.Game].GameName as Name
--,Casino.[LuckyStreak.Game].GameName as Title
--,Casino.[LuckyStreak.GameDealer].AvatarUrl as Img
--,Casino.[LuckyStreak.Game].LaunchUrl as GameUrl
--,Casino.[LuckyStreak.Game].ParameterGameTypeId
--,'LS' as CasinoType 
--From Casino.[LuckyStreak.Game] INNER JOIN
--Casino.[LuckyStreak.GameDealer] ON 
--Casino.[LuckyStreak.GameDealer].GameDealerId=Casino.[LuckyStreak.Game].GameDealerId INNER JOIN
--Casino.[LuckyStreak.ParameterGameType] ON
--Casino.[LuckyStreak.ParameterGameType].GameTypeId=Casino.[LuckyStreak.Game].GameTypeId
--where Casino.[LuckyStreak.Game].GameId in (select Distinct GameId from [Casino].[LuckyStreak.LimitGroup])


end
else
begin
if(@GameTypeId<>4)
begin
--Select [Casino].[RealGaming.NetentGame].GameId,[Casino].[RealGaming.NetentGame].Name,[Casino].[RealGaming.NetentGame].Title,
--[Casino].[RealGaming.NetentGame].Img,[Casino].[RealGaming.NetentGame].GameUrl,[Casino].[RealGaming.NetentGame].ParameterGameTypeId,'rgnetent' as CasinoType 
--From [Casino].[RealGaming.NetentGame]
--where Casino.[RealGaming.NetentGame].ParameterGameTypeId=@GameTypeId  and IsMobile=1
--UNION ALL
--Select Casino.[RealGaming.AmaticGame].GameId,Casino.[RealGaming.AmaticGame].Name,Casino.[RealGaming.AmaticGame].Title,
--Casino.[RealGaming.AmaticGame].Img,Casino.[RealGaming.AmaticGame].GameUrl,Casino.[RealGaming.AmaticGame].ParameterGameTypeId,'rgamatic' as CasinoType 
--From Casino.[RealGaming.AmaticGame]
--where Casino.[RealGaming.AmaticGame].ParameterGameTypeId=@GameTypeId  and IsMobile=1
--UNION ALL
--Select Casino.[LuckyStreak.Game].Id as GameId
--,Casino.[LuckyStreak.Game].GameName as Name
--,Casino.[LuckyStreak.Game].GameName as Title
--,Casino.[LuckyStreak.GameDealer].AvatarUrl as Img
--,Casino.[LuckyStreak.Game].LaunchUrl as GameUrl
--,Casino.[LuckyStreak.Game].ParameterGameTypeId
--,'LS' as CasinoType 
--From Casino.[LuckyStreak.Game] INNER JOIN
--Casino.[LuckyStreak.GameDealer] ON 
--Casino.[LuckyStreak.GameDealer].GameDealerId=Casino.[LuckyStreak.Game].GameDealerId INNER JOIN
--Casino.[LuckyStreak.ParameterGameType] ON
--Casino.[LuckyStreak.ParameterGameType].GameTypeId=Casino.[LuckyStreak.Game].GameTypeId
--where Casino.[LuckyStreak.Game].GameId in (select Distinct GameId from [Casino].[LuckyStreak.LimitGroup])
--AND Casino.[LuckyStreak.Game].ParameterGameTypeId=@GameTypeId
--UNION ALL
Select   [Casino].[SwissSoft.GameList].GameId,[Casino].[SwissSoft.GameList].Name,[Casino].[SwissSoft.GameList].Title,
[Casino].[SwissSoft.GameList].Img,[Casino].[SwissSoft.GameList].GameUrl,[Casino].[SwissSoft.GameList].ParameterGameTypeId,'swisssoft' as CasinoType 
From [Casino].[SwissSoft.GameList]
where ParameterGameTypeId=@GameTypeId and IsMobile=1 and IsEnable=1
UNION ALL
Select  [Casino].[Spinmatic.Game].GameId,[Casino].[Spinmatic.Game].Name,[Casino].[Spinmatic.Game].FriendlyName as Title,
'Spinmatic/'+cast([Casino].[Spinmatic.Game].GameId as nvarchar(30))+'_s.jpg' as Img,'' as GameUrl,[Casino].[Spinmatic.Game].ParameterGameTypeId,'spinmatic' as CasinoType 
From [Casino].[Spinmatic.Game]
where IsPopular=1 and IsEnable=1 and IsMobile=1 and  ParameterGameTypeId=@GameTypeId 
UNION ALL
Select  [Casino].[XprressGaming.Game].GameId,[Casino].[XprressGaming.Game].Name,[Casino].[XprressGaming.Game].FriendlyName as Title,
IMG as Img,cast([ProviderId] as nvarchar(10)) as GameUrl,[Casino].[XprressGaming.Game].ParameterGameTypeId,'xpressgaming' as CasinoType 
From [Casino].[XprressGaming.Game]
where IsPopular=1 and IsEnable=1 and IsMobile=1 and  ParameterGameTypeId=@GameTypeId 
end
else
begin
--Select [Casino].[RealGaming.NetentGame].GameId,[Casino].[RealGaming.NetentGame].Name,[Casino].[RealGaming.NetentGame].Title,
--[Casino].[RealGaming.NetentGame].Img,[Casino].[RealGaming.NetentGame].GameUrl,[Casino].[RealGaming.NetentGame].ParameterGameTypeId,'rgnetent' as CasinoType 
--From [Casino].[RealGaming.NetentGame]
--where Casino.[RealGaming.NetentGame].ParameterGameTypeId in (4,5)  and IsMobile=1
--UNION ALL
--Select Casino.[RealGaming.AmaticGame].GameId,Casino.[RealGaming.AmaticGame].Name,Casino.[RealGaming.AmaticGame].Title,
--Casino.[RealGaming.AmaticGame].Img,Casino.[RealGaming.AmaticGame].GameUrl,Casino.[RealGaming.AmaticGame].ParameterGameTypeId,'rgamatic' as CasinoType 
--From Casino.[RealGaming.AmaticGame]
--where Casino.[RealGaming.AmaticGame].ParameterGameTypeId in (4,5)  and IsMobile=1
--UNION ALL
--Select Casino.[LuckyStreak.Game].Id as GameId
--,Casino.[LuckyStreak.Game].GameName as Name
--,Casino.[LuckyStreak.Game].GameName as Title
--,Casino.[LuckyStreak.GameDealer].AvatarUrl as Img
--,Casino.[LuckyStreak.Game].LaunchUrl as GameUrl
--,Casino.[LuckyStreak.Game].ParameterGameTypeId
--,'LS' as CasinoType 
--From Casino.[LuckyStreak.Game] INNER JOIN
--Casino.[LuckyStreak.GameDealer] ON 
--Casino.[LuckyStreak.GameDealer].GameDealerId=Casino.[LuckyStreak.Game].GameDealerId INNER JOIN
--Casino.[LuckyStreak.ParameterGameType] ON
--Casino.[LuckyStreak.ParameterGameType].GameTypeId=Casino.[LuckyStreak.Game].GameTypeId
--where Casino.[LuckyStreak.Game].GameId in (select Distinct GameId from [Casino].[LuckyStreak.LimitGroup])
--AND Casino.[LuckyStreak.Game].ParameterGameTypeId=@GameTypeId
----UNION ALL
Select  [Casino].[SwissSoft.GameList].GameId,[Casino].[SwissSoft.GameList].Name,[Casino].[SwissSoft.GameList].Title,
[Casino].[SwissSoft.GameList].Img,[Casino].[SwissSoft.GameList].GameUrl,[Casino].[SwissSoft.GameList].ParameterGameTypeId,'swisssoft' as CasinoType 
From [Casino].[SwissSoft.GameList]
where ParameterGameTypeId in (4,5)  and IsMobile=1 and IsEnable=1
UNION ALL
Select  [Casino].[Spinmatic.Game].GameId,[Casino].[Spinmatic.Game].Name,[Casino].[Spinmatic.Game].FriendlyName as Title,
'Spinmatic/'+cast([Casino].[Spinmatic.Game].GameId as nvarchar(30))+'_s.jpg' as Img,'' as GameUrl,[Casino].[Spinmatic.Game].ParameterGameTypeId,'spinmatic' as CasinoType 
From [Casino].[Spinmatic.Game]
where IsPopular=1 and IsEnable=1 and IsMobile=1 and  ParameterGameTypeId in (4,5) 
UNION ALL
Select  [Casino].[XprressGaming.Game].GameId,[Casino].[XprressGaming.Game].Name,[Casino].[XprressGaming.Game].FriendlyName as Title,
IMG as Img,cast([ProviderId] as nvarchar(10)) as GameUrl,[Casino].[XprressGaming.Game].ParameterGameTypeId,'xpressgaming' as CasinoType 
From [Casino].[XprressGaming.Game] 
where IsPopular=1 and IsEnable=1 and IsMobile=1 and  ParameterGameTypeId in (4,5) 
end
end


END



GO
