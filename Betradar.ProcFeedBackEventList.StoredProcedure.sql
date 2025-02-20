USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[ProcFeedBackEventList]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Betradar].[ProcFeedBackEventList]

AS

BEGIN

select 1 as  SportId,Cache.Fixture.BetradarMatchId,Match.Odd.BetradarOddTypeId,Match.Odd.SpecialBetValue,Match.Odd.StateId,Match.Odd.OutComeId,Match.Odd.OutCome,Match.Odd.OddValue,Cache.Fixture.MatchDate
from Cache.Fixture with (nolock)  INNER JOIN
Match.Odd ON Match.Odd.MatchId=Cache.Fixture.MatchId 
where Cache.Fixture.SportId=1
END

  
GO
