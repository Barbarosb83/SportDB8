USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcBookings]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcBookings] 
@CustomerId bigint,
@TypeId int,
@TransDate datetime,
@LangId int
AS

BEGIN
SET NOCOUNT ON;






if(@TypeId=3)
begin




SELECT     Customer.[Transaction].TransactionDate, Customer.[Transaction].TransactionTypeId, '' as TransactionComment, Customer.[Transaction].Amount, 
                      Customer.[Transaction].CurrencyId, Parameter.Currency.Currency, Customer.[Transaction].TransactionId, Customer.[Transaction].CustomerId, 
                      Language.[Parameter.TransactionType].TransactionType,case when Parameter.TransactionType.Direction=1 THEN 'green' ELSE 'red' end as statucolor,Customer.[Transaction].TransactionBalance
FROM         Parameter.TransactionType with (nolock) INNER JOIN
                      Customer.[Transaction] with (nolock) ON Parameter.TransactionType.TransactionTypeId = Customer.[Transaction].TransactionTypeId INNER JOIN
                      Parameter.TransactionSource with (nolock) ON Customer.[Transaction].TransactionSourceId = Parameter.TransactionSource.TransactionSourceId INNER JOIN
                      Parameter.Currency with (nolock) ON Customer.[Transaction].CurrencyId = Parameter.Currency.CurrencyId INNER JOIN
                      Language.[Parameter.TransactionType] with (nolock) ON Parameter.TransactionType.TransactionTypeId = Language.[Parameter.TransactionType].TransactionTypeId
WHERE   (Month(Customer.[Transaction].TransactionDate) = MONTH(@TransDate)) and (Year(Customer.[Transaction].TransactionDate) = Year(@TransDate)) 
and  (Customer.[Transaction].CustomerId = @CustomerId)    and  Language.[Parameter.TransactionType].LanguageId=@LangId  and Parameter.TransactionType.TransactionTypeId=@TypeId
order by Customer.[Transaction].TransactionDate desc
end
else if(@TypeId=4)
begin




SELECT     Customer.[Transaction].TransactionDate, Customer.[Transaction].TransactionTypeId, '' as TransactionComment, Customer.[Transaction].Amount, 
                      Customer.[Transaction].CurrencyId, Parameter.Currency.Currency, Customer.[Transaction].TransactionId, Customer.[Transaction].CustomerId, 
                      Language.[Parameter.TransactionType].TransactionType,case when Parameter.TransactionType.Direction=1 THEN 'green' ELSE 'red' end as statucolor,Customer.[Transaction].TransactionBalance
FROM         Parameter.TransactionType with (nolock) INNER JOIN
                      Customer.[Transaction] with (nolock) ON Parameter.TransactionType.TransactionTypeId = Customer.[Transaction].TransactionTypeId INNER JOIN
                      Parameter.TransactionSource with (nolock) ON Customer.[Transaction].TransactionSourceId = Parameter.TransactionSource.TransactionSourceId INNER JOIN
                      Parameter.Currency with (nolock) ON Customer.[Transaction].CurrencyId = Parameter.Currency.CurrencyId INNER JOIN
                      Language.[Parameter.TransactionType] ON Parameter.TransactionType.TransactionTypeId = Language.[Parameter.TransactionType].TransactionTypeId
WHERE   (Month(Customer.[Transaction].TransactionDate) = MONTH(@TransDate)) and (Year(Customer.[Transaction].TransactionDate) = Year(@TransDate)) and  (Customer.[Transaction].CustomerId = @CustomerId)    and  Language.[Parameter.TransactionType].LanguageId=@LangId  and Parameter.TransactionType.TransactionTypeId=@TypeId
order by Customer.[Transaction].TransactionDate desc
end
else if(@TypeId=33)
begin




SELECT     Customer.[Transaction].TransactionDate, Customer.[Transaction].TransactionTypeId, '' as TransactionComment, Customer.[Transaction].Amount, 
                      Customer.[Transaction].CurrencyId, Parameter.Currency.Currency, Customer.[Transaction].TransactionId, Customer.[Transaction].CustomerId, 
                      Language.[Parameter.TransactionType].TransactionType,case when Parameter.TransactionType.Direction=1 THEN 'green' ELSE 'red' end as statucolor,Customer.[Transaction].TransactionBalance
