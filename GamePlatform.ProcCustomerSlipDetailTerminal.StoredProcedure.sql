USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerSlipDetailTerminal]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 
CREATE PROCEDURE [GamePlatform].[ProcCustomerSlipDetailTerminal] 
@SlipId bigint,
@LangId int
AS

BEGIN
SET NOCOUNT ON;


if exists (select Customer.SlipOdd.SlipId from Customer.SlipOdd with (nolock) where Customer.SlipOdd.SlipId=@SlipId)
begin
	
	if exists (select  Customer.Slip.SlipId from Customer.Slip with (nolock) where Customer.Slip.SlipTypeId<3 and Customer.Slip.SlipId=@SlipId)
	begin
	SELECT   Customer.SlipOdd.SlipId,case when  Customer.SlipOdd.StateId=5 then 3 else Customer.SlipOdd.StateId end as StateId ,Language.[Parameter.SlipState].SlipState as State, Customer.SlipOdd.EventName as EventName, Language.[Parameter.OddsType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI as OddsType, 
						  Customer.SlipOdd.OutCome AS Outcomes, Customer.SlipOdd.OddValue, Customer.SlipOdd.EventDate,
								  [dbo].[FuncScore3](Customer.SlipOdd.BetradarMatchId,0,@LangId)  AS Result,case when Customer.SlipOdd.ParameterOddId IN (1578,1544,1540,1648,1646,1644,1642,2247,2321,2325,2465,2541,2543,2915,2973,2993,2997,3010,3052,3079,3350,3371,3393) then CAST( cast(Customer.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10)) else ISNULL(Customer.SlipOdd.SpecialBetValue, '') end AS SpecialBetValue
								   ,Customer.SlipOdd.MatchId,  [dbo].[FuncScoreFinal](Customer.SlipOdd.MatchId,0) AS FinalResult,
								   ''  as WinOddtype,ISNULL(Customer.SlipOdd.Score,'-') as SlipScore,Language.[Parameter.OddsType].ShortOddType COLLATE SQL_Latin1_General_CP1253_CI_AI as ShortOddType,Customer.SlipOdd.Banko
								   ,'' as Live
	FROM         
						  Customer.SlipOdd with (nolock) INNER JOIN
						  Language.[Parameter.OddsType] ON Customer.SlipOdd.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId INNER JOIN
						  Language.[Parameter.SlipState] ON Language.[Parameter.SlipState].[SlipStateId]=Customer.SlipOdd.StateId
	WHERE     (Customer.SlipOdd.SlipId = @SlipId) AND (Language.[Parameter.OddsType].LanguageId = @LangId) and Language.[Parameter.SlipState].LanguageId=@LangId AND (Customer.SlipOdd.BetTypeId = 0)
	UNION ALL
	SELECT     Customer.SlipOdd.SlipId,case when Customer.SlipOdd.StateId=5 then 3 else Customer.SlipOdd.StateId end as StateId, Language.[Parameter.SlipState].SlipState as State, Customer.SlipOdd.EventName as EventName,Language.[Parameter.LiveOddType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI AS OddsType, 
						Customer.SlipOdd.OutCome AS Outcomes
					   , Customer.SlipOdd.OddValue, Customer.SlipOdd.EventDate,
		    [dbo].[FuncScore3](Customer.SlipOdd.BetradarMatchId,1,@LangId)  AS Result
					   ,case when Customer.SlipOdd.ParameterOddId in (108,112,116,129,137,143,149,192,387,389,426,428,1947,2059,2503,2505,2553,2965,3257) 
	  then CAST( cast(Customer.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10))
	  else case when Customer.SlipOdd.SpecialBetValue<>'-1' then  ISNULL(Customer.SlipOdd.SpecialBetValue,'') else '' end end as SpecialBetValue
	  ,Customer.SlipOdd.MatchId,  [dbo].[FuncScoreFinal](Customer.SlipOdd.MatchId,1) AS FinalResult
	 --  ,case when Customer.SlipOdd.StateId not in (3,7,1) 
		--then    (select top 1 Language.[Parameter.LiveOdds].OutComes
  -- from Language.[Parameter.LiveOdds] with (nolock) INNER JOIN Live.[Parameter.Odds] with (nolock) ON Language.[Parameter.LiveOdds].OddsId=Live.[Parameter.Odds].OddsId
  -- where Language.[Parameter.LiveOdds].LanguageId=@LangId 
  -- and Live.[Parameter.Odds].Outcomes =
  -- (select top 1  LO.OutCome COLLATE SQL_Latin1_General_CP1_CI_AS   from Live.EventOddResult as LO  with (nolock)
  -- where LO.OddsTypeId=Customer.SlipOdd.OddsTypeId 
  -- and LO.BetradarMatchId=Customer.SlipOdd.BetradarMatchId
  -- and LO.SpecialBetValue=case when  Customer.SlipOdd.SpecialBetValue = '' then '-1' else Customer.SlipOdd.SpecialBetValue end and OddResult=1))
	 -- else case when Customer.SlipOdd.StateId=3 then Customer.SlipOdd.OutCome else '' end end as WinOddtype
	 ,'' as WinOddtype
	  ,ISNULL(Customer.SlipOdd.Score,'-') as SlipScore
	  ,Language.[Parameter.LiveOddType].ShortOddType COLLATE SQL_Latin1_General_CP1253_CI_AI as ShortOddType,Customer.SlipOdd.Banko
	  ,'Live' as Live
	FROM        
						  Customer.SlipOdd with (nolock)  INNER JOIN
						  Live.[Parameter.OddType] ON Customer.SlipOdd.OddsTypeId = Live.[Parameter.OddType].OddTypeId INNER JOIN
						  Language.[Parameter.LiveOddType] ON Live.[Parameter.OddType].OddTypeId= Language.[Parameter.LiveOddType].OddTypeId INNER JOIN
						  Language.[Parameter.SlipState] ON Language.[Parameter.SlipState].[SlipStateId]=Customer.SlipOdd.StateId
	WHERE     (Customer.SlipOdd.SlipId = @SlipId) and Customer.SlipOdd.BetTypeId=1 and  Language.[Parameter.LiveOddType].LanguageId=@LangId and Language.[Parameter.SlipState].LanguageId=@LangId
	UNION ALL
	SELECT     Customer.SlipOdd.SlipId,Parameter.SlipState.StateId, Language.[Parameter.SlipState].SlipState as State, Customer.SlipOdd.EventName, Customer.SlipOdd.EventName AS OddsType, Customer.SlipOdd.OutCome AS Outcomes, 
						  Customer.SlipOdd.OddValue, Customer.SlipOdd.EventDate, '' AS Result, 
						  Customer.SlipOdd.SpecialBetValue,Customer.SlipOdd.MatchId,  '-/-' AS FinalResult,'-' as WinOddtype,ISNULL(Customer.SlipOdd.Score,'-') as SlipScore,'' as ShortOddType,Customer.SlipOdd.Banko
						  ,'' as Live
	FROM         Parameter.SlipState INNER JOIN
						  Customer.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Customer.SlipOdd.StateId INNER JOIN
						  Language.[Parameter.SlipState] ON Language.[Parameter.SlipState].[SlipStateId]=Parameter.SlipState.StateId
	WHERE     (Customer.SlipOdd.SlipId = @SlipId) AND (Customer.SlipOdd.BetTypeId = 2) and Language.[Parameter.SlipState].LanguageId=@LangId
	end
	else
		begin
			SELECT  DISTINCT cast(0 as bigint) as SlipId,case when  Customer.SlipOdd.StateId=5 then 3 else Customer.SlipOdd.StateId end as StateId ,Language.[Parameter.SlipState].SlipState as State, Customer.SlipOdd.EventName as EventName, Language.[Parameter.OddsType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI as OddsType, 
						  Customer.SlipOdd.OutCome AS Outcomes, Customer.SlipOdd.OddValue, Customer.SlipOdd.EventDate,
								case when Customer.SlipOdd.StateId<>3 and Customer.SlipOdd.EventDate<GETDATE()
								 then  [dbo].[FuncScore3](Customer.SlipOdd.BetradarMatchId,0,@LangId) else '-' end AS Result
								,case when Customer.SlipOdd.ParameterOddId IN (1578,1544,1540,1648,1646,1644,1642,2247,2321,2325,2465,2541,2543,2915,2973,2993,2997,3010,3052,3079,3350,3371,3393) then CAST( cast(Customer.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10)) else ISNULL(Customer.SlipOdd.SpecialBetValue, '') end AS SpecialBetValue
								   ,Customer.SlipOdd.MatchId,
					  [dbo].[FuncScoreFinal](Customer.SlipOdd.MatchId,Customer.SlipOdd.BetTypeId)  AS FinalResult 
		--						   , case when Customer.SlipOdd.StateId not in (3,7,1) 
		--then    (select top 1 Language.[Parameter.Odds].OutComes
  -- from Language.[Parameter.Odds] with (nolock) INNER JOIN Parameter.Odds  with (nolock) ON Language.[Parameter.Odds].OddsId=Parameter.Odds.OddsId
  -- where Language.[Parameter.Odds].LanguageId=@LangId  and Parameter.Odds.OddTypeId=Customer.SlipOdd.OddsTypeId
  -- and Parameter.Odds.Outcomes =
  -- (select top 1  LO.OutCome COLLATE SQL_Latin1_General_CP1_CI_AS   from Match.OddsResult as LO  with (nolock)
  -- where LO.OddsTypeId=Customer.SlipOdd.OddsTypeId 
  -- and LO.MatchId=Customer.SlipOdd.MatchId
  -- and LO.SpecialBetValue COLLATE SQL_Latin1_General_CP1_CI_AS   =case when  Customer.SlipOdd.SpecialBetValue = '' then '-1' else Customer.SlipOdd.SpecialBetValue end ))
	 -- else case when Customer.SlipOdd.StateId=3 then Customer.SlipOdd.OutCome else '' end end 
	 ,'' as WinOddtype
								   
								   ,ISNULL(Customer.SlipOdd.Score,'-') as SlipScore,Language.[Parameter.OddsType].ShortOddType COLLATE SQL_Latin1_General_CP1253_CI_AI as ShortOddType,Customer.SlipOdd.Banko
								   ,'' as Live
			FROM         
								  Customer.SlipOdd with (nolock)   INNER JOIN
								  Language.[Parameter.OddsType] with (nolock) ON Customer.SlipOdd.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId INNER JOIN
								  Language.[Parameter.SlipState] with (nolock) ON Language.[Parameter.SlipState].[SlipStateId]=Customer.SlipOdd.StateId
			WHERE     (Customer.SlipOdd.SlipId in (select Customer.SlipSystemSlip.SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=(select top 1 Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SlipId=@SlipId)) ) AND (Language.[Parameter.OddsType].LanguageId = @LangId) and Language.[Parameter.SlipState].LanguageId=@LangId AND (Customer.SlipOdd.BetTypeId = 0)
			UNION ALL
			SELECT    DISTINCT cast(0 as bigint) as SlipId,case when  Customer.SlipOdd.StateId=5 then 3 else Customer.SlipOdd.StateId end as StateId,
			 Language.[Parameter.SlipState].SlipState as State, Customer.SlipOdd.EventName as EventName,Language.[Parameter.LiveOddType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI AS OddsType, 
								Customer.SlipOdd.OutCome AS Outcomes
							   , Customer.SlipOdd.OddValue, Customer.SlipOdd.EventDate,
				  case when Customer.SlipOdd.StateId<>3 and Customer.SlipOdd.EventDate<GETDATE() then  [dbo].[FuncScore3](Customer.SlipOdd.BetradarMatchId,1,@LangId) else '-' end
				   AS Result
							   ,case when Customer.SlipOdd.ParameterOddId in (108,112,116,129,137,143,149,192,387,389,426,428,1947,2059,2503,2505,2553,2965,3257) 
			  then CAST( cast(Customer.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10))
			  else case when Customer.SlipOdd.SpecialBetValue<>'-1' then  ISNULL(Customer.SlipOdd.SpecialBetValue,'') else '' end end as SpecialBetValue
			  ,Customer.SlipOdd.MatchId,   [dbo].[FuncScoreFinal](Customer.SlipOdd.MatchId,1) AS FinalResult
			  
		--,case when Customer.SlipOdd.StateId not in (3,7,1) 
		--then    (select top 1 Language.[Parameter.LiveOdds].OutComes
  -- from Language.[Parameter.LiveOdds] with (nolock) INNER JOIN Live.[Parameter.Odds] with (nolock) ON Language.[Parameter.LiveOdds].OddsId=Live.[Parameter.Odds].OddsId
  -- where Language.[Parameter.LiveOdds].LanguageId=@LangId 
  -- and Live.[Parameter.Odds].Outcomes =
  -- (select top 1  LO.OutCome COLLATE SQL_Latin1_General_CP1_CI_AS   from Live.EventOddResult as LO  with (nolock)
  -- where LO.OddsTypeId=Customer.SlipOdd.OddsTypeId 
  -- and LO.BetradarMatchId=Customer.SlipOdd.BetradarMatchId
  -- and LO.SpecialBetValue=case when  Customer.SlipOdd.SpecialBetValue = '' then '-1' else Customer.SlipOdd.SpecialBetValue end and OddResult=1))
	 -- else case when Customer.SlipOdd.StateId=3 then Customer.SlipOdd.OutCome else '' end end 
	,''  as WinOddtype
	  ,ISNULL(Customer.SlipOdd.Score,'-') as SlipScore,Language.[Parameter.LiveOddType].ShortOddType COLLATE SQL_Latin1_General_CP1253_CI_AI as ShortOddType,Customer.SlipOdd.Banko
	  ,'' as Live
			FROM         
								  Customer.SlipOdd with (nolock)   INNER JOIN
								  Live.[Parameter.OddType] with (nolock) ON Customer.SlipOdd.OddsTypeId = Live.[Parameter.OddType].OddTypeId INNER JOIN
								  Language.[Parameter.LiveOddType] with (nolock) ON Live.[Parameter.OddType].OddTypeId= Language.[Parameter.LiveOddType].OddTypeId INNER JOIN
								  Language.[Parameter.SlipState] with (nolock) ON Language.[Parameter.SlipState].[SlipStateId]=Customer.SlipOdd.StateId
			WHERE     (Customer.SlipOdd.SlipId in (select Customer.SlipSystemSlip.SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=(select top 1 Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SlipId=@SlipId)) ) and Customer.SlipOdd.BetTypeId=1 and  Language.[Parameter.LiveOddType].LanguageId=@LangId and Language.[Parameter.SlipState].LanguageId=@LangId
			--UNION ALL
			--SELECT   DISTINCT 0 as SlipId,Parameter.SlipState.StateId, Language.[Parameter.SlipState].SlipState as State, Customer.SlipOdd.EventName, '' AS OddsType, Customer.SlipOdd.OutCome AS Outcomes, 
			--					  Customer.SlipOdd.OddValue, Customer.SlipOdd.EventDate, '' AS Result, 
			--					  Customer.SlipOdd.SpecialBetValue,Customer.SlipOdd.MatchId,  '' AS FinalResult,'-' as WinOddtype,ISNULL(Customer.SlipOdd.Score,'-') as SlipScore,'' as ShortOddType,Customer.SlipOdd.Banko
			--FROM         Parameter.SlipState with (nolock) INNER JOIN
			--					  Customer.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Customer.SlipOdd.StateId INNER JOIN
			--					  Language.[Parameter.SlipState] with (nolock) ON Language.[Parameter.SlipState].[SlipStateId]=Parameter.SlipState.StateId
			--WHERE     (Customer.SlipOdd.SlipId in (select Customer.SlipSystemSlip.SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=(select top 1 Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SlipId=@SlipId)) ) AND (Customer.SlipOdd.BetTypeId = 2) and Language.[Parameter.SlipState].LanguageId=@LangId
			


		end

end
else
begin

	if exists (select Archive.Slip.SlipId from Archive.Slip with (nolock) where Archive.Slip.SlipTypeId<3 and Archive.Slip.SlipId=@SlipId)
	begin
			SELECT   Archive.SlipOdd.SlipId,case when  Archive.SlipOdd.StateId=5 then 3 else Archive.SlipOdd.StateId end as StateId ,Language.[Parameter.SlipState].SlipState as State, Archive.SlipOdd.EventName as EventName, Language.[Parameter.OddsType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI as OddsType, 
								  Archive.SlipOdd.OutCome AS Outcomes, Archive.SlipOdd.OddValue, Archive.SlipOdd.EventDate,
										case when Archive.SlipOdd.StateId<>3 then    [dbo].[FuncScore3](Archive.SlipOdd.BetradarMatchId,0,@LangId) else '-' end AS Result,case when Archive.SlipOdd.ParameterOddId IN (2247,2321,2325,2465,2541,2543,2915,2973,2993,2997,3010,3052,3079,3350,3371,3393) then CAST( cast(Archive.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10)) else ISNULL(Archive.SlipOdd.SpecialBetValue, '') end AS SpecialBetValue
										   ,Archive.SlipOdd.MatchId,  [dbo].[FuncScoreFinal](Archive.SlipOdd.MatchId,0) AS FinalResult
								, ''    as WinOddtype,ISNULL(Archive.SlipOdd.Score,'-') as SlipScore,Language.[Parameter.OddsType].ShortOddType COLLATE SQL_Latin1_General_CP1253_CI_AI as ShortOddType,Archive.SlipOdd.Banko
								,'' as Live
			FROM         
								  Archive.SlipOdd with (nolock)   INNER JOIN
								  Language.[Parameter.OddsType] with (nolock) ON Archive.SlipOdd.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId INNER JOIN
								  Language.[Parameter.SlipState] with (nolock) ON Language.[Parameter.SlipState].[SlipStateId]=Archive.SlipOdd.StateId
			WHERE     (Archive.SlipOdd.SlipId = @SlipId) AND (Language.[Parameter.OddsType].LanguageId = @LangId) and Language.[Parameter.SlipState].LanguageId=@LangId AND (Archive.SlipOdd.BetTypeId = 0)
			UNION ALL
			SELECT     Archive.SlipOdd.SlipId,case when  Archive.SlipOdd.StateId=5 then 3 else Archive.SlipOdd.StateId end as StateId, Language.[Parameter.SlipState].SlipState as State, Archive.SlipOdd.EventName,Language.[Parameter.LiveOddType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI AS OddsType, 
								Archive.SlipOdd.OutCome AS Outcomes
							   , Archive.SlipOdd.OddValue, Archive.SlipOdd.EventDate,
				 case when Archive.SlipOdd.StateId<>3 then    [dbo].[FuncScore3](Archive.SlipOdd.BetradarMatchId,1,@LangId) else '-' end AS Result
							   ,case when Archive.SlipOdd.ParameterOddId in (108,112,116,129,137,143,149,192,387,389,426,428,1947,2059,2503,2505,2553,2965) 
			  then CAST( cast(Archive.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10))
			  else case when Archive.SlipOdd.SpecialBetValue<>'-1' then  ISNULL(Archive.SlipOdd.SpecialBetValue,'') else '' end end as SpecialBetValue
			  ,Archive.SlipOdd.MatchId,  [dbo].[FuncScoreFinal](Archive.SlipOdd.MatchId,1) AS FinalResult
		--	    ,case when Archive.SlipOdd.StateId not in (3,7,1) 
		--then    (select top 1 Language.[Parameter.LiveOdds].OutComes
  -- from Language.[Parameter.LiveOdds] with (nolock) INNER JOIN Live.[Parameter.Odds] with (nolock) ON Language.[Parameter.LiveOdds].OddsId=Live.[Parameter.Odds].OddsId
  -- where Language.[Parameter.LiveOdds].LanguageId=@LangId and Live.[Parameter.Odds].OddTypeId=Archive.SlipOdd.OddsTypeId
  -- and Live.[Parameter.Odds].Outcomes =
  -- (select top 1  LO.OutCome COLLATE SQL_Latin1_General_CP1_CI_AS   from Archive.[Live.EventOddResult] as LO  with (nolock)
  -- where LO.OddsTypeId=Archive.SlipOdd.OddsTypeId 
  -- and LO.BetradarMatchId=Archive.SlipOdd.BetradarMatchId
  -- and LO.SpecialBetValue=case when  Archive.SlipOdd.SpecialBetValue = '' then '-1' else Archive.SlipOdd.SpecialBetValue end and OddResult=1))
	 -- else case when Archive.SlipOdd.StateId=3 then Archive.SlipOdd.OutCome else '' end end as WinOddtype
	 ,'' as WinOddtype
	  ,ISNULL(Archive.SlipOdd.Score,'-') as SlipScore,Language.[Parameter.LiveOddType].ShortOddType  COLLATE SQL_Latin1_General_CP1253_CI_AI as ShortOddType,Archive.SlipOdd.Banko
	  ,'' as Live
			FROM      
								  Archive.SlipOdd with (nolock)   INNER JOIN
								  Live.[Parameter.OddType] with (nolock) ON Archive.SlipOdd.OddsTypeId = Live.[Parameter.OddType].OddTypeId INNER JOIN
								  Language.[Parameter.LiveOddType] with (nolock) ON Live.[Parameter.OddType].OddTypeId= Language.[Parameter.LiveOddType].OddTypeId INNER JOIN
								  Language.[Parameter.SlipState] with (nolock) ON Language.[Parameter.SlipState].[SlipStateId]=Archive.SlipOdd.StateId
			WHERE     (Archive.SlipOdd.SlipId = @SlipId) and Archive.SlipOdd.BetTypeId=1 and  Language.[Parameter.LiveOddType].LanguageId=@LangId and Language.[Parameter.SlipState].LanguageId=@LangId
			UNION ALL
			SELECT    Archive.SlipOdd.SlipId, Parameter.SlipState.StateId, Language.[Parameter.SlipState].SlipState as State, Archive.SlipOdd.EventName, '' AS OddsType, Archive.SlipOdd.OutCome AS Outcomes, 
								  Archive.SlipOdd.OddValue, Archive.SlipOdd.EventDate, '' AS Result, 
								  Archive.SlipOdd.SpecialBetValue,Archive.SlipOdd.MatchId, '' AS FinalResult,'' as WinOddtype,ISNULL(Archive.SlipOdd.Score,'') as SlipScore,'' as ShortOddType,Archive.SlipOdd.Banko
								  ,'' as Live
			FROM         Parameter.SlipState INNER JOIN
								  Archive.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Archive.SlipOdd.StateId INNER JOIN
								  Language.[Parameter.SlipState] with (nolock) ON Language.[Parameter.SlipState].[SlipStateId]=Parameter.SlipState.StateId
			WHERE     (Archive.SlipOdd.SlipId = @SlipId) AND (Archive.SlipOdd.BetTypeId = 2) and Language.[Parameter.SlipState].LanguageId=@LangId
			
	end
	else
		begin
			SELECT   DISTINCT cast(0 as bigint) as SlipId,case when  Archive.SlipOdd.StateId=5 then 3 else Archive.SlipOdd.StateId end as StateId ,Language.[Parameter.SlipState].SlipState as State, Archive.SlipOdd.EventName as EventName, Language.[Parameter.OddsType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI as OddsType, 
								  Archive.SlipOdd.OutCome AS Outcomes, Archive.SlipOdd.OddValue, Archive.SlipOdd.EventDate,
										case when Archive.SlipOdd.StateId<>3 then     [dbo].[FuncScore3](Archive.SlipOdd.BetradarMatchId,Archive.SlipOdd.BetTypeId,@LangId) else '-' end AS Result,case when Archive.SlipOdd.ParameterOddId IN (2247,2321,2325,2465,2541,2543,2915,2973,2993,2997,3010,3052,3079,3350,3371,3393) then CAST( cast(Archive.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10)) else ISNULL(Archive.SlipOdd.SpecialBetValue, '') end AS SpecialBetValue
										   ,Archive.SlipOdd.MatchId,  [dbo].[FuncScoreFinal](Archive.SlipOdd.MatchId,Archive.SlipOdd.BetTypeId) AS FinalResult
								 ,'-'   as WinOddtype,ISNULL(Archive.SlipOdd.Score,'-') as SlipScore,Language.[Parameter.OddsType].ShortOddType COLLATE SQL_Latin1_General_CP1253_CI_AI as ShortOddType,Archive.SlipOdd.Banko
								 ,'' as Live
			FROM         
								  Archive.SlipOdd with (nolock)  INNER JOIN
								  Language.[Parameter.OddsType] with (nolock) ON Archive.SlipOdd.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId INNER JOIN
								  Language.[Parameter.SlipState] with (nolock) ON Language.[Parameter.SlipState].[SlipStateId]=Archive.SlipOdd.StateId
			WHERE    (Archive.SlipOdd.SlipId in (select Customer.SlipSystemSlip.SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=(select top 1 Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SlipId=@SlipId)) )  AND (Language.[Parameter.OddsType].LanguageId = @LangId) and Language.[Parameter.SlipState].LanguageId=@LangId AND (Archive.SlipOdd.BetTypeId = 0)
			UNION ALL
			SELECT    DISTINCT 0 as SlipId,case when  Archive.SlipOdd.StateId=5 then 3 else Archive.SlipOdd.StateId end as StateId, Language.[Parameter.SlipState].SlipState as State, Archive.SlipOdd.EventName,Language.[Parameter.LiveOddType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI AS OddsType, 
								Archive.SlipOdd.OutCome AS Outcomes
							   , Archive.SlipOdd.OddValue, Archive.SlipOdd.EventDate,
				   '-' AS Result
							   ,case when Archive.SlipOdd.ParameterOddId in (108,112,116,129,137,143,149,192,387,389,426,428,1947,2059,2503,2505,2553,2965) 
			  then CAST( cast(Archive.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10))
			  else case when Archive.SlipOdd.SpecialBetValue<>'-1' then  ISNULL(Archive.SlipOdd.SpecialBetValue,'') else '' end end as SpecialBetValue
			  ,Archive.SlipOdd.MatchId,
			     [dbo].[FuncScoreFinal](Archive.SlipOdd.MatchId,1) 
			   AS FinalResult,
		--    case when Archive.SlipOdd.StateId not in (3,7,1) 
		--then    (select top 1 Language.[Parameter.LiveOdds].OutComes
  -- from Language.[Parameter.LiveOdds] with (nolock) INNER JOIN Live.[Parameter.Odds] with (nolock) ON Language.[Parameter.LiveOdds].OddsId=Live.[Parameter.Odds].OddsId
  -- where Language.[Parameter.LiveOdds].LanguageId=@LangId and Live.[Parameter.Odds].OddTypeId=Archive.SlipOdd.OddsTypeId
  -- and Live.[Parameter.Odds].Outcomes =
  -- (select top 1  LO.OutCome COLLATE SQL_Latin1_General_CP1_CI_AS   from Archive.[Live.EventOddResult] as LO  with (nolock)
  -- where LO.OddsTypeId=Archive.SlipOdd.OddsTypeId 
  -- and LO.BetradarMatchId=Archive.SlipOdd.BetradarMatchId
  -- and LO.SpecialBetValue=case when  Archive.SlipOdd.SpecialBetValue = '' then '-1' else Archive.SlipOdd.SpecialBetValue end and OddResult=1))
	 -- else case when Archive.SlipOdd.StateId=3 then Archive.SlipOdd.OutCome else '' end end 
	'' as WinOddtype
	  ,ISNULL(Archive.SlipOdd.Score,'-') as SlipScore,Language.[Parameter.LiveOddType].ShortOddType COLLATE SQL_Latin1_General_CP1253_CI_AI as ShortOddType,Archive.SlipOdd.Banko
	  ,'' as Live
			FROM      
								  Archive.SlipOdd with (nolock)   INNER JOIN
								  Live.[Parameter.OddType] with (nolock) ON Archive.SlipOdd.OddsTypeId = Live.[Parameter.OddType].OddTypeId INNER JOIN
								  Language.[Parameter.LiveOddType] with (nolock) ON Live.[Parameter.OddType].OddTypeId= Language.[Parameter.LiveOddType].OddTypeId INNER JOIN
								  Language.[Parameter.SlipState] with (nolock) ON Language.[Parameter.SlipState].[SlipStateId]=Archive.SlipOdd.StateId
			WHERE      (Archive.SlipOdd.SlipId in (select Customer.SlipSystemSlip.SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=(select top 1 Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SlipId=@SlipId)) )  and Archive.SlipOdd.BetTypeId=1 and  Language.[Parameter.LiveOddType].LanguageId=@LangId and Language.[Parameter.SlipState].LanguageId=@LangId
			UNION ALL
			SELECT    DISTINCT 0 as SlipId, Parameter.SlipState.StateId, Language.[Parameter.SlipState].SlipState as State, Archive.SlipOdd.EventName, '' AS OddsType, Archive.SlipOdd.OutCome AS Outcomes, 
								  Archive.SlipOdd.OddValue, Archive.SlipOdd.EventDate, '' AS Result, 
								  Archive.SlipOdd.SpecialBetValue,Archive.SlipOdd.MatchId, '' AS FinalResult,'' as WinOddtype,ISNULL(Archive.SlipOdd.Score,'-') as SlipScore,'' as ShortOddType,Archive.SlipOdd.Banko,'' as Live
			FROM         Parameter.SlipState INNER JOIN
								  Archive.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Archive.SlipOdd.StateId INNER JOIN
								  Language.[Parameter.SlipState] with (nolock) ON Language.[Parameter.SlipState].[SlipStateId]=Parameter.SlipState.StateId
			WHERE     (Archive.SlipOdd.SlipId in (select Customer.SlipSystemSlip.SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=(select top 1 Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SlipId=@SlipId)) )  AND (Archive.SlipOdd.BetTypeId = 2) and Language.[Parameter.SlipState].LanguageId=@LangId
	

		end

end



END




GO
