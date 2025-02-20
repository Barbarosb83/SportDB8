USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[Outrights.ProcEventOddNewOnline]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[Outrights.ProcEventOddNewOnline] @MatchId bigint,
                                                            @LangId int
AS

BEGIN
    SET NOCOUNT ON;

    SELECT DISTINCT Outrights.Odd.OddId,
                    Outrights.Odd.OutCome                       as OutCome,
                    Outrights.Odd.OddValue,
                    Outrights.[Event].TournamentId,
                    ''                                          as SpecialBetValue,
                    Outrights.EventName.EventName               as OddsType,
                    ''                                          as OutcomesDescription,
                    ISNULL(Outrights.Event.SequenceNumber, 999) as SequenceNumber,
                    Outrights.Odd.MatchId                     as MatchId
					,LPTO.TournamentName
					,PC.CategoryId

					,LCO.CategoryName
					,LPS.SportName
					,PS.SportName as SportNameOrginal
					,SUBSTRING(LOWER(Parameter.Iso.IsoName2), 0, 3) AS IsoName
    FROM Outrights.Odd
             INNER JOIN
         -- Outrights.[Competitor] On Outrights.Competitor.CompetitorId=Outrights.Odd.CompetitorId INNER JOIN
             Outrights.[Event] ON Outrights.Odd.MatchId = Outrights.[Event].EventId
             INNER JOIN
         Outrights.EventName
         On Outrights.EventName.EventId = Outrights.Event.EventId and Outrights.EventName.LanguageId = @LangId
		 INNER JOIN Parameter.TournamentOutrights PTO with (nolock) ON PTO.TournamentId=Outrights.[Event].TournamentId INNER JOIN
		 Language.[Parameter.TournamentOutrights] LPTO with (nolock) ON LPTO.TournamentId=PTO.TournamentId and LPTO.LanguageId=@LangId INNER JOIN
		 Parameter.Category PC with (nolock) On PC.CategoryId=PTO.CategoryId INNER JOIN
		 Language.[Parameter.Category] LCO with (nolock) ON LCO.CategoryId=PC.CategoryId and LCO.LanguageId=@LangId INNER JOIN
		 Parameter.Sport PS with (nolock) ON PC.SportId=PS.SportId INNER JOIN
		 Language.[Parameter.Sport] LPS with (nolock) ON LPS.SportId=Ps.SportId and LPs.LanguageId=@LangId INNER JOIN
		  Parameter.Iso ON Parameter.Iso.IsoId=PC.IsoId
    -- INNER JOIN Outrights.OddTypeSetting ON  Outrights.OddTypeSetting.MatchId = Outrights.[Event].EventId and Outrights.OddTypeSetting.OddTypeId=Outrights.Odd.OddsTypeId 
    --  [Parameter].[Competitor] as PC On PC.BetradarSuperId=Outrights.Competitor.CompetitorBetradarId 
    --    inner join Language.[ParameterCompetitor] on PC.CompetitorId=Language.[ParameterCompetitor].CompetitorId 
    --  and Language.[ParameterCompetitor].LanguageId=2
    WHERE (Outrights.[Event].TournamentId = @MatchId)
      and OddValue > 1
      and Outrights.[Event].IsActive = 1
      and Outrights.Event.EventEndDate > DATEADD(MINUTE, -5, GETDATE())
    --AND (Outrights.OddTypeSetting.StateId = 2)
-- AND (Outrights.OddTypeSetting.MatchId = @MatchId)   --and Outrights.OddSetting.StateId=2
    order by ISNULL(Outrights.Event.SequenceNumber, 999), Outrights.EventName.EventName, Outrights.Odd.OddValue


END
GO
