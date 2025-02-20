USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcGameDataOutrights]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcGameDataOutrights] 
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
declare @sqlcommand2 nvarchar(max)

--declare @total int 

--select @total=COUNT(Outrights.Event.EventId) 
--FROM            Language.Language INNER JOIN
--                      Outrights.EventName ON Language.Language.LanguageId = Outrights.EventName.LanguageId INNER JOIN
--                      Outrights.Event ON Outrights.EventName.EventId = Outrights.Event.EventId INNER JOIN
--                      Parameter.TournamentOutrights ON Outrights.Event.TournamentId = Parameter.TournamentOutrights.TournamentId INNER JOIN
--                      Parameter.Category ON Parameter.TournamentOutrights.CategoryId = Parameter.Category.CategoryId AND 
--                      Parameter.TournamentOutrights.CategoryId = Parameter.Category.CategoryId AND Parameter.TournamentOutrights.CategoryId = Parameter.Category.CategoryId AND 
--                      Parameter.TournamentOutrights.CategoryId = Parameter.Category.CategoryId INNER JOIN
--                      Language.[Parameter.Category] ON Language.Language.LanguageId = Language.[Parameter.Category].LanguageId AND 
--                      Parameter.Category.CategoryId = Language.[Parameter.Category].CategoryId AND Parameter.Category.CategoryId = Language.[Parameter.Category].CategoryId AND 
--                      Parameter.Category.CategoryId = Language.[Parameter.Category].CategoryId AND 
--                      Parameter.Category.CategoryId = Language.[Parameter.Category].CategoryId INNER JOIN
--                      Language.[Parameter.Sport] ON Language.Language.LanguageId = Language.[Parameter.Sport].LanguageId INNER JOIN
--                      Parameter.Sport ON Parameter.Category.SportId = Parameter.Sport.SportId AND Parameter.Category.SportId = Parameter.Sport.SportId AND 
--                      Parameter.Category.SportId = Parameter.Sport.SportId AND Parameter.Category.SportId = Parameter.Sport.SportId AND 
--                      Parameter.Category.SportId = Parameter.Sport.SportId AND Parameter.Category.SportId = Parameter.Sport.SportId AND 
--                      Language.[Parameter.Sport].SportId = Parameter.Sport.SportId AND Language.[Parameter.Sport].SportId = Parameter.Sport.SportId AND 
--                      Language.[Parameter.Sport].SportId = Parameter.Sport.SportId AND Language.[Parameter.Sport].SportId = Parameter.Sport.SportId AND 
--                      Language.[Parameter.Sport].SportId = Parameter.Sport.SportId
--WHERE     (Language.Language.LanguageId = 2); 
--WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY Outrights.Event.EventId) AS RowNum,
-- Outrights.Event.EventId, Outrights.Event.TournamentId, Outrights.Event.EventDate, Outrights.Event.EventStartDate, Outrights.Event.EventEndDate, 
--                      Outrights.EventName.EventName, Parameter.TournamentOutrights.CategoryId, Language.[Parameter.Category].CategoryName, Parameter.Sport.SportId, 
--                      Language.[Parameter.Sport].SportName, Outrights.Event.IsActive,dbo.FuncCashFlow(0,Outrights.Event.EventId,4,2) as CashFlow,Parameter.Sport.IconColor,
--                      CAse when Outrights.Event.IsActive=0 then 3 else 1 end as StatuColor,Parameter.Sport.Icon
--FROM         Language.Language INNER JOIN
--                      Outrights.EventName ON Language.Language.LanguageId = Outrights.EventName.LanguageId INNER JOIN
--                      Outrights.Event ON Outrights.EventName.EventId = Outrights.Event.EventId INNER JOIN
--                      Parameter.TournamentOutrights ON Outrights.Event.TournamentId = Parameter.TournamentOutrights.TournamentId INNER JOIN
--                      Parameter.Category ON Parameter.TournamentOutrights.CategoryId = Parameter.Category.CategoryId AND 
--                      Parameter.TournamentOutrights.CategoryId = Parameter.Category.CategoryId AND Parameter.TournamentOutrights.CategoryId = Parameter.Category.CategoryId AND 
--                      Parameter.TournamentOutrights.CategoryId = Parameter.Category.CategoryId INNER JOIN
--                      Language.[Parameter.Category] ON Language.Language.LanguageId = Language.[Parameter.Category].LanguageId AND 
--                      Parameter.Category.CategoryId = Language.[Parameter.Category].CategoryId AND Parameter.Category.CategoryId = Language.[Parameter.Category].CategoryId AND 
--                      Parameter.Category.CategoryId = Language.[Parameter.Category].CategoryId AND 
--                      Parameter.Category.CategoryId = Language.[Parameter.Category].CategoryId INNER JOIN
--                      Language.[Parameter.Sport] ON Language.Language.LanguageId = Language.[Parameter.Sport].LanguageId INNER JOIN
--                      Parameter.Sport ON Parameter.Category.SportId = Parameter.Sport.SportId AND Parameter.Category.SportId = Parameter.Sport.SportId AND 
--                      Parameter.Category.SportId = Parameter.Sport.SportId AND Parameter.Category.SportId = Parameter.Sport.SportId AND 
--                      Parameter.Category.SportId = Parameter.Sport.SportId AND Parameter.Category.SportId = Parameter.Sport.SportId AND 
--                      Language.[Parameter.Sport].SportId = Parameter.Sport.SportId AND Language.[Parameter.Sport].SportId = Parameter.Sport.SportId AND 
--                      Language.[Parameter.Sport].SportId = Parameter.Sport.SportId AND Language.[Parameter.Sport].SportId = Parameter.Sport.SportId AND 
--                      Language.[Parameter.Sport].SportId = Parameter.Sport.SportId
--WHERE     (Language.Language.LanguageId = 2)
--)  
--SELECT *,@total as totalrow 
--FROM OrdersRN 
--WHERE RowNum BETWEEN ((@PageNum-1 )*(@PageSize))+1 AND (@PageNum * @PageSize ) 





