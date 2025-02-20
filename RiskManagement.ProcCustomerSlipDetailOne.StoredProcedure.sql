USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCustomerSlipDetailOne]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [RiskManagement].[ProcCustomerSlipDetailOne] 
@SlipOddId bigint,
@LangId int,
@Username nvarchar(50)
AS

BEGIN
SET NOCOUNT ON;


if exists (select Customer.SlipOdd.SlipId from Customer.SlipOdd with (nolock) where Customer.SlipOdd.SlipOddId=@SlipOddId)
	begin
		SELECT     Parameter.SlipState.StateId, Parameter.SlipState.State, Customer.SlipOdd.EventName+''+ISNULL((select ' ( '+ISNULL(Language.[Parameter.Sport].SportName,'')+' ) ' from Language.[Parameter.Sport] where Language.[Parameter.Sport].SportId=Customer.SlipOdd.SportId and Language.[Parameter.Sport].LanguageId=@LangId),'') as EventName, Language.[Parameter.OddsType].OddsType, 
							  Language.[Parameter.Odds].OutComes+' '+Customer.SlipOdd.SpecialBetValue AS Outcomes, Customer.SlipOdd.OddValue, dbo.UserTimeZoneDate(@Username,Customer.SlipOdd.EventDate,0) as EventDate,
									  ''  AS Result,Customer.SlipOdd.SpecialBetValue,Customer.SlipOdd.OddId,Customer.SlipOdd.OddsTypeId,Customer.SlipOdd.MatchId,Customer.SlipOdd.SlipId,Customer.SlipOdd.SlipOddId,Customer.SlipOdd.BetTypeId
		FROM         Parameter.SlipState with (nolock) INNER JOIN
							  Customer.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Customer.SlipOdd.StateId INNER JOIN
							  Language.[Parameter.OddsType] with (nolock) ON Customer.SlipOdd.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId INNER JOIN
							  Language.[Parameter.Odds] with (nolock) ON Language.[Parameter.Odds].OddsId=Customer.SlipOdd.ParameterOddId
		WHERE     (Customer.SlipOdd.SlipOddId = @SlipOddId) AND (Language.[Parameter.OddsType].LanguageId = @LangId) AND (Customer.SlipOdd.BetTypeId = 0) and Language.[Parameter.Odds].LanguageId=@LangId
		UNION ALL
		SELECT     Parameter.SlipState.StateId, Parameter.SlipState.State, Customer.SlipOdd.EventName+' (Live)',case when Customer.SlipOdd.SpecialBetValue<>'-1' then  Language.[Parameter.LiveOddType].OddsType+' '+Customer.SlipOdd.SpecialBetValue else Language.[Parameter.LiveOddType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI end AS OddsType
						   --,case when (select COUNT(OutCome) from Live.EventOdd where Live.EventOdd.MatchId=Customer.SlipOdd.MatchId and Live.EventOdd.OddsTypeId=Customer.SlipOdd.OddsTypeId and Live.EventOdd.OddResult=1 and ISNULL(Live.EventOdd.SpecialBetValue,'')= case when  Customer.SlipOdd.SpecialBetValue is not null then  Customer.SlipOdd.SpecialBetValue else '' end )>0 then  Customer.SlipOdd.OutCome +' ( '+ISNULL((select top 1 OutCome from Live.EventOdd where Live.EventOdd.MatchId=Customer.SlipOdd.MatchId and Live.EventOdd.OddsTypeId=Customer.SlipOdd.OddsTypeId and Live.EventOdd.OddResult=1 and ISNULL(Live.EventOdd.SpecialBetValue,'')= case when  Customer.SlipOdd.SpecialBetValue is not null then  Customer.SlipOdd.SpecialBetValue else '' end ),'')+' )' 
						   --else case when (select COUNT(OutCome) from Archive.[Live.EventOdd] where Archive.[Live.EventOdd].MatchId=Customer.SlipOdd.MatchId and Archive.[Live.EventOdd].OddsTypeId=Customer.SlipOdd.OddsTypeId and Archive.[Live.EventOdd].OddResult=1 and Archive.[Live.EventOdd].SpecialBetValue=Customer.SlipOdd.SpecialBetValue)>0  then  Language.[Parameter.LiveOdds].OutComes +' ( '+ISNULL((select top 1 OutCome from Archive.[Live.EventOdd] where Archive.[Live.EventOdd].MatchId=Customer.SlipOdd.MatchId and Archive.[Live.EventOdd].OddsTypeId=Customer.SlipOdd.OddsTypeId and Archive.[Live.EventOdd].OddResult=1 and ISNULL(Archive.[Live.EventOdd].SpecialBetValue,'')= case when  Customer.SlipOdd.SpecialBetValue is not null then  Customer.SlipOdd.SpecialBetValue else '' end),'')+' )' else Language.[Parameter.LiveOdds].OutComes end end AS Outcomes
						   ,Customer.SlipOdd.OutCome AS Outcomes
						   , Customer.SlipOdd.OddValue,  dbo.UserTimeZoneDate(@Username,Customer.SlipOdd.EventDate,0) as EventDate, '' AS Result
						   , case when Customer.SlipOdd.SpecialBetValue<>'-1' then Customer.SlipOdd.SpecialBetValue else '' end as SpecialBetValue,Customer.SlipOdd.OddId,Customer.SlipOdd.OddsTypeId,Customer.SlipOdd.MatchId,Customer.SlipOdd.SlipId,Customer.SlipOdd.SlipOddId,Customer.SlipOdd.BetTypeId
		FROM         Parameter.SlipState with (nolock) INNER JOIN
							  Customer.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Customer.SlipOdd.StateId INNER JOIN
							  Live.[Parameter.OddType] with (nolock) ON Customer.SlipOdd.OddsTypeId = Live.[Parameter.OddType].OddTypeId INNER JOIN
							  Language.[Parameter.LiveOddType] with (nolock) ON Language.[Parameter.LiveOddType].OddTypeId=Live.[Parameter.OddType].OddTypeId INNER JOIN
							  Language.[Parameter.LiveOdds] with (nolock) ON Language.[Parameter.LiveOdds].OddsId=Customer.SlipOdd.ParameterOddId
		WHERE     (Customer.SlipOdd.SlipOddId = @SlipOddId) and Customer.SlipOdd.BetTypeId=1 and Language.[Parameter.LiveOddType].LanguageId=@LangId and Language.[Parameter.LiveOdds].LanguageId=@LangId
		--UNION ALL
		--SELECT     Parameter.SlipState.StateId, Parameter.SlipState.State, Customer.SlipOdd.EventName, '' AS OddsType, Customer.SlipOdd.OutCome AS Outcomes, 
		--					  Customer.SlipOdd.OddValue, dbo.UserTimeZoneDate(@Username,Customer.SlipOdd.EventDate,0) as EventDate, '' AS Result, 
		--					  Customer.SlipOdd.SpecialBetValue,Customer.SlipOdd.OddId,Customer.SlipOdd.OddsTypeId,Customer.SlipOdd.MatchId,Customer.SlipOdd.SlipId,Customer.SlipOdd.SlipOddId,Customer.SlipOdd.BetTypeId
		--FROM         Parameter.SlipState INNER JOIN
		--					  Customer.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Customer.SlipOdd.StateId
		--WHERE     (Customer.SlipOdd.SlipOddId = @SlipOddId) AND (Customer.SlipOdd.BetTypeId = 2)
		--UNION ALL
		--SELECT     Parameter.SlipState.StateId, Parameter.SlipState.State, Customer.SlipOdd.EventName, Virtual.[Parameter.OddType].OddType AS OddsType, 
		--					  Customer.SlipOdd.OutCome AS Outcomes, Customer.SlipOdd.OddValue,dbo.UserTimeZoneDate(@Username,Customer.SlipOdd.EventDate,0) as EventDate,Customer.SlipOdd.Score as Result,Customer.SlipOdd.SpecialBetValue
		--					  ,Customer.SlipOdd.OddId,Customer.SlipOdd.OddsTypeId,Customer.SlipOdd.MatchId,Customer.SlipOdd.SlipId,Customer.SlipOdd.SlipOddId,Customer.SlipOdd.BetTypeId
		--FROM         Parameter.SlipState INNER JOIN
		--					  Customer.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Customer.SlipOdd.StateId INNER JOIN
		--					  Virtual.[Parameter.OddType] ON Customer.SlipOdd.OddsTypeId = Virtual.[Parameter.OddType].OddTypeId
		--WHERE     (Customer.SlipOdd.SlipOddId = @SlipOddId) and Customer.SlipOdd.BetTypeId=3
		end
else
	begin
		SELECT     Parameter.SlipState.StateId, Parameter.SlipState.State, Archive.SlipOdd.EventName+''+ISNULL((select ' ( '+ISNULL(Language.[Parameter.Sport].SportName,'')+' ) ' from Language.[Parameter.Sport] where Language.[Parameter.Sport].SportId=Archive.SlipOdd.SportId and Language.[Parameter.Sport].LanguageId=@LangId),'') as EventName, Language.[Parameter.OddsType].OddsType, 
                      Language.[Parameter.Odds].OutComes+' '+Archive.SlipOdd.SpecialBetValue AS Outcomes, Archive.SlipOdd.OddValue, dbo.UserTimeZoneDate(@Username,Archive.SlipOdd.EventDate,0) as EventDate,
							  ''  AS Result,Archive.SlipOdd.SpecialBetValue,Archive.SlipOdd.OddId,Archive.SlipOdd.OddsTypeId,Archive.SlipOdd.MatchId,Archive.SlipOdd.SlipId,Archive.SlipOdd.SlipOddId,Archive.SlipOdd.BetTypeId
		FROM         Parameter.SlipState INNER JOIN
							  Archive.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Archive.SlipOdd.StateId INNER JOIN
							  Language.[Parameter.OddsType] with (nolock) ON Archive.SlipOdd.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId INNER JOIN
							  Language.[Parameter.Odds] with (nolock) ON Language.[Parameter.Odds].OddsId=Archive.SlipOdd.ParameterOddId
		WHERE     (Archive.SlipOdd.SlipOddId = @SlipOddId) AND (Language.[Parameter.OddsType].LanguageId = @LangId) AND (Archive.SlipOdd.BetTypeId = 0) and Language.[Parameter.Odds].LanguageId=@LangId
		UNION ALL
		SELECT     Parameter.SlipState.StateId, Parameter.SlipState.State, Archive.SlipOdd.EventName+' (Live)',case when Archive.SlipOdd.SpecialBetValue<>'-1' then  Language.[Parameter.LiveOddType].OddsType+' '+Archive.SlipOdd.SpecialBetValue else Language.[Parameter.LiveOddType].OddsType COLLATE SQL_Latin1_General_CP1253_CI_AI end AS OddsType
						   --,case when (select COUNT(OutCome) from Live.EventOdd where Live.EventOdd.MatchId=Archive.SlipOdd.MatchId and Live.EventOdd.OddsTypeId=Archive.SlipOdd.OddsTypeId and Live.EventOdd.OddResult=1 and ISNULL(Live.EventOdd.SpecialBetValue,'')= case when  Archive.SlipOdd.SpecialBetValue is not null then  Archive.SlipOdd.SpecialBetValue else '' end )>0 then  Archive.SlipOdd.OutCome +' ( '+ISNULL((select top 1 OutCome from Live.EventOdd where Live.EventOdd.MatchId=Archive.SlipOdd.MatchId and Live.EventOdd.OddsTypeId=Archive.SlipOdd.OddsTypeId and Live.EventOdd.OddResult=1 and ISNULL(Live.EventOdd.SpecialBetValue,'')= case when  Archive.SlipOdd.SpecialBetValue is not null then  Archive.SlipOdd.SpecialBetValue else '' end ),'')+' )' 
						   --else case when (select COUNT(OutCome) from Archive.[Live.EventOdd] where Archive.[Live.EventOdd].MatchId=Archive.SlipOdd.MatchId and Archive.[Live.EventOdd].OddsTypeId=Archive.SlipOdd.OddsTypeId and Archive.[Live.EventOdd].OddResult=1 and Archive.[Live.EventOdd].SpecialBetValue=Archive.SlipOdd.SpecialBetValue)>0  then  Language.[Parameter.LiveOdds].OutComes +' ( '+ISNULL((select top 1 OutCome from Archive.[Live.EventOdd] where Archive.[Live.EventOdd].MatchId=Archive.SlipOdd.MatchId and Archive.[Live.EventOdd].OddsTypeId=Archive.SlipOdd.OddsTypeId and Archive.[Live.EventOdd].OddResult=1 and ISNULL(Archive.[Live.EventOdd].SpecialBetValue,'')= case when  Archive.SlipOdd.SpecialBetValue is not null then  Archive.SlipOdd.SpecialBetValue else '' end),'')+' )' else Language.[Parameter.LiveOdds].OutComes end end AS Outcomes
						   ,Archive.SlipOdd.OutCome as Outcomes
						   , Archive.SlipOdd.OddValue,  dbo.UserTimeZoneDate(@Username,Archive.SlipOdd.EventDate,0) as EventDate, '' AS Result
						   , case when Archive.SlipOdd.SpecialBetValue<>'-1' then Archive.SlipOdd.SpecialBetValue else '' end as SpecialBetValue,Archive.SlipOdd.OddId,Archive.SlipOdd.OddsTypeId,Archive.SlipOdd.MatchId,Archive.SlipOdd.SlipId,Archive.SlipOdd.SlipOddId,Archive.SlipOdd.BetTypeId
		FROM         Parameter.SlipState INNER JOIN
							  Archive.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Archive.SlipOdd.StateId INNER JOIN
							  Live.[Parameter.OddType] with (nolock) ON Archive.SlipOdd.OddsTypeId = Live.[Parameter.OddType].OddTypeId INNER JOIN
							  Language.[Parameter.LiveOddType] with (nolock) ON Language.[Parameter.LiveOddType].OddTypeId=Live.[Parameter.OddType].OddTypeId INNER JOIN
							  Language.[Parameter.LiveOdds] with (nolock) ON Language.[Parameter.LiveOdds].OddsId=Archive.SlipOdd.ParameterOddId
		WHERE     (Archive.SlipOdd.SlipOddId = @SlipOddId) and Archive.SlipOdd.BetTypeId=1 and Language.[Parameter.LiveOddType].LanguageId=@LangId and Language.[Parameter.LiveOdds].LanguageId=@LangId
		UNION ALL
		SELECT     Parameter.SlipState.StateId, Parameter.SlipState.State, Archive.SlipOdd.EventName, '' AS OddsType, Archive.SlipOdd.OutCome AS Outcomes, 
							  Archive.SlipOdd.OddValue, dbo.UserTimeZoneDate(@Username,Archive.SlipOdd.EventDate,0) as EventDate, '' AS Result, 
							  Archive.SlipOdd.SpecialBetValue,Archive.SlipOdd.OddId,Archive.SlipOdd.OddsTypeId,Archive.SlipOdd.MatchId,Archive.SlipOdd.SlipId,Archive.SlipOdd.SlipOddId,Archive.SlipOdd.BetTypeId
		FROM         Parameter.SlipState with (nolock) INNER JOIN
							  Archive.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Archive.SlipOdd.StateId
		WHERE     (Archive.SlipOdd.SlipOddId = @SlipOddId) AND (Archive.SlipOdd.BetTypeId = 2)
		--UNION ALL
		--SELECT     Parameter.SlipState.StateId, Parameter.SlipState.State, Archive.SlipOdd.EventName, Virtual.[Parameter.OddType].OddType AS OddsType, 
		--					  Archive.SlipOdd.OutCome AS Outcomes, Archive.SlipOdd.OddValue,dbo.UserTimeZoneDate(@Username,Archive.SlipOdd.EventDate,0) as EventDate,Archive.SlipOdd.Score as Result,Archive.SlipOdd.SpecialBetValue
		--					  ,Archive.SlipOdd.OddId,Archive.SlipOdd.OddsTypeId,Archive.SlipOdd.MatchId,Archive.SlipOdd.SlipId,Archive.SlipOdd.SlipOddId,Archive.SlipOdd.BetTypeId
		--FROM         Parameter.SlipState INNER JOIN
		--					  Archive.SlipOdd with (nolock) ON Parameter.SlipState.StateId = Archive.SlipOdd.StateId INNER JOIN
		--					  Virtual.[Parameter.OddType] ON Archive.SlipOdd.OddsTypeId = Virtual.[Parameter.OddType].OddTypeId
		--WHERE     (Archive.SlipOdd.SlipOddId = @SlipOddId) and Archive.SlipOdd.BetTypeId=3
	
	
	end
	
END


GO
