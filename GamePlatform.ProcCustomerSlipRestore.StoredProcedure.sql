USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerSlipRestore]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 

CREATE PROCEDURE [GamePlatform].[ProcCustomerSlipRestore] 
@SlipId bigint,
@LangId int,
@Username nvarchar(50)
AS

BEGIN
SET NOCOUNT ON;


if exists (select Customer.SlipOdd.SlipId from Customer.SlipOdd with (nolock) where Customer.SlipOdd.SlipId=@SlipId)
	begin

	if exists (select Customer.Slip.SlipId from Customer.Slip with (nolock) where Customer.Slip.SlipTypeId<3 and Customer.Slip.SlipId=@SlipId)
	begin
		SELECT    Parameter.SlipState.StateId, Language.[Parameter.SlipState].SlipState as State, 
		--cast(Customer.SlipOdd.MatchId as nvarchar(10))+' - '+ISNULL((select  TOP 1 Language.ParameterCompetitor.CompetitorName COLLATE SQL_Latin1_General_CP1_CI_AS from Match.Fixture 
		--INNER JOIN Match.FixtureCompetitor ON Match.Fixture.FixtureId=Match.FixtureCompetitor.FixtureId and  Match.FixtureCompetitor.TypeId=1 and Match.Fixture.MatchId=Customer.SlipOdd.MatchId
		--INNER JOIN Language.ParameterCompetitor ON Language.ParameterCompetitor.CompetitorId=Match.FixtureCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangId),'')+''+ISNULL((select  TOP 1 Language.ParameterCompetitor.CompetitorName COLLATE SQL_Latin1_General_CP1_CI_AS from Archive.Fixture 
		--INNER JOIN Archive.FixtureCompetitor ON Archive.Fixture.FixtureId=Archive.FixtureCompetitor.FixtureId and  Archive.FixtureCompetitor.TypeId=1 and Archive.Fixture.MatchId=Customer.SlipOdd.MatchId
		--INNER JOIN Language.ParameterCompetitor ON Language.ParameterCompetitor.CompetitorId=Archive.FixtureCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangId),'')+'-'+ISNULL((select  TOP 1 Language.ParameterCompetitor.CompetitorName COLLATE SQL_Latin1_General_CP1_CI_AS from Match.Fixture 
		--INNER JOIN Match.FixtureCompetitor ON Match.Fixture.FixtureId=Match.FixtureCompetitor.FixtureId and  Match.FixtureCompetitor.TypeId=2 and Match.Fixture.MatchId=Customer.SlipOdd.MatchId
		--INNER JOIN Language.ParameterCompetitor ON Language.ParameterCompetitor.CompetitorId=Match.FixtureCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangId),'')+''+ISNULL((select  TOP 1 Language.ParameterCompetitor.CompetitorName COLLATE SQL_Latin1_General_CP1_CI_AS from Archive.Fixture 
		--INNER JOIN Archive.FixtureCompetitor ON Archive.Fixture.FixtureId=Archive.FixtureCompetitor.FixtureId and  Archive.FixtureCompetitor.TypeId=2 and Archive.Fixture.MatchId=Customer.SlipOdd.MatchId
		--INNER JOIN Language.ParameterCompetitor ON Language.ParameterCompetitor.CompetitorId=Archive.FixtureCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangId),'')+''+ISNULL((select top 1 ' ( '+ISNULL(Language.[Parameter.Sport].SportName,'')+' ) ' from Language.[Parameter.Sport] where Language.[Parameter.Sport].SportId=Customer.SlipOdd.SportId and Language.[Parameter.Sport].LanguageId=@LangId),'') as EventName
		Customer.SlipOdd.EventName
		, Language.[Parameter.OddsType].OddsType+' ' +case when Customer.SlipOdd.ParameterOddId IN (1578,1544,1540,1648,1646,1644,1642,2247,2321,2325,2465,2541,2543,2915,2973,2993,2997,3010,3052,3079,3350,3371,3393) then '('+CAST( cast(Customer.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10))+')' else case when Customer.SlipOdd.SpecialBetValue is null or Customer.SlipOdd.SpecialBetValue='' or Customer.SlipOdd.SpecialBetValue='-1' then '' else '('+Customer.SlipOdd.SpecialBetValue+')' end end  as OddsType, 
							  Customer.SlipOdd.OutCome AS Outcomes, Customer.SlipOdd.OddValue, Customer.SlipOdd.EventDate as EventDate,
									  --[dbo].[FuncScore](Customer.SlipOdd.MatchId,0)  AS Result
									  '' as Result
									  ,case when Customer.SlipOdd.ParameterOddId IN (1578,1544,1540,1648,1646,1644,1642,2247,2321,2325,2465,2541,2543,2915,2973,2993,2997,3010,3052,3079,3350,3371,3393) then CAST( cast(Customer.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10)) else ISNULL(Customer.SlipOdd.SpecialBetValue, '') end as SpecialBetValue,
									  --case when (select Match.Match.BetradarMatchId from Match.Match where Match.Match.MatchId=Customer.SlipOdd.MatchId)>0 
									  --Then (select Match.Match.BetradarMatchId from Match.Match where Match.Match.MatchId=Customer.SlipOdd.MatchId)
									  --else (select Archive.Match.BetradarMatchId from Archive.Match where Archive.Match.MatchId=Customer.SlipOdd.MatchId) end as BetradarMatchId
									  Customer.SlipOdd.BetradarMatchId as BetradarMatchId
									  --,case when (select Count(*) from Match.Code where MatchId=Customer.SlipOdd.MatchId and BetTypeId=0)>0 then (select top 1 Code from Match.Code where MatchId=Customer.SlipOdd.MatchId and BetTypeId=0) else  (select top 1 Code from Archive.Code where MatchId=Customer.SlipOdd.MatchId and BetTypeId=0) end as MatchCode,
									  ,MAtch.Code.Code as MatchCode
									  ,Customer.SlipOdd.OddId,0 as BetType,Customer.SlipOdd.Banko,Language.[Parameter.OddsType].ShortOddType
		FROM         Parameter.SlipState with (nolock) INNER JOIN
							  Customer.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Customer.SlipOdd.StateId INNER JOIN
							  Match.Code with (nolock) ON Match.Code.MatchId=Customer.SlipOdd.MatchId and Match.Code.BetTypeId=0 INNER JOIN
							  Language.[Parameter.OddsType] with (nolock) ON Customer.SlipOdd.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId INNER JOIN
							  Language.[Parameter.Odds] with (nolock) ON Language.[Parameter.Odds].OddsId=Customer.SlipOdd.ParameterOddId INNER JOIN
							  Language.[Parameter.SlipState] with (nolock) ON Language.[Parameter.SlipState].SlipStateId=Parameter.SlipState.StateId and Language.[Parameter.SlipState].LanguageId=@LangId
		WHERE    Customer.SlipOdd.StateId=1 and (Customer.SlipOdd.SlipId = @SlipId) AND (Language.[Parameter.OddsType].LanguageId = @LangId) AND (Customer.SlipOdd.BetTypeId = 0) and Language.[Parameter.Odds].LanguageId=@LangId
		UNION ALL

		SELECT     Parameter.SlipState.StateId
		, Language.[Parameter.SlipState].SlipState as State,
		-- cast(Customer.SlipOdd.MatchId as nvarchar(10))+' - '+ISNULL((select  TOP 1 Language.ParameterCompetitor.CompetitorName COLLATE SQL_Latin1_General_CP1_CI_AS from Live.Event
		--INNER JOIN Language.ParameterCompetitor ON Language.ParameterCompetitor.CompetitorId=Live.Event.HomeTeam and Live.Event.EventId=Customer.SlipOdd.MatchId and Language.ParameterCompetitor.LanguageId=@LangId),'')+''+ISNULL((select  TOP 1 Language.ParameterCompetitor.CompetitorName COLLATE SQL_Latin1_General_CP1_CI_AS from Archive.[Live.Event]
		--INNER JOIN Language.ParameterCompetitor ON Language.ParameterCompetitor.CompetitorId=Archive.[Live.Event].HomeTeam and Archive.[Live.Event].EventId=Customer.SlipOdd.MatchId and Language.ParameterCompetitor.LanguageId=@LangId),'')+'-'+ISNULL((select Language.ParameterCompetitor.CompetitorName COLLATE SQL_Latin1_General_CP1_CI_AS from Live.Event
		--INNER JOIN Language.ParameterCompetitor ON Language.ParameterCompetitor.CompetitorId=Live.Event.AwayTeam and Live.Event.EventId=Customer.SlipOdd.MatchId and Language.ParameterCompetitor.LanguageId=@LangId),'')+''+ISNULL((select  TOP 1 Language.ParameterCompetitor.CompetitorName COLLATE SQL_Latin1_General_CP1_CI_AS from Archive.[Live.Event]
		--INNER JOIN Language.ParameterCompetitor ON Language.ParameterCompetitor.CompetitorId=Archive.[Live.Event].AwayTeam and Archive.[Live.Event].EventId=Customer.SlipOdd.MatchId and Language.ParameterCompetitor.LanguageId=@LangId),'')+' (Live)'
		Customer.SlipOdd.EventName
		,case when Customer.SlipOdd.SpecialBetValue<>'-1' 
		then  Language.[Parameter.LiveOddType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI +' '+ case when Customer.SlipOdd.ParameterOddId in (108,112,116,129,137,143,149,192,387,389,426,428,1947,2059,2503,2505,2553,2965,3257) 
		  then CAST( cast(Customer.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10))
		  else case when Customer.SlipOdd.SpecialBetValue<>'-1' then  ISNULL(Customer.SlipOdd.SpecialBetValue,'') else '' end end
		else Language.[Parameter.LiveOddType].OddsType end AS OddsType, 
	 case when Language.[Parameter.LiveOdds].OutComes like '%none%' then Customer.SlipOdd.OutCome else Language.[Parameter.LiveOdds].OutComes end AS Outcomes
						   ,Customer.SlipOdd.OddValue,  dbo.UserTimeZoneDate('administrator',Customer.SlipOdd.EventDate,0) as EventDate, 
						   --'Live Score -'+ISNULL((select Score from Live.EventDetail where Live.EventDetail.EventId=Customer.SlipOdd.MatchId),'') 
						   [dbo].[FuncScore](Customer.SlipOdd.MatchId,1) AS Result
						   , case when Customer.SlipOdd.SpecialBetValue<>'-1' then  case when Customer.SlipOdd.ParameterOddId in (108,112,116,129,137,143,149,192,387,389,426,428,1947,2059,2503,2505,2553,2965) 
		  then CAST( cast(Customer.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10))
		  else case when Customer.SlipOdd.SpecialBetValue<>'-1' then  ISNULL(Customer.SlipOdd.SpecialBetValue,'') else '' end end else '' end as SpecialBetValue,
		  --case when (select Live.[Event].BetradarMatchId from Live.[Event] where Live.[Event].EventId=Customer.SlipOdd.MatchId)>0 
				--					  Then (select Live.[Event].BetradarMatchId from Live.[Event] where Live.[Event].EventId=Customer.SlipOdd.MatchId)
				--					  else (select Archive.[Live.Event].BetradarMatchId from Archive.[Live.Event] where Archive.[Live.Event].EventId=Customer.SlipOdd.MatchId) end as BetradarMatchId
									  Customer.SlipOdd.BetradarMatchId as BetradarMatchId
									  --,case when (select Count(*) from Match.Code where MatchId=Customer.SlipOdd.MatchId and BetTypeId=1)>0 then (select top 1 Code from Match.Code where MatchId=Customer.SlipOdd.MatchId and BetTypeId=1) else  (select top 1 Code from Archive.Code where MatchId=Customer.SlipOdd.MatchId and BetTypeId=1) end as MatchCode
									   ,MAtch.Code.Code as MatchCode
									  ,Customer.SlipOdd.OddId,1 as BetType,Customer.SlipOdd.Banko,Language.[Parameter.LiveOddType].ShortOddType
		FROM         Parameter.SlipState with (nolock) INNER JOIN
							  Customer.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Customer.SlipOdd.StateId INNER JOIN
							    Match.Code with (nolock) ON Match.Code.MatchId=Customer.SlipOdd.MatchId and Match.Code.BetTypeId=1 INNER JOIN
							  Live.[Parameter.OddType] with (nolock) ON Customer.SlipOdd.OddsTypeId = Live.[Parameter.OddType].OddTypeId INNER JOIN
							  Language.[Parameter.LiveOddType] with (nolock) ON Language.[Parameter.LiveOddType].OddTypeId=Live.[Parameter.OddType].OddTypeId INNER JOIN
							  Language.[Parameter.LiveOdds] with (nolock) ON Language.[Parameter.LiveOdds].OddsId=Customer.SlipOdd.ParameterOddId  INNER JOIN
							   Language.[Parameter.SlipState] with (nolock) ON Language.[Parameter.SlipState].SlipStateId=Parameter.SlipState.StateId and Language.[Parameter.SlipState].LanguageId=@LangId
		WHERE  Customer.SlipOdd.StateId=1 and    (Customer.SlipOdd.SlipId = @SlipId) and Customer.SlipOdd.BetTypeId=1 and Language.[Parameter.LiveOddType].LanguageId=@LangId and Language.[Parameter.LiveOdds].LanguageId=@LangId


		--UNION ALL
		--SELECT      Parameter.SlipState.StateId, Parameter.SlipState.State, cast(Customer.SlipOdd.MatchId as nvarchar(10))+' - '+Customer.SlipOdd.EventName, '' AS OddsType, Customer.SlipOdd.OutCome AS Outcomes, 
		--					  Customer.SlipOdd.OddValue, dbo.UserTimeZoneDate('administrator',Customer.SlipOdd.EventDate,0) as EventDate, '' AS Result, 
		--					  Customer.SlipOdd.SpecialBetValue,0 as BetradarMatchId,Match.Code.Code as MatchCode,Customer.SlipOdd.OddId,2 as BetType,Customer.SlipOdd.Banko,'' as ShortOddType
		--FROM         Parameter.SlipState INNER JOIN
		--					  Customer.SlipOdd ON Parameter.SlipState.StateId = Customer.SlipOdd.StateId LEFT OUTER JOIN Match.Code ON Match.Code.MatchId=Customer.SlipOdd.MatchId and Match.Code.BetTypeId=2
		--WHERE   Customer.SlipOdd.StateId=1 and   (Customer.SlipOdd.SlipId = @SlipId) AND (Customer.SlipOdd.BetTypeId = 2)
--		UNION ALL
--		SELECT     Customer.SlipOdd.SlipOddId,Parameter.SlipState.StateId
--, Parameter.SlipState.State
--, cast(Customer.SlipOdd.MatchId as nvarchar(10))+' - '+Customer.SlipOdd.EventName as EventName
--, LSports.[Parameter.OutcomeType].OutcomeType AS OddsType
--,Customer.SlipOdd.OutCome AS Outcomes, Customer.SlipOdd.OddValue, dbo.UserTimeZoneDate(@Username,Customer.SlipOdd.EventDate,0) as EventDate,
--									  ''  AS Result,'' as SpecialBetValue,
--									  CAST('0' as bigint)  as BetradarMatchId
--		FROM         Parameter.SlipState INNER JOIN
--						  Customer.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Customer.SlipOdd.StateId INNER JOIN
--						  LSports.[Parameter.OutcomeType] ON Customer.SlipOdd.OddsTypeId = LSports.[Parameter.OutcomeType].OutcomeTypeId INNER JOIN
--						  Language.[Parameter.SlipState] ON Language.[Parameter.SlipState].[SlipStateId]=Parameter.SlipState.StateId
--		WHERE     (Customer.SlipOdd.SlipId = @SlipId)  AND (Customer.SlipOdd.BetTypeId = 4) and  Language.[Parameter.SlipState].LanguageId=@LangId
		
		--UNION ALL
		--SELECT     Customer.SlipOdd.SlipOddId,Parameter.SlipState.StateId, Parameter.SlipState.State, Customer.SlipOdd.EventName, Virtual.[Parameter.OddType].OddType AS OddsType, 
		--					  Customer.SlipOdd.OutCome AS Outcomes, Customer.SlipOdd.OddValue,dbo.UserTimeZoneDate(@Username,Customer.SlipOdd.EventDate,0) as EventDate,Customer.SlipOdd.Score as Result,Customer.SlipOdd.SpecialBetValue,
		--					  0 as BetradarMatchId
		--FROM         Parameter.SlipState INNER JOIN
		--					  Customer.SlipOdd ON Parameter.SlipState.StateId = Customer.SlipOdd.StateId INNER JOIN
		--					  Virtual.[Parameter.OddType] ON Customer.SlipOdd.OddsTypeId = Virtual.[Parameter.OddType].OddTypeId
		--WHERE     (Customer.SlipOdd.SlipId = @SlipId) and Customer.SlipOdd.BetTypeId=3
		end
		else
		begin
			SELECT DISTINCT   case when  Parameter.SlipState.StateId=5 then 3 else Parameter.SlipState.StateId end as StateId ,
			Language.[Parameter.SlipState].SlipState as State,
		--	cast(Customer.SlipOdd.MatchId as nvarchar(10))+' - '+ ISNULL((select TOP 1 Language.ParameterCompetitor.CompetitorName COLLATE SQL_Latin1_General_CP1_CI_AS from Match.Fixture 
		--INNER JOIN Match.FixtureCompetitor ON Match.Fixture.FixtureId=Match.FixtureCompetitor.FixtureId and  Match.FixtureCompetitor.TypeId=1 and Match.Fixture.MatchId=Customer.SlipOdd.MatchId
		--INNER JOIN Language.ParameterCompetitor ON Language.ParameterCompetitor.CompetitorId=Match.FixtureCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangId),'')+''+ISNULL((select TOP 1 Language.ParameterCompetitor.CompetitorName COLLATE SQL_Latin1_General_CP1_CI_AS from Archive.Fixture 
		--INNER JOIN Archive.FixtureCompetitor ON Archive.Fixture.FixtureId=Archive.FixtureCompetitor.FixtureId and  Archive.FixtureCompetitor.TypeId=1 and Archive.Fixture.MatchId=Customer.SlipOdd.MatchId
		--INNER JOIN Language.ParameterCompetitor ON Language.ParameterCompetitor.CompetitorId=Archive.FixtureCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangId),'')+'-'+ISNULL((select  TOP 1 Language.ParameterCompetitor.CompetitorName COLLATE SQL_Latin1_General_CP1_CI_AS from Match.Fixture 
		--INNER JOIN Match.FixtureCompetitor ON Match.Fixture.FixtureId=Match.FixtureCompetitor.FixtureId and  Match.FixtureCompetitor.TypeId=2 and Match.Fixture.MatchId=Customer.SlipOdd.MatchId
		--INNER JOIN Language.ParameterCompetitor ON Language.ParameterCompetitor.CompetitorId=Match.FixtureCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangId),'')+''+ISNULL((select  TOP 1 Language.ParameterCompetitor.CompetitorName COLLATE SQL_Latin1_General_CP1_CI_AS from Archive.Fixture 
		--INNER JOIN Archive.FixtureCompetitor ON Archive.Fixture.FixtureId=Archive.FixtureCompetitor.FixtureId and  Archive.FixtureCompetitor.TypeId=2 and Archive.Fixture.MatchId=Customer.SlipOdd.MatchId
		--INNER JOIN Language.ParameterCompetitor ON Language.ParameterCompetitor.CompetitorId=Archive.FixtureCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangId),'') as EventName, 
		Customer.SlipOdd.EventName,
		Language.[Parameter.OddsType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI +' ' +case when Customer.SlipOdd.ParameterOddId IN (1578,1544,1540,1648,1646,1644,1642,2247,2321,2325,2465,2541,2543,2915,2973,2993,2997,3010,3052,3079,3350,3371,3393) then CAST( '('+cast(Customer.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10))+')' else case when Customer.SlipOdd.SpecialBetValue is null or Customer.SlipOdd.SpecialBetValue='' or Customer.SlipOdd.SpecialBetValue='-1' then '' else '('+Customer.SlipOdd.SpecialBetValue+')' end end  as OddsType, 
						  Customer.SlipOdd.OutCome AS Outcomes, Customer.SlipOdd.OddValue, Customer.SlipOdd.EventDate,
								 [dbo].[FuncScore](Customer.SlipOdd.MatchId,0)   AS Result,case when Customer.SlipOdd.ParameterOddId IN (1578,1544,1540,1648,1646,1644,1642,2247,2321,2325,2465,2541,2543,2915,2973,2993,2997,3010,3052,3079,3350,3371,3393) then CAST( cast(Customer.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10)) else ISNULL(Customer.SlipOdd.SpecialBetValue, '') end AS SpecialBetValue
								   ,Customer.SlipOdd.MatchId as BetradarMatchId,case when (select Count(*) from Match.Code with (nolock) where MatchId=Customer.SlipOdd.MatchId and BetTypeId=0)>0 then (select top 1 Code from Match.Code with (nolock) where MatchId=Customer.SlipOdd.MatchId and BetTypeId=0) else  (select top 1 Code from Archive.Code where MatchId=Customer.SlipOdd.MatchId and BetTypeId=0) end as MatchCode,Customer.SlipOdd.OddId,0 as BetType,Customer.SlipOdd.Banko
								   ,Language.[Parameter.OddsType].ShortOddType
			FROM         Parameter.SlipState with (nolock) INNER JOIN
								  Customer.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Customer.SlipOdd.StateId INNER JOIN
								  Language.[Parameter.OddsType] ON Customer.SlipOdd.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId INNER JOIN
								  Language.[Parameter.SlipState] ON Language.[Parameter.SlipState].[SlipStateId]=Parameter.SlipState.StateId 
			WHERE   Customer.SlipOdd.StateId=1 and   (Customer.SlipOdd.SlipId in (select Customer.SlipSystemSlip.SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=(select top 1 Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SlipId=@SlipId)) ) AND (Language.[Parameter.OddsType].LanguageId = @LangId) and Language.[Parameter.SlipState].LanguageId=@LangId AND (Customer.SlipOdd.BetTypeId = 0)
			UNION ALL
			SELECT   DISTINCT  case when  Parameter.SlipState.StateId=5 then 3 else Parameter.SlipState.StateId end as StateId, Language.[Parameter.SlipState].SlipState as State,
		--	cast(Customer.SlipOdd.MatchId as nvarchar(10))+' - '+ ISNULL((select Language.ParameterCompetitor.CompetitorName COLLATE SQL_Latin1_General_CP1_CI_AS from Live.Event
		--INNER JOIN Language.ParameterCompetitor ON Language.ParameterCompetitor.CompetitorId=Live.Event.HomeTeam and Live.Event.EventId=Customer.SlipOdd.MatchId and Language.ParameterCompetitor.LanguageId=@LangId),'')+''+ISNULL((select Language.ParameterCompetitor.CompetitorName COLLATE SQL_Latin1_General_CP1_CI_AS from Archive.[Live.Event]
		--INNER JOIN Language.ParameterCompetitor ON Language.ParameterCompetitor.CompetitorId=Archive.[Live.Event].HomeTeam and Archive.[Live.Event].EventId=Customer.SlipOdd.MatchId and Language.ParameterCompetitor.LanguageId=@LangId),'')+'-'+ISNULL((select Language.ParameterCompetitor.CompetitorName COLLATE SQL_Latin1_General_CP1_CI_AS from Live.Event
		--INNER JOIN Language.ParameterCompetitor ON Language.ParameterCompetitor.CompetitorId=Live.Event.AwayTeam and Live.Event.EventId=Customer.SlipOdd.MatchId and Language.ParameterCompetitor.LanguageId=@LangId),'')+''+ISNULL((select Language.ParameterCompetitor.CompetitorName COLLATE SQL_Latin1_General_CP1_CI_AS from Archive.[Live.Event]
		--INNER JOIN Language.ParameterCompetitor ON Language.ParameterCompetitor.CompetitorId=Archive.[Live.Event].AwayTeam and Archive.[Live.Event].EventId=Customer.SlipOdd.MatchId and Language.ParameterCompetitor.LanguageId=@LangId),'')+' (Live)' as EventName,
		Customer.SlipOdd.EventName,
		Language.[Parameter.LiveOddType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI +' ' +case when Customer.SlipOdd.ParameterOddId IN (1578,1544,1540,1648,1646,1644,1642,2247,2321,2325,2465,2541,2543,2915,2973,2993,2997,3010,3052,3079,3350,3371,3393) then CAST( '('+cast(Customer.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10))+')' else case when Customer.SlipOdd.SpecialBetValue is null or Customer.SlipOdd.SpecialBetValue='' or Customer.SlipOdd.SpecialBetValue='-1' then '' else '('+Customer.SlipOdd.SpecialBetValue+')' end end AS OddsType, 
				    Customer.SlipOdd.OutCome AS Outcomes
							   , Customer.SlipOdd.OddValue, Customer.SlipOdd.EventDate,
				   [dbo].[FuncScore](Customer.SlipOdd.MatchId,1) AS Result
							   ,case when Customer.SlipOdd.ParameterOddId in (108,112,116,129,137,143,149,192,387,389,426,428,1947,2059,2503,2505,2553,2965,3257) 
			  then CAST( cast(Customer.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10))
			  else case when Customer.SlipOdd.SpecialBetValue<>'-1' then  ISNULL(Customer.SlipOdd.SpecialBetValue,'') else '' end end as SpecialBetValue
			  ,Customer.SlipOdd.MatchId as BetradarMatchId,Match.Code.Code as MatchCode,Customer.SlipOdd.OddId,1 as BetType,Customer.SlipOdd.Banko,Language.[Parameter.LiveOddType].ShortOddType
			FROM         Parameter.SlipState with (nolock) INNER JOIN
								  Customer.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Customer.SlipOdd.StateId INNER JOIN
								  Live.[Parameter.OddType] with (nolock) ON Customer.SlipOdd.OddsTypeId = Live.[Parameter.OddType].OddTypeId INNER JOIN
								  Language.[Parameter.LiveOddType] ON Live.[Parameter.OddType].OddTypeId= Language.[Parameter.LiveOddType].OddTypeId INNER JOIN
								  Language.[Parameter.SlipState] ON Language.[Parameter.SlipState].[SlipStateId]=Parameter.SlipState.StateId LEFT OUTER JOIN Match.Code ON Match.Code.MatchId=Customer.SlipOdd.MatchId
			WHERE  Customer.SlipOdd.StateId=1 and    (Customer.SlipOdd.SlipId in (select Customer.SlipSystemSlip.SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=(select top 1 Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SlipId=@SlipId)) ) and Customer.SlipOdd.BetTypeId=1 and  Language.[Parameter.LiveOddType].LanguageId=@LangId and Language.[Parameter.SlipState].LanguageId=@LangId
			--UNION ALL
			--SELECT   DISTINCT   Parameter.SlipState.StateId, Language.[Parameter.SlipState].SlipState as State,cast(Customer.SlipOdd.MatchId as nvarchar(10))+' - '+ Customer.SlipOdd.EventName, '' AS OddsType, Customer.SlipOdd.OutCome AS Outcomes, 
			--					  Customer.SlipOdd.OddValue, Customer.SlipOdd.EventDate, '' AS Result, 
			--					  Customer.SlipOdd.SpecialBetValue,Customer.SlipOdd.MatchId as BetradarMatchId,Match.Code.Code as MatchCode ,Customer.SlipOdd.OddId,2 as BetType,Customer.SlipOdd.Banko,'' as ShortOddType
			--FROM         Parameter.SlipState INNER JOIN
			--					  Customer.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Customer.SlipOdd.StateId INNER JOIN
			--					  Language.[Parameter.SlipState] ON Language.[Parameter.SlipState].[SlipStateId]=Parameter.SlipState.StateId LEFT OUTER JOIN Match.Code ON Match.Code.MatchId=Customer.SlipOdd.MatchId
			--WHERE   Customer.SlipOdd.StateId=1 and   (Customer.SlipOdd.SlipId in (select Customer.SlipSystemSlip.SlipId from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SystemSlipId=(select top 1 Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SlipId=@SlipId)) ) AND (Customer.SlipOdd.BetTypeId = 2) and Language.[Parameter.SlipState].LanguageId=@LangId
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
	if exists(select Archive.Slip.SlipId from Archive.Slip with (nolock) where Archive.Slip.SlipTypeId<3 and Archive.Slip.SlipId=@SlipId)
	begin
		SELECT     Parameter.SlipState.StateId, Language.[Parameter.SlipState].SlipState as State, 
		Archive.SlipOdd.EventName
		--cast(Archive.SlipOdd.MatchId as nvarchar(10))+' - '+ISNULL((select TOP 1  Language.ParameterCompetitor.CompetitorName COLLATE SQL_Latin1_General_CP1_CI_AS from Match.Fixture 
		--INNER JOIN Match.FixtureCompetitor ON Match.Fixture.FixtureId=Match.FixtureCompetitor.FixtureId and  Match.FixtureCompetitor.TypeId=1 and Match.Fixture.MatchId=Archive.SlipOdd.MatchId
		--INNER JOIN Language.ParameterCompetitor ON Language.ParameterCompetitor.CompetitorId=Match.FixtureCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangId),'')+''+ISNULL((select TOP 1  Language.ParameterCompetitor.CompetitorName COLLATE SQL_Latin1_General_CP1_CI_AS from Archive.Fixture 
		--INNER JOIN Archive.FixtureCompetitor ON Archive.Fixture.FixtureId=Archive.FixtureCompetitor.FixtureId and  Archive.FixtureCompetitor.TypeId=1 and Archive.Fixture.MatchId=Archive.SlipOdd.MatchId
		--INNER JOIN Language.ParameterCompetitor ON Language.ParameterCompetitor.CompetitorId=Archive.FixtureCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangId),'')+'-'+ISNULL((select TOP 1  Language.ParameterCompetitor.CompetitorName COLLATE SQL_Latin1_General_CP1_CI_AS from Match.Fixture 
		--INNER JOIN Match.FixtureCompetitor ON Match.Fixture.FixtureId=Match.FixtureCompetitor.FixtureId and  Match.FixtureCompetitor.TypeId=2 and Match.Fixture.MatchId=Archive.SlipOdd.MatchId
		--INNER JOIN Language.ParameterCompetitor ON Language.ParameterCompetitor.CompetitorId=Match.FixtureCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangId),'')+''+ISNULL((select TOP 1  Language.ParameterCompetitor.CompetitorName COLLATE SQL_Latin1_General_CP1_CI_AS from Archive.Fixture 
		--INNER JOIN Archive.FixtureCompetitor ON Archive.Fixture.FixtureId=Archive.FixtureCompetitor.FixtureId and  Archive.FixtureCompetitor.TypeId=2 and Archive.Fixture.MatchId=Archive.SlipOdd.MatchId
		--INNER JOIN Language.ParameterCompetitor ON Language.ParameterCompetitor.CompetitorId=Archive.FixtureCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangId),'')+''+ISNULL((select TOP 1  ' ( '+ISNULL(Language.[Parameter.Sport].SportName,'')+' ) ' from Language.[Parameter.Sport] where Language.[Parameter.Sport].SportId=Archive.SlipOdd.SportId and Language.[Parameter.Sport].LanguageId=@LangId),'') as EventName
		, Language.[Parameter.OddsType].OddsType +' '+case when Archive.SlipOdd.ParameterOddId IN (2247,2321,2325,2465,2541,2543,2915,2973,2993,2997,3010,3052,3079,3350,3371,3393) then CAST( cast(Archive.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10)) else ISNULL(Archive.SlipOdd.SpecialBetValue, '') end AS OddsType, 
							  Language.[Parameter.Odds].OutComes as Outcomes, Archive.SlipOdd.OddValue, dbo.UserTimeZoneDate('administrator',Archive.SlipOdd.EventDate,0) as EventDate,
									   [dbo].[FuncScore](Archive.SlipOdd.MatchId,0)  AS Result,case when Archive.SlipOdd.ParameterOddId IN (2247,2321,2325,2465,2541,2543,2915,2973,2993,2997,3010,3052,3079,3350,3371,3393) then CAST( cast(Archive.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10)) 
									   else ISNULL(Archive.SlipOdd.SpecialBetValue, '') end as SpecialBetValue,
									  case when (select Match.Match.BetradarMatchId from Match.Match with (nolock) where Match.Match.MatchId=Archive.SlipOdd.MatchId)>0 
									  Then (select Match.Match.BetradarMatchId from Match.Match with (nolock) where Match.Match.MatchId=Archive.SlipOdd.MatchId)
									  else (select Archive.Match.BetradarMatchId from Archive.Match with (nolock) where Archive.Match.MatchId=Archive.SlipOdd.MatchId) end as BetradarMatchId,Archive.Code.Code as MatchCode
									  ,Archive.SlipOdd.OddId,0 as BetType,Archive.SlipOdd.Banko,Language.[Parameter.OddsType].ShortOddType
		FROM         Parameter.SlipState with (nolock) INNER JOIN
							  Archive.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Archive.SlipOdd.StateId INNER JOIN
							  Language.[Parameter.OddsType] with (nolock) ON Archive.SlipOdd.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId INNER JOIN
							  Language.[Parameter.Odds] with (nolock) ON Language.[Parameter.Odds].OddsId=Archive.SlipOdd.ParameterOddId LEFT OUTER JOIN Archive.Code ON Archive.Code.MatchId=Archive.SlipOdd.MatchId INNER JOIN
							   Language.[Parameter.SlipState] with (nolock) ON Language.[Parameter.SlipState].SlipStateId=Parameter.SlipState.StateId and Language.[Parameter.SlipState].LanguageId=@LangId
		WHERE    Archive.SlipOdd.StateId=1 and  (Archive.SlipOdd.SlipId = @SlipId) AND (Language.[Parameter.OddsType].LanguageId = @LangId) AND (Archive.SlipOdd.BetTypeId = 0) and Language.[Parameter.Odds].LanguageId=@LangId
		UNION ALL

		SELECT      Parameter.SlipState.StateId
		,  Language.[Parameter.SlipState].SlipState as State, 
		--cast(Archive.SlipOdd.MatchId as nvarchar(10))+' - '+ISNULL((select TOP 1  Language.ParameterCompetitor.CompetitorName COLLATE SQL_Latin1_General_CP1_CI_AS from Live.Event
		--INNER JOIN Language.ParameterCompetitor ON Language.ParameterCompetitor.CompetitorId=Live.Event.HomeTeam and Live.Event.EventId=Archive.SlipOdd.MatchId and Language.ParameterCompetitor.LanguageId=@LangId),'')+''+ISNULL((select TOP 1  Language.ParameterCompetitor.CompetitorName COLLATE SQL_Latin1_General_CP1_CI_AS from Archive.[Live.Event]
		--INNER JOIN Language.ParameterCompetitor ON Language.ParameterCompetitor.CompetitorId=Archive.[Live.Event].HomeTeam and Archive.[Live.Event].EventId=Archive.SlipOdd.MatchId and Language.ParameterCompetitor.LanguageId=@LangId),'')+'-'+ISNULL((select TOP 1  Language.ParameterCompetitor.CompetitorName COLLATE SQL_Latin1_General_CP1_CI_AS from Live.Event
		--INNER JOIN Language.ParameterCompetitor ON Language.ParameterCompetitor.CompetitorId=Live.Event.AwayTeam and Live.Event.EventId=Archive.SlipOdd.MatchId and Language.ParameterCompetitor.LanguageId=@LangId),'')+''+ISNULL((select TOP 1  Language.ParameterCompetitor.CompetitorName COLLATE SQL_Latin1_General_CP1_CI_AS from Archive.[Live.Event]
		--INNER JOIN Language.ParameterCompetitor ON Language.ParameterCompetitor.CompetitorId=Archive.[Live.Event].AwayTeam and Archive.[Live.Event].EventId=Archive.SlipOdd.MatchId and Language.ParameterCompetitor.LanguageId=@LangId),'')+' (Live)'
		Archive.SlipOdd.EventName
		,case when Archive.SlipOdd.SpecialBetValue<>'-1' 
		then  Language.[Parameter.LiveOddType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI +' '+ case when Archive.SlipOdd.ParameterOddId in (108,112,116,129,137,143,149,192,387,389,426,428,1947,2059,2503,2505,2553,2965) 
		  then CAST( cast(Archive.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10))
		  else case when Archive.SlipOdd.SpecialBetValue<>'-1' then  ISNULL(Archive.SlipOdd.SpecialBetValue,'') else '' end end
		else Language.[Parameter.LiveOddType].OddsType end AS OddsType, 
		  Archive.SlipOdd.OutCome  AS Outcomes
						   , Archive.SlipOdd.OddValue,  dbo.UserTimeZoneDate('administrator',Archive.SlipOdd.EventDate,0) as EventDate, 
						   --'Live Score -'+ISNULL((select Score from Live.EventDetail where Live.EventDetail.EventId=Archive.SlipOdd.MatchId),'') 
						   [dbo].[FuncScore](Archive.SlipOdd.MatchId,1) AS Result
						   , case when Archive.SlipOdd.SpecialBetValue<>'-1' then  case when Archive.SlipOdd.ParameterOddId in (108,112,116,129,137,143,149,192,387,389,426,428,1947,2059,2503,2505,2553,2965) 
		  then CAST( cast(Archive.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10))
		  else case when Archive.SlipOdd.SpecialBetValue<>'-1' then  ISNULL(Archive.SlipOdd.SpecialBetValue,'') else '' end end else '' end as SpecialBetValue,
		  case when (select Live.[Event].BetradarMatchId from Live.[Event] with (nolock) where Live.[Event].EventId=Archive.SlipOdd.MatchId)>0 
									  Then (select Live.[Event].BetradarMatchId from Live.[Event] with (nolock) where Live.[Event].EventId=Archive.SlipOdd.MatchId)
									  else (select Archive.[Live.Event].BetradarMatchId from Archive.[Live.Event] with (nolock) where Archive.[Live.Event].EventId=Archive.SlipOdd.MatchId) end as BetradarMatchId,Archive.Code.Code as MatchCode
									   ,Archive.SlipOdd.OddId,1 as BetType,Archive.SlipOdd.Banko,Language.[Parameter.LiveOddType].ShortOddType
		FROM         Parameter.SlipState with (nolock) INNER JOIN
							  Archive.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Archive.SlipOdd.StateId INNER JOIN
							  Live.[Parameter.OddType] with (nolock) ON Archive.SlipOdd.OddsTypeId = Live.[Parameter.OddType].OddTypeId INNER JOIN
							  Language.[Parameter.LiveOddType] with (nolock) ON Language.[Parameter.LiveOddType].OddTypeId=Live.[Parameter.OddType].OddTypeId INNER JOIN
							  Language.[Parameter.LiveOdds] with (nolock) ON Language.[Parameter.LiveOdds].OddsId=Archive.SlipOdd.ParameterOddId  LEFT OUTER JOIN Archive.Code ON Archive.Code.MatchId=Archive.SlipOdd.MatchId INNER JOIN
							   Language.[Parameter.SlipState] with (nolock) ON Language.[Parameter.SlipState].SlipStateId=Parameter.SlipState.StateId and Language.[Parameter.SlipState].LanguageId=@LangId
		WHERE    Archive.SlipOdd.StateId=1 and  (Archive.SlipOdd.SlipId = @SlipId) and Archive.SlipOdd.BetTypeId=1 and Language.[Parameter.LiveOddType].LanguageId=@LangId and Language.[Parameter.LiveOdds].LanguageId=@LangId


		--UNION ALL
		--SELECT     Parameter.SlipState.StateId, Parameter.SlipState.State,cast(Archive.SlipOdd.MatchId as nvarchar(10))+' - '+ Archive.SlipOdd.EventName, '' AS OddsType, Archive.SlipOdd.OutCome AS Outcomes, 
		--					  Archive.SlipOdd.OddValue, dbo.UserTimeZoneDate('administrator',Archive.SlipOdd.EventDate,0) as EventDate, '' AS Result, 
		--					  Archive.SlipOdd.SpecialBetValue,0 as BetradarMatchId,Match.Code.Code as MatchCode ,Archive.SlipOdd.OddId,2 as BetType,Archive.SlipOdd.Banko,'' as ShortOddType
		--FROM         Parameter.SlipState INNER JOIN
		--					  Archive.SlipOdd ON Parameter.SlipState.StateId = Archive.SlipOdd.StateId LEFT OUTER JOIN Match.Code ON Match.Code.MatchId=Archive.SlipOdd.MatchId and Match.Code.BetTypeId=2
		--WHERE    Archive.SlipOdd.StateId=1 and  (Archive.SlipOdd.SlipId = @SlipId) AND (Archive.SlipOdd.BetTypeId = 2)
--		UNION ALL
--		SELECT     Customer.SlipOdd.SlipOddId,Parameter.SlipState.StateId
--, Parameter.SlipState.State
--, cast(Customer.SlipOdd.MatchId as nvarchar(10))+' - '+Customer.SlipOdd.EventName as EventName
--, LSports.[Parameter.OutcomeType].OutcomeType AS OddsType
--,Customer.SlipOdd.OutCome AS Outcomes, Customer.SlipOdd.OddValue, dbo.UserTimeZoneDate(@Username,Customer.SlipOdd.EventDate,0) as EventDate,
--									  ''  AS Result,'' as SpecialBetValue,
--									  CAST('0' as bigint)  as BetradarMatchId
--		FROM         Parameter.SlipState INNER JOIN
--						  Customer.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Customer.SlipOdd.StateId INNER JOIN
--						  LSports.[Parameter.OutcomeType] ON Customer.SlipOdd.OddsTypeId = LSports.[Parameter.OutcomeType].OutcomeTypeId INNER JOIN
--						  Language.[Parameter.SlipState] ON Language.[Parameter.SlipState].[SlipStateId]=Parameter.SlipState.StateId
--		WHERE     (Customer.SlipOdd.SlipId = @SlipId)  AND (Customer.SlipOdd.BetTypeId = 4) and  Language.[Parameter.SlipState].LanguageId=@LangId
		
		--UNION ALL
		--SELECT     Archive.SlipOdd.SlipOddId,Parameter.SlipState.StateId, Parameter.SlipState.State, Archive.SlipOdd.EventName, Virtual.[Parameter.OddType].OddType AS OddsType, 
		--					  Archive.SlipOdd.OutCome AS Outcomes, Archive.SlipOdd.OddValue,dbo.UserTimeZoneDate(@Username,Archive.SlipOdd.EventDate,0) as EventDate,Archive.SlipOdd.Score as Result,Archive.SlipOdd.SpecialBetValue,
		--					  0 as BetradarMatchId
		--FROM         Parameter.SlipState INNER JOIN
		--					  Archive.SlipOdd ON Parameter.SlipState.StateId = Archive.SlipOdd.StateId INNER JOIN
		--					  Virtual.[Parameter.OddType] ON Archive.SlipOdd.OddsTypeId = Virtual.[Parameter.OddType].OddTypeId
		--WHERE     (Archive.SlipOdd.SlipId = @SlipId) and Archive.SlipOdd.BetTypeId=3
	end
		else
		begin
			SELECT  DISTINCT  case when  Parameter.SlipState.StateId=5 then 3 else Parameter.SlipState.StateId end as StateId ,Language.[Parameter.SlipState].SlipState as State,
		--	cast(Archive.SlipOdd.MatchId as nvarchar(10))+' - '+ ISNULL((select Language.ParameterCompetitor.CompetitorName COLLATE SQL_Latin1_General_CP1_CI_AS from Match.Fixture 
		--INNER JOIN Match.FixtureCompetitor ON Match.Fixture.FixtureId=Match.FixtureCompetitor.FixtureId and  Match.FixtureCompetitor.TypeId=1 and Match.Fixture.MatchId=Archive.SlipOdd.MatchId
		--INNER JOIN Language.ParameterCompetitor ON Language.ParameterCompetitor.CompetitorId=Match.FixtureCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangId),'')+''+ISNULL((select Language.ParameterCompetitor.CompetitorName COLLATE SQL_Latin1_General_CP1_CI_AS from Archive.Fixture 
		--INNER JOIN Archive.FixtureCompetitor ON Archive.Fixture.FixtureId=Archive.FixtureCompetitor.FixtureId and  Archive.FixtureCompetitor.TypeId=1 and Archive.Fixture.MatchId=Archive.SlipOdd.MatchId
		--INNER JOIN Language.ParameterCompetitor ON Language.ParameterCompetitor.CompetitorId=Archive.FixtureCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangId),'')+'-'+ISNULL((select Language.ParameterCompetitor.CompetitorName COLLATE SQL_Latin1_General_CP1_CI_AS from Match.Fixture 
		--INNER JOIN Match.FixtureCompetitor ON Match.Fixture.FixtureId=Match.FixtureCompetitor.FixtureId and  Match.FixtureCompetitor.TypeId=2 and Match.Fixture.MatchId=Archive.SlipOdd.MatchId
		--INNER JOIN Language.ParameterCompetitor ON Language.ParameterCompetitor.CompetitorId=Match.FixtureCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangId),'')+''+ISNULL((select Language.ParameterCompetitor.CompetitorName COLLATE SQL_Latin1_General_CP1_CI_AS from Archive.Fixture 
		--INNER JOIN Archive.FixtureCompetitor ON Archive.Fixture.FixtureId=Archive.FixtureCompetitor.FixtureId and  Archive.FixtureCompetitor.TypeId=2 and Archive.Fixture.MatchId=Archive.SlipOdd.MatchId
		--INNER JOIN Language.ParameterCompetitor ON Language.ParameterCompetitor.CompetitorId=Archive.FixtureCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangId),'') as EventName,
		Archive.SlipOdd.EventName,
		 Language.[Parameter.OddsType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI +' ' +case when Archive.SlipOdd.ParameterOddId IN (1578,1544,1540,1648,1646,1644,1642,2247,2321,2325,2465,2541,2543,2915,2973,2993,2997,3010,3052,3079,3350,3371,3393) then CAST( '('+cast(Archive.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10))+')' else case when Archive.SlipOdd.SpecialBetValue is null or Archive.SlipOdd.SpecialBetValue='' then '' else '('+Archive.SlipOdd.SpecialBetValue+')' end end as OddsType, 
								  Archive.SlipOdd.OutCome AS Outcomes, Archive.SlipOdd.OddValue, Archive.SlipOdd.EventDate,
										 case when Archive.SlipOdd.StateId=4 then  [dbo].[FuncScore](Archive.SlipOdd.MatchId,0) else   '' end AS Result,case when Archive.SlipOdd.ParameterOddId IN (2247,2321,2325,2465,2541,2543,2915,2973,2993,2997,3010,3052,3079,3350,3371,3393) then CAST( cast(Archive.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10)) else ISNULL(Archive.SlipOdd.SpecialBetValue, '') end AS SpecialBetValue
										   ,Archive.SlipOdd.MatchId as BetradarMatchId,Archive.Code.Code as MatchCode ,Archive.SlipOdd.OddId,0 as BetType,Archive.SlipOdd.Banko,Language.[Parameter.OddsType].ShortOddType
			FROM         Parameter.SlipState with (nolock) INNER JOIN
								  Archive.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Archive.SlipOdd.StateId INNER JOIN
								  Language.[Parameter.OddsType] with (nolock) ON Archive.SlipOdd.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId INNER JOIN
								  Language.[Parameter.SlipState] with (nolock) ON Language.[Parameter.SlipState].[SlipStateId]=Parameter.SlipState.StateId LEFT OUTER JOIN Archive.Code ON Archive.Code.MatchId=Archive.SlipOdd.MatchId
			WHERE   Archive.SlipOdd.StateId=1 and  (Archive.SlipOdd.SlipId in (select Customer.SlipSystemSlip.SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=(select top 1 Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SlipId=@SlipId)) )  AND (Language.[Parameter.OddsType].LanguageId = @LangId) and Language.[Parameter.SlipState].LanguageId=@LangId AND (Archive.SlipOdd.BetTypeId = 0)
			UNION ALL
			SELECT  DISTINCT    case when  Parameter.SlipState.StateId=5 then 3 else Parameter.SlipState.StateId end as StateId, Language.[Parameter.SlipState].SlipState as State,
			Archive.SlipOdd.EventName
		--	cast(Archive.SlipOdd.MatchId as nvarchar(10))+' - '+ ISNULL((select Language.ParameterCompetitor.CompetitorName COLLATE SQL_Latin1_General_CP1_CI_AS from Live.Event
		--INNER JOIN Language.ParameterCompetitor ON Language.ParameterCompetitor.CompetitorId=Live.Event.HomeTeam and Live.Event.EventId=Archive.SlipOdd.MatchId and Language.ParameterCompetitor.LanguageId=@LangId),'')+''+ISNULL((select Language.ParameterCompetitor.CompetitorName COLLATE SQL_Latin1_General_CP1_CI_AS from Archive.[Live.Event]
		--INNER JOIN Language.ParameterCompetitor ON Language.ParameterCompetitor.CompetitorId=Archive.[Live.Event].HomeTeam and Archive.[Live.Event].EventId=Archive.SlipOdd.MatchId and Language.ParameterCompetitor.LanguageId=@LangId),'')+'-'+ISNULL((select Language.ParameterCompetitor.CompetitorName COLLATE SQL_Latin1_General_CP1_CI_AS from Live.Event
		--INNER JOIN Language.ParameterCompetitor ON Language.ParameterCompetitor.CompetitorId=Live.Event.AwayTeam and Live.Event.EventId=Archive.SlipOdd.MatchId and Language.ParameterCompetitor.LanguageId=@LangId),'')+''+ISNULL((select Language.ParameterCompetitor.CompetitorName COLLATE SQL_Latin1_General_CP1_CI_AS from Archive.[Live.Event]
		--INNER JOIN Language.ParameterCompetitor ON Language.ParameterCompetitor.CompetitorId=Archive.[Live.Event].AwayTeam and Archive.[Live.Event].EventId=Archive.SlipOdd.MatchId and Language.ParameterCompetitor.LanguageId=@LangId),'')
		,Language.[Parameter.LiveOddType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI +' ' +case when Archive.SlipOdd.ParameterOddId IN (1578,1544,1540,1648,1646,1644,1642,2247,2321,2325,2465,2541,2543,2915,2973,2993,2997,3010,3052,3079,3350,3371,3393) then CAST( '('+cast(Archive.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10))+')' else case when Archive.SlipOdd.SpecialBetValue is null or Archive.SlipOdd.SpecialBetValue='' or Archive.SlipOdd.SpecialBetValue='-1' then '' else '('+Archive.SlipOdd.SpecialBetValue+')' end end AS OddsType, 
				   --             case when (select COUNT(OutCome) from Live.EventOdd where Live.EventOdd.MatchId=Archive.SlipOdd.MatchId and Live.EventOdd.OddsTypeId=Archive.SlipOdd.OddsTypeId and Live.EventOdd.OddResult=1 and ISNULL(Live.EventOdd.SpecialBetValue,'')= case when  Archive.SlipOdd.SpecialBetValue is not null then  Archive.SlipOdd.SpecialBetValue else '' end )>0 then  Archive.SlipOdd.OutCome 
							   --else case when (select COUNT(OutCome) from Archive.[Live.EventOdd] where Archive.[Live.EventOdd].MatchId=Archive.SlipOdd.MatchId and Archive.[Live.EventOdd].OddsTypeId=Archive.SlipOdd.OddsTypeId and Archive.[Live.EventOdd].OddResult=1 and Archive.[Live.EventOdd].SpecialBetValue=Archive.SlipOdd.SpecialBetValue)>0  then  Archive.SlipOdd.OutCome else  Archive.SlipOdd.OutCome end end 
								Archive.SlipOdd.OutCome AS Outcomes
							   , Archive.SlipOdd.OddValue, Archive.SlipOdd.EventDate,
				   [dbo].[FuncScore](Archive.SlipOdd.MatchId,1) AS Result
							   ,case when Archive.SlipOdd.ParameterOddId in (108,112,116,129,137,143,149,192,387,389,426,428,1947,2059,2503,2505,2553,2965) 
			  then CAST( cast(Archive.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10))
			  else case when Archive.SlipOdd.SpecialBetValue<>'-1' then  ISNULL(Archive.SlipOdd.SpecialBetValue,'') else '' end end as SpecialBetValue
			  ,Archive.SlipOdd.MatchId as BetradarMatchId,Archive.Code.Code as MatchCode ,Archive.SlipOdd.OddId,1 as BetType,Archive.SlipOdd.Banko,Language.[Parameter.LiveOddType].ShortOddType
			FROM         Parameter.SlipState with (nolock) INNER JOIN
								  Archive.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Archive.SlipOdd.StateId INNER JOIN
								  Live.[Parameter.OddType] with (nolock) ON Archive.SlipOdd.OddsTypeId = Live.[Parameter.OddType].OddTypeId INNER JOIN
								  Language.[Parameter.LiveOddType] with (nolock) ON Live.[Parameter.OddType].OddTypeId= Language.[Parameter.LiveOddType].OddTypeId INNER JOIN
								  Language.[Parameter.SlipState] with (nolock) ON Language.[Parameter.SlipState].[SlipStateId]=Parameter.SlipState.StateId LEFT OUTER JOIN Archive.Code ON Archive.Code.MatchId=Archive.SlipOdd.MatchId
			WHERE  Archive.SlipOdd.StateId=1 and     (Archive.SlipOdd.SlipId in (select Customer.SlipSystemSlip.SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=(select top 1 Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SlipId=@SlipId)) )  and Archive.SlipOdd.BetTypeId=1 and  Language.[Parameter.LiveOddType].LanguageId=@LangId and Language.[Parameter.SlipState].LanguageId=@LangId
			--UNION ALL
			--SELECT  DISTINCT    Parameter.SlipState.StateId, Language.[Parameter.SlipState].SlipState as State,cast(Archive.SlipOdd.MatchId as nvarchar(10))+' - '+ Archive.SlipOdd.EventName, '' AS OddsType, Archive.SlipOdd.OutCome AS Outcomes, 
			--					  Archive.SlipOdd.OddValue, Archive.SlipOdd.EventDate, '' AS Result, 
			--					  Archive.SlipOdd.SpecialBetValue,Archive.SlipOdd.MatchId  as BetradarMatchId,Archive.Code.Code as MatchCode ,Archive.SlipOdd.OddId,2 as BetType,Archive.SlipOdd.Banko,'' as ShortOddType
			--FROM         Parameter.SlipState INNER JOIN
			--					  Archive.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Archive.SlipOdd.StateId INNER JOIN
			--					  Language.[Parameter.SlipState] ON Language.[Parameter.SlipState].[SlipStateId]=Parameter.SlipState.StateId LEFT OUTER JOIN Archive.Code ON Archive.Code.MatchId=Archive.SlipOdd.MatchId
			--WHERE   Archive.SlipOdd.StateId=1 and   (Archive.SlipOdd.SlipId in (select Customer.SlipSystemSlip.SlipId from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SystemSlipId=(select top 1 Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SlipId=@SlipId)) )  AND (Archive.SlipOdd.BetTypeId = 2) and Language.[Parameter.SlipState].LanguageId=@LangId
			



		end
	end

END




GO
