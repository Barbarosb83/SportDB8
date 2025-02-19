USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Job].[FuncMatchStateChange]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Job].[FuncMatchStateChange]

AS

BEGIN

 
	
	update Match.Setting set StateId=1 
	where Match.Setting.MatchId in 
	(select Match.Fixture.MatchId from Match.Fixture where Match.Fixture.FixtureId in 
	(select Match.FixtureDateInfo.FixtureId from Match.FixtureDateInfo where Match.FixtureDateInfo.MatchDate<=GETDATE()))

END


GO
