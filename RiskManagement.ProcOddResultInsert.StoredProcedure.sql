USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcOddResultInsert]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcOddResultInsert]
@MatchId int,
@MatchTimeTypeId int,
@Score nvarchar(20),
@HomeScore int,
@AwayScore int


AS
    

declare @SportId int


SELECT     @SportId=Parameter.Category.SportId
FROM         Match.Match INNER JOIN
                      Parameter.Tournament ON Match.Match.TournamentId = Parameter.Tournament.TournamentId AND 
                      Match.Match.TournamentId = Parameter.Tournament.TournamentId INNER JOIN
                      Parameter.Category ON Parameter.Tournament.CategoryId = Parameter.Category.CategoryId AND Parameter.Tournament.CategoryId = Parameter.Category.CategoryId
where Match.Match.MatchId=@MatchId


--Eğer gelen score futbol maçına aitse futbola ait oddlar bulunuyor.
if(@SportId=1)
	Begin
		declare @WhoWin nvarchar(4)='X' --0 ise beraberlik 1 ise ev sahibi,2 ise deplasman kazandı
		declare @WhoWin2 nvarchar(4)='1X'
		declare @WhoWin3 nvarchar(4)='X2'
		
		
		--- 1.kural skorun büyük küçük ve eşit olması
		if(@HomeScore>@AwayScore)
			Begin
				set @WhoWin='1'
				set @WhoWin2='1X'
				set @WhoWin3='12'
			end
		else if (@AwayScore>@HomeScore)
				Begin
					set @WhoWin='2'
					set @WhoWin2='X2'
					set @WhoWin3='12'
				end
		
		insert Match.OddsResult (MatchId,OddsTypeId,Outcome,SpecialBetValue)
		SELECT     Match.Odd.MatchId,Match.Odd.OddsTypeId, Match.Odd.OutCome,Match.Odd.SpecialBetValue 
			FROM   Match.Odd INNER JOIN
            Parameter.Odds ON Match.Odd.ParameterOddId = Parameter.Odds.OddsId
			where MatchId=@MatchId and MatchTimeTypeId=@MatchTimeTypeId and Parameter.Odds.OddTypeId in (1462,1683,1481,1839,1861,1615,1702)  and 
			(Match.Odd.OutCome=@WhoWin or Match.Odd.OutCome=@WhoWin2 or Match.Odd.OutCome=@WhoWin3)
------------------------------------------------------------


----- Over Under sonuçlarını girme ------
insert Match.OddsResult (MatchId,OddsTypeId,Outcome,SpecialBetValue)
		SELECT     Match.Odd.MatchId,Match.Odd.OddsTypeId, Match.Odd.OutCome,Match.Odd.SpecialBetValue 
			FROM   Match.Odd INNER JOIN
            Parameter.Odds ON Match.Odd.ParameterOddId = Parameter.Odds.OddsId
			where MatchId=@MatchId and MatchTimeTypeId=@MatchTimeTypeId and Parameter.Odds.OddTypeId in (1642,1516,1644)  and
			(Match.Odd.OutCome='Over' and cast(Match.Odd.SpecialBetValue as FLOat)<(@HomeScore+@AwayScore)) or
			(Match.Odd.OutCome='Under' and cast(Match.Odd.SpecialBetValue as FLOat)>(@HomeScore+@AwayScore))
-----------------------------------------------------------------------------

----- Maç skoruna göre sonuçlarını girme ------
insert Match.OddsResult (MatchId,OddsTypeId,Outcome,SpecialBetValue)
		SELECT     Match.Odd.MatchId,Match.Odd.OddsTypeId, Match.Odd.OutCome,Match.Odd.SpecialBetValue 
			FROM   Match.Odd INNER JOIN
            Parameter.Odds ON Match.Odd.ParameterOddId = Parameter.Odds.OddsId
			where MatchId=@MatchId and MatchTimeTypeId=@MatchTimeTypeId and Parameter.Odds.OddTypeId in (1520,1772,1694,1769,1833,1838,1782,1783) and
			Match.Odd.OutCome=cast(@HomeScore as nvarchar)+':'+cast(@AwayScore as nvarchar) 
			
