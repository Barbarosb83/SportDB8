USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcProgrammeConfig]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcProgrammeConfig]
 @PageSize  INT,
 @PageNum int,
@Username nvarchar(50),
@where nvarchar(1000),
@orderby nvarchar(100),
@LangId int


AS




BEGIN
SET NOCOUNT ON;

declare @sqlcommand nvarchar(max)

--declare @total int
--select @total=COUNT(Id) 
--FROM            Retail.ProgrammeConfig INNER JOIN Parameter.Tournament On Retail.ProgrammeConfig.TournamentId=Parameter.Tournament.TournamentId INNER JOIN
--Language.[Parameter.Tournament] ON Language.[Parameter.Tournament].TournamentId=Parameter.Tournament.TournamentId and Language.[Parameter.Tournament].LanguageId=@LangId INNER JOIN
--Parameter.Category ON Parameter.Category.CategoryId=Retail.ProgrammeConfig.CategoryId and Parameter.Category.SportId=Retail.ProgrammeConfig.SportId INNER JOIN 
--Language.[Parameter.Category] On Language.[Parameter.Category].CategoryId=Parameter.Category.CategoryId and Language.[Parameter.Category].LanguageId=@LangId INNER JOIN
--Language.[Parameter.Sport] On Language.[Parameter.Sport].SportId=Retail.ProgrammeConfig.SportId and Language.[Parameter.Sport].LanguageId=@LangId
--WHERE (1 = 1)  ; 
--WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY Retail.ProgrammeConfig.SportId) AS RowNum, 
-- Id, Retail.ProgrammeConfig.SportId, Parameter.Tournament.CategoryId, Language.[Parameter.Tournament].TournamentId, ReportCount, IsHighlights,
--Language.[Parameter.Tournament].TournamentName
--,Language.[Parameter.Category].CategoryName
--,Language.[Parameter.Sport].SportName
--FROM            Retail.ProgrammeConfig INNER JOIN Parameter.Tournament On Retail.ProgrammeConfig.TournamentId=Parameter.Tournament.TournamentId INNER JOIN
--Language.[Parameter.Tournament] ON Language.[Parameter.Tournament].TournamentId=Parameter.Tournament.TournamentId and Language.[Parameter.Tournament].LanguageId=@LangId INNER JOIN
--Parameter.Category ON Parameter.Category.CategoryId=Retail.ProgrammeConfig.CategoryId and Parameter.Category.SportId=Retail.ProgrammeConfig.SportId INNER JOIN 
--Language.[Parameter.Category] On Language.[Parameter.Category].CategoryId=Parameter.Category.CategoryId and Language.[Parameter.Category].LanguageId=@LangId INNER JOIN
--Language.[Parameter.Sport] On Language.[Parameter.Sport].SportId=Retail.ProgrammeConfig.SportId and Language.[Parameter.Sport].LanguageId=@LangId
--WHERE (1 = 1) 
--)   
--SELECT *,@total as totalrow 
-- FROM OrdersRN 


set @sqlcommand='declare @total int '+
'select @total=COUNT(Retail.ProgrammeConfig.SportId)  '+
'FROM            Retail.ProgrammeConfig INNER JOIN Parameter.Tournament On Retail.ProgrammeConfig.TournamentId=Parameter.Tournament.TournamentId INNER JOIN
Language.[Parameter.Tournament] ON Language.[Parameter.Tournament].TournamentId=Parameter.Tournament.TournamentId and Language.[Parameter.Tournament].LanguageId='+cast(@LangId as nvarchar(10))+' INNER JOIN
Parameter.Category ON Parameter.Category.CategoryId=Retail.ProgrammeConfig.CategoryId and Parameter.Category.SportId=Retail.ProgrammeConfig.SportId INNER JOIN 
Language.[Parameter.Category] On Language.[Parameter.Category].CategoryId=Parameter.Category.CategoryId and Language.[Parameter.Category].LanguageId='+cast(@LangId as nvarchar(10))+' INNER JOIN
Language.[Parameter.Sport] On Language.[Parameter.Sport].SportId=Retail.ProgrammeConfig.SportId and Language.[Parameter.Sport].LanguageId='+cast(@LangId as nvarchar(10))+' '+
'WHERE (1 = 1) and '+@where +' ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
' Id, Retail.ProgrammeConfig.SportId, Parameter.Tournament.CategoryId, Language.[Parameter.Tournament].TournamentId, ReportCount, IsHighlights,
Language.[Parameter.Tournament].TournamentName
,Language.[Parameter.Category].CategoryName
,Language.[Parameter.Sport].SportName '+
'FROM            Retail.ProgrammeConfig INNER JOIN Parameter.Tournament On Retail.ProgrammeConfig.TournamentId=Parameter.Tournament.TournamentId INNER JOIN
Language.[Parameter.Tournament] ON Language.[Parameter.Tournament].TournamentId=Parameter.Tournament.TournamentId and Language.[Parameter.Tournament].LanguageId='+cast(@LangId as nvarchar(10))+' INNER JOIN
Parameter.Category ON Parameter.Category.CategoryId=Retail.ProgrammeConfig.CategoryId and Parameter.Category.SportId=Retail.ProgrammeConfig.SportId INNER JOIN 
Language.[Parameter.Category] On Language.[Parameter.Category].CategoryId=Parameter.Category.CategoryId and Language.[Parameter.Category].LanguageId='+cast(@LangId as nvarchar(10))+' INNER JOIN
Language.[Parameter.Sport] On Language.[Parameter.Sport].SportId=Retail.ProgrammeConfig.SportId and Language.[Parameter.Sport].LanguageId='+cast(@LangId as nvarchar(10))+' '+
'WHERE (1 = 1) and '+@where +
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' )'

execute (@sqlcommand)


END



GO
