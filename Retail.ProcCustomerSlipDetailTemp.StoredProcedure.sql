USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcCustomerSlipDetailTemp]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 

CREATE PROCEDURE [Retail].[ProcCustomerSlipDetailTemp] 
@SlipId bigint,
@LangId int,
@Username nvarchar(50)
AS

BEGIN
SET NOCOUNT ON;


declare @temptable table (StateId int,State nvarchar(50),EventName nvarchar(150),OddsType nvarchar(250),Outcomes nvarchar(250),OddValue float,EventDate datetime,Result nvarchar(30),SpecialBetValue nvarchar(250),BetradarMatchId bigint,MatchCode nvarchar(50),OddId bigint,BetType int,Banko int,ShortOddType nvarchar(250) COLLATE SQL_Latin1_General_CP1253_CI_AI ,TimeStatu nvarchar(150),Score nvarchar(150))

if exists (select Customer.SlipOddTemp.SlipId from Customer.SlipOddTemp with (nolock) where Customer.SlipOddTemp.SlipId=@SlipId)
	begin

	if exists(select  Customer.SlipTemp.SlipId from Customer.SlipTemp with (nolock) where Customer.SlipTemp.SlipTypeId<3 and Customer.SlipTemp.SlipId=@SlipId)
	begin

	insert @temptable
		SELECT    Language.[Parameter.SlipState].SlipStateId as StateId, Language.[Parameter.SlipState].SlipState as State
		
		,cast(Customer.SlipOddTemp.MatchId as nvarchar(10))+' -'+Customer.SlipOddTemp.EventName as EventName
		, Language.[Parameter.OddsType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI+' ' +case when Customer.SlipOddTemp.ParameterOddId IN (1578,1544,1540,1648,1646,1644,1642,2247,2321,2325,2465,2541,2543,2915,2973,2993,2997,3010,3052,3079,3350,3371,3393) then CAST( cast(Customer.SlipOddTemp.SpecialBetValue AS float)*-1 AS nvarchar(10)) else case when Customer.SlipOddTemp.SpecialBetValue is null or Customer.SlipOddTemp.SpecialBetValue='' or Customer.SlipOddTemp.SpecialBetValue='-1' then '' else '('+Customer.SlipOddTemp.SpecialBetValue+')' end end  as OddsType, 
							  Customer.SlipOddTemp.OutCome AS Outcomes, Customer.SlipOddTemp.OddValue,  Customer.SlipOddTemp.EventDate  as EventDate,
									  [dbo].[FuncScore2](Customer.SlipOddTemp.BetradarMatchId,0)  AS Result
									  ,case when Customer.SlipOddTemp.ParameterOddId IN (1578,1544,1540,1648,1646,1644,1642,2247,2321,2325,2465,2541,2543,2915,2973,2993,2997,3010,3052,3079,3350,3371,3393) 
									  then CAST( cast(Customer.SlipOddTemp.SpecialBetValue AS float)*-1 AS nvarchar(10)) else ISNULL(Customer.SlipOddTemp.SpecialBetValue, '') end as SpecialBetValue,
									  Customer.SlipOddTemp.BetradarMatchId
									  ,case when (select Count(*) from Match.Code with (nolock) where BetradarMatchId=Customer.SlipOddTemp.BetradarMatchId)>0
									   then (select top 1 Code from Match.Code with (nolock) where BetradarMatchId=Customer.SlipOddTemp.BetradarMatchId ) 
									   else  (select top 1 Code from Archive.Code with (nolock) where BetradarMatchId=Customer.SlipOddTemp.BetradarMatchId ) end as MatchCode,
									  Customer.SlipOddTemp.OddId,0 as BetType,Customer.SlipOddTemp.Banko,Language.[Parameter.OddsType].ShortOddType COLLATE SQL_Latin1_General_CP1253_CI_AI as ShortOddType,Customer.SlipOddTemp.ScoreTimeStatu,'' as Score
		FROM        Customer.SlipOddTemp with (nolock)  INNER JOIN
							  Language.[Parameter.OddsType] with (nolock) ON Customer.SlipOddTemp.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId INNER JOIN
							  Language.[Parameter.Odds] with (nolock) ON Language.[Parameter.Odds].OddsId=Customer.SlipOddTemp.ParameterOddId INNER JOIN
							  Language.[Parameter.SlipState] with (nolock) ON Language.[Parameter.SlipState].SlipStateId=Customer.SlipOddTemp.StateId and Language.[Parameter.SlipState].LanguageId=@LangId
		WHERE     (Customer.SlipOddTemp.SlipId = @SlipId) AND (Language.[Parameter.OddsType].LanguageId = @LangId) AND (Customer.SlipOddTemp.BetTypeId = 0) and Language.[Parameter.Odds].LanguageId=@LangId
		
		insert @temptable
		SELECT    Language.[Parameter.SlipState].SlipStateId as StateId
		, Language.[Parameter.SlipState].SlipState as State
		,cast(Customer.SlipOddTemp.MatchId as nvarchar(10))+' -'+Customer.SlipOddTemp.EventName as EventName
		,case when Customer.SlipOddTemp.SpecialBetValue<>'-1' 
		then  Language.[Parameter.LiveOddType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI+' '+ case when Customer.SlipOddTemp.ParameterOddId in (108,112,116,129,137,143,149,192,387,389,426,428,1947,2059,2503,2505,2553,2965,3257) 
		  then CAST( cast(Customer.SlipOddTemp.SpecialBetValue AS float)*-1 AS nvarchar(10))
		  else case when Customer.SlipOddTemp.SpecialBetValue<>'-1' then  ISNULL(Customer.SlipOddTemp.SpecialBetValue,'') else '' end end
		else Language.[Parameter.LiveOddType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI end + ' ('+Customer.SlipOddTemp.Score+')' AS OddsType, 
		 --case when (select COUNT(OutCome) from Live.EventOdd where Live.EventOdd.MatchId=Customer.SlipOdd.MatchId and Live.EventOdd.OddsTypeId=Customer.SlipOdd.OddsTypeId and Live.EventOdd.OddResult=1 and ISNULL(Live.EventOdd.SpecialBetValue,'')= case when  Customer.SlipOdd.SpecialBetValue is not null then  Customer.SlipOdd.SpecialBetValue else '' end )>0 then  Customer.SlipOdd.OutCome +' ( '+ISNULL((select top 1 OutCome from Live.EventOdd where Live.EventOdd.MatchId=Customer.SlipOdd.MatchId and Live.EventOdd.OddsTypeId=Customer.SlipOdd.OddsTypeId and Live.EventOdd.OddResult=1 and ISNULL(Live.EventOdd.SpecialBetValue,'')= case when  Customer.SlipOdd.SpecialBetValue is not null then  Customer.SlipOdd.SpecialBetValue else '' end ),'')+' )' 
			--			   else case when (select COUNT(OutCome) from Archive.[Live.EventOdd] where Archive.[Live.EventOdd].MatchId=Customer.SlipOdd.MatchId and Archive.[Live.EventOdd].OddsTypeId=Customer.SlipOdd.OddsTypeId and Archive.[Live.EventOdd].OddResult=1 and Archive.[Live.EventOdd].SpecialBetValue=Customer.SlipOdd.SpecialBetValue)>0  then  Language.[Parameter.LiveOdds].OutComes +' ( '+ISNULL((select top 1 OutCome from Archive.[Live.EventOdd] where Archive.[Live.EventOdd].MatchId=Customer.SlipOdd.MatchId and Archive.[Live.EventOdd].OddsTypeId=Customer.SlipOdd.OddsTypeId and Archive.[Live.EventOdd].OddResult=1 and ISNULL(Archive.[Live.EventOdd].SpecialBetValue,'')= case when  Customer.SlipOdd.SpecialBetValue is not null then  Customer.SlipOdd.SpecialBetValue else '' end),'')+' )' else Language.[Parameter.LiveOdds].OutComes end end 
							case when Language.[Parameter.LiveOdds].OutComes like '%none%' then Customer.SlipOddTemp.OutCome else Language.[Parameter.LiveOdds].OutComes end AS Outcomes
						   ,Customer.SlipOddTemp.OddValue,  Customer.SlipOddTemp.EventDate  as EventDate, 
						   --'Live Score -'+ISNULL((select Score from Live.EventDetail where Live.EventDetail.EventId=Customer.SlipOdd.MatchId),'') 
						   [dbo].[FuncScore2](Customer.SlipOddTemp.BetradarMatchId,1) AS Result
						   , case when Customer.SlipOddTemp.SpecialBetValue<>'-1' then  case when Customer.SlipOddTemp.ParameterOddId in (108,112,116,129,137,143,149,192,387,389,426,428,1947,2059,2503,2505,2553,2965) 
		  then CAST( cast(Customer.SlipOddTemp.SpecialBetValue AS float)*-1 AS nvarchar(10))
		  else case when Customer.SlipOddTemp.SpecialBetValue<>'-1' then  ISNULL(Customer.SlipOddTemp.SpecialBetValue,'') else '' end end else '' end   as SpecialBetValue,
		  Customer.SlipOddTemp.BetradarMatchId
									  ,case when (select Count(*) from Match.Code with (nolock) where MatchId=Customer.SlipOddTemp.MatchId and BetTypeId=1)>0 then (select top 1 Code from Match.Code with (nolock) where MatchId=Customer.SlipOddTemp.MatchId and BetTypeId=1) else  (select top 1 Code from Archive.Code with (nolock) where MatchId=Customer.SlipOddTemp.MatchId and BetTypeId=1) end as MatchCode
									  ,Customer.SlipOddTemp.OddId,1 as BetType,Customer.SlipOddTemp.Banko,Language.[Parameter.LiveOddType].ShortOddType COLLATE SQL_Latin1_General_CP1253_CI_AI as ShortOddType,Customer.SlipOddTemp.ScoreTimeStatu,' ('+RTRIM(Customer.SlipOddTemp.Score)+')' as Score
		FROM        Customer.SlipOddTemp with (nolock) INNER JOIN
							  Language.[Parameter.LiveOddType] with (nolock) ON Language.[Parameter.LiveOddType].OddTypeId=Customer.SlipOddTemp.OddsTypeId and Language.[Parameter.LiveOddType].LanguageId=@LangId INNER JOIN
							  Language.[Parameter.LiveOdds] with (nolock) ON Language.[Parameter.LiveOdds].OddsId=Customer.SlipOddTemp.ParameterOddId and Language.[Parameter.LiveOdds].LanguageId=@LangId  INNER JOIN
							   Language.[Parameter.SlipState] with (nolock) ON Language.[Parameter.SlipState].SlipStateId=Customer.SlipOddTemp.StateId and Language.[Parameter.SlipState].LanguageId=@LangId
		WHERE     (Customer.SlipOddTemp.SlipId = @SlipId) and Customer.SlipOddTemp.BetTypeId=1  
		UNION ALL
		SELECT      Parameter.SlipState.StateId, Parameter.SlipState.State, cast(Customer.SlipOddTemp.MatchId as nvarchar(10))+' -'+Customer.SlipOddTemp.EventName as EventName, Language.[Parameter.OddsType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI as OddsType, Customer.SlipOddTemp.OutCome AS Outcomes, 
							  Customer.SlipOddTemp.OddValue,  Customer.SlipOddTemp.EventDate  as EventDate, '-' AS Result, 
							  Customer.SlipOddTemp.SpecialBetValue, Customer.SlipOddTemp.BetradarMatchId,Match.Code.Code as MatchCode,Customer.SlipOddTemp.OddId,2 as BetType,Customer.SlipOddTemp.Banko,'' as ShortOddType,'',''
		FROM         Parameter.SlipState with (nolock) INNER JOIN 
							  Customer.SlipOddTemp with (nolock) ON Parameter.SlipState.StateId = Customer.SlipOddTemp.StateId LEFT OUTER JOIN Match.Code with (nolock) ON Match.Code.MatchId=Customer.SlipOddTemp.MatchId and Match.Code.BetTypeId=2
							  INNER JOIN Language.[Parameter.OddsType] ON Customer.SlipOddTemp.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId and Language.[Parameter.OddsType].LanguageId=@LangId
		WHERE     (Customer.SlipOddTemp.SlipId = @SlipId) AND (Customer.SlipOddTemp.BetTypeId = 2)
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

			insert @temptable
			SELECT DISTINCT   case when  Language.[Parameter.SlipState].SlipStateId=5 then 3 else Language.[Parameter.SlipState].SlipStateId end as StateId 
			,Language.[Parameter.SlipState].SlipState as State
		
		,cast(Customer.SlipOddTemp.MatchId as nvarchar(10))+' -'+Customer.SlipOddTemp.EventName as EventName
		, Language.[Parameter.OddsType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI +' ' +case when Customer.SlipOddTemp.ParameterOddId IN (1578,1544,1540,1648,1646,1644,1642,2247,2321,2325,2465,2541,2543,2915,2973,2993,2997,3010,3052,3079,3350,3371,3393) then CAST( cast(Customer.SlipOddTemp.SpecialBetValue AS float)*-1 AS nvarchar(10)) else case when Customer.SlipOddTemp.SpecialBetValue is null or Customer.SlipOddTemp.SpecialBetValue='' or Customer.SlipOddTemp.SpecialBetValue='-1' then '' else '('+Customer.SlipOddTemp.SpecialBetValue+')' end end + ' ('+Customer.SlipOddTemp.Score+')'  as OddsType, 
						  Customer.SlipOddTemp.OutCome AS Outcomes, Customer.SlipOddTemp.OddValue, Customer.SlipOddTemp.EventDate,
								' -'  AS Result,case when Customer.SlipOddTemp.ParameterOddId IN (1578,1544,1540,1648,1646,1644,1642,2247,2321,2325,2465,2541,2543,2915,2973,2993,2997,3010,3052,3079,3350,3371,3393) then CAST( cast(Customer.SlipOddTemp.SpecialBetValue AS float)*-1 AS nvarchar(10)) else ISNULL(Customer.SlipOddTemp.SpecialBetValue, '') end AS SpecialBetValue
								   ,Customer.SlipOddTemp.BetradarMatchId
								   ,case when (select Count(*) from Match.Code where MatchId=Customer.SlipOddTemp.MatchId and BetTypeId=0)>0 
								   then (select top 1 Code from Match.Code where MatchId=Customer.SlipOddTemp.MatchId and BetTypeId=0) 
								   else  (select top 1 Code from Archive.Code where MatchId=Customer.SlipOddTemp.MatchId and BetTypeId=0) end 
								   --(select top 1 Code from Match.Code where BetradarMatchId=Customer.SlipOdd.BetradarMatchId) 
								   as MatchCode
								   ,Customer.SlipOddTemp.OddId,0 as BetType,Customer.SlipOddTemp.Banko
								   ,Language.[Parameter.OddsType].ShortOddType COLLATE SQL_Latin1_General_CP1253_CI_AI as ShortOddType,Customer.SlipOddTemp.ScoreTimeStatu,'' as Score
			FROM         
								  Customer.SlipOddTemp with (nolock)   INNER JOIN
								  Language.[Parameter.OddsType] with (nolock) ON Customer.SlipOddTemp.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId INNER JOIN
								  Language.[Parameter.SlipState] with (nolock) ON Language.[Parameter.SlipState].[SlipStateId]=Customer.SlipOddTemp.StateId 
			WHERE     (Customer.SlipOddTemp.SlipId in (select Customer.SlipSystemSlipTemp.SlipId from Customer.SlipSystemSlipTemp with (nolock) where Customer.SlipSystemSlipTemp.SystemSlipId=(select top 1 Customer.SlipSystemSlipTemp.SystemSlipId from Customer.SlipSystemSlipTemp with (nolock) where Customer.SlipSystemSlipTemp.SlipId=@SlipId)) ) AND (Language.[Parameter.OddsType].LanguageId = @LangId) and Language.[Parameter.SlipState].LanguageId=@LangId AND (Customer.SlipOddTemp.BetTypeId = 0)
		
			insert @temptable
			SELECT   DISTINCT  case when  Language.[Parameter.SlipState].[SlipStateId]=5 then 3 else Language.[Parameter.SlipState].[SlipStateId] end as StateId
			, Language.[Parameter.SlipState].SlipState as State
		,cast(Customer.SlipOddTemp.MatchId as nvarchar(10))+' -'+Customer.SlipOddTemp.EventName as EventName
		,Language.[Parameter.LiveOddType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI +' ' +case when Customer.SlipOddTemp.ParameterOddId IN (1578,1544,1540,1648,1646,1644,1642,2247,2321,2325,2465,2541,2543,2915,2973,2993,2997,3010,3052,3079,3350,3371,3393) then CAST( '('+cast(Customer.SlipOddTemp.SpecialBetValue AS float)*-1 AS nvarchar(10))+')' else case when Customer.SlipOddTemp.SpecialBetValue is null or Customer.SlipOddTemp.SpecialBetValue='' or Customer.SlipOddTemp.SpecialBetValue='-1' then '' else '('+Customer.SlipOddTemp.SpecialBetValue+')' end end + ' ('+Customer.SlipOddTemp.Score+')' AS OddsType, 
								Customer.SlipOddTemp.OutCome AS Outcomes
							   , Customer.SlipOddTemp.OddValue, Customer.SlipOddTemp.EventDate,
				 ' -' AS Result
							   ,case when Customer.SlipOddTemp.ParameterOddId in (108,112,116,129,137,143,149,192,387,389,426,428,1947,2059,2503,2505,2553,2965,3257) 
			  then CAST( cast(Customer.SlipOddTemp.SpecialBetValue AS float)*-1 AS nvarchar(10))
			  else case when Customer.SlipOddTemp.SpecialBetValue<>'-1' then  ISNULL(Customer.SlipOddTemp.SpecialBetValue,'') else '' end end  as SpecialBetValue
			  ,Customer.SlipOddTemp.BetradarMatchId
			     ,case when (select Count(*) from Match.Code where MatchId=Customer.SlipOddTemp.MatchId and BetTypeId=1)>0 
								   then (select top 1 Code from Match.Code where MatchId=Customer.SlipOddTemp.MatchId and BetTypeId=1) 
								   else  (select top 1 Code from Archive.Code where MatchId=Customer.SlipOddTemp.MatchId and BetTypeId=1) end 
								   as MatchCode
			  ,Customer.SlipOddTemp.OddId,1 as BetType,Customer.SlipOddTemp.Banko,Language.[Parameter.LiveOddType].ShortOddType COLLATE SQL_Latin1_General_CP1253_CI_AI as ShortOddType,Customer.SlipOddTemp.ScoreTimeStatu,' ('+RTRIM(Customer.SlipOddTemp.Score)+')' as Score
			FROM         
								  Customer.SlipOddTemp with (nolock)   INNER JOIN
								  Live.[Parameter.OddType] with (nolock) ON Customer.SlipOddTemp.OddsTypeId = Live.[Parameter.OddType].OddTypeId INNER JOIN
								  Language.[Parameter.LiveOddType] with (nolock) ON Live.[Parameter.OddType].OddTypeId= Language.[Parameter.LiveOddType].OddTypeId INNER JOIN
								  Language.[Parameter.SlipState] with (nolock) ON Language.[Parameter.SlipState].[SlipStateId]=Customer.SlipOddTemp.StateId --LEFT OUTER JOIN Match.Code ON Match.Code.MatchId=Customer.SlipOdd.MatchId
			WHERE     (Customer.SlipOddTemp.SlipId in (select Customer.SlipSystemSlipTemp.SlipId from Customer.SlipSystemSlipTemp with (nolock) where Customer.SlipSystemSlipTemp.SystemSlipId=(select top 1 Customer.SlipSystemSlipTemp.SystemSlipId from Customer.SlipSystemSlipTemp with (nolock) where Customer.SlipSystemSlipTemp.SlipId=@SlipId)) ) and Customer.SlipOddTemp.BetTypeId=1 and  Language.[Parameter.LiveOddType].LanguageId=@LangId and Language.[Parameter.SlipState].LanguageId=@LangId
			UNION ALL
			SELECT   DISTINCT   Parameter.SlipState.StateId, Language.[Parameter.SlipState].SlipState as State,cast(Customer.SlipOddTemp.MatchId as nvarchar(10))+' -'+ Customer.SlipOddTemp.EventName,  Language.[Parameter.OddsType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI as OddsType, Customer.SlipOddTemp.OutCome AS Outcomes, 
								  Customer.SlipOddTemp.OddValue, Customer.SlipOddTemp.EventDate, '-' AS Result, 
								  Customer.SlipOddTemp.SpecialBetValue,Customer.SlipOddTemp.BetradarMatchId,Match.Code.Code as MatchCode ,Customer.SlipOddTemp.OddId,2 as BetType,Customer.SlipOddTemp.Banko,'' as ShortOddType,Customer.SlipOddTemp.ScoreTimeStatu,' ('+RTRIM(Customer.SlipOddTemp.Score)+')' as Score
			FROM         Parameter.SlipState INNER JOIN
								  Customer.SlipOddTemp with (nolock) ON Parameter.SlipState.StateId = Customer.SlipOddTemp.StateId
								  INNER JOIN
								  Language.[Parameter.OddsType] ON Customer.SlipOddTemp.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId  and Language.[Parameter.OddsType].LanguageId=@LangId INNER JOIN
								  Language.[Parameter.SlipState] ON Language.[Parameter.SlipState].[SlipStateId]=Parameter.SlipState.StateId LEFT OUTER JOIN Match.Code ON Match.Code.MatchId=Customer.SlipOddTemp.MatchId
			WHERE     (Customer.SlipOddTemp.SlipId in (select Customer.SlipSystemSlipTemp.SlipId from Customer.SlipSystemSlipTemp with (nolock) where Customer.SlipSystemSlipTemp.SystemSlipId=(select top 1 Customer.SlipSystemSlipTemp.SystemSlipId from Customer.SlipSystemSlipTemp with (nolock) where Customer.SlipSystemSlipTemp.SlipId=@SlipId)) ) AND (Customer.SlipOddTemp.BetTypeId = 2) and Language.[Parameter.SlipState].LanguageId=@LangId
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
 

	select * from @temptable order by EventDate

END




GO
