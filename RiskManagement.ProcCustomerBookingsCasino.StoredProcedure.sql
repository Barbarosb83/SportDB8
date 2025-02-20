USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCustomerBookingsCasino]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [RiskManagement].[ProcCustomerBookingsCasino] 
@CustomerId bigint,
@TypeId int,
@TransDate datetime,
@LangId int,
 @PageSize  INT,
 @PageNum int,
@Username nvarchar(50),
@where nvarchar(1000),
@orderby nvarchar(100)
AS

BEGIN
SET NOCOUNT ON;
declare @sqlcommand nvarchar(max)
declare @sqlcommand0 nvarchar(max)
declare @sqlcommand1 nvarchar(max)
declare @sqlcommand2 nvarchar(max)
declare @sqlcommand3 nvarchar(max)
declare @UserCurrencyId int

select @UserCurrencyId=Users.Users.CurrencyId from Users.Users where Users.Users.UserName=@Username




--declare @total int 
--select @total=COUNT(Customer.[Transaction].TransactionId)  
--FROM         Parameter.TransactionType INNER JOIN
--                      Customer.[Transaction] ON Parameter.TransactionType.TransactionTypeId = Customer.[Transaction].TransactionTypeId INNER JOIN
--                      Parameter.TransactionSource ON Customer.[Transaction].TransactionSourceId = Parameter.TransactionSource.TransactionSourceId INNER JOIN
--                      Parameter.Currency ON Customer.[Transaction].CurrencyId = Parameter.Currency.CurrencyId INNER JOIN
--                      Language.[Parameter.TransactionType] ON Parameter.TransactionType.TransactionTypeId = Language.[Parameter.TransactionType].TransactionTypeId
--WHERE     (Customer.[Transaction].CustomerId = @CustomerId)    and  Language.[Parameter.TransactionType].LanguageId=@LangId   ;
--WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY Customer.[Transaction].TransactionId) AS RowNum, 
--   cast(Customer.[Transaction].TransactionDate as date) as TransactionDate, Customer.[Transaction].TransactionTypeId, case when Parameter.[TransactionType].Direction=1 THEN ISNULL(dbo.FuncCurrencyConverter(Customer.[Transaction].Amount,Customer.[Transaction].CurrencyId,71) ,0)  ELSE -1*ISNULL(dbo.FuncCurrencyConverter(Customer.[Transaction].Amount,Customer.[Transaction].CurrencyId,71) ,0)  end as Amount, 
--                      Customer.[Transaction].CurrencyId, Parameter.Currency.Currency,  Customer.[Transaction].CustomerId, 
--                      Language.[Parameter.TransactionType].TransactionType,
--					  case when Parameter.[TransactionType].Direction=1 THEN  1 ELSE 3 end as statucolor
--FROM         Parameter.TransactionType INNER JOIN
--                      Customer.[Transaction] ON Parameter.TransactionType.TransactionTypeId = Customer.[Transaction].TransactionTypeId INNER JOIN
--                      Parameter.TransactionSource ON Customer.[Transaction].TransactionSourceId = Parameter.TransactionSource.TransactionSourceId INNER JOIN
--                      Parameter.Currency ON Customer.[Transaction].CurrencyId = Parameter.Currency.CurrencyId INNER JOIN
--                      Language.[Parameter.TransactionType] ON Parameter.TransactionType.TransactionTypeId = Language.[Parameter.TransactionType].TransactionTypeId
--WHERE     (Customer.[Transaction].CustomerId = @CustomerId) and  Parameter.TransactionType.TransactionTypeId in (36,37,38,39,40,41,42,43)     and  Language.[Parameter.TransactionType].LanguageId=@LangId  -- and  Parameter.TransactionType.TransactionTypeId =@TypeId     