------------------------------------------------------------------------------

----- Toplam gol sayısına göre sonuçlarını girme ------
declare @totalgoal nvarchar(4)='0'
set @totalgoal=@HomeScore+@AwayScore


insert Match.OddsResult (MatchId,OddsTypeId,Outcome,SpecialBetValue)
		SELECT     Match.Odd.MatchId,Match.Odd.OddsTypeId, Match.Odd.OutCome,Match.Odd.SpecialBetValue 
			FROM   Match.Odd INNER JOIN
            Parameter.Odds ON Match.Odd.ParameterOddId = Parameter.Odds.OddsId
			where MatchId=@MatchId and MatchTimeTypeId=@MatchTimeTypeId and Parameter.Odds.OddTypeId in (1628,1614,1629) and
			replace(Match.Odd.OutCome,'+','')=@totalgoal 			
	 
-----------------------------------------------------------------------------------

----- Ev   sahibi takımının gol sayısına göre sonuçlarını girme ------
 

insert Match.OddsResult (MatchId,OddsTypeId,Outcome,SpecialBetValue)
		SELECT     Match.Odd.MatchId,Match.Odd.OddsTypeId, Match.Odd.OutCome,Match.Odd.SpecialBetValue 
			FROM   Match.Odd INNER JOIN
            Parameter.Odds ON Match.Odd.ParameterOddId = Parameter.Odds.OddsId
			where MatchId=@MatchId and MatchTimeTypeId=@MatchTimeTypeId and Parameter.Odds.OddTypeId in (1487) and
			replace(Match.Odd.OutCome,'+','')=@HomeScore 			
	 
-----------------------------------------------------------------------------------

----- Deplasman takımının gol sayısına göre sonuçlarını girme ------
 

insert Match.OddsResult (MatchId,OddsTypeId,Outcome,SpecialBetValue)
		SELECT     Match.Odd.MatchId,Match.Odd.OddsTypeId, Match.Odd.OutCome,Match.Odd.SpecialBetValue 
			FROM   Match.Odd INNER JOIN
            Parameter.Odds ON Match.Odd.ParameterOddId = Parameter.Odds.OddsId
			where MatchId=@MatchId and MatchTimeTypeId=@MatchTimeTypeId and Parameter.Odds.OddTypeId in (1488) and
			replace(Match.Odd.OutCome,'+','')=@AwayScore 			
	 
-----------------------------------------------------------------------------------


----- Beraberlik iade (Draw no bet) sonuçlarını girme ------

if(@WhoWin='X')
begin
insert Match.OddsResult (MatchId,OddsTypeId,Outcome,SpecialBetValue,VoidFactor)
		SELECT     Match.Odd.MatchId,Match.Odd.OddsTypeId, Match.Odd.OutCome,Match.Odd.SpecialBetValue,1 
			FROM   Match.Odd INNER JOIN
            Parameter.Odds ON Match.Odd.ParameterOddId = Parameter.Odds.OddsId
			where MatchId=@MatchId and MatchTimeTypeId=@MatchTimeTypeId and Parameter.Odds.OddTypeId in (1686,1484) and
			Match.Odd.OutCome='1' and Match.Odd.OutCome='2'			
end	
else
begin
insert Match.OddsResult (MatchId,OddsTypeId,Outcome,SpecialBetValue)
		SELECT     Match.Odd.MatchId,Match.Odd.OddsTypeId, Match.Odd.OutCome,Match.Odd.SpecialBetValue
			FROM   Match.Odd INNER JOIN
            Parameter.Odds ON Match.Odd.ParameterOddId = Parameter.Odds.OddsId
			where MatchId=@MatchId and MatchTimeTypeId=@MatchTimeTypeId and Parameter.Odds.OddTypeId in (1686,1484,1699) and
			Match.Odd.OutCome=@WhoWin	
end		
 -----------------------------------------------------------------------------------
 
 ----- Home no bet (Draw no bet) sonuçlarını girme ------