FROM         Parameter.TransactionType with (nolock) INNER JOIN
                      Customer.[Transaction] with (nolock) ON Parameter.TransactionType.TransactionTypeId = Customer.[Transaction].TransactionTypeId INNER JOIN
                      Parameter.TransactionSource with (nolock) ON Customer.[Transaction].TransactionSourceId = Parameter.TransactionSource.TransactionSourceId INNER JOIN
                      Parameter.Currency with (nolock) ON Customer.[Transaction].CurrencyId = Parameter.Currency.CurrencyId INNER JOIN
                      Language.[Parameter.TransactionType] with (nolock) ON Parameter.TransactionType.TransactionTypeId = Language.[Parameter.TransactionType].TransactionTypeId
WHERE   (Month(Customer.[Transaction].TransactionDate) = MONTH(@TransDate)) and (Year(Customer.[Transaction].TransactionDate) = Year(@TransDate)) and  (Customer.[Transaction].CustomerId = @CustomerId)    and  Language.[Parameter.TransactionType].LanguageId=@LangId  and Parameter.TransactionType.TransactionTypeId=@TypeId
order by Customer.[Transaction].TransactionDate desc
end
else if(@TypeId=34)
begin




SELECT     Customer.[Transaction].TransactionDate, Customer.[Transaction].TransactionTypeId, Customer.[Transaction].TransactionComment as TransactionComment, Customer.[Transaction].Amount, 
                      Customer.[Transaction].CurrencyId, Parameter.Currency.Currency, Customer.[Transaction].TransactionId, Customer.[Transaction].CustomerId, 
                      Language.[Parameter.TransactionType].TransactionType,case when Parameter.TransactionType.Direction=1 THEN 'green' ELSE 'red' end as statucolor,Customer.[Transaction].TransactionBalance
FROM         Parameter.TransactionType with (nolock) INNER JOIN
                      Customer.[Transaction] with (nolock) ON Parameter.TransactionType.TransactionTypeId = Customer.[Transaction].TransactionTypeId INNER JOIN
                      Parameter.TransactionSource with (nolock) ON Customer.[Transaction].TransactionSourceId = Parameter.TransactionSource.TransactionSourceId INNER JOIN
                      Parameter.Currency with (nolock) ON Customer.[Transaction].CurrencyId = Parameter.Currency.CurrencyId INNER JOIN
                      Language.[Parameter.TransactionType] with (nolock) ON Parameter.TransactionType.TransactionTypeId = Language.[Parameter.TransactionType].TransactionTypeId
WHERE   (Month(Customer.[Transaction].TransactionDate) = MONTH(@TransDate)) and (Year(Customer.[Transaction].TransactionDate) = Year(@TransDate)) and  (Customer.[Transaction].CustomerId = @CustomerId)    and  Language.[Parameter.TransactionType].LanguageId=@LangId  and Parameter.TransactionType.TransactionTypeId=@TypeId
order by Customer.[Transaction].TransactionDate desc
end
else if(@TypeId=35)
begin




SELECT     Customer.[Transaction].TransactionDate, Customer.[Transaction].TransactionTypeId, '' as TransactionComment, Customer.[Transaction].Amount, 
                      Customer.[Transaction].CurrencyId, Parameter.Currency.Currency, Customer.[Transaction].TransactionId, Customer.[Transaction].CustomerId, 
                      Language.[Parameter.TransactionType].TransactionType,case when Parameter.TransactionType.Direction=1 THEN 'green' ELSE 'red' end as statucolor,Customer.[Transaction].TransactionBalance
FROM         Parameter.TransactionType with (nolock) INNER JOIN
                      Customer.[Transaction] with (nolock) ON Parameter.TransactionType.TransactionTypeId = Customer.[Transaction].TransactionTypeId INNER JOIN
                      Parameter.TransactionSource with (nolock) ON Customer.[Transaction].TransactionSourceId = Parameter.TransactionSource.TransactionSourceId INNER JOIN
                      Parameter.Currency with (nolock) ON Customer.[Transaction].CurrencyId = Parameter.Currency.CurrencyId INNER JOIN
                      Language.[Parameter.TransactionType] ON Parameter.TransactionType.TransactionTypeId = Language.[Parameter.TransactionType].TransactionTypeId
