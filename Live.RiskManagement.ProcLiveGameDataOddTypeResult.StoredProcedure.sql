USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Live].[RiskManagement.ProcLiveGameDataOddTypeResult]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Barbaros Babalı
-- Create date: 03.03.2015
-- Description:
-- =============================================
CREATE PROCEDURE [Live].[RiskManagement.ProcLiveGameDataOddTypeResult] 
 @PageSize  INT,
 @PageNum int,
@Username nvarchar(50),
@where nvarchar(200),
@orderby nvarchar(200),
@MatchId int,
@LangId int
AS
BEGIN
SET NOCOUNT ON;



declare @sqlcommand nvarchar(max)



if exists(select Archive.[Live.Event].EventId from Archive.[Live.Event] where Archive.[Live.Event].EventId=@MatchId)
begin

if(@orderby='dbo.FuncCashFlow(Live.[EventOddTypeSetting].OddTypeId,Live.[EventOddTypeSetting].MatchId,1,1) desc')
	set @orderby='dbo.FuncCashFlow(Archive.[Live.EventOddTypeSetting].OddTypeId,Archive.[Live.EventOddTypeSetting].MatchId,1,1) desc'
else if (@orderby='dbo.FuncCashFlow(Live.[EventOddTypeSetting].OddTypeId,Live.[EventOddTypeSetting].MatchId,1,1) asc')
   set @orderby='dbo.FuncCashFlow(Archive.[Live.EventOddTypeSetting].OddTypeId,Archive.[Live.EventOddTypeSetting].MatchId,1,1) asc'

	
--select @total=COUNT(Archive.[Live.EventOddTypeSetting].OddTypeSettingId)
--FROM         Archive.[Live.EventOddTypeSetting] INNER JOIN
--                      Live.[Parameter.OddType] ON Archive.[Live.EventOddTypeSetting].OddTypeId = Live.[Parameter.OddType].OddTypeId INNER JOIN
--                      Parameter.MatchState ON Archive.[Live.EventOddTypeSetting].StateId = Parameter.MatchState.StateId INNER JOIN
--                      Parameter.MatchAvailability ON Archive.[Live.EventOddTypeSetting].AvailabilityId = Parameter.MatchAvailability.AvailabilityId
--WHERE      (Archive.[Live.EventOddTypeSetting].MatchId = @MatchId);
--WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY dbo.FuncCashFlow(Archive.[Live.EventOddTypeSetting].OddTypeId,Archive.[Live.EventOddTypeSetting].MatchId,1,1),Archive.[Live.EventOddTypeSetting].OddTypeId desc) AS RowNum,
--Archive.[Live.EventOddTypeSetting].OddTypeSettingId, Archive.[Live.EventOddTypeSetting].OddTypeId, Live.[Parameter.OddType].OddType, Archive.[Live.EventOddTypeSetting].StateId, 
--                      Archive.[Live.EventOddTypeSetting].LossLimit, Archive.[Live.EventOddTypeSetting].LimitPerTicket, Archive.[Live.EventOddTypeSetting].StakeLimit, Archive.[Live.EventOddTypeSetting].AvailabilityId, 
--                      Archive.[Live.EventOddTypeSetting].MinCombiBranch, Archive.[Live.EventOddTypeSetting].MinCombiInternet, Archive.[Live.EventOddTypeSetting].MinCombiMachine, Parameter.MatchAvailability.Availability,
--                       Parameter.MatchState.State, Archive.[Live.EventOddTypeSetting].MatchId,Parameter.MatchState.StatuColor,dbo.FuncCashFlow(Archive.[Live.EventOddTypeSetting].OddTypeId,Archive.[Live.EventOddTypeSetting].MatchId,1,1) as Cashflow,
--                      '' as SpecialBetValue,Archive.[Live.EventOddTypeSetting].IsPopular
--FROM        Archive.[Live.EventOddTypeSetting] INNER JOIN
--                      Live.[Parameter.OddType] ON Archive.[Live.EventOddTypeSetting].OddTypeId = Live.[Parameter.OddType].OddTypeId INNER JOIN
--                      Parameter.MatchState ON Archive.[Live.EventOddTypeSetting].StateId = Parameter.MatchState.StateId INNER JOIN
--                      Parameter.MatchAvailability ON Archive.[Live.EventOddTypeSetting].AvailabilityId = Parameter.MatchAvailability.AvailabilityId
--WHERE      (Archive.[Live.EventOddTypeSetting].MatchId = @MatchId)
--)  
--			 SELECT *,@total as totalrow 
--  FROM OrdersRN
-- WHERE RowNum BETWEEN (@PageNum-1)*(@PageSize + 1) AND (@PageNum * @PageSize) 


