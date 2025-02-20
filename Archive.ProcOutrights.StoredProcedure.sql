USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Archive].[ProcOutrights]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Archive].[ProcOutrights]


AS

BEGIN TRAN 


declare @TempTable table (MatchId bigint )


insert @TempTable
SELECT    EventId
FROM            Outrights.Event
where  cast(EventEndDate as date)<cast(GETDATE() as date)  

 



insert [Archive].[Code]
select Match.Code.*
from Match.Code
where Match.Code.MatchId in (select MatchId from @TempTable) and BetTypeId=2



Begin TRY
insert [Archive].[Outrights.Event]
SELECT     Outrights.[Event].*
FROM        Outrights.[Event]
where Outrights.[Event].EventId in (select MatchId from @TempTable)
end try
BEGIN CATCH 
delete From [Archive].[Outrights.Event] where [Archive].[Outrights.Event].EventId in (select MatchId from @TempTable)
insert [Archive].[Outrights.Event]
SELECT     Outrights.[Event].*
FROM        Outrights.[Event]
where Outrights.[Event].EventId in (select MatchId from @TempTable)

END CATCH 




Begin TRY
insert [Archive].[Outrights.Competitor]
SELECT     Outrights.Competitor.*
FROM        Outrights.Competitor
where Outrights.Competitor.EventId in (select MatchId from @TempTable)
end try
BEGIN CATCH 
delete From [Archive].[Outrights.Competitor] where [Archive].[Outrights.Competitor].EventId in (select MatchId from @TempTable)
insert [Archive].[Outrights.Competitor]
SELECT     Outrights.Competitor.*
FROM        Outrights.Competitor
where Outrights.Competitor.EventId in (select MatchId from @TempTable)

END CATCH 


insert [Archive].[Outrights.EventName]
SELECT     Outrights.EventName.*
FROM        Outrights.EventName
where Outrights.EventName.EventId in (select MatchId from @TempTable)

insert [Archive].[Outrights.OddResult]
SELECT     Outrights.OddResult.*
FROM         Outrights.OddResult
where Outrights.OddResult.MatchId in (select MatchId from @TempTable)
 

 Begin TRY
insert [Archive].[Outrights.Odd]
SELECT     Outrights.Odd.*
FROM         Outrights.Odd
where Outrights.Odd.MatchId in (select MatchId from @TempTable)
end try
BEGIN CATCH 
delete From  [Archive].[Outrights.Odd] where  [Archive].[Outrights.Odd].MatchId in (select MatchId from @TempTable)
insert [Archive].[Outrights.Odd]
SELECT     Outrights.Odd.*
FROM         Outrights.Odd
where Outrights.Odd.MatchId in (select MatchId from @TempTable)

END CATCH 




insert [Archive].[Outrights.OddSetting]
SELECT     Outrights.OddSetting.*
FROM        Outrights.Odd INNER JOIN
                      Outrights.OddSetting ON Outrights.Odd.OddId = Outrights.OddSetting.OddId
where Outrights.Odd.MatchId in (select MatchId from @TempTable)





Begin TRY
insert [Archive].[Outrights.OddTypeSetting]
SELECT     Outrights.OddTypeSetting.*
FROM         Outrights.OddTypeSetting
where Outrights.OddTypeSetting.MatchId in (select MatchId from @TempTable)
end try
BEGIN CATCH 
delete From [Archive].[Outrights.OddTypeSetting] where [Archive].[Outrights.OddTypeSetting].MatchId in (select MatchId from @TempTable)
insert [Archive].[Outrights.OddTypeSetting]
SELECT     Outrights.OddTypeSetting.*
FROM         Outrights.OddTypeSetting
where Outrights.OddTypeSetting.MatchId in (select MatchId from @TempTable)

END CATCH 


--------------------------------------------------------------------DELETE-------------------------------


delete Outrights.Competitor where Outrights.Competitor.EventId in (select MatchId from @TempTable)

delete    Outrights.EventName where Outrights.EventName.EventId in (select MatchId from @TempTable)

delete    Outrights.OddResult where Outrights.OddResult.MatchId in (select MatchId from @TempTable)

delete    Outrights.OddTypeSetting where Outrights.OddTypeSetting.MatchId in (select MatchId from @TempTable)

delete Match.Code where Match.Code.MatchId in (select MatchId from @TempTable) and BetTypeId=2

update Parameter.MatchCode set IsUsed=0 where Code not in (select Match.Code.Code from Match.Code)

delete    Outrights.OddSetting where Outrights.OddSetting.OddSettingId in (SELECT     Outrights.OddSetting.OddSettingId
FROM        Outrights.Odd INNER JOIN
                      Outrights.OddSetting ON Outrights.Odd.OddId = Outrights.OddSetting.OddId
where Outrights.Odd.MatchId in (select MatchId from @TempTable))


delete    Outrights.Odd where Outrights.Odd.MatchId in (select MatchId from @TempTable)

 

delete  from     Outrights.[Event] where Outrights.[Event].EventId in (select MatchId from @TempTable)

COMMIT TRAN


GO
