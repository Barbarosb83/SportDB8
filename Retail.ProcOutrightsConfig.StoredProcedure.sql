USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcOutrightsConfig]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Retail].[ProcOutrightsConfig] 
@DayPeriod int,
@SportId int
AS

BEGIN
SET NOCOUNT ON;

 
select Outrights.Event.*, Language.[Parameter.Category].CategoryName+' '+ Outrights.EventName.EventName as EventName,Match.Code.Code from Outrights.Event INNER JOIN Outrights.EventName 
On Outrights.Event.EventId=Outrights.EventName.EventId and Outrights.EventName.LanguageId=6 INNER JOIN Match.Code ON
Match.Code.MatchId=Outrights.Event.EventId and Match.Code.BetTypeId=2 INNER JOIN Parameter.TournamentOutrights On
Parameter.TournamentOutrights.TournamentId=Outrights.Event.TournamentId INNER JOIN
Parameter.Category On Parameter.Category.CategoryId=Parameter.TournamentOutrights.CategoryId and Parameter.Category.SportId=1
INNER JOIN Language.[Parameter.Category] On Language.[Parameter.Category].CategoryId=Parameter.Category.CategoryId and Language.[Parameter.Category].LanguageId=6
where Outrights.Event.EventEndDate>GETDATE() and Outrights.Event.EventId in (select Distinct MatchId from Outrights.Odd where SwCode is not null)   
and (Select COUNT(*) from Outrights.Odd where MatchId=Outrights.Event.EventId and OddValue>1 and SwCode is not null)>1 and Outrights.Event.EventId not in (43722) and Outrights.Event.IsActive=1
order by ISNULL(Outrights.Event.SequenceNumber,999),Language.[Parameter.Category].CategoryName+' '+ Outrights.EventName.EventName


END


GO
