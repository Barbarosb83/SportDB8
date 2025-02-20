USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcEventOdd_OLD]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Retail].[ProcEventOdd_OLD] 
@MatchId bigint,
@OddTypeId int,
@BetType int,
@LangId int
AS

BEGIN
SET NOCOUNT ON;



if (@BetType=0)
SELECT    Match.Odd.OddId,
case when Match.Odd.OddsTypeId  in (1460,1461,1462,1463,1464,1465,1466,1484,1485,1486,1490,1492,1494,1495,1496,1504,1513,1514,1515,1521,1522,1523,1524,1525,1537,1538,1539,1540,1541,1562,1563,1564,1565,1566,1567,1568,1569,1570,1571,1572,1573,1574,1575,1576,1577,1578,1579,1580,1581,1582,1583,1615,1616,1617,1619,1621,1632,1633,1638,1639,1645,1646,1649,1650,1651,1657,1658,1659,1662,1663,1664,1665,1666,1667,1668,1669,1670,1671,1684,1685,1686,1689,1699,1700,1701,1708,1709,1717,1718,1719,1720,1740,1741,1742,1743,1744,1745,1746,1747,1752,1753,1754,1755,1764,1768,1771,1777,1785,1786,1787,1799,1804,1813,1816,1820,1832,1834,1835,1837,1839,1840,1846,1851,1861,1862,1869,1870,1873,1876,1878,1881,1888,1889,1890,1891,1892,1910,1917,1920,1923,1928,1953,1956,1960,1963,1964,1965,1968,1970,1971,1972,1978,1979,1981,1983,1985,1987,1988,1989,1992,1993,1995,1996,1997,1998) 
			 then case when Match.Odd.OutCome='1' or Match.Odd.OutCome='home' then '[home!]' 
			 else case when Match.Odd.OutCome='2' or Match.Odd.OutCome='away' then '[away!]' 
			 else case when   Match.Odd.OutCome='X' or Match.Odd.OutCome='None' or Match.Odd.OutCome='Both teams' then Language.[Parameter.Odds].OutComes else Match.Odd.OutCome end  end end else 
			 case when Language.[Parameter.Odds].OutComes is not null Then Language.[Parameter.Odds].OutComes 
			 else Match.Odd.OutCome end end as OutCome,
 Match.Odd.OddValue,
  case when Parameter.Odds.OddsId IN (1578,1544,1540,1648,1646,1644,1642,2247,2892,2321,2325,2465,2541,2543,2915,2973,2993,2997,3010,3052,3079,3350,3371,3393) then CAST( cast(Match.Odd.SpecialBetValue AS float)*-1 AS nvarchar(10)) else ISNULL(Match.Odd.SpecialBetValue, '') end AS SpecialBetValue
FROM            Match.Odd with (nolock) INNER JOIN
                      Parameter.Odds with (nolock) ON Match.Odd.ParameterOddId = Parameter.Odds.OddsId INNER JOIN
                      Match.Match with (nolock) ON Match.Odd.MatchId = Match.Match.MatchId INNER JOIN
                      Parameter.OddsType with (nolock) ON Parameter.OddsType.OddsTypeId = Parameter.Odds.OddTypeId INNER JOIN
                      Language.[Parameter.OddsType] with (nolock) ON Parameter.OddsType.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId INNER JOIN
                      Match.OddTypeSetting with (nolock) ON Language.[Parameter.OddsType].OddsTypeId = Match.OddTypeSetting.OddTypeId AND 
                      Match.OddTypeSetting.MatchId = Match.Match.MatchId INNER JOIN
                      Language.[Parameter.Odds] ON Parameter.Odds.OddsId = Language.[Parameter.Odds].OddsId AND 
                      Language.[Parameter.OddsType].LanguageId = Language.[Parameter.Odds].LanguageId  
WHERE    (Match.Odd.OddsTypeId = @OddTypeId) AND (Match.Odd.MatchId = @MatchId) AND (Language.[Parameter.Odds].LanguageId = @LangId) and Match.Odd.OddValue>1 AND (Match.OddTypeSetting.StateId = 2)  AND Parameter.OddsType.IsActive=1 and
                      (Language.[Parameter.OddsType].LanguageId = @LangId)


