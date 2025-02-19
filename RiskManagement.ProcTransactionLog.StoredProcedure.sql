USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcTransactionLog]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [RiskManagement].[ProcTransactionLog]
 @UserId int,
 @TransactionTypeId int,
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


declare @where2 nvarchar(max)=' and 1=1 '

if(@TransactionTypeId<>-1)
	set @where2=' and Log.TransactionLog.TransactionTypeId='+CAST(@TransactionTypeId as nvarchar(5))




--set @sqlcommand='declare @total int '+
--'select @total=COUNT(Log.TransactionLog.TransactionLogId)  '+
--'from Log.TransactionLog INNER JOIN
--Log.SpDescription ON Log.SpDescription.SpDescriptionId=Log.TransactionLog.SpDescriptionId INNER JOIN
--Log.TransactionType ON Log.TransactionType.TransactionTypeId=Log.TransactionLog.TransactionTypeId INNER JOIN
--Users.Users ON Users.Users.UserName=Log.TransactionLog.Username '+
--'WHERE (1 = 1) '+@where2+' '+@where +' ; ' +
--'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
--'Log.TransactionLog.TransactionLogId '+
--',Log.TransactionLog .CreateDate '+
--',Log.TransactionLog.NewValues '+
--',Log.TransactionLog.OldValues '+
--',Log.TransactionLog.RowId '+
--',Log.TransactionLog.SpDescriptionId '+
--',Log.TransactionLog.TableName '+
--',Log.TransactionLog.TransactionTypeId '+
--', Log.SpDescription.SpDescription '+
--', Log.SpDescription.SpName '+
--',Log.TransactionType.TransactionType '+
--',Users.Users.Name+'' ''+Users.Users.Surname + ''(''+Users.Users.UserName+'')'' as Users '+
--'from Log.TransactionLog INNER JOIN
--Log.SpDescription ON Log.SpDescription.SpDescriptionId=Log.TransactionLog.SpDescriptionId INNER JOIN
--Log.TransactionType ON Log.TransactionType.TransactionTypeId=Log.TransactionLog.TransactionTypeId INNER JOIN
--Users.Users ON Users.Users.UserName=Log.TransactionLog.Username   '+
--'WHERE (1 = 1)  '+@where2+' '+@where +
-- ') '+  
--'SELECT *,@total as totalrow '+
--  'FROM OrdersRN '+
-- ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' )'

exec (@sqlcommand)


END




GO