set @sqlcommand='declare @total int '+
'select @total=COUNT(Outrights.Event.EventId) '+
'FROM         Language.Language INNER JOIN
                      Outrights.EventName ON Language.Language.LanguageId = Outrights.EventName.LanguageId INNER JOIN
                      Outrights.Event ON Outrights.EventName.EventId = Outrights.Event.EventId INNER JOIN
                      Parameter.TournamentOutrights ON Outrights.Event.TournamentId = Parameter.TournamentOutrights.TournamentId INNER JOIN
                      Parameter.Category ON Parameter.TournamentOutrights.CategoryId = Parameter.Category.CategoryId AND 
                      Parameter.TournamentOutrights.CategoryId = Parameter.Category.CategoryId AND Parameter.TournamentOutrights.CategoryId = Parameter.Category.CategoryId AND 
                      Parameter.TournamentOutrights.CategoryId = Parameter.Category.CategoryId INNER JOIN
                      Language.[Parameter.Category] ON Language.Language.LanguageId = Language.[Parameter.Category].LanguageId AND 
                      Parameter.Category.CategoryId = Language.[Parameter.Category].CategoryId AND Parameter.Category.CategoryId = Language.[Parameter.Category].CategoryId AND 
                      Parameter.Category.CategoryId = Language.[Parameter.Category].CategoryId AND 
                      Parameter.Category.CategoryId = Language.[Parameter.Category].CategoryId INNER JOIN
                      Language.[Parameter.Sport] ON Language.Language.LanguageId = Language.[Parameter.Sport].LanguageId INNER JOIN
                      Parameter.Sport ON Parameter.Category.SportId = Parameter.Sport.SportId AND Parameter.Category.SportId = Parameter.Sport.SportId AND 
                      Parameter.Category.SportId = Parameter.Sport.SportId AND Parameter.Category.SportId = Parameter.Sport.SportId AND 
                      Parameter.Category.SportId = Parameter.Sport.SportId AND Parameter.Category.SportId = Parameter.Sport.SportId AND 
                      Language.[Parameter.Sport].SportId = Parameter.Sport.SportId AND Language.[Parameter.Sport].SportId = Parameter.Sport.SportId AND 
                      Language.[Parameter.Sport].SportId = Parameter.Sport.SportId AND Language.[Parameter.Sport].SportId = Parameter.Sport.SportId AND 
                      Language.[Parameter.Sport].SportId = Parameter.Sport.SportId '+