if(@WhoWin='1')
begin
insert Match.OddsResult (MatchId,OddsTypeId,Outcome,SpecialBetValue,VoidFactor)
		SELECT     Match.Odd.MatchId,Match.Odd.OddsTypeId, Match.Odd.OutCome,Match.Odd.SpecialBetValue,1 
			FROM   Match.Odd INNER JOIN
            Parameter.Odds ON Match.Odd.ParameterOddId = Parameter.Odds.OddsId
			where MatchId=@MatchId and MatchTimeTypeId=@MatchTimeTypeId and Parameter.Odds.OddTypeId in (1786) and
			Match.Odd.OutCome='X' and Match.Odd.OutCome='2'			
end	
else
begin
insert Match.OddsResult (MatchId,OddsTypeId,Outcome,SpecialBetValue)
		SELECT     Match.Odd.MatchId,Match.Odd.OddsTypeId, Match.Odd.OutCome,Match.Odd.SpecialBetValue
			FROM   Match.Odd INNER JOIN
            Parameter.Odds ON Match.Odd.ParameterOddId = Parameter.Odds.OddsId
			where MatchId=@MatchId and MatchTimeTypeId=@MatchTimeTypeId and Parameter.Odds.OddTypeId in (1786) and
			Match.Odd.OutCome=@WhoWin	
end		
 -----------------------------------------------------------------------------------
 
 ----- Away no bet (Away no bet) sonuçlarını girme ------

if(@WhoWin='2')
begin
insert Match.OddsResult (MatchId,OddsTypeId,Outcome,SpecialBetValue,VoidFactor)
		SELECT     Match.Odd.MatchId,Match.Odd.OddsTypeId, Match.Odd.OutCome,Match.Odd.SpecialBetValue,1 
			FROM   Match.Odd INNER JOIN
            Parameter.Odds ON Match.Odd.ParameterOddId = Parameter.Odds.OddsId
			where MatchId=@MatchId and MatchTimeTypeId=@MatchTimeTypeId and Parameter.Odds.OddTypeId in (1787) and
			Match.Odd.OutCome='X' and Match.Odd.OutCome='1'			
end	
else
begin
insert Match.OddsResult (MatchId,OddsTypeId,Outcome,SpecialBetValue)
		SELECT     Match.Odd.MatchId,Match.Odd.OddsTypeId, Match.Odd.OutCome,Match.Odd.SpecialBetValue
			FROM   Match.Odd INNER JOIN
            Parameter.Odds ON Match.Odd.ParameterOddId = Parameter.Odds.OddsId
			where MatchId=@MatchId and MatchTimeTypeId=@MatchTimeTypeId and Parameter.Odds.OddTypeId in (1788) and
			Match.Odd.OutCome=@WhoWin	
end		
 -----------------------------------------------------------------------------------
 
 
 ----- Both Teams to score (iki takımda gol atar) sonuçlarını girme ------
 declare @BothTeamsScore nvarchar(3)='No'

if(@HomeScore>0 and @AwayScore>0)
set @BothTeamsScore='Yes'

insert Match.OddsResult (MatchId,OddsTypeId,Outcome,SpecialBetValue)
		SELECT     Match.Odd.MatchId,Match.Odd.OddsTypeId, Match.Odd.OutCome,Match.Odd.SpecialBetValue 
			FROM   Match.Odd INNER JOIN
            Parameter.Odds ON Match.Odd.ParameterOddId = Parameter.Odds.OddsId
			where MatchId=@MatchId and MatchTimeTypeId=@MatchTimeTypeId and Parameter.Odds.OddTypeId in (1690,1467,1691) and
			Match.Odd.OutCome=@BothTeamsScore			
 -----------------------------------------------------------------------------------

----- Ev sahibi takım Over Under sonuçlarını girme ------
insert Match.OddsResult (MatchId,OddsTypeId,Outcome,SpecialBetValue)
		SELECT     Match.Odd.MatchId,Match.Odd.OddsTypeId, Match.Odd.OutCome,Match.Odd.SpecialBetValue 
			FROM   Match.Odd INNER JOIN
            Parameter.Odds ON Match.Odd.ParameterOddId = Parameter.Odds.OddsId
			where MatchId=@MatchId and MatchTimeTypeId=@MatchTimeTypeId and Parameter.Odds.OddTypeId in (1773,1739,1778)  and
			(Match.Odd.OutCome='Over' and cast(Match.Odd.SpecialBetValue as FLOat)<(@HomeScore)) or
			(Match.Odd.OutCome='Under' and cast(Match.Odd.SpecialBetValue as FLOat)>(@HomeScore))
