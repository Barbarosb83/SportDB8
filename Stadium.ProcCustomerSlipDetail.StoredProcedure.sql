USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Stadium].[ProcCustomerSlipDetail]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Stadium].[ProcCustomerSlipDetail] 
@SlipId bigint,
@LangId int
AS

BEGIN
SET NOCOUNT ON;


if exists (select Stadium.SlipOdd.SlipId from Stadium.SlipOdd with (nolock) where Stadium.SlipOdd.SlipId=@SlipId)
begin
	
	if exists (select Stadium.Slip.SlipId from Stadium.Slip with (nolock) where Stadium.Slip.SlipTypeId<>3 and Stadium.Slip.SlipId=@SlipId)
	begin
	SELECT   Stadium.SlipOdd.SlipId,case when  Parameter.SlipState.StateId=5 then 3 else Parameter.SlipState.StateId end as StateId ,Language.[Parameter.SlipState].SlipState as State, Stadium.SlipOdd.EventName as EventName, Language.[Parameter.OddsType].OddsType, 
						  Stadium.SlipOdd.OutCome AS Outcomes, Stadium.SlipOdd.OddValue, Stadium.SlipOdd.EventDate,
								  [dbo].[FuncScore2](Stadium.SlipOdd.BetradarMatchId,0) AS Result,case when Stadium.SlipOdd.ParameterOddId IN (1578,1544,1540,1648,1646,1644,1642,2247,2321,2325,2465,2541,2543,2915,2973,2993,2997,3010,3052,3079,3350,3371,3393) then CAST( cast(Stadium.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10)) else ISNULL(Stadium.SlipOdd.SpecialBetValue, '') end AS SpecialBetValue
								   ,Stadium.SlipOdd.MatchId,Stadium.SlipOdd.BetradarMatchId,Stadium.SlipOdd.Banko
	FROM         Parameter.SlipState INNER JOIN
						  Stadium.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Stadium.SlipOdd.StateId INNER JOIN
						  Language.[Parameter.OddsType] with (nolock) ON Stadium.SlipOdd.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId INNER JOIN
						  Language.[Parameter.SlipState] with (nolock) ON Language.[Parameter.SlipState].[SlipStateId]=Parameter.SlipState.StateId
	WHERE     (Stadium.SlipOdd.SlipId = @SlipId) AND (Language.[Parameter.OddsType].LanguageId = @LangId) and Language.[Parameter.SlipState].LanguageId=@LangId AND (Stadium.SlipOdd.BetTypeId = 0)
	UNION ALL
	SELECT     Stadium.SlipOdd.SlipId,case when  Parameter.SlipState.StateId=5 then 3 else Parameter.SlipState.StateId end as StateId, Language.[Parameter.SlipState].SlipState as State, Stadium.SlipOdd.EventName+' (Live)' as EventName,Language.[Parameter.LiveOddType].OddsType AS OddsType, 
		   --             case when (select COUNT(OutCome) from Live.EventOdd where Live.EventOdd.MatchId=Stadium.SlipOdd.MatchId and Live.EventOdd.OddsTypeId=Stadium.SlipOdd.OddsTypeId and Live.EventOdd.OddResult=1 and ISNULL(Live.EventOdd.SpecialBetValue,'')= case when  Stadium.SlipOdd.SpecialBetValue is not null then  Stadium.SlipOdd.SpecialBetValue else '' end )>0 then  Stadium.SlipOdd.OutCome 
					   --else case when (select COUNT(OutCome) from Archive.[Live.EventOdd] where Archive.[Live.EventOdd].MatchId=Stadium.SlipOdd.MatchId and Archive.[Live.EventOdd].OddsTypeId=Stadium.SlipOdd.OddsTypeId and Archive.[Live.EventOdd].OddResult=1 and Archive.[Live.EventOdd].SpecialBetValue=Stadium.SlipOdd.SpecialBetValue)>0  then  Stadium.SlipOdd.OutCome else  Stadium.SlipOdd.OutCome end end 
						Stadium.SlipOdd.OutCome AS Outcomes
					   , Stadium.SlipOdd.OddValue, Stadium.SlipOdd.EventDate,
		   [dbo].[FuncScore2](Stadium.SlipOdd.BetradarMatchId,1) AS Result
					   ,case when Stadium.SlipOdd.ParameterOddId in (108,112,116,129,137,143,149,192,387,389,426,428,1947,2059,2503,2505,2553,2965,3257) 
	  then CAST( cast(Stadium.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10))
	  else case when Stadium.SlipOdd.SpecialBetValue<>'-1' then  ISNULL(Stadium.SlipOdd.SpecialBetValue,'') else '' end end as SpecialBetValue
	  ,Stadium.SlipOdd.MatchId,Stadium.SlipOdd.BetradarMatchId,Stadium.SlipOdd.Banko
	FROM         Parameter.SlipState with (nolock) INNER JOIN
						  Stadium.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Stadium.SlipOdd.StateId INNER JOIN
						  Live.[Parameter.OddType] with (nolock) ON Stadium.SlipOdd.OddsTypeId = Live.[Parameter.OddType].OddTypeId INNER JOIN
						  Language.[Parameter.LiveOddType] with (nolock) ON Live.[Parameter.OddType].OddTypeId= Language.[Parameter.LiveOddType].OddTypeId INNER JOIN
						  Language.[Parameter.SlipState] with (nolock) ON Language.[Parameter.SlipState].[SlipStateId]=Parameter.SlipState.StateId
	WHERE     (Stadium.SlipOdd.SlipId = @SlipId) and Stadium.SlipOdd.BetTypeId=1 and  Language.[Parameter.LiveOddType].LanguageId=@LangId and Language.[Parameter.SlipState].LanguageId=@LangId
	UNION ALL
	SELECT   DISTINCT  Stadium.SlipOdd.SlipId,Parameter.SlipState.StateId, Language.[Parameter.SlipState].SlipState as State, Stadium.SlipOdd.EventName,  Language.[Parameter.OddsType].OddsType, Stadium.SlipOdd.OutCome AS Outcomes, 
						  Stadium.SlipOdd.OddValue, Stadium.SlipOdd.EventDate, '-' AS Result, 
						  Stadium.SlipOdd.SpecialBetValue,Stadium.SlipOdd.MatchId,Stadium.SlipOdd.BetradarMatchId,Stadium.SlipOdd.Banko
	FROM         Parameter.SlipState INNER JOIN
						  Stadium.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Stadium.SlipOdd.StateId INNER JOIN
						   Language.[Parameter.OddsType] with (nolock) ON Stadium.SlipOdd.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId INNER JOIN
						  Language.[Parameter.SlipState] with (nolock) ON Language.[Parameter.SlipState].[SlipStateId]=Parameter.SlipState.StateId
	WHERE     (Stadium.SlipOdd.SlipId = @SlipId)  AND (Language.[Parameter.OddsType].LanguageId = @LangId) AND (Stadium.SlipOdd.BetTypeId = 2) and Language.[Parameter.SlipState].LanguageId=@LangId
	--UNION ALL
	--	SELECT   case when  Parameter.SlipState.StateId=5 then 3 else Parameter.SlipState.StateId end as StateId 
	--,Language.[Parameter.SlipState].SlipState as State, Stadium.SlipOdd.EventName as EventName, LSports.[Parameter.OutcomeType].OutcomeType AS OddsType, 
	--					  Stadium.SlipOdd.OutCome AS Outcomes, Stadium.SlipOdd.OddValue, Stadium.SlipOdd.EventDate,
	--							   '' AS Result,cast('' as nvarchar(20)) AS SpecialBetValue
	--							   ,Stadium.SlipOdd.MatchId
	--FROM         Parameter.SlipState INNER JOIN
	--					  Stadium.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Stadium.SlipOdd.StateId INNER JOIN
	--					  LSports.[Parameter.OutcomeType] ON Stadium.SlipOdd.OddsTypeId = LSports.[Parameter.OutcomeType].OutcomeTypeId INNER JOIN
	--					  Language.[Parameter.SlipState] ON Language.[Parameter.SlipState].[SlipStateId]=Parameter.SlipState.StateId
	--WHERE     (Stadium.SlipOdd.SlipId = @SlipId) and Language.[Parameter.SlipState].LanguageId=@LangId AND (Stadium.SlipOdd.BetTypeId = 4)
	
	--UNION ALL
	--SELECT     Parameter.SlipState.StateId,Language.[Parameter.SlipState].SlipState as State, Stadium.SlipOdd.EventName, Virtual.[Parameter.OddType].OddType AS OddsType, 
	--					  Stadium.SlipOdd.OutCome AS Outcomes, Stadium.SlipOdd.OddValue, Stadium.SlipOdd.EventDate,Stadium.SlipOdd.Score as Result,Stadium.SlipOdd.SpecialBetValue,Stadium.SlipOdd.MatchId
	--FROM         Parameter.SlipState INNER JOIN
	--					  Stadium.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Stadium.SlipOdd.StateId INNER JOIN
	--					  Virtual.[Parameter.OddType] ON Stadium.SlipOdd.OddsTypeId = Virtual.[Parameter.OddType].OddTypeId INNER JOIN
	--					  Language.[Parameter.SlipState] ON Language.[Parameter.SlipState].[SlipStateId]=Parameter.SlipState.StateId
	--WHERE     (Stadium.SlipOdd.SlipId = @SlipId) and Stadium.SlipOdd.BetTypeId=3 and Language.[Parameter.SlipState].LanguageId=@LangId
	end


