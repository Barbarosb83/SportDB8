USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcOddIdbyInfo]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 
CREATE PROCEDURE [GamePlatform].[ProcOddIdbyInfo] 
@OddId bigint,
@BetType int,
@LangId int	
AS

BEGIN
SET NOCOUNT ON;


declare @LangComp int=@LangId


if(@LangComp not in (2,3,6))
	set @LangComp=2

if (@BetType=0)--pre match
begin
			SELECT DISTINCT 
								  Top  1 Match.Fixture.MatchId, Language.ParameterCompetitor.CompetitorName + '-' + LangComp.CompetitorName AS EventName, Match.Odd.OddId AS OddId1, 
								  Match.Odd.OddValue AS OddValue1,
								    case when Match.Odd.OddsTypeId  in (1460,1461,1462,1463,1464,1465,1466,1484,1485,1486,1490,1492,1494,1495,1496,1504,1513,1514,1515,1521,1522,1523,1524,1525,1537,1538,1539,1540,1541,1562,1563,1564,1565,1566,1567,1568,1569,1570,1571,1572,1573,1574,1575,1576,1577,1578,1579,1580,1581,1582,1583,1615,1616,1617,1619,1621,1632,1633,1638,1639,1645,1646,1649,1650,1651,1657,1658,1659,1662,1663,1664,1665,1666,1667,1668,1669,1670,1671,1684,1685,1686,1689,1699,1700,1701,1708,1709,1717,1718,1719,1720,1740,1741,1742,1743,1744,1745,1746,1747,1752,1753,1754,1755,1764,1768,1771,1777,1785,1786,1787,1799,1804,1813,1816,1820,1832,1834,1835,1837,1839,1840,1846,1851,1861,1862,1869,1870,1873,1876,1878,1881,1888,1889,1890,1891,1892,1910,1917,1920,1923,1928,1953,1956,1960,1963,1964,1965,1968,1970,1971,1972,1978,1979,1981,1983,1985,1987,1988,1989,1992,1993,1995,1996,1997,1998) 
			 then case when
			 /* Match.Odd.OutCome='1' or */ Match.Odd.OutCome='home' then '[home!]' else case when /*Match.Odd.OutCome='2' or */ Match.Odd.OutCome='away' then '[away!]' 
			 else
			  case when  /* Match.Odd.OutCome='X' or */ Match.Odd.OutCome='None' or Match.Odd.OutCome='Both teams' then Language.[Parameter.Odds].OutComes else Match.Odd.OutCome end  end end else 
			 case when
			  Language.[Parameter.Odds].OutComes is not null Then Language.[Parameter.Odds].OutComes 
			 else Match.Odd.OutCome end end as OutCome, 
								  case when Match.Odd.ParameterOddId IN (2892,1578,1544,1648,1646,1644,1642,2247,2321,2325,2465,2541,2543,2915,2973,2993,2997,3010,3052,3079,3350,3371,3393) then '('+CAST( cast(Match.Odd.SpecialBetValue AS float)*-1 AS nvarchar(10))+')' 
								  else case when Match.Odd.SpecialBetValue is null   or Match.Odd.SpecialBetValue ='' then '' 
								  else case when Match.Odd.OddsTypeId in (1497,1911,1493) then case when cast(Match.Odd.SpecialBetValue AS float)<0 then  '0:'+CAST( cast(Match.Odd.SpecialBetValue AS float)*-1 AS nvarchar(10)) else  ISNULL(Match.Odd.SpecialBetValue, '')+':0' end else    '('+Match.Odd.SpecialBetValue+')' end end end AS SpecialBetValue,
								 -- case when Parameter.Odds.OddsId IN (1578,1544,1648,1646,1644,1642,2247,2321,2325,2465,2541,2543,2915,2973,2993,2997,3010,3052,3079,3350,3371,3393) then CAST( cast(Match.Odd.SpecialBetValue AS float)*-1 AS nvarchar(10)) else case when Match.Odd.OddsTypeId=1497 and cast(Match.Odd.SpecialBetValue AS float)<0 then  CAST( cast(Match.Odd.SpecialBetValue AS float)*-1 AS nvarchar(10)) else  ISNULL(Match.Odd.SpecialBetValue, '') end end AS SpecialBetValue,
								   Match.Odd.OddsTypeId, Language.[Parameter.OddsType].OddsType,cast(0 as bit) as Banko,cast(1 as bit) as [Enable],@BetType as BetType
								  ,'' as Visibility, Language.[Parameter.OddsType].ShortOddType,
								  Parameter.Category.SportId,LPT.TournamentName,MFD.MatchDate
								  ,ISNULL((Select JsonData from Parameter.CompetitorJersey where BetradarSuperId=HomeTeam.BetradarSuperId),'') as HomeTeamJersey
								  ,ISNULL((Select JsonData from Parameter.CompetitorJersey where BetradarSuperId=AwayTeam.BetradarSuperId),'') as AwayTeamJersey
			FROM         
								  
								  Match.FixtureCompetitor AS FixtureCompetitor_1 with (nolock)    INNER JOIN
								  Match.Fixture with (nolock) ON  FixtureCompetitor_1.FixtureId = Match.Fixture.FixtureId INNER JOIN
								   Match.FixtureDateInfo MFD with (nolock)  On MFD.FixtureId= Match.Fixture.FixtureId INNER JOIN
								  Match.FixtureCompetitor with (nolock)  ON Match.Fixture.FixtureId = Match.FixtureCompetitor.FixtureId INNER JOIN
								  Match.Odd with (nolock) ON Match.Fixture.MatchId = Match.Odd.MatchId INNER JOIN
								  Language.ParameterCompetitor with (nolock) ON Language.ParameterCompetitor.CompetitorId= FixtureCompetitor_1.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangComp INNER JOIN
								  Parameter.Competitor HomeTeam with (nolock) ON HomeTeam.CompetitorId= FixtureCompetitor_1.CompetitorId  INNER JOIN
								  Language.ParameterCompetitor as LangComp with (nolock) ON LangComp.CompetitorId=  Match.FixtureCompetitor.CompetitorId and LangComp.LanguageId=@LangComp INNER JOIN
								  Parameter.Competitor AwayTeam  with (nolock) ON AwayTeam.CompetitorId=  Match.FixtureCompetitor.CompetitorId  INNER JOIN
								  Language.[Parameter.OddsType] with (nolock) ON Language.[Parameter.OddsType].OddsTypeId=Match.Odd.OddsTypeId AND Language.[Parameter.OddsType].LanguageId=@LangId INNER JOIN
								  Language.[Parameter.Odds] with (nolock) ON Language.[Parameter.Odds].OddsId=Match.Odd.ParameterOddId AND Language.[Parameter.Odds].LanguageId=@LangId INNER JOIN
								  Match.Match On Match.MatchId=Match.Fixture.MatchId INNER JOIN
								  Parameter.Tournament On Parameter.Tournament.TournamentId=Match.Match.TournamentId INNER JOIN
								  Parameter.Category On Parameter.Category.CategoryId=Parameter.Tournament.CategoryId INNER JOIN
								  Language.[Parameter.Tournament] LPT On LPT.TournamentId=Parameter.Tournament.TournamentId and LPT.LanguageId=@LangId
			WHERE     (FixtureCompetitor_1.TypeId = 1) AND (Match.FixtureCompetitor.TypeId = 2) AND Match.Odd.OddId=@OddId