else if  (@BetType=1)
SELECT    Live.EventOdd.OddId,
  case when Language.[Parameter.LiveOdds].OutComes like '%player%' 
  then  Live.EventOdd.OutCome 
  else case when Language.[Parameter.LiveOdds].OutComes like '%none%'  
  then Live.EventOdd.OutCome 
  else case when Live.[Parameter.OddType].OddTypeId  in (21,22,25,29,30,62,121,122,119,123,124,125,126,127,128,129,132,133,134,135,136,137,141,142,149,150,151,152,153,155,156,157,158,160,161,203,212,239,241,270,294,295,296,297,298,299,300,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326,327,328,329,330,331,332,333,334,335,336,337,338,339,340,341,342,343,344,345,346,347,348,349,350,351,352,353,354,355,356,357,358,359,360,361,362,363,364,365,366,367,368,369,370,371,372,373,374,375,376,377,378,379,380,381,382,383,384,385,386,387,388,389,390,391,392,393,394,395,396,397,398,399,400,401,402,403,404,405,406,407,408,409,410,411,412,413,414,415,416,417,418,419,420,421,422,423,424,454,464,512,513,521,526,527,545,549,550,566,569,570,571,611,608,740) then Language.[Parameter.LiveOdds].OutComes 
  else case when Live.EventOdd.OutCome='1' or Live.EventOdd.OutCome='home'  then '[home!]' 
  else case when Live.EventOdd.OutCome='2' or Live.EventOdd.OutCome='away'  then '[away!]'
  else case when  Live.[Parameter.OddType].OddTypeId not in (103,102,90,91,98) then Language.[Parameter.LiveOdds].OutComes  else Live.EventOdd.OutCome end end end end  end end as OutCome
 ,Live.EventOdd.OddValue,
  case when Live.EventOdd.ParameterOddId in (108,112,116,129,137,143,149,192,387,389,426,428,1947,2059,2503,2505,2553,2965,3257) 
  then CAST( cast(Live.EventOdd.SpecialBetValue AS float)*-1 AS nvarchar(10))
  else case when Live.EventOdd.SpecialBetValue<>'-1' then  ISNULL(Live.EventOdd.SpecialBetValue,'') else '' end end as SpecialBetValue
FROM         Live.EventOdd with (nolock) INNER JOIN
                      Live.[Parameter.OddType] with (nolock) on Live.EventOdd.OddsTypeId=Live.[Parameter.OddType].OddTypeId inner join
                      Live.EventDetail with (nolock) on Live.EventDetail.EventId=Live.EventOdd.MatchId INNER JOIN
                      Language.[Parameter.LiveOddType] with (nolock) ON Language.[Parameter.LiveOddType].OddTypeId=Live.[Parameter.OddType].OddTypeId inner join
                      live.[Parameter.Odds] with (nolock) ON live.[Parameter.Odds].OddsId=Live.EventOdd.ParameterOddId
                       INNER JOIN
                      Language.[Parameter.LiveOdds] with (nolock) ON Language.[Parameter.LiveOdds].OddsId=live.[Parameter.Odds].OddsId 
                      and Language.[Parameter.LiveOdds].LanguageId=Language.[Parameter.LiveOddType].LanguageId
WHERE     Live.EventOdd.MatchId=@MatchId 
and Live.EventOdd.OddValue is not null
and (Live.EventOdd.IsActive = 1) 
--AND (Live.EventOdd.OddResult IS NULL) AND (Live.EventOdd.IsCanceled IS NULL) AND (Live.EventOdd.IsEvaluated IS NULL) 
and (select count(Live.EventOddResult.OddId) from Live.EventOddResult with (nolock) where Live.EventOddResult.OddId=Live.EventOdd.OddId)=0
--and Live.EventDetail.BetStatus=2 
and Language.[Parameter.LiveOddType].LanguageId=@LangId and  Live.[Parameter.OddType].IsActive=1 
and Live.EventOdd.OddsTypeId=@OddTypeId --and Live.[Parameter.OddType].OddTypeId=@LangId
else 
SELECT   
        DISTINCT     Outrights.Odd.OddId,  Outrights.Odd.OutCome as OutCome, 
             Outrights.Odd.OddValue,
          
               ''  as SpecialBetValue
              
FROM         Outrights.Odd   INNER JOIN
                    -- Outrights.[Competitor] On Outrights.Competitor.CompetitorId=Outrights.Odd.CompetitorId INNER JOIN
                      Outrights.[Event] ON Outrights.Odd.MatchId = Outrights.[Event].EventId  INNER JOIN
					  Outrights.EventName On Outrights.EventName.EventId=Outrights.Event.EventId and Outrights.EventName.LanguageId=@LangId

                     -- INNER JOIN Outrights.OddTypeSetting ON  Outrights.OddTypeSetting.MatchId = Outrights.[Event].EventId and Outrights.OddTypeSetting.OddTypeId=Outrights.Odd.OddsTypeId 
				--  [Parameter].[Competitor] as PC On PC.BetradarSuperId=Outrights.Competitor.CompetitorBetradarId 
                  --    inner join Language.[ParameterCompetitor] on PC.CompetitorId=Language.[ParameterCompetitor].CompetitorId 
					--  and Language.[ParameterCompetitor].LanguageId=2
WHERE     (Outrights.[Event].EventId = @MatchId)  and OddValue>1 and  Outrights.[Event].IsActive=1 and Outrights.Odd.OddsTypeId=@OddTypeId
order by Outrights.Odd.OddValue




END


GO
