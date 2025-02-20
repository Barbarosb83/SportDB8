USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcNews]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcNews] 
 @PageSize  INT,
 @PageNum int,
@Username nvarchar(50),
@where nvarchar(1000),
@orderby nvarchar(100)
AS

BEGIN
SET NOCOUNT ON;


declare @sqlcommand nvarchar(max)
declare @sqlcommand2 nvarchar(max)

--declare @total int 

--select @total=COUNT(RiskManagement.News.NewsId) 
--FROM        RiskManagement.News INNER JOIN Users.Users On Users.UserId=RiskManagement.News.CreateUserId INNER JOIN Language.Language On Language.Language.LanguageId=RiskManagement.News.LangId
--WHERE     1=1 ; 
--WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY RiskManagement.News.NewsId) AS RowNum,
--  RiskManagement.News.NewsId,RiskManagement.News.News,RiskManagement.News.CreateDate,RiskManagement.News.EndDate,
--  RiskManagement.News.CreateUserId,RiskManagement.News.IsActive,RiskManagement.News.IsBranchView,RiskManagement.News.IsTerminalView,RiskManagement.News.IsTvView,RiskManagement.News.IsWebView,
--  RiskManagement.News.LangId,RiskManagement.News.StartDate,Users.Users.Name+''+Users.Users.Surname+'('+Users.Users.UserName+')' as UsersName,Language.Language.Language
--FROM        RiskManagement.News INNER JOIN Users.Users On Users.UserId=RiskManagement.News.CreateUserId INNER JOIN Language.Language On Language.Language.LanguageId=RiskManagement.News.LangId
--WHERE   1=1
--)  
--SELECT *,@total as totalrow 
--FROM OrdersRN 
--WHERE RowNum BETWEEN ((@PageNum-1 )*(@PageSize))+1 AND (@PageNum * @PageSize ) 





set @sqlcommand='declare @total int '+
'select @total=COUNT(RiskManagement.News.NewsId)  '+
'FROM      RiskManagement.News INNER JOIN Users.Users On Users.UserId=RiskManagement.News.CreateUserId INNER JOIN Language.Language On Language.Language.LanguageId=RiskManagement.News.LangId
WHERE     1=1 and '+@where +' ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
'  RiskManagement.News.NewsId,RiskManagement.News.News,RiskManagement.News.CreateDate,RiskManagement.News.EndDate,
  RiskManagement.News.CreateUserId,RiskManagement.News.IsActive,RiskManagement.News.IsBranchView,RiskManagement.News.IsTerminalView,RiskManagement.News.IsTvView,RiskManagement.News.IsWebView,
  RiskManagement.News.LangId,RiskManagement.News.StartDate,Users.Users.Name+''''+Users.Users.Surname+''(''+Users.Users.UserName+'')'' as UsersName,Language.Language.Language
FROM           RiskManagement.News INNER JOIN Users.Users On Users.UserId=RiskManagement.News.CreateUserId INNER JOIN Language.Language On Language.Language.LanguageId=RiskManagement.News.LangId
WHERE   1=1 and '+@where +' '+
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '


execute (@sqlcommand)
END



GO
