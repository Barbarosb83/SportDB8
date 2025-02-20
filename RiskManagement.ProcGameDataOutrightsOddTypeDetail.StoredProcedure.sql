USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcGameDataOutrightsOddTypeDetail]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Barbaros Babalı
-- Create date: 03.03.2015
-- Description:
-- =============================================
CREATE PROCEDURE [RiskManagement].[ProcGameDataOutrightsOddTypeDetail] 
 @PageSize  INT,
 @PageNum int,
@Username nvarchar(50),
@where nvarchar(200),
@orderby nvarchar(100),
@MatchId int,
@OddTypeId int, 
@LangId int
AS
BEGIN
SET NOCOUNT ON;


--SELECT     Outrights.Odd.OddId, Language.ParameterCompetitor.CompetitorName as OutCome, Outrights.Odd.SpecialBetValue, Outrights.Odd.OddValue, Outrights.Odd.MatchId, Outrights.Odd.Suggestion, 
--                      Parameter.MatchAvailability.Availability, Parameter.MatchState.State, Language.[Parameter.OddsType].OddsTypeId, Language.[Parameter.OddsType].OddsType, 
--                      Outrights.OddSetting.OddSettingId, Outrights.OddSetting.StateId, Outrights.OddSetting.LossLimit, Outrights.OddSetting.LimitPerTicket, Outrights.OddSetting.StakeLimit, 
--                      Outrights.OddSetting.AvailabilityId, Outrights.OddSetting.MinCombiBranch, Outrights.OddSetting.MinCombiInternet, Outrights.OddSetting.MinCombiMachine,
--                                            CASE WHEN Outrights.Odd.IsOddValueLock = 1 THEN 'Manuel' ELSE 'Auto' END AS OddChange, dbo.FuncCashFlow(Outrights.OddSetting.OddId, 0, 0,3) AS Cashflow,(dbo.FuncCashFlow(Outrights.OddSetting.OddId, 0, 0,3)*Outrights.Odd.OddValue) as PossibleLost,
--                                            CASE WHEN Outrights.OddSetting.StateId=5 THEN 1 ELSE Case when Outrights.OddSetting.StateId=2 THEN 1 ELSE 3 END END AS StatuColor
--FROM         Parameter.MatchAvailability INNER JOIN
--                      Outrights.OddSetting ON Parameter.MatchAvailability.AvailabilityId = Outrights.OddSetting.AvailabilityId INNER JOIN
--                      Parameter.MatchState ON Outrights.OddSetting.StateId = Parameter.MatchState.StateId INNER JOIN
--                      Outrights.Odd ON Outrights.OddSetting.OddId = Outrights.Odd.OddId INNER JOIN
--                      Language.[Parameter.OddsType] ON Outrights.Odd.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId INNER JOIN
--                      Language.ParameterCompetitor ON Language.[Parameter.OddsType].LanguageId = Language.ParameterCompetitor.LanguageId AND 
--                      Outrights.Odd.CompetitorId = Language.ParameterCompetitor.CompetitorId
--WHERE     (Language.[Parameter.OddsType].LanguageId = @LangId) AND (Outrights.Odd.MatchId = @MatchId) AND (Outrights.Odd.OddsTypeId=@OddTypeId )

declare @sqlcommand nvarchar(max)

set @sqlcommand=   'declare @total int '+
' select @total=COUNT(Outrights.Odd.OddId) '+
' FROM         Parameter.MatchAvailability  INNER JOIN  Outrights.OddTypeSetting ON Parameter.MatchAvailability.AvailabilityId = Outrights.OddTypeSetting.AvailabilityId 
								 INNER JOIN Parameter.MatchState ON Outrights.OddTypeSetting.StateId = Parameter.MatchState.StateId INNER JOIN Outrights.Odd ON Outrights.OddTypeSetting.MatchId=Outrights.Odd.MatchId 
								 INNER JOIN Outrights.EventName On Outrights.EventName.EventId=Outrights.Odd.MatchId 
                       WHERE  (Outrights.EventName.LanguageId ='+ cast(@LangId as nvarchar(2))+') and IsOddValueLock=0 AND (Outrights.Odd.MatchId ='+ cast(@MatchId as nvarchar(15))+') AND (Outrights.Odd.OddsTypeId ='+ cast(@OddTypeId as nvarchar(15))+') and '+@where+ ' ; '+
' WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY  '+@orderby+ ') AS RowNum,  '+
'    Outrights.Odd.OddId,  Outrights.Odd.OutCome as OutCome, Outrights.Odd.SpecialBetValue, Outrights.Odd.OddValue,
		Outrights.Odd.MatchId, Outrights.Odd.Suggestion,                   
		       Parameter.MatchAvailability.Availability, Parameter.MatchState.State,  CAST( Outrights.Odd.OddsTypeId as int) as OddsTypeId, Outrights.EventName.EventName as OddsType,          
			                  Outrights.OddTypeSetting.OddTypeSettingId as OddSettingId, Outrights.OddTypeSetting.StateId, Outrights.OddTypeSetting.LossLimit,
							   Outrights.OddTypeSetting.LimitPerTicket, Outrights.OddTypeSetting.StakeLimit,                       
							     Outrights.OddTypeSetting.AvailabilityId, Outrights.OddTypeSetting.MinCombiBranch, Outrights.OddTypeSetting.MinCombiInternet, Outrights.OddTypeSetting.MinCombiMachine
								 ,CASE WHEN Outrights.Odd.IsOddValueLock = 1 THEN '' Manuel '' ELSE ''Auto'' END AS OddChange,ISNULL( dbo.FuncCashFlow(Outrights.Odd.OddId, 0, 0,3),0) AS Cashflow
								 ,ISNULL((dbo.FuncCashFlow(Outrights.Odd.OddId, 0, 0,3)*Outrights.Odd.OddValue),0) as PossibleLost,                                              
								 CASE WHEN Outrights.OddTypeSetting.StateId=5 THEN 1 ELSE Case when Outrights.OddTypeSetting.StateId=2 THEN 1 ELSE 3 END END AS StatuColor   '+
' FROM         Parameter.MatchAvailability  INNER JOIN  Outrights.OddTypeSetting ON Parameter.MatchAvailability.AvailabilityId = Outrights.OddTypeSetting.AvailabilityId 
								 INNER JOIN Parameter.MatchState ON Outrights.OddTypeSetting.StateId = Parameter.MatchState.StateId INNER JOIN Outrights.Odd ON Outrights.OddTypeSetting.MatchId=Outrights.Odd.MatchId 
								 INNER JOIN Outrights.EventName On Outrights.EventName.EventId=Outrights.Odd.MatchId   '+
' WHERE  (Outrights.EventName.LanguageId ='+ cast(@LangId as nvarchar(2))+') and IsOddValueLock=0 AND (Outrights.Odd.MatchId ='+ cast(@MatchId as nvarchar(15))+') AND (Outrights.Odd.OddsTypeId ='+ cast(@OddTypeId as nvarchar(15))+') and '+@where +
'  )  '+
'			 SELECT * '+
'  FROM OrdersRN'+
' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(20))+')*('+cast(@PageSize  as nvarchar(10))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '






exec (@sqlcommand)





END


GO
