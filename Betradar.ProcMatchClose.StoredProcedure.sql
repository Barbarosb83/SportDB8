USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[ProcMatchClose]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
 
CREATE PROCEDURE [Betradar].[ProcMatchClose]
 @BetradarMatchId bigint
 
AS

Declare @TempTournamentId bigint=0
Declare @TempMonitoringMatchId bigint=0
declare @TournamentId int=0
declare @MatchId bigint=0
BEGIN
-- insert dbo.betslip values (@BetradarMatchId,'ProcMatchClose',GETDATE())
		if exists (Select MatchId from Match.Match with (nolock) where BetradarMatchId=@BetradarMatchId)
			begin
			Select @MatchId= MatchId from Match.Match with (nolock) where BetradarMatchId=@BetradarMatchId
				update Match.Odd set StateId=1 where Match.Odd.MatchId=@MatchId
			--	update Match.OddSetting set StateId=1 where Match.OddSetting.OddId in (Select OddId from Match.Odd with (nolock) where MatchId=@MatchId)
				 
				update Match.Setting set StateId=1 where Match.Setting.MatchId=@MatchId
			end
		
	return @MatchId

END


GO
