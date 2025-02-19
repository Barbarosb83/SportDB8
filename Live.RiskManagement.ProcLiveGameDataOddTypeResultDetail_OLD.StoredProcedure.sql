USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Live].[RiskManagement.ProcLiveGameDataOddTypeResultDetail_OLD]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Barbaros Babalı
-- Create date: 03.03.2015
-- Description:
-- =============================================
CREATE PROCEDURE [Live].[RiskManagement.ProcLiveGameDataOddTypeResultDetail_OLD] 
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

--if exists(select Archive.[Live.Event].EventId from Archive.[Live.Event] where Archive.[Live.Event].EventId=@MatchId)
--begin
--SELECT     Archive.[Live.EventOdd].OddId, Live.[Parameter.OddType].OddTypeId, Live.[Parameter.OddType].OddType, Archive.[Live.EventOdd].OutCome, Archive.[Live.EventOdd].SpecialBetValue, 
--                      Archive.[Live.EventOdd].OddValue, Archive.[Live.EventOdd].Suggestion,Archive.[Live.EventOdd].OddFactor, Archive.[Live.EventOdd].IsChanged,
--                             case when Archive.[Live.EventOdd].IsCanceled IS not null then 'Cancelled' 
--                       else case when Archive.[Live.EventOdd].IsEvaluated IS not null then (case when Archive.[Live.EventOdd].OddResult=1 then 'Won' else 'Lost' end)
--                      else case when Archive.[Live.EventOdd].OddResult IS not null then (case when Archive.[Live.EventOdd].OddResult=1 then 'Won*' else 'Lost*' end) 
--                      else case when Archive.[Live.EventOdd].VoidFactor is not null then 'Void' 
--                      else case when Archive.[Live.EventOdd].IsActive=1  then 'Open' else 'Close' end end end end end  as 'State' ,
--                      Archive.[Live.EventOddSetting].LossLimit, Archive.[Live.EventOddSetting].LimitPerTicket, Archive.[Live.EventOddSetting].StakeLimit, Archive.[Live.EventOddSetting].OddSettingId, 
--                      Archive.[Live.EventOddSetting].StateId, Archive.[Live.EventOddSetting].AvailabilityId, Archive.[Live.EventOdd].IsOddValueLock,   
                     
--					  dbo.FuncCashFlow(Archive.[Live.EventOdd].OddId,0,0,1) as Stake,
--					  (select COUNT(Customer.SlipOdd.MatchId) from Customer.SlipOdd with (nolock) where Customer.SlipOdd.OddId=Archive.[Live.EventOdd].OddId) as Bet
--FROM         Archive.[Live.EventOdd] INNER JOIN
--                      Live.[Parameter.OddType] ON Archive.[Live.EventOdd].OddsTypeId = Live.[Parameter.OddType].OddTypeId INNER JOIN
--                      Archive.[Live.EventOddSetting] ON Archive.[Live.EventOdd].OddId = Archive.[Live.EventOddSetting].OddId
--                    Where Archive.[Live.EventOdd].MatchId=@MatchId and Archive.[Live.EventOdd].OddsTypeId=@OddTypeId

--end
--else
--begin
-- SELECT     Live.EventOdd.OddId, Live.[Parameter.OddType].OddTypeId, Live.[Parameter.OddType].OddType, Live.EventOdd.OutCome, Live.EventOdd.SpecialBetValue, 
--                      Live.EventOdd.OddValue, Live.EventOdd.Suggestion,Live.EventOdd.OddFactor, Live.EventOdd.IsChanged, 
                    
--                      case when Live.EventOdd.IsCanceled IS not null then 'Cancelled' 
--                      else case when Live.EventOdd.IsEvaluated IS not null then (case when Live.EventOdd.OddResult=1 then 'Won' else 'Lost' end)
--                      else case when Live.EventOdd.OddResult IS not null then (case when Live.EventOdd.OddResult=1 then 'Won*' else 'Lost*' end) 
--                      else case when  Live.EventOdd.VoidFactor is not null then 'Void' 
--                      else case when Live.EventOdd.IsActive=1  then 'Open' else 'Close' end end end end end  as 'State' ,
                     
--                      Live.EventOddSetting.LossLimit, Live.EventOddSetting.LimitPerTicket, Live.EventOddSetting.StakeLimit, Live.EventOddSetting.OddSettingId, 
--                      Live.EventOddSetting.StateId, Live.EventOddSetting.AvailabilityId, Live.EventOdd.IsOddValueLock,   
                      
--					  dbo.FuncCashFlow(Live.EventOdd.OddId,0,0,1) as Stake,
--					  (select COUNT(Customer.SlipOdd.MatchId) from Customer.SlipOdd with (nolock) where Customer.SlipOdd.OddId=Live.EventOdd.OddId) as Bet
--FROM         Live.EventOdd INNER JOIN
--                      Live.[Parameter.OddType] ON Live.EventOdd.OddsTypeId = Live.[Parameter.OddType].OddTypeId INNER JOIN
--                      Live.EventOddSetting ON Live.EventOdd.OddId = Live.EventOddSetting.OddId
--                    Where Live.EventOdd.MatchId=@MatchId and Live.EventOdd.OddsTypeId=@OddTypeId

  
--  end



if exists(select Archive.[Live.Event].EventId from Archive.[Live.Event] with (nolock) where Archive.[Live.Event].EventId=@MatchId)
begin
SELECT     Archive.[Live.EventOdd].OddId, Live.[Parameter.OddType].OddTypeId, Live.[Parameter.OddType].OddType, Archive.[Live.EventOdd].OutCome

