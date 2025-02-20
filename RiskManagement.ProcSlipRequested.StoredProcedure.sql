USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcSlipRequested]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcSlipRequested] 
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
declare @UserCurrencyId int

select @UserCurrencyId=Users.Users.CurrencyId from Users.Users where Users.Users.UserName=@Username
--declare @total int 

--select @total=COUNT(Customer.Slip.SlipId) 
--FROM         Customer.Customer INNER JOIN
--                      Customer.Slip ON Customer.Customer.CustomerId = Customer.Slip.CustomerId INNER JOIN
--                      Parameter.SlipState ON Customer.Slip.SlipStateId = Parameter.SlipState.StateId INNER JOIN
--                      Parameter.Source ON Customer.Slip.SourceId = Parameter.Source.SourceId INNER JOIN
--                      Parameter.SlipType ON Customer.Slip.SlipTypeId = Parameter.SlipType.Id INNER JOIN
--                      Parameter.Currency ON Customer.Customer.CurrencyId = Parameter.Currency.CurrencyId
--WHERE 1=1 ; 
--WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY Customer.Slip.SlipId) AS RowNum,
--  Customer.Slip.SlipId, Customer.Slip.CustomerId, 
--                      Customer.Customer.CustomerName + ' ' + Customer.Customer.CustomerSurname + ' ( ' + Customer.Customer.Username + ' ) ' AS CustomerName, 
--                      Customer.Slip.Amount, Customer.Slip.TotalOddValue, Parameter.SlipState.StateId, Parameter.SlipState.State, Customer.Slip.CreateDate, Parameter.Source.SourceId, 
--                      Parameter.Source.Source, COUNT(Customer.SlipOdd.SlipOddId) AS OddCount, Parameter.SlipType.SlipType, Customer.Slip.SlipTypeId, 
--                      Parameter.SlipState.StatuColor AS SlipStateStatuColor, Customer.Slip.Amount * Customer.Slip.TotalOddValue AS MaxGain, Parameter.Currency.CurrencyId, 
--                      Parameter.Currency.Currency,Parameter.SlipStatu.SlipStatu,Parameter.SlipStatu.SlipStatuId
--FROM         Customer.Customer INNER JOIN
--                      Customer.Slip ON Customer.Customer.CustomerId = Customer.Slip.CustomerId INNER JOIN
--                      Customer.SlipOdd ON Customer.Slip.SlipId = Customer.SlipOdd.SlipId INNER JOIN
--                      Parameter.SlipState ON Customer.Slip.SlipStateId = Parameter.SlipState.StateId INNER JOIN
--                      Parameter.Source ON Customer.Slip.SourceId = Parameter.Source.SourceId INNER JOIN
--                      Parameter.SlipType ON Customer.Slip.SlipTypeId = Parameter.SlipType.Id INNER JOIN
--                      Parameter.SlipStatu ON Customer.Slip.SlipStatu = Parameter.SlipStatu.SlipStatuId INNER JOIN
--                      Parameter.Currency ON Customer.Customer.CurrencyId = Parameter.Currency.CurrencyId
--WHERE 1=1
--GROUP BY Customer.Slip.SlipId, Customer.Slip.CustomerId, Customer.Customer.CustomerName, Customer.Customer.CustomerSurname, Customer.Customer.Username, 
--                      Customer.Slip.Amount, Customer.Slip.TotalOddValue, Parameter.SlipState.StateId, Parameter.SlipState.State, Customer.Slip.CreateDate, Parameter.Source.SourceId, 
--                      Parameter.Source.Source,Customer.Slip.SlipTypeId, Customer.Slip.SourceId, Parameter.SlipType.SlipType, 
--                      Parameter.SlipState.StatuColor, Parameter.Currency.CurrencyId, Parameter.Currency.Currency,Parameter.SlipStatu.SlipStatu,Parameter.SlipStatu.SlipStatuId
--)  
--SELECT *,@total as totalrow 
--FROM OrdersRN 
--WHERE RowNum BETWEEN ((@PageNum-1 )*(@PageSize))+1 AND (@PageNum * @PageSize ) 