WHERE   (Month(Customer.[Transaction].TransactionDate) = MONTH(@TransDate)) and (Year(Customer.[Transaction].TransactionDate) = Year(@TransDate)) and  (Customer.[Transaction].CustomerId = @CustomerId)    and  Language.[Parameter.TransactionType].LanguageId=@LangId  and Parameter.TransactionType.TransactionTypeId in (35,75)
order by Customer.[Transaction].TransactionDate desc
end
else if(@TypeId=1)
begin

SELECT     Customer.[Transaction].TransactionDate, Customer.[Transaction].TransactionTypeId, '' as TransactionComment, Customer.[Transaction].Amount, 
                      Customer.[Transaction].CurrencyId, Parameter.Currency.Currency, Customer.[Transaction].TransactionId, Customer.[Transaction].CustomerId, 
                      Language.[Parameter.TransactionType].TransactionType,case when Parameter.TransactionType.Direction=1 THEN 'green' ELSE 'red' end as statucolor,Customer.[Transaction].TransactionBalance
FROM         Parameter.TransactionType with (nolock) INNER JOIN
                      Customer.[Transaction] with (nolock) ON Parameter.TransactionType.TransactionTypeId = Customer.[Transaction].TransactionTypeId INNER JOIN
                      Parameter.TransactionSource with (nolock) ON Customer.[Transaction].TransactionSourceId = Parameter.TransactionSource.TransactionSourceId INNER JOIN
                      Parameter.Currency with (nolock) ON Customer.[Transaction].CurrencyId = Parameter.Currency.CurrencyId INNER JOIN
                      Language.[Parameter.TransactionType] with (nolock) ON Parameter.TransactionType.TransactionTypeId = Language.[Parameter.TransactionType].TransactionTypeId
WHERE    (Month(Customer.[Transaction].TransactionDate) = MONTH(@TransDate)) and (Year(Customer.[Transaction].TransactionDate) = Year(@TransDate)) and (Customer.[Transaction].CustomerId = @CustomerId)   
 and  Language.[Parameter.TransactionType].LanguageId=@LangId   and  Parameter.TransactionType.TransactionTypeId in (1,7,30,32,27,35,64,46,67,68,69,70,71,72,74,75)     
order by Customer.[Transaction].TransactionDate desc
end

else if(@TypeId=2)
begin

SELECT     Customer.[Transaction].TransactionDate, Customer.[Transaction].TransactionTypeId, '' as TransactionComment, Customer.[Transaction].Amount, 
                      Customer.[Transaction].CurrencyId, Parameter.Currency.Currency, Customer.[Transaction].TransactionId, Customer.[Transaction].CustomerId, 
                      Language.[Parameter.TransactionType].TransactionType,case when Parameter.TransactionType.Direction=1 THEN 'green' ELSE 'red' end as statucolor,Customer.[Transaction].TransactionBalance
FROM         Parameter.TransactionType with (nolock) INNER JOIN
                      Customer.[Transaction] with (nolock) ON Parameter.TransactionType.TransactionTypeId = Customer.[Transaction].TransactionTypeId INNER JOIN
                      Parameter.TransactionSource with (nolock) ON Customer.[Transaction].TransactionSourceId = Parameter.TransactionSource.TransactionSourceId INNER JOIN
                      Parameter.Currency with (nolock) ON Customer.[Transaction].CurrencyId = Parameter.Currency.CurrencyId INNER JOIN
                      Language.[Parameter.TransactionType] with (nolock) ON Parameter.TransactionType.TransactionTypeId = Language.[Parameter.TransactionType].TransactionTypeId
WHERE    (Month(Customer.[Transaction].TransactionDate) = MONTH(@TransDate)) and (Year(Customer.[Transaction].TransactionDate) = Year(@TransDate)) 
and (Customer.[Transaction].CustomerId = @CustomerId)    and  Language.[Parameter.TransactionType].LanguageId=@LangId  
 and  Parameter.TransactionType.TransactionTypeId in (2,31,65,66,73,12)     
order by Customer.[Transaction].TransactionDate desc
end
else if(@TypeId=0)
begin

