USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCasinoGameList]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [RiskManagement].[ProcCasinoGameList] 
@GameType nvarchar(20),
 @PageSize  INT,
 @PageNum int,
@Username nvarchar(50),
@where nvarchar(1000),
@orderby nvarchar(100)
AS

BEGIN
SET NOCOUNT ON;

declare @sqlcommand0 nvarchar(max)
declare @sqlcommand1 nvarchar(max)
declare @sqlcommand nvarchar(max)
declare @sqlcommand2 nvarchar(max)

declare @total int 


set @sqlcommand0=' declare @tempTable table (GameId int,GameType nvarchar(20),Title nvarchar(100),IsPopular bit,IsMobile bit,IsEnable bit,GameTypeId int,ParameterGameType nvarchar(30))'




if (@GameType='Amatic')
	begin
set @sqlcommand1='insert @tempTable
		select Casino.[RealGaming.AmaticGame].GameId,''Amatic'',Casino.[RealGaming.AmaticGame].Title,
		Casino.[RealGaming.AmaticGame].IsPopular
		,Casino.[RealGaming.AmaticGame].IsMobile
		,Casino.[RealGaming.AmaticGame].IsEnable
		,[Casino].[Parameter.GameType].[ParameterGameTypeId]
		,[Casino].[Parameter.GameType].[GameType]
		from Casino.[RealGaming.AmaticGame] 
		INNER JOIN  [Casino].[Parameter.GameType] ON [Casino].[Parameter.GameType].[ParameterGameTypeId]=Casino.[RealGaming.AmaticGame].[ParameterGameTypeId] '

	end
else if (@GameType='Netent')
	begin
	set @sqlcommand1='	insert @tempTable
		select Casino.[RealGaming.NetentGame].GameId,''Netent'',Casino.[RealGaming.NetentGame].Title,
		Casino.[RealGaming.NetentGame].IsPopular
		,Casino.[RealGaming.NetentGame].IsMobile
		,Casino.[RealGaming.NetentGame].IsEnable
		,[Casino].[Parameter.GameType].[ParameterGameTypeId]
		,[Casino].[Parameter.GameType].[GameType]
		from Casino.[RealGaming.NetentGame]
		INNER JOIN  [Casino].[Parameter.GameType] ON [Casino].[Parameter.GameType].[ParameterGameTypeId]=Casino.[RealGaming.NetentGame].[ParameterGameTypeId] '
 
	end
else if (@GameType='SwissSoft')
	begin
	set @sqlcommand1='	insert @tempTable
		select Casino.[SwissSoft.GameList].GameId,''PlayTech'',Casino.[SwissSoft.GameList].Title,
		Casino.[SwissSoft.GameList].IsPopular
		,Casino.[SwissSoft.GameList].IsMobile
		,Casino.[SwissSoft.GameList].IsEnable
		,[Casino].[Parameter.GameType].[ParameterGameTypeId]
		,[Casino].[Parameter.GameType].[GameType]
		from Casino.[SwissSoft.GameList]
		INNER JOIN  [Casino].[Parameter.GameType] ON [Casino].[Parameter.GameType].[ParameterGameTypeId]=Casino.[SwissSoft.GameList].[ParameterGameTypeId] '

	end
else if (@GameType='Spinmatic')
	begin
	set @sqlcommand1='	insert @tempTable
		select [Casino].[Spinmatic.Game].GameId,''Spinmatic'',[Casino].[Spinmatic.Game].Name as Title,
		[Casino].[Spinmatic.Game].IsPopular
		,[Casino].[Spinmatic.Game].IsMobile
		,[Casino].[Spinmatic.Game].IsEnable
		,[Casino].[Parameter.GameType].[ParameterGameTypeId]
		,[Casino].[Parameter.GameType].[GameType]
		from Casino.[Spinmatic.Game]
		INNER JOIN  [Casino].[Parameter.GameType] ON [Casino].[Parameter.GameType].[ParameterGameTypeId]=Casino.[Spinmatic.Game].[ParameterGameTypeId] '

	end
else if (@GameType='Xpress Gaming')
	begin
	set @sqlcommand1='	insert @tempTable
		select [Casino].[XprressGaming.Game].Id as GameId,''XpressGaming'',[Casino].[XprressGaming.Game].Name as Title,
		[Casino].[XprressGaming.Game].IsPopular
		,[Casino].[XprressGaming.Game].IsMobile
		,[Casino].[XprressGaming.Game].IsEnable
		,[Casino].[Parameter.GameType].[ParameterGameTypeId]
		,[Casino].[Parameter.GameType].[GameType]
		from Casino.[XprressGaming.Game]
		INNER JOIN  [Casino].[Parameter.GameType] ON [Casino].[Parameter.GameType].[ParameterGameTypeId]=Casino.[XprressGaming.Game].[ParameterGameTypeId] '

	end






set @sqlcommand='declare @total int '+
'select @total=COUNT(GameId)  '+
'FROM         @tempTable ' +
                      'WHERE (1 = 1) and '+@where +' ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
'GameId,GameType,Title,IsPopular,IsEnable,IsMobile,GameTypeId,ParameterGameType
FROM         @tempTable '+
                      'WHERE (1 = 1) and '+@where +
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '






execute (@sqlcommand0+@sqlcommand1+@sqlcommand)
END



GO