end
else if (@BetType=1)--live
	begin
			Select top 1 Live.EventOdd.MatchId as MatchId, Language.ParameterCompetitor.CompetitorName+'-'+CompetitorAwayLangugage.CompetitorName as EventName,Live.EventOdd.OddId as OddId1,
				Live.EventOdd.OddValue as OddValue1, case when Language.[Parameter.LiveOdds].OutComes like '%player%' then  Live.EventOdd.OutCome else case when Language.[Parameter.LiveOdds].OutComes like '%none%'  then Live.EventOdd.OutCome 
				else case when /*Live.EventOdd.OutCome='1' or */ Live.EventOdd.OutCome='home'  then '[home!]' 
  else case when /*Live.EventOdd.OutCome='2' or */ Live.EventOdd.OutCome='away'  then '[away!]' else   Language.[Parameter.LiveOdds].OutComes end end end end as OutCome,
				case when Live.EventOdd.ParameterOddId in (108,112,116,129,137,143,149,192,387,389,426,428,1947,2059,2503,2505,2553,2965,3257) 
  then CAST( cast(Live.EventOdd.SpecialBetValue AS float)*-1 AS nvarchar(10))
  else case when Live.EventOdd.SpecialBetValue='-1' then  '' else case when Live.EventOdd.SpecialBetValue is null   or Live.EventOdd.SpecialBetValue ='' then '' else case when Live.EventOdd.SpecialBetValue<>'-1' then  ISNULL(Live.EventOdd.SpecialBetValue,'') else case when Live.EventOdd.OddsTypeId in (35) then case when cast(Live.EventOdd.SpecialBetValue AS float)<0 then  '0:'+CAST( cast(Live.EventOdd.SpecialBetValue  AS float)*-1 AS nvarchar(10)) else  ISNULL(Live.EventOdd.SpecialBetValue , '')+':0' end else  '('+Live.EventOdd.SpecialBetValue+')'    end end end  end end as SpecialBetValue
				, Live.EventOdd.OddsTypeId, Language.[Parameter.LiveOddType].OddsType as OddsType,cast(0 as bit) as Banko,cast(1 as bit) as [Enable],@BetType as BetType
	    ,Case when Live.EventOdd.OddValue is null OR Live.EventOdd.OddValue=1 or
		 Live.EventOdd.IsActive=0 or (select  Live.[EventDetail].BetStatus from Live.EventDetail with (nolock) where Live.[EventDetail].BetradarMatchIds=Live.EventOdd.BetradarMatchId)<>2 then 'hidden' else '' end as Visibility
		, Language.[Parameter.LiveOddType].ShortOddType
		,  Parameter.Category.SportId,LPT.TournamentName
		,Live.Event.EventDate as MatchDate
			from Live.EventOdd with (nolock) inner join Live.[Event] with (nolock) on Live.EventOdd.BetradarMatchId=Live.[Event].BetradarMatchId INNER JOIN 
									 
									 Language.ParameterCompetitor with (nolock) ON  Language.ParameterCompetitor.CompetitorId=Live.[Event].HomeTeam AND  Language.ParameterCompetitor.LanguageId=@LangComp INNER JOIN 
									 --Parameter.Competitor  as CompetitorAway with (nolock) on Live.[Event].AwayTeam=CompetitorAway.CompetitorId INNER JOIN
									  Parameter.Tournament On Parameter.Tournament.TournamentId= Live.[Event].TournamentId INNER JOIN
								  Parameter.Category On Parameter.Category.CategoryId=Parameter.Tournament.CategoryId INNER JOIN
								  Language.[Parameter.Tournament] LPT On LPT.TournamentId=Parameter.Tournament.TournamentId and LPT.LanguageId=@LangId INNER JOIN
									 Language.ParameterCompetitor as CompetitorAwayLangugage with (nolock) ON CompetitorAwayLangugage.CompetitorId=Live.[Event].AwayTeam
									 AND  CompetitorAwayLangugage.LanguageId=@LangComp 
									 INNER JOIN	Language.[Parameter.LiveOddType] with (nolock) ON Language.[Parameter.LiveOddType].OddTypeId=Live.EventOdd.OddsTypeId 
									and  Language.[Parameter.LiveOddType].LanguageId=@LangId INNER JOIN
									 Language.[Parameter.LiveOdds] with (nolock) ON Language.[Parameter.LiveOdds].OddsId=Live.EventOdd.ParameterOddId 
									 and Language.[Parameter.LiveOdds].LanguageId=@LangId
			Where Live.EventOdd.OddId=@OddId 
	end
