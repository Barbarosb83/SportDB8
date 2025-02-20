USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcBultenHighlights]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
 
CREATE PROCEDURE [Retail].[ProcBultenHighlights] 
@DayPeriod int,
@SportId int
AS

BEGIN
SET NOCOUNT ON;


if(@DayPeriod=0)
begin
	if(@SportId=1)
		begin
			if(select COUNT(Retail.ProgrammeConfig.Id) from Retail.ProgrammeConfig INNER JOIN Cache.Programme ON Retail.ProgrammeConfig.TournamentId=Cache.Programme.TournamentId and Retail.ProgrammeConfig.IsHighlights=1 and Retail.ProgrammeConfig.SportId=1 and Cache.Programme.MatchDate>=getdate() and Cache.Programme.MatchDate<DATEADD(DAY,1,getdate())  )>0
				select DISTINCT   Retail.ProgrammeConfig.* from Retail.ProgrammeConfig INNER JOIN Cache.Programme ON Retail.ProgrammeConfig.TournamentId=Cache.Programme.TournamentId and Retail.ProgrammeConfig.IsHighlights=1 and Retail.ProgrammeConfig.SportId=1 and Cache.Programme.MatchDate>=getdate() and Cache.Programme.MatchDate<DATEADD(DAY,1,getdate())  Order by ReportCount desc
			else
				select DISTINCT top 1  Retail.ProgrammeConfig.* from Retail.ProgrammeConfig INNER JOIN Cache.Programme ON Retail.ProgrammeConfig.TournamentId=Cache.Programme.TournamentId and Retail.ProgrammeConfig.SportId=1 and Cache.Programme.MatchDate>=getdate() and Cache.Programme.MatchDate<DATEADD(DAY,1,getdate())   Order by ReportCount desc
		end
	else
		begin
			if(select COUNT(Retail.ProgrammeConfig.Id) from Retail.ProgrammeConfig INNER JOIN Cache.Programme ON Retail.ProgrammeConfig.TournamentId=Cache.Programme.TournamentId and Retail.ProgrammeConfig.IsHighlights=1 and Retail.ProgrammeConfig.SportId not in (1,17,8,16,35,22) )>0
				select DISTINCT   Retail.ProgrammeConfig.* from Retail.ProgrammeConfig INNER JOIN Cache.Programme ON Retail.ProgrammeConfig.TournamentId=Cache.Programme.TournamentId and Retail.ProgrammeConfig.IsHighlights=1 and  Retail.ProgrammeConfig.SportId not in (1,17,8,16,35,22) and Cache.Programme.MatchDate>=getdate() and Cache.Programme.MatchDate<DATEADD(DAY,1,getdate())  Order by ReportCount desc
			else
				select DISTINCT top 1  Retail.ProgrammeConfig.* from Retail.ProgrammeConfig INNER JOIN Cache.Programme ON Retail.ProgrammeConfig.TournamentId=Cache.Programme.TournamentId and  Retail.ProgrammeConfig.SportId not in (1,17,8,16,35,22) and Cache.Programme.MatchDate>=getdate() and Cache.Programme.MatchDate<DATEADD(DAY,1,getdate())   Order by ReportCount desc

		end