'WHERE  (Language.Language.LanguageId = '''+cast(@LangId as nvarchar(1))+''')'+ ' and '+@where +' ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
'Outrights.Event.EventId,  ISNULL(Outrights.Event.SequenceNumber,999) as  TournamentId,dbo.UserTimeZoneDate('''+@Username+''',Outrights.Event.EventDate,0) as EventDate,dbo.UserTimeZoneDate('''+@Username+''',Outrights.Event.EventStartDate,0) as EventStartDate, dbo.UserTimeZoneDate('''+@Username+''',Outrights.Event.EventEndDate,0) as EventEndDate,Outrights.EventName.EventName, Parameter.Category.CategoryId, Language.[Parameter.Category].CategoryName, Parameter.Sport.SportId, 
                      Language.[Parameter.Sport].SportName, Outrights.Event.IsActive,dbo.FuncCashFlow(0,Outrights.Event.EventId,4,2) as CashFlow,Parameter.Sport.IconColor,
                      CAse when Outrights.Event.IsActive=0 then 3 else 1 end as StatuColor,Parameter.Sport.Icon '

set @sqlcommand2= ' FROM Language.Language INNER JOIN
                      Outrights.EventName ON Language.Language.LanguageId = Outrights.EventName.LanguageId INNER JOIN
                      Outrights.Event ON Outrights.EventName.EventId = Outrights.Event.EventId INNER JOIN
                      Parameter.TournamentOutrights ON Outrights.Event.TournamentId = Parameter.TournamentOutrights.TournamentId INNER JOIN
                      Parameter.Category ON Parameter.TournamentOutrights.CategoryId = Parameter.Category.CategoryId AND 
                      Parameter.TournamentOutrights.CategoryId = Parameter.Category.CategoryId AND Parameter.TournamentOutrights.CategoryId = Parameter.Category.CategoryId AND 
                      Parameter.TournamentOutrights.CategoryId = Parameter.Category.CategoryId INNER JOIN
                      Language.[Parameter.Category] ON Language.Language.LanguageId = Language.[Parameter.Category].LanguageId AND 
                      Parameter.Category.CategoryId = Language.[Parameter.Category].CategoryId AND Parameter.Category.CategoryId = Language.[Parameter.Category].CategoryId AND 
                      Parameter.Category.CategoryId = Language.[Parameter.Category].CategoryId AND 
                      Parameter.Category.CategoryId = Language.[Parameter.Category].CategoryId INNER JOIN
                      Language.[Parameter.Sport] ON Language.Language.LanguageId = Language.[Parameter.Sport].LanguageId INNER JOIN
                      Parameter.Sport ON Parameter.Category.SportId = Parameter.Sport.SportId AND Parameter.Category.SportId = Parameter.Sport.SportId AND 
                      Parameter.Category.SportId = Parameter.Sport.SportId AND Parameter.Category.SportId = Parameter.Sport.SportId AND 
                      Parameter.Category.SportId = Parameter.Sport.SportId AND Parameter.Category.SportId = Parameter.Sport.SportId AND 
                      Language.[Parameter.Sport].SportId = Parameter.Sport.SportId AND Language.[Parameter.Sport].SportId = Parameter.Sport.SportId AND 
                      Language.[Parameter.Sport].SportId = Parameter.Sport.SportId AND Language.[Parameter.Sport].SportId = Parameter.Sport.SportId AND 
                      Language.[Parameter.Sport].SportId = Parameter.Sport.SportId '+
' WHERE  (Language.Language.LanguageId = '''+cast(@LangId as nvarchar(1))+''')'+ ' and '+@where+
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '


execute (@sqlcommand+@sqlcommand2)
END


GO