SELECT   top 50  Customer.[Transaction].TransactionDate, Customer.[Transaction].TransactionTypeId, '' as TransactionComment, Customer.[Transaction].Amount, 
                      Customer.[Transaction].CurrencyId, Parameter.Currency.Currency, Customer.[Transaction].TransactionId, Customer.[Transaction].CustomerId, 
                      Language.[Parameter.TransactionType].TransactionType,case when Parameter.TransactionType.Direction=1 THEN 'green' ELSE 'red' end as statucolor,Customer.[Transaction].TransactionBalance
FROM         Parameter.TransactionType with (nolock) INNER JOIN
                      Customer.[Transaction] with (nolock) ON Parameter.TransactionType.TransactionTypeId = Customer.[Transaction].TransactionTypeId INNER JOIN
                      Parameter.TransactionSource with (nolock) ON Customer.[Transaction].TransactionSourceId = Parameter.TransactionSource.TransactionSourceId INNER JOIN
                      Parameter.Currency with (nolock) ON Customer.[Transaction].CurrencyId = Parameter.Currency.CurrencyId INNER JOIN
                      Language.[Parameter.TransactionType] ON Parameter.TransactionType.TransactionTypeId = Language.[Parameter.TransactionType].TransactionTypeId
WHERE     (Month(Customer.[Transaction].TransactionDate) = MONTH(@TransDate)) and (Year(Customer.[Transaction].TransactionDate) = Year(@TransDate))  and
 (Customer.[Transaction].CustomerId = @CustomerId)   
 and  Language.[Parameter.TransactionType].LanguageId=@LangId   
 and  Parameter.TransactionType.TransactionTypeId in (1,11,7,9,30,32,27,2,31,35,4,3,64,63,65,46,66,67,68,69,70,71,72,73,12,74,75)     
order by Customer.[Transaction].TransactionDate desc
end
else if(@TypeId=5) --All In
begin

SELECT   top 50  Customer.[Transaction].TransactionDate, Customer.[Transaction].TransactionTypeId, '' as TransactionComment, Customer.[Transaction].Amount, 
                      Customer.[Transaction].CurrencyId, Parameter.Currency.Currency, Customer.[Transaction].TransactionId, Customer.[Transaction].CustomerId, 
                      Language.[Parameter.TransactionType].TransactionType,case when Parameter.TransactionType.Direction=1 THEN 'green' ELSE 'red' end as statucolor,Customer.[Transaction].TransactionBalance
FROM         Parameter.TransactionType with (nolock) INNER JOIN
                      Customer.[Transaction] with (nolock) ON Parameter.TransactionType.TransactionTypeId = Customer.[Transaction].TransactionTypeId INNER JOIN
                      Parameter.TransactionSource with (nolock) ON Customer.[Transaction].TransactionSourceId = Parameter.TransactionSource.TransactionSourceId INNER JOIN
                      Parameter.Currency with (nolock) ON Customer.[Transaction].CurrencyId = Parameter.Currency.CurrencyId INNER JOIN
                      Language.[Parameter.TransactionType] ON Parameter.TransactionType.TransactionTypeId = Language.[Parameter.TransactionType].TransactionTypeId
WHERE    (Month(Customer.[Transaction].TransactionDate) = MONTH(@TransDate)) and (Year(Customer.[Transaction].TransactionDate) = Year(@TransDate))  and
 (Customer.[Transaction].CustomerId = @CustomerId)   
 and  Language.[Parameter.TransactionType].LanguageId=@LangId   
 and  Parameter.TransactionType.TransactionTypeId in (1,7,9,11,30,32,27,35,3,64,63,46,67,68,69,70,71,72,74,75)     
order by Customer.[Transaction].TransactionDate desc
end
else if(@TypeId=6) --All out
begin

SELECT   top 50  Customer.[Transaction].TransactionDate, Customer.[Transaction].TransactionTypeId, '' as TransactionComment, Customer.[Transaction].Amount, 
                      Customer.[Transaction].CurrencyId, Parameter.Currency.Currency, Customer.[Transaction].TransactionId, Customer.[Transaction].CustomerId, 
                      Language.[Parameter.TransactionType].TransactionType,case when Parameter.TransactionType.Direction=1 THEN 'green' ELSE 'red' end as statucolor,Customer.[Transaction].TransactionBalance