set @sqlcommand='declare @total int '+
'select @total=COUNT(DISTINCT Customer.Slip.SlipId) '+
'FROM         Customer.Customer INNER JOIN
                      Customer.Slip ON Customer.Customer.CustomerId = Customer.Slip.CustomerId INNER JOIN
                      Customer.SlipOdd ON Customer.Slip.SlipId = Customer.SlipOdd.SlipId INNER JOIN
                      Parameter.SlipState ON Customer.Slip.SlipStateId = Parameter.SlipState.StateId INNER JOIN
                      Parameter.Source ON Customer.Slip.SourceId = Parameter.Source.SourceId INNER JOIN
                      Parameter.SlipType ON Customer.Slip.SlipTypeId = Parameter.SlipType.Id INNER JOIN
                       Parameter.SlipStatu ON Customer.Slip.SlipStatu = Parameter.SlipStatu.SlipStatuId INNER JOIN
                      Parameter.Currency ON   Parameter.Currency.CurrencyId ='+cast(@UserCurrencyId as nvarchar(2))+' '+
'WHERE 1=1 and Customer.Slip.SlipStatu in (2,4) and  '+@where +' ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
'  Customer.Slip.SlipId, Customer.Slip.CustomerId, 
                      Customer.Customer.CustomerName + '' '' + Customer.Customer.CustomerSurname + '' ( '' + Customer.Customer.Username + '' ) '' AS CustomerName, 
                      dbo.FuncCurrencyConverter(Customer.Slip.Amount,Customer.Customer.CurrencyId,'+cast(@UserCurrencyId as nvarchar(2))+') as Amount, Customer.Slip.TotalOddValue, Parameter.SlipState.StateId, Parameter.SlipState.State, dbo.UserTimeZoneDate('''+@Username+''',Customer.Slip.CreateDate,0) as CreateDate, Parameter.Source.SourceId, 
                      Parameter.Source.Source, COUNT(Customer.SlipOdd.SlipOddId) AS OddCount, Parameter.SlipType.SlipType, Customer.Slip.SlipTypeId, 
                      Parameter.SlipState.StatuColor AS SlipStateStatuColor,cast(dbo.FuncCurrencyConverter(Customer.Slip.Amount * Customer.Slip.TotalOddValue,Customer.Customer.CurrencyId,'+cast(@UserCurrencyId as nvarchar(2))+') as float) AS MaxGain, Parameter.Currency.CurrencyId, 
                      Parameter.Currency.Currency,Parameter.SlipStatu.SlipStatu,Parameter.SlipStatu.SlipStatuId '+
'FROM         Customer.Customer INNER JOIN
                      Customer.Slip ON Customer.Customer.CustomerId = Customer.Slip.CustomerId INNER JOIN
                      Customer.SlipOdd ON Customer.Slip.SlipId = Customer.SlipOdd.SlipId INNER JOIN
                      Parameter.SlipState ON Customer.Slip.SlipStateId = Parameter.SlipState.StateId INNER JOIN
                      Parameter.Source ON Customer.Slip.SourceId = Parameter.Source.SourceId INNER JOIN
                      Parameter.SlipType ON Customer.Slip.SlipTypeId = Parameter.SlipType.Id INNER JOIN
                       Parameter.SlipStatu ON Customer.Slip.SlipStatu = Parameter.SlipStatu.SlipStatuId INNER JOIN
                      Parameter.Currency ON   Parameter.Currency.CurrencyId ='+cast(@UserCurrencyId as nvarchar(2))+' '+
'WHERE 1=1 and Customer.Slip.SlipStatu in (2,4) and '+@where+
'GROUP BY Customer.Slip.SlipId, Customer.Slip.CustomerId, Customer.Customer.CustomerName, Customer.Customer.CustomerSurname, Customer.Customer.Username, 
                      Customer.Slip.Amount, Customer.Slip.TotalOddValue, Parameter.SlipState.StateId, Parameter.SlipState.State, Customer.Slip.CreateDate, Parameter.Source.SourceId, 
                      Parameter.Source.Source, Customer.Slip.SlipTypeId, Customer.Slip.SourceId, Parameter.SlipType.SlipType, 
                      Parameter.SlipState.StatuColor, Parameter.Currency.CurrencyId, Parameter.Currency.Currency,Customer.Customer.CurrencyId,Parameter.SlipStatu.SlipStatu,Parameter.SlipStatu.SlipStatuId '+
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '

exec (@sqlcommand)
END


GO
