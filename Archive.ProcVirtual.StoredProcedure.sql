USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Archive].[ProcVirtual]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Archive].[ProcVirtual]


AS

BEGIN TRAN 

declare @Temptable table (EventId bigint)


insert @Temptable
select EventId from Virtual.Event where CAST(EventDate as date)<CAST(DATEADD(DAY,-1,GETDATE()) as date)

delete from Virtual.EventOddSetting where Virtual.EventOddSetting.OddId in (
select Virtual.EventOdd.OddId from Virtual.EventOdd where Virtual.EventOdd.MatchId in (
select EventId from @Temptable))

delete from Virtual.EventOdd where Virtual.EventOdd.MatchId in (
select EventId from @Temptable)

delete from Virtual.ScoreCardSummary where Virtual.ScoreCardSummary.EventId in (
select EventId from @Temptable)

delete from Virtual.EventOddTypeSetting where Virtual.EventOddTypeSetting.MatchId in (
select EventId from @Temptable)

delete from Virtual.EventSetting where Virtual.EventSetting.MatchId in (
select EventId from @Temptable)

delete from Virtual.EventDetail where Virtual.EventDetail.EventId in (
select EventId from @Temptable)



delete from Virtual.Event  where Virtual.Event.EventId in (select EventId from @Temptable) 




COMMIT TRAN


GO