FROM         Parameter.TransactionType with (nolock) INNER JOIN
                      Customer.[Transaction] with (nolock) ON Parameter.TransactionType.TransactionTypeId = Customer.[Transaction].TransactionTypeId INNER JOIN
                      Parameter.TransactionSource with (nolock) ON Customer.[Transaction].TransactionSourceId = Parameter.TransactionSource.TransactionSourceId INNER JOIN
                      Parameter.Currency with (nolock) ON Customer.[Transaction].CurrencyId = Parameter.Currency.CurrencyId INNER JOIN
                      Language.[Parameter.TransactionType] ON Parameter.TransactionType.TransactionTypeId = Language.[Parameter.TransactionType].TransactionTypeId
WHERE    (Month(Customer.[Transaction].TransactionDate) = MONTH(@TransDate)) and (Year(Customer.[Transaction].TransactionDate) = Year(@TransDate))  and
 (Customer.[Transaction].CustomerId = @CustomerId)   
 and  Language.[Parameter.TransactionType].LanguageId=@LangId   
 and  Parameter.TransactionType.TransactionTypeId in (2,4,12,31,65,66,73)     
order by Customer.[Transaction].TransactionDate desc
end


else  if (@TypeId=-10)
begin

SELECT   top 50  Customer.[Transaction].TransactionDate, Customer.[Transaction].TransactionTypeId, Customer.[Transaction].TransactionComment as TransactionComment, Customer.[Transaction].Amount, 
                      Customer.[Transaction].CurrencyId, Parameter.Currency.Currency, Customer.[Transaction].TransactionId, Customer.[Transaction].CustomerId, 
                      Language.[Parameter.TransactionType].TransactionType,case when Parameter.TransactionType.Direction=1 THEN 'green' ELSE 'red' end as statucolor,Customer.[Transaction].TransactionBalance
FROM         Parameter.TransactionType with (nolock) INNER JOIN
                      Customer.[Transaction] with (nolock) ON Parameter.TransactionType.TransactionTypeId = Customer.[Transaction].TransactionTypeId INNER JOIN
                      Parameter.TransactionSource with (nolock) ON Customer.[Transaction].TransactionSourceId = Parameter.TransactionSource.TransactionSourceId INNER JOIN
                      Parameter.Currency  with (nolock) ON Customer.[Transaction].CurrencyId = Parameter.Currency.CurrencyId INNER JOIN
                      Language.[Parameter.TransactionType] ON Parameter.TransactionType.TransactionTypeId = Language.[Parameter.TransactionType].TransactionTypeId
WHERE     (cast(Customer.[Transaction].TransactionDate as Date) >= cast(@TransDate as date)) and
 (Customer.[Transaction].CustomerId = @CustomerId)   
 and  Language.[Parameter.TransactionType].LanguageId=@LangId   
 and     Customer.[Transaction].Amount>0
order by Customer.[Transaction].TransactionDate desc
end
else  if (@TypeId=-20) --Terminal para yatırma çekme
begin

SELECT   top 50  Customer.[Transaction].TransactionDate, Customer.[Transaction].TransactionTypeId, Customer.[Transaction].TransactionComment as TransactionComment, Customer.[Transaction].Amount, 
                      Customer.[Transaction].CurrencyId, Parameter.Currency.Currency, Customer.[Transaction].TransactionId, Customer.[Transaction].CustomerId, 
                      Language.[Parameter.TransactionType].TransactionType,case when Parameter.TransactionType.Direction=1 THEN 'green' ELSE 'red' end as statucolor,Customer.[Transaction].TransactionBalance
FROM         Parameter.TransactionType with (nolock)  INNER JOIN
                      Customer.[Transaction] with (nolock) ON Parameter.TransactionType.TransactionTypeId = Customer.[Transaction].TransactionTypeId INNER JOIN
                      Parameter.TransactionSource with (nolock) ON Customer.[Transaction].TransactionSourceId = Parameter.TransactionSource.TransactionSourceId INNER JOIN
                      Parameter.Currency with (nolock) ON Customer.[Transaction].CurrencyId = Parameter.Currency.CurrencyId INNER JOIN
                      Language.[Parameter.TransactionType] with (nolock) ON Parameter.TransactionType.TransactionTypeId = Language.[Parameter.TransactionType].TransactionTypeId
