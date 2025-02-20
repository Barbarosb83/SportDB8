USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcEvaluation]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcEvaluation] 
 @PageSize  INT,
 @PageNum int,
@Username nvarchar(50),
@where nvarchar(1000),
@orderby nvarchar(100)
AS

BEGIN
SET NOCOUNT ON;


declare @sqlcommand nvarchar(max)=''
declare @sqlcommand2 nvarchar(max)=''

--declare @total int 

--select NEWID() as ID ,'Evaluated' as Stated,COUNT(DISTINCT Customer.Slip.SlipId) as Counts,ISNULL(SUM(Customer.Slip.Amount),0) as Stake
--,(select ISNULL(SUM(CusSlip.Amount*CusSlip.TotalOddValue),0) from Customer.Slip as CusSlip where CusSlip.SlipStateId=3) as Lost,
--(select ISNULL(SUM(CusSlip.Amount),0) from Customer.Slip as CusSlip where CusSlip.SlipStateId=4) as Win
--FROM         Customer.Slip 
--where Customer.Slip.SlipStateId not in (1,2) and Customer.Slip.SlipId in (SELECT    DISTINCT Customer.Slip.SlipId
--FROM         Customer.SlipOdd INNER JOIN
--                      Match.Odd ON Customer.SlipOdd.OddId = Match.Odd.OddId INNER JOIN
--                      Customer.Slip ON Customer.SlipOdd.SlipId = Customer.Slip.SlipId INNER JOIN
--                      Match.Match ON Match.Odd.MatchId = Match.Match.MatchId INNER JOIN
--                      Parameter.Tournament ON Match.Match.TournamentId = Parameter.Tournament.TournamentId AND 
--                      Match.Match.TournamentId = Parameter.Tournament.TournamentId AND Match.Match.TournamentId = Parameter.Tournament.TournamentId INNER JOIN
--                      Parameter.Category ON Parameter.Tournament.CategoryId = Parameter.Category.CategoryId AND 
--                      Parameter.Tournament.CategoryId = Parameter.Category.CategoryId AND Parameter.Tournament.CategoryId = Parameter.Category.CategoryId AND 
--                      Parameter.Tournament.CategoryId = Parameter.Category.CategoryId
--WHERE     (Customer.Slip.SlipStateId  not in (1,2)))
--UNION ALL
--select NEWID() as ID,'Not Evaluated' as Stated,COUNT(Customer.Slip.SlipId) as Counts,ISNULL(SUM(Customer.Slip.Amount),0) as Stake,0 as Lost,0 as Win
--FROM         Customer.Slip
--where Customer.Slip.SlipStateId=1 and Customer.Slip.SlipId in (SELECT    DISTINCT Customer.Slip.SlipId
--FROM         Customer.SlipOdd INNER JOIN
--                      Match.Odd ON Customer.SlipOdd.OddId = Match.Odd.OddId INNER JOIN
--                      Customer.Slip ON Customer.SlipOdd.SlipId = Customer.Slip.SlipId INNER JOIN
--                      Match.Match ON Match.Odd.MatchId = Match.Match.MatchId INNER JOIN
--                      Parameter.Tournament ON Match.Match.TournamentId = Parameter.Tournament.TournamentId AND 
--                      Match.Match.TournamentId = Parameter.Tournament.TournamentId AND Match.Match.TournamentId = Parameter.Tournament.TournamentId INNER JOIN
--                      Parameter.Category ON Parameter.Tournament.CategoryId = Parameter.Category.CategoryId AND 
--                      Parameter.Tournament.CategoryId = Parameter.Category.CategoryId AND Parameter.Tournament.CategoryId = Parameter.Category.CategoryId AND 
--                      Parameter.Tournament.CategoryId = Parameter.Category.CategoryId
--WHERE     (Customer.Slip.SlipStateId = 1))


