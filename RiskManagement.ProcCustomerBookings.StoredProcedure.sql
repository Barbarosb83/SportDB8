USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCustomerBookings]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcCustomerBookings] 
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
declare @UserCurrencyId int

declare @RoleId int


select top 1  @RoleId=Users.UserRoles.RoleId, @UserCurrencyId=Users.Users.CurrencyId
from Users.Users INNER JOIN Users.UserRoles ON Users.UserRoles.UserId=Users.Users.UserId 
where Users.Users.UserName=@Username



--declare @total int 
--select @total=COUNT(Customer.[Transaction].TransactionId)  
--FROM         Parameter.TransactionType INNER JOIN
--                      Customer.[Transaction] ON Parameter.TransactionType.TransactionTypeId = Customer.[Transaction].TransactionTypeId INNER JOIN
--                      Parameter.TransactionSource ON Customer.[Transaction].TransactionSourceId = Parameter.TransactionSource.TransactionSourceId INNER JOIN
--                      Parameter.Currency ON Customer.[Transaction].CurrencyId = Parameter.Currency.CurrencyId INNER JOIN
--                      Language.[Parameter.TransactionType] ON Parameter.TransactionType.TransactionTypeId = Language.[Parameter.TransactionType].TransactionTypeId
--WHERE     (Customer.[Transaction].CustomerId = @CustomerId)    and  Language.[Parameter.TransactionType].LanguageId=@LangId   ;
--WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY Customer.[Transaction].TransactionId) AS RowNum, 
--    Customer.[Transaction].TransactionDate, Customer.[Transaction].TransactionTypeId, Customer.[Transaction].TransactionComment, Customer.[Transaction].Amount, 
--                      Customer.[Transaction].CurrencyId, Parameter.Currency.Currency, Customer.[Transaction].TransactionId, Customer.[Transaction].CustomerId, 
--                      Language.[Parameter.TransactionType].TransactionType,case when Customer.[Transaction].TransactionId In (1,3,5) THEN 1 ELSE 3 end as statucolor
--FROM         Parameter.TransactionType INNER JOIN
--                      Customer.[Transaction] ON Parameter.TransactionType.TransactionTypeId = Customer.[Transaction].TransactionTypeId INNER JOIN
--                      Parameter.TransactionSource ON Customer.[Transaction].TransactionSourceId = Parameter.TransactionSource.TransactionSourceId INNER JOIN
--                      Parameter.Currency ON Customer.[Transaction].CurrencyId = Parameter.Currency.CurrencyId INNER JOIN
--                      Language.[Parameter.TransactionType] ON Parameter.TransactionType.TransactionTypeId = Language.[Parameter.TransactionType].TransactionTypeId
--WHERE     (Customer.[Transaction].CustomerId = @CustomerId)    and  Language.[Parameter.TransactionType].LanguageId=@LangId  -- and  Parameter.TransactionType.TransactionTypeId =@TypeId     

--)  
--SELECT *,@total as totalrow 
--  FROM OrdersRN 
--  WHERE RowNum BETWEEN (@PageNum-1 )*(@PageSize )+1 AND (@PageNum * @PageSize )


set @orderby='Customer.[Transaction].TransactionId desc'


if(@RoleId<>156)
begin
set @sqlcommand='declare @total int '+
'select @total=COUNT(Customer.[Transaction].TransactionId) '+
'FROM         Parameter.TransactionType with (nolock) INNER JOIN
                      Customer.[Transaction] with (nolock) ON Parameter.TransactionType.TransactionTypeId = Customer.[Transaction].TransactionTypeId INNER JOIN
                      Parameter.TransactionSource with (nolock) ON Customer.[Transaction].TransactionSourceId = Parameter.TransactionSource.TransactionSourceId INNER JOIN
                      Parameter.Currency with (nolock) ON Customer.[Transaction].CurrencyId = Parameter.Currency.CurrencyId INNER JOIN
                      Language.[Parameter.TransactionType] with (nolock) ON Parameter.TransactionType.TransactionTypeId = Language.[Parameter.TransactionType].TransactionTypeId '+