,case when Archive.[Live.EventOdd].ParameterOddId in (108,112,116,129,137,143,149,192,387,389,426,428,1947,2059,2503,2505,2553,2965,3257) 
  then CAST( cast(Archive.[Live.EventOdd].SpecialBetValue AS float)*-1 AS nvarchar(10))
  else case when Archive.[Live.EventOdd].SpecialBetValue<>'-1' then  ISNULL(Archive.[Live.EventOdd].SpecialBetValue,'') else '' end end as SpecialBetValue , 
                      Archive.[Live.EventOdd].OddValue, Archive.[Live.EventOdd].Suggestion,Archive.[Live.EventOdd].OddFactor, Archive.[Live.EventOdd].IsChanged,
                        Parameter.MatchState.[State] as 'State' ,
                      Archive.[Live.EventOddTypeSetting].LossLimit, Archive.[Live.EventOddTypeSetting].LimitPerTicket, Archive.[Live.EventOddTypeSetting].StakeLimit, Archive.[Live.EventOddTypeSetting].OddTypeSettingId as OddSettingId, 
                     Archive.[Live.EventOdd].StateId, Archive.[Live.EventOddTypeSetting].AvailabilityId, Archive.[Live.EventOdd].IsOddValueLock,   
                     
					  dbo.FuncCashFlow(Archive.[Live.EventOdd].OddId,0,0,1) as Stake,
					  (select COUNT(Customer.SlipOdd.MatchId) from Customer.SlipOdd with (nolock) where Customer.SlipOdd.OddId=Archive.[Live.EventOdd].OddId) as Bet
					     , Parameter.MatchState.StatuColor AS StatuColor
FROM         Archive.[Live.EventOdd] with (nolock) INNER JOIN
                      Live.[Parameter.OddType] with (nolock) ON Archive.[Live.EventOdd].OddsTypeId = Live.[Parameter.OddType].OddTypeId INNER JOIN
                      Archive.[Live.EventOddTypeSetting] with (nolock) ON Archive.[Live.EventOdd].OddsTypeId = Archive.[Live.EventOddTypeSetting].OddTypeId  and Archive.[Live.EventOdd].MatchId = Archive.[Live.EventOddTypeSetting].MatchId LEFT OUTER JOIN 
					   Archive.[Live.EventOddResult] with (nolock) On Archive.[Live.EventOddResult].OddId=Archive.[Live.EventOdd].OddId INNER JOIN
					  Parameter.MatchState with (nolock) On ISNULL(Archive.[Live.EventOdd].StateId,2)=Parameter.MatchState.StateId
                    Where Archive.[Live.EventOdd].MatchId=@MatchId and Archive.[Live.EventOdd].OddsTypeId=@OddTypeId

end
else
begin
 SELECT     Live.EventOdd.OddId, Live.[Parameter.OddType].OddTypeId, Live.[Parameter.OddType].OddType, Live.EventOdd.OutCome
 ,case when Live.EventOdd.ParameterOddId in (108,112,116,129,137,143,149,192,387,389,426,428,1947,2059,2503,2505,2553,2965,3257) 
  then CAST( cast(Live.EventOdd.SpecialBetValue AS float)*-1 AS nvarchar(10))
  else case when Live.EventOdd.SpecialBetValue<>'-1' then  ISNULL(Live.EventOdd.SpecialBetValue,'') else '' end end as SpecialBetValue , 
                      Live.EventOdd.OddValue, Live.EventOdd.Suggestion,Live.EventOdd.OddFactor, Live.EventOdd.IsChanged, 
                    
                     ISNULL( Parameter.MatchState.[State],'Open') as 'State' ,
                     
                      Live.EventOddTypeSetting.LossLimit, Live.EventOddTypeSetting.LimitPerTicket, Live.EventOddTypeSetting.StakeLimit, Live.EventOddTypeSetting.OddTypeSettingId as OddSettingId, 
                      Live.EventOddResult.StateId  as StateId, Live.EventOddTypeSetting.AvailabilityId, Live.EventOdd.IsOddValueLock,   
                      
					  dbo.FuncCashFlow(Live.EventOddResult.OddId,0,0,1) as Stake,
					  (select COUNT(Customer.SlipOdd.MatchId) from Customer.SlipOdd with (nolock) where Customer.SlipOdd.OddId=Live.EventOdd.OddId) as Bet
					   , ISNULL(Parameter.MatchState.StatuColor,1) AS StatuColor
FROM         Live.EventOdd with (nolock) INNER JOIN
                      Live.[Parameter.OddType] with (nolock) ON Live.EventOdd.OddsTypeId = Live.[Parameter.OddType].OddTypeId LEFT OUTER JOIN
					  Live.EventOddResult with (nolock) On Live.EventOddResult.OddId=Live.EventOdd.OddId INNER JOIN
                      Live.EventOddTypeSetting with (nolock) ON Live.EventOdd.OddsTypeId = Live.EventOddTypeSetting.OddTypeId and Live.EventOdd.MatchId = Live.EventOddTypeSetting.MatchId  LEFT OUTER JOIN 
					  Parameter.MatchState with (nolock) On Live.EventOddResult.StateId=Parameter.MatchState.StateId

                    Where Live.EventOdd.MatchId=@MatchId and Live.EventOdd.OddsTypeId=@OddTypeId

  
  end


END


GO