WHERE     (cast(Customer.[Transaction].TransactionDate as Date) >= cast(@TransDate as date)) and
 (Customer.[Transaction].CustomerId = @CustomerId)   
 and  Language.[Parameter.TransactionType].LanguageId=@LangId   
 and     Customer.[Transaction].Amount>0
  and  Parameter.TransactionType.TransactionTypeId in (1,7,9,11,30,32,27,2,31,35,64,65,46,66,75)  
order by Customer.[Transaction].TransactionDate desc
end
else  if (@TypeId=-30) --Terminal para yatırma çekme
begin

SELECT    Customer.[Transaction].TransactionDate, Customer.[Transaction].TransactionTypeId, Customer.[Transaction].TransactionComment as TransactionComment, Customer.[Transaction].Amount, 
                      Customer.[Transaction].CurrencyId, Parameter.Currency.Currency, Customer.[Transaction].TransactionId, Customer.[Transaction].CustomerId, 
                      Language.[Parameter.TransactionType].TransactionType,case when Parameter.TransactionType.Direction=1 THEN 'green' ELSE 'red' end as statucolor,Customer.[Transaction].TransactionBalance
FROM         Parameter.TransactionType with (nolock) INNER JOIN
                      Customer.[Transaction] with (nolock) ON Parameter.TransactionType.TransactionTypeId = Customer.[Transaction].TransactionTypeId INNER JOIN
                      Parameter.TransactionSource with (nolock) ON Customer.[Transaction].TransactionSourceId = Parameter.TransactionSource.TransactionSourceId INNER JOIN
                      Parameter.Currency with (nolock) ON Customer.[Transaction].CurrencyId = Parameter.Currency.CurrencyId INNER JOIN
                      Language.[Parameter.TransactionType] with (nolock) ON Parameter.TransactionType.TransactionTypeId = Language.[Parameter.TransactionType].TransactionTypeId
WHERE    
 (Customer.[Transaction].CustomerId = @CustomerId)   
 and  Language.[Parameter.TransactionType].LanguageId=@LangId   
 and     Customer.[Transaction].Amount>0
  
order by Customer.[Transaction].TransactionDate desc
end
else 
begin

SELECT   top 50  Customer.[Transaction].TransactionDate, Customer.[Transaction].TransactionTypeId, Customer.[Transaction].TransactionComment as TransactionComment, Customer.[Transaction].Amount, 
                      Customer.[Transaction].CurrencyId, Parameter.Currency.Currency, Customer.[Transaction].TransactionId, Customer.[Transaction].CustomerId, 
                      Language.[Parameter.TransactionType].TransactionType,case when Parameter.TransactionType.Direction=1 THEN 'green' ELSE 'red' end as statucolor,Customer.[Transaction].TransactionBalance
FROM         Parameter.TransactionType with (nolock) INNER JOIN
                      Customer.[Transaction] with (nolock) ON Parameter.TransactionType.TransactionTypeId = Customer.[Transaction].TransactionTypeId INNER JOIN
                      Parameter.TransactionSource with (nolock) ON Customer.[Transaction].TransactionSourceId = Parameter.TransactionSource.TransactionSourceId INNER JOIN
                      Parameter.Currency with (nolock) ON Customer.[Transaction].CurrencyId = Parameter.Currency.CurrencyId INNER JOIN
                      Language.[Parameter.TransactionType] with (nolock) ON Parameter.TransactionType.TransactionTypeId = Language.[Parameter.TransactionType].TransactionTypeId
WHERE    (Month(Customer.[Transaction].TransactionDate) = MONTH(@TransDate)) and (Year(Customer.[Transaction].TransactionDate) = Year(@TransDate)) and
 (Customer.[Transaction].CustomerId = @CustomerId)   
 and  Language.[Parameter.TransactionType].LanguageId=@LangId   
 and  Parameter.TransactionType.TransactionTypeId =@TypeId   and  Customer.[Transaction].Amount>0
order by Customer.[Transaction].TransactionDate desc
end

END


GO
