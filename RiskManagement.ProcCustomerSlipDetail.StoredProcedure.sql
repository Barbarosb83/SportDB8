USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCustomerSlipDetail]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcCustomerSlipDetail] 
@SlipId bigint,
@LangId int,
@Username nvarchar(50)
AS
BEGIN
SET NOCOUNT ON;


if exists (select Customer.Slip.SlipId from Customer.Slip with (nolock) where Customer.Slip.SlipId=@SlipId)
	begin

	if  exists(select  Customer.Slip.SlipId  from Customer.Slip with (nolock) where Customer.Slip.SlipTypeId<3 and Customer.Slip.SlipId=@SlipId)
	begin
		SELECT     Customer.SlipOdd.SlipOddId,Parameter.SlipState.StateId, Parameter.SlipState.State, cast(Customer.SlipOdd.MatchId as nvarchar(10))+' - '+Customer.SlipOdd.EventName+''+ISNULL((select top 1 ' ( '+ISNULL(Language.[Parameter.Sport].SportName,'')+' ) ' from Language.[Parameter.Sport] where Language.[Parameter.Sport].SportId=Customer.SlipOdd.SportId and Language.[Parameter.Sport].LanguageId=@LangId),'') as EventName, Language.[Parameter.OddsType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI as OddsType, 
							  Customer.SlipOdd.OutCome+' '+case when Customer.SlipOdd.ParameterOddId IN (1578,1544,1540,1648,1646,1644,1642,2247,2321,2325,2465,2541,2543,2915,2973,2993,2997,3010,3052,3079,3350,3371,3393) then CAST( cast(Customer.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10)) else case when Customer.SlipOdd.OddsTypeId in (1524) then '' else ISNULL(Customer.SlipOdd.SpecialBetValue, '') end end AS Outcomes, Customer.SlipOdd.OddValue, dbo.UserTimeZoneDate(@Username,Customer.SlipOdd.EventDate,0) as EventDate,
									  [dbo].[FuncScore2](Customer.SlipOdd.BetradarMatchId,0)  AS Result,case when Customer.SlipOdd.ParameterOddId IN (1578,1544,1540,1648,1646,1644,1642,2247,2321,2325,2465,2541,2543,2915,2973,2993,2997,3010,3052,3079,3350,3371,3393) then CAST( cast(Customer.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10)) else  case when Customer.SlipOdd.OddsTypeId in (1497,1911,1493) then case when cast(Customer.SlipOdd.SpecialBetValue AS float)<0 then  '0:'+CAST( cast(Customer.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10)) else  ISNULL(Customer.SlipOdd.SpecialBetValue, '')+':0' end else ISNULL(Customer.SlipOdd.SpecialBetValue, '')   end  end as SpecialBetValue,
									 Customer.SlipOdd.BetradarMatchId
									 ,'(matchId:'+cast(Customer.SlipOdd.BetradarMatchId as nvarchar(20))+',sportId:1)' as urllink,BetTypeId,MatchId,case when BetTypeId=0 then 'resultdetail.aspx?up=' else 'liveresultdetail.aspx?up=' end as ResultLink
		FROM         Parameter.SlipState with (nolock) INNER JOIN
							  Customer.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Customer.SlipOdd.StateId INNER JOIN
							  Language.[Parameter.OddsType] with (nolock) ON Customer.SlipOdd.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId INNER JOIN
							  Language.[Parameter.Odds] with (nolock) ON Language.[Parameter.Odds].OddsId=Customer.SlipOdd.ParameterOddId
		WHERE     (Customer.SlipOdd.SlipId = @SlipId) AND (Language.[Parameter.OddsType].LanguageId = @LangId) AND (Customer.SlipOdd.BetTypeId = 0) and Language.[Parameter.Odds].LanguageId=@LangId
		UNION ALL
		SELECT     Customer.SlipOdd.SlipOddId,Parameter.SlipState.StateId
		, Parameter.SlipState.State, cast(Customer.SlipOdd.MatchId as nvarchar(10))+' - '+Customer.SlipOdd.EventName+' (Live)'
		,case when Customer.SlipOdd.SpecialBetValue<>'-1' 
		then  Language.[Parameter.LiveOddType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI+' '+ case when Customer.SlipOdd.ParameterOddId in (108,112,116,129,137,143,149,192,387,389,426,428,1947,2059,2503,2505,2553,2965,3257) 
		  then CAST( cast(Customer.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10))
		  else case when Customer.SlipOdd.SpecialBetValue<>'-1' then  ISNULL(Customer.SlipOdd.SpecialBetValue,'') else '' end end
		else Language.[Parameter.LiveOddType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI end AS OddsType, 
		 --case when (select COUNT(OutCome) from Live.EventOdd where Live.EventOdd.MatchId=Customer.SlipOdd.MatchId and Live.EventOdd.OddsTypeId=Customer.SlipOdd.OddsTypeId and Live.EventOdd.OddResult=1 and ISNULL(Live.EventOdd.SpecialBetValue,'')= case when  Customer.SlipOdd.SpecialBetValue is not null then  Customer.SlipOdd.SpecialBetValue else '' end )>0 then  Customer.SlipOdd.OutCome +' ( '+ISNULL((select top 1 OutCome from Live.EventOdd where Live.EventOdd.MatchId=Customer.SlipOdd.MatchId and Live.EventOdd.OddsTypeId=Customer.SlipOdd.OddsTypeId and Live.EventOdd.OddResult=1 and ISNULL(Live.EventOdd.SpecialBetValue,'')= case when  Customer.SlipOdd.SpecialBetValue is not null then  Customer.SlipOdd.SpecialBetValue else '' end ),'')+' )' 
			--			   else case when (select COUNT(OutCome) from Archive.[Live.EventOdd] where Archive.[Live.EventOdd].MatchId=Customer.SlipOdd.MatchId and Archive.[Live.EventOdd].OddsTypeId=Customer.SlipOdd.OddsTypeId and Archive.[Live.EventOdd].OddResult=1 and Archive.[Live.EventOdd].SpecialBetValue=Customer.SlipOdd.SpecialBetValue)>0  then  Language.[Parameter.LiveOdds].OutComes +' ( '+ISNULL((select top 1 OutCome from Archive.[Live.EventOdd] where Archive.[Live.EventOdd].MatchId=Customer.SlipOdd.MatchId and Archive.[Live.EventOdd].OddsTypeId=Customer.SlipOdd.OddsTypeId and Archive.[Live.EventOdd].OddResult=1 and ISNULL(Archive.[Live.EventOdd].SpecialBetValue,'')= case when  Customer.SlipOdd.SpecialBetValue is not null then  Customer.SlipOdd.SpecialBetValue else '' end),'')+' )' else Language.[Parameter.LiveOdds].OutComes end end 
							Language.[Parameter.LiveOdds].OutComes  AS Outcomes
						   , Customer.SlipOdd.OddValue,  dbo.UserTimeZoneDate(@Username,Customer.SlipOdd.EventDate,0) as EventDate, 
						   --'Live Score -'+ISNULL((select Score from Live.EventDetail where Live.EventDetail.EventId=Customer.SlipOdd.MatchId),'') 
						   [dbo].[FuncScore2](Customer.SlipOdd.BetradarMatchId,1) AS Result
						   , case when Customer.SlipOdd.SpecialBetValue<>'-1' then  case when Customer.SlipOdd.ParameterOddId in (108,112,116,129,137,143,149,192,387,389,426,428,1947,2059,2503,2505,2553,2965) 
		  then CAST( cast(Customer.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10))
		  else case when Customer.SlipOdd.SpecialBetValue<>'-1' then  ISNULL(Customer.SlipOdd.SpecialBetValue,'') else '' end end else '' end as SpecialBetValue,
		 Customer.SlipOdd.BetradarMatchId
		 ,'(matchId:'+cast(Customer.SlipOdd.BetradarMatchId as nvarchar(20))+',sportId:1)' as urllink,BetTypeId,MatchId,case when BetTypeId=0 then 'resultdetail.aspx?up=' else 'liveresultdetail.aspx?up=' end as ResultLink
		FROM         Parameter.SlipState with (nolock) INNER JOIN
							  Customer.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Customer.SlipOdd.StateId INNER JOIN
							  Live.[Parameter.OddType] with (nolock) ON Customer.SlipOdd.OddsTypeId = Live.[Parameter.OddType].OddTypeId INNER JOIN
							  Language.[Parameter.LiveOddType] with (nolock) ON Language.[Parameter.LiveOddType].OddTypeId=Live.[Parameter.OddType].OddTypeId INNER JOIN
							  Language.[Parameter.LiveOdds] with (nolock) ON Language.[Parameter.LiveOdds].OddsId=Customer.SlipOdd.ParameterOddId
		WHERE     (Customer.SlipOdd.SlipId = @SlipId) and Customer.SlipOdd.BetTypeId=1 and Language.[Parameter.LiveOddType].LanguageId=@LangId and Language.[Parameter.LiveOdds].LanguageId=@LangId


		UNION ALL
		SELECT     Customer.SlipOdd.SlipOddId,Parameter.SlipState.StateId, Parameter.SlipState.State, Customer.SlipOdd.EventName,  Customer.SlipOdd.EventName as OddsType, Customer.SlipOdd.OutCome AS Outcomes, 
							  Customer.SlipOdd.OddValue, dbo.UserTimeZoneDate(@Username,Customer.SlipOdd.EventDate,0) as EventDate, '-' AS Result, 
							  Customer.SlipOdd.SpecialBetValue,Customer.SlipOdd.BetradarMatchId 
							  ,'(matchId:'+cast(Customer.SlipOdd.BetradarMatchId as nvarchar(20))+',sportId:1)' as urllink,BetTypeId,MatchId,case when BetTypeId=0 then 'resultdetail.aspx?up=' else 'liveresultdetail.aspx?up=' end as ResultLink
		FROM         Parameter.SlipState with (nolock) INNER JOIN
							  Customer.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Customer.SlipOdd.StateId 
							   
		WHERE     (Customer.SlipOdd.SlipId = @SlipId) AND (Customer.SlipOdd.BetTypeId = 2)
		end
	else
		begin
			SELECT DISTINCT Max(Customer.SlipOdd.SlipOddId) as SlipOddId, case when  Parameter.SlipState.StateId=5 then 3 else Parameter.SlipState.StateId end as StateId 
			,Language.[Parameter.SlipState].SlipState as State
		
		,cast(Customer.SlipOdd.MatchId as nvarchar(10))+' -'+Customer.SlipOdd.EventName+ case when Banko=1 then '(!!!Bank!!!)' else '' end as EventName
		, Language.[Parameter.OddsType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI+' ' +case when Customer.SlipOdd.ParameterOddId IN (1578,1544,1540,1648,1646,1644,1642,2247,2321,2325,2465,2541,2543,2915,2973,2993,2997,3010,3052,3079,3350,3371,3393) then '('+CAST( cast(Customer.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10))+')' else case when Customer.SlipOdd.SpecialBetValue is null or Customer.SlipOdd.SpecialBetValue='' or Customer.SlipOdd.SpecialBetValue='-1' then '' else '('+Customer.SlipOdd.SpecialBetValue+')' end end  as OddsType, 
						  Customer.SlipOdd.OutCome AS Outcomes, Customer.SlipOdd.OddValue,  dbo.UserTimeZoneDate(@Username,Customer.SlipOdd.EventDate,0) as EventDate,
								 [dbo].[FuncScore2](Customer.SlipOdd.BetradarMatchId,0)  AS Result,case when Customer.SlipOdd.ParameterOddId IN (1578,1544,1540,1648,1646,1644,1642,2247,2321,2325,2465,2541,2543,2915,2973,2993,2997,3010,3052,3079,3350,3371,3393) then CAST( cast(Customer.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10)) else  case when Customer.SlipOdd.OddsTypeId in (1497,1911,1493) then case when cast(Customer.SlipOdd.SpecialBetValue AS float)<0 then  '0:'+CAST( cast(Customer.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10)) else  ISNULL(Customer.SlipOdd.SpecialBetValue, '')+':0' end else ISNULL(Customer.SlipOdd.SpecialBetValue, '')   end end AS SpecialBetValue
								   ,Customer.SlipOdd.BetradarMatchId
								   ,'(matchId:'+cast(Customer.SlipOdd.BetradarMatchId as nvarchar(20))+',sportId:1)' as urllink,BetTypeId,MatchId,case when BetTypeId=0 then 'resultdetail.aspx?up=' else 'liveresultdetail.aspx?up=' end as ResultLink
								  
			FROM         Parameter.SlipState with (nolock) INNER JOIN
								  Customer.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Customer.SlipOdd.StateId INNER JOIN
								  Language.[Parameter.OddsType] with (nolock) ON Customer.SlipOdd.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId INNER JOIN
								  Language.[Parameter.SlipState] with (nolock) ON Language.[Parameter.SlipState].[SlipStateId]=Parameter.SlipState.StateId 
			WHERE     (Customer.SlipOdd.SlipId in (select Customer.SlipSystemSlip.SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=(select top 1 Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SlipId=@SlipId)) ) AND (Language.[Parameter.OddsType].LanguageId = @LangId) and Language.[Parameter.SlipState].LanguageId=@LangId AND (Customer.SlipOdd.BetTypeId = 0)
				group by Parameter.SlipState.StateId,Language.[Parameter.SlipState].SlipState,Customer.SlipOdd.MatchId,Customer.SlipOdd.EventName,Customer.SlipOdd.SpecialBetValue,
			Language.[Parameter.OddsType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI,Customer.SlipOdd.ParameterOddId,Customer.SlipOdd.OutCome,Customer.SlipOdd.OddValue,Customer.SlipOdd.EventDate
			,Customer.SlipOdd.BetradarMatchId,BetTypeId,MatchId,Banko,Customer.SlipOdd.OddsTypeId
			UNION ALL
			SELECT   DISTINCT  Max(Customer.SlipOdd.SlipOddId) as SlipOddId,  case when  Parameter.SlipState.StateId=5 then 3 else Parameter.SlipState.StateId end as StateId
			, Language.[Parameter.SlipState].SlipState as State
		,cast(Customer.SlipOdd.MatchId as nvarchar(10))+' -'+Customer.SlipOdd.EventName+ case when Banko=1 then '(!!!Bank!!!)' else '' end as EventName
		,Language.[Parameter.LiveOddType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI+' ' +case when Customer.SlipOdd.ParameterOddId IN (1578,1544,1540,1648,1646,1644,1642,2247,2321,2325,2465,2541,2543,2915,2973,2993,2997,3010,3052,3079,3350,3371,3393) then '('+CAST( cast(Customer.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10))+')' else case when Customer.SlipOdd.SpecialBetValue is null or Customer.SlipOdd.SpecialBetValue='' or Customer.SlipOdd.SpecialBetValue='-1' then '' else '('+Customer.SlipOdd.SpecialBetValue+')' end end AS OddsType, 
				   --             case when (select COUNT(OutCome) from Live.EventOdd where Live.EventOdd.MatchId=Customer.SlipOdd.MatchId and Live.EventOdd.OddsTypeId=Customer.SlipOdd.OddsTypeId and Live.EventOdd.OddResult=1 and ISNULL(Live.EventOdd.SpecialBetValue,'')= case when  Customer.SlipOdd.SpecialBetValue is not null then  Customer.SlipOdd.SpecialBetValue else '' end )>0 then  Customer.SlipOdd.OutCome 
							   --else case when (select COUNT(OutCome) from Archive.[Live.EventOdd] where Archive.[Live.EventOdd].MatchId=Customer.SlipOdd.MatchId and Archive.[Live.EventOdd].OddsTypeId=Customer.SlipOdd.OddsTypeId and Archive.[Live.EventOdd].OddResult=1 and Archive.[Live.EventOdd].SpecialBetValue=Customer.SlipOdd.SpecialBetValue)>0  then  Customer.SlipOdd.OutCome else  Customer.SlipOdd.OutCome end end 
								Customer.SlipOdd.OutCome AS Outcomes
							   , Customer.SlipOdd.OddValue, dbo.UserTimeZoneDate(@Username,Customer.SlipOdd.EventDate,0) as EventDate,
				   [dbo].[FuncScore2](Customer.SlipOdd.BetradarMatchId,1) AS Result
							   ,case when Customer.SlipOdd.ParameterOddId in (108,112,116,129,137,143,149,192,387,389,426,428,1947,2059,2503,2505,2553,2965,3257) 
			  then CAST( cast(Customer.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10))
			  else case when Customer.SlipOdd.SpecialBetValue<>'-1' then  ISNULL(Customer.SlipOdd.SpecialBetValue,'') else '' end end as SpecialBetValue
			  ,Customer.SlipOdd.BetradarMatchId
			  ,'(matchId:'+cast(Customer.SlipOdd.BetradarMatchId as nvarchar(20))+',sportId:1)' as urllink,BetTypeId,MatchId,case when BetTypeId=0 then 'resultdetail.aspx?up=' else 'liveresultdetail.aspx?up=' end as ResultLink
			    
			FROM         Parameter.SlipState with (nolock) INNER JOIN
								  Customer.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Customer.SlipOdd.StateId INNER JOIN
								  Live.[Parameter.OddType] with (nolock) ON Customer.SlipOdd.OddsTypeId = Live.[Parameter.OddType].OddTypeId INNER JOIN
								  Language.[Parameter.LiveOddType] with (nolock) ON Live.[Parameter.OddType].OddTypeId= Language.[Parameter.LiveOddType].OddTypeId INNER JOIN
								  Language.[Parameter.SlipState] with (nolock) ON Language.[Parameter.SlipState].[SlipStateId]=Parameter.SlipState.StateId --LEFT OUTER JOIN Match.Code ON Match.Code.MatchId=Customer.SlipOdd.MatchId
			WHERE     (Customer.SlipOdd.SlipId in (select Customer.SlipSystemSlip.SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=(select top 1 Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SlipId=@SlipId)) ) and Customer.SlipOdd.BetTypeId=1 and  Language.[Parameter.LiveOddType].LanguageId=@LangId and Language.[Parameter.SlipState].LanguageId=@LangId
				group by Parameter.SlipState.StateId,Language.[Parameter.SlipState].SlipState,Customer.SlipOdd.MatchId,Customer.SlipOdd.EventName,Customer.SlipOdd.SpecialBetValue,
			Language.[Parameter.LiveOddType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI,Customer.SlipOdd.ParameterOddId,Customer.SlipOdd.OutCome,Customer.SlipOdd.OddValue, Customer.SlipOdd.EventDate
			,Customer.SlipOdd.BetradarMatchId,BetTypeId,MatchId,Banko
			UNION ALL
			SELECT   DISTINCT    Customer.SlipOdd.SlipOddId as SlipOddId,Parameter.SlipState.StateId, Language.[Parameter.SlipState].SlipState as State,cast(Customer.SlipOdd.MatchId as nvarchar(10))+' -'+ Customer.SlipOdd.EventName,  Language.[Parameter.OddsType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI, Customer.SlipOdd.OutCome AS Outcomes, 
								  Customer.SlipOdd.OddValue,  dbo.UserTimeZoneDate(@Username,Customer.SlipOdd.EventDate,0) as EventDate, '-' AS Result, 
								  Customer.SlipOdd.SpecialBetValue,Customer.SlipOdd.BetradarMatchId
								  ,'(matchId:'+cast(Customer.SlipOdd.BetradarMatchId as nvarchar(20))+',sportId:1)' as urllink,Customer.SlipOdd.BetTypeId,Customer.SlipOdd.MatchId,case when Customer.SlipOdd.BetTypeId=0 then 'resultdetail.aspx?up=' else 'liveresultdetail.aspx?up=' end as ResultLink
			FROM         Parameter.SlipState INNER JOIN
								  Customer.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Customer.SlipOdd.StateId
								  INNER JOIN
								  Language.[Parameter.OddsType] ON Customer.SlipOdd.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId  and Language.[Parameter.OddsType].LanguageId=@LangId INNER JOIN
								  Language.[Parameter.SlipState] ON Language.[Parameter.SlipState].[SlipStateId]=Parameter.SlipState.StateId LEFT OUTER JOIN Match.Code ON Match.Code.MatchId=Customer.SlipOdd.MatchId
			WHERE     (Customer.SlipOdd.SlipId in (select Customer.SlipSystemSlip.SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=(select top 1 Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SlipId=@SlipId)) ) AND (Customer.SlipOdd.BetTypeId = 2) and Language.[Parameter.SlipState].LanguageId=@LangId
			UNION ALL
		SELECT     Customer.SlipOdd.SlipOddId,Parameter.SlipState.StateId, Parameter.SlipState.State, Customer.SlipOdd.EventName,  Customer.SlipOdd.EventName as OddsType, Customer.SlipOdd.OutCome AS Outcomes, 
							  Customer.SlipOdd.OddValue, dbo.UserTimeZoneDate(@Username,Customer.SlipOdd.EventDate,0) as EventDate, '-' AS Result, 
							  Customer.SlipOdd.SpecialBetValue,Customer.SlipOdd.BetradarMatchId 
							  ,'(matchId:'+cast(Customer.SlipOdd.BetradarMatchId as nvarchar(20))+',sportId:1)' as urllink,BetTypeId,MatchId,case when BetTypeId=0 then 'resultdetail.aspx?up=' else 'liveresultdetail.aspx?up=' end as ResultLink
		FROM         Parameter.SlipState with (nolock) INNER JOIN
							  Customer.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Customer.SlipOdd.StateId 
							   
		WHERE     (Customer.SlipOdd.SlipId = @SlipId) AND (Customer.SlipOdd.BetTypeId = 2)

		end

	end
else
	begin
	if(select COUNT(Archive.Slip.SlipId) from Archive.Slip with (nolock) where Archive.Slip.SlipTypeId<3 and Archive.Slip.SlipId=@SlipId)>0
	begin
		SELECT     Archive.SlipOdd.SlipOddId,Parameter.SlipState.StateId, Parameter.SlipState.State, cast(Archive.SlipOdd.MatchId as nvarchar(10))+' - '+Archive.SlipOdd.EventName+''+ISNULL((select ' ( '+ISNULL(Language.[Parameter.Sport].SportName,'')+' ) ' from Language.[Parameter.Sport] where Language.[Parameter.Sport].SportId=Archive.SlipOdd.SportId and Language.[Parameter.Sport].LanguageId=@LangId),'') as EventName, Language.[Parameter.OddsType].OddsType, 
							  Language.[Parameter.Odds].OutComes+' '+case when Archive.SlipOdd.ParameterOddId IN (2247,2321,2325,2465,2541,2543,2915,2973,2993,2997,3010,3052,3079,3350,3371,3393) then CAST( cast(Archive.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10)) else case when Archive.SlipOdd.OddsTypeId in (1497,1911,1493) then case when cast(Archive.SlipOdd.SpecialBetValue AS float)<0 then  '0:'+CAST( cast(Archive.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10)) else  ISNULL(Archive.SlipOdd.SpecialBetValue, '')+':0' end else ISNULL(Archive.SlipOdd.SpecialBetValue, '')   end end AS Outcomes, Archive.SlipOdd.OddValue, dbo.UserTimeZoneDate(@Username,Archive.SlipOdd.EventDate,0) as EventDate,
									   [dbo].[FuncScore](Archive.SlipOdd.MatchId,0)  AS Result,case when Archive.SlipOdd.ParameterOddId IN (2247,2321,2325,2465,2541,2543,2915,2973,2993,2997,3010,3052,3079,3350,3371,3393) then CAST( cast(Archive.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10)) else  case when Archive.SlipOdd.OddsTypeId in (1497,1911,1493) then case when cast(Archive.SlipOdd.SpecialBetValue AS float)<0 then  '0:'+CAST( cast(Archive.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10)) else  ISNULL(Archive.SlipOdd.SpecialBetValue, '')+':0' end else ISNULL(Archive.SlipOdd.SpecialBetValue, '')   end end as SpecialBetValue,
									Archive.SlipOdd.BetradarMatchId
									,'(matchId:'+cast(Archive.SlipOdd.BetradarMatchId as nvarchar(20))+',sportId:1)' as urllink,BetTypeId,MatchId,case when BetTypeId=0 then 'resultdetail.aspx?up=' else 'liveresultdetail.aspx?up=' end as ResultLink
		FROM         Parameter.SlipState INNER JOIN
							  Archive.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Archive.SlipOdd.StateId INNER JOIN
							  Language.[Parameter.OddsType] ON Archive.SlipOdd.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId INNER JOIN
							  Language.[Parameter.Odds] ON Language.[Parameter.Odds].OddsId=Archive.SlipOdd.ParameterOddId
		WHERE     (Archive.SlipOdd.SlipId = @SlipId) AND (Language.[Parameter.OddsType].LanguageId = @LangId) AND (Archive.SlipOdd.BetTypeId = 0) and Language.[Parameter.Odds].LanguageId=@LangId
		UNION ALL

		SELECT     Archive.SlipOdd.SlipOddId,Parameter.SlipState.StateId
		, Parameter.SlipState.State, cast(Archive.SlipOdd.MatchId as nvarchar(10))+' - '+Archive.SlipOdd.EventName+' (Live)'
		,case when Archive.SlipOdd.SpecialBetValue<>'-1' 
		then  Language.[Parameter.LiveOddType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI+' '+ case when Archive.SlipOdd.ParameterOddId in (108,112,116,129,137,143,149,192,387,389,426,428,1947,2059,2503,2505,2553,2965) 
		  then CAST( cast(Archive.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10))
		  else case when Archive.SlipOdd.SpecialBetValue<>'-1' then  ISNULL(Archive.SlipOdd.SpecialBetValue,'') else '' end end
		else Language.[Parameter.LiveOddType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI end AS OddsType, 
		 --case when (select COUNT(OutCome) from Live.EventOdd where Live.EventOdd.MatchId=Archive.SlipOdd.MatchId and Live.EventOdd.OddsTypeId=Archive.SlipOdd.OddsTypeId and Live.EventOdd.OddResult=1 and ISNULL(Live.EventOdd.SpecialBetValue,'')= case when  Archive.SlipOdd.SpecialBetValue is not null then  Archive.SlipOdd.SpecialBetValue else '' end )>0 then  Archive.SlipOdd.OutCome +' ( '+ISNULL((select top 1 OutCome from Live.EventOdd where Live.EventOdd.MatchId=Archive.SlipOdd.MatchId and Live.EventOdd.OddsTypeId=Archive.SlipOdd.OddsTypeId and Live.EventOdd.OddResult=1 and ISNULL(Live.EventOdd.SpecialBetValue,'')= case when  Archive.SlipOdd.SpecialBetValue is not null then  Archive.SlipOdd.SpecialBetValue else '' end ),'')+' )' 
			--			   else case when (select COUNT(OutCome) from Archive.[Live.EventOdd] where Archive.[Live.EventOdd].MatchId=Archive.SlipOdd.MatchId and Archive.[Live.EventOdd].OddsTypeId=Archive.SlipOdd.OddsTypeId and Archive.[Live.EventOdd].OddResult=1 and Archive.[Live.EventOdd].SpecialBetValue=Archive.SlipOdd.SpecialBetValue)>0  then  Language.[Parameter.LiveOdds].OutComes +' ( '+ISNULL((select top 1 OutCome from Archive.[Live.EventOdd] where Archive.[Live.EventOdd].MatchId=Archive.SlipOdd.MatchId and Archive.[Live.EventOdd].OddsTypeId=Archive.SlipOdd.OddsTypeId and Archive.[Live.EventOdd].OddResult=1 and ISNULL(Archive.[Live.EventOdd].SpecialBetValue,'')= case when  Archive.SlipOdd.SpecialBetValue is not null then  Archive.SlipOdd.SpecialBetValue else '' end),'')+' )' else Language.[Parameter.LiveOdds].OutComes end end 
							Archive.SlipOdd.OutCome  AS Outcomes
						   , Archive.SlipOdd.OddValue,  dbo.UserTimeZoneDate(@Username,Archive.SlipOdd.EventDate,0) as EventDate, 
						   --'Live Score -'+ISNULL((select Score from Live.EventDetail where Live.EventDetail.EventId=Archive.SlipOdd.MatchId),'') 
						   [dbo].[FuncScore](Archive.SlipOdd.MatchId,1) AS Result
						   , case when Archive.SlipOdd.SpecialBetValue<>'-1' then  case when Archive.SlipOdd.ParameterOddId in (108,112,116,129,137,143,149,192,387,389,426,428,1947,2059,2503,2505,2553,2965) 
		  then CAST( cast(Archive.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10))
		  else case when Archive.SlipOdd.SpecialBetValue<>'-1' then  ISNULL(Archive.SlipOdd.SpecialBetValue,'') else '' end end else '' end as SpecialBetValue,
		 Archive.SlipOdd.BetradarMatchId
		 ,'(matchId:'+cast(Archive.SlipOdd.BetradarMatchId as nvarchar(20))+',sportId:1)' as urllink,BetTypeId,MatchId,case when BetTypeId=0 then 'resultdetail.aspx?up=' else 'liveresultdetail.aspx?up=' end as ResultLink
		FROM         Parameter.SlipState INNER JOIN
							  Archive.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Archive.SlipOdd.StateId INNER JOIN
							  Live.[Parameter.OddType] ON Archive.SlipOdd.OddsTypeId = Live.[Parameter.OddType].OddTypeId INNER JOIN
							  Language.[Parameter.LiveOddType] ON Language.[Parameter.LiveOddType].OddTypeId=Live.[Parameter.OddType].OddTypeId INNER JOIN
							  Language.[Parameter.LiveOdds] ON Language.[Parameter.LiveOdds].OddsId=Archive.SlipOdd.ParameterOddId
		WHERE     (Archive.SlipOdd.SlipId = @SlipId) and Archive.SlipOdd.BetTypeId=1 and Language.[Parameter.LiveOddType].LanguageId=@LangId and Language.[Parameter.LiveOdds].LanguageId=@LangId


		UNION ALL
		SELECT     Archive.SlipOdd.SlipOddId,Parameter.SlipState.StateId, Parameter.SlipState.State, Archive.SlipOdd.EventName,  Language.[Parameter.OddsType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI, Archive.SlipOdd.OutCome AS Outcomes, 
							  Archive.SlipOdd.OddValue, dbo.UserTimeZoneDate(@Username,Archive.SlipOdd.EventDate,0) as EventDate, '-' AS Result, 
							  Archive.SlipOdd.SpecialBetValue,Archive.SlipOdd.BetradarMatchId
							  ,'(matchId:'+cast(Archive.SlipOdd.BetradarMatchId as nvarchar(20))+',sportId:1)' as urllink,BetTypeId,MatchId,case when BetTypeId=0 then 'resultdetail.aspx?up=' else 'liveresultdetail.aspx?up=' end as ResultLink
		FROM         Parameter.SlipState with (nolock) INNER JOIN
		
							  Archive.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Archive.SlipOdd.StateId INNER JOIN
							    Language.[Parameter.OddsType] with (nolock) ON Archive.SlipOdd.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId and Language.[Parameter.OddsType].LanguageId=@LangId
		WHERE     (Archive.SlipOdd.SlipId = @SlipId) AND (Archive.SlipOdd.BetTypeId = 2)
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
			SELECT  DISTINCT   Max(Archive.SlipOdd.SlipOddId) as SlipOddId,case when  Parameter.SlipState.StateId=5 then 3 else Parameter.SlipState.StateId end as StateId 
			,Language.[Parameter.SlipState].SlipState as State
		,cast(Archive.SlipOdd.MatchId as nvarchar(10))+' -'+Archive.SlipOdd.EventName+ case when Banko=1 then '(!!!Bank!!!)' else '' end as EventName
		, Language.[Parameter.OddsType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI+' ' +case when Archive.SlipOdd.ParameterOddId IN (1578,1544,1540,1648,1646,1644,1642,2247,2321,2325,2465,2541,2543,2915,2973,2993,2997,3010,3052,3079,3350,3371,3393) then '('+CAST( cast(Archive.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10))+')' else case when Archive.SlipOdd.SpecialBetValue is null or Archive.SlipOdd.SpecialBetValue='' then '' else '('+Archive.SlipOdd.SpecialBetValue+')' end end as OddsType, 
								  Archive.SlipOdd.OutCome AS Outcomes, Archive.SlipOdd.OddValue,  dbo.UserTimeZoneDate(@Username,Archive.SlipOdd.EventDate,0) as EventDate,
										 case when Archive.SlipOdd.StateId=4 then  [dbo].[FuncScore](Archive.SlipOdd.MatchId,0) else   '' end AS Result,case when Archive.SlipOdd.ParameterOddId IN (2247,2321,2325,2465,2541,2543,2915,2973,2993,2997,3010,3052,3079,3350,3371,3393) then CAST( cast(Archive.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10)) else ISNULL(Archive.SlipOdd.SpecialBetValue, '') end AS SpecialBetValue
										   ,Archive.SlipOdd.BetradarMatchId
										   ,'(matchId:'+cast(Archive.SlipOdd.BetradarMatchId as nvarchar(20))+',sportId:1)' as urllink,Archive.SlipOdd.BetTypeId,Archive.SlipOdd.MatchId,case when Archive.SlipOdd.BetTypeId=0 then 'resultdetail.aspx?up=' else 'liveresultdetail.aspx?up=' end as ResultLink
			FROM         Parameter.SlipState with (nolock) INNER JOIN
								  Archive.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Archive.SlipOdd.StateId INNER JOIN
								  Language.[Parameter.OddsType] with (nolock) ON Archive.SlipOdd.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId INNER JOIN
								  Language.[Parameter.SlipState] with (nolock) ON Language.[Parameter.SlipState].[SlipStateId]=Parameter.SlipState.StateId LEFT OUTER JOIN Archive.Code ON Archive.Code.MatchId=Archive.SlipOdd.MatchId and Archive.Code.BetTypeId=0
			WHERE    (Archive.SlipOdd.SlipId in (select Customer.SlipSystemSlip.SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=(select top 1 Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SlipId=@SlipId)) )  AND (Language.[Parameter.OddsType].LanguageId = @LangId) and Language.[Parameter.SlipState].LanguageId=@LangId AND (Archive.SlipOdd.BetTypeId = 0)
			group by Parameter.SlipState.StateId,Language.[Parameter.SlipState].SlipState,Archive.SlipOdd.MatchId,Archive.SlipOdd.EventName,Archive.SlipOdd.SpecialBetValue,
			Language.[Parameter.OddsType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI,Archive.SlipOdd.ParameterOddId,Archive.SlipOdd.OutCome,Archive.SlipOdd.OddValue,Archive.SlipOdd.EventDate
			,Archive.SlipOdd.BetradarMatchId,Archive.SlipOdd.StateId,Archive.SlipOdd.BetTypeId,Archive.SlipOdd.MatchId,Banko
			UNION ALL
			SELECT  DISTINCT    Max(Archive.SlipOdd.SlipOddId) as SlipOddId, case when  Parameter.SlipState.StateId=5 then 3 else Parameter.SlipState.StateId end as StateId
			, Language.[Parameter.SlipState].SlipState as State
		,cast(Archive.SlipOdd.MatchId as nvarchar(10))+' -'+Archive.SlipOdd.EventName+ case when Banko=1 then '(!!!Bank!!!)' else '' end as EventName
		,Language.[Parameter.LiveOddType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI+' ' +case when Archive.SlipOdd.ParameterOddId IN (1578,1544,1540,1648,1646,1644,1642,2247,2321,2325,2465,2541,2543,2915,2973,2993,2997,3010,3052,3079,3350,3371,3393) then '('+CAST( cast(Archive.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10))+')' else case when Archive.SlipOdd.SpecialBetValue is null or Archive.SlipOdd.SpecialBetValue='' or Archive.SlipOdd.SpecialBetValue='-1' then '' else '('+Archive.SlipOdd.SpecialBetValue+')' end end AS OddsType, 
				   --             case when (select COUNT(OutCome) from Live.EventOdd where Live.EventOdd.MatchId=Archive.SlipOdd.MatchId and Live.EventOdd.OddsTypeId=Archive.SlipOdd.OddsTypeId and Live.EventOdd.OddResult=1 and ISNULL(Live.EventOdd.SpecialBetValue,'')= case when  Archive.SlipOdd.SpecialBetValue is not null then  Archive.SlipOdd.SpecialBetValue else '' end )>0 then  Archive.SlipOdd.OutCome 
							   --else case when (select COUNT(OutCome) from Archive.[Live.EventOdd] where Archive.[Live.EventOdd].MatchId=Archive.SlipOdd.MatchId and Archive.[Live.EventOdd].OddsTypeId=Archive.SlipOdd.OddsTypeId and Archive.[Live.EventOdd].OddResult=1 and Archive.[Live.EventOdd].SpecialBetValue=Archive.SlipOdd.SpecialBetValue)>0  then  Archive.SlipOdd.OutCome else  Archive.SlipOdd.OutCome end end 
								Archive.SlipOdd.OutCome AS Outcomes
							   , Archive.SlipOdd.OddValue,  dbo.UserTimeZoneDate(@Username,Archive.SlipOdd.EventDate,0) as EventDate,
				   [dbo].[FuncScore](Archive.SlipOdd.MatchId,1) AS Result
							   ,case when Archive.SlipOdd.ParameterOddId in (108,112,116,129,137,143,149,192,387,389,426,428,1947,2059,2503,2505,2553,2965) 
			  then CAST( cast(Archive.SlipOdd.SpecialBetValue AS float)*-1 AS nvarchar(10))
			  else case when Archive.SlipOdd.SpecialBetValue<>'-1' then  ISNULL(Archive.SlipOdd.SpecialBetValue,'') else '' end end as SpecialBetValue
			  ,Archive.SlipOdd.BetradarMatchId
			  ,'(matchId:'+cast(Archive.SlipOdd.BetradarMatchId as nvarchar(20))+',sportId:1)' as urllink,Archive.SlipOdd.BetTypeId,Archive.SlipOdd.MatchId,case when Archive.SlipOdd.BetTypeId=0 then 'resultdetail.aspx?up=' else 'liveresultdetail.aspx?up=' end as ResultLink
			FROM         Parameter.SlipState with (nolock) INNER JOIN
								  Archive.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Archive.SlipOdd.StateId INNER JOIN
								  Live.[Parameter.OddType] with (nolock) ON Archive.SlipOdd.OddsTypeId = Live.[Parameter.OddType].OddTypeId INNER JOIN
								  Language.[Parameter.LiveOddType] with (nolock) ON Live.[Parameter.OddType].OddTypeId= Language.[Parameter.LiveOddType].OddTypeId INNER JOIN
								  Language.[Parameter.SlipState] with (nolock) ON Language.[Parameter.SlipState].[SlipStateId]=Parameter.SlipState.StateId LEFT OUTER JOIN Archive.Code ON Archive.Code.MatchId=Archive.SlipOdd.MatchId and Archive.Code.BetTypeId=1
			WHERE      (Archive.SlipOdd.SlipId in (select Customer.SlipSystemSlip.SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=(select top 1 Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SlipId=@SlipId)) )  and Archive.SlipOdd.BetTypeId=1 and  Language.[Parameter.LiveOddType].LanguageId=@LangId and Language.[Parameter.SlipState].LanguageId=@LangId
			group by Parameter.SlipState.StateId,Language.[Parameter.SlipState].SlipState,Archive.SlipOdd.MatchId,Archive.SlipOdd.EventName,Archive.SlipOdd.SpecialBetValue,
			Language.[Parameter.LiveOddType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI,Archive.SlipOdd.ParameterOddId,Archive.SlipOdd.OutCome,Archive.SlipOdd.OddValue,Archive.SlipOdd.EventDate
			,Archive.SlipOdd.BetradarMatchId,Archive.SlipOdd.BetTypeId,Archive.SlipOdd.MatchId,Banko
			--UNION ALL
			--SELECT  DISTINCT   cast(0 as bigint) as SlipOddId,  Parameter.SlipState.StateId, Language.[Parameter.SlipState].SlipState as State,cast(Archive.SlipOdd.MatchId as nvarchar(10))+' - '+ Archive.SlipOdd.EventName, Language.[Parameter.OddsType].OddsType, Archive.SlipOdd.OutCome AS Outcomes, 
			--					  Archive.SlipOdd.OddValue, Archive.SlipOdd.EventDate, '-' AS Result, 
			--					  Archive.SlipOdd.SpecialBetValue,Archive.SlipOdd.BetradarMatchId
			--					  ,'(matchId:'+cast(Archive.SlipOdd.BetradarMatchId as nvarchar(20))+',sportId:1)' as urllink
			--FROM         Parameter.SlipState INNER JOIN
			--					  Archive.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Archive.SlipOdd.StateId
			--					  INNER JOIN
			--					  Language.[Parameter.OddsType] with (nolock) ON Archive.SlipOdd.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId and  Language.[Parameter.OddsType].LanguageId=@LangId INNER JOIN
			--					  Language.[Parameter.SlipState]  with (nolock)ON Language.[Parameter.SlipState].[SlipStateId]=Parameter.SlipState.StateId LEFT OUTER JOIN Archive.Code ON Archive.Code.MatchId=Archive.SlipOdd.MatchId
			--WHERE     (Archive.SlipOdd.SlipId in (select Customer.SlipSystemSlip.SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=(select top 1 Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SlipId=@SlipId)) )  AND (Archive.SlipOdd.BetTypeId = 2) and Language.[Parameter.SlipState].LanguageId=@LangId
			

		end
	end

END




GO
