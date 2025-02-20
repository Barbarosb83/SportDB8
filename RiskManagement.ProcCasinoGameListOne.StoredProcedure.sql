USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCasinoGameListOne]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [RiskManagement].[ProcCasinoGameListOne] 
@GameType nvarchar(20),
@GameId int
AS

BEGIN
SET NOCOUNT ON;


declare @sqlcommand nvarchar(max)
declare @sqlcommand2 nvarchar(max)

declare @total int 


declare @tempTable table (GameId int,GameType nvarchar(20),Title nvarchar(100),IsPopular bit,IsMobile bit,IsEnable bit,GameTypeId int,ParameterGameType nvarchar(30))




if (@GameType='Amatic')
	begin
		insert @tempTable
		select Casino.[RealGaming.AmaticGame].GameId,'Amatic',Casino.[RealGaming.AmaticGame].Title,
		Casino.[RealGaming.AmaticGame].IsPopular
		,Casino.[RealGaming.AmaticGame].IsMobile
		,Casino.[RealGaming.AmaticGame].IsEnable
		,[Casino].[Parameter.GameType].[ParameterGameTypeId]
		,[Casino].[Parameter.GameType].[GameType]
		from Casino.[RealGaming.AmaticGame] 
		INNER JOIN  [Casino].[Parameter.GameType] ON [Casino].[Parameter.GameType].[ParameterGameTypeId]=Casino.[RealGaming.AmaticGame].[ParameterGameTypeId] 
		where Casino.[RealGaming.AmaticGame].GameId=@GameId

	end
else if (@GameType='Netent')
	begin
		insert @tempTable
		select Casino.[RealGaming.NetentGame].GameId,'Netent',Casino.[RealGaming.NetentGame].Title,
		Casino.[RealGaming.NetentGame].IsPopular
		,Casino.[RealGaming.NetentGame].IsMobile
		,Casino.[RealGaming.NetentGame].IsEnable
		,[Casino].[Parameter.GameType].[ParameterGameTypeId]
		,[Casino].[Parameter.GameType].[GameType]
		from Casino.[RealGaming.NetentGame]
		INNER JOIN  [Casino].[Parameter.GameType] ON [Casino].[Parameter.GameType].[ParameterGameTypeId]=Casino.[RealGaming.NetentGame].[ParameterGameTypeId] 
		where Casino.[RealGaming.NetentGame].GameId=@GameId

	end
else if (@GameType='PlayTech')
	begin
		insert @tempTable
		select Casino.[RealGaming.PlayTech].GameId,'PlayTech',Casino.[RealGaming.PlayTech].Title,
		Casino.[RealGaming.PlayTech].IsPopular
		,Casino.[RealGaming.PlayTech].IsMobile
		,Casino.[RealGaming.PlayTech].IsEnable
		,[Casino].[Parameter.GameType].[ParameterGameTypeId]
		,[Casino].[Parameter.GameType].[GameType]
		from Casino.[RealGaming.PlayTech]
		INNER JOIN  [Casino].[Parameter.GameType] ON [Casino].[Parameter.GameType].[ParameterGameTypeId]=Casino.[RealGaming.PlayTech].[ParameterGameTypeId] 
		where Casino.[RealGaming.PlayTech].GameId=@GameId

	end
	else if (@GameType='SwissSoft')
	begin
		insert @tempTable
		select Casino.[SwissSoft.GameList].GameId,'SwissSoft',Casino.[SwissSoft.GameList].Title,
		Casino.[SwissSoft.GameList].IsPopular
		,Casino.[SwissSoft.GameList].IsMobile
		,Casino.[SwissSoft.GameList].IsEnable
		,[Casino].[Parameter.GameType].[ParameterGameTypeId]
		,[Casino].[Parameter.GameType].[GameType]
		from Casino.[SwissSoft.GameList]
		INNER JOIN  [Casino].[Parameter.GameType] ON [Casino].[Parameter.GameType].[ParameterGameTypeId]=Casino.[SwissSoft.GameList].[ParameterGameTypeId] 
		where Casino.[SwissSoft.GameList].GameId=@GameId

	end
	else if (@GameType='Spinmatic')
	begin
		insert @tempTable
		select [Casino].[Spinmatic.Game].GameId,'Spinmatic',[Casino].[Spinmatic.Game].Name as Title,
		[Casino].[Spinmatic.Game].IsPopular
		,[Casino].[Spinmatic.Game].IsMobile
		,[Casino].[Spinmatic.Game].IsEnable
		,[Casino].[Parameter.GameType].[ParameterGameTypeId]
		,[Casino].[Parameter.GameType].[GameType]
		from Casino.[Spinmatic.Game]
		INNER JOIN  [Casino].[Parameter.GameType] ON [Casino].[Parameter.GameType].[ParameterGameTypeId]=Casino.[Spinmatic.Game].[ParameterGameTypeId]
		where [Casino].[Spinmatic.Game].GameId=@GameId

	end
else if (@GameType='Xpress Gaming')
	begin
	 insert @tempTable
		select [Casino].[XprressGaming.Game].Id as GameId,'Xpress Gaming',[Casino].[XprressGaming.Game].Name as Title,
		[Casino].[XprressGaming.Game].IsPopular
		,[Casino].[XprressGaming.Game].IsMobile
		,[Casino].[XprressGaming.Game].IsEnable
		,[Casino].[Parameter.GameType].[ParameterGameTypeId]
		,[Casino].[Parameter.GameType].[GameType]
		from Casino.[XprressGaming.Game]
		INNER JOIN  [Casino].[Parameter.GameType] ON [Casino].[Parameter.GameType].[ParameterGameTypeId]=Casino.[XprressGaming.Game].[ParameterGameTypeId]
		where [Casino].[XprressGaming.Game].Id=@GameId

	end


select * from @tempTable


END



GO
