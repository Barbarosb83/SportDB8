USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Dashboard].[ProcTop10LiveStake]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Dashboard].[ProcTop10LiveStake] 
@Username nvarchar(50),
@LangId int
AS

BEGIN
SET NOCOUNT ON;



declare @TempMatch table (MatchId bigint,Amount money)



insert @TempMatch
select top 50 MatchId,SUM(Customer.Slip.Amount) from Customer.SlipOdd with (nolock) INNER JOIN Customer.Slip with (nolock) On Customer.Slip.SlipId=Customer.SlipOdd.SlipId where BetTypeId=1 and Customer.Slip.SlipStateId=1 GROUP BY MatchId OrDER BY SUM(Customer.Slip.Amount) desc 
 
 
  SELECT top 10    Live.EventDetail.EventId,
			 Parameter.Competitor.CompetitorName +'-'+ CompetiTip_1.CompetitorName AS AwayTeam,TMP.Amount
 FROM         Live.Event with (nolock) INNER JOIN 
                       Live.EventDetail with (nolock) ON Live.[Event].EventId = Live.EventDetail.EventId INNER JOIN 
                       Parameter.Competitor with (nolock) ON    Parameter.Competitor.CompetitorId =Live.[Event].HomeTeam INNER JOIN 
                       Parameter.Competitor AS CompetiTip_1 with (nolock) ON  CompetiTip_1.CompetitorId=Live.[Event].AwayTeam   inner join 
					   Parameter.Tournament with (nolock) On Parameter.Tournament.TournamentId=Live.Event.TournamentId INNER JOIN 
					   Parameter.Category with (nolock) ON Parameter.Category.CategoryId=Parameter.Tournament.CategoryId INNER JOIN  
					   [Language].[Parameter.Sport] with (nolock) On [Language].[Parameter.Sport].SportId=Parameter.Category.SportId and [Language].[Parameter.Sport].LanguageId=3
					   INNER JOIN @TempMatch as TMP On TMP.MatchId=Live.Event.EventId
   Order By TMP.Amount desc

END


GO