-----------------------------------------------------------------------------

----- Deplasman takım Over/Under sonuçlarını girme ------
insert Match.OddsResult (MatchId,OddsTypeId,Outcome,SpecialBetValue)
		SELECT     Match.Odd.MatchId,Match.Odd.OddsTypeId, Match.Odd.OutCome,Match.Odd.SpecialBetValue 
			FROM   Match.Odd INNER JOIN
            Parameter.Odds ON Match.Odd.ParameterOddId = Parameter.Odds.OddsId
			where MatchId=@MatchId and MatchTimeTypeId=@MatchTimeTypeId and Parameter.Odds.OddTypeId in (1774,1732,1779)  and
			(Match.Odd.OutCome='Over' and cast(Match.Odd.SpecialBetValue as FLOat)<(@AwayScore)) or
			(Match.Odd.OutCome='Under' and cast(Match.Odd.SpecialBetValue as FLOat)>(@AwayScore))
-----------------------------------------------------------------------------


----- ilkyarı kazanan takım ve over/under sonuçlarını girme ------
declare @MatchbetAndTotals nvarchar(100)='Under and draw'

	if(@WhoWin='1')
	begin
		insert Match.OddsResult (MatchId,OddsTypeId,Outcome,SpecialBetValue)
		SELECT     Match.Odd.MatchId,Match.Odd.OddsTypeId, Match.Odd.OutCome,Match.Odd.SpecialBetValue 
			FROM   Match.Odd INNER JOIN
            Parameter.Odds ON Match.Odd.ParameterOddId = Parameter.Odds.OddsId
			where MatchId=@MatchId and MatchTimeTypeId=@MatchTimeTypeId and Parameter.Odds.OddTypeId in (1792,1531)  and
			(Match.Odd.OutCome='Over and home' and cast(Match.Odd.SpecialBetValue as FLOat)<(@AwayScore+@HomeScore)) or
			(Match.Odd.OutCome='Under and home' and cast(Match.Odd.SpecialBetValue as FLOat)>(@AwayScore+@HomeScore))
	end
	else if(@WhoWin='2')
	begin
		
		insert Match.OddsResult (MatchId,OddsTypeId,Outcome,SpecialBetValue)
		SELECT     Match.Odd.MatchId,Match.Odd.OddsTypeId, Match.Odd.OutCome,Match.Odd.SpecialBetValue 
			FROM   Match.Odd INNER JOIN
            Parameter.Odds ON Match.Odd.ParameterOddId = Parameter.Odds.OddsId
			where MatchId=@MatchId and MatchTimeTypeId=@MatchTimeTypeId and Parameter.Odds.OddTypeId in (1792)  and
			(Match.Odd.OutCome='Over and away' and cast(Match.Odd.SpecialBetValue as FLOat)<(@AwayScore+@HomeScore)) or
			(Match.Odd.OutCome='Under and away' and cast(Match.Odd.SpecialBetValue as FLOat)>(@AwayScore+@HomeScore))
	
	
	end
	else
	begin
		
		insert Match.OddsResult (MatchId,OddsTypeId,Outcome,SpecialBetValue)
		SELECT     Match.Odd.MatchId,Match.Odd.OddsTypeId, Match.Odd.OutCome,Match.Odd.SpecialBetValue 
			FROM   Match.Odd INNER JOIN
            Parameter.Odds ON Match.Odd.ParameterOddId = Parameter.Odds.OddsId
			where MatchId=@MatchId and MatchTimeTypeId=@MatchTimeTypeId and Parameter.Odds.OddTypeId in (1792)  and
			(Match.Odd.OutCome='Over and draw' and cast(Match.Odd.SpecialBetValue as FLOat)<(@AwayScore+@HomeScore)) or
			(Match.Odd.OutCome='Under and draw' and cast(Match.Odd.SpecialBetValue as FLOat)>(@AwayScore+@HomeScore))
	
	
	end
			
