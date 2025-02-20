USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcBultenConfig]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
 
 
CREATE PROCEDURE [Retail].[ProcBultenConfig] 
@DayPeriod int,
@SportId int
AS

BEGIN
SET NOCOUNT ON;


if(@DayPeriod=0)
begin
	if(@SportId=1)
		begin
			select  DISTINCT Top 200  Retail.ProgrammeConfig.*,Language.[Parameter.Category].CategoryName+' - '+Language.[Parameter.Tournament].TournamentName as CategoryName,Language.[Parameter.Sport].SportName  ,Parameter.Category.SequenceNumber
			,Parameter.Tournament.SequenceNumber as SequenceNumber1
			from Retail.ProgrammeConfig INNER JOIN Cache.Programme ON Retail.ProgrammeConfig.TournamentId=Cache.Programme.TournamentId and Cache.Programme.MatchDate>GETDATE() and cast(Cache.Programme.MatchDate as date)=cast(GETDATE() as date)
			INNER JOIN Language.[Parameter.Category] 
			On Language.[Parameter.Category].CategoryId=Retail.ProgrammeConfig.CategoryId and Language.[Parameter.Category].LanguageId=6 INNER JOIN
				Parameter.Category On Parameter.Category.CategoryId=Retail.ProgrammeConfig.CategoryId and Parameter.Category.IsActive=1 INNER JOIN
				Language.[Parameter.Tournament] On Language.[Parameter.Tournament].TournamentId=Retail.ProgrammeConfig.TournamentId and Language.[Parameter.Tournament].LanguageId=6 INNER JOIN
				PArameter.Tournament ON Parameter.Tournament.TournamentId=Retail.ProgrammeConfig.TournamentId INNER JOIN
			Language.[Parameter.Sport] ON Language.[Parameter.Sport].SportId=Retail.ProgrammeConfig.SportId and Language.[Parameter.Sport].LanguageId=6 and Retail.ProgrammeConfig.SportId=@SportId
			 Order by Parameter.Category.SequenceNumber asc,Parameter.Tournament.SequenceNumber
		end
	else
		begin
				select DISTINCT    Retail.ProgrammeConfig.*,Language.[Parameter.Category].CategoryName,Language.[Parameter.Sport].SportName ,Parameter.Sport.SquanceNumber as SequenceNumber
				,Parameter.Sport.SquanceNumber as SequenceNumber1
			from Retail.ProgrammeConfig INNER JOIN Cache.Programme ON Retail.ProgrammeConfig.TournamentId=Cache.Programme.TournamentId and Cache.Programme.MatchDate>GETDATE() and cast(Cache.Programme.MatchDate as date)=cast(GETDATE() as date)
			INNER JOIN Language.[Parameter.Category] 
			On Language.[Parameter.Category].CategoryId=Retail.ProgrammeConfig.CategoryId and Language.[Parameter.Category].LanguageId=6 INNER JOIN
			Language.[Parameter.Sport] ON Language.[Parameter.Sport].SportId=Retail.ProgrammeConfig.SportId and Language.[Parameter.Sport].LanguageId=6 and Retail.ProgrammeConfig.SportId not in (1,17,8,16,35,22,10,9,24) INNER JOIN
			Parameter.Sport On Parameter.Sport.SportId=Language.[Parameter.Sport].SportId 
			GROUP BY Retail.ProgrammeConfig.IsEnable, Parameter.Sport.SquanceNumber,Retail.ProgrammeConfig.CategoryId,Retail.ProgrammeConfig.Id,Retail.ProgrammeConfig.IsHighlights,Retail.ProgrammeConfig.ReportCount,Retail.ProgrammeConfig.SportId,Retail.ProgrammeConfig.TournamentId,Language.[Parameter.Category].CategoryName,Language.[Parameter.Sport].SportName 
			 Order by Parameter.Sport.SquanceNumber

		end
 end
else
begin

