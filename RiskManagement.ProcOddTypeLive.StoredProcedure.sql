USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcOddTypeLive]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [RiskManagement].[ProcOddTypeLive]
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
--select @total=COUNT(Live.[Parameter.OddType].OddTypeId) 
--      FROM        Live.[Parameter.OddType]               
--WHERE (1 = 1)  ; 
--WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY Live.[Parameter.OddType].OddTypeId) AS RowNum, 
--Live.[Parameter.OddType].OddTypeId as OddsTypeId, Live.[Parameter.OddType].OddType as OddsType, Live.[Parameter.OddType].OutcomesDescription as OutcomesDescription, 
--                     Live.[Parameter.OddType].IsActive, Live.[Parameter.OddType].ShortSign, Live.[Parameter.OddType].IsPopular
--FROM        Live.[Parameter.OddType] 
--WHERE (1 = 1) 
--)   
--SELECT *,@total as totalrow 
-- FROM OrdersRN 


set @sqlcommand='declare @total int '+
'select @total=COUNT(Live.[Parameter.OddType].OddTypeId)  '+
'FROM          Live.[Parameter.OddType] '+
'WHERE (1 = 1) '+@where +' ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
'Live.[Parameter.OddType].OddTypeId as OddsTypeId, Live.[Parameter.OddType].OddType as OddsType, Live.[Parameter.OddType].OutcomesDescription as OutcomesDescription, 
    Live.[Parameter.OddType].IsActive, Live.[Parameter.OddType].ShortSign, Live.[Parameter.OddType].IsPopular,ISNULL(Live.[Parameter.OddType].SeqNumber ,999) as SeqNumber '+
'FROM        Live.[Parameter.OddType]  '+
'WHERE (1 = 1) '+@where +
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' )'

execute (@sqlcommand)


END



GO
