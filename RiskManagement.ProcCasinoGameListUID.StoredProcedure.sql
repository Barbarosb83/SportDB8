USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCasinoGameListUID]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [RiskManagement].[ProcCasinoGameListUID]
@GameType nvarchar(20),
@GameId int,
@Title nvarchar(150),
@IsEnable bit,
@IsPopular bit,
@IsMobile bit,
@ParameterGameTypeId int,
@LangId int,
@username nvarchar(max),
@ActivityCode int,
@NewValues nvarchar(max)
AS



BEGIN
SET NOCOUNT ON;

declare @OldValues nvarchar(max)
declare @resultcode int=106
declare @resultmessage nvarchar(max)='Hata oluştu'
declare @AvailabityId int


select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId


if @ActivityCode=1
	begin


if (@GameType='Amatic')
	begin
		update Casino.[RealGaming.AmaticGame] set
		Title=@Title,
		IsEnable=@IsEnable,
		IsMobile=@IsMobile,
		Ispopular=@IsPopular
		,ParameterGameTypeId=@ParameterGameTypeId
		where GameId=@GameId
	end
else if (@GameType='Netent')
	begin
		update Casino.[RealGaming.NetentGame] set
		Title=@Title,
		IsEnable=@IsEnable,
		IsMobile=@IsMobile,
		Ispopular=@IsPopular
		,ParameterGameTypeId=@ParameterGameTypeId
		where GameId=@GameId
	end
else if (@GameType='PlayTech')
	begin
		update Casino.[RealGaming.PlayTech] set
		Title=@Title,
		IsEnable=@IsEnable,
		IsMobile=@IsMobile,
		Ispopular=@IsPopular
		,ParameterGameTypeId=@ParameterGameTypeId
		where GameId=@GameId
	end
	else if (@GameType='SwissSoft')
	begin
		update Casino.[SwissSoft.GameList] set
		Title=@Title,
		IsEnable=@IsEnable,
		IsMobile=@IsMobile,
		Ispopular=@IsPopular
		,ParameterGameTypeId=@ParameterGameTypeId
		where GameId=@GameId
	end
		else if (@GameType='Spinmatic')
	begin
		update Casino.[Spinmatic.Game] set
		Name=@Title,
		IsEnable=@IsEnable,
		IsMobile=@IsMobile,
		Ispopular=@IsPopular
		,ParameterGameTypeId=@ParameterGameTypeId
		where GameId=@GameId
	end
		else if (@GameType='Xpress Gaming')
	begin
		update Casino.[XprressGaming.Game] set
		Name=@Title,
		IsEnable=@IsEnable,
		IsMobile=@IsMobile,
		Ispopular=@IsPopular
		,ParameterGameTypeId=@ParameterGameTypeId
		where Id=@GameId
	end
	

	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId
	
	
	end


	select @resultcode as resultcode,@resultmessage as resultmessage


END




GO
