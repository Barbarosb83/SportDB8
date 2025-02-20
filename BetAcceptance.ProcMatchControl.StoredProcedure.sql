USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [BetAcceptance].[ProcMatchControl]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [BetAcceptance].[ProcMatchControl] 
@MatchId bigint,
@BetType int


AS

declare @result int=0

if (@BetType=0)
begin
	SELECT    @result= ISNULL(Match.Fixture.MatchId,0)
FROM         Match.Fixture with (nolock) INNER JOIN
                      Match.FixtureDateInfo with (nolock) ON Match.Fixture.FixtureId = Match.FixtureDateInfo.FixtureId
                      where Match.FixtureDateInfo.MatchDate>DATEADD(SECOND,15, GETDATE()) and Match.Fixture.MatchId=@MatchId
IF @@ROWCOUNT=0
	set @result=0
end
else if (@BetType=1)
begin

	select @result= ISNULL(Live.EventDetail.EventId,0)
	from Live.EventDetail with (nolock) INNER JOIN Live.Event with (nolock) On Live.Event.EventId=Live.EventDetail.EventId
		where Live.EventDetail.EventId=@MatchId and Live.EventDetail.BetStatus=2 and Live.Event.ConnectionStatu=2
IF @@ROWCOUNT=0
	set @result=0
end
else if (@BetType=2)
begin

	select @result= ISNULL(Outrights.Event.EventId,0) from Outrights.Event with (nolock) 
	where Outrights.Event.EventEndDate>DATEADD(MINUTE,1, GETDATE())  and Outrights.Event.EventId=@MatchId
	
IF @@ROWCOUNT=0
	set @result=0
end
else if (@BetType=3)
begin

	select @result= ISNULL(Virtual.EventDetail.EventId,0)
	from Virtual.EventDetail with (nolock)
	where Virtual.EventDetail.EventId=@MatchId and Virtual.EventDetail.BetStatus=2
IF @@ROWCOUNT=0
	set @result=0
end

select @result


GO
