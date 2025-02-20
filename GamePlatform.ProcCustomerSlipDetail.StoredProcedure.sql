USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerSlipDetail]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [GamePlatform].[ProcCustomerSlipDetail] 
@SlipId bigint,
@LangId int
AS

BEGIN
SET NOCOUNT ON;


if exists (select Customer.SlipOdd.SlipId from Customer.SlipOdd with (nolock) where Customer.SlipOdd.SlipId=@SlipId)
begin
	
	if exists (select Customer.Slip.SlipId from Customer.Slip with (nolock) where Customer.Slip.SlipTypeId<3 and Customer.Slip.SlipId=@SlipId)
	begin
	SELECT   Customer.SlipOdd.SlipId,case when  Customer.SlipOdd.StateId=5 then 3 else Customer.SlipOdd.StateId end as StateId ,Language.[Parameter.SlipState].SlipState as State, Customer.SlipOdd.EventName as EventName, Language.[Parameter.OddsType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI as OddsType, 
						  Customer.SlipOdd.OutCome AS Outcomes, Customer.SlipOdd.OddValue, Customer.SlipOdd.EventDate,
								  [dbo].[FuncScore2](Customer.SlipOdd.BetradarMatchId,0) AS Result,case when Customer.SlipOdd.ParameterOddId IN (1578,1544,1540,1648,1646,1644,1642,2247,2321,2325,2465,2541,2543,2915,2973,2993,2997,3010,3052,3079,3350,3371,3393) then CAST( cast(Customer.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10)) else case when Customer.SlipOdd.OddsTypeId in (1497,1911,1493) then case when cast(Customer.SlipOdd.SpecialBetValue AS float)<0 then  '0:'+CAST( cast(Customer.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10)) else  ISNULL(Customer.SlipOdd.SpecialBetValue, '')+':0' end else  ISNULL(Customer.SlipOdd.SpecialBetValue, '') end end AS SpecialBetValue
								   ,Customer.SlipOdd.MatchId,Customer.SlipOdd.BetradarMatchId,Customer.SlipOdd.Banko
	FROM        
						  Customer.SlipOdd with (nolock)  INNER JOIN
						  Language.[Parameter.OddsType] with (nolock) ON Customer.SlipOdd.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId INNER JOIN
						  Language.[Parameter.SlipState] with (nolock) ON Language.[Parameter.SlipState].[SlipStateId]=Customer.SlipOdd.StateId
	WHERE     (Customer.SlipOdd.SlipId = @SlipId) AND (Language.[Parameter.OddsType].LanguageId = @LangId) and Language.[Parameter.SlipState].LanguageId=@LangId AND (Customer.SlipOdd.BetTypeId = 0)
	UNION ALL
	SELECT     Customer.SlipOdd.SlipId,case when  Customer.SlipOdd.StateId=5 then 3 else Customer.SlipOdd.StateId end as StateId, Language.[Parameter.SlipState].SlipState as State, Customer.SlipOdd.EventName+' (Live)' as EventName,Language.[Parameter.LiveOddType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI AS OddsType, 
						Customer.SlipOdd.OutCome AS Outcomes
					   , Customer.SlipOdd.OddValue, Customer.SlipOdd.EventDate,
		   [dbo].[FuncScore2](Customer.SlipOdd.BetradarMatchId,1) AS Result
					   ,case when Customer.SlipOdd.ParameterOddId in (108,112,116,129,137,143,149,192,387,389,426,428,1947,2059,2503,2505,2553,2965,3257) 
	  then CAST( cast(Customer.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10))
	  else case when Customer.SlipOdd.SpecialBetValue<>'-1' then  ISNULL(Customer.SlipOdd.SpecialBetValue,'') else '' end end as SpecialBetValue
	  ,Customer.SlipOdd.MatchId,Customer.SlipOdd.BetradarMatchId,Customer.SlipOdd.Banko
	FROM       
						  Customer.SlipOdd with (nolock)  INNER JOIN
						  Live.[Parameter.OddType] with (nolock) ON Customer.SlipOdd.OddsTypeId = Live.[Parameter.OddType].OddTypeId INNER JOIN
						  Language.[Parameter.LiveOddType] with (nolock) ON Live.[Parameter.OddType].OddTypeId= Language.[Parameter.LiveOddType].OddTypeId INNER JOIN
						  Language.[Parameter.SlipState] with (nolock) ON Language.[Parameter.SlipState].[SlipStateId]=Customer.SlipOdd.StateId
	WHERE     (Customer.SlipOdd.SlipId = @SlipId) and Customer.SlipOdd.BetTypeId=1 and  Language.[Parameter.LiveOddType].LanguageId=@LangId and Language.[Parameter.SlipState].LanguageId=@LangId
	UNION ALL
	SELECT   DISTINCT  Customer.SlipOdd.SlipId,Parameter.SlipState.StateId, Language.[Parameter.SlipState].SlipState as State, Customer.SlipOdd.EventName,  Customer.SlipOdd.EventName as OddsType, Customer.SlipOdd.OutCome AS Outcomes, 
						  Customer.SlipOdd.OddValue, Customer.SlipOdd.EventDate, '-' AS Result, 
						  '' as SpecialBetValue,Customer.SlipOdd.MatchId,Customer.SlipOdd.BetradarMatchId,Customer.SlipOdd.Banko
	FROM         Parameter.SlipState INNER JOIN
						  Customer.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Customer.SlipOdd.StateId INNER JOIN
						  
						  Language.[Parameter.SlipState] with (nolock) ON Language.[Parameter.SlipState].[SlipStateId]=Parameter.SlipState.StateId 
	WHERE     (Customer.SlipOdd.SlipId = @SlipId)   AND (Customer.SlipOdd.BetTypeId = 2) and Language.[Parameter.SlipState].LanguageId=@LangId
	--UNION ALL
	--	SELECT   case when  Parameter.SlipState.StateId=5 then 3 else Parameter.SlipState.StateId end as StateId 
	--,Language.[Parameter.SlipState].SlipState as State, Customer.SlipOdd.EventName as EventName, LSports.[Parameter.OutcomeType].OutcomeType AS OddsType, 
	--					  Customer.SlipOdd.OutCome AS Outcomes, Customer.SlipOdd.OddValue, Customer.SlipOdd.EventDate,
	--							   '' AS Result,cast('' as nvarchar(20)) AS SpecialBetValue
	--							   ,Customer.SlipOdd.MatchId
	--FROM         Parameter.SlipState INNER JOIN
	--					  Customer.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Customer.SlipOdd.StateId INNER JOIN
	--					  LSports.[Parameter.OutcomeType] ON Customer.SlipOdd.OddsTypeId = LSports.[Parameter.OutcomeType].OutcomeTypeId INNER JOIN
	--					  Language.[Parameter.SlipState] ON Language.[Parameter.SlipState].[SlipStateId]=Parameter.SlipState.StateId
	--WHERE     (Customer.SlipOdd.SlipId = @SlipId) and Language.[Parameter.SlipState].LanguageId=@LangId AND (Customer.SlipOdd.BetTypeId = 4)
	
	--UNION ALL
	--SELECT     Parameter.SlipState.StateId,Language.[Parameter.SlipState].SlipState as State, Customer.SlipOdd.EventName, Virtual.[Parameter.OddType].OddType AS OddsType, 
	--					  Customer.SlipOdd.OutCome AS Outcomes, Customer.SlipOdd.OddValue, Customer.SlipOdd.EventDate,Customer.SlipOdd.Score as Result,Customer.SlipOdd.SpecialBetValue,Customer.SlipOdd.MatchId
	--FROM         Parameter.SlipState INNER JOIN
	--					  Customer.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Customer.SlipOdd.StateId INNER JOIN
	--					  Virtual.[Parameter.OddType] ON Customer.SlipOdd.OddsTypeId = Virtual.[Parameter.OddType].OddTypeId INNER JOIN
	--					  Language.[Parameter.SlipState] ON Language.[Parameter.SlipState].[SlipStateId]=Parameter.SlipState.StateId
	--WHERE     (Customer.SlipOdd.SlipId = @SlipId) and Customer.SlipOdd.BetTypeId=3 and Language.[Parameter.SlipState].LanguageId=@LangId
	end
	else
		begin
			SELECT DISTINCT cast(0 as bigint) as SlipId,case when  Customer.SlipOdd.StateId=5 then 3 else Customer.SlipOdd.StateId end as StateId ,Language.[Parameter.SlipState].SlipState as State, Customer.SlipOdd.EventName as EventName, Language.[Parameter.OddsType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI as OddsType, 
						  Customer.SlipOdd.OutCome AS Outcomes, Customer.SlipOdd.OddValue, Customer.SlipOdd.EventDate,
								  [dbo].[FuncScore2](Customer.SlipOdd.BetradarMatchId,0) AS Result,case when Customer.SlipOdd.ParameterOddId IN (1578,1544,1540,1648,1646,1644,1642,2247,2321,2325,2465,2541,2543,2915,2973,2993,2997,3010,3052,3079,3350,3371,3393) then CAST( cast(Customer.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10)) else ISNULL(Customer.SlipOdd.SpecialBetValue, '') end AS SpecialBetValue
								   ,Customer.SlipOdd.MatchId,Customer.SlipOdd.BetradarMatchId,Customer.SlipOdd.Banko
			FROM         
								  Customer.SlipOdd with (nolock)  INNER JOIN
								  Language.[Parameter.OddsType] with (nolock) ON Customer.SlipOdd.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId INNER JOIN
								  Language.[Parameter.SlipState] with (nolock) ON Language.[Parameter.SlipState].[SlipStateId]=Customer.SlipOdd.StateId
			WHERE     (Customer.SlipOdd.SlipId in (select Customer.SlipSystemSlip.SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=(select top 1 Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SlipId=@SlipId)) ) AND (Language.[Parameter.OddsType].LanguageId = @LangId) and Language.[Parameter.SlipState].LanguageId=@LangId AND (Customer.SlipOdd.BetTypeId = 0)
			UNION ALL
			SELECT  DISTINCT   cast(0 as bigint) as SlipId,case when  Customer.SlipOdd.StateId=5 then 3 else Customer.SlipOdd.StateId end as StateId, Language.[Parameter.SlipState].SlipState as State, Customer.SlipOdd.EventName+' (Live)' as EventName,Language.[Parameter.LiveOddType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI AS OddsType, 
				   								Customer.SlipOdd.OutCome AS Outcomes
							   , Customer.SlipOdd.OddValue, Customer.SlipOdd.EventDate,
				   [dbo].[FuncScore2](Customer.SlipOdd.BetradarMatchId,1) AS Result
							   ,case when Customer.SlipOdd.ParameterOddId in (108,112,116,129,137,143,149,192,387,389,426,428,1947,2059,2503,2505,2553,2965,3257) 
			  then CAST( cast(Customer.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10))
			  else case when Customer.SlipOdd.SpecialBetValue<>'-1' then  ISNULL(Customer.SlipOdd.SpecialBetValue,'') else '' end end as SpecialBetValue
			  ,Customer.SlipOdd.MatchId,Customer.SlipOdd.BetradarMatchId,Customer.SlipOdd.Banko
			FROM         
								  Customer.SlipOdd with (nolock)   INNER JOIN
								  Live.[Parameter.OddType] with (nolock) ON Customer.SlipOdd.OddsTypeId = Live.[Parameter.OddType].OddTypeId INNER JOIN
								  Language.[Parameter.LiveOddType] with (nolock) ON Live.[Parameter.OddType].OddTypeId= Language.[Parameter.LiveOddType].OddTypeId INNER JOIN
								  Language.[Parameter.SlipState] with (nolock) ON Language.[Parameter.SlipState].[SlipStateId]=Customer.SlipOdd.StateId
			WHERE     (Customer.SlipOdd.SlipId in (select Customer.SlipSystemSlip.SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=(select top 1 Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SlipId=@SlipId)) ) and Customer.SlipOdd.BetTypeId=1 and  Language.[Parameter.LiveOddType].LanguageId=@LangId and Language.[Parameter.SlipState].LanguageId=@LangId
				UNION ALL
				SELECT   DISTINCT  Customer.SlipOdd.SlipId,Parameter.SlipState.StateId, Language.[Parameter.SlipState].SlipState as State, Customer.SlipOdd.EventName,  Customer.SlipOdd.EventName as OddsType, Customer.SlipOdd.OutCome AS Outcomes, 
						  Customer.SlipOdd.OddValue, Customer.SlipOdd.EventDate, '-' AS Result, 
						  '' as SpecialBetValue,Customer.SlipOdd.MatchId,Customer.SlipOdd.BetradarMatchId,Customer.SlipOdd.Banko
	FROM         Parameter.SlipState INNER JOIN
						  Customer.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Customer.SlipOdd.StateId INNER JOIN
						  
						  Language.[Parameter.SlipState] with (nolock) ON Language.[Parameter.SlipState].[SlipStateId]=Parameter.SlipState.StateId 
	WHERE     (Customer.SlipOdd.SlipId = @SlipId)   AND (Customer.SlipOdd.BetTypeId = 2) and Language.[Parameter.SlipState].LanguageId=@LangId
			
			--UNION ALL
			--SELECT   DISTINCT   cast(0 as bigint) as SlipId,Customer.SlipOdd.StateId, Language.[Parameter.SlipState].SlipState as State, Customer.SlipOdd.EventName,  Language.[Parameter.OddsType].OddsType, Customer.SlipOdd.OutCome AS Outcomes, 
			--					  Customer.SlipOdd.OddValue, Customer.SlipOdd.EventDate, '-' AS Result, 
			--					  Customer.SlipOdd.SpecialBetValue,Customer.SlipOdd.MatchId,Customer.SlipOdd.BetradarMatchId,Customer.SlipOdd.Banko
			--FROM         
			--					  Customer.SlipOdd with (nolock)   INNER JOIN
			--					  Language.[Parameter.OddsType] with (nolock) ON Customer.SlipOdd.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId INNER JOIN
			--					  Language.[Parameter.SlipState] with (nolock) ON Language.[Parameter.SlipState].[SlipStateId]=Customer.SlipOdd.StateId
			--WHERE     (Language.[Parameter.OddsType].LanguageId = @LangId) and (Customer.SlipOdd.SlipId in (select Customer.SlipSystemSlip.SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=(select top 1 Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SlipId=@SlipId)) ) AND (Customer.SlipOdd.BetTypeId = 2) and Language.[Parameter.SlipState].LanguageId=@LangId
			--UNION ALL
			--	SELECT   case when  Parameter.SlipState.StateId=5 then 3 else Parameter.SlipState.StateId end as StateId 
			--,Language.[Parameter.SlipState].SlipState as State, Customer.SlipOdd.EventName as EventName, LSports.[Parameter.OutcomeType].OutcomeType AS OddsType, 
			--					  Customer.SlipOdd.OutCome AS Outcomes, Customer.SlipOdd.OddValue, Customer.SlipOdd.EventDate,
			--							   '' AS Result,cast('' as nvarchar(20)) AS SpecialBetValue
			--							   ,Customer.SlipOdd.MatchId
			--FROM         Parameter.SlipState INNER JOIN
			--					  Customer.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Customer.SlipOdd.StateId INNER JOIN
			--					  LSports.[Parameter.OutcomeType] ON Customer.SlipOdd.OddsTypeId = LSports.[Parameter.OutcomeType].OutcomeTypeId INNER JOIN
			--					  Language.[Parameter.SlipState] ON Language.[Parameter.SlipState].[SlipStateId]=Parameter.SlipState.StateId
			--WHERE     (Customer.SlipOdd.SlipId = @SlipId) and Language.[Parameter.SlipState].LanguageId=@LangId AND (Customer.SlipOdd.BetTypeId = 4)
	
			--UNION ALL
			--SELECT     Parameter.SlipState.StateId,Language.[Parameter.SlipState].SlipState as State, Customer.SlipOdd.EventName, Virtual.[Parameter.OddType].OddType AS OddsType, 
			--					  Customer.SlipOdd.OutCome AS Outcomes, Customer.SlipOdd.OddValue, Customer.SlipOdd.EventDate,Customer.SlipOdd.Score as Result,Customer.SlipOdd.SpecialBetValue,Customer.SlipOdd.MatchId
			--FROM         Parameter.SlipState INNER JOIN
			--					  Customer.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Customer.SlipOdd.StateId INNER JOIN
			--					  Virtual.[Parameter.OddType] ON Customer.SlipOdd.OddsTypeId = Virtual.[Parameter.OddType].OddTypeId INNER JOIN
			--					  Language.[Parameter.SlipState] ON Language.[Parameter.SlipState].[SlipStateId]=Parameter.SlipState.StateId
			--WHERE     (Customer.SlipOdd.SlipId = @SlipId) and Customer.SlipOdd.BetTypeId=3 and Language.[Parameter.SlipState].LanguageId=@LangId


		end

end
else
begin

	if exists (select Archive.Slip.SlipId from Archive.Slip with (nolock) where Archive.Slip.SlipTypeId<3 and Archive.Slip.SlipId=@SlipId)
	begin
			SELECT   Archive.SlipOdd.SlipId,case when  Archive.SlipOdd.StateId=5 then 3 else Archive.SlipOdd.StateId end as StateId ,Language.[Parameter.SlipState].SlipState as State, Archive.SlipOdd.EventName as EventName, Language.[Parameter.OddsType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI as OddsType, 
								  Archive.SlipOdd.OutCome AS Outcomes, Archive.SlipOdd.OddValue, Archive.SlipOdd.EventDate,
										   [dbo].[FuncScore2](Archive.SlipOdd.BetradarMatchId,0) AS Result,case when Archive.SlipOdd.ParameterOddId IN (2247,2321,2325,2465,2541,2543,2915,2973,2993,2997,3010,3052,3079,3350,3371,3393) then CAST( cast(Archive.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10)) else ISNULL(Archive.SlipOdd.SpecialBetValue, '') end AS SpecialBetValue
										   ,Archive.SlipOdd.MatchId,Archive.SlipOdd.BetradarMatchId,Archive.SlipOdd.Banko
			FROM         
								  Archive.SlipOdd with (nolock) INNER JOIN
								  Language.[Parameter.OddsType] with (nolock) ON Archive.SlipOdd.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId INNER JOIN
								  Language.[Parameter.SlipState] with (nolock) ON Language.[Parameter.SlipState].[SlipStateId]=Archive.SlipOdd.StateId
			WHERE     (Archive.SlipOdd.SlipId = @SlipId) AND (Language.[Parameter.OddsType].LanguageId = @LangId) and Language.[Parameter.SlipState].LanguageId=@LangId AND (Archive.SlipOdd.BetTypeId = 0)
			UNION ALL
			SELECT     Archive.SlipOdd.SlipId,case when  Archive.SlipOdd.StateId=5 then 3 else Archive.SlipOdd.StateId end as StateId, Language.[Parameter.SlipState].SlipState as State, Archive.SlipOdd.EventName,Language.[Parameter.LiveOddType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI AS OddsType, 
								Archive.SlipOdd.OutCome AS Outcomes
							   , Archive.SlipOdd.OddValue, Archive.SlipOdd.EventDate,
				   [dbo].[FuncScore2](Archive.SlipOdd.BetradarMatchId,1) AS Result
							   ,case when Archive.SlipOdd.ParameterOddId in (108,112,116,129,137,143,149,192,387,389,426,428,1947,2059,2503,2505,2553,2965) 
			  then CAST( cast(Archive.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10))
			  else case when Archive.SlipOdd.SpecialBetValue<>'-1' then  ISNULL(Archive.SlipOdd.SpecialBetValue,'') else '' end end as SpecialBetValue
			  ,Archive.SlipOdd.MatchId,Archive.SlipOdd.BetradarMatchId,Archive.SlipOdd.Banko
			FROM        
								  Archive.SlipOdd with (nolock)  INNER JOIN
								  Live.[Parameter.OddType] with (nolock) ON Archive.SlipOdd.OddsTypeId = Live.[Parameter.OddType].OddTypeId INNER JOIN
								  Language.[Parameter.LiveOddType] with (nolock) ON Live.[Parameter.OddType].OddTypeId= Language.[Parameter.LiveOddType].OddTypeId INNER JOIN
								  Language.[Parameter.SlipState]  with (nolock) ON Language.[Parameter.SlipState].[SlipStateId]=Archive.SlipOdd.StateId
			WHERE     (Archive.SlipOdd.SlipId = @SlipId) and Archive.SlipOdd.BetTypeId=1 and  Language.[Parameter.LiveOddType].LanguageId=@LangId and Language.[Parameter.SlipState].LanguageId=@LangId
			UNION ALL
		SELECT   DISTINCT  Archive.SlipOdd.SlipId,Parameter.SlipState.StateId, Language.[Parameter.SlipState].SlipState as State, Archive.SlipOdd.EventName,  Archive.SlipOdd.EventName as OddsType, Archive.SlipOdd.OutCome AS Outcomes, 
						  Archive.SlipOdd.OddValue, Archive.SlipOdd.EventDate, '-' AS Result, 
						  '' as SpecialBetValue,Archive.SlipOdd.MatchId,Archive.SlipOdd.BetradarMatchId,Archive.SlipOdd.Banko
	FROM         Parameter.SlipState INNER JOIN
						  Archive.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Archive.SlipOdd.StateId INNER JOIN
						  
						  Language.[Parameter.SlipState] with (nolock) ON Language.[Parameter.SlipState].[SlipStateId]=Parameter.SlipState.StateId 
	WHERE     (Archive.SlipOdd.SlipId = @SlipId)   AND (Archive.SlipOdd.BetTypeId = 2) and Language.[Parameter.SlipState].LanguageId=@LangId
			--UNION ALL
			--	SELECT   case when  Parameter.SlipState.StateId=5 then 3 else Parameter.SlipState.StateId end as StateId 
			--,Language.[Parameter.SlipState].SlipState as State, Customer.SlipOdd.EventName as EventName, LSports.[Parameter.OutcomeType].OutcomeType AS OddsType, 
			--					  Customer.SlipOdd.OutCome AS Outcomes, Customer.SlipOdd.OddValue, Customer.SlipOdd.EventDate,
			--							   '' AS Result,cast('' as nvarchar(20)) AS SpecialBetValue
			--							   ,Customer.SlipOdd.MatchId
			--FROM         Parameter.SlipState INNER JOIN
			--					  Customer.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Customer.SlipOdd.StateId INNER JOIN
			--					  LSports.[Parameter.OutcomeType] ON Customer.SlipOdd.OddsTypeId = LSports.[Parameter.OutcomeType].OutcomeTypeId INNER JOIN
			--					  Language.[Parameter.SlipState] ON Language.[Parameter.SlipState].[SlipStateId]=Parameter.SlipState.StateId
			--WHERE     (Customer.SlipOdd.SlipId = @SlipId) and Language.[Parameter.SlipState].LanguageId=@LangId AND (Customer.SlipOdd.BetTypeId = 4)
	
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
			SELECT  DISTINCT cast(0 as bigint) as SlipId,case when  Archive.SlipOdd.StateId=5 then 3 else Archive.SlipOdd.StateId end as StateId ,Language.[Parameter.SlipState].SlipState as State, Archive.SlipOdd.EventName as EventName, Language.[Parameter.OddsType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI as OddsType, 
								  Archive.SlipOdd.OutCome AS Outcomes, Archive.SlipOdd.OddValue, Archive.SlipOdd.EventDate,
										   [dbo].[FuncScore2](Archive.SlipOdd.BetradarMatchId,0) AS Result,case when Archive.SlipOdd.ParameterOddId IN (2247,2321,2325,2465,2541,2543,2915,2973,2993,2997,3010,3052,3079,3350,3371,3393) then CAST( cast(Archive.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10)) else ISNULL(Archive.SlipOdd.SpecialBetValue, '') end AS SpecialBetValue
										   ,Archive.SlipOdd.MatchId,Archive.SlipOdd.BetradarMatchId,Archive.SlipOdd.Banko
			FROM       
								  Archive.SlipOdd with (nolock)  INNER JOIN
								  Language.[Parameter.OddsType] with (nolock) ON Archive.SlipOdd.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId INNER JOIN
								  Language.[Parameter.SlipState] with (nolock) ON Language.[Parameter.SlipState].[SlipStateId]=Archive.SlipOdd.StateId
			WHERE    (Archive.SlipOdd.SlipId in (select Customer.SlipSystemSlip.SlipId from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SystemSlipId=(select top 1 Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SlipId=@SlipId)) )  AND (Language.[Parameter.OddsType].LanguageId = @LangId) and Language.[Parameter.SlipState].LanguageId=@LangId AND (Archive.SlipOdd.BetTypeId = 0)
			UNION ALL
			SELECT    DISTINCT cast(0 as bigint) as SlipId,case when  Archive.SlipOdd.StateId=5 then 3 else Archive.SlipOdd.StateId end as StateId, Language.[Parameter.SlipState].SlipState as State, Archive.SlipOdd.EventName,Language.[Parameter.LiveOddType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI AS OddsType, 
								Archive.SlipOdd.OutCome AS Outcomes
							   , Archive.SlipOdd.OddValue, Archive.SlipOdd.EventDate,
				   [dbo].[FuncScore2](Archive.SlipOdd.BetradarMatchId,1) AS Result
							   ,case when Archive.SlipOdd.ParameterOddId in (108,112,116,129,137,143,149,192,387,389,426,428,1947,2059,2503,2505,2553,2965) 
			  then CAST( cast(Archive.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10))
			  else case when Archive.SlipOdd.SpecialBetValue<>'-1' then  ISNULL(Archive.SlipOdd.SpecialBetValue,'') else '' end end as SpecialBetValue
			  ,Archive.SlipOdd.MatchId,Archive.SlipOdd.BetradarMatchId,Archive.SlipOdd.Banko
			FROM        
								  Archive.SlipOdd with (nolock)   INNER JOIN
								  Live.[Parameter.OddType] with (nolock) ON Archive.SlipOdd.OddsTypeId = Live.[Parameter.OddType].OddTypeId INNER JOIN
								  Language.[Parameter.LiveOddType] with (nolock) ON Live.[Parameter.OddType].OddTypeId= Language.[Parameter.LiveOddType].OddTypeId INNER JOIN
								  Language.[Parameter.SlipState] with (nolock) ON Language.[Parameter.SlipState].[SlipStateId]=Archive.SlipOdd.StateId
			WHERE      (Archive.SlipOdd.SlipId in (select Customer.SlipSystemSlip.SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=(select top 1 Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SlipId=@SlipId)) )  and Archive.SlipOdd.BetTypeId=1 and  Language.[Parameter.LiveOddType].LanguageId=@LangId and Language.[Parameter.SlipState].LanguageId=@LangId
			--UNION ALL
			--SELECT  DISTINCT  cast(0 as bigint) as SlipId, Parameter.SlipState.StateId, Language.[Parameter.SlipState].SlipState as State, Archive.SlipOdd.EventName, '' AS OddsType, Archive.SlipOdd.OutCome AS Outcomes, 
			--					  Archive.SlipOdd.OddValue, Archive.SlipOdd.EventDate, '-' AS Result, 
			--					  Archive.SlipOdd.SpecialBetValue,Archive.SlipOdd.MatchId,Archive.SlipOdd.BetradarMatchId,Archive.SlipOdd.Banko
			--FROM         Parameter.SlipState INNER JOIN
			--					  Archive.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Archive.SlipOdd.StateId INNER JOIN
			--					  Language.[Parameter.SlipState] ON Language.[Parameter.SlipState].[SlipStateId]=Parameter.SlipState.StateId
			--WHERE     (Archive.SlipOdd.SlipId in (select Customer.SlipSystemSlip.SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=(select top 1 Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SlipId=@SlipId)) )  AND (Archive.SlipOdd.BetTypeId = 2) and Language.[Parameter.SlipState].LanguageId=@LangId
			--UNION ALL
			--	SELECT   case when  Parameter.SlipState.StateId=5 then 3 else Parameter.SlipState.StateId end as StateId 
			--,Language.[Parameter.SlipState].SlipState as State, Customer.SlipOdd.EventName as EventName, LSports.[Parameter.OutcomeType].OutcomeType AS OddsType, 
			--					  Customer.SlipOdd.OutCome AS Outcomes, Customer.SlipOdd.OddValue, Customer.SlipOdd.EventDate,
			--							   '' AS Result,cast('' as nvarchar(20)) AS SpecialBetValue
			--							   ,Customer.SlipOdd.MatchId
			--FROM         Parameter.SlipState INNER JOIN
			--					  Customer.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Customer.SlipOdd.StateId INNER JOIN
			--					  LSports.[Parameter.OutcomeType] ON Customer.SlipOdd.OddsTypeId = LSports.[Parameter.OutcomeType].OutcomeTypeId INNER JOIN
			--					  Language.[Parameter.SlipState] ON Language.[Parameter.SlipState].[SlipStateId]=Parameter.SlipState.StateId
			--WHERE     (Customer.SlipOdd.SlipId = @SlipId) and Language.[Parameter.SlipState].LanguageId=@LangId AND (Customer.SlipOdd.BetTypeId = 4)
	
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