else if (@BetType=2)--outrights
	begin
							SELECT DISTINCT   Outrights.Odd.MatchId,
			 Outrights.[EventName].EventName as EventName, 
             Outrights.Odd.OddId as OddId1,
             Outrights.Odd.OddValue as OddValue1,
             Outrights.Odd.OutCome as OutCome, 
             '' as SpecialBetValue,
             Outrights.Odd.OddsTypeId as  OddTypeId,
              Outrights.EventName.EventName as OddsType,
             cast(0 as bit) as Banko,cast(1 as bit) as [Enable],2 as BetType,'' as Visibility,Outrights.EventName.EventName as ShortOddType
			 ,  0 as SportId,'' as TournamentName,GETDATE() as MatchDate
FROM         Outrights.Odd  INNER JOIN
                    -- Outrights.[Competitor] On Outrights.Competitor.CompetitorId=Outrights.Odd.CompetitorId INNER JOIN
                      Outrights.[Event] ON Outrights.Odd.MatchId = Outrights.[Event].EventId  INNER JOIN
					  Outrights.EventName On Outrights.EventName.EventId=Outrights.Event.EventId and Outrights.EventName.LanguageId=@LangId
WHERE     (Outrights.Odd.OddId=@OddId)   
	end
else if (@BetType=3)--virtual
	begin
			Select Virtual.EventOdd.MatchId as MatchId, Virtual.Team.Team+'-'+CompetitorAway.Team as EventName,Virtual.EventOdd.OddId as OddId1,
				Virtual.EventOdd.OddValue as OddValue1, Virtual.EventOdd.OutCome,Virtual.EventOdd.SpecialBetValue, Virtual.EventOdd.OddsTypeId, Virtual.[Parameter.OddType].OddType as OddsType,cast(0 as bit) as Banko,cast(1 as bit) as [Enable],@BetType as BetType
	   ,'' as Visibility, '' as ShortOddType ,  0 as SportId,'' as TournamentName,GETDATE() as MatchDate
			from Virtual.EventOdd inner join Virtual.[Event] on Virtual.EventOdd.MatchId=Virtual.[Event].EventId INNER JOIN 
									 Virtual.Team on Virtual.[Event].HomeTeam=Virtual.Team.TeamId INNER JOIN									 
									 Virtual.Team as CompetitorAway on Virtual.[Event].AwayTeam=CompetitorAway.TeamId INNER JOIN									 
									 Virtual.[Parameter.OddType] ON Virtual.EventOdd.OddsTypeId = Virtual.[Parameter.OddType].OddTypeId
			Where Virtual.EventOdd.OddId=@OddId
	end


END


GO
