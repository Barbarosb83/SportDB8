USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[Outrights.ProcEventOdd]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 
 
CREATE PROCEDURE [GamePlatform].[Outrights.ProcEventOdd] 
@MatchId bigint,
@LangId int
AS

BEGIN
SET NOCOUNT ON;


if(@LangId=21)
	set @LangId=2

SELECT DISTINCT   
             Outrights.Odd.OddId, Outrights.Odd.OutCome as OutCome, 
             Outrights.Odd.OddValue,
              Outrights.[Event].TournamentId,
               ''  as SpecialBetValue,
              Outrights.EventName.EventName as OddsType,
                       '' as OutcomesDescription 
					    ,ISNULL(Outrights.Event.SequenceNumber,999) as SequenceNumber
FROM         Outrights.Odd   INNER JOIN
                    -- Outrights.[Competitor] On Outrights.Competitor.CompetitorId=Outrights.Odd.CompetitorId INNER JOIN
                      Outrights.[Event] ON Outrights.Odd.MatchId = Outrights.[Event].EventId  INNER JOIN
					  Outrights.EventName On Outrights.EventName.EventId=Outrights.Event.EventId and Outrights.EventName.LanguageId=@LangId

                     -- INNER JOIN Outrights.OddTypeSetting ON  Outrights.OddTypeSetting.MatchId = Outrights.[Event].EventId and Outrights.OddTypeSetting.OddTypeId=Outrights.Odd.OddsTypeId 
				--  [Parameter].[Competitor] as PC On PC.BetradarSuperId=Outrights.Competitor.CompetitorBetradarId 
                  --    inner join Language.[ParameterCompetitor] on PC.CompetitorId=Language.[ParameterCompetitor].CompetitorId 
					--  and Language.[ParameterCompetitor].LanguageId=2
WHERE     (Outrights.[Event].TournamentId = @MatchId)  and OddValue>1 and  Outrights.[Event].IsActive=1 and Outrights.Event.EventEndDate>DATEADD(MINUTE,-5,GETDATE())
--AND (Outrights.OddTypeSetting.StateId = 2)
-- AND (Outrights.OddTypeSetting.MatchId = @MatchId)   --and Outrights.OddSetting.StateId=2
order by ISNULL(Outrights.Event.SequenceNumber,999),Outrights.EventName.EventName,Outrights.Odd.OddValue
 


END


GO