-----------------------------------------------------------------------------

 ----- Maçı kim kazandı ve Both Teams to score (iki takımda gol atar) sonuçlarını girme ------
declare @MatchbetBothTeams nvarchar(100)='Draw / No'

if(@WhoWin='1')
begin
	if(@AwayScore>0)
		set @MatchbetBothTeams='Home / Yes'
	else
		set @MatchbetBothTeams='Home / No'
end		
else if(@WhoWin='2')
begin	
	if(@HomeScore>0)
		set @MatchbetBothTeams='Away / Yes'
	else
		set @MatchbetBothTeams='Away / No'
end		
else
	if(@HomeScore>0 and @AwayScore>0)
		set @MatchbetBothTeams='Draw / Yes'
	


insert Match.OddsResult (MatchId,OddsTypeId,Outcome,SpecialBetValue)
		SELECT     Match.Odd.MatchId,Match.Odd.OddsTypeId, Match.Odd.OutCome,Match.Odd.SpecialBetValue 
			FROM   Match.Odd INNER JOIN
            Parameter.Odds ON Match.Odd.ParameterOddId = Parameter.Odds.OddsId
			where MatchId=@MatchId and MatchTimeTypeId=@MatchTimeTypeId and Parameter.Odds.OddTypeId in (1793,1767) and
			Match.Odd.OutCome=@MatchbetBothTeams			
 -----------------------------------------------------------------------------------

----- Maçın Odd/Even sonuçlarını girme ------
declare @OddEven nvarchar(50)='Odd'

declare @oddEvenInt int=0

set @oddEvenInt=(@HomeScore+@AwayScore)%2

if(@oddEvenInt=0)
	set @OddEven='Even'

insert Match.OddsResult (MatchId,OddsTypeId,Outcome,SpecialBetValue)
		SELECT     Match.Odd.MatchId,Match.Odd.OddsTypeId, Match.Odd.OutCome,Match.Odd.SpecialBetValue 
			FROM   Match.Odd INNER JOIN
            Parameter.Odds ON Match.Odd.ParameterOddId = Parameter.Odds.OddsId
			where MatchId=@MatchId and MatchTimeTypeId=@MatchTimeTypeId and Parameter.Odds.OddTypeId in (1546,1475,1696)  and
			(Match.Odd.OutCome=@OddEven)
-----------------------------------------------------------------------------
----- Ev sahibi takım Odd/Even sonuçlarını girme ------
declare @HomeOddEven nvarchar(50)='Odd'

declare @HomeOddEvenInt int=0

set @HomeOddEvenInt=(@HomeScore)%2

if(@HomeOddEvenInt=0)
	set @HomeOddEven='Even'

insert Match.OddsResult (MatchId,OddsTypeId,Outcome,SpecialBetValue)
		SELECT     Match.Odd.MatchId,Match.Odd.OddsTypeId, Match.Odd.OutCome,Match.Odd.SpecialBetValue 
			FROM   Match.Odd INNER JOIN
            Parameter.Odds ON Match.Odd.ParameterOddId = Parameter.Odds.OddsId
			where MatchId=@MatchId and MatchTimeTypeId=@MatchTimeTypeId and Parameter.Odds.OddTypeId in (1790)  and
			(Match.Odd.OutCome=@HomeOddEven)
-----------------------------------------------------------------------------
----- deplasman takımı Odd/Even sonuçlarını girme ------
declare @AwayOddEven nvarchar(50)='Odd'

declare @AwayOddEvenInt int=0

set @AwayOddEvenInt=(@AwayScore)%2

if(@AwayOddEvenInt=0)
	set @AwayOddEven='Even'

insert Match.OddsResult (MatchId,OddsTypeId,Outcome,SpecialBetValue)
		SELECT     Match.Odd.MatchId,Match.Odd.OddsTypeId, Match.Odd.OutCome,Match.Odd.SpecialBetValue 
			FROM   Match.Odd INNER JOIN
            Parameter.Odds ON Match.Odd.ParameterOddId = Parameter.Odds.OddsId
			where MatchId=@MatchId and MatchTimeTypeId=@MatchTimeTypeId and Parameter.Odds.OddTypeId in (1791)  and
			(Match.Odd.OutCome=@AwayOddEven)
