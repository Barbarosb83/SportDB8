USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[ProcMatchPitcher]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Betradar].[ProcMatchPitcher]
@MatchId bigint,
@Team1Name nvarchar(150),
@Team1Hand nvarchar(50),
@Team2Name nvarchar(150),
@Team2Hand nvarchar(50)

AS



BEGIN
declare @BetradarTeamType int=0
--if exists (select Match.Pitcher.PitcherId from Match.Pitcher with (nolock) where Match.Pitcher.MatchId=@MatchId)
--	update Match.Pitcher set Team1Name=@Team1Name,Team1Hand=@Team1Hand,Team2Name=@Team2Name,Team2Hand=@Team2Hand
--	where Match.Pitcher.MatchId=@MatchId
--else	
--insert Match.Pitcher (MatchId,Team1Name,Team1Hand,Team2Name,Team2Hand)
--values (@MatchId,@Team1Name,@Team1Hand,@Team2Name,@Team2Hand)




	
	
	

END


GO