set @sqlcommand=   'declare @total int '+
' select @total=COUNT(Archive.[Live.EventOddTypeSetting].OddTypeSettingId) '+
' FROM         Archive.[Live.EventOddTypeSetting] INNER JOIN
                      Live.[Parameter.OddType] ON Archive.[Live.EventOddTypeSetting].OddTypeId = Live.[Parameter.OddType].OddTypeId INNER JOIN
                      Parameter.MatchState ON Archive.[Live.EventOddTypeSetting].StateId = Parameter.MatchState.StateId INNER JOIN
                      Parameter.MatchAvailability ON Archive.[Live.EventOddTypeSetting].AvailabilityId = Parameter.MatchAvailability.AvailabilityId
                       WHERE  Live.[Parameter.OddType].IsActive=1 and  (Archive.[Live.EventOddTypeSetting].MatchId = '+ cast(@MatchId as nvarchar(10))+')  and '+@where+ ' ; '+
' WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY  Archive.[Live.EventOddTypeSetting].OddTypeSettingId) AS RowNum,  '+
'  Archive.[Live.EventOddTypeSetting].OddTypeSettingId, Archive.[Live.EventOddTypeSetting].OddTypeId, Live.[Parameter.OddType].OddType, Archive.[Live.EventOddTypeSetting].StateId, 
                      Archive.[Live.EventOddTypeSetting].LossLimit, Archive.[Live.EventOddTypeSetting].LimitPerTicket, Archive.[Live.EventOddTypeSetting].StakeLimit, Archive.[Live.EventOddTypeSetting].AvailabilityId, 
                      Archive.[Live.EventOddTypeSetting].MinCombiBranch, Archive.[Live.EventOddTypeSetting].MinCombiInternet, Archive.[Live.EventOddTypeSetting].MinCombiMachine, Parameter.MatchAvailability.Availability,
                       Parameter.MatchState.State, Archive.[Live.EventOddTypeSetting].MatchId,Parameter.MatchState.StatuColor,dbo.FuncCashFlow(Archive.[Live.EventOddTypeSetting].OddTypeId,Archive.[Live.EventOddTypeSetting].MatchId,1,1) as Cashflow,
                      '''' as SpecialBetValue,Archive.[Live.EventOddTypeSetting].IsPopular '+
' FROM        Archive.[Live.EventOddTypeSetting] with (nolock) INNER JOIN
                      Live.[Parameter.OddType] with (nolock) ON Archive.[Live.EventOddTypeSetting].OddTypeId = Live.[Parameter.OddType].OddTypeId INNER JOIN
                      Parameter.MatchState with (nolock) ON Archive.[Live.EventOddTypeSetting].StateId = Parameter.MatchState.StateId INNER JOIN
                      Parameter.MatchAvailability with (nolock) ON Archive.[Live.EventOddTypeSetting].AvailabilityId = Parameter.MatchAvailability.AvailabilityId '+
' WHERE Live.[Parameter.OddType].IsActive=1 and  (Archive.[Live.EventOddTypeSetting].MatchId = '+ cast(@MatchId as nvarchar(10))+')  and '+@where +
'  )  '+
'			 SELECT *,@total as totalrow '+
'  FROM OrdersRN'+
' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(20))+')*('+cast(@PageSize  as nvarchar(10))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '






end
else
begin
--select @total=COUNT(Live.[EventOddTypeSetting].OddTypeSettingId)
--FROM         Live.[EventOddTypeSetting] INNER JOIN
--                      Live.[Parameter.OddType] ON Live.[EventOddTypeSetting].OddTypeId = Live.[Parameter.OddType].OddTypeId INNER JOIN
--                      Parameter.MatchState ON Live.[EventOddTypeSetting].StateId = Parameter.MatchState.StateId INNER JOIN
--                      Parameter.MatchAvailability ON Live.[EventOddTypeSetting].AvailabilityId = Parameter.MatchAvailability.AvailabilityId
--WHERE      (Live.[EventOddTypeSetting].MatchId = @MatchId);
--WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY dbo.FuncCashFlow(Live.[EventOddTypeSetting].OddTypeId,Live.[EventOddTypeSetting].MatchId,1,1),Live.[EventOddTypeSetting].OddTypeId desc) AS RowNum,
--Live.[EventOddTypeSetting].OddTypeSettingId, Live.[EventOddTypeSetting].OddTypeId, Live.[Parameter.OddType].OddType, Live.[EventOddTypeSetting].StateId, 
--                      Live.[EventOddTypeSetting].LossLimit, Live.[EventOddTypeSetting].LimitPerTicket, Live.[EventOddTypeSetting].StakeLimit, Live.[EventOddTypeSetting].AvailabilityId, 
--                      Live.[EventOddTypeSetting].MinCombiBranch, Live.[EventOddTypeSetting].MinCombiInternet, Live.[EventOddTypeSetting].MinCombiMachine, Parameter.MatchAvailability.Availability,
--                       Parameter.MatchState.State, Live.[EventOddTypeSetting].MatchId,Parameter.MatchState.StatuColor,dbo.FuncCashFlow(Live.[EventOddTypeSetting].OddTypeId,Live.[EventOddTypeSetting].MatchId,1,1) as Cashflow,
--                      '' as SpecialBetValue,Live.[EventOddTypeSetting].IsPopular
--FROM        Live.[EventOddTypeSetting] INNER JOIN
--                      Live.[Parameter.OddType] ON Live.[EventOddTypeSetting].OddTypeId = Live.[Parameter.OddType].OddTypeId INNER JOIN
--                      Parameter.MatchState ON Live.[EventOddTypeSetting].StateId = Parameter.MatchState.StateId INNER JOIN
--                      Parameter.MatchAvailability ON Live.[EventOddTypeSetting].AvailabilityId = Parameter.MatchAvailability.AvailabilityId
--WHERE      (Live.[EventOddTypeSetting].MatchId = @MatchId)
--)  
--			 SELECT *,@total as totalrow 
--  FROM OrdersRN
-- WHERE RowNum BETWEEN (@PageNum-1)*(@PageSize + 1) AND (@PageNum * @PageSize)
 
 
 
set @sqlcommand=   'declare @total int '+
' select @total=COUNT(Live.[EventOddTypeSetting].OddTypeSettingId) '+
' FROM         Live.[EventOddTypeSetting] INNER JOIN
                      Live.[Parameter.OddType] ON Live.[EventOddTypeSetting].OddTypeId = Live.[Parameter.OddType].OddTypeId INNER JOIN
                      Parameter.MatchState ON Live.[EventOddTypeSetting].StateId = Parameter.MatchState.StateId INNER JOIN
                      Parameter.MatchAvailability ON Live.[EventOddTypeSetting].AvailabilityId = Parameter.MatchAvailability.AvailabilityId
                       WHERE Live.[Parameter.OddType].IsActive=1 and   (Live.[EventOddTypeSetting].MatchId = '+ cast(@MatchId as nvarchar(10))+')  and '+@where+ ' ; '+
' WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY  '+@orderby+ ') AS RowNum,  '+
'  Live.[EventOddTypeSetting].OddTypeSettingId, Live.[EventOddTypeSetting].OddTypeId, Live.[Parameter.OddType].OddType, Live.[EventOddTypeSetting].StateId, 
                      Live.[EventOddTypeSetting].LossLimit, Live.[EventOddTypeSetting].LimitPerTicket, Live.[EventOddTypeSetting].StakeLimit, Live.[EventOddTypeSetting].AvailabilityId, 
                      Live.[EventOddTypeSetting].MinCombiBranch, Live.[EventOddTypeSetting].MinCombiInternet, Live.[EventOddTypeSetting].MinCombiMachine, Parameter.MatchAvailability.Availability,
                       Parameter.MatchState.State, Live.[EventOddTypeSetting].MatchId,Parameter.MatchState.StatuColor,dbo.FuncCashFlow(Live.[EventOddTypeSetting].OddTypeId,Live.[EventOddTypeSetting].MatchId,1,1) as Cashflow,
                      '''' as SpecialBetValue,Live.[EventOddTypeSetting].IsPopular '+
' FROM        Live.[EventOddTypeSetting] with (nolock) INNER JOIN
                      Live.[Parameter.OddType] with (nolock) ON Live.[EventOddTypeSetting].OddTypeId = Live.[Parameter.OddType].OddTypeId INNER JOIN
                      Parameter.MatchState with (nolock) ON Live.[EventOddTypeSetting].StateId = Parameter.MatchState.StateId INNER JOIN
                      Parameter.MatchAvailability with (nolock) ON Live.[EventOddTypeSetting].AvailabilityId = Parameter.MatchAvailability.AvailabilityId '+
' WHERE Live.[Parameter.OddType].IsActive=1 and  (Live.[EventOddTypeSetting].MatchId  = '+ cast(@MatchId as nvarchar(10))+')  and '+@where +
'  )  '+
'			 SELECT *,@total as totalrow '+
'  FROM OrdersRN'+
' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(20))+')*('+cast(@PageSize  as nvarchar(10))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '



end


exec (@sqlcommand)
END


GO
