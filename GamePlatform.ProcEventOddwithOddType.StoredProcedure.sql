USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcEventOddwithOddType]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcEventOdd]    Script Date: 10/31/2023 6:38:17 AM ******/
CREATE PROCEDURE [GamePlatform].[ProcEventOddwithOddType]
@MatchId bigint,
@OddTypeId int,
@LangId int
AS

BEGIN
SET NOCOUNT ON;

	if exists (Select MatchId from Match.Fixture MF with (nolock) INNER JOIN Match.FixtureDateInfo MFD with (nolock) ON MF.FixtureId=MFD.FixtureId and MF.MatchId=@MatchId and MFD.MatchDate>GETDATE())
SELECT     ROW_NUMBER() over(order by Match.Odd.SpecialBetValue,Match.Odd.OddId) as RowNumber, Match.Odd.OddId,
case when Match.Odd.OddsTypeId  in (1460,1461,1462,1463,1464,1465,1466,1484,1485,1486,1490,1492,1494,1495,1496,1504,1513,1514,1515,1521,1522,1523,1524,1525,1537,1538,1539,1540,1541,1562,1563,1564,1565,1566,1567,1569,1570,1571,1572,1573,1574,1575,1576,1577,1578,1579,1580,1581,1582,1583,1615,1616,1617,1619,1621,1632,1633,1638,1639,1645,1646,1649,1650,1651,1657,1658,1659,1662,1663,1664,1665,1666,1667,1668,1669,1670,1671,1684,1685,1686,1689,1699,1700,1701,1708,1709,1717,1718,1719,1720,1740,1741,1742,1743,1744,1745,1746,1747,1752,1753,1754,1755,1764,1768,1771,1777,1785,1786,1787,1799,1804,1813,1816,1820,1832,1834,1835,1837,1839,1840,1846,1851,1861,1862,1869,1870,1873,1876,1878,1881,1888,1889,1890,1891,1892,1910,1917,1920,1923,1928,1953,1956,1960,1963,1964,1965,1968,1970,1971,1972,1978,1979,1981,1983,1985,1987,1988,1989,1992,1993,1995,1996,1997,1998)
			 then case when Match.Odd.OutCome='1' or Match.Odd.OutCome='home' then '[home!]'
			 else case when Match.Odd.OutCome='2' or Match.Odd.OutCome='away' then '[away!]'
			 else case when   Match.Odd.OutCome='X' or Match.Odd.OutCome='None' or Match.Odd.OutCome='Both teams' then Language.[Parameter.Odds].OutComes else Match.Odd.OutCome end  end end else
			 case when Language.[Parameter.Odds].OutComes is not null Then Language.[Parameter.Odds].OutComes
			 else Match.Odd.OutCome end end as OutCome,
 Match.Odd.OddValue, Match.Match.TournamentId,
   case when Parameter.Odds.OddsId IN (1578,1544,1648,1646,1644,1642,2247,2321,2325,2465,2541,2543,2915,2997,3010,3052,3079,3350,3371,3393)
			   then CAST( cast(Match.Odd.SpecialBetValue AS float)*-1 AS nvarchar(10))
			   else case when Match.Odd.OddsTypeId in (1497,1911,1493,1851,1951,1864,1912,1752,1753,1754,1755) then case when cast(Match.Odd.SpecialBetValue AS float)<0 then  '0:'+CAST( cast(Match.Odd.SpecialBetValue AS float)*-1 AS nvarchar(10)) else  ISNULL(Match.Odd.SpecialBetValue, '')+':0' end else ISNULL(Match.Odd.SpecialBetValue, '')   end end AS SpecialBetValue
			   ,LPO.OddsType
FROM         Match.Odd with (nolock) INNER JOIN
                      Parameter.Odds with (nolock) ON Match.Odd.ParameterOddId = Parameter.Odds.OddsId INNER JOIN
                      Match.Match with (nolock) ON Match.Odd.MatchId = Match.Match.MatchId INNER JOIN
                      Language.[Parameter.Odds] with (nolock) ON Parameter.Odds.OddsId = Language.[Parameter.Odds].OddsId INNER JOIN
					  Language.[Parameter.OddsType] LPO ON LPO.OddsTypeId=Match.Odd.OddsTypeId and LPO.LanguageId=@LangId
WHERE    (Match.Odd.OddsTypeId = @OddTypeId and  Match.Odd.StateId=2) AND (Match.Odd.MatchId = @MatchId) AND (Language.[Parameter.Odds].LanguageId = @LangId) and Match.Odd.OddValue>1 and Match.Odd.StateId=2
Order By Match.Odd.SpecialBetValue,Parameter.Odds.SeqNumber,Match.Odd.OddId



END
GO
