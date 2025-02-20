USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcProgrammeConfigOne]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [RiskManagement].[ProcProgrammeConfigOne]
@Id int,
@LangId int


AS




BEGIN
SET NOCOUNT ON;

select  Id, Retail.ProgrammeConfig.SportId, Parameter.Tournament.CategoryId, Language.[Parameter.Tournament].TournamentId, ReportCount, IsHighlights,
Language.[Parameter.Tournament].TournamentName
,Language.[Parameter.Category].CategoryName
,Language.[Parameter.Sport].SportName
FROM            Retail.ProgrammeConfig INNER JOIN Parameter.Tournament On Retail.ProgrammeConfig.TournamentId=Parameter.Tournament.TournamentId INNER JOIN
Language.[Parameter.Tournament] ON Language.[Parameter.Tournament].TournamentId=Parameter.Tournament.TournamentId and Language.[Parameter.Tournament].LanguageId=@LangId INNER JOIN
Parameter.Category ON Parameter.Category.CategoryId=Retail.ProgrammeConfig.CategoryId and Parameter.Category.SportId=Retail.ProgrammeConfig.SportId INNER JOIN 
Language.[Parameter.Category] On Language.[Parameter.Category].CategoryId=Parameter.Category.CategoryId and Language.[Parameter.Category].LanguageId=@LangId INNER JOIN
Language.[Parameter.Sport] On Language.[Parameter.Sport].SportId=Retail.ProgrammeConfig.SportId and Language.[Parameter.Sport].LanguageId=@LangId
WHERE Id=@Id

END



GO
