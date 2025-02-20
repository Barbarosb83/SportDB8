USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcOddResultUID]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcOddResultUID]
@MatchId int,
@MatchTimeTypeId int,
@Score1 int,
@Score2 int,
@username nvarchar(max)

AS



BEGIN
SET NOCOUNT ON;


declare @WhoWin nvarchar(1)='X' --1 ise Ev sahibi , 2 ise Deplasman takımı,X ise beraberlik
declare @SportId int

SELECT    @SportId= Parameter.Category.SportId
FROM         Match.Match INNER JOIN
                      Parameter.Tournament ON Match.Match.TournamentId = Parameter.Tournament.TournamentId AND 
                      Match.Match.TournamentId = Parameter.Tournament.TournamentId INNER JOIN
                      Parameter.Category ON Parameter.Tournament.CategoryId = Parameter.Category.CategoryId
where MatchId=@MatchId

if @Score1>@Score2
	set @WhoWin='1'
else if @Score1<@Score2
	set @WhoWin='2'
	
	
	insert Match.OddsResult(MatchId,OddsTypeId,Outcome,SpecialBetValue,Status)
	select @MatchId,Match.Odd.OddsTypeId,Match.Odd.OutCome,Match.Odd.SpecialBetValue,0
	from Match.Odd
	where MatchId=@MatchId and ParameterOddId in (
	select OddsId from Parameter.Odds where MatchTimeTypeId=@MatchTimeTypeId and OutCome=@WhoWin)
	
	
	
	
	




END


GO