-----------------------------------------------------------------------------


----- Clean sheet Ev sahibi (Ev sahibi gol yermi) sonuçlarını girme ------
declare @HomeCleanSheet nvarchar(10)='No'

if(@AwayScore>0)
set @HomeCleanSheet='Yes'

insert Match.OddsResult (MatchId,OddsTypeId,Outcome,SpecialBetValue)
		SELECT     Match.Odd.MatchId,Match.Odd.OddsTypeId, Match.Odd.OutCome,Match.Odd.SpecialBetValue 
			FROM   Match.Odd INNER JOIN
            Parameter.Odds ON Match.Odd.ParameterOddId = Parameter.Odds.OddsId
			where MatchId=@MatchId and MatchTimeTypeId=@MatchTimeTypeId and Parameter.Odds.OddTypeId in (1625)  and
			(Match.Odd.OutCome=@HomeCleanSheet)
-----------------------------------------------------------------------------

----- Clean sheet Deplasman takımı (Deplasman gol yermi) sonuçlarını girme ------
declare @AwayCleanSheet nvarchar(10)='No'

if(@HomeScore>0)
set @AwayCleanSheet='Yes'

insert Match.OddsResult (MatchId,OddsTypeId,Outcome,SpecialBetValue)
		SELECT     Match.Odd.MatchId,Match.Odd.OddsTypeId, Match.Odd.OutCome,Match.Odd.SpecialBetValue 
			FROM   Match.Odd INNER JOIN
            Parameter.Odds ON Match.Odd.ParameterOddId = Parameter.Odds.OddsId
			where MatchId=@MatchId and MatchTimeTypeId=@MatchTimeTypeId and Parameter.Odds.OddTypeId in (1626)  and
			(Match.Odd.OutCome=@AwayCleanSheet)
-----------------------------------------------------------------------------


----- Her iki takımda gol atar mı FT sonuçlarını girme ------
declare @ScoreDuring nvarchar(20)='None'

if(@HomeScore>0 and @AwayScore>0)
set @ScoreDuring='Both teams'
else if(@HomeScore>0 and @AwayScore=0)
set @ScoreDuring='1'
else if(@HomeScore=0 and @AwayScore>0)
set @ScoreDuring='2'

insert Match.OddsResult (MatchId,OddsTypeId,Outcome,SpecialBetValue)
		SELECT     Match.Odd.MatchId,Match.Odd.OddsTypeId, Match.Odd.OutCome,Match.Odd.SpecialBetValue 
			FROM   Match.Odd INNER JOIN
            Parameter.Odds ON Match.Odd.ParameterOddId = Parameter.Odds.OddsId
			where MatchId=@MatchId and MatchTimeTypeId=@MatchTimeTypeId and Parameter.Odds.OddTypeId in (1627)  and
			(Match.Odd.OutCome=@ScoreDuring)
-----------------------------------------------------------------------------

 ----- Both Teams to score (iki takımda gol atar ve over/under) sonuçlarını girme ------


insert Match.OddsResult (MatchId,OddsTypeId,Outcome,SpecialBetValue)
		SELECT     Match.Odd.MatchId,Match.Odd.OddsTypeId, Match.Odd.OutCome,Match.Odd.SpecialBetValue 
			FROM   Match.Odd INNER JOIN
            Parameter.Odds ON Match.Odd.ParameterOddId = Parameter.Odds.OddsId
			where MatchId=@MatchId and MatchTimeTypeId=@MatchTimeTypeId and Parameter.Odds.OddTypeId in (1794)  and
			(Match.Odd.OutCome=@BothTeamsScore+' / Over' and cast(Match.Odd.SpecialBetValue as FLOat)<(@HomeScore+@AwayScore)) or
			(Match.Odd.OutCome=@BothTeamsScore+' / Under' and cast(Match.Odd.SpecialBetValue as FLOat)>(@HomeScore+@AwayScore))		
 -----------------------------------------------------------------------------------

end


GO
