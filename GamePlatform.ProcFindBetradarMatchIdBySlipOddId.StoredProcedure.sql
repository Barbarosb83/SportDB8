USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcFindBetradarMatchIdBySlipOddId]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Barbaros Babalı
-- Create date: 14.10.2016
-- Description:	
-- =============================================
CREATE PROCEDURE [GamePlatform].[ProcFindBetradarMatchIdBySlipOddId] 
@SlipOddId bigint


AS

declare @BetTypeId int
declare @MatchId bigint=@SlipOddId
declare @BetradarMatchId bigint


--select top 1 @BetTypeId=BetTypeId from Customer.SlipOdd where MatchId=@SlipOddId

if exists (select Match.Match.MatchId from Match.Match with (nolock) where Match.Match.MatchId=@MatchId)
		set @BetTypeId=0
else if exists (select Archive.Match.MatchId from Archive.Match with (nolock) where Archive.Match.MatchId=@MatchId)
	set @BetTypeId=0
else
	set @BetTypeId=1
if(@BetTypeId=0)
	begin
		if exists (select Match.Match.MatchId from Match.Match with (nolock) where Match.Match.MatchId=@MatchId)
			begin
				select @BetradarMatchId=Match.Match.BetradarMatchId from Match.Match with (nolock) where Match.Match.MatchId=@MatchId
			end
		else
			begin
				select @BetradarMatchId=Archive.Match.BetradarMatchId from Archive.Match with (nolock) where Archive.Match.MatchId=@MatchId
			end
	
	end
else if (@BetTypeId=1)
	begin
		if exists (select Live.Event.BetradarMatchId from Live.Event with (nolock) where Live.Event.EventId=@MatchId)
			begin
				select @BetradarMatchId=Live.Event.BetradarMatchId from Live.Event with (nolock) where Live.Event.EventId=@MatchId
			end
		else
			begin
				select @BetradarMatchId=Archive.[Live.Event].BetradarMatchId from Archive.[Live.Event] with (nolock) where Archive.[Live.Event].EventId=@MatchId
			end
	end


select @BetradarMatchId as BetradarMatchId		
	

GO
