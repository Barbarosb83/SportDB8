USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcGameDataOddTypeResult]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcGameDataOddTypeResult] 
 @PageSize  INT,
 @PageNum int,
@Username nvarchar(50),
@where nvarchar(200),
@orderby nvarchar(100),
@MatchId int,
@LangId int
AS
--10|1|Administrator|and 1=1|OddTypeId desc|1413191|1|
BEGIN
SET NOCOUNT ON;


declare @sqlcommand nvarchar(max)

--declare @total int 

--select @total=COUNT([Archive].OddTypeSetting.OddTypeSettingId)
--FROM         [Archive].OddTypeSetting INNER JOIN
--                      Language.[Parameter.OddsType] ON [Archive].OddTypeSetting.OddTypeId = Language.[Parameter.OddsType].OddsTypeId INNER JOIN
--                      Parameter.MatchState ON [Archive].OddTypeSetting.StateId = Parameter.MatchState.StateId INNER JOIN
--                      Parameter.MatchAvailability ON [Archive].OddTypeSetting.AvailabilityId = Parameter.MatchAvailability.AvailabilityId
--WHERE     (Language.[Parameter.OddsType].LanguageId = @LangId) AND ([Archive].OddTypeSetting.MatchId = @MatchId);
--WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY dbo.FuncCashFlow([Archive].OddTypeSetting.OddTypeId,[Archive].OddTypeSetting.MatchId,1,0),[Archive].OddTypeSetting.OddTypeId desc) AS RowNum,
--[Archive].OddTypeSetting.OddTypeSettingId, [Archive].OddTypeSetting.OddTypeId, Language.[Parameter.OddsType].OddsType, [Archive].OddTypeSetting.StateId, 
--                      [Archive].OddTypeSetting.LossLimit, [Archive].OddTypeSetting.LimitPerTicket, [Archive].OddTypeSetting.StakeLimit, [Archive].OddTypeSetting.AvailabilityId, 
--                      [Archive].OddTypeSetting.MinCombiBranch, [Archive].OddTypeSetting.MinCombiInternet, [Archive].OddTypeSetting.MinCombiMachine, Parameter.MatchAvailability.Availability,
--                       Parameter.MatchState.State, [Archive].OddTypeSetting.MatchId,Parameter.MatchState.StatuColor,dbo.FuncCashFlow([Archive].OddTypeSetting.OddTypeId,[Archive].OddTypeSetting.MatchId,1,0) as Cashflow,
--                      '' as SpecialBetValue,[Archive].OddTypeSetting.IsPopular
--FROM         [Archive].OddTypeSetting INNER JOIN
--                      Language.[Parameter.OddsType] ON [Archive].OddTypeSetting.OddTypeId = Language.[Parameter.OddsType].OddsTypeId INNER JOIN
--                      Parameter.MatchState ON [Archive].OddTypeSetting.StateId = Parameter.MatchState.StateId INNER JOIN
--                      Parameter.MatchAvailability ON [Archive].OddTypeSetting.AvailabilityId = Parameter.MatchAvailability.AvailabilityId
--WHERE     (Language.[Parameter.OddsType].LanguageId = @LangId) AND ([Archive].OddTypeSetting.MatchId = @MatchId)
--)  
--			 SELECT *,@total as totalrow 
--  FROM OrdersRN
-- WHERE RowNum BETWEEN (@PageNum-1)*(@PageSize + 1) AND (@PageNum * @PageSize) 





if exists(select Archive.Odd.OddId from Archive.Odd with (nolock) where Archive.Odd.MatchId=@MatchId)
begin
set @sqlcommand=   'declare @total int '+
' select @total=COUNT([Archive].OddTypeSetting.OddTypeSettingId)  '+
' FROM         [Archive].OddTypeSetting with (nolock) INNER JOIN
                      Language.[Parameter.OddsType] with (nolock) ON [Archive].OddTypeSetting.OddTypeId = Language.[Parameter.OddsType].OddsTypeId INNER JOIN
					   [Parameter].[OddsType] with (nolock) ON [Parameter].[OddsType].OddsTypeId = [Archive].OddTypeSetting.OddTypeId INNER JOIN
                      Parameter.MatchState with (nolock) ON [Archive].OddTypeSetting.StateId = Parameter.MatchState.StateId INNER JOIN
                      Parameter.MatchAvailability with (nolock) ON [Archive].OddTypeSetting.AvailabilityId = Parameter.MatchAvailability.AvailabilityId