set @sqlcommand='select NEWID() as ID ,''Evaluated'' as Stated,COUNT(DISTINCT Customer.Slip.SlipId) as Counts,ISNULL(SUM(Customer.Slip.Amount),0) as Stake
,(select ISNULL(SUM(CusSlip.Amount*CusSlip.TotalOddValue),0) from Customer.Slip as CusSlip where CusSlip.SlipStateId=3 and CusSlip.SlipId in (SELECT    DISTINCT Customer.Slip.SlipId
FROM         Customer.SlipOdd with (nolock) INNER JOIN
                      Match.Odd ON Customer.SlipOdd.OddId = Match.Odd.OddId INNER JOIN
                      Customer.Slip ON Customer.SlipOdd.SlipId = Customer.Slip.SlipId INNER JOIN
                      Match.Match ON Match.Odd.MatchId = Match.Match.MatchId INNER JOIN
                      Parameter.Tournament ON Match.Match.TournamentId = Parameter.Tournament.TournamentId AND 
                      Match.Match.TournamentId = Parameter.Tournament.TournamentId AND Match.Match.TournamentId = Parameter.Tournament.TournamentId INNER JOIN
                      Parameter.Category ON Parameter.Tournament.CategoryId = Parameter.Category.CategoryId AND 
                      Parameter.Tournament.CategoryId = Parameter.Category.CategoryId AND Parameter.Tournament.CategoryId = Parameter.Category.CategoryId AND 
                      Parameter.Tournament.CategoryId = Parameter.Category.CategoryId
WHERE     (Customer.Slip.SlipStateId  not in (1,2)) and ' +@where +')) as Lost,
(select ISNULL(SUM(CusSlip.Amount),0) from Customer.Slip as CusSlip where CusSlip.SlipStateId=4 and CusSlip.SlipId in (SELECT    DISTINCT Customer.Slip.SlipId
FROM         Customer.SlipOdd with (nolock) INNER JOIN
                      Match.Odd ON Customer.SlipOdd.OddId = Match.Odd.OddId INNER JOIN
                      Customer.Slip with (nolock) ON Customer.SlipOdd.SlipId = Customer.Slip.SlipId INNER JOIN
                      Match.Match ON Match.Odd.MatchId = Match.Match.MatchId INNER JOIN
                      Parameter.Tournament ON Match.Match.TournamentId = Parameter.Tournament.TournamentId AND 
                      Match.Match.TournamentId = Parameter.Tournament.TournamentId AND Match.Match.TournamentId = Parameter.Tournament.TournamentId INNER JOIN
                      Parameter.Category ON Parameter.Tournament.CategoryId = Parameter.Category.CategoryId AND 
                      Parameter.Tournament.CategoryId = Parameter.Category.CategoryId AND Parameter.Tournament.CategoryId = Parameter.Category.CategoryId AND 
                      Parameter.Tournament.CategoryId = Parameter.Category.CategoryId
WHERE     (Customer.Slip.SlipStateId  not in (1,2)) and ' +@where+')) as Win
FROM         Customer.Slip with (nolock) 
where Customer.Slip.SlipId in (SELECT    DISTINCT Customer.Slip.SlipId
FROM         Customer.SlipOdd with (nolock) INNER JOIN
                      Match.Odd ON Customer.SlipOdd.OddId = Match.Odd.OddId INNER JOIN
                      Customer.Slip with (nolock) ON Customer.SlipOdd.SlipId = Customer.Slip.SlipId INNER JOIN
                      Match.Match ON Match.Odd.MatchId = Match.Match.MatchId INNER JOIN
                      Parameter.Tournament ON Match.Match.TournamentId = Parameter.Tournament.TournamentId AND 
                      Match.Match.TournamentId = Parameter.Tournament.TournamentId AND Match.Match.TournamentId = Parameter.Tournament.TournamentId INNER JOIN
                      Parameter.Category ON Parameter.Tournament.CategoryId = Parameter.Category.CategoryId AND 
                      Parameter.Tournament.CategoryId = Parameter.Category.CategoryId AND Parameter.Tournament.CategoryId = Parameter.Category.CategoryId AND 
                      Parameter.Tournament.CategoryId = Parameter.Category.CategoryId
WHERE     (Customer.Slip.SlipStateId  not in (1,2)) and ' +@where + ') '+
'UNION ALL '
set @sqlcommand2=' select NEWID() as ID,''Not Evaluated'' as Stated,COUNT(Customer.Slip.SlipId) as Counts,ISNULL(SUM(Customer.Slip.Amount),0) as Stake,0 as Lost,0 as Win
FROM         Customer.Slip with (nolock)
where Customer.Slip.SlipId in (SELECT    DISTINCT Customer.Slip.SlipId
FROM         Customer.SlipOdd with (nolock) INNER JOIN
                      Match.Odd ON Customer.SlipOdd.OddId = Match.Odd.OddId INNER JOIN
                      Customer.Slip with (nolock) ON Customer.SlipOdd.SlipId = Customer.Slip.SlipId INNER JOIN
                      Match.Match ON Match.Odd.MatchId = Match.Match.MatchId INNER JOIN
                      Parameter.Tournament ON Match.Match.TournamentId = Parameter.Tournament.TournamentId AND 
                      Match.Match.TournamentId = Parameter.Tournament.TournamentId AND Match.Match.TournamentId = Parameter.Tournament.TournamentId INNER JOIN
                      Parameter.Category ON Parameter.Tournament.CategoryId = Parameter.Category.CategoryId AND 
                      Parameter.Tournament.CategoryId = Parameter.Category.CategoryId AND Parameter.Tournament.CategoryId = Parameter.Category.CategoryId AND 
                      Parameter.Tournament.CategoryId = Parameter.Category.CategoryId
WHERE     (Customer.Slip.SlipStateId = 1) and ' +@where + ') '


execute (@sqlcommand+@sqlcommand2)
END


GO
