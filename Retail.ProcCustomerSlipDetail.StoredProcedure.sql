USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcCustomerSlipDetail]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [Retail].[ProcCustomerSlipDetail] 
@SlipId bigint,
@LangId int,
@Username nvarchar(50)
AS

BEGIN
SET NOCOUNT ON;


declare @temptable table (StateId int,State nvarchar(50),EventName nvarchar(150),OddsType nvarchar(250),Outcomes nvarchar(250),OddValue float,EventDate datetime,Result nvarchar(30),SpecialBetValue nvarchar(250),BetradarMatchId bigint,MatchCode nvarchar(50),OddId bigint,BetType int,Banko int,ShortOddType nvarchar(250) COLLATE SQL_Latin1_General_CP1253_CI_AI ,TimeStatu nvarchar(150),Score nvarchar(150))

if exists (select Customer.SlipOdd.SlipId from Customer.SlipOdd with (nolock) where Customer.SlipOdd.SlipId=@SlipId)
	begin

	if exists(select  Customer.Slip.SlipId from Customer.Slip with (nolock) where Customer.Slip.SlipTypeId<3 and Customer.Slip.SlipId=@SlipId)
	begin

	insert @temptable
		SELECT   DISTINCT  Language.[Parameter.SlipState].SlipStateId as StateId, Language.[Parameter.SlipState].SlipState as State
		
		,cast(Customer.SlipOdd.MatchId as nvarchar(10))+' -'+Customer.SlipOdd.EventName as EventName
		, Language.[Parameter.OddsType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI+' ' +case when Customer.SlipOdd.ParameterOddId IN (1578,1544,1540,1648,1646,1644,1642,2247,2321,2325,2465,2541,2543,2915,2973,2993,2997,3010,3052,3079,3350,3371,3393) then CAST( cast(Customer.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10)) else case when Customer.SlipOdd.SpecialBetValue is null or Customer.SlipOdd.SpecialBetValue='' or Customer.SlipOdd.SpecialBetValue='-1' then '' else '('+Customer.SlipOdd.SpecialBetValue+')' end end  as OddsType, 
							  Customer.SlipOdd.OutCome AS Outcomes, Customer.SlipOdd.OddValue,  Customer.SlipOdd.EventDate  as EventDate,
									  [dbo].[FuncScore2](Customer.SlipOdd.BetradarMatchId,0)  AS Result
									  ,case when Customer.SlipOdd.ParameterOddId IN (1578,1544,1540,1648,1646,1644,1642,2247,2321,2325,2465,2541,2543,2915,2973,2993,2997,3010,3052,3079,3350,3371,3393) 
									  then CAST( cast(Customer.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10)) else ISNULL(Customer.SlipOdd.SpecialBetValue, '') end as SpecialBetValue,
									  Customer.SlipOdd.BetradarMatchId
									  ,case when (select Count(*) from Match.Code with (nolock) where BetradarMatchId=Customer.SlipOdd.BetradarMatchId)>0
									   then (select top 1 Code from Match.Code with (nolock) where BetradarMatchId=Customer.SlipOdd.BetradarMatchId ) 
									   else  (select top 1 Code from Archive.Code with (nolock) where BetradarMatchId=Customer.SlipOdd.BetradarMatchId ) end as MatchCode,
									  Customer.SlipOdd.OddId,0 as BetType,Customer.SlipOdd.Banko,Language.[Parameter.OddsType].ShortOddType COLLATE SQL_Latin1_General_CP1253_CI_AI as ShortOddType,Customer.SlipOdd.ScoreTimeStatu,'' as Score
		FROM        Customer.SlipOdd with (nolock)  INNER JOIN
							  Language.[Parameter.OddsType] with (nolock) ON Customer.SlipOdd.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId INNER JOIN
							  Language.[Parameter.Odds] with (nolock) ON Language.[Parameter.Odds].OddsId=Customer.SlipOdd.ParameterOddId INNER JOIN
							  Language.[Parameter.SlipState] with (nolock) ON Language.[Parameter.SlipState].SlipStateId=Customer.SlipOdd.StateId and Language.[Parameter.SlipState].LanguageId=@LangId
		WHERE     (Customer.SlipOdd.SlipId = @SlipId) AND (Language.[Parameter.OddsType].LanguageId = @LangId) AND (Customer.SlipOdd.BetTypeId = 0) and Language.[Parameter.Odds].LanguageId=@LangId
		
		insert @temptable
		SELECT   DISTINCT  Language.[Parameter.SlipState].SlipStateId as StateId
		, Language.[Parameter.SlipState].SlipState as State
		,REPLACE(cast(Customer.SlipOdd.MatchId as nvarchar(10)),'-','')+' -'+Customer.SlipOdd.EventName as EventName
		,case when Customer.SlipOdd.SpecialBetValue<>'-1' 
		then  Language.[Parameter.LiveOddType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI+' '+ case when Customer.SlipOdd.ParameterOddId in (108,112,116,129,137,143,149,192,387,389,426,428,1947,2059,2503,2505,2553,2965,3257) 
		  then CAST( cast(Customer.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10))
		  else case when Customer.SlipOdd.SpecialBetValue<>'-1' then  ISNULL(Customer.SlipOdd.SpecialBetValue,'') else '' end end
		else Language.[Parameter.LiveOddType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI end + ' ('+Customer.SlipOdd.Score+')' AS OddsType, 
							case when Language.[Parameter.LiveOdds].OutComes like '%none%' then Customer.SlipOdd.OutCome else Language.[Parameter.LiveOdds].OutComes end AS Outcomes
						   ,Customer.SlipOdd.OddValue,  Customer.SlipOdd.EventDate  as EventDate, 
						   [dbo].[FuncScore2](Customer.SlipOdd.BetradarMatchId,1) AS Result
						   , case when Customer.SlipOdd.SpecialBetValue<>'-1' then  case when Customer.SlipOdd.ParameterOddId in (108,112,116,129,137,143,149,192,387,389,426,428,1947,2059,2503,2505,2553,2965) 
		  then CAST( cast(Customer.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10))
		  else case when Customer.SlipOdd.SpecialBetValue<>'-1' then  ISNULL(Customer.SlipOdd.SpecialBetValue,'') else '' end end else '' end   as SpecialBetValue,
		  Customer.SlipOdd.BetradarMatchId
									   ,case when (select Count(*) from Match.Code with (nolock) where BetradarMatchId=Customer.SlipOdd.BetradarMatchId)>0
									   then (select top 1 Code from Match.Code with (nolock) where BetradarMatchId=Customer.SlipOdd.BetradarMatchId ) 
									   else  (select top 1 Code from Archive.Code with (nolock) where BetradarMatchId=Customer.SlipOdd.BetradarMatchId )  end as MatchCode
									  ,Customer.SlipOdd.OddId,1 as BetType,Customer.SlipOdd.Banko,Language.[Parameter.LiveOddType].ShortOddType COLLATE SQL_Latin1_General_CP1253_CI_AI as ShortOddType,Customer.SlipOdd.ScoreTimeStatu,' ('+RTRIM(Customer.SlipOdd.Score)+')' as Score
		FROM        Customer.SlipOdd with (nolock) INNER JOIN
							  Language.[Parameter.LiveOddType] with (nolock) ON Language.[Parameter.LiveOddType].OddTypeId=Customer.SlipOdd.OddsTypeId and Language.[Parameter.LiveOddType].LanguageId=@LangId INNER JOIN
							  Language.[Parameter.LiveOdds] with (nolock) ON Language.[Parameter.LiveOdds].OddsId=Customer.SlipOdd.ParameterOddId and Language.[Parameter.LiveOdds].LanguageId=@LangId  INNER JOIN
							   Language.[Parameter.SlipState] with (nolock) ON Language.[Parameter.SlipState].SlipStateId=Customer.SlipOdd.StateId and Language.[Parameter.SlipState].LanguageId=@LangId
		WHERE     (Customer.SlipOdd.SlipId = @SlipId) and Customer.SlipOdd.BetTypeId=1  
 
 insert @temptable
				SELECT   DISTINCT    Parameter.SlipState.StateId, Parameter.SlipState.State,cast(Customer.SlipOdd.MatchId as nvarchar(10))+' -'+ Customer.SlipOdd.EventName,  Customer.SlipOdd.EventName as OddsType, Customer.SlipOdd.OutCome AS Outcomes, 
							  Customer.SlipOdd.OddValue, Customer.SlipOdd.EventDate as EventDate, '-' AS Result, 
							  '' as SpecialBetValue,Customer.SlipOdd.BetradarMatchId 
							  ,case when (select Count(*) from Match.Code with (nolock) where BetradarMatchId=Customer.SlipOdd.BetradarMatchId)>0
									   then (select top 1 Code from Match.Code with (nolock) where BetradarMatchId=Customer.SlipOdd.BetradarMatchId ) 
									   else  (select top 1 Code from Archive.Code with (nolock) where BetradarMatchId=Customer.SlipOdd.BetradarMatchId )  end as MatchCode
									    ,Customer.SlipOdd.OddId,2 as BetType,Customer.SlipOdd.Banko ,Customer.SlipOdd.EventName,'' as ScoreTimeStatu,'' as Score
		FROM         Parameter.SlipState with (nolock) INNER JOIN
							  Customer.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Customer.SlipOdd.StateId 
							   
		WHERE     (Customer.SlipOdd.SlipId = @SlipId) AND (Customer.SlipOdd.BetTypeId = 2)
		end
		else
		begin

			insert @temptable
			SELECT DISTINCT   case when  Language.[Parameter.SlipState].SlipStateId=5 then 3 else Language.[Parameter.SlipState].SlipStateId end as StateId 
			,Language.[Parameter.SlipState].SlipState as State
		
		,cast(Customer.SlipOdd.MatchId as nvarchar(10))+' -'+Customer.SlipOdd.EventName as EventName
		, Language.[Parameter.OddsType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI +' ' +case when Customer.SlipOdd.ParameterOddId IN (1578,1544,1540,1648,1646,1644,1642,2247,2321,2325,2465,2541,2543,2915,2973,2993,2997,3010,3052,3079,3350,3371,3393) then CAST( cast(Customer.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10)) else case when Customer.SlipOdd.SpecialBetValue is null or Customer.SlipOdd.SpecialBetValue='' or Customer.SlipOdd.SpecialBetValue='-1' then '' else '('+Customer.SlipOdd.SpecialBetValue+')' end end + ' ('+Customer.SlipOdd.Score+')'  as OddsType, 
						  Customer.SlipOdd.OutCome AS Outcomes, Customer.SlipOdd.OddValue, Customer.SlipOdd.EventDate,
								' -'  AS Result,case when Customer.SlipOdd.ParameterOddId IN (1578,1544,1540,1648,1646,1644,1642,2247,2321,2325,2465,2541,2543,2915,2973,2993,2997,3010,3052,3079,3350,3371,3393) then CAST( cast(Customer.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10)) else ISNULL(Customer.SlipOdd.SpecialBetValue, '') end AS SpecialBetValue
								   ,Customer.SlipOdd.BetradarMatchId
								    ,case when (select Count(*) from Match.Code with (nolock) where BetradarMatchId=Customer.SlipOdd.BetradarMatchId)>0
									   then (select top 1 Code from Match.Code with (nolock) where BetradarMatchId=Customer.SlipOdd.BetradarMatchId ) 
									   else  (select top 1 Code from Archive.Code with (nolock) where BetradarMatchId=Customer.SlipOdd.BetradarMatchId )  end 
								   --(select top 1 Code from Match.Code where BetradarMatchId=Customer.SlipOdd.BetradarMatchId) 
								   as MatchCode
								   ,Customer.SlipOdd.OddId,0 as BetType,Customer.SlipOdd.Banko
								   ,Language.[Parameter.OddsType].ShortOddType COLLATE SQL_Latin1_General_CP1253_CI_AI as ShortOddType,Customer.SlipOdd.ScoreTimeStatu,'' as Score
			FROM         
								  Customer.SlipOdd with (nolock)   INNER JOIN
								  Language.[Parameter.OddsType] with (nolock) ON Customer.SlipOdd.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId INNER JOIN
								  Language.[Parameter.SlipState] with (nolock) ON Language.[Parameter.SlipState].[SlipStateId]=Customer.SlipOdd.StateId 
			WHERE     (Customer.SlipOdd.SlipId in (select Customer.SlipSystemSlip.SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=(select top 1 Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SlipId=@SlipId)) ) AND (Language.[Parameter.OddsType].LanguageId = @LangId) and Language.[Parameter.SlipState].LanguageId=@LangId AND (Customer.SlipOdd.BetTypeId = 0)
		
			insert @temptable
			SELECT   DISTINCT  case when  Language.[Parameter.SlipState].[SlipStateId]=5 then 3 else Language.[Parameter.SlipState].[SlipStateId] end as StateId
			, Language.[Parameter.SlipState].SlipState as State
		,REPLACE(cast(Customer.SlipOdd.MatchId as nvarchar(10)),'-','')+' -'+Customer.SlipOdd.EventName as EventName
		,Language.[Parameter.LiveOddType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI +' ' +case when Customer.SlipOdd.ParameterOddId IN (1578,1544,1540,1648,1646,1644,1642,2247,2321,2325,2465,2541,2543,2915,2973,2993,2997,3010,3052,3079,3350,3371,3393) then CAST( '('+cast(Customer.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10))+')' else case when Customer.SlipOdd.SpecialBetValue is null or Customer.SlipOdd.SpecialBetValue='' or Customer.SlipOdd.SpecialBetValue='-1' then '' else '('+Customer.SlipOdd.SpecialBetValue+')' end end + ' ('+Customer.SlipOdd.Score+')' AS OddsType, 
								Customer.SlipOdd.OutCome AS Outcomes
							   , Customer.SlipOdd.OddValue, Customer.SlipOdd.EventDate,
				 ' -' AS Result
							   ,case when Customer.SlipOdd.ParameterOddId in (108,112,116,129,137,143,149,192,387,389,426,428,1947,2059,2503,2505,2553,2965,3257) 
			  then CAST( cast(Customer.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10))
			  else case when Customer.SlipOdd.SpecialBetValue<>'-1' then  ISNULL(Customer.SlipOdd.SpecialBetValue,'') else '' end end  as SpecialBetValue
			  ,Customer.SlipOdd.BetradarMatchId
			      ,case when (select Count(*) from Match.Code with (nolock) where BetradarMatchId=Customer.SlipOdd.BetradarMatchId)>0
									   then (select top 1 Code from Match.Code with (nolock) where BetradarMatchId=Customer.SlipOdd.BetradarMatchId ) 
									   else  (select top 1 Code from Archive.Code with (nolock) where BetradarMatchId=Customer.SlipOdd.BetradarMatchId )  end 
								   as MatchCode
			  ,Customer.SlipOdd.OddId,1 as BetType,Customer.SlipOdd.Banko,Language.[Parameter.LiveOddType].ShortOddType COLLATE SQL_Latin1_General_CP1253_CI_AI as ShortOddType,Customer.SlipOdd.ScoreTimeStatu,' ('+RTRIM(Customer.SlipOdd.Score)+')' as Score
			FROM         
								  Customer.SlipOdd with (nolock)   INNER JOIN
								  Live.[Parameter.OddType] with (nolock) ON Customer.SlipOdd.OddsTypeId = Live.[Parameter.OddType].OddTypeId INNER JOIN
								  Language.[Parameter.LiveOddType] with (nolock) ON Live.[Parameter.OddType].OddTypeId= Language.[Parameter.LiveOddType].OddTypeId INNER JOIN
								  Language.[Parameter.SlipState] with (nolock) ON Language.[Parameter.SlipState].[SlipStateId]=Customer.SlipOdd.StateId --LEFT OUTER JOIN Match.Code ON Match.Code.MatchId=Customer.SlipOdd.MatchId
			WHERE     (Customer.SlipOdd.SlipId in (select Customer.SlipSystemSlip.SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=(select top 1 Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SlipId=@SlipId)) ) and Customer.SlipOdd.BetTypeId=1 and  Language.[Parameter.LiveOddType].LanguageId=@LangId and Language.[Parameter.SlipState].LanguageId=@LangId
			UNION ALL
			SELECT   DISTINCT   Parameter.SlipState.StateId, Language.[Parameter.SlipState].SlipState as State,cast(Customer.SlipOdd.MatchId as nvarchar(10))+' -'+ Customer.SlipOdd.EventName,  Language.[Parameter.OddsType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI as OddsType, Customer.SlipOdd.OutCome AS Outcomes, 
								  Customer.SlipOdd.OddValue, Customer.SlipOdd.EventDate, '-' AS Result, 
								  Customer.SlipOdd.SpecialBetValue,Customer.SlipOdd.BetradarMatchId,Match.Code.Code as MatchCode ,Customer.SlipOdd.OddId,2 as BetType,Customer.SlipOdd.Banko,'' as ShortOddType,Customer.SlipOdd.ScoreTimeStatu,' ('+RTRIM(Customer.SlipOdd.Score)+')' as Score
			FROM         Parameter.SlipState INNER JOIN
								  Customer.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Customer.SlipOdd.StateId
								  INNER JOIN
								  Language.[Parameter.OddsType] ON Customer.SlipOdd.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId  and Language.[Parameter.OddsType].LanguageId=@LangId INNER JOIN
								  Language.[Parameter.SlipState] ON Language.[Parameter.SlipState].[SlipStateId]=Parameter.SlipState.StateId LEFT OUTER JOIN Match.Code ON Match.Code.MatchId=Customer.SlipOdd.MatchId
			WHERE     (Customer.SlipOdd.SlipId in (select Customer.SlipSystemSlip.SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=(select top 1 Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SlipId=@SlipId)) ) AND (Customer.SlipOdd.BetTypeId = 2) and Language.[Parameter.SlipState].LanguageId=@LangId
			
			 insert @temptable
				SELECT   DISTINCT    Parameter.SlipState.StateId, Parameter.SlipState.State, Customer.SlipOdd.EventName,  Customer.SlipOdd.EventName as OddsType, Customer.SlipOdd.OutCome AS Outcomes, 
							  Customer.SlipOdd.OddValue, dbo.UserTimeZoneDate(@Username,Customer.SlipOdd.EventDate,0) as EventDate, '-' AS Result, 
							  '' as SpecialBetValue,Customer.SlipOdd.BetradarMatchId 
							  ,case when (select Count(*) from Match.Code with (nolock) where BetradarMatchId=Customer.SlipOdd.BetradarMatchId)>0
									   then (select top 1 Code from Match.Code with (nolock) where BetradarMatchId=Customer.SlipOdd.BetradarMatchId ) 
									   else  (select top 1 Code from Archive.Code with (nolock) where BetradarMatchId=Customer.SlipOdd.BetradarMatchId )  end as MatchCode
									    ,Customer.SlipOdd.OddId,2 as BetType,Customer.SlipOdd.Banko ,Customer.SlipOdd.EventName,Customer.SlipOdd.ScoreTimeStatu,' ('+RTRIM(Customer.SlipOdd.Score)+')' as Score
		FROM         Parameter.SlipState with (nolock) INNER JOIN
							  Customer.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Customer.SlipOdd.StateId 
							   
		WHERE     (Customer.SlipOdd.SlipId = @SlipId) AND (Customer.SlipOdd.BetTypeId = 2)

		end
	end
else if exists (select Archive.SlipOdd.SlipId from Archive.SlipOdd with (nolock) where Archive.SlipOdd.SlipId=@SlipId)
	begin
	if exists(select Archive.Slip.SlipId from Archive.Slip with (nolock) where Archive.Slip.SlipTypeId<3 and Archive.Slip.SlipId=@SlipId)
	begin

 
		insert @temptable
		SELECT   DISTINCT  Language.[Parameter.SlipState].SlipStateId as StateId, Language.[Parameter.SlipState].SlipState as State
		,cast(Archive.SlipOdd.MatchId as nvarchar(10))+' -'+Archive.SlipOdd.EventName as EventName
		, Language.[Parameter.OddsType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI +' '+case when Archive.SlipOdd.ParameterOddId IN (2247,2321,2325,2465,2541,2543,2915,2973,2993,2997,3010,3052,3079,3350,3371,3393) then CAST( cast(Archive.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10)) else ISNULL(Archive.SlipOdd.SpecialBetValue, '') end  AS OddsType, 
							  Language.[Parameter.Odds].OutComes as Outcomes, Archive.SlipOdd.OddValue, Archive.SlipOdd.EventDate  as EventDate,
									   [dbo].[FuncScore](Archive.SlipOdd.MatchId,0)  AS Result,case when Archive.SlipOdd.ParameterOddId IN (2247,2321,2325,2465,2541,2543,2915,2973,2993,2997,3010,3052,3079,3350,3371,3393) then CAST( cast(Archive.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10)) 
									   else ISNULL(Archive.SlipOdd.SpecialBetValue, '') end  as SpecialBetValue,
									 Archive.SlipOdd.BetradarMatchId
									  ,case when (select Count(*) from Match.Code with (nolock) where BetradarMatchId=Archive.SlipOdd.BetradarMatchId)>0
									   then (select top 1 Code from Match.Code with (nolock) where BetradarMatchId=Archive.SlipOdd.BetradarMatchId ) 
									   else  (select top 1 Code from Archive.Code with (nolock) where BetradarMatchId=Archive.SlipOdd.BetradarMatchId ) end  as MatchCode
									  ,Archive.SlipOdd.OddId,0 as BetType,Archive.SlipOdd.Banko,Language.[Parameter.OddsType].ShortOddType COLLATE SQL_Latin1_General_CP1253_CI_AI as ShortOddType,Archive.SlipOdd.ScoreTimeStatu,'' as Score
		FROM          
							  Archive.SlipOdd with (nolock)   INNER JOIN
							  Language.[Parameter.OddsType] with (nolock) ON Archive.SlipOdd.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId INNER JOIN
							  Language.[Parameter.Odds] with (nolock) ON Language.[Parameter.Odds].OddsId=Archive.SlipOdd.ParameterOddId
							   --LEFT OUTER JOIN Archive.Code ON Archive.Code.MatchId=Archive.SlipOdd.MatchId and Archive.Code.BetTypeId=0 
							  INNER JOIN
							   Language.[Parameter.SlipState] with (nolock) ON Language.[Parameter.SlipState].SlipStateId=Archive.SlipOdd.StateId and Language.[Parameter.SlipState].LanguageId=@LangId
		WHERE     (Archive.SlipOdd.SlipId = @SlipId) AND (Language.[Parameter.OddsType].LanguageId = @LangId) AND (Archive.SlipOdd.BetTypeId = 0) and Language.[Parameter.Odds].LanguageId=@LangId
	 
	 	insert @temptable
		SELECT    DISTINCT  Language.[Parameter.SlipState].SlipStateId as StateId
		,  Language.[Parameter.SlipState].SlipState as State
		,cast(Archive.SlipOdd.MatchId as nvarchar(10))+' -'+Archive.SlipOdd.EventName as EventName
		,case when Archive.SlipOdd.SpecialBetValue<>'-1' 
		then  Language.[Parameter.LiveOddType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI+' '+ case when Archive.SlipOdd.ParameterOddId in (108,112,116,129,137,143,149,192,387,389,426,428,1947,2059,2503,2505,2553,2965) 
		  then CAST( cast(Archive.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10))
		  else case when Archive.SlipOdd.SpecialBetValue<>'-1' then  ISNULL(Archive.SlipOdd.SpecialBetValue,'') else '' end end
		else Language.[Parameter.LiveOddType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI end + ' ('+Archive.SlipOdd.Score+')'  AS OddsType, 
							Archive.SlipOdd.OutCome  AS Outcomes
						   , Archive.SlipOdd.OddValue,   Archive.SlipOdd.EventDate  as EventDate, 
						   [dbo].[FuncScore](Archive.SlipOdd.MatchId,1) AS Result
						   , case when Archive.SlipOdd.SpecialBetValue<>'-1' then  case when Archive.SlipOdd.ParameterOddId in (108,112,116,129,137,143,149,192,387,389,426,428,1947,2059,2503,2505,2553,2965) 
		  then CAST( cast(Archive.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10))
		  else case when Archive.SlipOdd.SpecialBetValue<>'-1' then  ISNULL(Archive.SlipOdd.SpecialBetValue,'') else '' end end else '' end  as SpecialBetValue,
		   Archive.SlipOdd.BetradarMatchId
		    ,(Select Top 1 Archive.Code.Code from Archive.Code where Archive.Code.MatchId=Archive.SlipOdd.MatchId ) as MatchCode
									   ,Archive.SlipOdd.OddId,1 as BetType,Archive.SlipOdd.Banko,Language.[Parameter.LiveOddType].ShortOddType COLLATE SQL_Latin1_General_CP1253_CI_AI as ShortOddType,Archive.SlipOdd.ScoreTimeStatu,' ('+RTRIM(Archive.SlipOdd.Score)+')' as Score
		FROM          
							  Archive.SlipOdd with (nolock) INNER JOIN
							  Live.[Parameter.OddType] with (nolock) ON Archive.SlipOdd.OddsTypeId = Live.[Parameter.OddType].OddTypeId INNER JOIN
							  Language.[Parameter.LiveOddType] with (nolock) ON Language.[Parameter.LiveOddType].OddTypeId=Live.[Parameter.OddType].OddTypeId INNER JOIN
							  Language.[Parameter.LiveOdds] with (nolock) ON Language.[Parameter.LiveOdds].OddsId=Archive.SlipOdd.ParameterOddId  
							  --LEFT OUTER JOIN Archive.Code ON Archive.Code.MatchId=Archive.SlipOdd.MatchId and Archive.Code.BetTypeId=1 
							  INNER JOIN							   Language.[Parameter.SlipState] with (nolock) ON Language.[Parameter.SlipState].SlipStateId=Archive.SlipOdd.StateId and Language.[Parameter.SlipState].LanguageId=@LangId
		WHERE     (Archive.SlipOdd.SlipId = @SlipId) and Archive.SlipOdd.BetTypeId=1 and Language.[Parameter.LiveOddType].LanguageId=@LangId and Language.[Parameter.LiveOdds].LanguageId=@LangId

	end
		else
		begin
			insert @temptable
			SELECT  DISTINCT  case when  Language.[Parameter.SlipState].[SlipStateId]=5 then 3 else Language.[Parameter.SlipState].[SlipStateId] end as StateId 
			,Language.[Parameter.SlipState].SlipState as State
		,cast(Archive.SlipOdd.MatchId as nvarchar(10))+' -'+Archive.SlipOdd.EventName as EventName
		, Language.[Parameter.OddsType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI +' ' +case when Archive.SlipOdd.ParameterOddId IN (1578,1544,1540,1648,1646,1644,1642,2247,2321,2325,2465,2541,2543,2915,2973,2993,2997,3010,3052,3079,3350,3371,3393) then CAST( '('+cast(Archive.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10))+')' else case when Archive.SlipOdd.SpecialBetValue is null or Archive.SlipOdd.SpecialBetValue='' then '' else '('+Archive.SlipOdd.SpecialBetValue+')' end end  as OddsType, 
								  Archive.SlipOdd.OutCome AS Outcomes, Archive.SlipOdd.OddValue, Archive.SlipOdd.EventDate,
										 case when Archive.SlipOdd.StateId=4 then  [dbo].[FuncScore](Archive.SlipOdd.MatchId,0) else   '' end AS Result,case when Archive.SlipOdd.ParameterOddId IN (2247,2321,2325,2465,2541,2543,2915,2973,2993,2997,3010,3052,3079,3350,3371,3393) then CAST( cast(Archive.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10)) else ISNULL(Archive.SlipOdd.SpecialBetValue, '') end  AS SpecialBetValue
										   ,Archive.SlipOdd.BetradarMatchId
										    ,case when (select Count(*) from Match.Code with (nolock) where BetradarMatchId=Archive.SlipOdd.BetradarMatchId)>0
									   then (select top 1 Code from Match.Code with (nolock) where BetradarMatchId=Archive.SlipOdd.BetradarMatchId ) 
									   else  (select top 1 Code from Archive.Code with (nolock) where BetradarMatchId=Archive.SlipOdd.BetradarMatchId ) end  as MatchCode ,Archive.SlipOdd.OddId,0 as BetType,Archive.SlipOdd.Banko,Language.[Parameter.OddsType].ShortOddType COLLATE SQL_Latin1_General_CP1253_CI_AI as ShortOddType,Archive.SlipOdd.ScoreTimeStatu,'' as Score
			FROM         
								  Archive.SlipOdd with (nolock)  INNER JOIN
								  Language.[Parameter.OddsType] with (nolock) ON Archive.SlipOdd.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId INNER JOIN
								  Language.[Parameter.SlipState] with (nolock) ON Language.[Parameter.SlipState].[SlipStateId]=Archive.SlipOdd.StateId
								  -- LEFT OUTER JOIN Archive.Code ON Archive.Code.MatchId=Archive.SlipOdd.MatchId and Archive.Code.BetTypeId=0
			WHERE    (Archive.SlipOdd.SlipId in (select Customer.SlipSystemSlip.SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=(select top 1 Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SlipId=@SlipId)) )  AND (Language.[Parameter.OddsType].LanguageId = @LangId) and Language.[Parameter.SlipState].LanguageId=@LangId AND (Archive.SlipOdd.BetTypeId = 0)
			


				insert @temptable
			SELECT  DISTINCT    case when  Language.[Parameter.SlipState].[SlipStateId]=5 then 3 else Language.[Parameter.SlipState].[SlipStateId] end as StateId
			, Language.[Parameter.SlipState].SlipState as State
		,cast(Archive.SlipOdd.MatchId as nvarchar(10))+' -'+Archive.SlipOdd.EventName as EventName
		,Language.[Parameter.LiveOddType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI +' ' +case when Archive.SlipOdd.ParameterOddId IN (1578,1544,1540,1648,1646,1644,1642,2247,2321,2325,2465,2541,2543,2915,2973,2993,2997,3010,3052,3079,3350,3371,3393) then CAST( '('+cast(Archive.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10))+')' else case when Archive.SlipOdd.SpecialBetValue is null or Archive.SlipOdd.SpecialBetValue='' or Archive.SlipOdd.SpecialBetValue='-1' then '' else '('+Archive.SlipOdd.SpecialBetValue+')' end end + ' ('+Archive.SlipOdd.Score+')' AS OddsType, 
								Archive.SlipOdd.OutCome AS Outcomes
							   , Archive.SlipOdd.OddValue, Archive.SlipOdd.EventDate,
				   [dbo].[FuncScore](Archive.SlipOdd.MatchId,1) AS Result
							   ,case when Archive.SlipOdd.ParameterOddId in (108,112,116,129,137,143,149,192,387,389,426,428,1947,2059,2503,2505,2553,2965) 
			  then CAST( cast(Archive.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10))
			  else case when Archive.SlipOdd.SpecialBetValue<>'-1' then  ISNULL(Archive.SlipOdd.SpecialBetValue,'') else '' end end  as SpecialBetValue
			  ,Archive.SlipOdd.BetradarMatchId
			   ,case when (select Count(*) from Match.Code with (nolock) where BetradarMatchId=Archive.SlipOdd.BetradarMatchId)>0
									   then (select top 1 Code from Match.Code with (nolock) where BetradarMatchId=Archive.SlipOdd.BetradarMatchId ) 
									   else  (select top 1 Code from Archive.Code with (nolock) where BetradarMatchId=Archive.SlipOdd.BetradarMatchId ) end as MatchCode ,Archive.SlipOdd.OddId,1 as BetType,Archive.SlipOdd.Banko,Language.[Parameter.LiveOddType].ShortOddType COLLATE SQL_Latin1_General_CP1253_CI_AI as ShortOddType,Archive.SlipOdd.ScoreTimeStatu,' ('+RTRIM(Archive.SlipOdd.Score)+')' as Score
			FROM         
								  Archive.SlipOdd with (nolock)  INNER JOIN
								  Live.[Parameter.OddType] with (nolock) ON Archive.SlipOdd.OddsTypeId = Live.[Parameter.OddType].OddTypeId INNER JOIN
								  Language.[Parameter.LiveOddType] with (nolock) ON Live.[Parameter.OddType].OddTypeId= Language.[Parameter.LiveOddType].OddTypeId INNER JOIN
								  Language.[Parameter.SlipState] with (nolock) ON Language.[Parameter.SlipState].[SlipStateId]=Archive.SlipOdd.StateId LEFT OUTER JOIN Archive.Code ON Archive.Code.MatchId=Archive.SlipOdd.MatchId and Archive.Code.BetTypeId=1
			WHERE      (Archive.SlipOdd.SlipId in (select Customer.SlipSystemSlip.SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=(select top 1 Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SlipId=@SlipId)) )  and Archive.SlipOdd.BetTypeId=1 and  Language.[Parameter.LiveOddType].LanguageId=@LangId and Language.[Parameter.SlipState].LanguageId=@LangId
			
		end
	end
else  
	begin
	if exists(select Archive.SlipOld.SlipId from Archive.SlipOld with (nolock) where Archive.SlipOld.SlipTypeId<3 and Archive.SlipOld.SlipId=@SlipId)
	begin

		insert @temptable
		SELECT   DISTINCT   Language.[Parameter.SlipState].SlipStateId as StateId, Language.[Parameter.SlipState].SlipState as State
		,cast(Archive.SlipOddOld.MatchId as nvarchar(10))+' -'+Archive.SlipOddOld.EventName as EventName
		, Language.[Parameter.OddsType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI +' '+case when Archive.SlipOddOld.ParameterOddId IN (2247,2321,2325,2465,2541,2543,2915,2973,2993,2997,3010,3052,3079,3350,3371,3393) then CAST( cast(Archive.SlipOddOld.SpecialBetValue AS float)*-1 AS nvarchar(10)) else ISNULL(Archive.SlipOddOld.SpecialBetValue, '') end  AS OddsType, 
							  Language.[Parameter.Odds].OutComes as Outcomes, Archive.SlipOddOld.OddValue, Archive.SlipOddOld.EventDate  as EventDate,
									   [dbo].[FuncScore](Archive.SlipOddOld.MatchId,0)  AS Result,case when Archive.SlipOddOld.ParameterOddId IN (2247,2321,2325,2465,2541,2543,2915,2973,2993,2997,3010,3052,3079,3350,3371,3393) then CAST( cast(Archive.SlipOddOld.SpecialBetValue AS float)*-1 AS nvarchar(10)) 
									   else ISNULL(Archive.SlipOddOld.SpecialBetValue, '') end  as SpecialBetValue,
									 Archive.SlipOddOld.BetradarMatchId
									  ,case when (select Count(*) from Match.Code with (nolock) where BetradarMatchId=Archive.SlipOddOld.BetradarMatchId)>0
									   then (select top 1 Code from Match.Code with (nolock) where BetradarMatchId=Archive.SlipOddOld.BetradarMatchId ) 
									   else  (select top 1 Code from Archive.Code with (nolock) where BetradarMatchId=Archive.SlipOddOld.BetradarMatchId )  end as MatchCode
									  ,Archive.SlipOddOld.OddId,0 as BetType,Archive.SlipOddOld.Banko,Language.[Parameter.OddsType].ShortOddType COLLATE SQL_Latin1_General_CP1253_CI_AI as ShortOddType,Archive.SlipOddOld.ScoreTimeStatu,'' as Score
		FROM          
							  Archive.SlipOddOld with (nolock)   INNER JOIN
							  Language.[Parameter.OddsType] with (nolock) ON Archive.SlipOddOld.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId INNER JOIN
							  Language.[Parameter.Odds] with (nolock) ON Language.[Parameter.Odds].OddsId=Archive.SlipOddOld.ParameterOddId LEFT OUTER JOIN Archive.Code ON Archive.Code.MatchId=Archive.SlipOddOld.MatchId and Archive.Code.BetTypeId=0 INNER JOIN
							   Language.[Parameter.SlipState] with (nolock) ON Language.[Parameter.SlipState].SlipStateId=Archive.SlipOddOld.StateId and Language.[Parameter.SlipState].LanguageId=@LangId
		WHERE     (Archive.SlipOddOld.SlipId = @SlipId) AND (Language.[Parameter.OddsType].LanguageId = @LangId) AND (Archive.SlipOddOld.BetTypeId = 0) and Language.[Parameter.Odds].LanguageId=@LangId
	 
	 	insert @temptable
		SELECT    DISTINCT  Language.[Parameter.SlipState].SlipStateId as StateId
		,  Language.[Parameter.SlipState].SlipState as State
		,cast(Archive.SlipOddOld.MatchId as nvarchar(10))+' -'+Archive.SlipOddOld.EventName as EventName
		,case when Archive.SlipOddOld.SpecialBetValue<>'-1' 
		then  Language.[Parameter.LiveOddType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI+' '+ case when Archive.SlipOddOld.ParameterOddId in (108,112,116,129,137,143,149,192,387,389,426,428,1947,2059,2503,2505,2553,2965) 
		  then CAST( cast(Archive.SlipOddOld.SpecialBetValue AS float)*-1 AS nvarchar(10))
		  else case when Archive.SlipOddOld.SpecialBetValue<>'-1' then  ISNULL(Archive.SlipOddOld.SpecialBetValue,'') else '' end end
		else Language.[Parameter.LiveOddType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI end + ' ('+Archive.SlipOddOld.Score+')'  AS OddsType, 
							Archive.SlipOddOld.OutCome  AS Outcomes
						   , Archive.SlipOddOld.OddValue,   Archive.SlipOddOld.EventDate  as EventDate, 
						   [dbo].[FuncScore](Archive.SlipOddOld.MatchId,1) AS Result
						   , case when Archive.SlipOddOld.SpecialBetValue<>'-1' then  case when Archive.SlipOddOld.ParameterOddId in (108,112,116,129,137,143,149,192,387,389,426,428,1947,2059,2503,2505,2553,2965) 
		  then CAST( cast(Archive.SlipOddOld.SpecialBetValue AS float)*-1 AS nvarchar(10))
		  else case when Archive.SlipOddOld.SpecialBetValue<>'-1' then  ISNULL(Archive.SlipOddOld.SpecialBetValue,'') else '' end end else '' end  as SpecialBetValue,
		   Archive.SlipOddOld.BetradarMatchId ,case when (select Count(*) from Match.Code with (nolock) where BetradarMatchId=Archive.SlipOddOld.BetradarMatchId)>0
									   then (select top 1 Code from Match.Code with (nolock) where BetradarMatchId=Archive.SlipOddOld.BetradarMatchId ) 
									   else  (select top 1 Code from Archive.Code with (nolock) where BetradarMatchId=Archive.SlipOddOld.BetradarMatchId ) end  as MatchCode
									   ,Archive.SlipOddOld.OddId,1 as BetType,Archive.SlipOddOld.Banko,Language.[Parameter.LiveOddType].ShortOddType COLLATE SQL_Latin1_General_CP1253_CI_AI as ShortOddType,Archive.SlipOddOld.ScoreTimeStatu,' ('+RTRIM(Archive.SlipOddOld.Score)+')' as Score
		FROM          
							  Archive.SlipOddOld with (nolock) INNER JOIN
							  Live.[Parameter.OddType] with (nolock) ON Archive.SlipOddOld.OddsTypeId = Live.[Parameter.OddType].OddTypeId INNER JOIN
							  Language.[Parameter.LiveOddType] with (nolock) ON Language.[Parameter.LiveOddType].OddTypeId=Live.[Parameter.OddType].OddTypeId INNER JOIN
							  Language.[Parameter.LiveOdds] with (nolock) ON Language.[Parameter.LiveOdds].OddsId=Archive.SlipOddOld.ParameterOddId  
							  --LEFT OUTER JOIN Archive.Code ON Archive.Code.MatchId=Archive.SlipOddOld.MatchId and Archive.Code.BetTypeId=1 
							  INNER JOIN
							   Language.[Parameter.SlipState] with (nolock) ON Language.[Parameter.SlipState].SlipStateId=Archive.SlipOddOld.StateId and Language.[Parameter.SlipState].LanguageId=@LangId
		WHERE     (Archive.SlipOddOld.SlipId = @SlipId) and Archive.SlipOddOld.BetTypeId=1 and Language.[Parameter.LiveOddType].LanguageId=@LangId and Language.[Parameter.LiveOdds].LanguageId=@LangId

	end
		else
		begin
			insert @temptable
			SELECT  DISTINCT  case when  Language.[Parameter.SlipState].[SlipStateId]=5 then 3 else Language.[Parameter.SlipState].[SlipStateId] end as StateId 
			,Language.[Parameter.SlipState].SlipState as State
		,cast(Archive.SlipOddOld.MatchId as nvarchar(10))+' -'+Archive.SlipOddOld.EventName as EventName
		, Language.[Parameter.OddsType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI +' ' +case when Archive.SlipOddOld.ParameterOddId IN (1578,1544,1540,1648,1646,1644,1642,2247,2321,2325,2465,2541,2543,2915,2973,2993,2997,3010,3052,3079,3350,3371,3393) then CAST( '('+cast(Archive.SlipOddOld.SpecialBetValue AS float)*-1 AS nvarchar(10))+')' else case when Archive.SlipOddOld.SpecialBetValue is null or Archive.SlipOddOld.SpecialBetValue='' then '' else '('+Archive.SlipOddOld.SpecialBetValue+')' end end  as OddsType, 
								  Archive.SlipOddOld.OutCome AS Outcomes, Archive.SlipOddOld.OddValue, Archive.SlipOddOld.EventDate,
										 case when Archive.SlipOddOld.StateId=4 then  [dbo].[FuncScore](Archive.SlipOddOld.MatchId,0) else   '' end AS Result,case when Archive.SlipOddOld.ParameterOddId IN (2247,2321,2325,2465,2541,2543,2915,2973,2993,2997,3010,3052,3079,3350,3371,3393) then CAST( cast(Archive.SlipOddOld.SpecialBetValue AS float)*-1 AS nvarchar(10)) else ISNULL(Archive.SlipOddOld.SpecialBetValue, '') end  AS SpecialBetValue
										   ,Archive.SlipOddOld.BetradarMatchId
										    ,case when (select Count(*) from Match.Code with (nolock) where BetradarMatchId=Archive.SlipOddOld.BetradarMatchId)>0
									   then (select top 1 Code from Match.Code with (nolock) where BetradarMatchId=Archive.SlipOddOld.BetradarMatchId ) 
									   else  (select top 1 Code from Archive.Code with (nolock) where BetradarMatchId=Archive.SlipOddOld.BetradarMatchId ) end as MatchCode ,Archive.SlipOddOld.OddId,0 as BetType,Archive.SlipOddOld.Banko,Language.[Parameter.OddsType].ShortOddType COLLATE SQL_Latin1_General_CP1253_CI_AI as ShortOddType,Archive.SlipOddOld.ScoreTimeStatu,'' as Score
			FROM         
								  Archive.SlipOddOld with (nolock)  INNER JOIN
								  Language.[Parameter.OddsType] with (nolock) ON Archive.SlipOddOld.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId INNER JOIN
								  Language.[Parameter.SlipState] with (nolock) ON Language.[Parameter.SlipState].[SlipStateId]=Archive.SlipOddOld.StateId
								  -- LEFT OUTER JOIN Archive.Code ON Archive.Code.MatchId=Archive.SlipOddOld.MatchId and Archive.Code.BetTypeId=0
			WHERE    (Archive.SlipOddOld.SlipId in (select Customer.SlipSystemSlip.SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=(select top 1 Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SlipId=@SlipId)) )  AND (Language.[Parameter.OddsType].LanguageId = @LangId) and Language.[Parameter.SlipState].LanguageId=@LangId AND (Archive.SlipOddOld.BetTypeId = 0)
			


				insert @temptable
			SELECT  DISTINCT    case when  Language.[Parameter.SlipState].[SlipStateId]=5 then 3 else Language.[Parameter.SlipState].[SlipStateId] end as StateId
			, Language.[Parameter.SlipState].SlipState as State
		,cast(Archive.SlipOddOld.MatchId as nvarchar(10))+' -'+Archive.SlipOddOld.EventName as EventName
		,Language.[Parameter.LiveOddType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI +' ' +case when Archive.SlipOddOld.ParameterOddId IN (1578,1544,1540,1648,1646,1644,1642,2247,2321,2325,2465,2541,2543,2915,2973,2993,2997,3010,3052,3079,3350,3371,3393) then CAST( '('+cast(Archive.SlipOddOld.SpecialBetValue AS float)*-1 AS nvarchar(10))+')' else case when Archive.SlipOddOld.SpecialBetValue is null or Archive.SlipOddOld.SpecialBetValue='' or Archive.SlipOddOld.SpecialBetValue='-1' then '' else '('+Archive.SlipOddOld.SpecialBetValue+')' end end + ' ('+Archive.SlipOddOld.Score+')' AS OddsType, 
								Archive.SlipOddOld.OutCome AS Outcomes
							   , Archive.SlipOddOld.OddValue, Archive.SlipOddOld.EventDate,
				   [dbo].[FuncScore](Archive.SlipOddOld.MatchId,1) AS Result
							   ,case when Archive.SlipOddOld.ParameterOddId in (108,112,116,129,137,143,149,192,387,389,426,428,1947,2059,2503,2505,2553,2965) 
			  then CAST( cast(Archive.SlipOddOld.SpecialBetValue AS float)*-1 AS nvarchar(10))
			  else case when Archive.SlipOddOld.SpecialBetValue<>'-1' then  ISNULL(Archive.SlipOddOld.SpecialBetValue,'') else '' end end  as SpecialBetValue
			  ,Archive.SlipOddOld.BetradarMatchId
			   ,case when (select Count(*) from Match.Code with (nolock) where BetradarMatchId=Archive.SlipOddOld.BetradarMatchId)>0
									   then (select top 1 Code from Match.Code with (nolock) where BetradarMatchId=Archive.SlipOddOld.BetradarMatchId ) 
									   else  (select top 1 Code from Archive.Code with (nolock) where BetradarMatchId=Archive.SlipOddOld.BetradarMatchId )end  as MatchCode ,Archive.SlipOddOld.OddId,1 as BetType,Archive.SlipOddOld.Banko,Language.[Parameter.LiveOddType].ShortOddType COLLATE SQL_Latin1_General_CP1253_CI_AI as ShortOddType,Archive.SlipOddOld.ScoreTimeStatu,' ('+RTRIM(Archive.SlipOddOld.Score)+')' as Score
			FROM         
								  Archive.SlipOddOld with (nolock)  INNER JOIN
								  Live.[Parameter.OddType] with (nolock) ON Archive.SlipOddOld.OddsTypeId = Live.[Parameter.OddType].OddTypeId INNER JOIN
								  Language.[Parameter.LiveOddType] with (nolock) ON Live.[Parameter.OddType].OddTypeId= Language.[Parameter.LiveOddType].OddTypeId INNER JOIN
								  Language.[Parameter.SlipState] with (nolock) ON Language.[Parameter.SlipState].[SlipStateId]=Archive.SlipOddOld.StateId 
								  --LEFT OUTER JOIN Archive.Code ON Archive.Code.MatchId=Archive.SlipOddOld.MatchId and Archive.Code.BetTypeId=1
			WHERE      (Archive.SlipOddOld.SlipId in (select Customer.SlipSystemSlip.SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=(select top 1 Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SlipId=@SlipId)) )  and Archive.SlipOddOld.BetTypeId=1 and  Language.[Parameter.LiveOddType].LanguageId=@LangId and Language.[Parameter.SlipState].LanguageId=@LangId
			
		end
	end

	select * from @temptable order by EventDate

END




GO
