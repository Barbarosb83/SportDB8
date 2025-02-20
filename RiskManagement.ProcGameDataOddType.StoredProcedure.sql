USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcGameDataOddType]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Barbaros Babalı
-- Create date: 03.03.2015
-- Description:
-- =============================================
CREATE PROCEDURE [RiskManagement].[ProcGameDataOddType] 
 @PageSize  INT,
 @PageNum int,
@Username nvarchar(50),
@where nvarchar(200),
@orderby nvarchar(100),
@MatchId int,
@LangId int
AS
BEGIN
SET NOCOUNT ON;


declare @sqlcommand nvarchar(max)

--declare @total int 

--select @total=COUNT(Match.OddTypeSetting.OddTypeSettingId)
--FROM         Match.OddTypeSetting INNER JOIN
--                      Language.[Parameter.OddsType] ON Match.OddTypeSetting.OddTypeId = Language.[Parameter.OddsType].OddsTypeId INNER JOIN
--                      Parameter.MatchState ON Match.OddTypeSetting.StateId = Parameter.MatchState.StateId INNER JOIN
--                      Parameter.MatchAvailability ON Match.OddTypeSetting.AvailabilityId = Parameter.MatchAvailability.AvailabilityId
--WHERE     (Language.[Parameter.OddsType].LanguageId = @LangId) AND (Match.OddTypeSetting.MatchId = @MatchId);
--WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY dbo.FuncCashFlow(Match.OddTypeSetting.OddTypeId,Match.OddTypeSetting.MatchId,1,0),Match.OddTypeSetting.OddTypeId desc) AS RowNum,
--Match.OddTypeSetting.OddTypeSettingId, Match.OddTypeSetting.OddTypeId, Language.[Parameter.OddsType].OddsType, Match.OddTypeSetting.StateId, 
--                      Match.OddTypeSetting.LossLimit, Match.OddTypeSetting.LimitPerTicket, Match.OddTypeSetting.StakeLimit, Match.OddTypeSetting.AvailabilityId, 
--                      Match.OddTypeSetting.MinCombiBranch, Match.OddTypeSetting.MinCombiInternet, Match.OddTypeSetting.MinCombiMachine, Parameter.MatchAvailability.Availability,
--                       Parameter.MatchState.State, Match.OddTypeSetting.MatchId,Parameter.MatchState.StatuColor,dbo.FuncCashFlow(Match.OddTypeSetting.OddTypeId,Match.OddTypeSetting.MatchId,1,0) as Cashflow,
--                      '' as SpecialBetValue,Match.OddTypeSetting.IsPopular
--FROM         Match.OddTypeSetting INNER JOIN
--                      Language.[Parameter.OddsType] ON Match.OddTypeSetting.OddTypeId = Language.[Parameter.OddsType].OddsTypeId INNER JOIN
--                      Parameter.MatchState ON Match.OddTypeSetting.StateId = Parameter.MatchState.StateId INNER JOIN
--                      Parameter.MatchAvailability ON Match.OddTypeSetting.AvailabilityId = Parameter.MatchAvailability.AvailabilityId
--WHERE     (Language.[Parameter.OddsType].LanguageId = @LangId) AND (Match.OddTypeSetting.MatchId = @MatchId)
--)  
--			 SELECT *,@total as totalrow 
--  FROM OrdersRN
-- WHERE RowNum BETWEEN (@PageNum-1)*(@PageSize + 1) AND (@PageNum * @PageSize) 


set @sqlcommand=   'declare @total int '+
' select @total=COUNT(Match.OddTypeSetting.OddTypeSettingId) '+
' FROM         Match.OddTypeSetting INNER JOIN
                      Language.[Parameter.OddsType] ON Match.OddTypeSetting.OddTypeId = Language.[Parameter.OddsType].OddsTypeId INNER JOIN
                      Parameter.MatchState ON Match.OddTypeSetting.StateId = Parameter.MatchState.StateId INNER JOIN
                      Parameter.MatchAvailability ON Match.OddTypeSetting.AvailabilityId = Parameter.MatchAvailability.AvailabilityId
                       WHERE  (Language.[Parameter.OddsType].LanguageId ='+ cast(@LangId as nvarchar(2))+') AND (Match.OddTypeSetting.MatchId ='+ cast(@MatchId as nvarchar(15))+') and '+@where+ ' ; '+
' WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY  '+@orderby+ ') AS RowNum,  '+
'  Match.OddTypeSetting.OddTypeSettingId, Match.OddTypeSetting.OddTypeId, Language.[Parameter.OddsType].OddsType, Match.OddTypeSetting.StateId, 
                      Match.OddTypeSetting.LossLimit, Match.OddTypeSetting.LimitPerTicket, Match.OddTypeSetting.StakeLimit, Match.OddTypeSetting.AvailabilityId, 
                      Match.OddTypeSetting.MinCombiBranch, Match.OddTypeSetting.MinCombiInternet, Match.OddTypeSetting.MinCombiMachine, Parameter.MatchAvailability.Availability,
                       Parameter.MatchState.State, Match.OddTypeSetting.MatchId,Parameter.MatchState.StatuColor,dbo.FuncCashFlow(Match.OddTypeSetting.OddTypeId,Match.OddTypeSetting.MatchId,1,0) as Cashflow,
                      '''' as SpecialBetValue,Match.OddTypeSetting.IsPopular '+
' FROM         Match.OddTypeSetting INNER JOIN
                      Language.[Parameter.OddsType] ON Match.OddTypeSetting.OddTypeId = Language.[Parameter.OddsType].OddsTypeId INNER JOIN
                      Parameter.MatchState ON Match.OddTypeSetting.StateId = Parameter.MatchState.StateId INNER JOIN
                      Parameter.MatchAvailability ON Match.OddTypeSetting.AvailabilityId = Parameter.MatchAvailability.AvailabilityId '+
' WHERE  (Language.[Parameter.OddsType].LanguageId ='+ cast(@LangId as nvarchar(2))+') AND (Match.OddTypeSetting.MatchId ='+ cast(@MatchId as nvarchar(15))+') and '+@where +
'  )  '+
'			 SELECT *,@total as totalrow '+
'  FROM OrdersRN'+
' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(20))+')*('+cast(@PageSize  as nvarchar(10))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '






exec (@sqlcommand)
END


GO