set @DayPeriod=8
	if(@SportId=1)
		begin
			select DISTINCT   TOp 150 Retail.ProgrammeConfig.*,Language.[Parameter.Category].CategoryName+' - '+Language.[Parameter.Tournament].TournamentName as CategoryName,Language.[Parameter.Sport].SportName ,Parameter.Category.SequenceNumber
			,Parameter.Tournament.SequenceNumber as SequenceNumber1
			from Retail.ProgrammeConfig INNER JOIN Cache.Programme2 ON Retail.ProgrammeConfig.TournamentId=Cache.Programme2.TournamentId and Cache.Programme2.MatchDate>GETDATE()
			INNER JOIN Language.[Parameter.Category] 
			On Language.[Parameter.Category].CategoryId=Retail.ProgrammeConfig.CategoryId and Language.[Parameter.Category].LanguageId=6 INNER JOIN
				Parameter.Category On Parameter.Category.CategoryId=Retail.ProgrammeConfig.CategoryId and Parameter.Category.IsActive=1 INNER JOIN
			PArameter.Tournament ON Parameter.Tournament.TournamentId=Retail.ProgrammeConfig.TournamentId INNER JOIN
				Language.[Parameter.Tournament] On Language.[Parameter.Tournament].TournamentId=Retail.ProgrammeConfig.TournamentId and Language.[Parameter.Tournament].LanguageId=6 INNER JOIN
			Language.[Parameter.Sport] ON Language.[Parameter.Sport].SportId=Retail.ProgrammeConfig.SportId and Language.[Parameter.Sport].LanguageId=6 and Retail.ProgrammeConfig.SportId=@SportId
			and Cache.Programme2.OddValue1 is not null
			where  (Cache.Programme2.MatchDate<  DATEADD(DAY,@DayPeriod,GETDATE()) or Parameter.Tournament.TournamentId in (31204,28963,3793) )
			 Order by Parameter.Category.SequenceNumber,Parameter.Tournament.SequenceNumber
		end
	else if(@SportId=5)
		begin
			select DISTINCT    Retail.ProgrammeConfig.*,Language.[Parameter.Category].CategoryName,Language.[Parameter.Sport].SportName  ,Parameter.Sport.SquanceNumber as SequenceNumber
			,Parameter.Sport.SquanceNumber as SequenceNumber1
		from Retail.ProgrammeConfig INNER JOIN Cache.Programme2 ON Retail.ProgrammeConfig.TournamentId=Cache.Programme2.TournamentId and Cache.Programme2.MatchDate>GETDATE() and Cache.Programme2.MatchDate<DATEADD(DAY,@DayPeriod,GETDATE())
			INNER JOIN Language.[Parameter.Category] 
			On Language.[Parameter.Category].CategoryId=Retail.ProgrammeConfig.CategoryId and Language.[Parameter.Category].LanguageId=6 INNER JOIN
			Language.[Parameter.Sport] ON Language.[Parameter.Sport].SportId=Retail.ProgrammeConfig.SportId and Language.[Parameter.Sport].LanguageId=6 and Retail.ProgrammeConfig.SportId not in (1,17,8,16,35,22,10,9,24) INNER JOIN
			Parameter.Sport On Parameter.Sport.SportId=Language.[Parameter.Sport].SportId 
			GROUP BY Retail.ProgrammeConfig.IsEnable,Parameter.Sport.SquanceNumber,Retail.ProgrammeConfig.CategoryId,Retail.ProgrammeConfig.Id,Retail.ProgrammeConfig.IsHighlights,Retail.ProgrammeConfig.ReportCount,Retail.ProgrammeConfig.SportId,Retail.ProgrammeConfig.TournamentId,Language.[Parameter.Category].CategoryName,Language.[Parameter.Sport].SportName 
			 Order by Parameter.Sport.SquanceNumber
		end
		else if(@SportId=8)
		begin
			select DISTINCT   TOp 200 Retail.ProgrammeConfig.CategoryId,Retail.ProgrammeConfig.Id,Retail.ProgrammeConfig.IsHighlights,cast(1 as int) as ReportCount,Retail.ProgrammeConfig.SportId,Retail.ProgrammeConfig.TournamentId,Language.[Parameter.Category].CategoryName+' - '+Language.[Parameter.Tournament].TournamentName as CategoryName,Language.[Parameter.Sport].SportName ,Parameter.Category.SequenceNumber
			,Parameter.Tournament.SequenceNumber as SequenceNumber1
			from Retail.ProgrammeConfig INNER JOIN Cache.Programme2 ON Retail.ProgrammeConfig.TournamentId=Cache.Programme2.TournamentId and Cache.Programme2.MatchDate>GETDATE()
			INNER JOIN Language.[Parameter.Category] 
			On Language.[Parameter.Category].CategoryId=Retail.ProgrammeConfig.CategoryId and Language.[Parameter.Category].LanguageId=6 INNER JOIN
				Parameter.Category On Parameter.Category.CategoryId=Retail.ProgrammeConfig.CategoryId and Parameter.Category.IsActive=1 INNER JOIN
			PArameter.Tournament ON Parameter.Tournament.TournamentId=Retail.ProgrammeConfig.TournamentId INNER JOIN
				Language.[Parameter.Tournament] On Language.[Parameter.Tournament].TournamentId=Retail.ProgrammeConfig.TournamentId and Language.[Parameter.Tournament].LanguageId=6 INNER JOIN
			Language.[Parameter.Sport] ON Language.[Parameter.Sport].SportId=Retail.ProgrammeConfig.SportId and Language.[Parameter.Sport].LanguageId=6 and Retail.ProgrammeConfig.SportId=1
			and Cache.Programme2.OddValue1 is not null
			where  (Cache.Programme2.MatchDate<  DATEADD(DAY,@DayPeriod,GETDATE())  )
			 Order by Parameter.Category.SequenceNumber,Parameter.Tournament.SequenceNumber
		end
 
 end


END


GO