WHERE  [Parameter].[OddsType].IsActive=1 and   (Language.[Parameter.OddsType].LanguageId = '+CAST(@LangId as nvarchar(2))+') AND ([Archive].OddTypeSetting.MatchId = '+CAST(@MatchId as nvarchar(20))+')'+ @where + ' ; '+
' WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum,
[Archive].OddTypeSetting.OddTypeSettingId, [Archive].OddTypeSetting.OddTypeId, Language.[Parameter.OddsType].OddsType, [Archive].OddTypeSetting.StateId, 
                      [Archive].OddTypeSetting.LossLimit, [Archive].OddTypeSetting.LimitPerTicket, [Archive].OddTypeSetting.StakeLimit, [Archive].OddTypeSetting.AvailabilityId, 
                      [Archive].OddTypeSetting.MinCombiBranch, [Archive].OddTypeSetting.MinCombiInternet, [Archive].OddTypeSetting.MinCombiMachine, Parameter.MatchAvailability.Availability,
                       Parameter.MatchState.State, [Archive].OddTypeSetting.MatchId,Parameter.MatchState.StatuColor,dbo.FuncCashFlow([Archive].OddTypeSetting.OddTypeId,[Archive].OddTypeSetting.MatchId,1,0) as Cashflow,
                      '''' as SpecialBetValue,[Archive].OddTypeSetting.IsPopular
FROM         [Archive].OddTypeSetting with (nolock) INNER JOIN
                      Language.[Parameter.OddsType] with (nolock) ON [Archive].OddTypeSetting.OddTypeId = Language.[Parameter.OddsType].OddsTypeId INNER JOIN
					  [Parameter].[OddsType] with (nolock) ON [Parameter].[OddsType].OddsTypeId = [Archive].OddTypeSetting.OddTypeId INNER JOIN
                      Parameter.MatchState with (nolock) ON [Archive].OddTypeSetting.StateId = Parameter.MatchState.StateId INNER JOIN
                      Parameter.MatchAvailability with (nolock) ON [Archive].OddTypeSetting.AvailabilityId = Parameter.MatchAvailability.AvailabilityId
WHERE  [Parameter].[OddsType].IsActive=1 and   (Language.[Parameter.OddsType].LanguageId = '+CAST(@LangId as nvarchar(2))+') AND ([Archive].OddTypeSetting.MatchId = '+CAST(@MatchId as nvarchar(20))+') '+ @where + '  '+
'  )  '+
'			 SELECT *,@total as totalrow '+
'  FROM OrdersRN'+
' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(20))+')*('+cast(@PageSize  as nvarchar(10))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '
end
else
begin

set @where=REPLACE(@where,'Archive','Match')
set @orderby=REPLACE(@orderby,'Archive','Match')


set @sqlcommand=   'declare @total int '+
' select @total=COUNT([Match].OddTypeSetting.OddTypeSettingId)  '+
' FROM         [Match].OddTypeSetting with (nolock) INNER JOIN
                      Language.[Parameter.OddsType] with (nolock) ON [Match].OddTypeSetting.OddTypeId = Language.[Parameter.OddsType].OddsTypeId INNER JOIN
					   [Parameter].[OddsType] with (nolock) ON [Parameter].[OddsType].OddsTypeId = [Match].OddTypeSetting.OddTypeId INNER JOIN
                      Parameter.MatchState with (nolock) ON [Match].OddTypeSetting.StateId = Parameter.MatchState.StateId INNER JOIN
                      Parameter.MatchAvailability with (nolock) ON [Match].OddTypeSetting.AvailabilityId = Parameter.MatchAvailability.AvailabilityId
WHERE  [Parameter].[OddsType].IsActive=1 and   (Language.[Parameter.OddsType].LanguageId = '+CAST(@LangId as nvarchar(2))+') AND ([Match].OddTypeSetting.MatchId = '+CAST(@MatchId as nvarchar(20))+')'+ @where + ' ; '+
' WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum,
[Match].OddTypeSetting.OddTypeSettingId, [Match].OddTypeSetting.OddTypeId, Language.[Parameter.OddsType].OddsType, [Match].OddTypeSetting.StateId, 
                      [Match].OddTypeSetting.LossLimit, [Match].OddTypeSetting.LimitPerTicket, [Match].OddTypeSetting.StakeLimit, [Match].OddTypeSetting.AvailabilityId, 
                      [Match].OddTypeSetting.MinCombiBranch, [Match].OddTypeSetting.MinCombiInternet, [Match].OddTypeSetting.MinCombiMachine, Parameter.MatchAvailability.Availability,
                       Parameter.MatchState.State, [Match].OddTypeSetting.MatchId,Parameter.MatchState.StatuColor,dbo.FuncCashFlow([Match].OddTypeSetting.OddTypeId,[Match].OddTypeSetting.MatchId,1,0) as Cashflow,
                      '''' as SpecialBetValue,[Match].OddTypeSetting.IsPopular
FROM         [Match].OddTypeSetting with (nolock) INNER JOIN
                      Language.[Parameter.OddsType] with (nolock) ON [Match].OddTypeSetting.OddTypeId = Language.[Parameter.OddsType].OddsTypeId INNER JOIN
					  [Parameter].[OddsType] with (nolock) ON [Parameter].[OddsType].OddsTypeId = [Match].OddTypeSetting.OddTypeId INNER JOIN
                      Parameter.MatchState with (nolock) ON [Match].OddTypeSetting.StateId = Parameter.MatchState.StateId INNER JOIN
                      Parameter.MatchAvailability with (nolock) ON [Match].OddTypeSetting.AvailabilityId = Parameter.MatchAvailability.AvailabilityId
WHERE  [Parameter].[OddsType].IsActive=1 and   (Language.[Parameter.OddsType].LanguageId = '+CAST(@LangId as nvarchar(2))+') AND ([Match].OddTypeSetting.MatchId = '+CAST(@MatchId as nvarchar(20))+') '+ @where + '  '+
'  )  '+
'			 SELECT *,@total as totalrow '+
'  FROM OrdersRN'+
' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(20))+')*('+cast(@PageSize  as nvarchar(10))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '
end





exec (@sqlcommand)
END


GO
