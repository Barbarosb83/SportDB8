USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Virtual].[GamePlatform.ProcEventOdd]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Virtual].[GamePlatform.ProcEventOdd] 
@EventId bigint
AS

BEGIN
SET NOCOUNT ON;

SELECT    ROW_NUMBER() over(partition by Virtual.[Parameter.OddType].OddTypeId order by Virtual.EventOdd.OddId) as RowNumber,
	Virtual.[Parameter.OddType].OddTypeId,Virtual.[Parameter.OddType].OddType,
  Virtual.EventOdd.OddId, Virtual.EventOdd.OutCome,Virtual.EventOdd.OddValue, ISNULL(Virtual.EventOdd.SpecialBetValue,'') as SpecialBetValue,isnull(Virtual.EventOdd.IsChanged,0) as IsChanged
FROM         Virtual.EventOdd INNER JOIN
                      Virtual.[Parameter.OddType] on Virtual.EventOdd.OddsTypeId=Virtual.[Parameter.OddType].OddTypeId inner join
                      Virtual.EventDetail on Virtual.EventDetail.EventId=Virtual.EventOdd.MatchId
WHERE     Virtual.EventOdd.MatchId=@EventId and Virtual.EventOdd.OddValue is not null
and (Virtual.EventOdd.IsActive = 1) AND (Virtual.EventOdd.OddResult IS NULL) AND (Virtual.EventOdd.IsCanceled IS NULL) AND (Virtual.EventOdd.IsEvaluated IS NULL) 
and Virtual.EventDetail.BetStatus=2
order by [Parameter.OddType].OddTypeId, Virtual.EventOdd.OddId





END


GO