'WHERE     (Customer.[Transaction].CustomerId = '+cast(@CustomerId as nvarchar(10))+' )  and Parameter.TransactionType.TransactionTypeId not in (36,37,38,39,40,41,42,43)   and  Language.[Parameter.TransactionType].LanguageId='+cast(@LangId as nvarchar(3)) + ' and '+@where+ '   ;' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY Customer.[Transaction].TransactionId desc) AS RowNum,  '+
' dbo.UserTimeZoneDate('''+@Username+''',Customer.[Transaction].TransactionDate,0) as TransactionDate, Customer.[Transaction].TransactionTypeId, Customer.[Transaction].TransactionComment,case when Parameter.[TransactionType].Direction=1 THEN case when Customer.[Transaction].TransactionTypeId=4 then -1*ISNULL(Customer.[Transaction].Amount,0) ELSE ISNULL(Customer.[Transaction].Amount,0) end else -1*ISNULL(Customer.[Transaction].Amount,0)  end as Amount, 
                      Customer.[Transaction].CurrencyId, Parameter.Currency.Currency, Customer.[Transaction].TransactionId, Customer.[Transaction].CustomerId, 
                      Language.[Parameter.TransactionType].TransactionType,
					  case when ISNULL(Customer.[Transaction].Amount,0)<2000 then 1 ELSE 3 end  as statucolor, case when Customer.[Transaction].TransactionTypeId=4 or Customer.[Transaction].TransactionTypeId=48  then Substring(TransactionComment, Charindex(''-'', TransactionComment)+1, LEN(TransactionComment)) 
                      else TransactionComment end as SlipId, ISNULL(Customer.[Transaction].TransactionBalance,0) as TransactionBalance '+
'FROM         Parameter.TransactionType with (nolock) INNER JOIN
                      Customer.[Transaction] with (nolock) ON Parameter.TransactionType.TransactionTypeId = Customer.[Transaction].TransactionTypeId INNER JOIN
                      Parameter.TransactionSource with (nolock) ON Customer.[Transaction].TransactionSourceId = Parameter.TransactionSource.TransactionSourceId INNER JOIN
                      Parameter.Currency with (nolock) ON Parameter.Currency.CurrencyId='+cast(@UserCurrencyId as nvarchar(5))+'  INNER JOIN
                      Language.[Parameter.TransactionType] with (nolock) ON Parameter.TransactionType.TransactionTypeId = Language.[Parameter.TransactionType].TransactionTypeId '+
'WHERE    Customer.[Transaction].Amount>0 and  (Customer.[Transaction].CustomerId = '+cast(@CustomerId as nvarchar(10))+') and Parameter.TransactionType.TransactionTypeId not in (36,37,38,39,40,41,42,43)    and  Language.[Parameter.TransactionType].LanguageId='+cast(@LangId as nvarchar(2)) + ' and '+@where+
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '
 end
 else
 begin
 set @sqlcommand='declare @total int '+
'select @total=COUNT(Customer.[Transaction].TransactionId) '+
'FROM         Parameter.TransactionType with (nolock) INNER JOIN
                      Customer.[Transaction] with (nolock) ON Parameter.TransactionType.TransactionTypeId = Customer.[Transaction].TransactionTypeId INNER JOIN
                      Parameter.TransactionSource with (nolock) ON Customer.[Transaction].TransactionSourceId = Parameter.TransactionSource.TransactionSourceId INNER JOIN
                      Parameter.Currency with (nolock) ON Customer.[Transaction].CurrencyId = Parameter.Currency.CurrencyId INNER JOIN
                      Language.[Parameter.TransactionType] with (nolock) ON Parameter.TransactionType.TransactionTypeId = Language.[Parameter.TransactionType].TransactionTypeId '+
'WHERE     (Customer.[Transaction].CustomerId = '+cast(@CustomerId as nvarchar(10))+' )  and Parameter.TransactionType.TransactionTypeId not in (36,37,38,39,40,41,42,43)   and  Language.[Parameter.TransactionType].LanguageId='+cast(@LangId as nvarchar(2)) + ' and '+@where+ '   ;' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY Customer.[Transaction].TransactionId desc) AS RowNum,  '+
' dbo.UserTimeZoneDate('''+@Username+''',Customer.[Transaction].TransactionDate,0) as TransactionDate, Customer.[Transaction].TransactionTypeId, Customer.[Transaction].TransactionComment,case when Parameter.[TransactionType].Direction=1 THEN case when Customer.[Transaction].TransactionTypeId=4 then -1*(ISNULL(Customer.[Transaction].Amount,0)/5) ELSE ISNULL(Customer.[Transaction].Amount ,0)/5 end else -1*(ISNULL(Customer.[Transaction].Amount,0)/5)  end as Amount, 
                      Customer.[Transaction].CurrencyId, Parameter.Currency.Currency, Customer.[Transaction].TransactionId, Customer.[Transaction].CustomerId, 
                      Language.[Parameter.TransactionType].TransactionType,
					  case when Parameter.[TransactionType].Direction=1 THEN case when Customer.[Transaction].TransactionTypeId<>4 then 1 ELSE 3 end Else 3 end as statucolor, case when Customer.[Transaction].TransactionTypeId=4 then Substring(TransactionComment, Charindex(''-'', TransactionComment)+1, LEN(TransactionComment)) 
                      else TransactionComment end as SlipId, Customer.[Transaction].TransactionBalance '+
'FROM         Parameter.TransactionType with (nolock) INNER JOIN
                      Customer.[Transaction] with (nolock) ON Parameter.TransactionType.TransactionTypeId = Customer.[Transaction].TransactionTypeId INNER JOIN
                      Parameter.TransactionSource with (nolock) ON Customer.[Transaction].TransactionSourceId = Parameter.TransactionSource.TransactionSourceId INNER JOIN
                      Parameter.Currency with (nolock) ON Customer.[Transaction].CurrencyId = Parameter.Currency.CurrencyId INNER JOIN
                      Language.[Parameter.TransactionType] with (nolock) ON Parameter.TransactionType.TransactionTypeId = Language.[Parameter.TransactionType].TransactionTypeId '+
'WHERE    Customer.[Transaction].Amount>0 and  (Customer.[Transaction].CustomerId = '+cast(@CustomerId as nvarchar(10))+') and Parameter.TransactionType.TransactionTypeId not in (36,37,38,39,40,41,42,43)    and  Language.[Parameter.TransactionType].LanguageId='+cast(@LangId as nvarchar(2)) + ' and '+@where+
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '
 end

execute (@sqlcommand)

END


GO