end
else
begin
	if(@SportId=1)
		begin
			if(select COUNT(Retail.ProgrammeConfig.Id) from Retail.ProgrammeConfig INNER JOIN Cache.Programme2 ON Retail.ProgrammeConfig.TournamentId=Cache.Programme2.TournamentId and Retail.ProgrammeConfig.IsHighlights=1 and Retail.ProgrammeConfig.SportId=1 and Cache.Programme2.MatchDate>=getdate() and Cache.Programme2.MatchDate<DATEADD(DAY,@DayPeriod,getdate())  )>0
				select DISTINCT top 3  Retail.ProgrammeConfig.* from Retail.ProgrammeConfig INNER JOIN Cache.Programme2 ON Retail.ProgrammeConfig.TournamentId=Cache.Programme2.TournamentId and Retail.ProgrammeConfig.IsHighlights=1 and Retail.ProgrammeConfig.SportId=1 and Cache.Programme2.MatchDate>=getdate() and Cache.Programme2.MatchDate<DATEADD(DAY,@DayPeriod,getdate())  Order by ReportCount desc
			else
				select DISTINCT top 3 Retail.ProgrammeConfig.* from Retail.ProgrammeConfig INNER JOIN Cache.Programme2 ON Retail.ProgrammeConfig.TournamentId=Cache.Programme2.TournamentId and Retail.ProgrammeConfig.IsHighlights=1 and Retail.ProgrammeConfig.SportId=1 and Cache.Programme2.MatchDate>=getdate()    Order by ReportCount desc
		end
	else if(@SportId=5)
		begin
			if(select COUNT(Retail.ProgrammeConfig.Id) from Retail.ProgrammeConfig INNER JOIN Cache.Programme2 ON Retail.ProgrammeConfig.TournamentId=Cache.Programme2.TournamentId and Retail.ProgrammeConfig.IsHighlights=1 and Retail.ProgrammeConfig.SportId<>1  and Cache.Programme2.MatchDate>=getdate() and Cache.Programme2.MatchDate<DATEADD(DAY,@DayPeriod,getdate()) )>0
				select DISTINCT top 1  Retail.ProgrammeConfig.* from Retail.ProgrammeConfig INNER JOIN Cache.Programme2 ON Retail.ProgrammeConfig.TournamentId=Cache.Programme2.TournamentId and Retail.ProgrammeConfig.IsHighlights=1 and Retail.ProgrammeConfig.SportId<>1  and Cache.Programme2.MatchDate>=getdate() and Cache.Programme2.MatchDate<DATEADD(DAY,@DayPeriod,getdate()) Order by ReportCount desc
			else
				select DISTINCT top 1 Retail.ProgrammeConfig.* from Retail.ProgrammeConfig INNER JOIN Cache.Programme2 ON Retail.ProgrammeConfig.TournamentId=Cache.Programme2.TournamentId and Retail.ProgrammeConfig.SportId<>1  and Cache.Programme2.MatchDate>=getdate() and Cache.Programme2.MatchDate<DATEADD(DAY,1,getdate())   Order by ReportCount desc
		end
		else if(@SportId=8)
		begin
			if(select COUNT(Retail.ProgrammeConfig.Id) from Retail.ProgrammeConfig INNER JOIN Cache.Programme2 ON Retail.ProgrammeConfig.TournamentId=Cache.Programme2.TournamentId and Retail.ProgrammeConfig.IsHighlights=1 and Retail.ProgrammeConfig.SportId=1 and Cache.Programme2.MatchDate>=getdate() and Cache.Programme2.MatchDate<DATEADD(DAY,@DayPeriod,getdate())  )>0
				select DISTINCT top 3  Retail.ProgrammeConfig.* from Retail.ProgrammeConfig INNER JOIN Cache.Programme2 ON Retail.ProgrammeConfig.TournamentId=Cache.Programme2.TournamentId and Retail.ProgrammeConfig.IsHighlights=1 and Retail.ProgrammeConfig.SportId=1 and Cache.Programme2.MatchDate>=getdate() and Cache.Programme2.MatchDate<DATEADD(DAY,@DayPeriod,getdate())  Order by ReportCount desc
			else
				select DISTINCT top 3 Retail.ProgrammeConfig.* from Retail.ProgrammeConfig INNER JOIN Cache.Programme2 ON Retail.ProgrammeConfig.TournamentId=Cache.Programme2.TournamentId and Retail.ProgrammeConfig.IsHighlights=1 and Retail.ProgrammeConfig.SportId=1 and Cache.Programme2.MatchDate>=getdate()    Order by ReportCount desc
		end
end


END


GO
