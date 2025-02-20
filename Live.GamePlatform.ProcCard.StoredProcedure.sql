USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Live].[GamePlatform.ProcCard]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [Live].[GamePlatform.ProcCard]
	@LangId int,
	@SportId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @temptable table (EventId bigint,HomeTeamYellow int,HomeTeamRed int,AwayTeamYellow int,AwayTeamRed int)


--    insert @temptable (EventId,HomeTeamYellow)
--	select Live.ScoreCardSummary.EventId,COUNT(Live.ScoreCardSummary.EventId) as HomeTeamYellow
--FROM            Live.ScoreCardSummary with (nolock) 
--Where Live.ScoreCardSummary.ScoreCardType=2 
--and Live.ScoreCardSummary.AffectedTeam=1 
--and Live.ScoreCardSummary.IsCanceled=0 
--and Live.ScoreCardSummary.CardType=1 

--GROUP BY Live.ScoreCardSummary.EventId 



insert @temptable (EventId,HomeTeamRed)
	select Live.ScoreCardSummary.EventId,COUNT(Live.ScoreCardSummary.EventId) as HomeTeamYellow
FROM            Live.ScoreCardSummary  with (nolock) 
Where Live.ScoreCardSummary.ScoreCardType=2 
and Live.ScoreCardSummary.AffectedTeam=1 
and Live.ScoreCardSummary.IsCanceled=0 
and Live.ScoreCardSummary.CardType in (2,3) 

GROUP BY Live.ScoreCardSummary.EventId 

 

insert @temptable (EventId,AwayTeamRed)
	select Live.ScoreCardSummary.EventId,COUNT(Live.ScoreCardSummary.EventId) as HomeTeamYellow
FROM             Live.ScoreCardSummary  with (nolock) 
Where Live.ScoreCardSummary.ScoreCardType=2 and Live.ScoreCardSummary.AffectedTeam=2 and Live.ScoreCardSummary.IsCanceled=0 and Live.ScoreCardSummary.CardType in (2,3) 

GROUP BY Live.ScoreCardSummary.EventId 


    

	select EventId,SUM(ISNULL(HomeTeamYellow,0)) as HomeTeamYellow,SUM(ISNULL(HomeTeamRed,0)) as HomeTeamRed,SUM(ISNULL(AwayTeamYellow,0)) as AwayTeamYellow,SUM(ISNULL(AwayTeamRed,0)) as AwayTeamRed 
	from @temptable GROUP BY EventId

END




GO
