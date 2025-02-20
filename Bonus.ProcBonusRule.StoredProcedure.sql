USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Bonus].[ProcBonusRule]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Bonus].[ProcBonusRule]
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

--SELECT    0 AS totalrow, Bonus.[Rule].BonusRuleId, Bonus.[Rule].BonusTypeId, Bonus.[Rule].BonusName, Bonus.[Rule].GameTypeId, Bonus.[Rule].MaxAmount, Bonus.[Rule].MinAmount, 
--                      Bonus.[Rule].BonusRate, Bonus.[Rule].BonusStartDate, Bonus.[Rule].BonusEndDate, Bonus.[Rule].BonusExpiredDay, Bonus.[Rule].BonusMinOddValue, 
--                      Bonus.[Rule].BonusOccurences, Bonus.[Rule].ForfeitOnWithdraw, Bonus.[Rule].MinCombineCount, Bonus.[Rule].SameOddtypeTwoOdds, 
--                      Parameter.GameType.GameType, Parameter.BonusType.Type, Parameter.BonusType.Description,0 as RuleDaysId,0 as ParameterDayId, 
--                      '' as Days, 0 as CashTypeId,'' as CashType, 0 as RuleCashTypeId
--FROM         Parameter.BonusType INNER JOIN
--                      Bonus.[Rule] ON Parameter.BonusType.BonusTypeId = Bonus.[Rule].BonusTypeId INNER JOIN
--                      Parameter.GameType ON Bonus.[Rule].GameTypeId = Parameter.GameType.GameTypeId 
                      
                      


set @sqlcommand='declare @total int '+
'select @total=COUNT(Bonus.[Rule].BonusRuleId) '+
'FROM         Parameter.BonusType INNER JOIN
                      Bonus.[Rule] ON Parameter.BonusType.BonusTypeId = Bonus.[Rule].BonusTypeId INNER JOIN
                      Parameter.GameType ON Bonus.[Rule].GameTypeId = Parameter.GameType.GameTypeId '+
'WHERE (1 = 1) and '+@where +' ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
'	Bonus.[Rule].BonusRuleId, Bonus.[Rule].BonusTypeId, Bonus.[Rule].BonusName, Bonus.[Rule].GameTypeId, Bonus.[Rule].MaxAmount, Bonus.[Rule].MinAmount, 
                      Bonus.[Rule].BonusRate, Bonus.[Rule].BonusStartDate, Bonus.[Rule].BonusEndDate, Bonus.[Rule].BonusExpiredDay, Bonus.[Rule].BonusMinOddValue, 
                      Bonus.[Rule].BonusOccurences, Bonus.[Rule].ForfeitOnWithdraw, Bonus.[Rule].MinCombineCount, Bonus.[Rule].SameOddtypeTwoOdds, 
                      Parameter.GameType.GameType, Parameter.BonusType.Type, Parameter.BonusType.Description,0 as RuleDaysId,0 as ParameterDayId, 
                      '''' as Days, 0 as CashTypeId,'''' as CashType, 0 as RuleCashTypeId '+
'FROM         Parameter.BonusType INNER JOIN
                      Bonus.[Rule] ON Parameter.BonusType.BonusTypeId = Bonus.[Rule].BonusTypeId INNER JOIN
                      Parameter.GameType ON Bonus.[Rule].GameTypeId = Parameter.GameType.GameTypeId '+
'WHERE (1 = 1) and '+@where +
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '


execute (@sqlcommand) 


END


GO
