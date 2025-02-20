USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcGameDataOutrightsOddTypeDetailOne]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Barbaros Babalı
-- Create date: 03.03.2015
-- Description:
-- =============================================
CREATE PROCEDURE [RiskManagement].[ProcGameDataOutrightsOddTypeDetailOne] 
@OddId int,
@LangId int,
@Username nvarchar(50)
AS
BEGIN
SET NOCOUNT ON;

 



SELECT    Outrights.Odd.OddId, Outrights.Odd.Suggestion,  Outrights.Odd.OddValue,                 
		       Parameter.MatchAvailability.Availability, Parameter.MatchState.State,  CAST( Outrights.Odd.OddsTypeId as int), Outrights.EventName.EventName as OddsType,          
			                  Outrights.OddTypeSetting.OddTypeSettingId as OddSettingId, Outrights.OddTypeSetting.StateId, Outrights.OddTypeSetting.LossLimit,
							   Outrights.OddTypeSetting.LimitPerTicket, Outrights.OddTypeSetting.StakeLimit,                       
							     Outrights.OddTypeSetting.AvailabilityId, Outrights.OddTypeSetting.MinCombiBranch, Outrights.OddTypeSetting.MinCombiInternet, Outrights.OddTypeSetting.MinCombiMachine
								 ,CASE WHEN Outrights.Odd.IsOddValueLock = 1 THEN ' Manuel ' ELSE 'Auto' END AS OddChange,ISNULL( dbo.FuncCashFlow(Outrights.Odd.OddId, 0, 0,3),0) AS Cashflow
								 ,ISNULL((dbo.FuncCashFlow(Outrights.Odd.OddId, 0, 0,3)*Outrights.Odd.OddValue),0) as PossibleLost,                                              
								 CASE WHEN Outrights.OddTypeSetting.StateId=5 THEN 1 ELSE Case when Outrights.OddTypeSetting.StateId=2 THEN 1 ELSE 3 END END AS StatuColor   
								 FROM         Parameter.MatchAvailability  INNER JOIN  Outrights.OddTypeSetting ON Parameter.MatchAvailability.AvailabilityId = Outrights.OddTypeSetting.AvailabilityId 
								 INNER JOIN Parameter.MatchState ON Outrights.OddTypeSetting.StateId = Parameter.MatchState.StateId INNER JOIN Outrights.Odd ON Outrights.OddTypeSetting.MatchId=Outrights.Odd.MatchId 
								 INNER JOIN Outrights.EventName On Outrights.EventName.EventId=Outrights.Odd.MatchId  
	   WHERE  (Outrights.EventName.LanguageId =@LangId) and IsOddValueLock=0 AND (Outrights.Odd.OddId =@OddId)


END


GO