end
else
begin

	if exists (select Archive.Slip.SlipId from Archive.Slip with (nolock) where Archive.Slip.SlipTypeId<>3 and Archive.Slip.SlipId=@SlipId)
	begin
			SELECT   Archive.SlipOdd.SlipId,case when  Parameter.SlipState.StateId=5 then 3 else Parameter.SlipState.StateId end as StateId ,Language.[Parameter.SlipState].SlipState as State, Archive.SlipOdd.EventName as EventName, Language.[Parameter.OddsType].OddsType, 
								  Archive.SlipOdd.OutCome AS Outcomes, Archive.SlipOdd.OddValue, Archive.SlipOdd.EventDate,
										   [dbo].[FuncScore2](Archive.SlipOdd.BetradarMatchId,0) AS Result,case when Archive.SlipOdd.ParameterOddId IN (2247,2321,2325,2465,2541,2543,2915,2973,2993,2997,3010,3052,3079,3350,3371,3393) then CAST( cast(Archive.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10)) else ISNULL(Archive.SlipOdd.SpecialBetValue, '') end AS SpecialBetValue
										   ,Archive.SlipOdd.MatchId,Archive.SlipOdd.BetradarMatchId,Archive.SlipOdd.Banko
			FROM         Parameter.SlipState with (nolock) INNER JOIN
								  Archive.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Archive.SlipOdd.StateId INNER JOIN
								  Language.[Parameter.OddsType] with (nolock) ON Archive.SlipOdd.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId INNER JOIN
								  Language.[Parameter.SlipState] with (nolock) ON Language.[Parameter.SlipState].[SlipStateId]=Parameter.SlipState.StateId
			WHERE     (Archive.SlipOdd.SlipId = @SlipId) AND (Language.[Parameter.OddsType].LanguageId = @LangId) and Language.[Parameter.SlipState].LanguageId=@LangId AND (Archive.SlipOdd.BetTypeId = 0)
			UNION ALL
			SELECT     Archive.SlipOdd.SlipId,case when  Parameter.SlipState.StateId=5 then 3 else Parameter.SlipState.StateId end as StateId, Language.[Parameter.SlipState].SlipState as State, Archive.SlipOdd.EventName,Language.[Parameter.LiveOddType].OddsType AS OddsType, 
				   --             case when (select COUNT(OutCome) from Live.EventOdd where Live.EventOdd.MatchId=Archive.SlipOdd.MatchId and Live.EventOdd.OddsTypeId=Archive.SlipOdd.OddsTypeId and Live.EventOdd.OddResult=1 and ISNULL(Live.EventOdd.SpecialBetValue,'')= case when  Archive.SlipOdd.SpecialBetValue is not null then  Archive.SlipOdd.SpecialBetValue else '' end )>0 then  Archive.SlipOdd.OutCome 
							   --else case when (select COUNT(OutCome) from Archive.[Live.EventOdd] where Archive.[Live.EventOdd].MatchId=Archive.SlipOdd.MatchId and Archive.[Live.EventOdd].OddsTypeId=Archive.SlipOdd.OddsTypeId and Archive.[Live.EventOdd].OddResult=1 and Archive.[Live.EventOdd].SpecialBetValue=Archive.SlipOdd.SpecialBetValue)>0  then  Archive.SlipOdd.OutCome else  Archive.SlipOdd.OutCome end end 
								Archive.SlipOdd.OutCome AS Outcomes
							   , Archive.SlipOdd.OddValue, Archive.SlipOdd.EventDate,
				   [dbo].[FuncScore2](Archive.SlipOdd.BetradarMatchId,1) AS Result
							   ,case when Archive.SlipOdd.ParameterOddId in (108,112,116,129,137,143,149,192,387,389,426,428,1947,2059,2503,2505,2553,2965) 
			  then CAST( cast(Archive.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10))
			  else case when Archive.SlipOdd.SpecialBetValue<>'-1' then  ISNULL(Archive.SlipOdd.SpecialBetValue,'') else '' end end as SpecialBetValue
			  ,Archive.SlipOdd.MatchId,Archive.SlipOdd.BetradarMatchId,Archive.SlipOdd.Banko
			FROM         Parameter.SlipState with (nolock) INNER JOIN
								  Archive.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Archive.SlipOdd.StateId INNER JOIN
								  Live.[Parameter.OddType] with (nolock) ON Archive.SlipOdd.OddsTypeId = Live.[Parameter.OddType].OddTypeId INNER JOIN
								  Language.[Parameter.LiveOddType] with (nolock) ON Live.[Parameter.OddType].OddTypeId= Language.[Parameter.LiveOddType].OddTypeId INNER JOIN
								  Language.[Parameter.SlipState]  with (nolock) ON Language.[Parameter.SlipState].[SlipStateId]=Parameter.SlipState.StateId
			WHERE     (Archive.SlipOdd.SlipId = @SlipId) and Archive.SlipOdd.BetTypeId=1 and  Language.[Parameter.LiveOddType].LanguageId=@LangId and Language.[Parameter.SlipState].LanguageId=@LangId
			UNION ALL
			SELECT    Archive.SlipOdd.SlipId, Parameter.SlipState.StateId, Language.[Parameter.SlipState].SlipState as State, Archive.SlipOdd.EventName, '' AS OddsType, Archive.SlipOdd.OutCome AS Outcomes, 
								  Archive.SlipOdd.OddValue, Archive.SlipOdd.EventDate, '-' AS Result, 
								  Archive.SlipOdd.SpecialBetValue,Archive.SlipOdd.MatchId,Archive.SlipOdd.BetradarMatchId,Archive.SlipOdd.Banko
			FROM         Parameter.SlipState with (nolock) INNER JOIN
								  Archive.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Archive.SlipOdd.StateId INNER JOIN
								  Language.[Parameter.SlipState] with (nolock) ON Language.[Parameter.SlipState].[SlipStateId]=Parameter.SlipState.StateId
			WHERE     (Archive.SlipOdd.SlipId = @SlipId) AND (Archive.SlipOdd.BetTypeId = 2) and Language.[Parameter.SlipState].LanguageId=@LangId
			--UNION ALL
			--	SELECT   case when  Parameter.SlipState.StateId=5 then 3 else Parameter.SlipState.StateId end as StateId 
			--,Language.[Parameter.SlipState].SlipState as State, Stadium.SlipOdd.EventName as EventName, LSports.[Parameter.OutcomeType].OutcomeType AS OddsType, 
			--					  Stadium.SlipOdd.OutCome AS Outcomes, Stadium.SlipOdd.OddValue, Stadium.SlipOdd.EventDate,
			--							   '' AS Result,cast('' as nvarchar(20)) AS SpecialBetValue
			--							   ,Stadium.SlipOdd.MatchId
			--FROM         Parameter.SlipState INNER JOIN
			--					  Stadium.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Stadium.SlipOdd.StateId INNER JOIN
			--					  LSports.[Parameter.OutcomeType] ON Stadium.SlipOdd.OddsTypeId = LSports.[Parameter.OutcomeType].OutcomeTypeId INNER JOIN
			--					  Language.[Parameter.SlipState] ON Language.[Parameter.SlipState].[SlipStateId]=Parameter.SlipState.StateId
			--WHERE     (Stadium.SlipOdd.SlipId = @SlipId) and Language.[Parameter.SlipState].LanguageId=@LangId AND (Stadium.SlipOdd.BetTypeId = 4)
	
			--UNION ALL
			--SELECT     Parameter.SlipState.StateId,Language.[Parameter.SlipState].SlipState as State, Archive.SlipOdd.EventName, Virtual.[Parameter.OddType].OddType AS OddsType, 
			--					  Archive.SlipOdd.OutCome AS Outcomes, Archive.SlipOdd.OddValue, Archive.SlipOdd.EventDate,Archive.SlipOdd.Score as Result,Archive.SlipOdd.SpecialBetValue,Archive.SlipOdd.MatchId
			--FROM         Parameter.SlipState INNER JOIN
			--					  Archive.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Archive.SlipOdd.StateId INNER JOIN
			--					  Virtual.[Parameter.OddType] ON Archive.SlipOdd.OddsTypeId = Virtual.[Parameter.OddType].OddTypeId INNER JOIN
			--					  Language.[Parameter.SlipState] ON Language.[Parameter.SlipState].[SlipStateId]=Parameter.SlipState.StateId
			--WHERE     (Archive.SlipOdd.SlipId = @SlipId) and Archive.SlipOdd.BetTypeId=3 and Language.[Parameter.SlipState].LanguageId=@LangId
	end
	else
		begin
			SELECT  DISTINCT cast(0 as bigint) as SlipId,case when  Parameter.SlipState.StateId=5 then 3 else Parameter.SlipState.StateId end as StateId ,Language.[Parameter.SlipState].SlipState as State, Archive.SlipOdd.EventName as EventName, Language.[Parameter.OddsType].OddsType, 
								  Archive.SlipOdd.OutCome AS Outcomes, Archive.SlipOdd.OddValue, Archive.SlipOdd.EventDate,
										   [dbo].[FuncScore2](Archive.SlipOdd.BetradarMatchId,0) AS Result,case when Archive.SlipOdd.ParameterOddId IN (2247,2321,2325,2465,2541,2543,2915,2973,2993,2997,3010,3052,3079,3350,3371,3393) then CAST( cast(Archive.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10)) else ISNULL(Archive.SlipOdd.SpecialBetValue, '') end AS SpecialBetValue
										   ,Archive.SlipOdd.MatchId,Archive.SlipOdd.BetradarMatchId,Archive.SlipOdd.Banko
			FROM         Parameter.SlipState with (nolock) INNER JOIN
								  Archive.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Archive.SlipOdd.StateId INNER JOIN
								  Language.[Parameter.OddsType] with (nolock) ON Archive.SlipOdd.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId INNER JOIN
								  Language.[Parameter.SlipState] with (nolock) ON Language.[Parameter.SlipState].[SlipStateId]=Parameter.SlipState.StateId
			WHERE    (Archive.SlipOdd.SlipId in (select Stadium.SlipSystemSlip.SlipId from Stadium.SlipSystemSlip where Stadium.SlipSystemSlip.SystemSlipId=(select top 1 Stadium.SlipSystemSlip.SystemSlipId from Stadium.SlipSystemSlip where Stadium.SlipSystemSlip.SlipId=@SlipId)) )  AND (Language.[Parameter.OddsType].LanguageId = @LangId) and Language.[Parameter.SlipState].LanguageId=@LangId AND (Archive.SlipOdd.BetTypeId = 0)
			UNION ALL
			SELECT    DISTINCT cast(0 as bigint) as SlipId,case when  Parameter.SlipState.StateId=5 then 3 else Parameter.SlipState.StateId end as StateId, Language.[Parameter.SlipState].SlipState as State, Archive.SlipOdd.EventName,Language.[Parameter.LiveOddType].OddsType AS OddsType, 
				   --             case when (select COUNT(OutCome) from Live.EventOdd where Live.EventOdd.MatchId=Archive.SlipOdd.MatchId and Live.EventOdd.OddsTypeId=Archive.SlipOdd.OddsTypeId and Live.EventOdd.OddResult=1 and ISNULL(Live.EventOdd.SpecialBetValue,'')= case when  Archive.SlipOdd.SpecialBetValue is not null then  Archive.SlipOdd.SpecialBetValue else '' end )>0 then  Archive.SlipOdd.OutCome 
							   --else case when (select COUNT(OutCome) from Archive.[Live.EventOdd] where Archive.[Live.EventOdd].MatchId=Archive.SlipOdd.MatchId and Archive.[Live.EventOdd].OddsTypeId=Archive.SlipOdd.OddsTypeId and Archive.[Live.EventOdd].OddResult=1 and Archive.[Live.EventOdd].SpecialBetValue=Archive.SlipOdd.SpecialBetValue)>0  then  Archive.SlipOdd.OutCome else  Archive.SlipOdd.OutCome end end 
								Archive.SlipOdd.OutCome AS Outcomes
							   , Archive.SlipOdd.OddValue, Archive.SlipOdd.EventDate,
				   [dbo].[FuncScore2](Archive.SlipOdd.BetradarMatchId,1) AS Result
							   ,case when Archive.SlipOdd.ParameterOddId in (108,112,116,129,137,143,149,192,387,389,426,428,1947,2059,2503,2505,2553,2965) 
			  then CAST( cast(Archive.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10))
			  else case when Archive.SlipOdd.SpecialBetValue<>'-1' then  ISNULL(Archive.SlipOdd.SpecialBetValue,'') else '' end end as SpecialBetValue
			  ,Archive.SlipOdd.MatchId,Archive.SlipOdd.BetradarMatchId,Archive.SlipOdd.Banko
			FROM         Parameter.SlipState INNER JOIN
								  Archive.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Archive.SlipOdd.StateId INNER JOIN
								  Live.[Parameter.OddType] with (nolock) ON Archive.SlipOdd.OddsTypeId = Live.[Parameter.OddType].OddTypeId INNER JOIN
								  Language.[Parameter.LiveOddType] with (nolock) ON Live.[Parameter.OddType].OddTypeId= Language.[Parameter.LiveOddType].OddTypeId INNER JOIN
								  Language.[Parameter.SlipState] with (nolock) ON Language.[Parameter.SlipState].[SlipStateId]=Parameter.SlipState.StateId
			WHERE      (Archive.SlipOdd.SlipId in (select Stadium.SlipSystemSlip.SlipId from Stadium.SlipSystemSlip with (nolock) where Stadium.SlipSystemSlip.SystemSlipId=(select top 1 Stadium.SlipSystemSlip.SystemSlipId from Stadium.SlipSystemSlip with (nolock) where Stadium.SlipSystemSlip.SlipId=@SlipId)) )  and Archive.SlipOdd.BetTypeId=1 and  Language.[Parameter.LiveOddType].LanguageId=@LangId and Language.[Parameter.SlipState].LanguageId=@LangId
			UNION ALL
			SELECT  DISTINCT  cast(0 as bigint) as SlipId, Parameter.SlipState.StateId, Language.[Parameter.SlipState].SlipState as State, Archive.SlipOdd.EventName, '' AS OddsType, Archive.SlipOdd.OutCome AS Outcomes, 
								  Archive.SlipOdd.OddValue, Archive.SlipOdd.EventDate, '-' AS Result, 
								  Archive.SlipOdd.SpecialBetValue,Archive.SlipOdd.MatchId,Archive.SlipOdd.BetradarMatchId,Archive.SlipOdd.Banko
			FROM         Parameter.SlipState INNER JOIN
								  Archive.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Archive.SlipOdd.StateId INNER JOIN
								  Language.[Parameter.SlipState] ON Language.[Parameter.SlipState].[SlipStateId]=Parameter.SlipState.StateId
			WHERE     (Archive.SlipOdd.SlipId in (select Stadium.SlipSystemSlip.SlipId from Stadium.SlipSystemSlip with (nolock) where Stadium.SlipSystemSlip.SystemSlipId=(select top 1 Stadium.SlipSystemSlip.SystemSlipId from Stadium.SlipSystemSlip with (nolock) where Stadium.SlipSystemSlip.SlipId=@SlipId)) )  AND (Archive.SlipOdd.BetTypeId = 2) and Language.[Parameter.SlipState].LanguageId=@LangId
			--UNION ALL
			--	SELECT   case when  Parameter.SlipState.StateId=5 then 3 else Parameter.SlipState.StateId end as StateId 
			--,Language.[Parameter.SlipState].SlipState as State, Stadium.SlipOdd.EventName as EventName, LSports.[Parameter.OutcomeType].OutcomeType AS OddsType, 
			--					  Stadium.SlipOdd.OutCome AS Outcomes, Stadium.SlipOdd.OddValue, Stadium.SlipOdd.EventDate,
			--							   '' AS Result,cast('' as nvarchar(20)) AS SpecialBetValue
			--							   ,Stadium.SlipOdd.MatchId
			--FROM         Parameter.SlipState INNER JOIN
			--					  Stadium.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Stadium.SlipOdd.StateId INNER JOIN
			--					  LSports.[Parameter.OutcomeType] ON Stadium.SlipOdd.OddsTypeId = LSports.[Parameter.OutcomeType].OutcomeTypeId INNER JOIN
			--					  Language.[Parameter.SlipState] ON Language.[Parameter.SlipState].[SlipStateId]=Parameter.SlipState.StateId
			--WHERE     (Stadium.SlipOdd.SlipId = @SlipId) and Language.[Parameter.SlipState].LanguageId=@LangId AND (Stadium.SlipOdd.BetTypeId = 4)
	
			--UNION ALL
			--SELECT     Parameter.SlipState.StateId,Language.[Parameter.SlipState].SlipState as State, Archive.SlipOdd.EventName, Virtual.[Parameter.OddType].OddType AS OddsType, 
			--					  Archive.SlipOdd.OutCome AS Outcomes, Archive.SlipOdd.OddValue, Archive.SlipOdd.EventDate,Archive.SlipOdd.Score as Result,Archive.SlipOdd.SpecialBetValue,Archive.SlipOdd.MatchId
			--FROM         Parameter.SlipState INNER JOIN
			--					  Archive.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Archive.SlipOdd.StateId INNER JOIN
			--					  Virtual.[Parameter.OddType] ON Archive.SlipOdd.OddsTypeId = Virtual.[Parameter.OddType].OddTypeId INNER JOIN
			--					  Language.[Parameter.SlipState] ON Language.[Parameter.SlipState].[SlipStateId]=Parameter.SlipState.StateId
			--WHERE     (Archive.SlipOdd.SlipId = @SlipId) and Archive.SlipOdd.BetTypeId=3 and Language.[Parameter.SlipState].LanguageId=@LangId

		end

end



END




GO
