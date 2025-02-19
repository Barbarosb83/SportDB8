USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Live.ProcEventend]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Betradar].[Live.ProcEventend]
 
          

AS


 --declare @HomeScore int
 --declare @AwayScore int
 -- declare @LastHomeScore int
 --declare @LastAwayScore int

 --declare @LastScore nvarchar(15)
BEGIN 
 

 update live.EventSetting set StateId=1 where MatchId in (
Select EventId from Live.EventDetail where TimeStatu=4 and  EventDetail.BetradarTimeStamp < DATEADD(MINUTE, -3, GETDATE())
)

update live.EventDetail set TimeStatu=5 where BetradarMatchIds in (
Select LE.EventId from Live.EventDetail LE where LE.TimeStatu=4 and  LE.BetradarTimeStamp < DATEADD(MINUTE, -3, GETDATE())
)


END


GO