--)  
--SELECT  NEWID() as ID,TransactionDate,TransactionTypeId,SUM(Amount) as Amount,CurrencyId,Currency,CustomerId,TransactionType,statucolor,@total as totalrow 
--  FROM OrdersRN 
--  WHERE @@ROWCOUNT BETWEEN (@PageNum-1 )*(@PageSize )+1 AND (@PageNum * @PageSize )
--  GROUP BY TransactionDate,TransactionTypeId,CurrencyId,Currency,CustomerId,TransactionType,statucolor 
  
  set @sqlcommand0='declare @temptable table (TransactionDate date,TransactionTypeId int,Amount money,Direction int,CurrencyId int,Currency nvarchar(20),CustomerId bigint,TransactionType nvarchar(30))'

   set @sqlcommand1= 'insert @temptable '+
  ' select casT(Customer.[Transaction].TransactionDate as date) as TransactionDate, Customer.[Transaction].TransactionTypeId, '+
   ' Customer.[Transaction].Amount , Parameter.[TransactionType].Direction, '+
                      ' Customer.[Transaction].CurrencyId, Parameter.Currency.Currency,  Customer.[Transaction].CustomerId, '+
                      ' Language.[Parameter.TransactionType].TransactionType '+
'FROM         Parameter.TransactionType with (nolock) INNER JOIN '+
                      'Customer.[Transaction] with (nolock) ON Parameter.TransactionType.TransactionTypeId = Customer.[Transaction].TransactionTypeId INNER JOIN '+
                      'Parameter.TransactionSource with (nolock) ON Customer.[Transaction].TransactionSourceId = Parameter.TransactionSource.TransactionSourceId INNER JOIN '+
                      'Parameter.Currency with (nolock) ON Parameter.Currency.CurrencyId='+cast(@UserCurrencyId as nvarchar(5))+' INNER JOIN '+
                      'Language.[Parameter.TransactionType] with (nolock) ON Parameter.TransactionType.TransactionTypeId = Language.[Parameter.TransactionType].TransactionTypeId '+
'WHERE     (Customer.[Transaction].CustomerId = '+cast(@CustomerId as nvarchar(10))+') and Parameter.TransactionType.TransactionTypeId in (36,37,38,39,40,41,42,43)    and  Language.[Parameter.TransactionType].LanguageId='+cast(@LangId as nvarchar(2)) + ' '+
 'and Amount<>0 '


 set @sqlcommand='declare @temptable2 table (TransactionDate date,TransactionTypeId int,Amount money,CurrencyId int,Currency nvarchar(20),CustomerId bigint,TransactionType nvarchar(30),statucolor int)'


set @sqlcommand2='insert @temptable2 '+
'SELECT  TransactionDate,TransactionTypeId,case when  Direction=1 '+
'THEN ISNULL( SUM(Amount) ,0)  
ELSE -1*ISNULL(SUM(Amount) ,0)  end as Amount,
CurrencyId,Currency,CustomerId,TransactionType,case when  Direction=1 then 1 else 3 end as statucolor '+
  'FROM @temptable '+
 ' GROUP BY TransactionDate,TransactionTypeId,CurrencyId,Currency,CustomerId,TransactionType,Direction' +
 ' Order by '+@orderby+' '


 --set @sqlcommand3=' SELECT NEWID() as ID,TransactionDate,TransactionTypeId,Amount,CurrencyId,Currency,CustomerId,statucolor,TransactionType,@@ROWCOUNT as totalrow'+
 --' From @temptable2'+
 -- ' WHERE @@ROWCOUNT BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) ' 


  
set @sqlcommand3='declare @total int '+
'select @total=COUNT(TransactionDate) '+
'FROM         @temptable2 '+
'; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
' NEWID() as ID,TransactionDate,TransactionTypeId,Amount,CurrencyId,Currency,CustomerId,statucolor,TransactionType'+
 ' FROM  @temptable2 '+
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '


 execute (@sqlcommand0+@sqlcommand1+@sqlcommand+@sqlcommand2+@sqlcommand3)

END


GO
